require "test_helper"

class Admin::StatesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_states_index_url
    assert_response :success
  end
end
