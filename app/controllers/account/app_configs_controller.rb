# frozen_string_literal: true

class Account::AppConfigsController < Account::BaseController
  load_and_authorize_resource

  def edit
    @app_config = AppConfig.instance
    @price_id = params[:price_id] || "1"
    @price_id_hash = AppConfig.instance.diapers_calculator[@price_id]
  end

  def update
    puts "=" * 100
    puts "params: #{params}"

    @app_config = AppConfig.instance
    @app_config.update_diapers_calculator(diapers_calculator_params)
  end

  private

  def diapers_calculator_params
    params.permit([
      :first_amount, :first_price, :second_amount, :second_price, :third_amount,
      :third_price, :fourth_amount, :fourth_price, :fifth_amount, :fifth_price,
      :sixth_amount, :sixth_price, :seventh_amount, :seventh_price
    ])
  end
end
