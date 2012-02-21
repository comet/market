class SMSAPIHelper

  def smsmark
    post_args = {'ids' => params[:ids], 'name' => APP_CONFIG.pysmsd_app_name, 'password' => APP_CONFIG.pysmsd_app_password}
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
  def self.smssend
    post_args = {'number' => params[:number], 'text' => params[:text], 'replyto' => params[:replyto], 'name' => APP_CONFIG.pysmsd_app_name, 'password' => APP_CONFIG.pysmsd_app_password}
    http = get_http_connection()
    request = Net::HTTP::Post.new('/messages/out.json')
    request.set_form_data(post_args)
    resp = http.request(request)
    json = JSON.parse(resp.body)
    render_json :entry => json
  end

  def self.ensure_sms_enabled
    unless APP_CONFIG.pysmsd_enabled
      render_json :status => 405, :messages => "SMS functionality is not currently enabled" and return
    end
  end

  def self.get_http_connection
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