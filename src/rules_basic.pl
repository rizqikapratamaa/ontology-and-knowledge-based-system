get_name(URI, Name) :- rdf_split_url(_, Name, URI).

% Get shinobi info
shinobi_info(Name, Village, Rank) :-
    common_prefix(naruto, P),
    atom_concat(P, 'isFrom', IsFrom),
    
    rdf(S, IsFrom, D),
    rdf(S, rdf:type, R),
    
    (   rdf_split_url(_, 'Genin', R)
    ;   rdf_split_url(_, 'Chuunin', R)
    ;   rdf_split_url(_, 'Jounin', R)
    ;   rdf_split_url(_, 'Kage', R)
    ;   rdf_split_url(_, 'Sennin', R)
    ),
    
    get_name(S, Name),
    get_name(D, Village),
    get_name(R, Rank).

% Get clan members
get_clan_members(Clan, Member) :-
    common_prefix(naruto, P),
    atom_concat(P, 'isClanMemberOf', IsClan),
    
    rdf(S, IsClan, K),
    get_name(K, Clan),
    get_name(S, Member).

% Get dojutsu users
get_eye_users(EyeType, Shinobi) :-
    common_prefix(naruto, P),
    atom_concat(P, 'hasEye', HasEyeProp),

    rdf(S, rdf:type, TypeNode),

    rdf(TypeNode, owl:onProperty, HasEyeProp),
    
    (   rdf(TypeNode, owl:someValuesFrom, EyeClassURI)
    ;   rdf(TypeNode, owl:allValuesFrom, EyeClassURI)
    ),
    
    get_name(EyeClassURI, EyeName),
    get_name(S, Shinobi),
    
    downcase_atom(EyeName, EyeLower),
    downcase_atom(EyeType, InputLower),
    EyeLower = InputLower.

% Checking who is still alive or deceased
check_status(Status, Shinobi) :-
    common_prefix(naruto, P),
    atom_concat(P, 'status', StatusProp),
    
    rdf(S, StatusProp, literal(type(_, Status))), 
    get_name(S, Shinobi).

% Finding who is the jinchuuriki and how many the bijuu tails
bijuu_info(Jinchuuriki, BijuuName, TailNumber) :-
    common_prefix(naruto, P),
    atom_concat(P, 'isJinchuurikiOf', IsJin),
    atom_concat(P, 'tailNumber', TailNum),
    rdf(S, IsJin, B),
    rdf(B, TailNum, literal(type(_, Tail))),
    get_name(S, Jinchuuriki),
    get_name(B, BijuuName),
    atom_number(TailsCountAtom, Tail),
    TailNumber = TailsCountAtom.

% Finding people who master certain jutsu
who_knows_jutsu(JutsuName, Shinobi) :-
    common_prefix(naruto, P),
    atom_concat(P, 'masterJutsu', MasterProp),
    rdf(S, MasterProp, J),
    get_name(J, JName),
    get_name(S, Shinobi),
    downcase_atom(JName, J1), downcase_atom(JutsuName, J2), J1 = J2.

% Counting how many element a shinobi could mastered
count_elements(Shinobi, Total) :-
    common_prefix(naruto, P),
    atom_concat(P, 'hasElement', HasElem),
    get_name(S, Shinobi), % Bind nama dulu
    findall(E, rdf(S, HasElem, E), List),
    length(List, Total).