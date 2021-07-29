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
    weekdays = {
      "Monday": 1, "Tuesday": 2, "Wednesday": 3, "Thursday": 4, "Friday": 5,
      "Saturday": 6, "Sunday": 0
    }
    datesByWeekday = (m.start_date..m.end_date).group_by(&:wday)
    m.frequency_options.each do |day|
      final_dates += datesByWeekday[weekdays[day.to_sym]]
    end
    return final_dates.sort!
  end

  def find_times(m)
    final_dates = []
    times = m.frequency_options[1].to_i
    datesByWeekday = (m.start_date..m.end_date).group_by(&:wday)
    days = [0, 6, 5, 4, 3, 2]
    days[0..(times - 1)].each do |i|
      final_dates += datesByWeekday[i]
    end
    return final_dates.sort!
  end


  def generate_weekly_habits(dates, m)
    dates.each do |date|
      @habit = Habit.new(master_habit_id: m.id, due_date: date, name: m.name, frequency_options: m.frequency_options)
      @habit.save!
      create_steps
      @steps.each do |step|
        step.habit_id = @habit.id
        step.save!
      end
    end
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
