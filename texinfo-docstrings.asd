;;;; -*- Mode: lisp; indent-tabs-mode: nil -*-

(asdf:defsystem texinfo-docstrings
  :depends-on (#-sbcl closer-mop)
  :components ((:file "docstrings")))

;; vim: ft=lisp et
