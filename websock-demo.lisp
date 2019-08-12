;;;; websock-demo.lisp

;; (ql:quickload :woo)
;; (ql:quickload :clack)
;; (ql:quickload :log4slime)
;; (ql:quickload :weblocks-ui)
;; (ql:quickload :weblocks-ui/form)
;; (ql:quickload :websocket-driver)
;; (ql:quickload :websock-demo)
;; (log:config :debug)

(in-package #:websock-demo)

(declaim (optimize (debug 3) (safety 3)))

(weblocks/debug:on)

(defvar *port* 5000)

(defun start ()
  (weblocks/server:start :port *port*
                         :debug t
                         :server-type :woo))

(defun stop ()
  (weblocks/server:stop))

(defwidget counter-box (weblocks.websocket::websocket-widget)
  ((counter :initform 0
            :accessor counter)))

(defun make-counter-box ()
  (make-instance 'counter-box))

(defmethod render ((widget counter-box))
  (with-html
    (:p (format nil "The counter is at ~d." (counter widget)))
    (:p (render-link
         (lambda (&rest args)
           (declare (ignorable args))
           (incf (counter widget)))
         "Count up!"))))

(defmethod initialize-instance ((instance counter-box) &rest restargs)
  (declare (ignorable restargs))
  (call-next-method)
  (weblocks.websocket:in-thread ("Update counter")
    (sleep 3)
    (incf (counter instance))
    (update instance)))

(defapp demo)

(defmethod weblocks/session:init ((app demo))
  (declare (ignorable app))
  (make-counter-box))

