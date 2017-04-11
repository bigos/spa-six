(in-package :about-page)

;;; this package uses Marco Antoniotti's project
;;; https://gitlab.common-lisp.net/xhtmlambda/XHTMLambda
(defmacro with-html-string (body)
  (let ((result (gensym "STREAM")))
    `(with-output-to-string (,result)
       (with-html-syntax-output (,result :syntax :standard :print-pretty T)
         ,body))))

(defun about ()
  (with-html-string
    (body (:style "color: red" :empty-attribute "")
          (p ()
             "Some text here"
             (ul ()
                 (li () "Line 1")))
          (script () (parenscript:ps
                       (alert (+ "Hello " 1)))))))
