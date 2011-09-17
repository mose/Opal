module ItemsHelper
  def preview(item, options = {}) # show preview of item
    options[:size] ||= "normal" 
    
    preview_record = item.preview
    content_tag (options[:size] == "pinky" ? :span : :div), :class => "preview preview_#{options[:size].to_s}" do 
      if preview_record && preview_record.is_approved?
          render :partial => "#{preview_record.class.name.pluralize.underscore}/preview", :locals => {:record => preview_record, :item => item, :options => options } # rescue nil
      else # no preview found 
          render :partial => "items/preview_not_found", :locals => {:item => item, :options => options } #rescue nil
      end      
    end
  end 
  
  def item_thumbnail(item, options = {})   
      # set defaults
      options[:preview] = false if options[:preview].nil? 
      options[:class] ||= "thumbnail"
      
      if !item.nil? # item exists
        if item.preview_type == PluginImage.name
           plugin_image_thumbnail(item.preview, options)
        elsif  item.preview_type == PluginVideo.name
           theme_image_tag("preview_video.png", :class => options[:class])
        else # some other preview type
           theme_image_tag("preview.png", :class => options[:class])
        end     
      else # item doesn't exist
        return raw "<img src=\"/themes/#{@setting[:theme]}/images/icons/failure.png\" class=\"icon\" title=\"#{Item.model_name.human} cannot be found.\">"      
      end 
  end

  def link_to_item(item, options = {})
    options[:preview] = false   if options[:preview].nil?
    options[:name]    = true    if options[:name].nil?
    link = Array.new
    link << preview(item, :size => "pinky") if options[:preview] 
    link << link_to(item.name, {:action => "view", :controller => "items", :id => item}, :title => item.name) if options[:name]  
    return link.join(" ") 
  end        
end 