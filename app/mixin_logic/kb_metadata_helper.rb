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

  # pick title out of OpenURL referent from best element available,
  # no normalization.
  def raw_search_title(rft)
    # Just make one call to create metadata hash
    metadata = rft.metadata
    title = nil
    if rft.format == 'journal' && metadata['atitle']
      title = metadata['atitle']
    elsif rft.format == 'book'
      title = metadata['btitle'] unless metadata['btitle'].blank?
      title = metadata['title'] if title.blank?
      # Well, if we don't know the format and we do have a title use that.
      # This might happen if we only have an ISBN to start and then enhance.
      # So should services like Amazon also enhance with a format, should
      # we simplify this method to not worry about format so much, or do we
      # keep this as is?
    elsif metadata['btitle'] && metadata['btitle'].length > 0
      title = metadata['btitle']
    elsif metadata['title'] && metadata['title'].length > 0
      title = metadata['title']
    elsif metadata['jtitle'] && metadata['jtitle'].length > 0
      title = metadata['jtitle']
    end
    title
  end

end