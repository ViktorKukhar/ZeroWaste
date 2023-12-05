if Flipper::Adapters::ActiveRecord::Feature.table_exists?
  require "flipper/adapters/active_record"

  require_relative "flipper_feature"

  Flipper.configure do |config|
    config.default do
      Flipper.new(Flipper::Adapters::ActiveRecord.new)
    end
  end

  Flipper.features.each do |feature|
    next if Flipper.enabled?(:sandbox_mode)
    Flipper.enable(feature.name) if Rails.env.development? # || Rails.env.staging?
  end

  Flipper.remove(:sandbox_mode) if Rails.env.production?
end
