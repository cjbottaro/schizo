require "spec_helper"

module ActiveRecordSpec

  module Poster
    extend ActiveSupport::Concern

    included do
      has_many :posts
    end

    def build_post(title = nil)
      posts.build(:title => title)
    end

    module ClassMethods

      def new_post(title = nil)
        Post.new(:title => title)
      end

    end
  end

  describe "ActiveRecord instances adorned with roles" do
    
    let(:poster){ User.new.as(Poster) }

    it "adds methods to the facade" do
      expect(poster.build_post).to be_a(Post)
      expect(poster.class.new_post).to be_a(Post)
    end

    it "adds associations to the facade" do
      expect{ poster.posts }.to_not raise_error
    end

    it "does not define associations on the object class" do
      expect{ poster.posts }.to_not raise_error
      expect{ User.new.posts }.to raise_error(NoMethodError)
    end

    it "#inspect on facade class looks like an ActiveRecord class" do
      expect(poster.class.inspect).to eq(User.inspect)
    end

    it "#inspect on facade looks like an ActiveRecord instance" do
      expect(poster.inspect).to eq(User.new.inspect)
    end

    it "#to_s on facade looks like an object" do
      expect(poster.to_s).to match(/#<#{User}:0x[0-9a-f]+>/)
    end

  end

end
