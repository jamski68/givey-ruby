module GiveyRuby

  module Shared

    module ClassMethods

      def setup_givey_sdk(options = {})
        #options             = default_model_options.merge(options)
      end

    end

    module InstanceMethods

      def api_client
        @api_client ||= GiveyRuby.configuration.client
      end

      def api_version
        @api_version ||= GiveyRuby.configuration.api_version
      end

      def token_from_file
        if File.exists?(GiveyRuby.configuration.token_file)
          File.read(GiveyRuby.configuration.token_file).gsub(/\n/, '')
        end
      end

      def token_to_file(token_string)
        File.open(GiveyRuby.configuration.token_file, 'w'){|f| f.write(token_string) }
        token_string
      end

      # PASSWORD

      # CLIENT CREDENTIALS ACCESS

      def get_token_response(url)
        JSON.parse(access_token.get("/#{api_version}#{url}").body)
      end

      def post_token_response(url, body, headers = {})
        body      = find_files_for_conversion(body)
        response  = access_token.post("/#{api_version}#{url}", {body: body, headers: headers})
        JSON.parse(response.body)
      end

      def put_token_response(url, body, headers = {})
        body      = find_files_for_conversion(body)
        response  = access_token.put("/#{api_version}#{url}", {body: body, headers: headers})
        JSON.parse(response.body)
      end

      def find_files_for_conversion(body, parents = [])
        @body ||= body
        body.each do |param, value|
          if value.kind_of?(Hash)
            parents.push(param)
            find_files_for_conversion(value, parents)
          else
            if upload_io = convert_files_for_upload(value)
              eval("@body[:#{parents.map(&:to_sym).join("][:")}][:#{param}] = upload_io")
            end
          end
        end
      end

      # replace avatar object (ActionDispatch::Http::UploadedFile) with UploadIO object
      def convert_files_for_upload(value)
        if value.kind_of?(ActionDispatch::Http::UploadedFile)
          upload_io = UploadIO.new(value.tempfile.path, value.content_type, value.original_filename)
          return upload_io
        else
          false
        end
      end

    end

  end

end
