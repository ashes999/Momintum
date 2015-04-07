window.createNote = (id) ->
  json = notes[id]
  sectionId = json.canvas_section_id
  newNote = document.createElement("div")
  
  status = json.status
  notes[id] = json

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
    json = notes[id]
    $('#note_text').val(json.text)
    $('#note_id').val(json.id)
    $('#note_status').val(json.status)
    $('#note_sectionId').val(json.sectionId)

    # clear and re-clone
    finalButtons = formButtons.slice(0)
    
    $('#edit-note-dialog-form').dialog({
        height: 460,
        width: 565,
        modal: false,
        buttons: finalButtons
    })
  )
  
window.createAndSaveNote = (container) ->
  container = container.parentNode
  # "section28" => "28"
  sectionId = container.id.substring(container.id.lastIndexOf('section') + 7)

  httpPost('/section_note/create', 
  { 'spark_id': <%= @spark.id %>, 'section_id': sectionId, 'text': 'Edit me!' },
  (result) ->
      id = result.id
      notes[id] = result
      createNote(id)
  )