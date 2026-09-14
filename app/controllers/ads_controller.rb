class AdsController < ApplicationController
  def create
    @app = App.find(params[:ad][:app_id])
    @ad = current_user.ads.build(ad_params)
    @ad.hypothesis_id = params[:hypothesis]
    @ad.file_name = params[:ad][:creative].original_filename
    if @ad.save
      @ad.ad_tests.create(status: "テスト結果待ち")
      @ad_tests = AdTest.all
      redirect_to apps_path, status: :see_other, notice: "広告をアップロードしました。"
    else
        Rails.logger.debug "Ad errors: #{@ad.errors.full_messages.inspect}"
      render "apps/show", status: :unprocessable_entity
    end
  end

  private
  
  def ad_params
    params.require(:ad).permit(:creative, :app_id)
  end
end
