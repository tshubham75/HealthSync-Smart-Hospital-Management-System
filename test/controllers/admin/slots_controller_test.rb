require "test_helper"

class Admin::SlotsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_slots_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_slots_show_url
    assert_response :success
  end

  test "should get new" do
    get admin_slots_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_slots_create_url
    assert_response :success
  end

  test "should get edit" do
    get admin_slots_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_slots_update_url
    assert_response :success
  end

  test "should get destriy" do
    get admin_slots_destriy_url
    assert_response :success
  end
end
