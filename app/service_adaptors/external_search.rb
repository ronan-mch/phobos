class ExternalSearch < Service
  include MetadataHelper

  def initialize(config)
    super(config)
  end

  def handle(request)
    # pull title out of request and insert into search url
    title = URI.encode(get_search_title(request.referent))
    issn = get_issn(request.referent)
    isbn = get_isbn(request.referent)
    identifier = issn || isbn
    search_url = @url.gsub('%{title}', title) # using local var due to strange bug when using instance var
    search_url.gsub!('%{issn/isbn}', identifier)
    request.add_service_response(
        :service => self,
        :service_type_value => 'highlighted_link',
        :display_text => @display_text,
        :url => search_url
    )

    request.dispatched(self, true)
  end


  def service_types_generated
    [ServiceTypeValue['highlighted_link']]
  end
end
