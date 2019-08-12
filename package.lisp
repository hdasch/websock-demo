;;;; package.lisp

(defpackage #:websock-demo
  (:use #:cl)
  (:import-from #:weblocks/actions
                #:make-js-action)
  (:import-from #:weblocks/app
                #:defapp)
  (:import-from #:weblocks/widget
                #:defwidget
                #:render
                #:update)
  (:import-from #:weblocks.websocket
                #:websocket-widget
                #:in-thread
                #:send-command)
  (:import-from #:weblocks-ui/form
                #:render-link)
  (:import-from #:weblocks/html
                #:with-html))
