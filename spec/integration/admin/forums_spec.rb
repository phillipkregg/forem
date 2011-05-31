require 'spec_helper'

describe "managing forums" do
  context "users not signed in as an admin" do
    before do
      sign_in!
    end

    it "cannot create a new forum" do
      visit new_admin_forum_path
      flash_error!("Access denied.")
    end
  end

  context "users signed in as admins" do
    before do
      sign_in! :admin => true
      visit root_path
      # Ensure that people can navigate to this area.
      click_link "Admin Area"
      click_link "Forums"
      click_link "New Forum"
    end

    context "creating a forum" do
      it "is valid with title and description" do
        fill_in "Title", :with => "FIRST FORUM"
        fill_in "Description", :with => "The first placeholder forum."
        click_button 'Create Forum'
        page!

        flash_notice!("This forum has been created.")
        assert_seen("FIRST FORUM", :within => :forum_header)
        assert_seen("The first placeholder forum.", :within => :forum_description)
      end

      it "is invalid without title" do
        fill_in "Description", :with => "The first placeholder forum."
        click_button 'Create Forum'

        flash_error!("This forum could not be created.")
        find_field("forum_title").value.should eql("")
      end

      it "is invalid without description" do
        fill_in "Title", :with => "FIRST FORUM."
        click_button 'Create Forum'

        flash_error!("This forum could not be created.")
        find_field("forum_description").value.should eql("")
      end
    end
  end
end