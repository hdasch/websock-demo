;;;; websock-demo.asd

(asdf:defsystem #:websock-demo
  :description "Describe websock-demo here"
  :author "Hugh Daschbach <hdasch@fastmail.com>"
  :license  "Public Domain"
  :version "0.0.1"
  :serial t
  :depends-on (#:woo
               #:clack
               #:log4slime
               #:weblocks-ui
               #:weblocks-ui/form
               #:websocket-driver
               #:weblocks-websocket)
  :components ((:file "package")
               (:file "websock-demo")))
