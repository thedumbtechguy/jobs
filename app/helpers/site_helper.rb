require "redcarpet"

module SiteHelper
  MARKDOWN = Redcarpet::Markdown.new(
    Redcarpet::Render::HTML.new(filter_html: true, no_images: true, no_styles: true, safe_links_only: true, link_attributes: {rel: "nofollow noopener", target: "_blank"}),
    autolink: true, no_intra_emphasis: true, strikethrough: true, lax_spacing: true
  )

  # User-written markdown (bios, job descriptions). Raw HTML is stripped and the
  # result sanitized again, so nothing a user types can inject markup.
  def render_markdown(text)
    return if text.blank?

    sanitize(MARKDOWN.render(text), tags: %w[p br strong em del a ul ol li h1 h2 h3 h4 blockquote code pre hr],
      attributes: %w[href rel target])
  end

  AVAILABILITY = {
    "looking" => ["Open to work", "bg-[#dcfce7] text-[#166534]"],
    "open" => ["Open to offers", "bg-[#e0f2fe] text-[#075985]"],
    "not_looking" => ["Not looking", "bg-[#efebdd] text-[#555]"]
  }.freeze

  def availability_pill(profile)
    label, classes = AVAILABILITY.fetch(profile.availability)
    tag.span(label, class: "shrink-0 rounded-full px-2.5 py-0.5 text-xs font-semibold #{classes}")
  end

  def pill(text, extra = nil)
    tag.span(text, class: "rounded-full border border-[#e0ddd4] bg-[#f5f2e8] px-2.5 py-0.5 text-xs #{extra}")
  end

  # Keep the current filters when building filter/pagination links.
  def filter_params(**overrides)
    request.query_parameters.symbolize_keys.except(:page).merge(overrides).compact_blank
  end

  def select_options(choices, selected)
    options_for_select(choices, selected)
  end
end
