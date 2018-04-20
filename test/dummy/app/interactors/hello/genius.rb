class Hello::Genius < Methodist::Interactor
  
  # See http://dry-rb.org/gems/dry-validation/ for syntax of validations
  set_schema do
    # required(:name).value(:str?)
  end
  
  step :validate

end