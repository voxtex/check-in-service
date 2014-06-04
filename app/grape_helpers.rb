module GrapeHelpers
  def permitted_params
    declared(params, include_missing: false)
  end
end