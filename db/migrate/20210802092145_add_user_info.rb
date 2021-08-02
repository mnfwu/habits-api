class AddUserInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :wechat_pic_url, :string
    rename_column :users, :display_name, :wechat_username
  end
end
