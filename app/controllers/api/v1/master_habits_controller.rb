class Api::V1::MasterHabitsController < Api::V1::BaseController
  before_action :find_master_habit, only: %i[show update destroy]

  def index
    @master_habits = MasterHabit.all
  end

  def show; end

  def create
    @master_habit = MasterHabit.new(master_habit_params)
    if @master_habit.save
      logic_route(@master_habit)
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

  def logic_route(master_habit)
    case master_habit.frequency_options[0]
    when "Daily"
      generate_daily_habits(master_habit)
    when "Weekly"
      @frequency = times_per_week
    else
      @frequency = specific_days
    end
  end

#different kinds of frequency functions
  def daily(master_habit)
    return (master_habit.end_date - master_habit.start_date).to_i + 1
    # need to code in logic based on day of the week
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

  def specific_days
    return @master_habit.frequency_options.length
    datesByWeekday = (start_date..end_date).group_by(&:wday)
    datesByWeekday[0]
  end

  def generate_daily_habits(master_habit)
    @date = master_habit.start_date
    @frequency = (master_habit.end_date - master_habit.start_date).to_i + 1
    @frequency.times do
        @habit = Habit.new(master_habit_id: master_habit.id, due_date: @date)
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
