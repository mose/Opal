require 'spec_helper'

describe PluginImagesController do  
  render_views
  
  describe "as admin" do
    before(:each) do
      login_admin
    end 
  
    describe "create" do 
      it "should work without a record" do
        expect{
          uploaded_file = fixture_file_upload(Rails.root.join('spec/fixtures/images/rails.png'), "image/png")       
          post(:create, {:plugin_image => {:image => uploaded_file}})
          flash[:success].should_not be_nil
        }.to change(PluginImage, :count).by(+1)
        assigns[:image].destroy # clean up          
      end    
    end  

    describe "tinymce" do 
      it "should work without a record" do         
        post(:tinymce)
        @response.code.should eq("200")      
      end
    end    
  end
  
  context "as user" do
    before(:each) do
      login_user
      @record = FactoryGirl.create(:item, :user => @controller.set_user)
    end 
        
    describe "new" do
      it "should return 200" do         
        get :new, {:record_type => @record.class.name, :record_id => @record.id}
        @response.code.should eq("200")
      end
    end

    describe "edit" do
      it "should return 200" do
        @image = FactoryGirl.create(:plugin_image, :record => @record)
        get :edit, {:record_type => @image.class.name, :record_id => @image.id}
        @response.code.should eq("200")
        @image.destroy # clean up
      end
    end  
    
    describe "create" do 
      it "should work with uploaded file" do
        expect{
          uploaded_file = fixture_file_upload(Rails.root.join('spec/fixtures/images/rails.png'), "image/png")       
          post(:create, {:record_type => @record.class.name, :record_id => @record.id, :plugin_image => {:image => uploaded_file}})
          flash[:success].should_not be_nil
        }.to change(PluginImage, :count).by(+1)
        assigns[:image].destroy # clean up          
      end    
      
      it "should fail when an file is not included" do
        expect{          
          post(:create, {:record_type => @record.class.name, :record_id => @record.id, :plugin_image => FactoryGirl.attributes_for(:plugin_image, :image => nil)})
          flash[:failure].should_not be_nil
        }.to change(PluginImage, :count).by(0)               
      end
    end
   	
   	describe "destroy" do 
   	  it "should reduce count and return success" do
   		@image = FactoryGirl.create(:plugin_image, :record => @record)
        expect{
          post(:delete, {:record_type => @image.class.name, :record_id => @image.id})
          flash[:success].should_not be_nil
        }.to change(PluginImage, :count).by(-1) 
   	  end	
   	end
   	
   	describe "tinymce" do 
   	  it "should work with a record" do   	     
        @image = FactoryGirl.create(:plugin_image, :record => @record)
        get(:tinymce, {:record_type => @record.class.name, :record_id => @record.id})
        @response.code.should eq("200")      
   	  end
   	end
  end
end
