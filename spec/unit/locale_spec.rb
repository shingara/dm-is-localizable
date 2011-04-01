require 'spec_helper'

describe "Locale" do

  describe "with valid attributes" do

    it "should be valid" do
      Locale.new(:tag => "en-US", :name => "English").should be_valid
    end

    it "should store unique locale string locales" do
      Locale.create(:tag => "en-US", :name => "English").should_not be_new
      Locale.create(:tag => "en-US", :name => "English").should be_new
    end

  end

  describe "with incomplete attributes" do

    before :each do
      @l = Locale.new
    end

    it "should require a locale" do
      @l.name = "English"
      @l.should_not be_valid
      @l.errors.size.should == 1
      @l.errors.on(:tag).should_not be_empty
    end

    it "should require a name" do
      @l.tag = "en-US"
      @l.should_not be_valid
      @l.errors.size.should == 1
      @l.errors.on(:name).should_not be_empty
    end

  end

  describe "with invalid attributes" do

    it "should not accept invalid locale strings" do
      Locale.new(:tag => 'foo',     :name => "English").should_not be_valid
      Locale.new(:tag => 'foo-bar', :name => "English").should_not be_valid
      Locale.new(:tag => 'foo-BAR', :name => "English").should_not be_valid
      Locale.new(:tag => 'FOO-bar', :name => "English").should_not be_valid
      Locale.new(:tag => 'FOO-BAR', :name => "English").should_not be_valid
      Locale.new(:tag => 'en-us',   :name => "English").should_not be_valid
      Locale.new(:tag => 'EN-us',   :name => "English").should_not be_valid
      Locale.new(:tag => 'EN-US',   :name => "English").should_not be_valid
    end

    it "should only allow unique locale string locales" do
      l1 = Locale.create(:tag => 'en-US', :name => "English")
      l1.should_not be_new
      l2 = Locale.create(:tag => 'en-US', :name => "English")
      l2.should be_new
      l2.errors.on(:tag).should_not be_empty
      l2.errors.size.should == 1
    end

  end

  describe "the for(value) class method" do

    before :each do
      Locale.create :tag => 'en-US', :name => 'English'
      Locale.create :tag => 'de-AT', :name => 'Deutsch'
    end

    describe "with nil as paramter" do

      it "should return nil" do
        Locale.for(nil).should be_nil
      end

    end

    describe "with an invalid (not present) locale symbol as parameter" do

      it "should return nil" do
        Locale.for(:it).should be_nil
      end

    end

    describe "with a valid (present) locale symbol as parameter" do

      it "should return the correct locale instance" do
        Locale.for(:en_US).should == Locale.first(:tag => 'en-US')
      end

    end

  end

end