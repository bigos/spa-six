#|
  This file is a part of spa-six project.
  Copyright (c) 2017 Jacek Podkanski (ruby.object@googlemail.com)
|#

#|
  Angular tutorials from W3C schools

  Author: Jacek Podkanski (ruby.object@googlemail.com)
|#



(in-package :cl-user)
(defpackage spa-six-asd
  (:use :cl :asdf))
(in-package :spa-six-asd)


(defsystem spa-six
  :version "0.1"
  :author "Jacek Podkanski"
  :mailto "ruby.object@googlemail.com"
  :license "LLGPL"
  :depends-on (:cl-who
               :parenscript
               :hunchentoot
               :alexandria
               :iterate)
  :components ((:module "src"
                        :components
                        ((:module "lib"
                                  :components
                                  ((:file "server")))
                         (:file "package")

                         (:file "tut-intro")
                         (:file "tut-expr")
                         (:file "tut-modules")

                         (:file "handlers")
                         (:file "parenscripts")
                         (:file "routes"))))
  :description "Angular tutorials from W3C schools"
  :in-order-to ((test-op (test-op :spa-six.test))))
