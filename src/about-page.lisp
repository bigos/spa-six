(in-package :about-page)

;;; this package uses Marco Antoniotti's project
;;; https://gitlab.common-lisp.net/xhtmlambda/XHTMLambda
(defun about ()
  (with-output-to-string (stream )
    (with-html-syntax-output (stream :syntax :standard :print-pretty t)
      (body (:style "color: red")
            (p ()
               "Some text here"
               (ul ()
                   (li () "Line 1")))
            (script () (parenscript:ps
                         (alert (+ "Hello " 1))))))))
