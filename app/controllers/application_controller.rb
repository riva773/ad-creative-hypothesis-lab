class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def after_sign_in_path_for(_resource)
    apps_path
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
  end

  private
  def load_app_show_data
    @apps = App.all
    if params.dig(:app, :search).present?
      @apps = @apps.where("name LIKE ?", "%#{params[:app][:search]}%")
    end
    @q = @app.ad_tests.ransack(params[:q])
    @ad_tests = @q.result.includes(
      :review,
      ad: [
        :hypothesis,
        :user,
        { creative_attachment: :blob }
      ]
    )
    @hypotheses = @app.hypotheses.where(user_id: current_user.id).includes(:ad).order(:id)
    @hypothesis ||= Hypothesis.new
    @ad ||= Ad.new
    @untestedHypotheses = @hypotheses.select do |hypothesis|
      hypothesis.ad.blank?
    end
    @new_app ||= App.new
  end
end
