% installed(package_name, version)
:- dynamic installed/2.
installed('p1', '1.2.3').
installed('p2', '3.8.9').
installed('p3', '2.1.7').

%install-p/5(package_name, version).
install-p().

%install/5(package_name, version).
install(package_name, version):- asserta(installed(package_name, version)).
%install(package_name, version):- installed(package_name, version),!.

%depends(package, version, name, version, flag).