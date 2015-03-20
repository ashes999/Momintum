window.rootUrl = '<%= ENV['C9_HOSTNAME'] %>'
window.rootUrl = "http://#{rootUrl}" unless rootUrl.indexOf('http://') == 0
window.canEdit = <%= !current_user.nil? && current_user.can_edit?(@spark) %>
window.isLocked = false

window.getIdFromEvent = (ui) ->
  id = ui.helper[0].id
  id = id.substring(id.lastIndexOf('-') + 1)
  return id
  
window.createImage = (id, src, width, height) ->
  image = document.createElement("img")
  image.id = id
  image.src = "#{rootUrl}#{src}"
  image.width = width
  image.height = height
  return image

window.post = (relativeUrl, data, callback) ->
  ajax('POST', relativeUrl, data, callback)

window.patch = (relativeUrl, data, callback) ->
  ajax('PATCH', relativeUrl, data, callback)

# 'delete' is a reserved keyword in JSl
window.http_delete = (relativeUrl, data, callback) ->
  ajax('DELETE', relativeUrl, data, callback)
    
window.ajax = (method, relativeUrl, data, callback) ->
  relativeUrl = relativeUrl.substring(1) if rootUrl.endsWith('/') and relativeUrl.indexOf('/') == 0
  url = rootUrl + relativeUrl
  console.log "#{method.toUpperCase()} #{url} with: #{JSON.stringify(data)}"
  
  $.ajax({
    headers: {
      'Accept' : 'application/json',
      'Content-Type' : 'application/json'
    },
    url: url,
    type: method,
    data: data,
    success: (response) ->
      alert(response.message) if response.message?
      error(response.error) if response.error?
      
      return callback(response) if callback?
      return response
    , error: (jqXHR, textStatus, errorThrown) ->
      error('An error occurred. Please try again or contact support.')
      console.log("AJAX Error for #{method} #{url}: #{textStatus}", errorThrown)
    #, complete: ->
    #  console.log("Done!")
  })

