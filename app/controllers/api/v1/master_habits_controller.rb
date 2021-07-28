class Api::V1::MasterHabitsController < Api::V1::BaseController
  before_action :find_master_habit, only: %i[show update destroy]

  def index
    @master_habits = MasterHabit.all
  end

  def show; end

  def create
    @master_habit = MasterHabit.new(master_habit_params)
    if @master_habit.save
      frequency_logic(@master_habit)
      render json: @master_habit
    else
      render_error
    end
  end

  def update
    if @master_habit.update(master_habit_params)
      #once a master habit is updated, destroy all instances of future habits and redo logic_route
      render json: @master_habit
    else
      render_error
    end
  end

  def destroy
    @master_habit.destroy
  end

  def show_user_master_habits
    @master_habits = MasterHabit.where("user_id = #{params[:user_id]}")
  end

  private

  def master_habit_params
    params.require(:master_habit).permit(:name, :start_date, :end_date, :user_id, :frequency_options => [])
  end

  def find_master_habit
    @master_habit = MasterHabit.find(params[:id])
  end

  def render_error
    render json: { errors: @story.errors.full_messages },
      status: :unprocessable_entity
  end

  def frequency_logic(m)
    case m.frequency_options[0]
    when "Daily"
      generate_daily_habits(m)
    when "Weekly"
      all_dates = find_times(m)
      generate_weekly_habits(all_dates, m)
    else
      all_dates = find_specific_days(m)
      generate_weekly_habits(all_dates, m)
    end
  end

  def find_specific_days(m)
    final_dates = []
    datesByWeekday = (m.start_date..m.end_date).group_by(&:wday)
    m.frequency_options.each do |day|
      case day
      when "Monday"
        final_dates += datesByWeekday[1]
      when "Tuesday"
        final_dates += datesByWeekday[2]
      when "Wednesday"
        final_dates += datesByWeekday[3]
      when "Thursday"
        final_dates += datesByWeekday[4]
      when "Friday"
        final_dates += datesByWeekday[5]
      when "Saturday"
        final_dates += datesByWeekday[6]
      when "Sunday"
        final_dates += datesByWeekday[0]
      end
    end
    return final_dates
  end

  def find_times(m)
    final_dates = []
    times = m.frequency_options[1].to_i
    datesByWeekday = (m.start_date..m.end_date).group_by(&:wday)
    days = [0, 6, 5, 4, 3, 2]
    days[0..(times - 1)].each do |i|
      final_dates += datesByWeekday[i]
    end
    return final_dates
  end


  def generate_weekly_habits(dates, m)
    dates.each do |date|
      @habit = Habit.new(master_habit_id: m.id, due_date: date)
      @habit.save!
      create_steps
      @steps.each do |step|
        step.habit_id = @habit.id
        step.save!
      end
    end
  end

  def times_per_week
    case @master_habit.frequency_options[1]
    when "One"
      return 1
    when "Two"
      return 2
    when "Three"
      return 3
    when "Four"
      return 4
    when "Five"
      return 5
    else
      return 6
    end
    # need to code in logic based on day of the week
  end

  def generate_daily_habits(m)
    @date = m.start_date
    @frequency = (m.end_date - m.start_date).to_i + 1
    @frequency.times do
        @habit = Habit.new(master_habit_id: m.id, due_date: @date)
        @habit.save!
        create_steps
        @steps.each do |step|
          step.habit_id = @habit.id
          step.save!
        end
        @date += 1
    end
  end

  def create_steps
    @steps = []
    params[:step_array].each do |step|
      @step = Step.new(name: step["name"], completed: false, step_type: "checkbox")
      @steps << @step
    end
    return @steps
  end

end
