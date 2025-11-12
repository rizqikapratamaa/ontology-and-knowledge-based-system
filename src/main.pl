:- use_module(library(semweb/rdf_db)).
:- rdf_prefix(naruto, 'http://www.semanticweb.org/qika/ontologies/2025/10/naruto-ontology#').
:- rdf_load('data/naruto.rdf').

jinchuuriki(Orang):-
    rdf(Orang, naruto:isJinchuurikiOf, _Bijuu).