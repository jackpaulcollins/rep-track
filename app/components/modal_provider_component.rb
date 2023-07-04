# frozen_string_literal: true

class ModalProviderComponent < ViewComponent::Base
  def initialize(form:, open_text:, header:, form_partial:, locals:, body: nil)
    @form = form
    @open_text = open_text
    @header = header
    @form_partial = form_partial
    @locals = locals
  end

  def render_form_partial
    render partial: @form_partial, locals: {report: @locals}
  end
end
