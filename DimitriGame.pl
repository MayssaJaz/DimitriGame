
%Exercice 1 :

% 1.
:-dynamic rocher/2.
:-dynamic arbre/2.




% 2.
:-dynamic vache/4.


% 3.
:- dynamic dimitri/2.


% 4.
largeur(15).
hauteur(10).

% 5.
nombre_rochers(8).
nombre_arbres(5).
nombre_vaches(brune,9).
nombre_vaches(simmental,9).
nombre_vaches(alpine_herens,9).



%Exercice 2:

% 1.
occupe(X,Y):-arbre(X,Y).
occupe(X,Y):-rocher(X,Y).
occupe(X,Y):-vache(X, Y, Race, Etat).
occupe(X,Y):-dimitri(X,Y).

% 2.
libre(X,Y):- largeur(L),hauteur(H),repeat, X1 is random(L), Y1 is random(H),not(occupe(X1,Y1)),!,X is X1, Y is Y1.


% 3.

placer_rochers(0).
placer_rochers(N):-N>0,libre(X,Y),assert(rocher(X,Y)),N1 is N-1,placer_rochers(N1).
placer_arbres(0).
placer_arbres(N):-N>0,libre(X,Y),assert(arbre(X,Y)),N1 is N-1,placer_arbres(N1).
placer_vaches(Race,0).
placer_vaches(Race,N):-N>0,libre(X,Y),assert(vache(X,Y,Race,vivante)),N1 is N-1,placer_vaches(Race,N1).
placer_dimitri:-libre(X,Y),assert(dimitri(X,Y)).

% 4.
vaches(L):-findall((X,Y),vache(X,Y,_,_),L).
% 5.
random_list([], []).
random_list(L, [X,Y]) :-
length(L, S),
I is random(S),
nth0(I, L, (X,Y)).


creer_zombie:-vaches(L),random_list(L,[X,Y]),retract(vache(X,Y,Race,vivante)),assert(vache(X,Y,Race,zombie)).


%Exercice 3:

% 1.
question(R):-print('Dans quel direction vous voulez deplacer Dimitri'),nl,read(R).



% 2.
morte(X,Y):-vache(X,Y,_,zombie).
zombification(X,Y):-X1 is X-1,morte(X1,Y),retract(vache(X,Y,R,vivante)),assert(vache(X,Y,R,zombie)),!.
zombification(X,Y):-X1 is X+1,morte(X1,Y),retract(vache(X,Y,R,vivante)),assert(vache(X,Y,R,zombie)),!.
zombification(X,Y):-Y1 is Y-1,morte(X,Y1),retract(vache(X,Y,R,vivante)),assert(vache(X,Y,R,zombie)),!.
zombification(X,Y):-Y1 is Y+1,morte(X,Y1),retract(vache(X,Y,R,vivante)),assert(vache(X,Y,R,zombie)),!.
zombification(X,Y).
zombification([]).
zombification([(X,Y)|L]):-zombification(X,Y),zombification(L).
zombification:-vaches(L),zombification(L).

% 3.

deplacement_vache([]).
random_move(L,M):-length(L, S),I is random(S),nth0(I,L,M).
deplacement_vache([(X,Y)|L]):-random_move([east,est,reste,nord,sud],M),deplacement_vache(X,Y,M),deplacement_vache(L).
deplacement_vaches:-vaches(L),deplacement_vache(L).
deplacement_vache(X, Y, reste):!.
deplacement_vache(X, Y, nord):- Y>0,Y1 is Y-1,not(occupe(X,Y1)),retract(vache(X,Y,Race,Etat)),assert(vache(X,Y1,Race,Etat)),!.
deplacement_vache(X, Y, sud):- hauteur(H),Y<H-1,Y1 is Y+1,not(occupe(X,Y1)),retract(vache(X,Y,Race,Etat)),assert(vache(X,Y1,Race,Etat)),!.
deplacement_vache(X, Y, ouest):- X>0,X1 is X-1,not(occupe(X1,Y)),retract(vache(X,Y,Race,Etat)),assert(vache(X1,Y,Race,Etat)),!.
deplacement_vache(X, Y,est):-largeur(L),X<L-1,X1 is X+1,not(occupe(X1,Y)),retract(vache(X,Y,Race,Etat)),assert(vache(X1,Y,Race,Etat)),!.
deplacement_vache(X, Y,_).

% 4.
deplacement_joueur(reste):!.
deplacement_joueur(nord):-dimitri(X,Y),Y>0,Y1 is Y-1,not(occupe(X,Y1)),retract(dimitri(X,Y)),assert(dimitri(X,Y1)),!.
deplacement_joueur(sud):-dimitri(X,Y),hauteur(H),Y<H-1,Y1 is Y+1,not(occupe(X,Y1)),retract(dimitri(X,Y)),assert(dimitri(X,Y1)),!.
deplacement_joueur(ouest):- dimitri(X,Y),X>0,X1 is X-1,not(occupe(X1,Y)),retract(dimitri(X,Y)),assert(dimitri(X1,Y)),!.
deplacement_joueur(est):- dimitri(X,Y),largeur(L),X<L-1,X1 is X+1,not(occupe(X1,Y)),retract(dimitri(X,Y)),assert(dimitri(X1,Y)),!.
deplacement_joueur(_).


% 5.
verification:-dimitri(X,Y),X1 is X+1,not(vache(X1,Y,_,zombie)),X2 is X-1,not(vache(X2,Y,_,zombie)),Y1 is Y+1,not(vache(X,Y1,_,zombie)),Y2 is Y -1,not(vache(X,Y2,_,zombie)).

% le reste est le code pr�d�fini du jeu
initialisation :-
  nombre_rochers(NR),
  placer_rochers(NR),
  nombre_arbres(NA),
  placer_arbres(NA),
  nombre_vaches(brune, NVB),
  placer_vaches(brune, NVB),
  nombre_vaches(simmental, NVS),
  placer_vaches(simmental, NVS),
  nombre_vaches(alpine_herens, NVH),
  placer_vaches(alpine_herens, NVH),
  placer_dimitri,
  creer_zombie,
  !.

affichage(L, _) :-
  largeur(L),
  nl.

affichage(L, H) :-
  rocher(L, H),
  print('O'),
  L_ is L + 1,
  affichage(L_, H).

affichage(L, H) :-
  arbre(L, H),
  print('T'),
  L_ is L + 1,
  affichage(L_, H).

affichage(L, H) :-
  dimitri(L, H),
  print('D'),
  L_ is L + 1,
  affichage(L_, H).

affichage(L, H) :-
  vache(L, H, brune, vivante),
  print('B'),
  L_ is L + 1,
  affichage(L_, H).
affichage(L, H) :-
  vache(L, H, brune, zombie),
  print('8'),
  L_ is L + 1,
  affichage(L_, H).

affichage(L, H) :-
  vache(L, H, simmental, vivante),
  print('S'),
  L_ is L + 1,
  affichage(L_, H).
affichage(L, H) :-
  vache(L, H, simmental, zombie),
  print('5'),
  L_ is L + 1,
  affichage(L_, H).

affichage(L, H) :-
  vache(L, H, alpine_herens, vivante),
  print('H'),
  L_ is L + 1,
  affichage(L_, H).
affichage(L, H) :-
  vache(L, H, alpine_herens, zombie),
  print('6'),
  L_ is L + 1,
  affichage(L_, H).

affichage(L, H) :-
  \+ occupe(L, H),
  print('.'),
  L_ is L + 1,
  affichage(L_, H).

affichage(H) :-
  hauteur(H).

affichage(H) :-
  hauteur(HMax),
  H < HMax,
  affichage(0, H),
  H_ is H + 1,
  affichage(H_).

affichage :-
  affichage(0),!.



jouer :-
  initialisation,
  tour(0, _).

tour_(_, _) :-
  \+ verification,
  write('Dimitri s\'est fait mordre'),!.
tour_(N, _) :-
  verification,
  M is N + 1,
  tour(M, _).

tour(N, R) :-
  affichage,
  question(R),
  deplacement_joueur(R),
  deplacement_vaches,
  zombification,
  tour_(N, R).



