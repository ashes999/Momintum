window.createNote = (json) ->
  sectionId = json.canvas_section_id
  newNote = document.createElement("div")
  
  id = json.id
  status = json.status

  newNote.id = "note-#{id}"
  newNote.className = "note #{status.toLowerCase()}"

  text = document.createElement('div')
  text.id = "#{newNote.id}-text"
  newNote.appendChild(text)
  $("##{text.id}").css("float", "left")

  $("#section#{sectionId}").append(newNote)
  # Visual (was pseudo) ID of the note
  $("##{text.id}").text(id)

  $("##{newNote.id}").click(() ->
    $('#NoteText').val(json.text)
    $('#NoteId').val(id)
    $('#NoteStatus').val(status)
    $('#NoteSection').val(sectionId)

    # clear and re-clone
    finalButtons = formButtons.slice(0)
    if status != "Prime"
      finalButtons.push(deleteButton)
      $('#NoteStatus').show()
    else
      $('#NoteStatus').hide()
    
    $('#edit-note-dialog-form').dialog({
        height: 475,
        width: 600,
        modal: false,
        buttons: finalButtons
    })
  )
  
# Variables needed for the form

finalButtons = []
formButtons = []

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

if (canEdit)
 formButtons = [
   {
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
    },
    {
      id: "close",
      text: '@(ViewBag.CanManageTasks ? "Cancel" : "Close")',
      click: () -> $(this).dialog("close")
    }
 ]