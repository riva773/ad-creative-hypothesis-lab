class AppsController < ApplicationController
  before_action :authenticate_user!
  def index
    @apps = App.all
    if params.dig(:app, :search).present?
      @apps = @apps.where("name LIKE ?", "%#{params[:app][:search]}%")
    end
    @app = App.new
  end

  def show
    @app = App.find(params[:id])
  end

  def new
    @app = App.new
  end

  def create
    @app = current_user.apps.build(app_params)
    if @app.save
      redirect_to apps_path, status: :see_other, notice: "アプリを作成しました。"
    else
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

  def app_params
    params.require(:app).permit(:name, :explanation, :avatar)
  end
end
