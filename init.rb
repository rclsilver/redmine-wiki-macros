require 'redmine'
require "#{Rails.root}/plugins/redmine_wiki_macros/app/helpers/redmine_wiki_macros"

Rails.logger.info 'Starting Wiki Macros plugin'

Redmine::Plugin.register :redmine_wiki_macros do
	name 'Wiki Macros plugin'
	author 'Thomas Betrancourt'
	description 'This plugin adds macros for wiki pages'
	version '0.0.1'
	settings :partial => 'settings/redmine_wiki_macros_settings',
		 :default => {
			'cache' => 3600,
			'plantuml' => '/usr/bin/plantuml',
		 }
end

Redmine::WikiFormatting::Macros.register do
	desc "Draw a PlantUML diagram."
	macro :plantuml do |obj, args, text|
		m = RedmineWikiMacrosHelper::PlantumlMacro.new(self, text, args, obj.respond_to?('page') ? obj.page.attachments : nil)
		m.render()
	end
end
