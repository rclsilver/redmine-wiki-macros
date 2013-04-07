match 'redmine_wiki_macros/:name/:filename/:extension', :controller => 'redmine_wiki_macros', :action => 'filter', :requirements => { :name => /.+/, :filename => /.+/, :extension => /.+/ }
match '/redmine_wiki_macros', :to => 'redmine_wiki_macros#filter', :via => [:get]
