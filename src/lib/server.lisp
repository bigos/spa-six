(defpackage :server
  (:use :common-lisp :cl-ppcre :hunchentoot)
  (:export :restart-acceptor
           :create-custom-dispatcher
           :add-routes))

(in-package :server)

;; Loosely based on the example from:
;; http://weitz.de/hunchentoot/#subclassing-acceptors

;;; need to add development or production profiles
(when T
  (setf
   *catch-errors-p* nil              ; nil jumps to debugger on errors
   *show-lisp-errors-p* T
   *show-lisp-backtraces-p* T))

;;; ---------- DEBUGGING REQUESTS ----------
;;; when *catch-errors-p* is nil you can do something like the following
;;; (cerror "debugging request" "tried argument ~a" 'some-argument)

;;; Subclass ACCEPTOR
(defclass vhost (acceptor)
  ;; slots
  ((dispatch-table
    :initform '()
    :accessor dispatch-table
    :documentation "List of dispatch functions"))
  ;; options
  (:default-initargs                   ; default-initargs must be used
   :address "127.0.0.1"))              ; because ACCEPTOR uses it


(defparameter *file-root* (cl-fad:merge-pathnames-as-directory
                           "~/Programming/Lisp/spa-six/assets/"))

;;; Instantiate VHOST
(defvar vhost1 (make-instance 'vhost
                              :port 5000
                              :document-root *file-root*))

;;; ----------------------------------------------------------------------------
;;; helpers for extracting parameters from url

(defun split-by-slash (string)
  "Splits STRING on slashes."
  (cdr                                  ; urls start with slash
   (loop for i = 0 then (1+ j)
      as j = (position #\/ string :start i)
      collect (subseq string i j)
      while j)))

(defun starts-with-colon (str)
  "Checks if the STRing starts with a colon."
  (unless (zerop (length str)) (equal (subseq str 0 1) ":")))

(defun build-regex (str)
  "Builds a regular expression splitting STR on / and replacing :keywords with
regex parts."
  (let ((parts (mapcar
                (lambda (c)
                  (if (starts-with-colon c)
                      "\\w+"         ; replace keyword with regex part
                      c))
                (split-by-slash str))))
    (with-output-to-string (s)          ; build regex
      (loop for p in parts
         do (format s "\\/~A" p)))))

(defun match-args (regex-builder url)
  "Builds params alist based on matching REGEX-BUILDER and URL."
  (loop
     with params = nil
     for key in (split-by-slash regex-builder)
     for val in (split-by-slash url)
     do
       (when (starts-with-colon key)
         (setf params (acons key val params))) ; associate params
     finally
       (return (reverse params))))      ; we reverse for readability
;;; ----------------------------------------------------------------------------

;;; Specialise ACCEPTOR-DISPATCH-REQUEST for VHOSTs
(defmethod acceptor-dispatch-request ((vhost vhost) request)
  ;; try REQUEST on each dispatcher in turn
  (mapc (lambda (dispatcher) ; as defined in the function create-custom-dispatcher
          (let ((handler-obj (funcall dispatcher request) ))
            ;; (cerror "debugging request" "request ~a ~A ~A" (script-name request)  handler-obj dispatcher)
            (if (consp handler-obj)
                (let ((handler-cons handler-obj)) ; version with script-name arguments
                  (when (car handler-cons) ; Handler found. APPLY it and return result
                    (return-from acceptor-dispatch-request (apply (car handler-cons)
                                                                  (list (cdr handler-cons))))))
                (let ((handler handler-obj)) ; version without arguments
                  (when handler              ; Handler found.
                    (return-from acceptor-dispatch-request (funcall handler)))))))
        (dispatch-table vhost))
  (call-next-method))

(defun create-custom-dispatcher (http-verb regex-builder handler)
  "Creates a request dispatch function which will dispatch to the function
denoted by HANDLER if the HTTP-VERB is correct and if the file name of  the
current request matches the CL-PPCRE regular expression based on REGEX-BUILDER."
  (let* ((regex (build-regex regex-builder))
         (scanner (create-scanner regex)))
    (lambda (request)
      (and
       (or (equal http-verb :ALL)      ; we pass :all if we don't care
           (equal http-verb (request-method request)))
       (scan scanner (script-name request)) ; regex matching
       (cons handler ; handler cons used in acceptor-dispatch-request
             (match-args regex-builder (script-name request)))))))

;;; the lambda from above becomes the route below

;;; Populate the dispatch table
(defun add-routes (routes)
  ;; clear previously defined routes so we do not have to restart the server
  (setf (dispatch-table vhost1) '())
  ;; add route lambdas reversing them first so top routes are dispatched first
  (loop for route-lambda in (reverse routes)
     do (push route-lambda (dispatch-table vhost1))))

;;; Start VHOST
(defun restart-acceptor ()
  (unless (hunchentoot::acceptor-shutdown-p vhost1)
    (stop vhost1))
  (start vhost1))
