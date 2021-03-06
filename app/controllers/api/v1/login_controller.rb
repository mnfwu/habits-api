class Api::V1::LoginController < Api::V1::BaseController
  def login
    open_id = wechat_user.fetch('openid')
    @user = User.find_or_create_by(open_id: open_id)
    # p "@user: #{@user.id}"
    render json: {
      user: @user
    }
  end

  def update_user
    @user = User.find(params[:user_id])
    @user.wechat_username = params[:wechat_username]
    @user.wechat_pic_url = params[:wechat_pic_url]
    if @user.save
      render json: @user
    else
      render_error
    end
  end

  private

  URL = 'https://api.weixin.qq.com/sns/jscode2session'.freeze

  # prepare the params for tencent request
  def wechat_user
    wechat_params = {
      appId: ENV['WECHAT_APP_ID'],
      secret: ENV['WECHAT_APP_SECRET'],
      js_code: params[:code],
      grant_type: 'authorization_code'
    }
    # p "wechat_params: #{wechat_params}"
    wechat_response = RestClient.get(URL, params: wechat_params)
    # p "wechat_response: #{wechat_response}"
    JSON.parse(wechat_response.body)
  end

end
