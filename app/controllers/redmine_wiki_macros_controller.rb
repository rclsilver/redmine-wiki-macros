class RedmineWikiMacrosController < ApplicationController
	include RedmineWikiMacrosHelper

	def filter
		name = params[:name]
		filename = params[:filename]
		extension = params[:extension]
		cache_key = self.construct_cache_key_with_macro_name(name, filename, extension)
		content = Rails.cache.read(cache_key)
		content_type = 'image/png'

		if(extension == 'svg')
			content_type = 'image/svg+xml'
		end
		
		if content
			headers['Content-Type'] = content_type
			send_data content, :disposition => 'inline', :filename => name + '_' + filename, :type => content_type
		else
			render_404
		end
	end
end
