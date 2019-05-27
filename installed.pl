% installed(package_name, version)
:- dynamic installed/2.
installed('p1', '1.2.3').
installed('p2', '3.8.9').
installed('p3', '2.1.7').

%install-p/5(package_name, version).
install-p(Package,Version,Flag):-not(installed(Package, Version)), findall(dep(X,Y), depends(Package,Version,X,Y,Z),K ),display(K).% install(Package, Version).

%install/5(package_name, version).
install(Package, Version,Flag):- not(installed(Package, Version)),
                            asserta(installed(Package, Version)),!.%Si no debe agregarlo
install(Package, Version,Flag):- installed(Package,Version),!.%Verifica que exista el paquete


%depends(package, version, name, version, flag).
depends('p11', '1.2.3', 'p7', '2.1.7', '^').
depends('p10', '3.2.3', 'p9', '7.1.0', '^').
depends('p10', '3.2.3', 'p8', '3.9.7', '^').

%Helppers
not(P) :- call(P), !, fail ; true.