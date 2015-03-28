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
    
    $('#edit-note-dialog-form').dialog({
        height: 460,
        width: 565,
        modal: false,
        buttons: finalButtons
    })
  )