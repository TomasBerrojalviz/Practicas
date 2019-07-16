llenarChico(bidones(Ch,G),bidones(3,G)):- Ch < 3.
llenarGrande(bidones(Ch,G),bidones(Ch,5)):- G < 5.
vaciarChico(bidones(Ch,G),bidones(0,G)):- Ch > 0.
vaciarGrande(bidones(Ch,G),bidones(Ch,0)):- G > 0.
pasarAlChico(bidones(Ch,G),bidones(NuevoCh,NuevoG)):-
		G > 0, Ch < 3,
		NuevoCh is min(3 , Ch + G),
		NuevoG is (Ch + G - NuevoCh).
pasarAlGrande(bidones(Ch,G),bidones(NuevoCh,NuevoG)):-
		Ch > 0, G < 5,
		NuevoG is min(5 , Ch + G),
		NuevoCh is (Ch + G - NuevoG).


accion(llenarChico).
accion(llenarGrande).
accion(vaciarChico).
accion(vaciarGrande).
accion(pasarAlChico).
accion(pasarAlGrande).

cumplido(bidones(R,_),R).
cumplido(bidones(_,R),R).

resolverBidones1(Objetivo,_,[],Bidones):- cumplido(Bidones,Objetivo).
resolverBidones1(Objetivo,Limite,[Accion | Acciones],Bidones):-
	Limite > 0,
	not(cumplido(Bidones,Objetivo)),
	accion(Accion),
	call(Accion,Bidones,NuevosBidones),
	NuevoLimite is Limite - 1,
	resolverBidones1(Objetivo,NuevoLimite,Acciones,NuevosBidones).

resolverBidones(Objetivo,Limite,Acciones):-
	Objetivo =< 5, Objetivo >= 0,
	resolverBidones1(Objetivo,Limite,Acciones,bidones(0,0)).