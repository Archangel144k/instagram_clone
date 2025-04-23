# Define custom inflection for "save"
ActiveSupport::Inflector.inflections(:en) do |inflect|
    inflect.irregular 'save', 'saves'
end