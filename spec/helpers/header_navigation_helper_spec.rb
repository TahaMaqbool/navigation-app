require 'rails_helper'

RSpec.describe HeaderNavigationHelper, type: :helper do
 describe "#nav_primary" do
  context "when user is logged in" do
   before do
    allow(helper).to receive_message_chain(:current_user, :unread_messages).and_return([])
   end

   it "returns nav items for client" do
    allow(helper).to receive_message_chain(:current_user, :client?).and_return(true)
    nav_items = helper.nav_primary(client: true)
    expect(nav_items.size).to eq(3)
    expect(nav_items).to include(text: "My Company", url: "/company_dashboard")
    expect(nav_items).to include(text: "My Projects", url: "/my_projects")
    expect(nav_items).to include(url: "/inbox", block: "Messages")
   end

   it "returns nav items for non-client" do
    allow(helper).to receive_message_chain(:current_user, :client?).and_return(false)
    nav_items = helper.nav_primary
    expect(nav_items.size).to eq(3)
    expect(nav_items).to include(text: "Find Projects", url: "/contests")
    expect(nav_items).to include(text: "My Projects", url: "/my_projects")
    expect(nav_items).to include(url: "/inbox", block: "Messages")
   end
  end

  context "when user is logged out" do
   before do
    allow(helper).to receive(:current_user).and_return(nil)
   end
   it "returns nav items for client" do
    nav_items = helper.nav_primary(client: true)
    expect(nav_items.size).to eq(3)
    expect(nav_items).to include(text: "How it works", url: "/profiles")
    expect(nav_items).to include(text: "About Us", url: "#{HeaderNavigationHelper::APP_URL}/about")
    expect(nav_items).to include(text: "Blog", url: "#{HeaderNavigationHelper::APP_URL}/blog")
   end

   it "returns nav items for non-client" do
    nav_items = helper.nav_primary(client: false)
    expect(nav_items.size).to eq(3)
    expect(nav_items).to include(text: "How it works", url: "/profiles")
    expect(nav_items).to include(text: "Browse Projects", url: "/contests")
    expect(nav_items).to include(text: "Blog", url: "#{HeaderNavigationHelper::APP_URL}/blog")
   end
  end
 end

 describe  "#nav_secondary" do
  context "when user is logged in" do
   before do
    allow(helper).to receive_message_chain(:current_user, :jury_in_contest).and_return(false)
    allow(helper).to receive(:current_profile).and_return({ id: 1 })
    allow(helper).to receive_message_chain(:current_user, :client?).and_return(false)
   end

   it "returns nav items for original user" do
    allow(helper).to receive(:original_user).and_return(true)
    nav_items = helper.nav_secondary
    expect(nav_items.size).to eq(4)
    expect(nav_items).to include(text: "My Profile", url: "/profiles/1")
    expect(nav_items).to include(text: "Settings", url: "/profiles/1/edit")
    expect(nav_items).to include(text: "Find Collaborators", url: "/profiles")
    expect(nav_items).to include(text: "☯ Excarnate", url: nil, options: { style: "color: green" })
   end

   it "returns nav items for non-original user" do
    allow(helper).to receive(:original_user).and_return(false)
    nav_items = helper.nav_secondary
    expect(nav_items.size).to eq(4)
    expect(nav_items).to include(text: "My Profile", url: "/profiles/1")
    expect(nav_items).to include(text: "Settings", url: "/profiles/1/edit")
    expect(nav_items).to include(text: "Find Collaborators", url: "/profiles")
    expect(nav_items).to include(text: "Log out", url: "/logout")
   end
  end

  context "when user is logged out" do
   before do
    allow(helper).to receive(:current_user).and_return(nil)
   end

   it "returns empty array" do
    nav_items = helper.nav_secondary
    expect(nav_items).to eq([])
   end
  end
 end
end
