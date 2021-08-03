class Api::V1::GoalsController < Api::V1::BaseController
  before_action :find_goal, only: %i[update destroy]

	def create
		@goal = Goal.new(goal_params)
    @goal.group = Group.find(params[:group_id])
    if @goal.save
      render json: @goal
    else
      render_error
    end
	end

  def update
    if @goal.update(goal_params)
      render json: @goal
    else
      render_error
    end
  end

  def destroy
    @goal.destroy
  end

	private

  def find_goal
    @goal = Goal.find(params[:id])
  end

	def goal_params
    params.require(:goal).permit(:end_date, :percent_complete)
  end

	def render_error
    render json: { errors: @goal.errors.full_messages },
    status: :unprocessable_entity
  end
end
