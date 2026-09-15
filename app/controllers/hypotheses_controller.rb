class HypothesesController < ApplicationController
  before_action :authenticate_user!

  def create
    @app = App.find(params[:hypothesis][:app_id])
    @hypothesis = current_user.hypotheses.new(create_hypothesis_params)
    @hypothesis.app = @app
    if @hypothesis.save
      redirect_to @app, status: :see_other, notice: "仮説を作成しました。"
    else
      load_app_show_data
      render "apps/show", status: :unprocessable_entity
    end
  end

  def update
    @hypothesis = current_user.hypotheses.find(params[:id])
    @app = @hypothesis.app
    if @hypothesis.update(update_hypothesis_params)
      redirect_to app_path(@app), status: :see_other, notice: "仮説を更新しました。"
    else
      load_app_show_data
      render "apps/show", status: :unprocessable_entity
    end
  end

  def destroy
    @hypothesis = current_user.hypotheses.find(params[:id])
    @app = @hypothesis.app
    if @hypothesis.destroy
      redirect_to app_path(@app), status: :see_other, notice: "仮説を削除しました。"
    else
      load_app_show_data
      render "apps/show", status: :unprocessable_entity
    end
  end

  private

  def create_hypothesis_params
    params.require(:hypothesis).permit(:content, :app_id)
  end

  def update_hypothesis_params
    params.require(:hypothesis).permit(:content)
  end
end
