class ExternalSearch < Service
  include KbMetadataHelper

  def initialize(config)
    super(config)
  end

  def handle(request)
    # pull title out of request and insert into search url
    title = get_search_title(request.referent) || ''
    identifier = get_identifier_for_search
    search_url = get_search_url(identifier, title)

    request.add_service_response(
        :service => self,
        :service_type_value => 'highlighted_link',
        :display_text => @display_text,
        :url => search_url
    )

    request.dispatched(self, true)
  end

  def get_search_url(identifier, title)
    search_url = @url.gsub('%{title}', URI.encode(title)) # using local var due to strange bug when using instance var
    search_url.gsub!('%{issn/isbn}', identifier)
    search_url
  end


  def service_types_generated
    [ServiceTypeValue['highlighted_link']]
  end
end
