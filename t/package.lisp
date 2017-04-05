#|
  This file is a part of spa-six project.
  Copyright (c) 2017 Jacek Podkanski (ruby.object@googlemail.com)
|#

(in-package :cl-user)
(defpackage :spa-six.test
  (:use :cl
        :spa-six
        :fiveam
        :cl-who :parenscript :hunchentoot :alexandria :iterate))
(in-package :spa-six.test)



(def-suite :spa-six)
(in-suite :spa-six)

;; run test with (run! test-name) 

(test spa-six

  )



