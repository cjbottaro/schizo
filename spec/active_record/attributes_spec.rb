require "spec_helper"

describe "an ActiveRecord instance" do
  context "adorned with a role" do

    let(:role) do
      Module.new do
        extend Schizo::Role
        def set_name(name)
          self.name = name
        end
      end
    end

    let(:user){ User.new :name => "christopher" }

    let(:adorned_user){ user.as(role) }

    it "setting attributes should affect the original instance because they aren't duped" do
      adorned_user.set_name("callie")
      adorned_user.should be_name_changed
      adorned_user.name.should == "callie"
      user.name.should == "callie"
      user.should be_name_changed
    end

    context "saving" do

      before(:all){ adorned_user.save }

      it "does not affect the original instance's status as a new record" do
        adorned_user.should_not be_new_record
        user.should be_new_record
      end

      it "unless #actualize is called" do
        adorned_user.actualize
        user.should_not be_new_record
      end

    end

  end
end
