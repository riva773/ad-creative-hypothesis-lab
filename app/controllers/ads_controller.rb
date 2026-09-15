class AdsController < ApplicationController
  before_action :authenticate_user!

  def create
    @app = App.find(params[:ad][:app_id])
    @ad = current_user.ads.build(ad_params)
    @ad.hypothesis = @app.hypotheses.where(user_id: current_user.id).find_by(id: params[:hypothesis])
    creative = params[:ad][:creative]
    if creative.present?
      @ad.file_name = creative.original_filename
    end
    begin
      ApplicationRecord.transaction do
        @ad.save!
        @ad.ad_tests.create!(status: "テスト結果待ち")
      end
        redirect_to @app, status: :see_other, notice: "広告をアップロードしました。"
    rescue ActiveRecord::RecordInvalid
      load_app_show_data
      render "apps/show", status: :unprocessable_entity
    end
  end

  private

  def ad_params
    params.require(:ad).permit(:creative, :app_id)
  end
end
