class AdsController < ApplicationController
  def create
    @ad = Add.new(ad_params)
    if @ad.save
      redirect_to apps_path, status: :see_other, notice: "広告をアップロードしました。"
    else
      render "apps/show", status: :unprocessable_entity
    end
  end

  def ad_params
    params.require(:ad).permit(:creative)
  end
end
