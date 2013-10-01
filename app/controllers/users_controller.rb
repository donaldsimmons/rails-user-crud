class UsersController < ApplicationController

	# uses the 'user_crud' layout for displaying the view
	layout 'user_crud'
	
	
	# restricts access to actions until the user is logged in
	#	-- defined in parent -- redirects to login page if not confirmed
	before_filter :confirm_logged_in_status, :except => 'new'
	
	
	# renders default view when UserController is used
	def index
	
		profile
		render('profile')
	
	end # end Index Method
	
	
	# selects the data for the logged in user
	def profile
		
		@user = User.find(session[:id])
		
	end
	
	
	# displays create new user form
	def new
		
	end # end New_User Method	
	
	# creates a new user record in the users table
	def create
	
		# permit the manipulation of the POST variables for the 'user' form
		params.permit!
		
		# creates new User object with the POST array contents
		@user = User.new(params[:user])
		
		
		# logs in the user if the record could be saved to the database
		if @user.save
		
			flash[:notice] = "A New User Was Created"
			
			redirect_to(:controller=>'access',:action=>'login')
		
		else
		
			# gives notice and redirects to sign up form if save is unsuccessful
		
			flash[:notice] = "Could Not Create a New User!"
			
			render('new')
					
		end
	
	end # end Create Method
	
	
	# updates attributes based on input in the edit profile form - located on profile page
	def update
	
		# allows manipulation of POST values
		params.permit!
		
		# selects correct record to update
		@user = User.find(params[:id])
	
		
		# if the user is successfully updated, alert the user and reload the profile
		if @user.update_attributes(params[:user])
			
			flash[:notice] = "'#{@user.name}' was Updated!"
			
			redirect_to(:action => 'list');
			
		else
			
			# notify and reload profile if the update was unsuccessful
			flash[:notice] = "'#{@user.name}' Could not be Updated!"
			
			render('profile')
		
		end
	
	end # end Edit Method
	
	
	# destroys the selected record in the database
	def destroy
	
		# allows manipulation of the POST values
		params.permit!
		
		@user = User.find(params[:id])
		
		# saves user's name for display after the record is destroyed - used in notification
		user_name = @user.name
		
		
		# notify that the user was removed from the table if successful and redirect
		if @user.destroy
		
			flash[:notice] = "#{user_name} was Destroyed!"
			
			redirect_to(:action=>'profile')
			
		else
		
			# notify and redirect to profile if destruction is unsuccessful
			flash[:notice] = "#{user_name} couldn't be Destroyed!"
			
			render('profile');
		
		end
	
	end # end Destroy Method

end
