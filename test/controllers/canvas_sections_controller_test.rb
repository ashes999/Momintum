require 'test_helper'

class CanvasSectionsControllerTest < ActionController::TestCase
  setup do
    @owner = create_user(:username => 'canvaseer')
    @spark = create_spark(:name => 'Canvas Section Tests', :owner_id => @owner.id)
    @canvas = CanvasSection.create(:spark_id => @spark.id, :name => 'Setup Canvas', :x => 0, :y => 0, :width => 100, :height => 100)
    assert_not_nil(@canvas)
    assert(@canvas.id > 0)
  end
  
  test 'can\'t create section without signing in as owner' do
    base_count = @spark.canvas_sections.count
    
    post :create, {:spark_id => @spark.id }
    @spark.reload
    assert_equal(base_count, @spark.canvas_sections.count)
    
    hacker = create_user(:username => 'hacker37')
    
    sign_in(hacker)
    post :create, {:spark_id => @spark.id }
    @spark.reload
    assert_equal(base_count, @spark.canvas_sections.count)
    
    sign_out(hacker)
    sign_in(@owner)
    post :create, {:spark_id => @spark.id }
    @spark.reload
    assert_equal(base_count + 1, @spark.canvas_sections.count)
  end
  
  test 'can\'t edit section without signing in as owner' do
    patch :update, {:sectionId => id_for(@canvas), :x => 99, :y => 99}
    @canvas.reload
    assert_equal(0, @canvas.x)
    assert_equal(0, @canvas.y)
    
    hacker = create_user(:username => 'hacker37')
    
    sign_in(hacker)
    patch :update, {:sectionId => id_for(@canvas), :x => 99, :y => 99}
    @canvas.reload
    assert_equal(0, @canvas.x)
    assert_equal(0, @canvas.y)
    
    sign_out(hacker)
    sign_in(@owner)
    patch :update, {:sectionId => id_for(@canvas), :x => 99, :y => 99}
    @canvas.reload
    assert_equal(99, @canvas.x)
    assert_equal(99, @canvas.y)
  end
  
  test 'can\'t destroy section without signing in as owner' do
    canvas = CanvasSection.create(:spark_id => @spark.id, :name => 'Destructo Canvas', :x => 0, :y => 0, :width => 200, :height => 100)
    delete :destroy, {:sectionId => id_for(canvas)}
    assert_not_nil(CanvasSection.find_by_id(canvas.id))
    
    hacker = create_user(:username => 'hacker37')
    
    sign_in(hacker)
    delete :destroy, {:sectionId => id_for(canvas)}
    assert_not_nil(CanvasSection.find_by_id(canvas.id))
    
    sign_out(hacker)
    sign_in(@owner)
    delete :destroy, {:sectionId => id_for(canvas)}
    assert_nil(CanvasSection.find_by_id(canvas.id))
  end
  
  def id_for(section)
    return "section#{section.id}"
  end
  
end