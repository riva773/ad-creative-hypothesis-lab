class ReviewsController < ApplicationController
  def create
    @review = current_user.reviews.new(create_review_params)
    @app = @review.ad_test.ad.app
    if @review.save
      redirect_to app_path(@app), status: :see_other
    else
      load_app_data
      render "apps/show", status: :unprocessable_entity
    end
  end

  def update
    @review = current_user.reviews.find(params[:id])
    @app = @review.ad_test.ad.app
    if @review.update(update_review_params)
      redirect_to app_path(@app), status: :see_other
    else
      load_app_data
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

  def load_app_data
    @ad_tests = @app.ad_tests
    @hypotheses = @app.hypotheses.where(user_id: current_user.id)
    @hypothesis = Hypothesis.new
    @ad = Ad.new
    @untestedHypotheses = @hypotheses.select do |hypothesis|
      hypothesis.ad.blank?
    end
  end
end
