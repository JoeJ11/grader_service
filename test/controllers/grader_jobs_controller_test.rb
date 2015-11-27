require 'test_helper'

class GraderJobsControllerTest < ActionController::TestCase
  setup do
    @grader_job = grader_jobs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:grader_jobs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create grader_job" do
    assert_difference('GraderJob.count') do
      post :create, grader_job: { anonym_id: @grader_job.anonym_id, grader_payload: @grader_job.grader_payload, submission_key: @grader_job.submission_key }
    end

    assert_redirected_to grader_job_path(assigns(:grader_job))
  end

  test "should show grader_job" do
    get :show, id: @grader_job
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @grader_job
    assert_response :success
  end

  test "should update grader_job" do
    patch :update, id: @grader_job, grader_job: { anonym_id: @grader_job.anonym_id, grader_payload: @grader_job.grader_payload, submission_key: @grader_job.submission_key }
    assert_redirected_to grader_job_path(assigns(:grader_job))
  end

  test "should destroy grader_job" do
    assert_difference('GraderJob.count', -1) do
      delete :destroy, id: @grader_job
    end

    assert_redirected_to grader_jobs_path
  end
end
