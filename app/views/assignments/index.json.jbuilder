json.array!(@assignments) do |assignment|
  json.extract! assignment, :id, :cmd, :exp_id
  json.url assignment_url(assignment, format: :json)
end
