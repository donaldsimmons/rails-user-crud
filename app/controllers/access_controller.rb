class AccessController < ApplicationController

	# uses 'user_crud' layout to wrap views
	layout 'user_crud'

	# default action - renders the login page when called
	def index
	
		login
		render('login')
	
	end # end Index Method
	
	
	# displays login page
	def login 
	
	end # end Login Method
	
	
	# tries to authenticate user, then logs user into app or redirects
	def attempt_user_login
	
	
		# authorizes user using User model
		authorized_user = User.authenticate(params[:username],params[:password])
		
		
		if authorized_user
			
			# sets user info to signal successful login
			session[:user_id] = authorized_user.id
			session[:username] = authorized_user.username
			
			flash[:notice] = "You are now logged in."
			
			# when user is logged in, redirects to their profile
			redirect_to(:controller=>'users', :action=>'profile', :id=>session[:user_id])
		
		else
		
			# if login is unsuccessful, notifies user
			flash[:notice] = "Invalid username/password combination"
		
			# redirects for another login
			redirect_to(:action=>'login');
		
		end
	
	end # end Attempt_User_Login Method
	
	
	# logs the user out of the application
	def logout
	
		# gets rid of user's stored session info
		session[:user_id] = nil
		session[:username] = nil
	
		flash[:notice] = "You have been logged out."
	
		# redirects back to login
		redirect_to(:action=>'login')
	
	end # end Logout Method

end
