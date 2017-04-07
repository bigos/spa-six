(declaim (optimize (debug 3)))

(defpackage :handlers
  (:use :cl :hunchentoot :cl-who :parenscript))

(in-package :handlers)

;;; make parenscript work nicely with cl-who
(setf *js-string-delimiter* #\")

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

;;; layout for normal pages
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

;;; layout for tutorials
(defun tutorials-layout (view)
  (setf (html-mode) :HTML5)
  (with-html-output-to-string (*standard-output* nil :indent T :prologue T)
    (:html (:head (:script :src "https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"))
           (:body
            (fmt "~A" view)))))

;;; tutorial examples ----------------------------------------------------------

(defun tut-intro ()
  (tutorials-layout
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
                                               (return undefined))))))))))

(defun tut-expr1 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app ""
           (:p (fmt "My first expression: {{ ~a }}" (ps (+ 5 5))))))))

(defun tut-expr3 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app "" :ng-init (ps (setf my-col "lightblue"))
           (:input :style "background-color:{{myCol}}" :ng-model "myCol" :value "{{myCol}}")))))

(defun tut-expr4 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app "" :ng-init (ps (setf quantity 1
                                         cost 5))
           (:p (fmt "Total in dollar: {{ ~a }}" (ps (* quantity cost))))))))

(defun tut-expr5 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app "" :ng-init (ps (setf quantity 1
                                         cost 5))
           (:p (fmt "Total in dollar: ") (:span :ng-bind (ps (* quantity cost))))))))


(defun tut-expr6 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app "" :ng-init (ps (setf first-name "John" last-name "Doe"))
           (:p (fmt "The name is {{ ~a }}" (ps (+ first-name " " last-name))))))))

(defun tut-expr7 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app "" :ng-init (ps (setf first-name "John" last-name "Doe"))
           (:p (fmt "The name is ") (:span :ng-bind (ps (+ first-name " " last-name))) )))))

;;; home page and tutorial handlers, tutorials are added above -----------------
(defun tutorials (args)
  (let ((tut (cdr (assoc ":tutorial" args :test #'equal)))
        (sec (cdr (assoc ":section"  args :test #'equal))))
    ;; (cerror "debugging uri params" "tried ~a" args)
    (labels ((t= (tu) (equal tut tu))
             (s= (s)  (equal sec s))
             (sec-error (s) (format nil "Section not implemented ~a" s)))
      (cond                             ;tutorials
        ((t= "intro")
         (cond ((s= "all") (tut-intro))  ;sections
               (T (sec-error sec))))
        ((t= "expressions")
         (cond ((s= "1") (tut-expr1))   ;sections
               ((s= "3") (tut-expr3))
               ((s= "4") (tut-expr4))
               ((s= "5") (tut-expr5))
               ((s= "6") (tut-expr6))
               ((s= "7") (tut-expr7))
               (T (sec-error sec))))
        (T (format nil "Error: tutorial not implemented ~a" tut))))))

(defun home ()
  (layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:h1 "Home")
     (:p "request " (fmt "~A" (script-name *request*)))
     (:h2 "Tutorials")
     (:p "based on" (:a
                     :href "https://www.w3schools.com/angular/default.asp"
                     "AngularJS Tutorial"))
     (:a :href "/angular/intro/all" "Intro") (:br)
     (:a :href "/angular/expressions/1" "Expressions 1") (:br)
     (:a :href "/angular/expressions/3" "Expressions 3") (:br)
     ;; AngularJS Numbers
     (:a :href "/angular/expressions/4" "Expressions 4") (:br)
     (:a :href "/angular/expressions/5" "Expressions 5") (:br)
     ;; AngularJS Strings
     (:a :href "/angular/expressions/6" "Expressions 6") (:br)
     (:a :href "/angular/expressions/7" "Expressions 7") (:br)

     )))
