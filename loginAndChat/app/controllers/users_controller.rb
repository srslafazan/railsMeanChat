class UsersController < ApplicationController
  after_action :set_user, :only => [:create, :login]


  # GET /
  # GET /users
  # GET /users.json
  def index
    @users = User.all
    @user = User.new
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  def dashboard 
    @user = @@user
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def login
    # check user info against db
    @userName = params[:login][:name].downcase.capitalize
    user = User.find_by_name(@userName)

    if user && user.authenticate(params[:login][:password])
      redirect_to :action => :dashboard
      puts 'user authenticated'
    else 
      flash[:notice] = 'Username or password is incorrect.'
      redirect_to :action => :index
    end
  end

  # POST /users
  # POST /users.json
  def create

    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to :action => :dashboard, notice: 'User was successfully created.' }
        format.json { render :dashboard }
      else # user failed to save
        format.html { render :index }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if !@userName 
        @userName = params[:user][:name].downcase.capitalize
      end
      @@user = User.find_by_name(@userName)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end

    def login_params
      params.require(:login).permit(:name, :password)
    end

end
