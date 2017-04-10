(in-package :handlers)

(defun tut-modules1 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app (ps my-app) :ng-controller (ps my-ctrl)
           (fmt "~a"  (tash (ps (+ first-name " " last-name)))))
     (:script
      (fmt "~a"
           (ps
             (var app (chain angular (module (lisp (ps my-app)) (array))))
             (chain app (controller (lisp (ps my-ctrl))
                                (lambda ($scope)
                                  (setf (@ $scope first-name) "John"
                                        (@ $scope last-name) "Doe")
                                  (return undefined))))))))))

;; Adding a Directive - https://www.w3schools.com/angular/angular_modules.asp
(defun tut-modules2 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app (nosc (ps my-app)) :w3-test-directive "" )
     (:script
      (fmt "~%~a"
           (ps
             (var app (chain angular (module (lisp (nosc (ps my-app))) (array))))
             (chain app (directive (lisp (nosc (ps w3-test-directive)))
                                   (lambda ()
                                     (create template "I was made in a directive constructor!"))))))))))
