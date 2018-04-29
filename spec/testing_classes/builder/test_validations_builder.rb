class TestValidationsBuilder < Methodist::Builder
  field :title, ->(val) { val.is_a?(String) }
end