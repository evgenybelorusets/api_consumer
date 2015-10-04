class Modal
  constructor: ->
    @modal = $('#generic-modal')
    @title = @modal.find('.modal-title')
    @body = @modal.find('.modal-body')

  show: (title, body)->
    @title.html(title)
    @body.html(body)
    @modal.modal()

  updateBody: (body)->
    @body.html(body)

  close: ->
    @modal.modal('hide')

  delegate: (element, event, handler)->
    @modal.delegate(element, event, handler)

$ ->
  window.Modal = new Modal