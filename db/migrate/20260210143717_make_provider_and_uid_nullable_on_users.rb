class MakeProviderAndUidNullableOnUsers < ActiveRecord::Migration[8.1]
  def change
    change_column_null :users, :provider, true
    change_column_null :users, :uid, true
  end
end
