(in-package :about-page)

(defun about ()
  (with-html-syntax-output (*standard-output* :syntax :standard :print-pretty t)
    (body (:style "color: red")
          (p ()
             "Some text here"
             (ul ()
                 (li () "Line 1")))
          (script () (parenscript:ps
                       (alert (+ "Hello " 1)))))))
