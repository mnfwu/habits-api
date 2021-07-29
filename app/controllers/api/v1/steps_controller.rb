class Api::V1::StepsController < Api::V1::BaseController
  before_action :find_step, only: %i[update show destroy]

  def index
    @steps = Step.all
  end

  def show; end

  def create
    @step = Step.new(step_params)
    if @step.save
      render json: @step
    else
      render_error
    end
  end

  def update
    if @step.update(step_params)
      find_habit(@step)
      render json: @step
    else
      render_error
    end
  end

  def destroy
    @step.destroy
  end

  def show_habit_steps
    @steps = Step.where("habit_id = #{params[:habit_id]}")
  end

  private

  def step_params
    params.require(:step).permit(:name, :step_type, :completed, :habit_id)
  end

  def find_step
    @step = Step.find(params[:id])
  end

  def render_error
    render json: { errors: @story.errors.full_messages },
      status: :unprocessable_entity
  end

  def find_habit(s)
    @habit = Habit.find(s.habit_id)
    @habit_completed_steps = @habit.steps.where("completed = true")
    @habit.steps_completed = @habit_completed_steps.length
    if @habit.steps_completed == @habit.total_steps
      @habit.completed = true
      @habit.completed_date = Date.today
    else
      @habit.completed_date = nil
      @habit.completed = nil
      @habit.completed_on_time = nil
    end
    if @habit.completed_date?
      @habit.completed_date <= @habit.due_date ? @habit.completed_on_time = true : @habit.completed_on_time = false
    end
    @habit.save!
  end

end
