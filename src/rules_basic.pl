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

% Get Organization members
get_org_members(Org, Member) :-
    common_prefix(naruto, P),
    atom_concat(P, 'isOrgMemberOf', IsOrg),
    
    rdf(S, IsOrg, O),
    get_name(O, Org),
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

% Get shinobi with two eye types
dual_dojutsu_users(Eye1, Eye2, ShinobiName) :-
    common_prefix(naruto, P),
    atom_concat(P, 'hasEye', HasEyeProp),

    % First dojutsu restriction
    rdf(S, rdf:type, Restr1),
    rdf(Restr1, owl:onProperty, HasEyeProp),
    (   rdf(Restr1, owl:someValuesFrom, EyeClass1)
    ;   rdf(Restr1, owl:allValuesFrom,  EyeClass1)
    ),

    % Second dojutsu restriction
    rdf(S, rdf:type, Restr2),
    rdf(Restr2, owl:onProperty, HasEyeProp),
    (   rdf(Restr2, owl:someValuesFrom, EyeClass2)
    ;   rdf(Restr2, owl:allValuesFrom,  EyeClass2)
    ),

    % Must be two different dojutsu
    EyeClass1 \= EyeClass2,

    % Convert to names
    get_name(EyeClass1, Eye1),
    get_name(EyeClass2, Eye2),
    Eye1 @< Eye2,
    get_name(S, ShinobiName).

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
    atom_concat(P, 'tailNumber', TailNumProp),
    
    rdf(S, IsJin, B),
    rdf(B, TailNumProp, literal(type(_, TailAtom))),
    
    get_name(S, Jinchuuriki),
    get_name(B, BijuuName),

    atom_number(TailAtom, TailNumber).

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
    
    atom_concat(P, Shinobi, S), 
    
    findall(E, rdf(S, HasElem, E), List),
    length(List, Total).

% Finding shinobi from big Village
shinobi_from_big_village(Village, Shinobi) :-
    common_prefix(naruto, P),
    atom_concat(P, 'isFrom', IsFrom),
    atom_concat(P, 'Big_Village', Big_Village),
    rdf(S, IsFrom, VillageIRI),

    rdf(VillageIRI, rdf:type, Big_Village),
    get_name(S, Shinobi),
    get_name(VillageIRI, Village).

% Finding shinobi from small Village
shinobi_from_small_village(Village, Shinobi) :-
    common_prefix(naruto, P),
    atom_concat(P, 'isFrom', IsFrom),
    
    atom_concat(P, 'Small_Village', ClassSmallVillage),

    rdf(S, IsFrom, VillageIRI),
    rdf(VillageIRI, rdf:type, ClassSmallVillage),
    
    get_name(S, Shinobi),
    get_name(VillageIRI, Village).