#In case of any problem contact the developer: yuriy.horobey@gmail.com
#or http://sminit.com (use current navigation to find contact info)

##########################  CONFIGURATIONS ##########################################################
# Here, and everywhere else -- edit only parts between double quotes
# be careful no to  accidentally delete the double quote.

# This structure is to setup your account details.
# it is commented out because your sites do not use any authentications
=begin
login={
    #':sample' is key to refer to these credentials
    :sample=>{

        #your username
        :username=>"login",

        #the password
        :password=>"pass",

        #url to login form. But if they change it -- you better contact the developer see top of this file
        :url=>"http://www.somewhere.com/",

        #do not edit this block, this is to be setup by programmer after security analise of the site
        :form=>{
            :selector=>nil, #1st form to be used
            #field name for username above
            :username=>"LoginName",
            #field name for password above
            :password=>"LoginPassword"
        }
    }
}
=end

#'Sites' are actually sites from where data is being scraped
sites = [
    {#I will document this entry in detail and left the other without it to do not clutter the code

     #the key to either process or skip this site.
     #possible values: true/false
     :active=>true,

     #path to file where to save the results
     #this path can be either absolute (full path) like "d:/my folder/my other folder/thefile.csv"
     #or it can be realtive to folder from where you run the script
     :save_path => "./csv/irecruitment.csv",

     #Site title
     #this is used just for nice output to terminal screen
     #probably you do not need to edit this
     :title => "iRecruitment",

     #Start URL of page where you see the search form
     :url => "https://irecruitment.oracle.com/OA_HTML/RF.jsp?function_id=1038712&resp_id=23350&resp_appl_id=800&security_group_id=0&lang_code=US&params=.1VlTZi5hyKHcE3E6mrZaB91phg4LLW-2ZXXJFOuaJdg-6ALqWl2AqDOwJZdQVEM&oas=f9bSTzElHujSgfFdBZBb-g",

     #If your site requires authentication, here you specify key from the previous setup block (that :sample=> above)
     # possible value is login[:here-is-the-key]
     # since login is not required for this site, this entry is commented out from the code
     # :login => login[:sample],

     #Technical stuff -- Do not edit!
     :parser => :BTNSearch,

     #Fields in the CSV file, better do not edit this.
     #If you feel like you must edit here -- the only option you have -- delete entries
     # the last entry must not be terminated with comma
     :csv_fields=>[
         "Site Name", "Working Title", "Location", "Organization Name", "Department Description", "Brief Description", "Detailed Description", "Site Requirements", "Additional Details", "How To Apply", "Link"
     ]
    },
    #The other Sites (sites to scrap)
    #The only difference is URL and save path
    {:active=>false,
     :save_path => "./csv/etrade.csv",
     #this is used just for nice output to terminal screen
     #probably you do not need to edit this
     :title => "eTrade",
     :url => "https://careers.etrade.com/OA_HTML/RF.jsp?function_id=10679&resp_id=23350&resp_appl_id=800&security_group_id=0&lang_code=US&params=GXCUJ8g-1tvJ4HA5xqCcVBHcAUf.gTR7j8jjSmwSuJpypcAwP9pClMLSHc1odaUV&oas=kWgn0eNyf45skC-92v-Zdg",
     #login is not required for this site
     # :login => login[:sample],
     :parser => :BTNSearch,
     :csv_fields=>[
         "Site Name",
         "Working Title",
         "Location",
         "Organization Name",
         "Department Description",
         "Brief Description",
         "Detailed Description",
         "Site Requirements",
         "Additional Details",
         "How To Apply",
         "Link"
     ]
    },
    {:active=>false,
     :save_path => "./csv/creditacceptance.csv",
     #this is used just for nice output to terminal screen
     #probably you do not need to edit this
     :title => "Credit Acceptance",
     :url => "https://careers.creditacceptance.com/OA_HTML/RF.jsp?function_id=14353&resp_id=23350&resp_appl_id=800&security_group_id=0&lang_code=US&params=bLhPcI2B3Utlu9kFCvpj.Zaynqfv.StCbq3TeVvVtmUDHhRGX1GjOrUG4-iN7uZA&oas=Rw_2UhQZeThPMoaUwDnMlg",
     #login is not required for this site
     # :login => login[:sample],
     :parser => :BTNSearch,
     :csv_fields=>[
         "Site Name",
         "Working Title",
         "Location",
         "Organization Name",
         "Department Description",
         "Brief Description",
         "Detailed Description",
         "Site Requirements",
         "Additional Details",
         "How To Apply",
         "Link"
     ]
    },
    {:active=>true,
     :save_path => "./csv/lgmc.csv",
     :title => "LGMC",
     :url => "http://irecruit.lgmc.com/OA_HTML/OA.jsp?_rc=IRC_VIS_Site_SEARCH_PAGE&_ri=800&SeededSearchFlag=N&Contractor=Y&Employee=Y&OASF=IRC_VIS_Site_SEARCH_PAGE&_ti=1808067168&oapc=2&OAMC=75478_9_0&menu=Y&oaMenuLevel=1&oas=QHZS5wWEOk2m60TtPf56bg",
     #login is not required for this site
     # :login => login[:sample],
     :parser => :BTNGo,
     :csv_fields=>[
         "Site Name",
         "Working Title",
         "Location",
         "Organization Name",
         "Department Description",
         "Brief Description",
         "Detailed Description",
         "Site Requirements",
         "Additional Details",
         "How To Apply",
         "Link"
     ]
    },
    {:active=>false,
     :save_path => "./csv/deltadentalins.csv",
     :title => "Deltadentalins",
     :url => "http://careers.deltadentalins.com/OA_HTML/OA.jsp?OAFunc=IRC_EMP_VIS_Site_SEARCH_PAGE&_ti=89864029&oapc=2&oas=eapgxHJTpsdkDWQG563-iA",
     #login is not required for this site
     # :login => login[:sample],
     :parser => :BTNGo,
     :csv_fields=>[
         "Site Name",
         "Working Title",
         "Location",
         "Organization Name",
         "Department Description",
         "Brief Description",
         "Detailed Description",
         "Site Requirements",
         "Additional Details",
         "How To Apply",
         "Link"
     ]
    },
    {:active=>false,
     :save_path => "./csv/xilinx.csv",
     :title => "Xilinx",
     :url => "https://xapps9.xilinx.com/irec_prod/OA_HTML/OA.jsp?_rc=IRC_VIS_Site_SEARCH_PAGE&_ri=800&SeededSearchFlag=N&Contractor=Y&Employee=Y&OASF=IRC_VIS_Site_SEARCH_PAGE&_ti=1996144&oapc=2&OAMC=77056_9_0&menu=Y&oaMenuLevel=1&oas=oKKPAo3Sn-c2a3b_Ct9WCA",
     #login is not required for this site
     # :login => login[:sample],
     :parser => :BTNGo,
     :csv_fields=>[
         "Site Name",
         "Working Title",
         "Location",
         "Organization Name",
         "Department Description",
         "Brief Description",
         "Detailed Description",
         "Site Requirements",
         "Additional Details",
         "How To Apply",
         "Link"
     ]
    },
    {:active=>false,
     :save_path => "./csv/huntington.csv",
     :title => "Huntington",
     :url => "https://essentialconnection.huntington.com/OA_HTML/OA.jsp?_rc=IRC_VIS_Site_SEARCH_PAGE&_ri=800&SeededSearchFlag=N&Contractor=Y&Employee=Y&OASF=IRC_VIS_Site_SEARCH_PAGE&_ti=1452616685&oapc=2&OAMC=1003941_9_0&menu=Y&oaMenuLevel=1&oas=sk2oNhsbCkF4RRKsgjoU1Q..",
     #login is not required for this site
     # :login => login[:sample],
     :parser => :BTNGo,
     :csv_fields=>[
         "Site Name",
         "Working Title",
         "Location",
         "Organization Name",
         "Department Description",
         "Brief Description",
         "Detailed Description",
         "Site Requirements",
         "Additional Details",
         "How To Apply",
         "Link"
     ]
    }
]

######################## NO EDITING PAST THIS LINE ####################################################################
require 'rubygems'
require 'mechanize'

require File.dirname(__FILE__)+"/lib/base_parser.rb"
require File.dirname(__FILE__)+"/lib/csv_maker.rb"
require File.dirname(__FILE__)+"/lib/parsers/ats_parser.rb"
require File.dirname(__FILE__)+"/lib/parsers/btn_go.rb"
require File.dirname(__FILE__)+"/lib/parsers/btn_search.rb"

#go through all the sites and launch each of them
sites.each do |site|
  if site[:active]
    begin
      parser_class = Module.const_get(site[:parser].to_s)

      #some IDEs here will complain that "default constructor has no parameters"
      #disregard -- we use our custom constructors -- they take parameters
      parser = parser_class.new site
      parser.run
    rescue Exception => e
      puts "Unable to start parser: #{e.message}"
    end
  else
    puts "Skipping inactive site: #{site[:title]}"
  end
end

