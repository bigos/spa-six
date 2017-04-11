(in-package :new-tutorials)

;;; this package uses Marco Antoniotti's project
;;; https://gitlab.common-lisp.net/xhtmlambda/XHTMLambda
(defmacro with-html-string (doctype body)
  "Converts BODY to a html string adding doctype declaration when DOCTYPE is true."
  (let ((result (gensym "STREAM")))
    `(with-output-to-string (,result)
       (when ,doctype
         (format ,result "<!DOCTYPE html>~%"))
       (with-html-syntax-output (,result :syntax :standard :print-pretty T)
         ,body))))

(defun about ()
  (with-html-string T
    (body (:style "color: red" :empty-attribute "")
          (<:label () "unconflicted label") ;use "<:tag" for shadowed imports
          (<:var () "unconflicted var")
            (p ()
               "Some text here"
               (ul ()
                   (li () "Line 1")))
            (script () (parenscript:ps
                         (alert (+ "Hello " 1)))))))
