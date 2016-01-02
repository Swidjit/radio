class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy,:finish_signup]
  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  respond_to :js

  def show
    @user = User.find_by_username(params[:id])
    puts @user
  end

  def edit

  end

  def favorites
    @favorite_songs = Song.where('id in (?)',Reaction.where(:user=>current_user).pluck(:post_id))
    @favorite_shows = Show.where('id in (?)',Reaction.where(:user=>current_user).pluck(:post_id))
  end


  def update
    # authorize! :update, @user
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        format.html { redirect_to profile_path(@user.username), notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @user
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(user_params)

        sign_in(@user, :bypass => true)
        redirect_to root_path, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end

    else

    end
  end

  # DELETE /users/:id.:format
  def destroy
    # authorize! :delete, @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  def autocomplete
    @users = User.where("username LIKE (?) or first_name LIKE (?) or last_name LIKE (?)","%#{params[:q]}%","%#{params[:q]}%","%#{params[:q]}%")
    render file: 'users/search.json.rabl'
  end

  def upload_file
    current_user.update_attribute(:avatar, URI.parse(URI.unescape(params['url'])))
    @user = User.find(params[:id])
  end


  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit([:username, :first_name, :last_name, :email, :address, :about, :avatar, :dietary_list,:password, :password_confirmation])
  end

end
