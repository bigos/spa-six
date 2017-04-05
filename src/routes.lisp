(in-package :spa-six)

;;; list of functions for adding to the dispatch-table
(server:add-routes
 (list
  ;; static assets stored in ../assets folder
  (hunchentoot:create-prefix-dispatcher "/javascripts/"  'handlers::assets)
  (hunchentoot:create-prefix-dispatcher "/stylesheets/"  'handlers::assets)
  (hunchentoot:create-prefix-dispatcher "/img/"          'handlers::assets)
  ;; routes where we might need arguments passed by script-name
  (server:create-custom-dispatcher :get "/parenscripts/:file"  'handlers::parenscripts)
  ;; (server:create-custom-dispatcher :get "/contacts/:action/:id" 'handlers::contacts)
  ;; regex routes
  ;; (hunchentoot:create-regex-dispatcher "\\A/about\\z" 'handlers::about)
  ;; finally route to home page making sure the regex is terminated with \z
  (hunchentoot:create-regex-dispatcher "\\A/\\z" 'handlers::home)))

;;; Start VHOST
(server:restart-acceptor)
