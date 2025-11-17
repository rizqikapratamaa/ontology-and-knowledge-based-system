% Finding a legendary (Shinobi with Kage/Sennin rank and masters at least 2 elements)
is_legendary(Name) :-
    common_prefix(naruto, P),
    atom_concat(P, 'hasElement', HasElem),
    
    (   rdf(S, rdf:type, Type), 
        (get_name(Type, 'Kage') ; get_name(Type, 'Sennin'))
    ),
    
    findall(E, rdf(S, HasElem, E), ListElemen),
    length(ListElemen, Count),
    Count >= 2,
    
    get_name(S, Name).

% Potential akatsuki target can be defined as a jinchuuriki who is still alive
potential_akatsuki_target(Name, BijuuName) :-
    common_prefix(naruto, P),
    atom_concat(P, 'isJinchuurikiOf', IsJinOf),
    atom_concat(P, 'status', StatusProp),
    
    rdf(S, IsJinOf, BijuuURI),
    rdf(S, StatusProp, literal(type(_, 'Alive'))),
    
    get_name(S, Name),
    get_name(BijuuURI, BijuuName).

% EXTREME: akatsuki member with kekkei genkai
% HIGH: common nukenin
high_threat_level(Name, 'EXTREME') :-
    common_prefix(naruto, P),
    atom_concat(P, 'AkatsukiMember', Akatsuki),
    atom_concat(P, 'KekkeiGenkai', KG), atom_concat(P, 'masterJutsu', MJ),
    rdf(S, rdf:type, Akatsuki), rdf(S, MJ, J), rdf(J, rdf:type, KG),
    get_name(S, Name).
high_threat_level(Name, 'HIGH') :-
    common_prefix(naruto, P), atom_concat(P, 'Nukenin', Nukenin),
    atom_concat(P, 'AkatsukiMember', Akatsuki),
    rdf(S, rdf:type, Nukenin), \+ rdf(S, rdf:type, Akatsuki),
    get_name(S, Name).

% Find someone with kekkei genkai ability
kekkei_genkai_user(Name, JutsuName) :-
    common_prefix(naruto, P),
    atom_concat(P, 'masterJutsu', MasterProp),
    atom_concat(P, 'KekkeiGenkai', KGClass),
    
    rdf(S, MasterProp, J),
    rdf(J, rdf:type, KGClass),
    
    get_name(S, Name),
    get_name(J, JutsuName).

% A kage who is still alive
village_protector(Name) :-
    common_prefix(naruto, P),
    atom_concat(P, 'Kage', KageClass),
    atom_concat(P, 'status', StatusProp),
    
    rdf(S, rdf:type, KageClass),
    rdf(S, StatusProp, literal(type(_, 'Alive'))),
    
    get_name(S, Name).

% Shinobi from village "X" but with Nukenin rank
village_traitor(Name, AsalDesa) :-
    common_prefix(naruto, P),
    atom_concat(P, 'isFrom', IsFrom),
    atom_concat(P, 'Nukenin', ClassNukenin),
    
    rdf(S, rdf:type, ClassNukenin),
    rdf(S, IsFrom, D),
    get_name(S, Name),
    get_name(D, AsalDesa).

% Living nukenin , with S rank (Jounin/Kage/Sennin) but not an akatsuki member yet.
akatsuki_candidate(Name) :-
    common_prefix(naruto, P),
    atom_concat(P, 'AkatsukiMember', ClassAkatsuki),
    atom_concat(P, 'Nukenin', ClassNukenin),
    
    rdf(S, rdf:type, ClassNukenin),
    
    get_name(S, Name),
    
    check_status('Alive', Name),
    
    \+ rdf(S, rdf:type, ClassAkatsuki),
    
    (   shinobi_info(Name, _, 'Jounin')
    ;   shinobi_info(Name, _, 'Kage')
    ;   shinobi_info(Name, _, 'Sennin')
    ).


% Akatsuki member who is still alive
surviving_akatsuki_member(Name) :-
    common_prefix(naruto, P),
    atom_concat(P, 'AkatsukiMember', Akatsuki),
    atom_concat(P, 'status', StatusProp),
    
    rdf(S, rdf:type, Akatsuki),
    \+ rdf(S, StatusProp, literal(type(_, 'Deceased'))),

    get_name(S, Name).

seven_swordsmen_member(Name) :-
    common_prefix(naruto, P),
    atom_concat(P, 'Seven_Swordmans_of_The_Mist', OrgURI),
    get_org_members('Seven_Swordmans_of_The_Mist', Name).

% Living Seven Swordsmen members
surviving_seven_swordsmen(Name) :-
    seven_swordsmen_member(Name),
    check_status('Alive', Name).

% Seven Swordsmen who betrayed the Mist (became Nukenin)
rogue_seven_swordsmen(Name) :-
    common_prefix(naruto, P),
    atom_concat(P, 'Nukenin', NukeninClass),
    
    seven_swordsmen_member(Name),
    atom_concat(P, Name, URI),
    rdf(URI, rdf:type, NukeninClass).

% Loyal Seven Swordsmen (not traitors, from Kirigakure)
loyal_seven_swordsmen(Name) :-
    common_prefix(naruto, P),
    atom_concat(P, 'Nukenin', NukeninClass),
    
    seven_swordsmen_member(Name),
    shinobi_info(Name, 'Kirigakure', _),
    atom_concat(P, Name, URI),
    \+ rdf(URI, rdf:type, NukeninClass).