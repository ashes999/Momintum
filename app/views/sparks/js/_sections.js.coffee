window.addNewSection = ->
  # AJAX POST to make a new one
  addSection( <%= raw CanvasSection.new.to_json %> )

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

window.unlockCanvas = (sectionId) ->
  if (canEdit)
    # Section events
    $('#' + sectionId).draggable({                
      stop: (event, ui) ->
        id = getIdFromEvent(ui)
        x = Math.round(ui.position.left)
        y = Math.round(ui.position.top)
        post("/CanvasSection/UpdatePosition?sectionId=#{id}&x=#{x}&y=#{y}")
      ,
      drag: resizeContainerIfNecessary
    }).resizable({
      stop: (event, ui) ->
        id = getIdFromEvent(ui)
        width = Math.round(ui.size.width)
        height = Math.round(ui.size.height)
        post("/CanvasSection/UpdateSize?sectionId=#{id}&width=#{width}&height=#{height}")
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

# "Main" entry point

<% @spark.canvas_sections.each do |c| %>
json  = <%= raw c.to_json %>
addSection json
<% end %>

$('#addSectionButton').button().click( -> addNewSection()) if (canEdit)
  