class HypothesesController < ApplicationController
  def create
    @app = App.find(params[:hypothesis][:app_id])
    @hypothesis = current_user.hypotheses.new(hypothesis_params)
    @hypothesis.app = @app
    if @hypothesis.save
      redirect_to @app, status: :see_other, notice: "仮説を作成しました。"
    else
      render "apps/show", app: @app, status: :unprocessable_entity
    end
  end

  def update
    @hypothesis = Hypothesis.find(params[:id])
    @app = @hypothesis.app
    if @hypothesis.update(hypothesis_params)
      redirect_to app_path(@app), status: :see_other, notice: "仮説を更新しました。"
    else
      render "app/show", status: :unprocessable_entity
    end
  end

  def destroy
    @hypothesis = Hypothesis.find(params[:id])
    @app = @hypothesis.app
    if @hypothesis.destroy
      redirect_to app_path(@app), status: :see_other, notice: "仮説を削除しました。"
    else
      render "app/show", status: :unprocessable_entity
    end
  end

  def hypothesis_params
    params.require(:hypothesis).permit(:content, :app_id)
  end
end
