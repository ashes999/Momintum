window.addNewSection = ->
  # JSON has to be sent as a string, not object, for jQuery.post() to work.
  post '/canvas_sections/create', { spark_id: <%= @spark.id %> }, (result) ->
    addSection( result )

window.addSection = (json) ->
  # Target HTML:
  # <div class="canvasSection" id="sectionId" >
  #    <div id="nameFieldId" contenteditable="true" style="float: left"><strong>name</strong></div>
  # <div>
  
  section = document.createElement("div")
  section.className = "canvasSection"
  section.id = "section#{json.id}"
  $('#sectionContainer').append(section)

  nameField = document.createElement("div")
  nameFieldId = "section#{json.id}Name"
  nameField.id = nameFieldId          
  nameField.innerHTML = "<strong>#{json.name}</strong>"
  section.appendChild(nameField)
  
  $('#' + nameField.id).css("float", "left")
  $('#' + section.id).css({ left: json.x, top: json.y, width: json.width, height: json.height })
  
  unlockCanvas(section.id)
  addSectionControls(section, nameFieldId)
  
  #resizeContainerIfNecessary(null, null, null)

window.unlockCanvas = (sectionId) ->
  if (canEdit)
    # Section events
    $('#' + sectionId).draggable({                
      stop: (event, ui) ->
        id = getIdFromEvent(ui)
        x = Math.round(ui.position.left)
        y = Math.round(ui.position.top)
        patch('/canvas_sections/update', { sectionId: id, x: x, y: y })
      ,
      drag: resizeContainerIfNecessary
    }).resizable({
      stop: (event, ui) ->
        id = getIdFromEvent(ui)
        width = Math.round(ui.size.width)
        height = Math.round(ui.size.height)
        patch('/canvas_sections/update', { sectionId: id, width: width, height: height })
      ,
      resize: resizeContainerIfNecessary
    }).click( -> 
      nameFieldId = "#{sectionId}Name"
      nameField = document.getElementById(nameFieldId)
      nameField.focus
    )
  
    nameFieldId = "#{sectionId}Name"
    nameField = document.getElementById(nameFieldId)
    nameField.setAttribute("contenteditable", "true")

window.resizeContainerIfNecessary = (event, data, child) ->
  child = $(this) if !child?

  container = $("#tabs-ideation")
  padding = 100            

  if (child.position().top > container.height() - child.height())
    container.height(child.position().top + child.height() + padding)


window.addSectionControls = (section, nameFieldId) ->
  if (canEdit)
    buttonContainer = document.createElement("div")            
    buttonContainer.id = "#{section.id}-buttons"
    section.appendChild buttonContainer
    $("##{section.id}-buttons").css("float", "right").css("padding", "4").width(32)
    section.appendChild(document.createElement("br"))

    # Add note button
    addNoteButton = createImage("#{section.id}-newNote", "<%= image_path 'note.png' %>", 32, 32)
    buttonContainer.appendChild(addNoteButton)	
    buttonContainer.appendChild(document.createElement('br'))
    buttonContainer.appendChild(document.createElement('br'))
    $("##{section.id}-newNote").css("float", "right")
    $("##{section.id}-newNote").click((event, ui) ->
        container = event.target.parentNode
        createAndSaveNote(container)
    )

    # Delete section button
    deleteSectionButton = createImage("#{section.id}-deleteSection", "<%= image_path 'delete.png' %>", 32, 32)
    buttonContainer.appendChild(deleteSectionButton)
    $("##{section.id}-deleteSection").css("float", "right")
    
    $("##{section.id}-deleteSection").click((event, ui) ->
      confirm("Are you sure? All notes from this section will be deleted.", () ->
        http_delete("/canvas_sections/destroy?sectionId=#{section.id}", null, () ->
          $("##{section.id}").remove()
        )
      )
    )
    
    $("##{nameFieldId}").focusout((eventData) ->
        id = eventData.target.id
        id = id.substring(id.lastIndexOf("-") + 1, id.lastIndexOf("Name"))
        newName = $(this).text()
        post("/canvas_sections/update?sectionId=#{id}&name=#{newName}")
    )

    unlockCanvas(section.id) if (!isLocked)

#
# "Main" entry point
#

<% @spark.canvas_sections.each do |c| %>
json  = <%= raw c.to_json %>
addSection json
<% end %>

$('#addSectionButton').button().click( -> addNewSection()) if (canEdit)
  