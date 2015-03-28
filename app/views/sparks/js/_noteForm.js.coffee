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
  
    makePostCall("/SparkNote/Update", { "noteId": id, "content": content, "status": status })
  
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
    pseudoId =  $('#NotePseudoId').val()
    makePostCall("/SparkNote/Delete", { "noteId": $('#NoteId').val() }, () ->
      $("#note-#{pseudoId}").remove()
    )
}


window.formButtons = [closeButton]

if (canEdit)
 closeButton.text = 'Cancel'
 window.formButtons = [updateButton, closeButton, deleteButton]