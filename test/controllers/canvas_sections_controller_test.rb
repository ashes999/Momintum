require 'test_helper'

class CanvasSectionsControllerTest < ActionController::TestCase
  setup do
    @canvas_section = canvas_sections(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:canvas_sections)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create canvas_section" do
    assert_difference('CanvasSection.count') do
      post :create, canvas_section: { height: @canvas_section.height, name: @canvas_section.name, spark_id: @canvas_section.spark_id, width: @canvas_section.width, x: @canvas_section.x, y: @canvas_section.y }
    end

    assert_redirected_to canvas_section_path(assigns(:canvas_section))
  end

  test "should show canvas_section" do
    get :show, id: @canvas_section
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @canvas_section
    assert_response :success
  end

  test "should update canvas_section" do
    patch :update, id: @canvas_section, canvas_section: { height: @canvas_section.height, name: @canvas_section.name, spark_id: @canvas_section.spark_id, width: @canvas_section.width, x: @canvas_section.x, y: @canvas_section.y }
    assert_redirected_to canvas_section_path(assigns(:canvas_section))
  end

  test "should destroy canvas_section" do
    assert_difference('CanvasSection.count', -1) do
      delete :destroy, id: @canvas_section
    end

    assert_redirected_to canvas_sections_path
  end
end
