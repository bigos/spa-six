(declaim (optimize (debug 3)))

(in-package :handlers)


;; AngularJS Directives - https://www.w3schools.com/angular/angular_directives.asp
(defun tut-directives1 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app "" :ng-init (ps-nosc (setf first-name "John"))
           (:p "Name: " (:input :type "text" :ng-model (ps-nosc first-name)))
           (:p (fmt "You wrote: ~a" (tash (ps-nosc first-name))))))))

;; Data Binding - https://www.w3schools.com/angular/angular_directives.asp
(defun tut-directives2 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app "" :ng-init  (ps-nosc (setf quantity 1 price 5))
           (fmt "~%Quantity: ")
           (:input :type "number" :ng-model (ps-nosc quantity))
           (fmt "~%Costs: ")
           (:input :type "number" :ng-model (ps-nosc price))
           (fmt "Total in dollar: ~a" (tash (ps-nosc (* quantity price))))))))
