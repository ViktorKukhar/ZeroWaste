# frozen_string_literal: true

class Api::V1::DiaperCalculatorsController < ApplicationController
  include LanguageHelpers::UkrLanguage

  def create
    result          = Calculators::DiapersService.new(params[:childs_age].to_i)
                                                 .calculate!
    diapers_be_used = correct_word_form(result.to_be_used_diapers_amount)
    diapers_used    = correct_word_form(result.used_diapers_amount)
    values          = [
      { name: "money_spent", result: result.used_diapers_price || 0 },
      { name: "money_will_be_spent",
        result: result.to_be_used_diapers_price || 0 },
      { name: "used_diapers_amount",
        result: result.used_diapers_amount || 0 },
      { name: "to_be_used_diapers_amount",
        result: result.to_be_used_diapers_amount || 0 }
    ]

    render(
      json: {
        result: values,
        date: params[:childs_age].to_i,
        word_form_to_be_used: diapers_be_used,
        word_form_used: diapers_used
      }
    )
  end
end
