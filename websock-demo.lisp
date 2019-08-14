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
(log:config :debug)

(defvar *port* 5000)
(defvar *page* nil)

(defun start ()
  (weblocks/server:start :port *port*
                         :debug t
                         :server-type :woo)
  (setf lparallel:*kernel* (lparallel:make-kernel 4)))

(defun stop ()
  (lparallel.queue:push-queue :quit (queue *page*))
  (lparallel:end-kernel :wait t)
  (weblocks/server:stop)
  (setf *page* nil))

(defwidget counter-box (weblocks.websocket::websocket-widget)
  ((counter :initform 0
            :accessor counter)))

(defun make-counter-box ()
  (make-instance 'counter-box))

(defmethod render ((widget counter-box))
  (with-html
    (:p (format nil "The counter is at ~d." (counter widget)))))

(defmethod initialize-instance ((instance counter-box) &rest restargs)
  (declare (ignorable restargs))
  (call-next-method))

(defwidget page ()
  ((queue :initarg :queue
            :accessor queue)
   (box :initform (make-counter-box)
        :accessor box)))

(defun make-page ()
  (make-instance 'page
                 :queue (lparallel.queue:make-queue)))

(defmethod render ((widget page))
  (with-html
    (:div
     (render (box widget)))
    (:p (render-link
         #'(lambda (&rest args)
             (declare (ignorable args))
             (log:debug "render link: " (weblocks/widgets/dom:dom-id widget))
             (incf (counter (box  widget)))
             (lparallel.queue:push-queue
              (weblocks/widgets/dom:dom-id widget)
              (queue *page*)))
         "Count up!"))))

(defmethod initialize-instance ((instance page) &rest restargs)
  (declare (ignorable restargs))
  (call-next-method)
  (weblocks.websocket:in-thread ("Update counter")
    (do ((msg (lparallel.queue:pop-queue (queue instance))
              (lparallel.queue:pop-queue (queue instance))))
        ((eq msg :quit))
      (format *trace-output* "task: ~a~%" msg)
      (update (box instance)))))

(defapp demo)

(defmethod weblocks/session:init ((app demo))
  (declare (ignorable app))
  (setf *page* (make-page)))
