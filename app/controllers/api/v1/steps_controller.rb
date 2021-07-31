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
      check_habit(@step)
      update_mh(@step)
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

  def check_habit(s)
    @habit = Habit.find(s.habit_id)
    @habit.steps_completed = @habit.steps.where("completed = true").length
    if @habit.steps_completed == @habit.total_steps
       @habit.completed = true
       @habit.partially_completed = false
       @habit.missed = false
    end
    @date = Date.today
    if @date > @habit.due_date
      if @habit.steps_completed > 0 && @habit.steps_completed < @habit.total_steps
        @habit.partially_completed = true
        @habit.missed = false
        @habit.completed = false
      elsif @habit.steps_completed == 0
        @habit.missed = true
        @habit.partially_completed = false
        @habit.completed = false
      end
    end
    @habit.save!
  end

  def update_mh(s)
    @master_habit = MasterHabit.find(@habit.master_habit_id)
    @habits = Habit.where("master_habit_id = #{@master_habit.id}").where("week = #{@habit.week}")
    completed_rate = (@habits.where("completed = true").length / @habits.length.to_f) * 100
    @habits.each do |habit| 
      habit.weekly_percent_complete = completed_rate 
      habit.save!
    end
    @master_habit.percent_complete = completed_rate
    @master_habit.save!
  end
end
