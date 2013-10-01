require 'digest/sha1'

class User < ActiveRecord::Base
	
	# sets a non-database attribute to use when salting/hashing password
	attr_accessor :password
	

	# sets regular expression to use in validating email address
	EMAIL_REGEX = /\A[A-Z0-9._+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i
	
	
	# validates input for prospective database content
	validates :first_name, :presence => true, :length => {:maximum => 25}
	validates :last_name, :presence => true, :length => {:maximum => 50}
	
	validates :username, :presence => true, :length => {:in => 8..25}, :uniqueness => true
	validates :password, :presence => true, :length => {:in => 8..25}
	
	validates :email, :presence => true, :length => {:maximum => 100}, :format => {:with => EMAIL_REGEX} 
	
	
	# creates callbacks that will handle "password" attribute when hashing before submission
	before_save :create_hashed_password
	after_save :clear_password
	
	
	# returns the full name (first + last) of the user
	def name 
	
		"#{first_name} #{last_name}"
	
	end # end Name Method
	
	
	# matches password to user input in the User.authenticate method
	def password_match?(password="")
	
		hashed_password == User.hash_with_salt(password,salt)
	
	end # end Password_Match? Method
	
	
	# authenticates the user for login by matching password for the selected user
	# 	-- called in AccessController to verify login
	def self.authenticate(username="",password="")
	
	
		# retrieves user data by searching for the username input
		user = User.find_by_username(username)	
		
		
		if user && user.password_match?(password)
			
			# if the user exists and the password input matches that users record,
			#	return that user's data
			return user
		
		else
		
			return false
		
		end
	
	end # end Self.Authenticate Method
	
	
	# creates a random salt using SHA1 hash and long, unique salt string
	def self.make_salt(username="")
	
		Digest::SHA1.hexdigest("Use #{username} with #{Time.now} to make salt")
	
	end # end Self.Make_Salt Method
	
	
	# hashes string and salt with extra content for further complexity
	def self.hash_with_salt(password="",salt="")
	
		Digest::SHA1.hexdigest("Put #{salt} on the #{password}")
	
	end # end Self.Hash_With_Salt Method
	
	
	# starts private block
	private
	
	
	# creates salt/hashes password upon callback execution
	def create_hashed_password
	
		# if the password attribute isn't blank check salt and create hashed password
		unless password.blank?
		
			self.salt = User.make_salt(username) if salt.blank?
			self.hashed_password = User.hash_with_salt(password,salt)
		
		end
	
	end # end Create_Hashed_Password Method
	
	
	# clears the password attribute at the end of callback execution to prepare for
	#	another callback
	def clear_password
	
		self.password = nil
	
	end # end Clear_Password Method

end
