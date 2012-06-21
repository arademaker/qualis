
;; Este script converte um arquivo qualis-?.text (CSV com separador |)
;; para RDF usando o Allegro Graph 3.3 da Franz. Deve ser rodado com o
;; Allegro Lisp da Franz.
;;
;; TODO: 
;;  - verificar ISSN antes de importar
;;  - corrigir ISSN tirando - e espacos
;;  - tratar ISSNs invalidos e nulos

(ql:quickload :fare-csv) 

(setq fare-csv:*separator* #\|)


(defun insert-record (alist)
  (let* ((news   nil)
	 (novos  nil)
	 (res    (resource (concatenate 'string "http://www.fgv.br/people/" (nth 0 doc))))
	 (names   (list (nth 1 doc) (nth 5 doc)))
	 (schools (list (nth 2 doc) (nth 4 doc))))
    (progn 
      (push (list res !rdf:type !foaf:Agent) news)
      (push (list res !fgvterms:cpf (literal (nth 0 doc))) news)
      (dolist (n names)
	(if (not (string= n "NA"))
	    (push (list res !foaf:name (literal n)) news)))
      (dolist (n schools)
	(if (not (string= n "NA"))
	    (push (list (cadr (assoc n *groups* :test #'string=)) !foaf:member res) news)))
      (if (not (string= (nth 3 doc) "NA"))
	  (let ((programa (resource (concatenate 'string "http://www.fgv.br/programa/" (nth 3 doc)))))
	    (push (list programa !foaf:member res) news)
	    (push (list programa !rdf:type !foaf:Group) news))))
    (dolist (n news novos)
      (if (not (get-triple :s (nth 0 n) :p (nth 1 n) :o (nth 2 n)))
	  (push (add-triple (nth 0 n) (nth 1 n) (nth 2 n)) novos)))))  


(defun import-file (filename)
  (let ((novos (fare-csv:read-csv-file filename)))
    (dolist (reg (subseq novos 1)) ; ignore heading
      (insert-record reg))))


(import-file "qualis-3.text")
