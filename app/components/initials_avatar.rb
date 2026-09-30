# A local avatar: initials on a colour picked deterministically from the seed.
# Used for developer profiles and companies until they can upload images.
class InitialsAvatar < Plutonium::UI::Component::Base
  SIZES = {
    sm: "h-8 w-8 text-xs",
    md: "h-10 w-10 text-sm",
    lg: "h-14 w-14 text-lg",
    xl: "h-20 w-20 text-2xl"
  }.freeze

  COLORS = %w[
    bg-primary-600 bg-sky-600 bg-emerald-600 bg-amber-600
    bg-rose-600 bg-violet-600 bg-teal-600 bg-fuchsia-600
  ].freeze

  def initialize(name:, seed: name, size: :md, shape: :circle, **attributes)
    @name = name.to_s
    @seed = seed.to_s
    @size = size
    @shape = shape
    @attributes = attributes
  end

  def view_template
    span(
      **@attributes,
      class: tokens(
        "inline-flex shrink-0 select-none items-center justify-center font-semibold text-white",
        SIZES.fetch(@size),
        color,
        (@shape == :square) ? "rounded-[var(--pu-radius-lg)]" : "rounded-full",
        @attributes[:class]
      ),
      aria_hidden: "true"
    ) { initials }
  end

  private

  def initials
    words = @name.split(/\s+/).reject(&:blank?)
    letters = (words.size > 1) ? words.first(2).map { |w| w[0] } : @name.first(2).chars
    letters.join.upcase.presence || "?"
  end

  def color
    COLORS[Zlib.crc32(@seed) % COLORS.size]
  end
end
