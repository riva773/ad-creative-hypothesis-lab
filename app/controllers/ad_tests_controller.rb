class AdTestsController < ApplicationController
  before_action :authenticate_user!
  require "csv"

  def results
  end

  def create
    count = 0
    missed_upload_tests = []
    @app = App.find(params[:ad_test][:app_id])
    CSV.foreach(params[:ad_test][:csv], headers: true) do |row|
      csv_ad_file_name = row["Ad set Name"]
      ad = @app.ads.find_by("split_part(file_name,'.',1) = ?", csv_ad_file_name)
      unless ad.present?
        missed_upload_tests.push(csv_ad_file_name)
        next
      end
      ad_test = ad.ad_tests.find_by(status: "テスト結果待ち")
      unless ad_test.present?
        missed_upload_tests.push(csv_ad_file_name)
        next
      end
      if ad_test.update(
        status: row["status"],
        test_start_date: row["test_start_date"],
        test_end_date: row["test_end_date"],
        cpi: row["cpi"],
        cpm: row["cpm"],
        ctr: row["ctr"],
        cvr: row["cvr"],
        impression: row["impression"],
        budget: row["budget"],
        amount_spent: row["amount_spent"],
        network: params[:ad_test][:network],
      )
        count += 1
      else
        missed_upload_tests.push(ad_test.ad.file_name)
      end
    end
    if missed_upload_tests.empty?
      message="#{count}件すべて取り込みました。"
      redirect_to @app, status: :see_other, notice: message
    else
      message ="#{count}件取り込みました。"
      alert_message ="失敗したファイル：#{missed_upload_tests.join(', ')}"
      redirect_to @app, status: :see_other, notice: message, alert: alert_message
    end
  end

  def update
    @ad_test = current_user.ad_tests.find(params[:id])
    @app = @ad_test.ad.app

    if @ad_test.update(ad_test_params)
      redirect_to @app, status: :see_other, notice: "テスト結果を更新しました。"
    else
      load_app_data
      render "apps/show", status: :unprocessable_entity
    end
  end

  def destroy
    @ad_test = current_user.ad_tests.find(params[:id])
    @app = @ad_test.ad.app

    if @ad_test.destroy
      redirect_to @app, status: :see_other, notice: "テスト結果を削除しました。"
    else
      redirect_to @app, status: :see_other, alert: "テスト結果を削除できませんでした。"
    end
  end

  private

  def ad_test_params
    params.require(:ad_test).permit(
      :ad_id,
      :app_id,
      :csv,
      :network,
      :status,
      :test_start_date,
      :test_end_date,
      :cpi,
      :cpm,
      :ctr,
      :cvr,
      :impression,
      :budget,
      :amount_spent
    )
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
