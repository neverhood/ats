require File.dirname(__FILE__)+"/../base_parser"
#base lass for both Oracle Irecruitment parsers (currently _v1 and _v2)
#contains common methods
class IRCParser < BaseParser

  #"next" link has different format of "onclick" attribute
  #this method converts it to format acceptable by method 'decorate_form'
  def prepare_next_link_options(next_link)
    onclick = next_link["onclick"]
    onclick.to_s =~/\(([^(]*)\)/
    opt = $1.split ","
    #next_link_opt = "{event :#{opt[1]}, source :#{opt[2]}, value :#{opt[4]}, size :#{opt[5]}, partialTargets :''}"
    next_link_opt = "{event :#{opt[1]}, source :#{opt[2]}, value :#{opt[4]}, size :#{opt[5]}, partialTargets :SiteSearchTable}"
    #next_link_opt = "{event :#{opt[1]}, source :#{opt[2]}, value :#{opt[4]}, size :#{opt[5]}, partialTargets :#{opt[6]}}"
    next_link["onclick"] = next_link_opt
  end


  #add fields from "onclick" event to form
  def decorate_form(form, onclick)

    fields = onclick.attr "onclick"
    fields.to_s =~ /\{([^}]+)\}/
    fields = $1
    fields = fields.split(",").map do |e|
      arr = e.gsub("'", "").split ":"
      arr.push "" unless arr.length == 2
      arr[0].strip!
      arr[1].strip!
      arr
    end
    fields.each do |field|
      form_field = form.field_with :name=>field[0]
      if form_field.nil?
        form.add_field! field[0]
        form_field = form.field_with :name=>field[0]
      end
      form_field.value= field[1]
    end
    return form
  rescue Exception => e
    puts e
  end


end