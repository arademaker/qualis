
# CAPES Qualis

## Descrição

Meu objetivo é oferecer a tabela QUALIS em um formato estruturado e
processável. Os dados ainda serão transformados em RDF para serem
usados em outro projeto que estou trabalhando, o Lattes2RDF [2].

Atualmente apenas as seguintes áreas tiveram sua tabela qualis
processada:

 * Matemática, Probabilidade e Estatística
 * Ciência da Computação
 * Direito
 * Administração, Ciências Contábeis e Turismo
 * Economia
 * Interdisciplinar
 * História

As planilhas das áreas foram baixadas do site da CAPES [1] em
26/Jun/2012.

O arquivo to-rdf.lisp contém o código de geração do RDF a partir dos
arquivos baixados do site da CAPES. Como uso a triple store Allegro
Graph, este código só poderá ser rodado no Allegro Lisp.

Os arquivos baixados do site foram manualmente mesclados em um único
arquivo CSV. O separador dos campos foi alterado de tabulação para
"|". Finalmente, ocorrências de aspas foram removidas. Este arquivo
final foi então a entrada para o script Lisp.

## TODO

 * Acrescentar informações de outras áreas.
 * Acrescentar informações sobre periódicos como: homepage, links
   entre periódicos etc. Possívelmente usando algum crawler na Web.
 * Acrescentar informações sobre tabelas QUALIS anteriores, permitindo
   assim a análise das mudanças de avaliação dos periódicos.

## Links

 * [1] http://qualis.capes.gov.br/webqualis/
 * [2] https://github.com/arademaker/lattes2RDF

