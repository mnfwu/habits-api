class Api::V1::MasterHabitsController < Api::V1::BaseController
  before_action :find_master_habit, only: %i[show update destroy]

  def index
    @master_habits = MasterHabit.all
  end

  def show; end

  def create
    @master_habit = MasterHabit.new(master_habit_params)
    if @master_habit.save
      render json: @master_habit
    else
      render_error
    end
  end

  def update
    if @master_habit.update(master_habit_params)
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
    params.require(:master_habit).permit(:name, :frequency_options, :start_date, :end_date, :user_id)
  end

  def find_master_habit
    @master_habit = MasterHabit.find(params[:id])
  end
end
