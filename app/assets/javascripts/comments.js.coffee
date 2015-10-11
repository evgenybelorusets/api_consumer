class Comments
  constructor: ->
    @comments = $('#comments')
    @initializeListeners()
    @loadComments()

  displayErrorMessage: ->
    $('#spinner-container').html($('#comments-load-error').html())

  reloadComments: =>
    $('#spinner-container').html('<div class="large spinner"></div>')
    @loadComments()

  deleteCommentSuccess: (event)->
    $(event.target).closest('.comment-content').remove()

  deleteCommentError: ->
    title = I18n.t('common.warning')
    body = I18n.t('comment.popup.error.delete')
    Modal.show(title, body)

  editCommentSuccess: (data)->
    title = I18n.t('comment.popup.title.edit')
    body = data
    Modal.show(title, body)

  newCommentSuccess: (data)->
    title = I18n.t('comment.popup.title.new')
    body = data
    Modal.show(title, body)

  updateCommentSuccess: (data)->
    container = document.createElement('container') #maybe memory leak, check later
    $(container).html(data)
    comment_id = $(container).find('.comment-content').data('id')
    $(".comment-content[data-id=#{comment_id}]").replaceWith(data)
    Modal.close()

  updateCommentError: ->
    Modal.close()
    title = I18n.t('common.warning')
    body = I18n.t('comment.popup.error.update')
    Modal.show(title, body)

  createCommentSuccess: (data)=>
    @comments.append(data)
    Modal.close()
    $('html, body').animate({ scrollTop: $(document).height() }, 'slow')

  createCommentError: ->
    Modal.close()
    title = I18n.t('common.warning')
    body = I18n.t('comment.popup.error.create')
    Modal.show(title, body)

  initializeListeners: ->
    @comments.delegate '.reload-comments', 'click', @reloadComments
    @comments.delegate '.delete-comment', 'ajax:success', (event)=> @deleteCommentSuccess(event)
    @comments.delegate '.delete-comment', 'ajax:error', @deleteCommentError
    @comments.delegate '.edit-comment', 'ajax:success', (event, data)=> @editCommentSuccess(data)
    $('#post').delegate '.new-comment', 'ajax:success', (event, data)=> @newCommentSuccess(data)
    Modal.delegate '.edit-comment-form', 'ajax:success', (event, data)=> @updateCommentSuccess(data)
    Modal.delegate '.edit-comment-form', 'ajax:error', @updateCommentError
    Modal.delegate '.new-comment-form', 'ajax:success', (event, data)=> @createCommentSuccess(data)
    Modal.delegate '.new-comment-form', 'ajax:error', @createCommentError

  loadComments: ->
    $comments = $('#comments')
    url = $comments.data('comments-url')
    $.ajax url: url, error: @displayErrorMessage, success: (data) -> $comments.html(data)

$ ->
  new Comments