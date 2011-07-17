# Support class & instance methods for Plugin Classes(Not the Actual Plugin Class) like PluginImage, PluginComment, etc.=
module Opal
  module ActsAsOpalPlugin       
    module ClassMethods              
      def item(item)
        where("item_id = ?", item.id)
      end
      
      def approved
         where("is_approved = ?", "1")
      end
      
      def plugin # get plugin record for this class
        Plugin.where("name = ?", system_name).first
      end
      
      def system_name # the plain, system name of the plugin, ie: Image
        name.gsub("Plugin", "")
      end  
      
      def get_setting(name)
        plugin.get_setting(name)
      end
      
      def get_setting_bool(name)
        plugin.get_setting_bool(name)
      end 
      
      def installed? # has this plugin been installed?
        table_exists?
      end
      
    end
    
    module InstanceMethods
      def after_create # called after a plugin record/item is created
        if self.class == Setting.get_global_settings[:default_preview_type] # if this plugin is set as the default preview class...
            item.update_attributes(:preview_type => self.class.name, :preview_id => id) if !item.preview? # set self as preview if no preview exists
        end 
      end
      
      def is_approved?
         self.is_approved == "1" if respond_to?(:is_approved) 
      end   
    end
    
    def self.included(base) # automatically called when included
      base.send(:extend, ClassMethods)
      base.send(:include, InstanceMethods)
      base.send(:after_create, :after_create)
    end
  end
end 