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
