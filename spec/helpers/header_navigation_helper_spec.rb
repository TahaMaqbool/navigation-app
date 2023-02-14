require 'rails_helper'

RSpec.describe HeaderNavigationHelper, type: :helper do
 before(:each) do
  allow(helper).to receive(:session).and_return({})
 end

 describe "#nav_primary" do
  it "returns nav items for non-logged-in client" do
   nav_items = helper.nav_primary(client: true)
   expect(nav_items.size).to eq(4)
   expect(nav_items).to include(text: "About Us", url: "#{HeaderNavigationHelper::APP_URL}/about")
   expect(nav_items).to include(text: "Find Projects", url: "/contests")
   expect(nav_items).to include(text: "How it works", url: "/profiles")
   expect(nav_items).to include(text: "Blog", url: "#{HeaderNavigationHelper::APP_URL}/blog")
  end

  it "returns nav items for logged-in client" do
   user = double("User", client?: true, unread_messages: [])
   allow(helper).to receive(:current_user).and_return(user)

   nav_items = helper.nav_primary
   expect(nav_items.size).to eq(3)
   expect(nav_items).to include(text: "My Company", url: "/company_dashboard")
   expect(nav_items).to include(text: "My Projects", url: "/my_projects")
   expect(nav_items).to include(url: "/inbox", block: "Messages")
  end

  it "returns nav items for logged-in non-client user" do
   user = double("User", client?: false, unread_messages: [])
   allow(helper).to receive(:current_user).and_return(user)

   nav_items = helper.nav_primary

   expect(nav_items.size).to eq(2)
   expect(nav_items).to include(text: "Find Projects", url: "/contests")
   expect(nav_items).to include(url: "/inbox", block: "Messages")
  end

  it "returns nav items for logged-in user with unread messages" do
   user = double("User", client?: false, unread_messages: [double("Message"), double("Message")])
   allow(helper).to receive(:current_user).and_return(user)

   nav_items = helper.nav_primary

   expect(nav_items.size).to eq(2)
   expect(nav_items).to include(text: "Find Projects", url: "/contests")
   expect(nav_items).to include(url: "/inbox", block: "Messages <span class=\"unread-messages\">2<span>")
  end
 end

 describe "#nav_secondary" do
  it "returns empty nav items for non-logged-in user" do
   nav_items = helper.nav_secondary

   expect(nav_items).to be_empty
  end

  it "returns nav items for logged-in user who is not a contest judge" do
   user = double("User", client?: false, profile: '1', profiles: double("Profile"), jury_in_contest: nil, unread_messages: [])
   allow(helper).to receive(:current_user).and_return(user)

   nav_items = helper.nav_secondary
   expect(nav_items.size).to eq(4)
   expect(nav_items).to include(text: "My Profile", url: "/profiles/#{user.profile}")
   expect(nav_items).to include(text: "Settings", url: "/profiles/#{user.profile}/edit")
   expect(nav_items).to include(text: "Find Collaborators", url: "/profiles")
   expect(nav_items).to include(text: "Log out", url: "/logout")
  end
 end
end