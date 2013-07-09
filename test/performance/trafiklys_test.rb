require 'test_helper'
require 'rails/performance_test_help'

#map.root :controller => 'trafiklys'

class TrafiklysTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { :runs => 5, :metrics => [:wall_time, :memory]
  #                          :output => 'tmp/performance', :formats => [:flat] }

  OPEN_URL = 'url_ver=Z39.88-2004&&ctx_ver=Z39.88-2004&ctx_tim=2013-07-03T15:14:49+02:00&ctx_id=&ctx_enc=info:ofienc:UTF-8&rft.jtitle=publishers weekly&rft_val_fmt=info:ofifmt:kev:mtx:journal&rft.object_id=954921336066&rft.date=1900'
  def test_maybe
    get 'trafiklys/lookUp', {:open_url => OPEN_URL, :ip_address => '10.22' }
  end

  def test_yes_inst
    get 'trafiklys/lookUp', {:open_url => OPEN_URL, :ip_address => '10.22', :institute => 'KB'}
  end

  def test_yes_ip
    get 'trafiklys/lookUp', {:open_url => OPEN_URL, :ip_address => '10.226.6.0', :institute => 'KB'}
  end

  def test_no
    get 'trafiklys/lookUp', {:open_url => OPEN_URL, :ip_address => '10.22', :institute => 'RA18'}
  end


end
