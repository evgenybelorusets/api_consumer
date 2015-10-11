module DeviseHelper
  def bootstrap_devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    button = content_tag :button, 'x', class: 'close', type: 'button', data: { dismiss: 'alert' }

    content_tag :div, class: 'alert alert-error alert-block' do
      [ button, messages ].join.html_safe
    end
  end
end