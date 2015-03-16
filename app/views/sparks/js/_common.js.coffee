window.canEdit = <%= !current_user.nil? && current_user.can_edit?(@spark) %>;

window.getIdFromEvent = (ui) ->
  id = ui.helper[0].id
  id = id.substring(id.lastIndexOf('-') + 1)
  return id

window.post = (relativeUrl, data, callback) ->
  rootUrl = '<%= ENV['C9_HOSTNAME'] %>'
  if rootUrl.endsWith('/') and relativeUrl.indexOf('/') == 0
    relativeUrl = relativeUrl.substring(1)
  url = rootUrl + relativeUrl
  console.log url
  alert 'POST: ' + url + ' with ' + data
  #$.post(url, data, callback);
