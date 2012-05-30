require 'spec_helper'

describe Scriba::Request do
  it "should be saved in database when hash is passed, and save this hash as env" do
    Scriba::Request.log({"foo" => "bar"}) { [200, {"Foo" => "Bar"}, []]}
    Scriba::Request.count.should == 1
    Scriba::Request.first.env.should == {"foo" => "bar"}
  end

  it "should replace dots in keys with _dot_" do
    Scriba::Request.log({"foo.bar" => "bar"}) { [200, {"Foo" => "Bar"}, []]}
    Scriba::Request.first.env["foo_dot_bar"].should == "bar"
  end

  it "should record response body, status code and respose headers" do
    Scriba::Request.log({"foo" => "bar"}) { [200, {"Foo" => "Bar"}, ["Some body"]]}
    r = Scriba::Request.first
    r.response_status.should == 200
    r.response_headers.should == {"Foo" => "Bar"}
    r.response_body.should =~ /Some body/
  end

  it "should find user id and user class from proc" do
    u = mock()
    u.stub!(:id).and_return(1)

    Scriba.user_finder = ->(env) { env["rack_dot_session"]["user_id"].should be_present; u }

    Scriba::Request.log({"foo" => "bar", "rack.session" => {"user_id" => 1}}) { [200, {"Foo" => "Bar"}, ["Some body"]]}
    r = Scriba::Request.first
    r.user.should == u
    r.user_id.should == "1"
  end

  it "should find user link from proc as well" do
    u = mock()
    u.stub!(:id).and_return(1)

    Scriba.user_finder = ->(env) { env["rack_dot_session"]["user_id"].should be_present; u }
    Scriba.user_path_finder = ->(user) { "/myusers/#{user.id}" }

    Scriba::Request.log({"foo" => "bar", "rack.session" => {"user_id" => 1}}) { [200, {"Foo" => "Bar"}, ["Some body"]]}
    r = Scriba::Request.first
    r.user_path.should == "/myusers/1"
  end
end

