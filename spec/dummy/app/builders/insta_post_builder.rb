class InstaPostBuilder < Methodist::Builder
  fields :title, :author do |value|
    value.is_a?(String)
  end
end