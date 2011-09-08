class ApplicationController < ActionController::Base
  protect_from_forgery

  def set_site
    @site = Site.find(params[:site_id])
    @site_title = @site.nil? ? "unknown.." : @site.title
  end

  def set_parser
    @parser = Parser.find(params[:parser_id])
    @parser_title = @parser.nil? ? "unknown.." : @parser.title
  end
end
