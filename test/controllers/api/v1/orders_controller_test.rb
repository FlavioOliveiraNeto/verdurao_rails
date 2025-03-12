require "test_helper"

class Api::OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_orders_index_url
    assert_response :success
  end

  test "should get create" do
    get api_v1_orders_create_url
    assert_response :success
  end

  test "should get process_payment" do
    get api_v1_orders_process_payment_url
    assert_response :success
  end
end
