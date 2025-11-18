:- use_module(library(semweb/rdf_db)).

common_prefix(naruto, 'http://www.semanticweb.org/qika/ontologies/2025/10/naruto-ontology#').

load_ontology :-
    write('Loading RDF Data... '),
    rdf_load('ontology/naruto.rdf'),
    write('Done!'), nl,
    register_prefixes.

register_prefixes :-
    common_prefix(Alias, URI),
    rdf_register_prefix(Alias, URI).