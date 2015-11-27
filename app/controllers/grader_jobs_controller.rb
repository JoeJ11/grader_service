class GraderJobsController < ApplicationController
  before_action :set_grader_job, only: [:show, :edit, :update, :destroy, :grade]

  # GET /grader_jobs
  # GET /grader_jobs.json
  def index
    @grader_jobs = GraderJob.all
  end

  # GET /grader_jobs/1
  # GET /grader_jobs/1.json
  def show
  end

  # GET /grader_jobs/new
  def new
    @grader_job = GraderJob.new
  end

  # GET /grader_jobs/1/edit
  def edit
  end

  # POST /grader_jobs
  # POST /grader_jobs.json
  def create
    @grader_job = GraderJob.new(grader_job_params)

    respond_to do |format|
      if @grader_job.save
        format.html { redirect_to @grader_job, notice: 'Grader job was successfully created.' }
        format.json { render :show, status: :created, location: @grader_job }
      else
        format.html { render :new }
        format.json { render json: @grader_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grader_jobs/1
  # PATCH/PUT /grader_jobs/1.json
  def update
    respond_to do |format|
      if @grader_job.update(grader_job_params)
        format.html { redirect_to @grader_job, notice: 'Grader job was successfully updated.' }
        format.json { render :show, status: :ok, location: @grader_job }
      else
        format.html { render :edit }
        format.json { render json: @grader_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grader_jobs/1
  # DELETE /grader_jobs/1.json
  def destroy
    @grader_job.destroy
    respond_to do |format|
      format.html { redirect_to grader_jobs_url, notice: 'Grader job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /grader_jobs/1/grade
  def grade
    @grader_job.grade
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grader_job
      @grader_job = GraderJob.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def grader_job_params
      params.require(:grader_job).permit(:anonym_id, :submission_key, :grader_payload)
    end
end
