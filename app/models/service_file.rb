class ServiceFile < ActiveRecord::Base
  belongs_to :service, :class_name => "Service", :foreign_key => "service_id"

  def self.save(data, insert)
    #name =  upload[:file_url].original_filename
    directory = "public/images/deliverables"
    # create the file path
    #name = name+Time.now.to_s
    #name.sub(/[^\w\.\-]/,'_')
    #path = File.join(directory,name)

    # write the file
    #File.open(path, "wb") { |f| f.write(upload[:file_url].original_filename) }
    # retrieve the filename from the file object
    unless data[:file_url].nil?
      fullname = data[:file_url].original_filename

# get only the filename, not the whole path (from IE)
      name = File.basename(fullname)

# replace all none alphanumeric, underscore or periods
# with underscore
      name.sub(/[^\w\.\-]/, '_')

# store the original filename in the insert object and storing other info
#insert.file_name = name
      insert.file_content_type = data[:file_url].content_type
      insert.file_size = data[:file_url].size
      insert.file_name = (1 + rand(999999999)).to_s << '.' << name # set the storage directory directory = "/tmp/file/uploads"

# write to the file system
      path = File.join(directory, insert.file_name)
      File.open(path, "wb") { |f| f.write(data[:file_url].read) }
      if insert.save
        #do nothing
      else
        #print on log
        Rails.logger.error { "The file could not be uploaded" }
      end
    end
  end
end
