require 'digest/sha2'

module RedmineWikiMacrosHelper
	def construct_cache_key(macro, filename, extension)
		return self.construct_cache_key_with_macro_name(macro.class.name.split('::').last, filename, extension)
	end

	def construct_cache_key_with_macro_name(macro, filename, extension)
		[ 'redmine_wiki_macros', macro, filename ].join('/') + '.' + extension
	end

	def build(macro, text, args, attachments, extension)
		filename = Digest::SHA256::hexdigest(text)
		expires = Setting.plugin_redmine_wiki_macros['cache'].to_i

		if not expires > 0
			raise 'Please set expires time under plugins settings in then "cache" parameter'
		end

		cache_key = self.construct_cache_key(macro, filename, extension)
		content = nil

		begin
			content = Rails.cache.read(cache_key, :expires_in => expires.seconds)
		rescue
			Rails.logger.error "Failed to load cache: #{cache_key}, error: $! #{error} #{$@}"
		end

		if content
			Rails.logger.debug "From cache: #{cache_key}"
		else
			build_result = macro.build()

			if build_result[:status]
				content = build_result[:content]

				begin
					Rails.cache.write(cache_key, content, :expires_in => expires.seconds)
					Rails.logger.debug("Cache saved: #{cache_key}, expires in #{expires.seconds}")
				rescue
					Rails.logger.error "Failed to save cache: #{cache_key}, error: #{$!}"
				end
			else
				raise "Error generating macro content: stdout is #{build_result[:content]}, stderr is #{build_result[:errors]}"
			end
		end

		result = {}
		result[:name] = macro.class.name.split('::').last
		result[:source] = text
		result[:content] = content
		result[:filename] = filename
		result[:extension] = extension

		return result
	end

	def render_tag(result, template)
		render_to_string(:template => 'redmine_wiki_macros/macro_' + template, :layout => false, :locals => result).chop
	end

	class PlantumlMacro
		def initialize(view, text, args, attachments)
			@text = text
			@view = view
			@view.controller.extend(RedmineWikiMacrosHelper)
			@result = @view.controller.build(self, @text, args, attachments, 'png')
		end

		def build()
			require 'open4'

			result = {}
			command = Setting.plugin_redmine_wiki_macros['plantuml'] + ' -pipe'

			Rails.logger.debug("Executing command #{command}")

			Open4::popen4(command) { |pid, fin, fout, ferr|
				fin.puts('@startuml')
				fin.puts(@text)
				fin.puts('@enduml')
				fin.close()

				result[:content] = fout.read
				result[:errors] = ferr.read
			}

			result[:status] = $?.exitstatus == 0

			Rails.logger.debug("child status: sig=#{$?.termsig}, exit=#{$?.exitstatus}")

			return result
		end

		def render()
			@view.controller.render_tag(@result, 'image').html_safe
		end
	end
end
