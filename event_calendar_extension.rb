class EventCalendarExtension < Radiant::Extension
  version "0.7"
  description "An event calendar extension which draws events from any ical publishers (Google Calendar, .Mac, etc.)"
  url "http://www.hellovenado.com"

  EXT_ROOT = '/admin/event_calendar'

  define_routes do |map|
    map.with_options :path_prefix => EXT_ROOT do |ext|
      ext.resources :calendars, :collection => {:help => :get}
      ext.resources :icals, :collection => {:refresh_all => :put}, :member => {:refresh => :put}
      ext.resources :events
    end
  end
  
  def activate
    EventCalendarPage
    admin.tabs.add "Event Calendars", EXT_ROOT + "/calendars", :after => "Snippets", :visibility => [:all]
    unless Radiant::Config["event_calendar.icals_path"]
      Radiant::Config["event_calendar.icals_path"] = "icals"
    end
    Page.send :include, EventCalendarTags
  end
end
