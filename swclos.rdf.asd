;;;; swclos.rdf.asd -*- Mode: Lisp;-*- 

(cl:in-package :asdf)

(defsystem :swclos.rdf
  :serial t
  :depends-on (:fiveam :puri :closer-mop :named-readtables)
  :components ((:file "package")
               (:file "Utils")
               (:file "RdfIO")
               (:file "IRI")
               (:file "Xml")
               (:file "rdferror")
               (:file "NameSpace")
               (:file "Literal")
               (:file "RDFShare")
               (:file "Rdf")
               (:file "RdfReader")
               (:file "node")
               (:file "readtable")
               (:file "test")))


#|(defsystem :rdf #|(:pretty-name "RDF subsystem of SWCLOS"
                       :default-pathname #,*swclos-directory*)|#
  (:module :utils        "../RDF/Utils")
  #|(:module :rdfio        "../RDF/RdfIO")|#
  #|(:module :iri          "../RDF/IRI")|#
  #|(:module :swclospackages "../RDF/packages")|#
  #|(:module :xml          "../RDF/Xml"          (:load-before-compile :swclospackages))|#
  #|(:module :rdferror     "../RDF/rdferror"     (:load-before-compile :utils :swclospackages))|#
  #|(:module :namespace    "../RDF/NameSpace"    (:load-before-compile :swclospackages))|#
  #|(:module :litreal      "../RDF/Literal"      (:load-before-compile :utils :swclospackages))|#
  #|(:module :rdfshare     "../RDF/RDFShare"     (:load-before-compile :swclospackages :rdfio :namespace))|#
  #|(:module :rdfrdf       "../RDF/Rdf"          (:load-before-compile :swclospackages :namespace :rdfshare))|#
  #|(:module :rdfform      "../RDF/RdfReader"    (:load-before-compile :swclospackages))|#
  #|(:module :rdfnode      "../RDF/node"         )|#
  )|#


(defmethod perform ((o test-op) (c (eql (find-system :swclos.rdf))))
  (load-system :swclos.rdf)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :swclos.rdf.internal :swclos.rdf))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))

