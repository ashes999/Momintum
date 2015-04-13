require 'test_helper'

class SectionNoteControllerTest < ActionController::TestCase
  setup do
    @owner = create_user(:username => 'notetaker')
    @spark = create_spark(:name => 'Section Notes Tests', :owner_id => @owner.id)
    @canvas = CanvasSection.create(:spark_id => @spark.id, :name => 'Notes Canvas', :x => 0, :y => 0, :width => 100, :height => 100)
    assert_not_nil(@canvas)
    assert(@canvas.id > 0)
  end
  
  test 'can\'t create note without signing in as spark owner' do
    canvas = CanvasSection.create(:spark_id => @spark.id, :name => 'Add Notes to Canvas', :x => 0, :y => 0, :width => 200, :height => 100)
    base_count = canvas.section_notes.count
    
    post :create, {:spark_id => @spark.id, :section_id => canvas.id, :text => 'POST-it note' }
    @spark.reload
    assert_equal(base_count, canvas.section_notes.count)
    
    non_owner = create_user(:username => 'hacker37')
    
    sign_in(non_owner)
    post :create, {:spark_id => @spark.id, :section_id => canvas.id, :text => 'do something malicious' }
    @spark.reload
    assert_equal(base_count, canvas.section_notes.count)
    
    sign_out(non_owner)
    sign_in(@owner)
    post :create, {:spark_id => @spark.id, :section_id => canvas.id, :identifier => 1, :text => 'Real Note' }
    @spark.reload
    assert_equal(base_count + 1, canvas.section_notes.count)
    assert_equal('Real Note', canvas.section_notes[0].text)
  end

  test 'can\'t update note without signing in as spark owner' do
    original_text = 'initial note text'
    updated_text = 'updated text'
    canvas = CanvasSection.create(:spark_id => @spark.id, :name => 'Destroy Canvas', :x => 0, :y => 0, :width => 200, :height => 100)
    note = SectionNote.create(:canvas_section_id => canvas.id, :identifier => '1', :text => original_text, :status => 'undecided')
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
    patch :update, { :id => note.id, :text => updated_text, :identifier => 'hi'}
    note.reload
    assert_equal(updated_text, note.text)
    assert_equal('hi', note.identifier)
  end

  test 'can\'t destroy note without signing in as spark owner' do
    canvas = CanvasSection.create(:spark_id => @spark.id, :name => 'Destroy Canvas', :x => 0, :y => 0, :width => 200, :height => 100)
    note = SectionNote.create(:canvas_section_id => canvas.id, :identifier => '1', :text => 'test note', :status => 'undecided')
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
