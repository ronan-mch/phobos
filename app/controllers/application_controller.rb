class ApplicationController < ActionController::Base
  protect_from_forgery


  before_filter :set_locale

  # if no locale is set, will default to default_locale (i.e. en)
  def set_locale
    I18n.locale = params['umlaut.locale'.to_sym] || I18n.default_locale
  end

  # ensure locale is always included in any internal links
  def default_url_options(options={})
    { 'umlaut.locale'.to_sym => I18n.locale }
  end
end
