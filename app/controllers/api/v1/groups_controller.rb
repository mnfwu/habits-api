class Api::V1::StepsController < Api::V1::BaseController
  before_action :find_group, only: %i[show update destroy]

  def index
    @groups = Group.all
  end

  def show; end

  def create
    @group = Group.new(group_params)
    if @group.save
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
    # This needs to be updated to reflect that group is connected to users throgh usersgroups
    @groups = Group.where("user_id = #{params[:user_id]}")
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end

  def find_group
    @group = Group.find(params[:id])
  end
end
