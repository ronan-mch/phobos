require 'test_helper'

class TrafiklysControllerTest < ActionController::TestCase

  OPEN_URL = 'url_ver=Z39.88-2004&&ctx_ver=Z39.88-2004&ctx_tim=2013-07-03T15:14:49+02:00&ctx_id=&ctx_enc=info:ofienc:UTF-8&rft.jtitle=publishers weekly&rft_val_fmt=info:ofifmt:kev:mtx:journal&rft.object_id=954921336066&rft.date=1900'

  test 'should get lookUp' do
    get :look_up
    assert_response :success
  end

  # ipen har ikke remote adgang, derfor er walkin adgang false.
  # Brugeren er ikke logget ind. Svaret er derfor "maybe".
  test 'should get maybe' do
    get :look_up, {:open_url => OPEN_URL, :ip_address => '10.22', :format => 'json'}
    assert_response :success
    response = MultiJson.load(@response.body)

    assert_equal('false', response['trafiklys']['response']['walkinAccess'])
    assert_equal('false', response['trafiklys']['response']['remoteAccess'])
    assert_equal('maybe', response['trafiklys']['response']['access'])
  end

  # Brugeren er logget ind, ipen har ikke remote adgang, men instituttet har adgang.
  # Remote adgang og adgang er derfor "yes". Walkin adgang er false.
  test 'should_get_yes_inst' do
    get :look_up, {:open_url => OPEN_URL, :ip_address => '10.22',
                   :institute => 'KB', :format => 'json'}

    response = MultiJson.load(@response.body)

    assert_equal('false', response['trafiklys']['response']['walkinAccess'])
    assert_equal('true', response['trafiklys']['response']['remoteAccess'])
    assert_equal('yes', response['trafiklys']['response']['access'])
  end

  # Brugeren er ikke logget ind men ipen har walkin adgang.
  # Adgang er derfor "yes".
  test 'should_get_yes_ip' do
    get :look_up, {:open_url => OPEN_URL, :ip_address => '10.226.6.0',
                   :format => 'json'}

    response = MultiJson.load(@response.body)

    assert_equal('true', response['trafiklys']['response']['walkinAccess'])
    assert_equal('false', response['trafiklys']['response']['remoteAccess'])
    assert_equal('yes', response['trafiklys']['response']['access'])
  end

  # Brugeren er logget ind, ipen har ikke walkin adgang,
  # Adgang er derfor "no".
  test 'should_get_no' do
    get :look_up, {:open_url => OPEN_URL, :ip_address => '10.226',
                   :institute => 'RA18', :format => 'json'}

    response = MultiJson.load(@response.body)

    assert_equal('false', response['trafiklys']['response']['walkinAccess'])
    assert_equal('false', response['trafiklys']['response']['remoteAccess'])
    assert_equal('no', response['trafiklys']['response']['access'])
  end

  test 'should_get_ip' do
    get :get_ip
    response = MultiJson.load(@response.body)
    assert_equal('0.0.0.0', response['ip'] )
  end


end
