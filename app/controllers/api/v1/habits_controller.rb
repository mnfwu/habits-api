class Api::V1::HabitsController < Api::V1::BaseController
  before_action :find_habit, only: %i[show update destroy]

  def index
    @habits = Habit.all
  end

  def show; end

  def create
    @habit = Habit.new(habit_params)
    if @habit.save
      render json: @habit
    else
      render_error
    end
  end

  def update
    if @habit.update(habit_params)
      render json: @habit
    else
      render_error
    end
  end

  def destroy
    @habit.destroy
  end

  def show_master_habit_habits
    @habits = Habit.where("master_habit_id = #{params[:master_habit_id]}")
  end

  private

  def habit_params
    params.require(:habit).permit(:partially_completed, :completed, :master_habit_id)
  end

  def find_habit
    @habit = Habit.find(params[:id])
  end
end
