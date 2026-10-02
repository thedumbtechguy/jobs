return if ENV["SECRET_KEY_BASE_DUMMY"].present?

# In development/test, only check if dotenv is loaded (process may not have reloaded yet)
return if Rails.env.local? && !defined?(Dotenv)

# Needed everywhere: mailer and route URLs are built from it.
required_env_vars = %w[
  RAILS_DEFAULT_URL
]

if Rails.env.production?
  required_env_vars += %w[
    SECRET_KEY_BASE
    ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY
    ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY
    ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT
  ]

  # Email: account verification, password resets, invites and job review all depend on it.
  required_env_vars += %w[
    RESEND_API_KEY
  ]

  # Backups: the Litestream accessory replicates the SQLite files to this bucket.
  required_env_vars += %w[
    LITESTREAM_REPLICA_BUCKET
    LITESTREAM_ACCESS_KEY_ID
    LITESTREAM_SECRET_ACCESS_KEY
  ]
end

missing = required_env_vars.select { |env_var| ENV[env_var].blank? }

if missing.any?
  raise <<~EOL
    Missing required environment variables: #{missing.join(", ")}

    See the Deploy section of the README for what each one is for.
  EOL
end
