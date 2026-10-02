# Idempotent: safe to run on every deploy (bin/rails db:seed).

# The skills developers pick for their profiles and projects' stacks. Admins can
# add more from the admin portal.
SKILLS = [
  # Languages
  "JavaScript", "TypeScript", "Python", "Ruby", "PHP", "Java", "Kotlin", "Swift", "Objective-C",
  "Go", "Rust", "C", "C++", "C#", "Dart", "Elixir", "Erlang", "Scala", "Clojure", "Haskell",
  "R", "Julia", "Lua", "Perl", "Solidity", "SQL", "Bash", "PowerShell", "HTML", "CSS",
  # Frontend
  "React", "Next.js", "Vue.js", "Nuxt", "Angular", "Svelte", "SvelteKit", "Solid", "Remix", "Astro",
  "jQuery", "Alpine.js", "Hotwire", "Stimulus", "htmx", "Redux", "Tailwind CSS", "Bootstrap", "Sass",
  "Vite", "Webpack",
  # Backend frameworks
  "Node.js", "Express", "NestJS", "Fastify", "Deno", "Bun", "Ruby on Rails", "Sinatra", "Django",
  "Flask", "FastAPI", "Laravel", "Symfony", "WordPress", "Spring Boot", "ASP.NET", ".NET",
  "Phoenix", "Gin", "Actix",
  # Mobile
  "Android", "iOS", "Flutter", "React Native", "Jetpack Compose", "SwiftUI", "Ionic", "Expo",
  # Data stores
  "PostgreSQL", "MySQL", "SQLite", "SQL Server", "Oracle", "MongoDB", "Redis", "Elasticsearch",
  "Cassandra", "DynamoDB", "Firebase", "Supabase",
  # APIs and messaging
  "REST", "GraphQL", "gRPC", "WebSockets", "Kafka", "RabbitMQ",
  # Cloud and DevOps
  "AWS", "Google Cloud", "Azure", "DigitalOcean", "Heroku", "Vercel", "Netlify", "Cloudflare",
  "Docker", "Kubernetes", "Terraform", "Ansible", "Linux", "Nginx", "Git", "GitHub Actions",
  "GitLab CI", "CI/CD", "Prometheus", "Grafana",
  # Data, ML and AI
  "Pandas", "NumPy", "scikit-learn", "TensorFlow", "PyTorch", "Machine Learning", "Deep Learning",
  "Data Analysis", "Data Engineering", "Apache Spark", "Airflow", "dbt", "Power BI", "Tableau",
  "LLMs", "Computer Vision", "NLP",
  # Testing
  "Jest", "Vitest", "Cypress", "Playwright", "Selenium", "RSpec", "Minitest", "pytest", "JUnit",
  # Payments and integrations
  "Stripe", "Paystack", "Flutterwave", "Mobile Money", "USSD", "Twilio",
  # Other
  "Blockchain", "Web3", "Unity", "Game Development", "Embedded Systems", "IoT", "Arduino",
  "Cybersecurity", "UI/UX Design", "Figma", "Technical Writing", "Agile", "Scrum",
  "Product Management", "Project Management"
].freeze

existing = Skill.pluck(:name).map(&:downcase).to_set
SKILLS.each do |name|
  Skill.create!(name:) unless existing.include?(name.downcase)
end
