match 'redmine_wiki_macros/:name/:filename', :controller => 'redmine_wiki_macros', :action => 'filter', :requirements => { :name => /.+/, :filename => /.+/ }
match '/redmine_wiki_macros', :to => 'redmine_wiki_macros#filter', :via => [:get]
