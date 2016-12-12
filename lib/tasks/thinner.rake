require 'net/http'

# the path that the URL is hosted at. no slashes.
# (i.e. "docdollars" for "https://projects.propublica.org/docdollars/")
APP_URL_PREFIX = "politwoops"

# the "Surrogate-Key" header set in the `application_controller.rb` or
# in fastly. often the same as APP_URL_PREFIX.
APP_SURROGATE_KEY = "politwoops"

FASTLY_API_KEY = '577b6afcf4e45c33b19afff81005b924'


############################################################


class Purge < Net::HTTPRequest
  METHOD = "PURGE"
  REQUEST_HAS_BODY = false
  RESPONSE_HAS_BODY = false
end

namespace :thinner do
  desc "Purge caches inside "
  task :purge do
    puts "Fastly: Purging '#{APP_SURROGATE_KEY}' surrogate key..."

    uri = URI("https://api.fastly.com/service/5hQpQYwbLS5amds8ErCps8/purge/#{APP_SURROGATE_KEY}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.request_uri)
    req['Fastly-Key'] = FASTLY_API_KEY

    response = http.request(req)
    puts response.code

    puts "Fastly: Explicitly purging app homepage & variations..."
    ["", "/", "?", "/?"].each do |suffix|
      uri = URI("https://api.fastly.com/purge/projects.propublica.org/#{APP_URL_PREFIX}#{suffix}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Post.new(uri.request_uri)
      req['Fastly-Key'] = FASTLY_API_KEY

      response = http.request(req)
      puts response.code
    end
  end
end
