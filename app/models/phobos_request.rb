#overrides Request locally for sake of trafiklys controller
#where query_string is not defined
class PhobosRequest < Request
  # Either creates a new Request, or recovers an already created Request from
  # the db--in either case return a Request matching the OpenURL.
  # options[:allow_create] => false, will not create a new request, return
  # nil if no existing request can be found.
  def self.find_or_create(params, session, a_rails_request, options = {}, query_string = nil )

    # Pull out the http params that are for the context object,
    # returning a CGI::parse style hash, customized for what
    # ContextObject.new_from_form_vars wants.
    co_params = self.context_object_params( a_rails_request, query_string )

    # Create a context object from our http params
    context_object = OpenURL::ContextObject.new_from_form_vars( co_params )
    # Sometimes umlaut puts in a 'umlaut.request_id' parameter.
    # first look by that, if we have it, for an existing request.
    request_id = params['umlaut.request_id']

    # We're trying to identify an already existing response that matches
    # this request, in this session.  We don't actually match the
    # session_id in the cache lookup though, so background processing
    # will hook up with the right request even if user has no cookies.
    # We don't check IP change anymore either, that was too open to
    # mistaken false negative when req.ip was being used.
    req = Request.find_by_id(request_id) unless request_id.nil?

    # No match?  Just pretend we never had a request_id in url at all.
    request_id = nil if req == nil

    # Serialized fingerprint of openurl http params, suitable for looking
    # up in the db to see if we've seen it before. We got our co_params
    # direct from parsing path ourselves, but in case a before_filter
    # added in certain other params after that, we want to merge them in
    # too.
    fingerprintable_params = co_params.merge(
        {"umlaut.service_group" => params["umlaut.service_group"]}.delete_if {|k, v| v.blank?}
    )
    param_fingerprint = self.co_params_fingerprint( fingerprintable_params )

    client_ip = params['req.ip'] || a_rails_request.remote_ip()

    unless (req || params["umlaut.force_new_request"] == "true" || param_fingerprint.blank? )
      # If not found yet, then look for an existing request that had the same
      # openurl params as this one, in the same session. In which case, reuse.
      # Here we do require same session, since we don't have an explicit
      # request_id given.
      req = Request.where(
          :session_id => a_rails_request.session_options[:id],
          :contextobj_fingerprint => param_fingerprint,
          :client_ip_addr => client_ip ).
          order("created_at DESC, id DESC").first
    end

    # Okay, if we found a req, it might NOT have a referent, it might
    # have been purged. If so, create a new one.
    if ( req && ! req.referent )
      req.referent = Referent.create_by_context_object(context_object)
    end

    unless (req || options[:allow_create] == false)
      # didn't find an existing one at all, just create one

      req = self.create_new_request!( :params => params, :session => session, :rails_request => a_rails_request, :contextobj_fingerprint => param_fingerprint, :context_object => context_object )
    end
    return req
  end

  # input is a Rails request (representing http request)
  # We pull out a hash of request params (get and post) that
  # define a context object. We use CGI::parse instead of relying
  # on Rails parsing because rails parsing ignores multiple params
  # with same key value, which is legal in CGI and is sometimes used in OpenURLs.
  #
  # So in general values of this hash will be an array.
  # ContextObject.new_from_form_vars is good with that.
  # Exception is url_ctx_fmt and url_ctx_val, which we'll
  # convert to single values, because ContextObject wants it so.
  def self.context_object_params(a_rails_request, query_string = nil)
    # GET params

    #custom handling for trafficlight use case
    #since we don't have a query_string in that case
    query_string ||= a_rails_request.query_string
    co_params = CGI::parse(query_string)

    # add in the POST params please
    co_params.merge!(  CGI::parse(a_rails_request.raw_post)) if a_rails_request.raw_post
    # default value nil please, that's what ropenurl wants
    co_params.default = nil

    # CGI::parse annoyingly sometimes puts a nil key in there, for an empty
    # query param (like a url that has two consecutive && in it). Let's get rid
    # of it please, only confuses our code.
    co_params.delete(nil)

    # Exclude params that are for Rails or Umlaut, and don't belong to the
    # context object. Except leave in umlaut.* keys that DO matter for
    # cacheability, like umlaut.institution (legacy) and umlaut.service_group
    excluded_keys = ["action", "controller", "page", /\Aumlaut\.(?!(institution|service_group\[\])\Z)/, 'rft.action', 'rft.controller']
    co_params.keys.each do |key|
      excluded_keys.each do |exclude|
        co_params.delete(key) if exclude === key;
      end
    end
    # 'id' is a special one, cause it can be a OpenURL 0.1 key, or
    # it can be just an application-level primary key. If it's only a
    # number, we assume the latter--an openurl identifier will never be
    # just a number.
    if co_params['id']
      co_params['id'].each do |id|
        co_params['id'].delete(id) if id =~ /^\d+$/
      end
    end
    return co_params
  end
end