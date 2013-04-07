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
			'mocodo' => '/usr/bin/mocodo',
		 }
end

Redmine::WikiFormatting::Macros.register do
	desc "Draw a PlantUML diagram. Example:\n\n  {{plantuml\nAlice -> Bob: Authentication Request\nBob --> Alice: Authentication Response\n}}"
	macro :plantuml do |obj, args, text|
		m = RedmineWikiMacrosHelper::PlantumlMacro.new(self, text, args, obj.respond_to?('page') ? obj.page.attachments : nil)
		m.render()
	end

	desc "Draw a MoCoDo diagram. Example:\n\n  {{mocodo\nCLIENT: Ref. client, Nom, Prenom, Adresse\nPASSER, 0N CLIENT, 11 COMMANDE\nCOMMANDE: Num commande, Date, Montant\nINCLURE, 1N COMMANDE, 0N PRODUIT: Quantite\nPRODUIT: Ref. produit, Libelle, Prix unitaire\n}}"
	macro :mocodo do |obj, args, text|
		m = RedmineWikiMacrosHelper::MocodoMacro.new(self, text, args, obj.respond_to?('page') ? obj.page.attachments : nil)
		m.render()
	end
end
