:- use_module(library(semweb/rdf_db)).

:- include('config.pl').
:- include('rules_basic.pl').
:- include('rules_combat.pl').
:- include('rules_inference.pl').

:- load_ontology.

start :-
    nl,
    write('==========================================================='), nl,
    write('                     NARUTO EXPERT SYSTEM                  '), nl,
    write('==========================================================='), nl,
    write('--- LEVEL 1: BASIC DATA ---'), nl,
    write(' 1. shinobi_info(Name, Village, Rank).   -> Basic profile'), nl,
    write(' 2. get_clan_members(Clan, Name).        -> Clan member'), nl,
    write(' 3. get_org_members(Org, Name).        -> Organization member'), nl,
    write(' 4. get_eye_users(EyeType, Name).        -> Dojutsu users'), nl,
    write(' 5. dual_dojutsu_users(Eye1, Eye2, ShinobiName).        -> Dojutsu users'), nl,
    write(' 6. check_status(Status, Name).          -> Check Alive/Deceased'), nl,
    write(' 7. bijuu_info(Jinchuuriki, Bijuu, Ekor).-> Jinchuuriki & Tails info'), nl,
    write(' 8. who_knows_jutsu(Jutsu, Name).        -> Who masters this Jutsu?'), nl,
    write(' 9. count_elements(Name, Total).         -> Element counter'), nl,
    write(' 10. shinobi_from_small_village(Village, Shinobi).         -> Shinobi from small village'), nl,
    write(' 11. shinobi_from_big_village(Village, Shinobi).         -> Shinobi from big village'), nl,
    nl,
    write('--- LEVEL 2: RELATIONS & STRATEGY ---'), nl,
    write(' 1. can_defeat(Winner, Loser).           -> Element simulation'), nl,
    write(' 2. suggest_counter_element(Enemy, You). -> Element suggestion'), nl,
    write(' 3. find_teacher(Student, Teacher).      -> Finding teachers'), nl,
    write(' 4. find_grand_teacher(Student, Grand).  -> Finding grandteachers'), nl,
    write(' 5. find_peers(Name, Peer).               -> Finding peers (same rank and same village)'), nl,
    write(' 6. balanced_team_check(P1,P2,P3,Result).-> Check team balanceness'), nl,
    nl,
    write('--- LEVEL 3: ADVANCED INFERENCE ---'), nl,
    write(' 1. is_legendary(Name).                  -> Kage/Sennin with at least 2 element'), nl,
    write(' 2. potential_akatsuki_target(Name, Bij).-> Living target of akatsuki'), nl,
    write(' 3. high_threat_level(Name, Level).      -> Threat analysis'), nl,
    write(' 4. kekkei_genkai_user(Name, Jutsu).     -> Kekkei genkai users'), nl,
    write(' 5. village_protector(Name).             -> Active kage'), nl,
    write(' 6. village_traitor(Name, Origin).       -> Village traitor list'), nl,
    write(' 7. akatsuki_candidate(Name).            -> Akatsukis new member candidates'), nl,
    write('==========================================================='), nl.