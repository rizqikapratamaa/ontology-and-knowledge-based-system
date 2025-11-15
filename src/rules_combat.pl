superior(katon, futon).
superior(futon, raiton).
superior(raiton, doton).
superior(doton, suiton).
superior(suiton, katon).

% ShinobiX can defeat ShinobiY based on element superiority
can_defeat(ShinobiX, ShinobiY) :-
    common_prefix(naruto, P),
    atom_concat(P, 'hasElement', HasElem),
    
    rdf(URI_X, HasElem, ElemX),
    rdf(URI_Y, HasElem, ElemY),
    
    get_name(ElemX, NameX),
    get_name(ElemY, NameY),
    
    downcase_atom(NameX, E1),
    downcase_atom(NameY, E2),
    
    superior(E1, E2),
    
    get_name(URI_X, ShinobiX),
    get_name(URI_Y, ShinobiY).

% Element suggestion to counter the enemy's element
suggest_counter_element(EnemyElement, ElementSuggestion) :-
    downcase_atom(EnemyElement, E_Musuh),
    superior(E_Kita, E_Musuh),
    ElementSuggestion = E_Kita.

% Find teacher and student
find_teacher(Student, Teacher) :-
    common_prefix(naruto, P),
    atom_concat(P, 'hasTeacher', HasTeacher),
    
    rdf(S, HasTeacher, T),
    get_name(S, Student),
    get_name(T, Teacher).

% Find grandteachers of a student
find_grand_teacher(Student, GrandTeacher) :-
    find_teacher(Student, Guru),
    find_teacher(Guru, GrandTeacher).

% Shinobi from the same village and the same rank
find_peers(Shinobi, Comrade) :-
    shinobi_info(Shinobi, Desa, Rank),
    shinobi_info(Comrade, Desa, Rank),
    Shinobi \= Comrade.

% A team consist of 3 shinobis is considered as balanced if they have minimum of 3 different element
balanced_team_check(P1, P2, P3, 'BALANCED') :-
    common_prefix(naruto, P), atom_concat(P, 'hasElement', HE),
    findall(E, (rdf(S, HE, E), (get_name(S, P1); get_name(S, P2); get_name(S, P3))), AllElements),
    sort(AllElements, UniqueElements),
    length(UniqueElements, Count),
    Count >= 3.

balanced_team_check(_, _, _, 'IMBALANCE').