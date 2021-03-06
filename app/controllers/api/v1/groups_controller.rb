class Api::V1::GroupsController < Api::V1::BaseController
  before_action :find_group, only: %i[show update destroy]

  def index
    @groups = Group.all
  end

  def show
    @users = @group.users
    total = 0
    @users.each { |user| total += user.weekly_average }
    @group_average = (total / @users.length.to_f).round(1)
  end

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

  def destroy_user
    @group = Group.find(params[:group_id])
    @user = User.find(params[:user_id])
    @usergroup = UsersGroup.find_by(user_id: @user.id, group_id: @group.id)
    @usergroup.destroy
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end

  def find_group
    @group = Group.find(params[:id])
  end

  def render_error
    render json: { errors: @group.errors.full_messages },
      status: :unprocessable_entity
  end

  def create_user_group(g)
    @user_id = params[:user_id].to_i
    @user_group = UsersGroup.new(group_id: g.id, user_id: @user_id)
    @user_group.save!
  end
end
