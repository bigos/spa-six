(declaim (optimize (debug 3)))

(defpackage :handlers
  (:use :cl :hunchentoot :cl-who :parenscript))

(in-package :handlers)

;;; Define handlers
(defun assets ()
  (let ((asset (merge-pathnames
                (subseq (script-name *request*) 1)
                (parse-namestring server::*file-root*))))
    ;; (cerror "debugging session" "tried ~a" asset)
    (hunchentoot:handle-static-file asset)))

(defun parenscripts (args)
  (setf (hunchentoot:content-type*) "text/javascript")
  (parenscripts-js))

;;; example handler for custom dispatcher
;; (defun contacts  (args)
;;   ;; this is the way of invoking a debugger
;;   ;; (cerror "debugging session" "tried ~a" args)
;;   (format nil "Baz ~a ~a <br>get parameters ~a"
;;           (request-method *request*)
;;           args
;;           (get-parameters *request*)))

(defun layout (view)
  (with-html-output-to-string (*standard-output* nil :indent T)
    (:html
     (:head
      (:title "Spa Six")
      (:link :href "/stylesheets/style.css" :media "all" :rel "stylesheet" :type "text/css")
      (:script :src "/javascripts/jquery-3.2.0.js")
      (:script :src "/javascripts/javascript.js")
      (:script :src "/parenscripts/first-parenscript.js")
      )
     (:body
      (fmt "~a" view)
      (:footer (multiple-value-bind
                     (s m h date month year wkd dst zone)
                   (get-decoded-time)
                 (fmt "time now ~2,'0d:~2,'0d current date ~2,'0d/~2,'0d/~d"
                      h m date month year) ))))))

(defun home ()
  (layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:h1 "Home")
     (:p "request " (fmt "~A" (script-name *request*)) )
     )))
