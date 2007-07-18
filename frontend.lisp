;;;; -*- Mode: lisp; indent-tabs-mode: nil -*-
;;;
;;; texinfo-docstrings.lisp --- Front-end script.
;;;
;;; Copyright (C) 2007, Luis Oliveira  <loliveira@common-lisp.net>
;;;
;;; Permission is hereby granted, free of charge, to any person
;;; obtaining a copy of this software and associated documentation
;;; files (the "Software"), to deal in the Software without
;;; restriction, including without limitation the rights to use, copy,
;;; modify, merge, publish, distribute, sublicense, and/or sell copies
;;; of the Software, and to permit persons to whom the Software is
;;; furnished to do so, subject to the following conditions:
;;;
;;; The above copyright notice and this permission notice shall be
;;; included in all copies or substantial portions of the Software.
;;;
;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;;; NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
;;; HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
;;; WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
;;; DEALINGS IN THE SOFTWARE.

(in-package #:cl-launch)

(defun print-help-and-quit ()
  (write-line "Usage: texinfo-docstrings [html|pdf|all] <system> <filename> <title> <css style> packages...")
  (quit 1))

(when (< (length *arguments*) 6)
  (write-line "Not enough arguments.")
  (print-help-and-quit))

(defparameter *output*
  (let ((arg1 (first *arguments*)))
    (cond
      ((string-equal arg1 "html") 'html)
      ((string-equal arg1 "pdf") 'pdf)
      ((string-equal arg1 "all") 'all)
      (t (print-help-and-quit)))))

(defparameter *system* (second *arguments*))
(defparameter *filename* (third *arguments*))
(defparameter *title* (fourth *arguments*))
(defparameter *css-style* (fifth *arguments*))
(defparameter *packages* (mapcar #'string-upcase (nthcdr 5 *arguments*)))

(load-system *system*)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (asdf:oos 'asdf:load-op :texinfo-docstrings))

(apply #'texinfo-docstrings:generate-includes "include/" *packages*)

(defparameter *sysdir*
  (namestring
   (make-pathname :directory
                  (pathname-directory
                   (asdf:system-definition-pathname
                    (asdf:find-system :texinfo-docstrings))))))

(defparameter *gendocs-template-dir*
  (or (getenv "GENDOCS_TEMPLATE_DIR") *sysdir*))

(when (string-equal *css-style* "default")
  (setq *css-style*
        (format nil "~Astyles/~A"
                *sysdir*
                (case *output*
                  (html "edi-style.css")
                  (t "style.css")))))

(let ((asdf::*verbose-out* *terminal-io*))
  (ecase *output*
    (html
     (asdf:run-shell-command "echo not yet"))
    (pdf
     (asdf:run-shell-command "echo not yet"))
    (all
     (asdf:run-shell-command
      "GENDOCS_TEMPLATE_DIR=~A sh ~Agendocs.sh --html \"--css-include=~A\" ~A \"~A\""
      *gendocs-template-dir* *sysdir* *css-style* *filename* *title*))))
