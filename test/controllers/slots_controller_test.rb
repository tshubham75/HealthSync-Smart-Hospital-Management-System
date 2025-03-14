require "test_helper"

class SlotsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get slots_index_url
    assert_response :success
  end

  test "should get slots" do
    get slots_slots_url
    assert_response :success
  end
end
