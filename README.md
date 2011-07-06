
# CAPES Qualis

## Descrição

Meu objetivo é oferecer a tabela QUALIS em um formato estruturado e
processável. Os dados ainda serão transformados em RDF para serem
usados em outro projeto que estou trabalhando, o Lattes2RDF [2].

Atualmente apenas as seguintes áreas tiveram sua tabela qualis
processada:

 * MATEMÁTICA / PROBABILIDADE E ESTATÍSTICA
 * CIÊNCIA DA COMPUTAÇÃO
 * ADMINISTRAÇÃO, CIÊNCIAS CONTÁBEIS E TURISMO
 * ECONOMIA

As planilhas das áreas foram baixadas do site da CAPES [1]. Em
seguida, os dados foram limpos usando o Emacs e R [3]. Informações
como referências a descontinuidade do periódico, desmembramento ou
agrupamento de periódico em outros e outras observações foram
separadas do título do periódico.

## TODO

 * Transformar em RDF o data.frame "qualis".
 * Acrescentar informações de outras áreas.
 * Acrescentar informações sobre periódicos como: homepage, links
   entre periódicos etc.
 * Acrescentar informações sobre tabelas QUALIS anteriores, permitindo
   assim a análise das mudanças de avaliação dos periódicos.
 * Possíveis correções e verificações dos dados.


## Links

 * [1] http://qualis.capes.gov.br/webqualis/
 * [2] https://github.com/arademaker/lattes2RDF
 * [3] http://www.r-project.org/

