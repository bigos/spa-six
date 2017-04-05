#|
  This file is a part of spa-six project.
  Copyright (c) 2017 Jacek Podkanski (ruby.object@googlemail.com)
|#


(in-package :cl-user)
(defpackage spa-six.test-asd
  (:use :cl :asdf))
(in-package :spa-six.test-asd)


(defsystem spa-six.test
  :author "Jacek Podkanski"
  :mailto "ruby.object@googlemail.com"
  :description "Test system of spa-six"
  :license "LLGPL"
  :depends-on (:spa-six
               :fiveam)
  :components ((:module "t"
                :components
                ((:file "package"))))
  :perform (test-op :after (op c) (eval
 (read-from-string
  "(let ((res (5am:run :spa-six)))
     (explain! res)
     (every #'fiveam::TEST-PASSED-P res))"))
))
