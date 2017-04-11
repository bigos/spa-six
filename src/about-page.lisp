(in-package :about-page)

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
