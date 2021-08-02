class Api::V1::GoalsController < Api::V1::BaseController
	def create
		@goal = Goal.new(goal_params)
    @goal.group = Group.find(params[:group_id])
    if @goal.save
      render json: @goal
    else
      render_error
    end
	end

	private

	def goal_params
    params.require(:goal).permit(:end_date, :percent_complete)
  end

	def render_error
    render json: { errors: @goal.errors.full_messages },
    status: :unprocessable_entity
  end
end
