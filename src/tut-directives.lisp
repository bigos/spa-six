(in-package :handlers)


;; AngularJS Directives - https://www.w3schools.com/angular/angular_directives.asp
(defun tut-directives1 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app "" :ng-init (lisp (nosc (ps (setf first-name "John"))))
           (:p "Name: " (:input :type "text" :ng-model (nosc (ps first-name))))
           (:p (fmt "You wrote: ~a" (tash (nosc (ps first-name)))))))))

(defun tut-directives2 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app "" :ng-init (lisp (nosc (ps (setf quantity 1 price 5))))
           (fmt "~%Quantity: ")
           (:input :type "number" :ng-model (nosc (ps quantity)))
           (fmt "~%Costs: ")
           (:input :type "number" :ng-model (nosc (ps price)))
           (fmt "Total in dollar: ~a" (tash (nosc (ps (* quantity price)))))
           ))))
