(in-package :handlers)

(defun tut-intro ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     ;; (cerror "debugging session" "tried ~a" args)
     (:div :data-ng-app (ps-nosc my-app) :data-ng-controller (ps-nosc my-ctrl)
           "First Name:" (:input :type "text" :data-ng-model (ps-nosc first-name)) (:br)
           "Last Name:"  (:input :type "text" :data-ng-model (ps-nosc last-name))  (:br)
           (:br)
           "Full Name: " (str (tash (ps-nosc (+ first-name " " last-name)))))
     (:script
      (fmt "~%~A"
           (ps
             ;; last AngularJS Example from
             ;; https://www.w3schools.com/angular/angular_intro.asp
             (var app (chain angular (module (lisp (ps-nosc my-app)) (array))))
             (chain app (controller (lisp (ps-nosc my-ctrl)) (lambda ($scope)
                                                           (setf (@ $scope first-name) "John")
                                                           (setf (@ $scope last-name) "Doe")
                                                           (return undefined))))))))))
