# frozen_string_literal: true

module Api
  module V1
    class DiaperCalculatorsController < ApplicationController
      def diaper_calc_communicator
        result = Calculators::DiapersService.new(params[:childs_age]).calculate!
        diapers_be_used = diapers_correct_form(result.to_be_used_diapers_amount)
        diapers_used = diapers_correct_form(result.used_diapers_amount)
        values = {
          money_spent: result.used_diapers_price || 0,
          money_will_be_spent: result.to_be_used_diapers_price || 0,
          used_diapers_amount: result.used_diapers_amount || 0,
          to_be_used_diapers_amount: result.to_be_used_diapers_amount || 0
        }
        render(json: { result: values, date: params[:childs_age].to_i,
                       word_form_to_be_used: diapers_be_used,
                       word_form_used: diapers_used })
      end

      private

      def diapers_correct_form(quantity)
        LanguageHelper::UkrLanguage.new.correct_word_form(quantity)
      end
    end
  end
end
