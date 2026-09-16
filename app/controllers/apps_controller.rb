class AppsController < ApplicationController
  before_action :authenticate_user!
  def index
    @apps = App.all
    if params.dig(:app, :search).present?
      @apps = @apps.where("name LIKE ?", "%#{params[:app][:search]}%")
    end
    @app = App.new
    @new_app = App.new
  end

  def show
    @focus_ad_test_id = params[:focus_ad_test_id]
    @new_app = App.new
    @app = App.find(params[:id])
    load_app_show_data
  end

  def new
    @app = App.new
  end

  def create
    @new_app = current_user.apps.build(app_params)
    if @new_app.save
      redirect_to apps_path, status: :see_other, notice: "アプリを作成しました。"
    else
      @apps = App.all
      @app = App.new
      flash.now[:alert] = @new_app.errors.full_messages.join("、")
      render :index, status: :unprocessable_entity
    end
  end

  def edit
    @app = current_user.apps.find(params[:id])
  end

  def update
    @app = current_user.apps.find(params[:id])
    if @app.update(app_params)
      redirect_to apps_path, status: :see_other, notice: "アプリを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @app = current_user.apps.find(params[:id])
    if @app.destroy
      redirect_to apps_path, notice: "アプリを削除しました。"
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def app_params
    params.require(:app).permit(:name, :explanation, :avatar, :campaign_name)
  end
end
