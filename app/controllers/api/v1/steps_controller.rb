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
    @habit.steps_completed = 3
    if @habit.steps_completed == @habit.total_steps
      puts @habit.completed?
    end
    @habit.save!
  end

  #check if the params changed is the completed boolean
  #find the habit instance associated with this step
  #set the steps_completed integer
  #check if steps_completed == total_steps
  #change completed? boolean
  #log completed date
  #check if completed date <= due_date
  #change completed_on_time boolean
end
