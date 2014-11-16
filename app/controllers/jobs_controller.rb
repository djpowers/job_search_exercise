class JobsController < ApplicationController

  before_action :authorize, only: [:new, :create]

  def index
    jobs = call_jobs_api
    jobs.sort_by! { |job| job["posted"] }.reverse!
    @jobs = jobs.paginate(page: params[:page], per_page: 10)

    if params[:keywords].try(:present?)
      @jobs.select! { |job| job["keywords"].include?(params[:keywords].downcase) }
    end
  end

  def show
    jobs = call_jobs_api
    @job = jobs[params[:id].to_i - 1]

    post_events_api(@job)
  end

  def new
  end

  def create
    response = post_jobs_api(params[:job])

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

  def post_events_api(job)
    uri = URI.parse("http://localhost:4000/events")
    Net::HTTP.post_form(uri,
      {
        "job_id" => job["id"].to_i,
        "clicked" => Time.now.to_i,
        "user_id" => current_user.try(:id)
      }
    )
  end

  def post_jobs_api(job_params)
    uri = URI.parse("http://localhost:4000/jobs")
    Net::HTTP.post_form(uri,
      {
        "posted" => Time.now.to_i,
        "company" => job_params[:company],
        "poster" => current_user.email,
        "city" => job_params[:city],
        "state" => job_params[:state],
        "title" => job_params[:title],
        "body" => job_params[:body],
        "keywords" => job_params[:keywords]
      }
    )
  end
end
