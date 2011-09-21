class PluginFile < ActiveRecord::Base
  acts_as_opal_plugin

  mount_uploader :file, ::FileUploader

  belongs_to :plugin
  belongs_to :user
  
  after_destroy :delete_files
  
  def to_s
    get_title	
  end
  
  def to_param # make custom parameter generator for seo urls, to use: pass actual object(not id) into id ie: :id => object
    # this is also backwards compatible with regular integer id lookups, since .to_i gets only contiguous numbers, ie: "4-some-string-here".to_i # => 4    
    "#{id}-#{self.get_title.gsub(/[^a-z0-9]+/i, '-')}" 
  end  
  
  def get_title # get the title of the file, either bare filename or user-inputted 
    self.title? ? self.title : filename.blank? ? "" : filename
  end
  
  def delete_files
    FileUtils.rmdir(File.dirname(file.path)) if !file.path.blank? && File.exists?(File.dirname(file.path))  # remove CarrierWave store dir, must be empty to work
  end
  
  def filename
    file.path.blank? ? "" : File.basename(file.path)  
  end  
end
