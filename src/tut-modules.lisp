(in-package :handlers)

;; Adding a Controller - https://www.w3schools.com/angular/angular_modules.asp
(defun tut-modules1 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app (ps my-app) :ng-controller (ps my-ctrl)
           (fmt "~a"  (tash (ps-nosc (+ first-name " " last-name)))))
     (:script
      (fmt "~a"
           (ps
             (var app (chain angular (module (lisp (ps-nosc my-app)) (array))))
             (chain app (controller (lisp (ps-nosc my-ctrl))
                                (lambda ($scope)
                                  (setf (@ $scope first-name) "John"
                                        (@ $scope last-name) "Doe")
                                  (return undefined))))))))))

;; Adding a Directive - https://www.w3schools.com/angular/angular_modules.asp
(defun tut-modules2 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app (ps-nosc my-app) :w3-test-directive "" )
     (:script
      (fmt "~%~a"
           (ps
             (var app (chain angular (module (lisp (ps-nosc my-app)) (array))))
             (chain app (directive (lisp (ps-nosc w3-test-directive))
                                   (lambda ()
                                     (create template "I was made in a directive constructor!"))))))))))
