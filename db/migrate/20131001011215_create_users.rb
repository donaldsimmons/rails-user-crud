class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    
    	t.string "user_name", :limit => 25
    	
    	t.string "user_password", :limit => 40
    	
    	t.string "user_salt", :limit => 40
    	
    	t.string "user_full_name", :limit => 50
    	
    	t.string "user_height", :limit => 3
    	
    	t.string "user_weight", :limit => 3
    	
    	t.string "user_target_weight", :limit => 3
    	
    	t.timestamps
    
    end
  end
end
