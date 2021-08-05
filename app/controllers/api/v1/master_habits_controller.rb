class Api::V1::MasterHabitsController < Api::V1::BaseController
  before_action :find_master_habit, only: %i[show update destroy]

  def index
    @master_habits = MasterHabit.all
  end

  def show; end

  def create
    @master_habit = MasterHabit.new(master_habit_params)
    if @master_habit.save
      new_frequency_logic(@master_habit)
      render json: @master_habit
    else
      puts "hi hi hi hi #{@master_habit}"
      puts @master_habit.errors
      render_error
    end
  end

  def update
    if @master_habit.update(master_habit_params)
      delete_habits(@master_habit)
      update_frequency_logic(@master_habit)
      render json: @master_habit
    else
      render_error
    end
  end

  def destroy
    @master_habit.destroy
  end

  def show_user_master_habits
    @user = User.find(params[:user_id])
    @master_habits = MasterHabit.where("user_id = #{params[:user_id]}")
  end

  def analytics
    @habits = Habit.where("master_habit_id = #{params[:master_habit_id]}").order("due_date")
    @habit_weeks = @habits.map { |habit| habit.week }.uniq!
    @weeks = []
    date = Date.today
    @habit_weeks.each do |week|
      week_stats = []
      week_habits = @habits.where("week = #{week}")
      @date = Date.today
      if week_habits.first.due_date.strftime("%B") == @date.strftime("%B")
        this_week = "#{week_habits.first.due_date.beginning_of_week.strftime('%b-%d')} to #{week_habits.first.due_date.end_of_week.strftime('%b-%d')}: "
        percent_complete = (date < week_habits.first.due_date.beginning_of_week ? "Not yet started" : "#{week_habits.first.weekly_percent_complete || 0}% complete")
        week_stats << this_week
        week_stats << week_habits
        week_stats << week_habits.first.weekly_percent_complete
        @weeks << week_stats
      end
    end
    @last_four_weeks = @weeks[-4..-1]
  end

  private

  def master_habit_params
    params.require(:master_habit).permit(:name, :start_date, :end_date, :user_id, :frequency_options => [])
  end

  def find_master_habit
    @master_habit = MasterHabit.find(params[:id])
  end

  def render_error
    render json: { errors: @master_habit.errors.full_messages },
      status: :unprocessable_entity
  end

###################### Generating a new master_habit route ######################
  def new_frequency_logic(m)
    case m.frequency_options[0]
    when "Daily"
      generate_daily_habits(m, m.start_date)
    when "Weekly"
      all_dates = find_times(m, m.start_date)
      generate_weekly_habits(m, all_dates)
    else
      all_dates = find_specific_days(m, m.start_date)
      generate_weekly_habits(m, all_dates)
    end
  end

###################### Updating a new master_habit route ######################
  def delete_habits(m)
    habits = m.habits.where("due_date >= '#{Date.today}'")
    habits.destroy_all
    m.save!
  end

  def update_frequency_logic(m)
    m.start_date < Date.today ? @date = Date.today : @date = m.start_date
    case m.frequency_options[0]
    when "Daily"
      generate_daily_habits(m, @date)
    when "Weekly"
      all_dates = find_times(m, @date)
      generate_weekly_habits(m, all_dates)
    else
      puts "specific days"
      all_dates = find_specific_days(m, @date)
      generate_weekly_habits(m, all_dates)
    end
  end

###################### Find days and generate habits ######################

  def find_specific_days(m, date)
    weekdays = {
      "Monday": 1, "Tuesday": 2, "Wednesday": 3, "Thursday": 4, "Friday": 5,
      "Saturday": 6, "Sunday": 0
    }
    datesByWeekday = (date..m.end_date).group_by(&:wday)
    final_dates = m.frequency_options.map { |day| datesByWeekday[weekdays[day.to_sym]] }
    return final_dates.flatten!.sort!
  end

  def find_times(m, date)
    times = m.frequency_options[1].to_i
    datesByWeekday = (date..m.end_date).group_by(&:wday)
    days = [0, 6, 5, 4, 3, 2]
    final_dates = days[0..(times - 1)].map { |i| datesByWeekday[i] }
    return final_dates.flatten!.sort!
  end


  def generate_weekly_habits(m, dates)
    dates.each do |date|
      create_steps
      @habit = Habit.new(master_habit_id: m.id, due_date: date, name: m.name, 
        frequency_options: m.frequency_options, total_steps: @steps.length, week: date.strftime('%-V'))
      @habit.save!
      @steps.each do |step|
        step.habit_id = @habit.id
        step.save!
      end
    end
  end

  def generate_daily_habits(m, date)
    @date = date
    @frequency = (m.end_date - m.start_date).to_i + 1
    @frequency.times do
      create_steps
      @habit = Habit.new(master_habit_id: m.id, due_date: @date, name: m.name, 
      frequency_options: m.frequency_options, total_steps: @steps.length, week: @date.strftime('%-V'))
      @habit.save!
      @steps.each do |step|
        step.habit_id = @habit.id
        step.save!
      end
      @date += 1
    end
  end

  def create_steps
    @steps = params[:step_array].map { |step| @step = Step.new(name: step["name"], completed: false, step_type: "checkbox") }
    return @steps
  end

end
