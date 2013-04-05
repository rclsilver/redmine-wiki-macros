module RedmineWikiMacrosHelper
	def build(macro, text, args, attachments)
		result = {}
		result['uri'] = [ 'redmine_wiki_macros', macro.class.name.split('::').last, 'filename_xxx' ].join('/')
	end

	def render_tag(result)
		'<pre>' + result + '</pre>'
	end

	class PlantumlMacro
		def initialize(view, text, args, attachments)
			@view = view
			@view.controller.extend(RedmineWikiMacrosHelper)
			@result = @view.controller.build(self, text, args, attachments)
		end

		def render()
			@view.controller.render_tag(@result).html_safe
		end
	end
end
