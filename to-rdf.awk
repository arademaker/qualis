
BEGIN { 
    FS = "|"
    OFS = ""
    print "@prefix      rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> ."
    print "@prefix     rdfs: <http://www.w3.org/2000/01/rdf-schema#> ."
    print "@prefix      owl: <http://www.w3.org/2002/07/owl#> ."
    print "@prefix      xsd: <http://www.w3.org/2001/XMLSchema#> ."
    print "@prefix     foaf: <http://xmlns.com/foaf/0.1/> ."
    print "@prefix       dc: <http://purl.org/dc/elements/1.1/> ."
    print "@prefix  dcterms: <http://purl.org/dc/terms/> ."
    print "@prefix     bibo: <http://purl.org/ontology/bibo/> ."
    print "@prefix fgvterms: <http://www.fgv.br/terms/> ."
    print ""
}

NR > 1 { 
    printf "<urn:ISSN:%s> rdf:type bibo:Journal . \n", $7
    printf "<urn:ISSN:%s> dc:title \"%s\". \n", $7, $3
    printf "<urn:ISSN:%s> bibo:issn \"%s\" ; fgvterms:hasScore _:a%s . \n", $7, $7, NR

    printf "_:a%s rdf:type fgvterms:Score . \n", NR
    printf "_:a%s fgvterms:area \"%s\" . \n", NR, $2
    printf "_:a%s fgvterms:estrato \"%s\" ; fgvterms:anoBase \"%s\" . \n", NR, $4, $5
    print ""
}

