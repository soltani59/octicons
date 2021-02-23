require "octicons"
require "action_view"

module OcticonsHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::AssetUrlHelper

  mattr_accessor :octicons_helper_cache, default: {}

  def octicon(symbol, options = {})
    return "" if symbol.nil?

    cache_key = [symbol, options]

    if tag = octicons_helper_cache[cache_key]
      tag
    else
      icon = Octicons::Octicon.new(symbol, options)

      content = if options[:use_markup]
        content_tag(:use, nil, href: "#{image_path('octicons-sprite.svg')}##{symbol}")
      else
        icon.path.html_safe
      end

      tag = content_tag(:svg, content, icon.options).freeze # rubocop:disable Rails/OutputSafety
      octicons_helper_cache[cache_key] = tag
      tag
    end
  end
end
