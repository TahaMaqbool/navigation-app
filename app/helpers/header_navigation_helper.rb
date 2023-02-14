module HeaderNavigationHelper
 APP_URL = 'http://localhost:3000'

 def nav_primary(client: false)
  nav_items = [
  { text: 'Find Projects', url: contests_path },
  { text: 'How it works', url: profiles_path },
  { text: 'Blog', url: "#{APP_URL}/blog" }
  ]

  unless current_user.nil?
   nav_items = [
   { text: 'My Projects', url: my_projects_path },
   { url: inbox_path, block: ("Messages" + (current_user.unread_messages.present? ? " <span class=\"unread-messages\">#{current_user.unread_messages.count}<span>" : '')).html_safe }
   ]
   nav_items.unshift({ text: 'My Company', url: company_dashboard_path }) if current_user.client?
   nav_items[0] = { text: 'Find Projects', url: contests_path } unless current_user.client?
  end

  nav_items.insert(1, { text: 'About Us', url: "#{APP_URL}/about" }) if client && current_user.nil?

  nav_items
 end

 def nav_secondary
  nav_items = []

  unless current_user.nil?
   nav_items = [
   { text: 'My Profile', url: profile_path(current_user.profile) },
   { text: 'Settings', url: edit_profile_path(current_user.profile) },
   { text: "Find #{current_user.client? ? 'Creatives' : 'Collaborators'}", url: profiles_path }
   ]
   nav_items.unshift({ text: 'Latest Ideas', url: contest_ideas_path(current_user.jury_in_contest) }) unless current_user.jury_in_contest.nil?

   if original_user
    nav_items.push({ text: '☯ Excarnate', url: unpretend_path, options: { style: 'color: green' } })
   else
    nav_items.push({ text: 'Log out', url: logout_path })
   end
  end

  nav_items
 end

 private

 def current_user
  @current_user ||= User.find_by_id(session[:user_id])
 end

 def original_user
  @original_user ||= User.find_by_id(session[:original_user_id])
 end
end
