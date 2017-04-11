#|
  This file is a part of spa-six project.
  Copyright (c) 2017 Jacek Podkanski (ruby.object@googlemail.com)
|#

(in-package :cl-user)

(defpackage :handlers
  (:use :cl :hunchentoot :cl-who :parenscript))


(defpackage :new-tutorials
  (:shadowing-import-from "XHTMLAMBDA"  "VAR" "LABEL")
  (:use :cl :hunchentoot :xhtmlambda :parenscript))


(defpackage spa-six
  (:use :cl :cl-who :parenscript :hunchentoot))

(in-package :spa-six)

;; blah blah blah.
