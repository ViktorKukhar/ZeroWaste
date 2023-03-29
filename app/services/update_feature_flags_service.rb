class UpdateFeatureFlagsService
  def initialize(params)
    @feature_params = params
  end

  def call
    Flipper.features.each do |feature|
      feature_name = feature.name
      is_enabled = @feature_params["#{feature_name}_enabled"].to_s == "1"

      Flipper.send("#{is_enabled ? 'enable' : 'disable'}", feature_name)
    end
  end
end
