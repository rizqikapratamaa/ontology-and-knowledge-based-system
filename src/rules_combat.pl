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

% Finnding element weakness of a shinobi
element_weakness(Shinobi, WeakElement) :-
    common_prefix(naruto, P),
    atom_concat(P, 'hasElement', HasElem),
    atom_concat(P, Shinobi, S),

    rdf(S, HasElem, ElemURI),
    get_name(ElemURI, ElemName),

    downcase_atom(ElemName, ELower),

    superior(WeakLower, ELower),
    WeakElement = WeakLower.

% Finding dual shinobi who cover each other weakness
duo_cover_weakness(S1, S2, ElemS1, ElemS2) :-
    S1 \= S2,
    common_prefix(naruto, P),
    atom_concat(P, 'hasElement', HasElem),

    % Elemen milik S1
    atom_concat(P, S1, URI1),
    rdf(URI1, HasElem, E1URI),
    get_name(E1URI, ElemS1Name),
    downcase_atom(ElemS1Name, E1Lower),

    % Elemen milik S2
    atom_concat(P, S2, URI2),
    rdf(URI2, HasElem, E2URI),
    get_name(E2URI, ElemS2Name),
    downcase_atom(ElemS2Name, E2Lower),

    % S2 punya elemen yang superior terhadap elemen S1
    superior(E2Lower, E1Lower),

    ElemS1 = E1Lower,
    ElemS2 = E2Lower.
