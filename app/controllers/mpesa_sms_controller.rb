require 'net/http'
require 'net/https'
class MpesaSmsController < ApplicationController
  #before_filter :ensure_client_login
  #before_filter :ensure_sms_enabled
  verify :method => :post,
    :only => :smssend,
    :render => {:text => '405 HTTP POST required', :status => 405}
  verify :method => :put,
    :only => :smsmark,
    :render => {:text => '405 HTTP POST required', :status => 405}
  verify :method => :get,
    :only => :index,
    :render => {:text => '405 HTTP GET required', :status => 405}

=begin rapidoc
return_code:: 200 - Returns SMSs fetched from pySMSd gateway for the logged in application
return_code:: 405 - Incorrect HTTP verb, only GET method allowed; OR SMS functionality not enabled

description:: ASI acts as a proxy and gets SMS stored at pySMSd as per the current application's name.
=end
  def index
    @client_name = APP_CONFIG.pysmsd_app_name

    unless @client_name == nil
      http = get_http_connection()
      path = '/messages/in.json?name='+APP_CONFIG.pysmsd_app_name+'&password='+APP_CONFIG.pysmsd_app_password+'&keyword='+@client_name
      Rails.logger.debug{path}
      resp = http.get(path)
      json = JSON.parse(resp.body)
      json['messages'].each do | message |
      #  @person = Person.find_by_phone_number(message['number'])
      #  if @person
      #    message['user_id'] = @person.guid
      #  end
        Rails.logger.debug{message}
      end
      flash[:notice]= json
      return
      #render_json :entry => json and return
    end
    flash[:notice]= "No matching application ID was found, cannot proceed to fetch SMS from server."
    #render_json :status => :bad_request, :messages => "No matching application ID was found, cannot proceed to fetch SMS from server." and return
  end

=begin rapidoc
return_code:: 200 - Message successfully marked as read in pySMSd database
return_code:: 405 - Incorrect HTTP verb, only PUT method allowed; OR SMS functionality not enabled
param:: ids - A comma-delimited list of sms ids which to mark as read.

description:: Mark particular message as read at pySMSd. Once marked, messages will not appear in an index query.
=end
  def smsmark
    post_args = { 'ids' => params[:ids], 'name' => APP_CONFIG.pysmsd_app_name, 'password' => APP_CONFIG.pysmsd_app_password }
    http = get_http_connection()
    request = Net::HTTP::Post.new('/messages/in.json')
    request.set_form_data(post_args)
    resp = http.request(request)
    json = JSON.parse(resp.body)
    render_json :entry => json
  end

=begin rapidoc
return_code:: 200 - Message successfully sent
return_code:: 405 - Incorrect HTTP verb, only POST method allowed; OR SMS functionality not enabled
param:: number - The number to which to send the message.
param:: text - The text of the message.
param:: replyto - Optional sms id to which the message is a reply. This has the effect of automatically marking the given message as read.

description:: Send one SMS message.
=end
  def smssend
    post_args = { 'number' => params[:number], 'text' => params[:text], 'replyto' => params[:replyto], 'name' => APP_CONFIG.pysmsd_app_name, 'password' => APP_CONFIG.pysmsd_app_password }
    http = get_http_connection()
    request = Net::HTTP::Post.new('/messages/out.json')
    request.set_form_data(post_args)
    resp = http.request(request)
    json = JSON.parse(resp.body)
    render_json :entry => json
  end

  def ensure_sms_enabled
    unless APP_CONFIG.pysmsd_enabled
      render_json :status => 405, :messages => "SMS functionality is not currently enabled" and return
    end
  end

  def get_http_connection
    if APP_CONFIG.pysmsd_enabled
      if APP_CONFIG.pysmsd_use_proxy
        http = Net::HTTP::Proxy(APP_CONFIG.pysmsd_proxy_host, APP_CONFIG.pysmsd_proxy_port, APP_CONFIG.pysmsd_proxy_username, APP_CONFIG.pysmsd_proxy_password).new(APP_CONFIG.pysmsd_host, APP_CONFIG.pysmsd_port)
      else
        http = Net::HTTP.new(APP_CONFIG.pysmsd_host, APP_CONFIG.pysmsd_port)
      end
      http.use_ssl = APP_CONFIG.pysmsd_use_ssl
      return http
    end
  end
end

