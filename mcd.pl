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
	
factores(Numero,Factores):-
	findall(Factor,factor(Numero,Factor),Factores).
	
mcd2(Numero1,Numero2,MCD):-
	factores(Numero1,Factores1),
	factores(Numero2,Factores2),
	select(MCD,Factores1,_),
	member(MCD,Factores2).