class AddUserBelongsToSeller < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :seller, foreign_key: true
  end
end