class AdTestsController < ApplicationController
  before_action :authenticate_user!
  require "csv"

  def results
    @q = AdTest.all.ransack(params[:q])
    @ad_tests = @q.result.includes(
      :review,
      ad: [
        :hypothesis,
        {
          app: {
            avatar_attachment: :blob
          }
        },
        { creative_attachment: :blob }
      ]
    )
  end

  def create
    count = 0
    missed_upload_tests = []
    @app = App.find(csv_import_params[:app_id])
    if csv_import_params[:csv].present?
      begin
        expected_headers = [
          "Ad set Name",
          "test_start_date",
          "test_end_date",
          "cpi",
          "cpm",
          "ctr",
          "cvr",
          "impression",
          "budget",
          "amount_spent"
        ]
        actual_headers = CSV.open(csv_import_params[:csv].path, &:readline)
        missing_headers = expected_headers - actual_headers
        if missing_headers.present?
          redirect_to @app, status: :see_other, alert: "CSVファイルのヘッダーが要件を満たしていません。(#{missing_headers.join(", ")})"
          return
        end
        ApplicationRecord.transaction do
          CSV.foreach(csv_import_params[:csv], headers: true) do |row|
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
              status: "結果取り込み済み",
              test_start_date: row["test_start_date"],
              test_end_date: row["test_end_date"],
              cpi: row["cpi"],
              cpm: row["cpm"],
              ctr: row["ctr"],
              cvr: row["cvr"],
              impression: row["impression"],
              budget: row["budget"],
              amount_spent: row["amount_spent"],
              network: csv_import_params[:network],
            )
              count += 1
            else
              error_message = ad_test.errors.full_messages.join(" / ")
              missed_upload_tests.push("#{ad_test.ad.file_name}: #{error_message}")
            end
          end
        end
        rescue CSV::MalformedCSVError
          redirect_to @app, status: :see_other, alert: "CSVファイルが読み込める形式ではありません。"
          return
        end
        if missed_upload_tests.empty?
          message="#{count}件すべて取り込みました。"
          redirect_to @app, status: :see_other, notice: message
        else
          message ="#{count}件取り込みました。"
          alert_message ="失敗したファイル：#{missed_upload_tests.join(', ')}"
          redirect_to @app, status: :see_other, notice: message, alert: alert_message
        end
    else
        redirect_to @app, status: :see_other, alert: "CSVファイルを選択してください。"
    end
  end

  def update
    @ad_test = current_user.ad_tests.find(params[:id])
    @app = @ad_test.ad.app

    if @ad_test.update(ad_test_params)
      redirect_to @app, status: :see_other, notice: "テスト結果を更新しました。"
    else
      load_app_show_data
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
      :network,
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

  def csv_import_params
    params.require(:ad_test).permit(:app_id, :csv, :network)
  end
end
