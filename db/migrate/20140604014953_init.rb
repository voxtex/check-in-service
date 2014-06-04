class Init < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name, null: false
      t.string :private_key, null: false

      t.timestamps
    end

    create_table :users do |t|
      t.string :username, null: false

      t.timestamps
    end

    create_table :check_ins do |t|
      t.belongs_to :store, null: false
      t.belongs_to :user, null: false

      t.timestamps
    end
  end
end
