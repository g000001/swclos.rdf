;;;; readtable.lisp

(cl:in-package :cl-user)
(named-readtables:in-readtable :common-lisp)

(named-readtables:defreadtable :swclos.rdf
  (:merge :standard)
  (:macro-char #\< #'gx::double-angle-bracket-reader t)
  (:macro-char #\_ #'gx::single-underscore-reader t)
  (:macro-char #\" #'|rdf|::read-string nil)
  (:case :preserve))


;;; *EOF*
