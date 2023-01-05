require 'rails_helper'

RSpec.describe Post, type: :model do
  it "checks for internet connection" do
    expect(Post.internet_connection?).to eql(true)
  end
end
 