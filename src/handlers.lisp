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
     (:p "request " (fmt "~A" (script-name *request*)))
     (:h2 "Tutorials")
     (:a :href "/angular/intro/all" "Intro") (:br)
     (:a :href "/angular/expressions/1" "Expressions 1") (:br)
     )))

(defun tutorials-layout (args view)
  (setf (html-mode) :HTML5)
  (with-html-output-to-string (*standard-output* nil :indent T :prologue T)
    (:html (:head (:script :src "https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"))
           (:body
            (fmt "~A" view)))))

(defun tutorials (args)
  (let ((tut     (cdr (assoc ":tutorial" args :test 'equal)))
        (section (cdr (assoc ":section"  args :test 'equal))))
     ;; (cerror "debugging session" "tried ~a" args)
    (tutorials-layout
     args
     (cond
       ((equal tut "intro")
        (tutorial-intro))
       ((and (equal tut "expressions") (equal section "1"))
        (tutorial-expr1))
       (T
        "Error: section not implemented")))))

(defun tutorial-intro ()
  (with-html-output-to-string (*standard-output* nil :indent T)
    ;; (cerror "debugging session" "tried ~a" args)
    (:div :data-ng-app "myApp" :data-ng-controller "myCtrl"
          "First Name:" (:input :type "text" :data-ng-model "firstName") (:br)
          "Last Name:"  (:input :type "text" :data-ng-model "lastName")  (:br)
          (:br)
          (fmt "Full Name: {{ ~a }}" (ps (+ first-name " " last-name))))
    (:script
     (fmt "~%~A"
          (ps
            ;; last AngularJS Example from
            ;; https://www.w3schools.com/angular/angular_intro.asp
            (var app (chain angular (module "myApp" (array))))
            (chain app (controller "myCtrl" (lambda ($scope)
                                              (setf (@ $scope first-name) "John")
                                              (setf (@ $scope last-name) "Doe")
                                              (return undefined)))))))))


(defun tutorial-expr1 ()
  (with-html-output-to-string (*standard-output* nil :indent T)
    (:div :ng-app ""
          (:p (fmt "My first expression: {{ ~a }}" (ps (+ 5 5)))))))
