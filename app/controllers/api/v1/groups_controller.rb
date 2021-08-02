class Api::V1::GroupsController < Api::V1::BaseController
  before_action :find_group, only: %i[show update destroy]

  def index
    @groups = Group.all
  end

  def show; end

  def create
    @group = Group.new(group_params)
    if @group.save
      create_user_group(@group)
      render json: @group
    else
      render_error
    end
  end

  def update
    if @group.update(group_params)
      render json: @group
    else
      render_error
    end
  end

  def destroy
    @group.destroy
  end

  def show_user_groups
    user = User.find(params[:user_id])
    @groups = user.groups
  end

  def add_user_to_group
    user_id = params[:user_id].to_i
    group_id = params[:group_id].to_i
    user_group = UsersGroup.new(group_id: group_id, user_id: user_id)
    user_group.save!
  end

  def add_new_goal
    @goal = Goal.new(goal_params)
    if @goal.save
      render json: @goal
    else
      render_goal_error
    end
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end

  def goal_params
    params.require(:goal).permit(:percent_complete, :end_date, :start_date, :group_id)
  end

  def find_group
    @group = Group.find(params[:id])
  end

  def render_error
    render json: { errors: @group.errors.full_messages },
      status: :unprocessable_entity
  end

  def render_goal_error
    render json: { errors: @goal.errors.full_messages },
    status: :unprocessable_entity
  end

  def create_user_group(g)
    @user_id = params[:user_id].to_i
    @user_group = UsersGroup.new(group_id: g.id, user_id: @user_id)
    @user_group.save!
  end
end
