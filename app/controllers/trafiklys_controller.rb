class TrafiklysController < ApplicationController
  include FormatWriter

  #take openUrl parameter, parse and query RSI
  def look_up
    init_service
    get_params
    check_remote_access
    check_walkin_access
    check_access
    write_response
  end

  def get_params
    @ip = params['ip_address']
    if params.has_key?("institute")
      @logged_in = true
      @institute = params['institute']
    end
  end

  #remote access defines access for the user credentials
  #if user is logged in - check access for their institute
  #if not - check for access without institute (e.g. open access)
  def check_remote_access
    @service.institute= @institute if @logged_in
    @service.handle(@user_request)
    @remote_access = @service.fulltext_found
  end

  #walkin access defines access for the current user location
  #remove institute info and send user's ip address
  def check_walkin_access
    @service.reset
    @service.ip= @ip
    @service.handle(@user_request)
    @walkin_access = @service.fulltext_found
  end

  # if we have remote access or walkin access, then we have access
  # else
  #   if user is logged in, then access is false  - i.e. we know they don't have access
  #   if user is not logged in, then access is maybe - i.e. we can't tell if they have access or not

  def check_access
    if @walkin_access || @remote_access
      @access = 'yes'
    elsif @logged_in
       @access = 'no'
    else
      @access = 'maybe'
    end
  end

  #create service and parse openUrl
  def init_service
    @service = SfxRsi.new(ServiceStore.service_definition_for('SFXRSI'))
    #initialize the request using our openUrl
    @user_request ||= PhobosRequest.find_or_create(
        params, session, request, {}, params['open_url']
    )
    @format = params['format']
    render_error unless @user_request
  end


  #build error hash and send to format renderer
  def render_error
    item = {}
    item[:response] = {}
    item[:response][:serviceStatus] = "error_in_request"
    item[:response][:serviceMessage] = "Incorrect parameters - see API docs for full details"

    format_response({:trafiklys => item})
  end

  #render json if specified in url - else render xml
  def format_response(response_hash)
    @format == 'json' ? render_json(response_hash) : render_xml(response_hash)
  end

  #build response hash and send to format renderer
  def write_response
    item = {}
    item[:response]= {}
    item[:response][:serviceStatus] = @service.status_ok ? "service_ok" : "service_down"
    item[:response][:serviceMessage] = @service.message unless @access
    item[:response][:walkinAccess] = @walkin_access.to_s
    item[:response][:remoteAccess] = @remote_access.to_s
    item[:response][:access] = @access

    format_response({:trafiklys => item})
  end

  def params
    @_params ||= request.parameters
  end

end
