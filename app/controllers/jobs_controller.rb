class JobsController < ApplicationController
  def index
    uri = URI.parse("http://localhost:4000/jobs")
    response = Net::HTTP.get_response(uri)
    @jobs = JSON.parse(response.body)
    @jobs.sort! { |x,y| y["posted"] <=> x["posted"] }
  end
end
