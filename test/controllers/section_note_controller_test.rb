require 'test_helper'

class SectionNoteControllerTest < ActionController::TestCase
  setup do
    @owner = create_user(:username => 'notetaker')
    @spark = create_spark(:name => 'Section Notes Tests', :owner_id => @owner.id)
    @canvas = CanvasSection.create(:spark_id => @spark.id, :name => 'Notes Canvas', :x => 0, :y => 0, :width => 100, :height => 100)
    assert_not_nil(@canvas)
    assert(@canvas.id > 0)
  end
=begin  
  test 'can\'t create section without signing in as owner' do
    base_count = @spark.canvas_sections.count
    
    post :create, {:spark_id => @spark.id }
    @spark.reload
    assert_equal(base_count, @spark.canvas_sections.count)
    
    non_owner = create_user(:username => 'hacker37')
    
    sign_in(non_owner)
    post :create, {:spark_id => @spark.id }
    @spark.reload
    assert_equal(base_count, @spark.canvas_sections.count)
    
    sign_out(non_owner)
    sign_in(@owner)
    post :create, {:spark_id => @spark.id }
    @spark.reload
    assert_equal(base_count + 1, @spark.canvas_sections.count)
  end
=end

  test 'can\'t update note without signing in as spark owner' do
    original_text = 'test note'
    canvas = CanvasSection.create(:spark_id => @spark.id, :name => 'Destroy Canvas', :x => 0, :y => 0, :width => 200, :height => 100)
    note = SectionNote.create(:canvas_section_id => canvas.id, :text => original_text, :status => 'undecided')
    assert note.valid?, note.errors.messages
    
    patch :update, { :id => note.id, :text => 'not logged in'}
    note.reload
    assert_equal(original_text, note.text)
    
    non_owner = create_user(:username => 'randomz')
    sign_in(non_owner)
    patch :update, { :id => note.id, :text => 'logged in'}
    note.reload
    assert_equal(original_text, note.text)
    
    sign_out(non_owner)
    sign_in(@owner)
    puts "Last try"
    patch :update, { :id => note.id, :text => 'successful update'}
    note.reload
    assert_equal('successful update', note.text)
  end

  test 'can\'t destroy note without signing in as spark owner' do
    canvas = CanvasSection.create(:spark_id => @spark.id, :name => 'Destroy Canvas', :x => 0, :y => 0, :width => 200, :height => 100)
    note = SectionNote.create(:canvas_section_id => canvas.id, :text => 'test note', :status => 'undecided')
    assert note.valid?, note.errors.messages
    assert_not_nil(SectionNote.find_by_id(note.id))
    non_owner = create_user(:username => 'random-user')
    
    sign_in(non_owner)
    delete :destroy, {:id => note.id}
    assert_not_nil(SectionNote.find_by_id(note.id))
    sign_out(non_owner)
    
    sign_in(@owner)
    delete :destroy, {:id => note.id}
    assert_nil(SectionNote.find_by_id(note.id))
  end

end
