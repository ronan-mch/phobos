class TrafiklysController < ApplicationController
  include FormatWriter

  #take openUrl parameter, parse and query RSI
  def look_up
    init_service
    check_remote_access
    check_walkin_access
    check_access
    write_response
  end

  #if we have an institute && remote access is false
  # then access is no
  #if we don't have an institute && remote access is false
  # and KB_PROXY has access true then access is maybe
  #otherwise it's no
  def check_access
    @access = @remote_access ? 'yes' : 'no'
    unless @remote_access || !params['institute'].nil?
      @service.institute="KB_PROXY"
      @service.handle(@user_request)
      potential_access = @service.fulltext_found
      @access = 'maybe' if potential_access
    end
  end


  #check for access with our given params
  def check_remote_access
    @service.ip= params['ip_address']
    @service.institute= params['institute']
    #send it out
    @service.handle(@user_request)
    @remote_access = @service.fulltext_found
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

  #check for access for KB user
  #set to true if we have remote access
  def check_walkin_access
    @walkin_access = @remote_access
    unless @remote_access
      @service.institute="KB"
      @service.handle(@user_request)
      @walkin_access = @service.fulltext_found
    end
  end

  def render_error
    item = {}
    item[:response] = {}
    item[:response][:serviceStatus] = "error_in_request"
    item[:response][:serviceMessage] = "Incorrect parameters - see API docs for full details"
    #see comment below
    format_response({:trafiklys => item})
  end

  def format_response(response_hash)
    @format == 'json' ? render_json(response_hash) : render_xml(response_hash)
  end

  #build response hash and render either xml or json
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
  def hello
  end
end
