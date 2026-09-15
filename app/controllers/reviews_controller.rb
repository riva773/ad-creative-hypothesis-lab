class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @ad_test = current_user.ad_tests.find(create_review_params[:ad_test_id])
    @app = @ad_test.ad.app
    if @ad_test.status != "結果取り込み済み"
      flash.now[:alert] = "振り返りは、結果取り込み済みのテストでしか作成できません。"
      load_app_show_data
      render "apps/show", status: :unprocessable_entity
      return
    end
    @review = @ad_test.build_review(user: current_user, content: create_review_params[:content])
    begin
      ApplicationRecord.transaction do
        @review.save!
        @review.ad_test.update!(status: "振り返り済み")
      end
      redirect_to app_path(@app), status: :see_other
    rescue ActiveRecord::RecordInvalid
      load_app_show_data
      render "apps/show", status: :unprocessable_entity
    end
  end

  def update
    @review = current_user.reviews.find(params[:id])
    @app = @review.ad_test.ad.app
    if @review.update(update_review_params)
      redirect_to app_path(@app), status: :see_other
    else
      load_app_show_data
      render "apps/show", status: :unprocessable_entity
    end
  end

  private

  def create_review_params
    params.require(:review).permit(:content, :ad_test_id)
  end

  def update_review_params
    params.require(:review).permit(:content)
  end

end
