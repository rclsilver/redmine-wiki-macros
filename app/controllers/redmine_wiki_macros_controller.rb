class RedmineWikiMacrosController < ApplicationController
	include RedmineWikiMacrosHelper

	def filter
		name = params[:name]
		filename = params[:filename]
		cache_key = self.construct_cache_key_with_macro_name(name, filename)
		content = Rails.cache.read(cache_key)
		
		if content
			send_data content, :disposition => 'inline', :filename => name + '_' + filename + '.png'
		else
			render_404
		end
	end
end
