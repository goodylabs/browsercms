module Cms
  module Attachments

    # Can be added to Controllers to handle serving files.
    module Serving

      # Send the file if:
      #   1. It exists:
      #   2. The user has permissions to see it.
      #
      # The strategy used to send the file can be configured based on the config.cms.attachments.storage parameter.
      # Default is:
      #   storage = :filesystem -> Cms::Attachments::FilesystemStrategy
      def send_attachment(attachment)
        if attachment
          raise Cms::Errors::AccessDenied unless current_user.able_to_view?(attachment)
          strategy_class = send_attachments_with
          strategy_class.send_attachment(attachment, self)
        end
      end

      def send_attachments_with
        Cms::Attachments::Serving.send_attachments_with
      end

      # @return [#send_attachments] The strategy that will be used to serve files.
      def self.send_attachments_with
        storage = Rails.configuration.cms.attachments.storage
        "Cms::Attachments::#{storage.to_s.classify}Strategy".constantize
      end

    end

    class FilesystemStrategy

      def self.attachments_storage_location
        Rails.configuration.cms.attachments.storage_directory
      end

      def self.x_accel_url(file_name = nil)
        # uri = "/internal_redirect/#{url.gsub('http://', '')}"
        uri = "/download/"
        uri << "#{file_name}" if file_name
        return uri
      end

      def self.send_attachment(attachment, controller)
        style = controller.params[:style]
        style = "original" unless style
        path_to_file = attachment.path(style)
        if File.exists?(path_to_file)
          Rails.logger.debug "Sending file #{path_to_file}"

          if !!Rails.configuration.cms.attachments.use_x_accel
            pretty_name = path_to_file.split('tmp/uploads/')[1]
            controller.headers['X-Accel-Redirect'] = x_accel_url(pretty_name)
            controller.headers['Content-type'] = attachment.file_type
            controller.headers['Content-Disposition'] = "inline; filename=\"#{attachment.file_name}\""
            controller.render( :nothing => true, :content_type => attachment.file_type  )
          else
            controller.send_file(path_to_file,
                                 :filename => attachment.file_name,
                                 :type => attachment.file_type,
                                 :disposition => "inline"
            )
          end


        else
          msg = "Couldn't find file #{path_to_file}'"
          Rails.logger.error msg
          raise ActiveRecord::RecordNotFound.new(msg)
        end
      end
    end
  end
end
