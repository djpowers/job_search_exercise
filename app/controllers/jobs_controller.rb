class JobsController < ApplicationController
  def index
    @jobs = call_jobs_api
    @jobs.sort_by! { |job| job["posted"] }.reverse!

    if params[:keywords].try(:present?)
      @jobs.select! { |job| job["keywords"].include?(params[:keywords].downcase) }
    end
  end

  def show
    jobs = call_jobs_api
    @job = jobs[params[:id].to_i - 1]

    uri = URI.parse("http://localhost:4000/events")
    Net::HTTP.post_form(uri,
      {
        "job_id" => @job["id"].to_i,
        "clicked" => Time.now.to_i,
        "user_id" => current_user.try(:id)
      }
    )
  end

  def new
  end

  def create
    uri = URI.parse("http://localhost:4000/jobs")
    response = Net::HTTP.post_form(uri,
      {
        "posted" => Time.now.to_i,
        "company" => params[:job][:company],
        "poster" => current_user.email,
        "city" => params[:job][:city],
        "state" => params[:job][:state],
        "title" => params[:job][:title],
        "body" => params[:job][:body],
        "keywords" => params[:job][:keywords]
      }
    )

    if response.code == "200"
      redirect_to jobs_path
    else
      render 'new'
    end
  end

  private

  def call_jobs_api
    uri = URI.parse("http://localhost:4000/jobs")
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end
end
