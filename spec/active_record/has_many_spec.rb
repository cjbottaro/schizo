require "spec_helper"

describe "an ActiveRecord instance" do
  context "extended with a role that has_many :posts" do

    let(:user){ User.create! :name => "chris" }

    let(:role) do
      Module.new do
        extend Schizo::Role
        extended do
          has_many :posts
        end
      end
    end

    let(:adorned_user){ user.as(role) }

    it "responds to #posts" do
      adorned_user.should respond_to(:posts)
      user.should_not respond_to(:posts)
    end

    context "#posts" do

      it "works with #<<" do
        post = Post.new :title => "first"
        post.should be_a_new_record
        adorned_user.posts << post
        post.should_not be_a_new_record
        adorned_user.posts.count.should == 1
      end

      it "works with #build" do
        post = adorned_user.posts.build :title => "second"
        post.should be_a_new_record
        adorned_user.save!
        post.should_not be_a_new_record
        adorned_user.posts.find(post.id).should == post
      end

      it "works with #create" do
        post = adorned_user.posts.create :title => "third"
        post.should_not be_a_new_record
        adorned_user.posts.find(post.id).should == post
      end

    end

  end
end
