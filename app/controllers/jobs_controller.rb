class JobsController < ApplicationController
  def index
    @jobs = call_jobs_api
    @jobs.sort! { |x,y| y["posted"] <=> x["posted"] }
  end

  def show
    jobs = call_jobs_api
    @job = jobs[params[:id].to_i - 1]
  end

  private

  def call_jobs_api
    uri = URI.parse("http://localhost:4000/jobs")
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end
end
