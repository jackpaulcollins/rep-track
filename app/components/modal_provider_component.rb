# frozen_string_literal: true

# All modals expext (if needed) that the local key is the symbolized class name of the record passed in

class ModalProviderComponent < ViewComponent::Base
  def initialize(form:, open_text:, header:, form_partial:, form_records:, body: nil, open_styling: nil)
    @form = form
    @open_text = open_text
    @open_styling = open_styling
    @header = header
    @form_partial = form_partial
    @form_records = form_records
  end

  def render_form_partial
    locals = @form_records.each_with_object({}) do |r, h|
      h[r.class.name.underscore.to_sym] = r
    end

    render partial: @form_partial, locals: locals
  end

  def open_styling
    @open_styling.nil? ? "text-indigo-600 hover:text-indigo-900 font-medium" : determine_open_styles
  end

  private

  def determine_open_styles
    if @open_styling.is_a?(Array)
      @open_styling.join(" ")
    else
      apply_template
    end
  end

  def apply_template
    case @open_styling
    when :primary_button
      "btn btn-primary"
    when :danger_button
      "btn btn-danger"
    else
      "btn btn-primary"
    end
  end
end
