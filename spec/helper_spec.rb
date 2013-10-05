require "spec_helper"

describe Chromedriver::Helper do
  describe "#check_latest" do
    it "checks latest for current os" do
      helper = Chromedriver::Helper.new
      version, etag, url = helper.check_latest

      url.should_not be_nil
      version.should_not be_nil
      etag.should_not be_nil
    end
  end

  describe "#download" do
    it "gets latest for current os" do
      helper = Chromedriver::Helper.new
      filename = helper.download

      File.exists?(filename).should be_true
    end
  end
end
