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

  onDeleteCommentSuccess: (event)->
    $(event.target).closest('.comment-content').remove()

  onDeleteCommentError: ->
    title = I18n.t('common.warning')
    body = I18n.t('comment.popup.error.delete')
    Modal.show(title, body)

  onEditCommentSuccess: (data)->
    title = I18n.t('comment.popup.title.edit')
    body = data
    Modal.show(title, body)

  onNewCommentSuccess: (data)->
    title = I18n.t('comment.popup.title.new')
    body = data
    Modal.show(title, body)

  onUpdateCommentSuccess: (data)->
    container = document.createElement('container') #maybe memory leak, check later
    $(container).html(data)
    comment_id = $(container).find('.comment-content').data('id')
    $(".comment-content[data-id=#{comment_id}]").replaceWith(data)
    Modal.close()

  onUpdateCommentError: ->
    Modal.close()
    title = I18n.t('common.warning')
    body = I18n.t('comment.popup.error.update')
    Modal.show(title, body)

  onCreateCommentSuccess: (data)=>
    @comments.append(data)
    Modal.close()
    $('html, body').animate({ scrollTop: $(document).height() }, 'slow')

  onCreateCommentError: ->
    Modal.close()
    title = I18n.t('common.warning')
    body = I18n.t('comment.popup.error.create')
    Modal.show(title, body)

  initializeListeners: ->
    @comments.delegate '.reload-comments', 'click', @reloadComments
    @comments.delegate '.delete-comment', 'ajax:success', (event)=> @onDeleteCommentSuccess(event)
    @comments.delegate '.delete-comment', 'ajax:error', @onDeleteCommentError
    @comments.delegate '.edit-comment', 'ajax:success', (event, data)=> @onEditCommentSuccess(data)
    $('#post').delegate '.new-comment', 'ajax:success', (event, data)=> @onNewCommentSuccess(data)
    Modal.delegate '.edit-comment-form', 'ajax:success', (event, data)=> @onUpdateCommentSuccess(data)
    Modal.delegate '.edit-comment-form', 'ajax:error', @onUpdateCommentError
    Modal.delegate '.new-comment-form', 'ajax:success', (event, data)=> @onCreateCommentSuccess(data)
    Modal.delegate '.new-comment-form', 'ajax:error', @onCreateCommentError

  loadComments: ->
    $comments = $('#comments')
    url = $comments.data('comments-url')
    $.ajax url: url, error: @displayErrorMessage, success: (data) -> $comments.html(data)

$ ->
  new Comments