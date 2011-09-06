class XmlFileDownload < ActiveRecord::Base

  def download
    require 'open-uri'

      self.path = "#{RAILS_ROOT}/tmp/#{DateTime.new.to_i.to_s}.xml"
      save
      writeOut = open(self.path, "wb")
      writeOut.write(open(self.url).read)
      writeOut.close

  end
end
