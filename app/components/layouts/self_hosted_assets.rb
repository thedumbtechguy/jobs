# Plutonium's layouts pull the form widget libraries (EasyMDE, SlimSelect,
# Flatpickr, intl-tel-input, Uppy styles) from jsdelivr. We bundle them into
# application.js/css instead, so skip the CDN tags.
module Layouts
  module SelfHostedAssets
    private

    def render_external_styles
    end

    def render_external_scripts
    end
  end
end
