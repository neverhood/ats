module ApplicationHelper
  def show_flash
    fl = ''
    f_names = flash.keys.map { |key| (key.to_s.gsub /\s+/, "_").to_sym }
    for name in f_names
      if flash[name]
        fl = fl + "<div class=\"flash_entry flash_#{name}\">#{flash[name]}</div>"
      end
      flash[name] = nil;
    end
    fl = '<div class="flash">'+fl+'</div>' unless fl.empty?

    return fl.html_safe
  end

  def run_button_for (site, image)
    if site.active == "y"
      if site.status == "idle" || site.status =~ /error/
        link = link_to(button_tag(true, image, "Run the site"), "/sites/#{site.id}/run", :title=>"Run site")
      else
        link = button_tag(false, image, "Site is currently running. If it is stuck -- please edit the status.")
      end
    else
      link = button_tag(false, image, "Site is not active. Activate to run it.")
    end
    return link.html_safe
  end

  def button_tag(enabled, image, title)
    src = enabled ? 'run.png' : 'run_disabled.png'
    css = enabled ? '' : ' run_disabled'
    if image
      tag = image_tag src, :border=>0, :title=>title
    else
      tag = '<span class="crud_button btn_run" style="background-image:url(/images/'+src+')" title="'+title+'">Run</span>'
    end
    return tag.html_safe
  end
end
