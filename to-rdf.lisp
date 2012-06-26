
;; Este script converte um arquivo qualis-?.text (CSV com separador |)
;; para RDF usando o Allegro Graph 4.X da Franz. Deve ser rodado com o
;; Allegro Lisp da Franz no Amazon Server.  O arquivo CSV deve ser
;; transferido para o servidor da amazon antes de rodar o script.

(ql:quickload :fare-csv)
(require :agraph) 

(in-package :db.agraph.user)

(create-triple-store "qualis")

(enable-!-reader)
(enable-print-decoded t)

(register-namespace "foaf" "http://xmlns.com/foaf/0.1/" :errorp nil)
(register-namespace "dc" "http://purl.org/dc/elements/1.1/" :errorp nil)
(register-namespace "dcterms" "http://purl.org/dc/terms/" :errorp nil)
(register-namespace "bibo" "http://purl.org/ontology/bibo/" :errorp nil)
(register-namespace "swrc" "http://swrc.ontoware.org/ontology#" :errorp nil)
(register-namespace "ly" "http://www.fgv.br/lyceum/0.1/" :errorp nil)
(register-namespace "gn" "http://www.geonames.org/ontology#" :errorp nil)
(register-namespace "geo" "http://www.w3.org/2003/01/geo/wgs84_pos#" :errorp nil)
(register-namespace "event" "http://purl.org/NET/c4dm/event.owl#" :errorp nil)
(register-namespace "fgvterms" "http://www.fgv.br/terms/" :errorp nil)
(register-namespace "skos" "http://www.w3.org/2004/02/skos/core#" :errorp nil)

(setq fare-csv:*separator* #\|)

(defun check-issn (str)
  " Parse a string of 8 digits in the format NNNN-NNNN representing an
    ISSN number. The last N can be an X representing 10. "
  (let ((digits (remove nil (loop for char across str
				  collect (cond ((equal char #\X) 10)
						((equal char #\-) nil)
						(t (parse-integer (string char))))))))
    (if (not (equal (length digits) 8))
	nil
	(equal 0 (mod (loop for i from 8 downto 1
			    for j in digits 
			    summing (* j i)) 11)))))


(defun make-res (str)
  (resource (format nil "http://www.fgv.br/qualis/area/~a" str)))


(defparameter *AREAS* (list `("ECONOMIA" . ,(make-res "Economia"))
			    `("ADMINISTRAÇÃO, CIÊNCIAS CONTÁBEIS E TURISMO" . ,(make-res "Administracao"))
			    `("DIREITO" . ,(make-res "Direito"))
			    `("CIÊNCIA DA COMPUTAÇÃO" . ,(make-res "Computacao"))
			    `("MATEMÁTICA, PROBABILIDADE E ESTATÍSTICA" . ,(make-res "Matematica"))
			    `("HISTÓRIA" . ,(make-res "Historia"))
			    `("INTERDISCIPLINAR" . ,(make-res "Interdisciplinar"))))


(defun insert-record (alist)
  (let* ((res   (resource (concatenate 'string "usn:ISSN:" (nth 0 alist))))
	 (news  nil))
    (with-blank-nodes (aval)
      (push (list res !rdf:type !bibo:Journal) news)
      (push (list res !dc:title (literal (nth 1 alist))) news)
      (push (list res !bibo:issn (literal (nth 0 alist))) news)
      (push (list res !fgvterms:hasScore aval) news)
      (push (list aval !rdf:type !fgvterms:Score) news)
      (push (list aval !fgvterms:area (cdr (assoc (nth 2 alist) *AREAS* :test #'string=))) news)
      (push (list aval !fgvterms:estrato (literal (nth 3 alist))) news)
      (push (list aval !fgvterms:anoBase (literal "2012")) news)
      (push (list aval !fgvterms:classification (literal (nth 4 alist))) news))
    (dolist (n news)
      (if (not (get-triple :s (nth 0 n) :p (nth 1 n) :o (nth 2 n)))
	  (add-triple (nth 0 n) (nth 1 n) (nth 2 n))))))

(defun import-csv-file (filename)
  (let ((novos (fare-csv:read-csv-file filename)))
    (dolist (reg (subseq novos 1)) ; ignore heading
      (print reg)
      (if (check-issn (nth 0 reg))
	  (insert-record reg)))))


(import-csv-file "/tmp/qualis-3.text")
