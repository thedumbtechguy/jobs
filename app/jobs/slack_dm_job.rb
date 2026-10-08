# Sends a SlackDm. Errors such as user_not_found or account_inactive mean the
# person left the workspace or was deactivated. Their identity stays linked
# in case they come back.
class SlackDmJob < ApplicationJob
  queue_as :default

  # The record was deleted before sending (e.g. an unfollow).
  discard_on ActiveJob::DeserializationError
  discard_on Slack::Error do |job, error|
    Rails.logger.warn { "#{job.arguments.first} not sent: #{error.code}" }
  end
  # rescue_from RateLimited must come after discard_on Slack::Error so it takes precedence.
  rescue_from(Slack::RateLimited) { |error| retry_job(wait: error.retry_after.seconds) }
  retry_on(*Slack::NETWORK_ERRORS, wait: :polynomially_longer, attempts: 5)

  def perform(class_name, **params)
    class_name.constantize.new(**params).deliver_now
  end
end
