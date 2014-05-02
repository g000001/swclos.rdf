;;;; package.lisp

(cl:in-package :cl-user)

#|(cl:defpackage :swclos.rdf
  (:use)
  (:export))|#

(defpackage :swclos.rdf.internal
  (:use :cl :gx :named-readtables :fiveam)
  (:shadowing-import-from :gx :typep :boundp))

(cl:defpackage "rdf"
  (:use ) ; supressing using common lisp package
  (:export "about"
           "XMLDatatype" 
           "inLang" 
           "resource" "ID" "parseType" "datatype" "nodeID"
           "Property" "List" "Statement" "subject" "predicate" "object" 
           "Bag" "Seq" "Alt" "value" "li" "XMLDecl" "RDF" "Description" "type"
           "nil" "first" "rest" "XMLLiteral" "XMLLiteral-equal"
           "_1" "_2" "_3" "_4" "_5" "_6" "_7" "_8" "_9"
           "type-p" "subclass-p")
  (:shadow "about" "resource" "Description" "Property" "ID")
  (:documentation "http://www.w3.org/1999/02/22-rdf-syntax-ns#"))


(cl:defpackage "xmlns"
  (:use ) ; supressing using common lisp package
  )

(cl:defpackage "xml"
  (:use ) ; supressing using common lisp package
  (:export "lang" )
  (:shadow "lang"))

(cl:defpackage :_                 ; this package is provided for nodeID symbol.
  (:use ) ; supressing using common lisp package
  )

(cl:defpackage "xsd"
  (:nicknames "xs")
  (:use ) ; supressing using common lisp package
  (:export "string" "boolean" "decimal" "float" "double" "dataTime" "time" "date"
           "gYearMonth" "gYear" "gMonthDay" "gDay" "gMonth" "hexBinary" "base64Binary"
           "anyURI" "normallizedString" "token" "language" "NMTOKEN" "Name" "NCName"
           "integer" "nonPositiveInteger" "negativeInteger" "long" "int" "short" "byte"
           "nonNegativeInteger" "unsignedLong" "unsignedInt" "unsignedShort" "unsignedByte"
           "positiveInteger" "simpleType" "anySimpleType" "true" "false"
           "duration" "duration-year" "duration-month" "duration-day" "duration-hour"
           "duration-minute" "duration-second")
  (:documentation "http://www.w3.org/2001/XMLSchema#"))


(cl:defpackage "rdfs"
  (:use ) ; supressing using common lisp package
  (:export "Resource" "Class" "subClassOf" "subPropertyOf" "seeAlso" "domain" "range"
           "isDefinedBy" "range" "domain" "Literal" "Container" "label" "comment" "member"
           "ContainerMembershipProperty" "Datatype")
  (:documentation "http://www.w3.org/2000/01/rdf-schema#"))

(defpackage "owl"
    (:use ) ; supressing using common lisp package
    (:export "Class" "Thing" "Nothing" "Restriction" "onProperty" "allValuesFrom" "someValuesFrom" "hasValue"
             "minCardinality" "maxCardinality" "cardinality"
             "allValuesFromRestriction" "someValuesFromRestriction" "hasValueRestriction" 
             "cardinalityRestriction" "Ontology"
             "oneOf" "differentFrom" "sameAs" "AllDifferent" "distinctMembers" "equivalentClass"
             "TransitiveProperty" "ObjectProperty" "DatatypeProperty" "FunctionalProperty" 
             "InverseFunctionalProperty" "SymmetricProperty" "inverseOf"
             "intersectionOf" "unionOf" "disjointWith" "complementOf" "equivalentProperty"
             "describe-slot-constraint" 
             "DataRange" "DeprecatedProperty" "DeprecatedClass" "incompatibleWith" "backwardCompatibleWith"
             "priorVersion" "versionInfo" "imports" "OntologyProperty" "AnnotationProperty"
             )
  ;; documentation is supplied from OWL.RDF file.
  )


(cl:defpackage :gx
  (:use :cl :net.uri)
  (:shadow :boundp :uri)
  (:shadow :parse-uri :type :typep :value :typep)
  (:export :mappend)
  (:export :*line-number* :*line-pos* :*pos* :expose-buf :skipbl
           :read-pattern-p :skip-pattern 
           :match-pattern-p)
  #+excl (:import-from :excl :compute-effective-slot-definition-initargs)
  #+sbcl (:import-from :sb-pcl :compute-effective-slot-definition-initargs)
  (:import-from :net.uri :render-uri :uri-fragment :copy-uri :uri-scheme)
  ;; IRI
  (:export :iri :boundp :bound-value)
  ;; rdferror
  (:export :quiet-warning-handler :with-quiet-warnings)
  ;; NameSpace
  (:export
   :iri :iri-p :iri-value :set-uri-namedspace
   :set-uri-namedspace-from-pkg :get-uri-namedspace :uri-namedspace :uri2package
   :uri2env :uri2symbol :irregular-name&pkg :export-as-qname :*base-uri*
   :*default-namespace* :symbol2uri :name-ontology :nodeid? :nodeid2symbol
   :*uri2symbol-name-mapping-fun* :*uri2symbol-package-mapping-fun*)
  (:export 
   :*entity-decls* :NameStartChar-p :NameChar-p :NCNameStartChar-p :NCNameChar-p
   :make-unique-nodeID
   :parse-iri :read-Eq :get-uri-namedspace :uri-namedspace :comment-p)
  (:export
   :*NameSpaces* :*default-namespace* :*base-uri* :set-uri-namedspace
   :name :uri2symbol :line :Description-p :Description-tag :Description-att&vals 
   :Description-elements :parse-rdf :lang :content
   :typep :parse-XMLDecl :read-AttValue :read-plane-text :read-as-datatype :^^
   )
  (:export :read-rdf-file)
  (:export :name)
  (:export :collect-prop-names-from)
  ;; rdfboot
  (:export ;; |rdfs:Resource| ???
   :metaRDFSclass :|rdfsClass| :*base-uri* :*reify-p*
   :nodeID? :nodeID2symbol :mclasses)
  (:export :property?
           :subPropertyOf)
  (:export :typep :class-direct-instances)
  (:documentation "http://www.TopOntologies.com/tools/SWCLOS#"))


;;; *EOF*
