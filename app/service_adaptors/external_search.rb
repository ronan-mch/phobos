class ExternalSearch < Service
  include MetadataHelper

  def initialize(config)
    super(config)
  end

  def handle(request)
    # pull title out of request and insert into search url
    title = URI.encode(get_search_title(request.referent))
    search_url = @url.gsub('%{keyword}', title) # using local var due to strange bug when using instance var
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
