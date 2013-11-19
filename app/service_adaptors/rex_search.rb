class RexSearch < ExternalSearch

  # special parsing method to ensure Rex link is rendered properly
  def get_search_url(identifier, title)
    search_url = @url.gsub('%{title}', URI.encode(title)) # using local var due to strange bug when using instance var
    search_url.gsub!('%{issn/isbn}', identifier)
    if title.length > 0 && identifier.length > 0
      search_url.gsub!('%{+OR+}(', '+OR+(')
      search_url.gsub!('%)', ')')
    else
      search_url.gsub!('%{+OR+}(', '')
      search_url.gsub!('%)', '')
    end

    search_url
  end

end