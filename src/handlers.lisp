(declaim (optimize (debug 3)))

(in-package :handlers)

;;; make parenscript work nicely with cl-who
(setf *js-string-delimiter* #\")

(defun nosc (sequence)
  "Removes last semicolon from the SEQUENCE."
  (let ((last-character (subseq sequence (1- (length sequence)))))
    (if (equal last-character ";")
        (subseq sequence 0 (1- (length sequence)))
        sequence)))

(defmacro ps-nosc (body)
  "Convert BODY to JavaScript and optionally remove last semicolon."
  `(nosc ,`(ps ,body)))

(defun tash (body)
  "Wraps BODY with moustache {{ }} brackets."
  (format nil "{{ ~a }}" body))

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


(defun about ()
  "about page")

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
         (cond ((s= "all") (tut-intro)) ;sections
               (T (sec-error sec))))
        ((t= "expressions")
         (cond ((s= "1")  (tut-expr1))  ;sections
               ((s= "3")  (tut-expr3))
               ((s= "4")  (tut-expr4))
               ((s= "5")  (tut-expr5))
               ((s= "6")  (tut-expr6))
               ((s= "7")  (tut-expr7))
               ((s= "8")  (tut-expr8))
               ((s= "9")  (tut-expr9))
               ((s= "10") (tut-expr10))
               ((s= "11") (tut-expr11))
               (T (sec-error sec))))
        ((t= "modules")
         (cond ((s= "1") (tut-modules1)) ;sections
               ((s= "2") (tut-modules2))
               (T (sec-error sec))))
        ((t= "directives")
         (cond ((s= "1") (tut-directives1)) ;sections
               ((s= "2") (tut-directives2))
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
     (:p
      (:a :href "/angular/intro/all" "Intro") (:br))
     (:p
      (:a :href "/angular/expressions/1" "Expressions 1") (:br)
      (:a :href "/angular/expressions/3" "Expressions 3") (:br)
      ;; AngularJS Numbers
      (:a :href "/angular/expressions/4" "Expressions 4") (:br)
      (:a :href "/angular/expressions/5" "Expressions 5") (:br)
      ;; AngularJS Strings
      (:a :href "/angular/expressions/6" "Expressions 6") (:br)
      (:a :href "/angular/expressions/7" "Expressions 7") (:br)
      ;; AngularJS Objects
      (:a :href "/angular/expressions/8" "Expressions 8") (:br)
      (:a :href "/angular/expressions/9" "Expressions 9") (:br)
      ;; AngularJS Arrays
      (:a :href "/angular/expressions/10" "Expressions 10") (:br)
      (:a :href "/angular/expressions/11" "Expressions 11") (:br))
     (:p
      ;; Adding a Controller
      (:a :href "/angular/modules/1" "Modules 1") (:br)
      ;; Adding a Directive
      (:a :href "/angular/modules/2" "Modules 2") (:br))
     (:p
      (:a :href "/angular/directives/1" "Directives 1") (:br)
      (:a :href "/angular/directives/2" "Directives 2") (:br)))))
