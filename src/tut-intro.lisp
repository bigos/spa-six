(in-package :handlers)

(defun tut-intro ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     ;; (cerror "debugging session" "tried ~a" args)
     (:div :data-ng-app "myApp" :data-ng-controller "myCtrl"
           "First Name:" (:input :type "text" :data-ng-model "firstName") (:br)
           "Last Name:"  (:input :type "text" :data-ng-model "lastName")  (:br)
           (:br)
           (fmt "Full Name: ~a" (tash (ps (+ first-name " " last-name)))))
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
