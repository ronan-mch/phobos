# includes some helper methods for our ExternalSearch class
module KbMetadataHelper
  include MetadataHelper

  def get_eissn(rft)
    eissn = rft.metadata['eissn']
    eissn = nil unless eissn =~ /\d{4}(-)?\d{4}/
    eissn
  end

  def get_identifier_for_search
    issn = get_issn(request.referent)
    eissn = get_eissn(request.referent)
    isbn = get_isbn(request.referent)
    issn || eissn || isbn || ''
  end

end