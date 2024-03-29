;;;-*- Mode: common-lisp; syntax: common-lisp -*-

#|(cl:provide :rdfnode)|#


(in-package :gx)

;;;; gnode & rdf-node
;;; rdf-node will be a superclass of rdfs:Class. 
;;; gnode will be a superclass of rdfs:Resource. 
;;; gnode class is needed for registration of class-instance relation. 

(defclass rdf-node (standard-class)
  ((direct-instances :initarg :direct-instances
                     :initform nil 
                     :accessor class-direct-instances))
  (:documentation "This metaclass is node class. This metaclass provides method class-direct-instances"))

(defmethod c2mop:validate-superclass ((class rdf-node)
                                      (super standard-class))
  T)


(defclass gnode ()
  ((|EXCL::NAME| :initarg :name :initform nil)      ;???excl::name
   (iri :initarg :iri :initform nil :accessor iri)
   (mclasses :initarg :mclasses :initform nil :accessor mclasses)
   (type-tag :initform nil :accessor type-tag)
   ;(inv-plist :initform nil)
   )
  (:metaclass rdf-node)
  (:documentation "This class is needed to maintain mclasses."))




;;; An element of direct-instances slot are initially stored by <make-instance(rdf-node)> method 
;;; and maintained by <update-instance-for-different-class:after(gnode)> which is invoked by 
;;; change-class.

(defmethod make-instance ((class rdf-node) &rest initargs)
  (declare (ignore initargs))
  (let ((instance (call-next-method)))
    (push instance (class-direct-instances class))
    instance))

(defun shadowed-class-p (x)
  "returns true if <x> is an instance of shadowed class.
   shadowed-class is defined at RdfsObjects file."
  (eq (class-name (class-of x)) 'shadowed-class))

(defmethod update-instance-for-different-class :after ((previous gnode) current &rest initargs)
  (declare (ignore initargs))
  (cond ((cl:typep current 'destroyed-class)
         (let ((old-class (class-of previous)))
           (setf (class-direct-instances old-class)
             (remove current (class-direct-instances old-class) :test #'eq))
           ))
        (t (let ((old-class (class-of previous))
                 (new-class (class-of current)))
             ;; domain constraint should be satisfied, if old-class was satisfied.
             ;; class direct instances handling
             (setf (class-direct-instances old-class)
               (remove current (class-direct-instances old-class) :test #'eq))
             (push current (class-direct-instances new-class))
             ;; mclasses handling
             (cond ((shadowed-class-p current)
                    (labels ((get-bright-supers (super)
                                                (cond ((not (shadowed-class-p super)) (list super))
                                                      (t (mapcan #'get-bright-supers (c2mop:class-direct-superclasses super))))))
                      (setf (mclasses current) 
                        (remove-duplicates (mapcan #'get-bright-supers (c2mop:class-direct-superclasses new-class))))))
                   (t (setf (mclasses current) (list new-class))))))))

(defun node-p (x)
  (cl:typep x 'gnode))

(defun bnode-p (node)
  (or (not (slot-value node '|EXCL::NAME|)) ;???excl::name
      (not (symbol-package (slot-value node '|EXCL::NAME|)))))

(defmethod ground? ((node gnode))
  (and (slot-value node '|EXCL::NAME|)
       (symbol-package (slot-value node '|EXCL::NAME|))))

(defmethod name ((node symbol))
  node)

(defmethod name ((node gnode))
  "returns a QName or a nodeID of <node>, if it exists. Otherwise nil."
  (let ((name (slot-value node '|EXCL::NAME|)))
    (when (and name (symbol-package name)) name))) ; name might have uninterned symbol.

(defmethod (setf name) (symbol (node gnode))
  "exports <symbol> for QName."
  (setf (slot-value node '|EXCL::NAME|) symbol)
  (export-as-QName symbol)
  (setf (symbol-value symbol) node))
