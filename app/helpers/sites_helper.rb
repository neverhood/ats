module SitesHelper
  def site_status_class(site)
    cls = "site_status "
    if site.status == "idle"
      cls+= "site_idle"
    elsif site.status =~ /error/
      cls+= "site_error"
    else
      cls+= "site_running"
    end
    return cls
  end
end
