class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.integer :unread_messages
      t.boolean :jury_in_contest
      t.boolean :client
      t.string :profile

      t.timestamps
    end
  end
end
