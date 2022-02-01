module Api::V1::ApiHelper
  def render_template(template, locals, args = {})
    status = args[:status] || :ok
    render template, formats: [:json], content_type: 'application/json', locals: locals, status: status
  end
end