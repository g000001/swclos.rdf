;;;-*- Mode: common-lisp; syntax: common-lisp; package: gx; base: 10 -*-
;;;
;;;; Condition and Error Handling module
;;;
;;; This code is written by Seiji Koide.
;;; 
;;; Copyright (c) 2007 Seiji Koide
;;
;; History
;; -------
;; 2009.05.09    File created.
;;; ==================================================================================

#|(cl:provide :rdferror)|#

#|(eval-when (:execute :load-toplevel :compile-toplevel)
  (require :utils)
  (require :swclospackages)
)|# ; end of eval-when


(cl:in-package :gx)

;; These coding is from ANSI Common Lisp manual.
(defvar *all-quiet* nil)
(defvar *saved-warnings* '())

(defun quiet-warning-handler (c)
  (when *all-quiet*
    (let ((r (find-restart 'muffle-warning c)))
      (when r 
        (push c *saved-warnings*)
        (invoke-restart r)))))

(defmacro with-quiet-warnings (&body forms)
  `(let ((*all-quiet* t)
         (*saved-warnings* '()))
     (handler-bind ((warning #'quiet-warning-handler))
       ,@forms
       *saved-warnings*)))

(defvar *undo* '())
(defvar *undo-stack* '())
(defvar *undoed-operations* '())

(defun undoable-by-domain-condition-handler (condition)
  (declare (ignore condition))
  (when *undo*
    (loop for undo-ope in *undo-stack*
        do (funcall undo-ope))))

(defmacro with-undoable (&body forms)
  `(let ((*undo* t)
         (*undo-stack* '())
         (*undoed-operations* '()))
     (handler-bind ((invalid-slot-value-for-range #'invalid-slot-value-handler)
                    (range-condition-unsatisfiable #'undoable-by-range-condition-handler)
                    (domain-condition-unsatisfiable #'undoable-by-domain-condition-handler)
                    )
       ,@forms)))
       
;;;
;;;; Undoable Objects and Classes
;;;

(defclass undoable-metaclass (cl:standard-class)
  ()
  (:metaclass cl:standard-class))


(defmethod c2mop:validate-superclass ((c undoable-metaclass) 
                                      (s cl:standard-class))
  T)

(defclass undoable-class (cl:standard-object)
  ()
  (:metaclass undoable-metaclass))

#||
The class #<STANDARD-CLASS STANDARD-OBJECT> was specified as a
super-class of the class #<UNDOABLE-METACLASS UNDOABLE-CLASS>,
but the meta-classes #<STANDARD-CLASS STANDARD-CLASS> and
#<STANDARD-CLASS UNDOABLE-METACLASS> are incompatible.  Define a
method for SB-MOP:VALIDATE-SUPERCLASS to avoid this error.
   [Condition of type SIMPLE-ERROR]
||#


(defmethod shared-initialize :around ((instance undoable-class) slot-names &rest initargs)
  (format t "~%SHARED-INITIALIZE:AROUND(undoable-class) ~S ~S ~S" instance slot-names initargs)
  (when *undo*
    (push (apply #'make-undo-operation #'undo-shared-initialize instance slot-names initargs)
          *undo-stack*))
  (call-next-method))
