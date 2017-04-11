(in-package :spa-six)

;;; list of functions for adding to the dispatch-table
(server:add-routes
 (list
  ;; static assets stored in ../assets folder
  (hunchentoot:create-prefix-dispatcher "/javascripts/"  'handlers::assets)
  (hunchentoot:create-prefix-dispatcher "/stylesheets/"  'handlers::assets)
  (hunchentoot:create-prefix-dispatcher "/img/"          'handlers::assets)

  ;; routes where we might need arguments passed by script-name
  (server:create-custom-dispatcher :get "/parenscripts/:file"         'handlers::parenscripts)
  ;; (server:create-custom-dispatcher :get "/contacts/:action/:id" 'handlers::contacts)

  (server:create-custom-dispatcher :get "/angular/:tutorial/:section" 'handlers::tutorials)

  ;; reg-ex routes, take note of \\A and \\z reg-ex terminators
  ;; (hunchentoot:create-regex-dispatcher "\\A/about\\z" 'handlers::about)

  ;; equal dispatcher when the script name is equal to the URL
  (server:create-equal-dispatcher "/about" 'about-page:about)

  ;; finally route to home page
  (server:create-equal-dispatcher "/" 'handlers::home)))

;;; Start VHOST
(server:restart-acceptor)
