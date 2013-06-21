require 'sinatra/base'
require 'httparty'
require 'uri'
require 'time'

class TrimetIframe < Sinatra::Base

  set :protection, :except => :frame_options

  def call_trimet(endpoint, params={})
    query = params.merge!(
      appID: ENV['TRIMET_APP_ID'],
      json: true
    ).map{|k,v| "#{k}=#{v}"}.join("&")
    url = "http://developer.trimet.org/ws/V1/#{endpoint}?#{query}"
    HTTParty.get(url)
  end

  helpers do
    def time(raw)
      return "" unless raw
      DateTime.parse(raw).strftime('%l:%M%P')
    end

    def relative(raw)
      return "" unless raw
      min = ((Time.parse(raw) - Time.now()) / 60).to_i
      "#{min} min"
    end
  end
  
  get '/next/:stop' do
    stop_id = params[:stop].gsub(/[^\d]/, '')
    results = call_trimet('arrivals', locIDs: stop_id)['resultSet']
    @arrivals = results['arrival']
    @stop = results['location'][0]['desc']
    @routes = (params[:routes] || "").split(/,/).map{|r| r.to_i}

    if @routes.length > 0
      @arrivals = @arrivals.select{|r| @routes.include? r['route'] }
    end
    erb :next, layout: :iframe
  end

  get '/' do
    erb :index, layout: :iframe
  end
end
