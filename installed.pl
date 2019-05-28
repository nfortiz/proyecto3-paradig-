% installed(package_name, version)
:- dynamic installed/2.
installed('p1', '1.2.3').
installed('p2', '3.8.9').
installed('p3', '2.1.7').

%install-p/5(package_name, version). foreach(between(Y,9,Z),write(Z))(number_string(Z,Q),append(F, [Q], R) )
install-p(Package,Version):-not(installed(Package,Version),
                                findall([X,Y,Z], depends(Package,Version,X,Y,Z),K ),
                                install(K).

%install/5(package_name, version).
install([H|T]):-install(T),[P,O,I]=H, install(P,O,I).

install(Package, Version,Flag):- not(installed(Package, Version)),
                            get_version(Version,Flag,ListVersi),                            
                            asserta(installed(Package, Version)),!.

install(Package, Version,Flag):- installed(Package,Version),!.


%depends(package, version, name, version, flag).
depends('p11', '1.2.3', 'p7', '2.1.7', '*').
depends('p10', '3.2.3', 'p9', '7.1.0', '*').
depends('p10', '3.2.3', 'p8', '3.9.7', '^').

%Helppers
not(P) :- call(P), !, fail ; true.
not(P) :- call(P), !, true ; fail.

get_version(Version, '*',R):-split_string(Version,".","",L),[_,Y|X]=L, number_string(H,Y), get_ListV(-1,9,L,[],R).
get_version(Version, '^',R):-convert(Version,KS),[_,_,K]=KS,generator_2(KS,K,[],RR),join_two(RR,[],R).
get_version(Version, '~',R):-get_version(Version, '*',R).

get_ListV(F,F,L,R,R).
get_ListV(I,F,L,A,R):-I\==F->
                    N is I+1, [U,_,T]=L,
                    number_string(N,Y),string_concat(U,"." ,Un),
                    string_concat(Un,Y,Ds ),
                    string_concat(Ds,".",Ts ),
                    string_concat(Ts,T,K),
                    get_ListV(N,F,L,[K|A],R);
                    R=A.


convert(V,R):-split_string(V, ".", "", L),conv(L, [], Y), rev(Y,[], R).
conv([],X,X):-!.
conv([H|T],A,X):-number_string(Y, H), conv(T,[Y|A],X).
rev([],X,X):-!.
rev([H|T],A,X):-rev(T,[H|A],X).

join_str(LS,R):-join_con(LS,"",R).
join_con([],R,R):-!.
join_con([H|T],A,R):-concat(A,H,S),join_con(T,S,R).
join(E,R):-E=[X,Y,Z],number_string(X,XS),number_string(Y,YS),
number_string(Z,ZS),join_str([XS,'.',YS,'.',ZS],R).

join_two([],X,X):-!.
join_two([H|T],A,X):- join(H,Y), join_two(T,[Y|A],X).

generator_2([X,Y,_],K,A,R):- 
K == 10 -> 
    Z is Y+1, R = [[X,Z,0]|A],!;
    SS = [[X,Y,K]|A], K2 is K+1, generator_2([X,Y,K],K2,SS,R).