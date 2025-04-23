# filepath: config/initializers/simple_form_tailwind.rb
SimpleForm.setup do |config|
  config.wrappers :default, class: "mb-4", error_class: "has-error" do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: "block text-sm font-medium text-gray-700"
    b.use :input, class: "mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md"
    b.use :error, wrap_with: { tag: :span, class: "text-red-500 text-xs italic" }
    b.use :hint, wrap_with: { tag: :p, class: "text-gray-500 text-xs italic" }
  end
  config.default_wrapper = :default
end