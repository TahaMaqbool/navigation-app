module HeaderNavigationHelper
 APP_URL = 'http://www.my_app.test'

 def nav_primary(client: false)
  nav = []
  if current_user
   nav.push({ text: 'My Projects', url: my_projects_path })
   nav.push({ url: inbox_path, block: inbox_block })
   nav.unshift(client ? company_link : find_projects_link)
  else
   nav.push({ text: 'How it works', url: profiles_path })
   nav.push({ text: 'Blog', url: "#{APP_URL}/blog" })
   nav.push(client ? about_us_link : browse_projects_link)
  end
  nav
 end

 def nav_secondary
  return [] unless current_user

  nav = [
    { text: 'My Profile', url: profile_path(current_profile) },
    { text: 'Settings', url: edit_profile_path(current_profile) },
    { text: "Find #{current_user.client? ? 'Creatives' : 'Collaborators'}", url: profiles_path }
  ]
  nav.unshift(latest_ideas_link) if current_user.jury_in_contest
  nav.push(original_user ? excarnate_link : logout_link)
  nav
 end

 private

 def inbox_block
  "Messages#{unread_messages_block}"
 end

 def unread_messages_block
  current_user.unread_messages.present? ?
  " <span class=\"unread-messages\">#{current_user.unread_messages.count}</span>".html_safe : ''
 end

 def company_link
  { text: 'My Company', url: company_dashboard_path }
 end

 def find_projects_link
  { text: 'Find Projects', url: contests_path }
 end

 def browse_projects_link
  { text: 'Browse Projects', url: contests_path }
 end

 def about_us_link
  { text: 'About Us', url: "#{APP_URL}/about" }
 end

 def latest_ideas_link
  { text: 'Latest Ideas', url: contest_ideas_path(current_user.jury_in_contest) }
 end

 def excarnate_link
  { text: '☯ Excarnate', url: unpretend_path, options: { style: 'color: green' } }
 end

 def logout_link
  { text: 'Log out', url: logout_path }
 end

 def current_user; end; def current_profile; end; def original_user; end; def unpretend_path; end
end
