module FormatWriter

  def render_xml(hash)
    render xml: write_xml(hash)
  end

  def write_xml(response)
    Nokogiri::XML::Builder.new { |xml|  hash_to_xml(response, xml) }
  end

  #Recursive function to convert hash to xml
  #args: hash containing only String or hash values
  #xml Nokogiri xml builder object
  def hash_to_xml(hash, xml)
    hash.each do |key, value|
      if value.is_a? String
        xml.send(key, value)
      elsif value.is_a? Hash
        xml.send(key.to_s) { hash_to_xml(value, xml) }
      end
    end
    xml
  end

  def render_json(response, callback)
    render json: response, :callback => callback
  end
end