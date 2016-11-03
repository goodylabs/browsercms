# Returns a file upload input tag for a given block, along with label and instructions.
#
# @param [Symbol] method The name of the model this form upload is associated with
# @param [Hash] options
# @option options [String] :label (method) If no label is specified, the human readable name for method will be used.
# @option options [String] :hint (blank) Helpful tips for the person entering the field, appears blank if nothing is specified.
class FilePickerInput < SimpleForm::Inputs::Base

  def input
    # New blocks will not have their attachments created yet.
    object.ensure_attachment_exists if object.respond_to?(:ensure_attachment_exists)

    # Need to explictly use correct id (i.e. image_block_file) rather than the autogenerated one (i.e. image_block_attachments_attributes_0_attachment_name)
    # Otherwise <label for=""/> won't be right.
    tag = ActionView::Helpers::Tags::Base.new(object_name, attribute_name, template, options)
    tag_id = tag.send(:tag_id)

    html = ""
    if render_section_picker?
      sections = sections_with_full_paths
      sections.each do |s|
        html << template.content_tag(:span, "", {:class => "section_id_map", style: 'display: hidden', :data => {:id => s.id, :path => s.prependable_path}})
      end
    end
    elements = @builder.object.attachments
    if single_attachment?
      elements = [ elements.select{ |attachment| attachment.attachment_name == attribute_name.to_s }.first ]
    end
    @builder.simple_fields_for :attachments, elements do |a|
      if matching_attachment?(a)
        html << '<div class="attachments-row">'
        html << a.hidden_field(:id) if single_attachment?
        html << a.hidden_field("attachment_name", value: attribute_name.to_s)
        html << '<div class="input-row">'
        html << a.file_field(:data, input_html_options.merge('data-purpose' => "cms_file_field", id: tag_id))
        html << '</div>'
        html << a.hint(options.delete(:hint)) if options.keys.include?(:hint)
        if render_section_picker?
          html << a.input(:section_id, collection: sections, label_method: :full_path, include_blank: false, label: "Section", wrapper_html: {class: "inline-section-picker"}, input_html: {'data-purpose' => "section_selector"})
        end
        if render_path_input?
          klass = object.new_record? ? "suggest_file_path" : "keep_existing_path"
          html << a.input(:data_file_path, label: "Path", wrapper_html: {class: "inline-path"}, input_html: {class: klass})
        end
        if a.object.data_file_name.present?
          html << '<div class="btn-row">'
          css_class = a.object.is_image? ? 'image' : 'video'
          html << "<a class='btn btn-mini btn-danger #{css_class}' href='#' data-purpose='destroy-attachment' data-id='#{a.object.id}'>Delete attachment</a>"
          html << '</div>'
          if a.object.is_image?
            html << "<img src='#{Rails.configuration.action_controller.asset_host}#{a.object.attachment_version_path}'>"
          else
            html << "<video controls='controls' src='#{Rails.configuration.action_controller.asset_host}#{a.object.versioned_url}'></video>"
          end
        end
        html << '</div>'
      end
      # html << a.input(:id, as: :hidden, wrapper: false)
    end
    html.html_safe

  end

  protected

  def single_attachment?
    definition = Cms::Attachment.definitions[@builder.object.class.name]
    return false if definition.nil?
    return false if definition[attribute_name.to_sym].nil?
    definition[attribute_name.to_sym][:type] == :single
  end

  # @override Find errors on attachments rather than the provide attribute name.
  def errors_on_attribute
    object.errors[:attachment]
  end

  # Because #attachments holds ALL attachments by all names, need to verify we only render one form control for each one.
  def matching_attachment?(a)
    a.object.attachment_name == attribute_name.to_s
  end

  def render_path_input?
    object.respond_to?(:set_attachment_path)
  end

  def render_section_picker?
    object.respond_to?(:set_attachment_section)
  end


  def sections_with_full_paths
    root = Cms::Section.root.first
    root.full_path = root.name
    sections = []
    sections << root
    sections += root.master_section_list
    sections.each { |s| s.full_path = "/" + s.full_path unless s == root }
    sections
  end

end
