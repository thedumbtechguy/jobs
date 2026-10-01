module Forms
  class CompanySetupForm < BaseForm
    def form_template
      div(class: "space-y-6") do
        fields_wrapper do
          text :name, span: true
          url :website
          text :city
          text :country
        end
        render_actions
      end
    end
  end
end
