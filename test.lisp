(in-package :swclos.rdf.internal)

(def-suite swclos.rdf)
(in-suite swclos.rdf)

#|
:cd C:\allegro-projects\SWCLOS\RDFS\  -> C:\allegro-projects\SWCLOS\RDFS\
/(with-open-file (p "Intro.rdf") (parse-rdf p))
->
 (<?xml version="1.0" ?> 
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:gxpr="http://galaxy-express.co.jp/MEXT/RDF/0.1/Prolog#"
         xmlns="http://galaxy-express.co.jp/MEXT/RDF/0.1/Prolog#">
  <rdf:Property rdf:ID="likes"/>
  <rdf:Description rdf:ID="Kim"><gxpr:likes rdf:resource="#Robin" /></rdf:Description>
  <rdf:Description rdf:ID="Sandy"><gxpr:likes rdf:resource="#Lee" /><gxpr:likes rdf:resource="#Kim" /></rdf:Description>
  <rdf:Description rdf:ID="Robin"><gxpr:likes rdf:resource="#cats" /></rdf:Description>
</rdf:RDF>)

:cd C:\allegro-projects\SWCLOS\RDFS\IntroExample
 (with-open-file (p "Example.rdf") (parse-rdf p))
|#

;; End of module
;; --------------------------------------------------------------------


(test intro.rdf
  (gx::resetxlist)
  (is-true
   (string= 
    (with-output-to-string (out)
      (let ((*readtable* (named-readtables:find-readtable :swclos.rdf)))
        (with-open-file (p (asdf:system-relative-pathname :swclos.rdf 
                                                          "Intro.rdf")) 
          (print (parse-rdf p) out))))
    "
\(<?xml version=\"1.0\" ?> 
<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"
         xmlns:gxpr=\"http://galaxy-express.co.jp/MEXT/RDF/0.1/Prolog#\"
         xmlns=\"http://galaxy-express.co.jp/MEXT/RDF/0.1/Prolog#\">
  <rdf:Property rdf:ID=\"likes\"/>
  <rdf:Description rdf:ID=\"Kim\">
    <gxpr:likes rdf:resource=\"#Robin\" />
  </rdf:Description>
  <rdf:Description rdf:ID=\"Sandy\">
    <gxpr:likes rdf:resource=\"#Lee\" />
    <gxpr:likes rdf:resource=\"#Kim\" />
  </rdf:Description>
  <rdf:Description rdf:ID=\"Robin\">
    <gxpr:likes rdf:resource=\"#cats\" />
  </rdf:Description>
</rdf:RDF>) ")))


(test lang63.rdf
  (gx::resetxlist)
  (is-true
   (string= 
    (with-output-to-string (out)
      (let ((*readtable* (named-readtables:find-readtable :swclos.rdf)))
        (with-open-file (p (asdf:system-relative-pathname :swclos.rdf
                                                          "Lang63.rdf")) 
          (print (parse-rdf p) out))))
"
\(<?xml version=\"1.0\" encoding=\"utf-8\" ?> 
<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\">
  <rdf:Description rdf:about=\"http://www.w3.org/TR/rdf-syntax-grammar\">
    <dc:title>RDF/XML Syntax Specification (Revised)</dc:title>
    <dc:title xml:lang=\"en\">RDF/XML Syntax Specification (Revised)</dc:title>
    <dc:title xml:lang=\"en-US\">RDF/XML Syntax Specification (Revised)</dc:title>
  </rdf:Description>
  <rdf:Description rdf:about=\"http://example.org/buecher/baum\" xml:lang=\"de\">
    <dc:title>Der Baum</dc:title>
    <dc:description>Das Buch ist ausergewohnlich</dc:description>
    <dc:title xml:lang=\"en\">The Tree</dc:title>
  </rdf:Description>
</rdf:RDF>) ")))

(test symbol2uri
  (is (equal
       (loop for x being each external-symbol
             in (find-package :|rdfs|)
             collect (symbol2uri x))
       (let ((*readtable* (named-readtables:find-readtable :swclos.rdf)))
         (read-from-string 
          "(<http://www.w3.org/2000/01/rdf-schema#isDefinedBy>
         <http://www.w3.org/2000/01/rdf-schema#Class>
         <http://www.w3.org/2000/01/rdf-schema#member>
         <http://www.w3.org/2000/01/rdf-schema#Datatype>
         <http://www.w3.org/2000/01/rdf-schema#subPropertyOf>
         <http://www.w3.org/2000/01/rdf-schema#comment>
         <http://www.w3.org/2000/01/rdf-schema#Literal>
         <http://www.w3.org/2000/01/rdf-schema#label>
         <http://www.w3.org/2000/01/rdf-schema#domain>
         <http://www.w3.org/2000/01/rdf-schema#subClassOf>
         <http://www.w3.org/2000/01/rdf-schema#seeAlso>
         <http://www.w3.org/2000/01/rdf-schema#Resource>
         <http://www.w3.org/2000/01/rdf-schema#ContainerMembershipProperty>
         <http://www.w3.org/2000/01/rdf-schema#range>
         <http://www.w3.org/2000/01/rdf-schema#Container>)")
         ))))

;;(getxlist)
;;(resetxlist)

#|(gx::resetxlist)|#

#|(let ((*readtable* (named-readtables:find-readtable :swclos.rdf)))
  (with-open-file (p "/l/src/rw/swclos.rdf/Intro.rdf") 
    (funcall (gx::make-rdf/xml-parser p) #'list)))|#


;;; *EOF*
