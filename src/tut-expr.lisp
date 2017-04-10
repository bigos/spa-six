(in-package :handlers)

(defun tut-expr1 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app ""
           (:p (fmt "My first expression: ~a" (tash (ps (+ 5 5)))))))))

(defun tut-expr3 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app "" :ng-init (ps (setf my-col "lightblue"))
           (:input :style (format nil "background-color:~a" (tash (ps my-col)))
                   :ng-model (ps my-col)
                   :value (tash (ps my-col)))))))

(defun tut-expr4 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app "" :ng-init (ps (setf quantity 1
                                         cost 5))
           (:p (fmt "Total in dollar: ~a" (tash (ps (* quantity cost)))))))))

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
           (:p (fmt "The name is ~a" (tash (ps (+ first-name " " last-name)))))))))

(defun tut-expr7 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app "" :ng-init (ps (setf first-name "John" last-name "Doe"))
           (:p (fmt "The name is ") (:span :ng-bind (ps (+ first-name " " last-name))) )))))


(defun tut-expr8 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app "" :ng-init (ps (setf person (create first-name "John" last-name "Doe")))
           (:p (fmt "The name is ~a" (tash (ps (@ person last-name)))))))))

(defun tut-expr9 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app "" :ng-init (ps (setf person (create first-name "John" last-name "Doe")))
           (:p (fmt "The name is ") (:span :ng-bind  (ps (@ person last-name))))))))

(defun tut-expr10 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app "" :ng-init (ps (setf points (array 1 15 19 2 40)))
           (:p (fmt "The third result is ~a" (tash (ps (aref points 2)))))))))


(defun tut-expr11 ()
  (tutorials-layout
   (with-html-output-to-string (*standard-output* nil :indent T)
     (:div :ng-app "" :ng-init (ps (setf points (array 1 15 19 2 40)))
           (:p (fmt "The third result is ") (:span :ng-bind (ps (aref points 2))))))))
