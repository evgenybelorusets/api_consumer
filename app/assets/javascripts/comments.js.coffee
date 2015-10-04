class Comments
  constructor: ->
    @comments = $('#comments')
    @initializeListeners()
    @loadComments()

  displayErrorMessage: ->
    $('#spinner-container').
      html('Error occurred while loading comments <button class="reload-comments btn btn-info">Reload</button>')

  initializeListeners: ->
    @comments.delegate '.reload-comments', 'click', (event)=>
      $('#spinner-container').html('<div class="large spinner"></div>')
      @loadComments()

    @comments.delegate '.delete-comment', 'ajax:success', (event)->
      $(event.target).closest('.comment-content').remove()

    @comments.delegate '.delete-comment', 'ajax:error', (event)->
      title = "Warning"
      body = "Error occurred during comment deletion. Please try again."
      Modal.show(title, body)

    @comments.delegate '.edit-comment', 'ajax:success', (event, data)->
      title = 'Edit comment'
      body = data
      Modal.show(title, body)

    $('#post').delegate '.new-comment', 'ajax:success', (event, data)->
      title = 'New comment'
      body = data
      Modal.show(title, body)

    Modal.delegate '.edit-comment-form', 'ajax:success', (event, data)=>
      container = document.createElement('container') #maybe memory leak, check later
      $(container).html(data)
      comment_id = $(container).find('.comment-content').data('id')
      $(".comment-content[data-id=#{comment_id}]").replaceWith(data)
      Modal.close()

    Modal.delegate '.edit-comment-form', 'ajax:error', (event)=>
      Modal.close()
      title = "Warning"
      body = "Comment was not updated. Please try again."
      Modal.show(title, body)

    Modal.delegate '.new-comment-form', 'ajax:success', (event, data)=>
      @comments.append(data)
      Modal.close()

    Modal.delegate '.new-comment-form', 'ajax:error', (event)=>
      Modal.close()
      title = "Warning"
      body = "Comment was not created. Please try again."
      Modal.show(title, body)

  loadComments: ->
    $comments = $('#comments')
    url = $comments.data('comments-url')
    $.ajax url: url, error: @displayErrorMessage, success: (data) -> $comments.html(data)

$(document).on 'page:change', ->
  new Comments