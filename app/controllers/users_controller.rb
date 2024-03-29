class UsersController < ApplicationController
	before_filter :signed_in_user,  		only: [:index, :edit, :update, :destroy]
	before_filter :correct_user,    		only: [:edit, :update]
	before_filter :admin_user,      		only: :destroy
	before_filter :not_current_admin_user,	only: :destroy
	before_filter :registered_user, 		only: [:new, :create]
   

	def index
		@users = User.paginate(page: params[:page])
	end

	def show
		store_location
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(page: params[:page])
	end	

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @user.update_attributes(params[:user])
			#handle successful update
			flash[:success] = "Profile Updated"
			sign_in @user
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
	    User.find(params[:id]).destroy
	    flash[:success] = "User destroyed."
	    redirect_to users_path
	end

	private

	    def correct_user
	      @user = User.find(params[:id])
	      redirect_to(root_path) unless current_user?(@user)
	    end

	    def admin_user
	    	@user = User.find(params[:id])
	    	redirect_to(root_path) unless current_user.admin?
	    end

	    def not_current_admin_user
	    	@user = User.find(params[:id])
	    	redirect_to(root_path) unless !current_user?(@user)
	    end

	    def registered_user
	      redirect_to(root_path) if signed_in?
	    end

end
