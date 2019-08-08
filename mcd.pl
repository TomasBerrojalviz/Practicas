mcd(1,0,1).
mcd(0,1,1).
mcd(Numero1,Numero2,MCD):-
	Resto is mod(Numero1,Numero2),
	Resto \= 0,
	mcd(Numero2,Resto,MCD).
	
mcd(Numero1,Numero2,MCD):-
	0 is mod(Numero1,Numero2),
	MCD is min(Numero1,Numero2).
	
primos(Primos):-
	findall(Primo,primo(Primo),Primos).

numerosNaturales(Naturales):-
	findall(Numero,between(1,1000,Numero),Naturales).

primo(Numero):-
	numerosNaturales(Naturales),
	select(1,Naturales,Naturales1),
	select(Numero,Naturales1,Naturales2),
	forall(member(Numero2,Naturales2),condicionPrimo(Numero,Numero2)).
	
condicionPrimo(NumPrimo,Num):-
	Resto is mod(NumPrimo,Num),
	Resto \= 0.
	
factor(Numero,Factor):-
	primos(Primos),
	select(Factor,Primos,_),
	condicionDeFactor(Numero,Factor).

condicionDeFactor(Num,Factor):-
	Resto is mod(Num,Factor),
	not(Resto \= 0).
	
cantidadDePrimos(Cantidad):-
	primos(Primos),
	length(Primos,Cantidad).

multiplicarLista([], 1).

multiplicarLista([X|Xs], S):-
          multiplicarLista(Xs, S2),
          S is S2 * X.

factores(1,[]).
factores(Numero,[Factor | Factores]):-
	factor(Numero,Factor),
	NuevoNumero is (Numero//Factor),
	factores(NuevoNumero,Factores).
	
factoresComunes([],_,_).
factoresComunes([Factor1 |Factores1],Factores2,FactoresComunes):-
	select(Factor1,Factores2,FactoresRestantes),
	factoresComunes(Factores1,FactoresRestantes,FactoresComunes).

	
subConjunto([],[]).
subConjunto([X|L1],[X|L2]) :-
	subConjunto(L1,L2).
subConjunto([_|L1],L2) :-
	subConjunto(L1,L2).
	
mcd21(Numero1,Numero2,MCD):-
	factores(Numero1,Factores1),
	factores(Numero2,Factores2),
	intersection(Factores1,Factores2,FactoresComunes),
	multiplicarLista(FactoresComunes,MCD),
	factor(Numero1,MCD),
	factor(Numero2,MCD).