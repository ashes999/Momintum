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
    id = $('#note_id').val() # DB ID
    text = $('#note_text').val()
    status = $('#note_status').val()
    sectionId = $('#note_sectionId').val()
    $(this).dialog("close")
  
    httpPatch("/section_note/update", { "id": id, "text": text, "status": status }, (response) ->
      notes[id] = response
      alert 'Note updated.'
      document.getElementById("note-#{id}").className = "note #{status.toLowerCase()}"
    )
}

deleteButton = {
  id: "delete",
  text: 'Delete',
  click: () ->
    $(this).dialog("close")
    id =  $('#note_id').val()
    httpDelete("/section_note/destroy", { "id": id }, () ->
      $("#note-#{id}").remove()
      delete notes[id]
    )
}


window.formButtons = [closeButton]

if (canEdit)
 closeButton.text = 'Cancel'
 window.formButtons = [updateButton, closeButton, deleteButton]