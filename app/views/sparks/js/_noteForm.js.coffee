#  
# Note view/edit form
#
closeButton = {
  id: "close",
  text: 'Close',
  click: () -> $(this).dialog("close")
}

updateButton =  {
  id: "update",
  text: "Update",
  click: () -> 
    id = $('#NoteId').val() # DB ID
    content = $('#NoteText').val()
    status = $('#NoteStatus').val()
    sectionId = $('#NoteSection').val()
    pseudoId = $('#NotePseudoId').val()
    index = $('#Index').val()
    $(this).dialog("close")
  
    makePostCall("/section_note/update", { "noteId": id, "content": content, "status": status })
  
    notes[index] = content
    noteSections[index] = sectionId
    statuses[index] = status
  
    document.getElementById("note#{pseudoId}").className = "note #{status.toLowerCase()}"
}

deleteButton = {
  id: "delete",
  text: 'Delete',
  click: () ->
    $(this).dialog("close")
    id =  $('#note_id').val()
    httpDelete("/section_note/destroy", { "id": id }, () ->
      $("#note-#{id}").remove()
    )
}


window.formButtons = [closeButton]

if (canEdit)
 closeButton.text = 'Cancel'
 window.formButtons = [updateButton, closeButton, deleteButton]