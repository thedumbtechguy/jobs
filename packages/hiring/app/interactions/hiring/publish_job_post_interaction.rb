module Hiring
  class PublishJobPostInteraction < JobPostTransitionInteraction
    presents label: "Publish", icon: Phlex::TablerIcons::Send, description: "Make this job visible to developers"
    self.transition = :publish!
    self.success_message = "Job published. It stays live for #{Hiring::JobPost::VALIDITY_PERIOD.inspect}."
  end
end
