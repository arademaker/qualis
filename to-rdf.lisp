
;; Este script converte um arquivo qualis-?.text (CSV com separador |)
;; para RDF usando o Allegro Graph 4.X da Franz. Deve ser rodado com o
;; Allegro Lisp da Franz no Amazon Server.  O arquivo CSV deve ser
;; transferido para o servidor da amazon antes de rodar o script.

(ql:quickload :fare-csv)
(require :agraph "/usr/local/agraph-client/agraph4.fasl") 

(in-package :db.agraph.user)

(open-triple-store "qualis"
		   :triple-store-class 'remote-triple-store
		   ; add :user and :password
		   :server "127.0.0.1")
					
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


(defun res (str)
  (resource (format nil "http://www.fgv.br/qualis/area/~a" str)))


(defparameter *AREAS* (list `("ECONOMIA" . ,(res "Economia"))
			    `("ADMINISTRAÇÃO, CIÊNCIAS CONTÁBEIS E TURISMO" . ,(res "Administracao"))
			    `("DIREITO" . ,(res "Direito"))
			    `("CIÊNCIA DA COMPUTAÇÃO" . ,(res "Computacao"))
			    `("MATEMÁTICA, PROBABILIDADE E ESTATÍSTICA" . ,(res "Matematica"))
			    `("HISTÓRIA" . ,(res "Historia"))
			    `("INTERDISCIPLINAR" . ,(res "Interdisciplinar"))))


(defun insert-record (alist)
  " Add triples possible with duplications. "
  (let  ((res (resource (concatenate 'string "usn:ISSN:" (nth 0 alist)))))
    (with-blank-nodes (aval)
      (add-triple res !rdf:type !bibo:Journal)
      (add-triple res !dc:title (literal (nth 2 alist)))
      (add-triple res !bibo:issn (literal (nth 0 alist)))
      (add-triple res !fgvterms:hasScore aval)
      (add-triple aval !rdf:type !fgvterms:Score)
      (add-triple aval !fgvterms:area (cdr (assoc (nth 1 alist) *AREAS* :test #'string=)))
      (add-triple aval !fgvterms:estrato (literal (nth 3 alist)))
      (add-triple aval !fgvterms:anoBase (literal "2012")))))

(defun import-csv-file (filename)
  (let ((novos (fare-csv:read-csv-file filename)))
    (dolist (reg (subseq novos 1)) ; ignore heading
      (if (check-issn (nth 0 reg))
	  (insert-record reg)))))

(defun check-file (filename)
  (let ((novos (fare-csv:read-csv-file filename)))
    (push (mapcar #'check-issn 
		  (mapcar #'car (subseq novos 1))))))

(dolist (file (directory "*.csv"))
  (import-csv-file file))

