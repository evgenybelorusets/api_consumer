class Comments
  constructor: ->
    @comments = $('#comments')
    @initializeListeners()
    @loadComments()

  displayErrorMessage: ->
    $('#spinner-container').html($('#comments-load-error').html())

  initializeListeners: ->
    @comments.delegate '.reload-comments', 'click', (event)=>
      $('#spinner-container').html('<div class="large spinner"></div>')
      @loadComments()

    @comments.delegate '.delete-comment', 'ajax:success', (event)->
      $(event.target).closest('.comment-content').remove()

    @comments.delegate '.delete-comment', 'ajax:error', (event)->
      title = I18n.t('common.warning')
      body = I18n.t('comment.popup.error.delete')
      Modal.show(title, body)

    @comments.delegate '.edit-comment', 'ajax:success', (event, data)->
      title = I18n.t('comment.popup.title.edit')
      body = data
      Modal.show(title, body)

    $('#post').delegate '.new-comment', 'ajax:success', (event, data)->
      title = I18n.t('comment.popup.title.new')
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
      title = I18n.t('common.warning')
      body = I18n.t('comment.popup.error.update')
      Modal.show(title, body)

    Modal.delegate '.new-comment-form', 'ajax:success', (event, data)=>
      @comments.append(data)
      Modal.close()
      $('html, body').animate({scrollTop: $(document).height()}, 'slow')

    Modal.delegate '.new-comment-form', 'ajax:error', (event)=>
      Modal.close()
      title = I18n.t('common.warning')
      body = I18n.t('comment.popup.error.create')
      Modal.show(title, body)

  loadComments: ->
    $comments = $('#comments')
    url = $comments.data('comments-url')
    $.ajax url: url, error: @displayErrorMessage, success: (data) -> $comments.html(data)

$ ->
  new Comments