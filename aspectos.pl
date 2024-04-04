% Definimos los aspectos y sus puntos como hechos dinámicos
:- dynamic aspecto/2.

% Hechos iniciales para los aspectos y sus puntos
aspecto(humano, 294).
aspecto(conocimiento, 412).
aspecto(orden, 193).
aspecto(naturaleza, 1597).
aspecto(bestia, 1877).
aspecto(destruccion, 1601).
aspecto(caos, 1364).
aspecto(corrupcion, 662).

% Definimos la relación de aspectos adyacentes de forma circular
adyacente(humano, corrupcion, conocimiento).
adyacente(conocimiento, humano, orden).
adyacente(orden, conocimiento, naturaleza).
adyacente(naturaleza, orden, bestia).
adyacente(bestia, naturaleza, destruccion).
adyacente(destruccion, bestia, caos).
adyacente(caos, destruccion, corrupcion).
adyacente(corrupcion, caos, humano).

% Regla para obtener el opuesto de un aspecto
opuesto(humano, bestia).
opuesto(conocimiento, destruccion).
opuesto(orden, caos).
opuesto(naturaleza, corrupcion).
opuesto(bestia, humano).
opuesto(destruccion, conocimiento).
opuesto(caos, orden).
opuesto(corrupcion, naturaleza).

% Regla para obtener los aspectos adyacentes desde cualquier dirección
aspectos_adyacentes(A, Izquierda, Derecha) :-
    (adyacente(A, Izquierda, Derecha) ; adyacente(A, Derecha, Izquierda)).

% Regla para obtener los puntos de un aspecto
puntos_aspecto(Aspecto, Puntos) :-
    aspecto(Aspecto, Puntos).

% Regla para actualizar los puntos de un aspecto
actualizar_puntos(Aspecto, NuevosPuntos) :-
    retractall(aspecto(Aspecto, _)),
    assertz(aspecto(Aspecto, NuevosPuntos)).
% Regla para jugar
jugar(Aspecto) :-
    puntos_aspecto(Aspecto, PuntosActuales),
    % Restar 5 al aspecto opuesto si es posible
    opuesto(Aspecto, Opuesto),
    puntos_aspecto(Opuesto, PuntosOpuesto),
    PuntosOpuesto >= 5,
    NuevosPuntosOpuesto is PuntosOpuesto - 5,
    actualizar_puntos(Opuesto, NuevosPuntosOpuesto),
    
    % Sumar 3 al aspecto
    NuevoPuntosAspecto is PuntosActuales + 3,
    actualizar_puntos(Aspecto, NuevoPuntosAspecto),

    % Sumar 1 a los aspectos adyacentes
    adyacente(Aspecto, Izquierda, Derecha),
    sumar_punto_adyacente(Izquierda),
    sumar_punto_adyacente(Derecha).

% Regla auxiliar para sumar 1 punto a un aspecto adyacente
sumar_punto_adyacente(Aspecto) :-
    puntos_aspecto(Aspecto, Puntos),
    NuevoPuntos is Puntos + 1,
    actualizar_puntos(Aspecto, NuevoPuntos).

% Posibles jugadas
jugada(humano).
jugada(conocimiento).
jugada(orden).
jugada(naturaleza).
jugada(bestia).
jugada(destruccion).
jugada(caos).
jugada(corrupcion).

cumplido(Aspecto, PuntosDeseados) :-
    puntos_aspecto(Aspecto, PuntosActuales),
    PuntosActuales >= PuntosDeseados.

jugarOpuestoAdyacente(Aspecto, AspectoAdyacente, Opuesto) :-
    aspectos_adyacentes(Aspecto, OtroAdyacente, AspectoAdyacente),
    opuesto(OtroAdyacente, Opuesto),
    jugar(Opuesto).

jugarOpuesto(Aspecto, Opuesto) :-
    opuesto(Aspecto, Opuesto),
    jugar(Opuesto).


queJugarSL(Aspecto, PuntosDeseados, Acciones, AspectoAdyacente):-
    PuntosDeseados =< 8000, PuntosDeseados >= 0,
    queJugarSL1(Aspecto, PuntosDeseados,Acciones,AspectoAdyacente),
    tell('output.txt'), % Abre el archivo de salida
    write(Acciones), nl, % Escribe el resultado en el archivo seguido de un salto de línea
    length(Acciones, Largo),
    write(Largo), nl, % Escribe el resultado en el archivo seguido de un salto de línea
    told. % Cierra el archivo de salida.

queJugarSL1(Aspecto, PuntosDeseados,[],_):- cumplido(Aspecto, PuntosDeseados).

queJugarSL1(Aspecto, PuntosDeseados,[Aspecto | Acciones],AspectoAdyacente):- % juega con aspecto
    not(cumplido(Aspecto, PuntosDeseados)),
    jugar(Aspecto),
    queJugarSL1(Aspecto, PuntosDeseados,Acciones,AspectoAdyacente).

queJugarSL1(Aspecto, PuntosDeseados,[AspectoAdyacente | Acciones], AspectoAdyacente):- % juega con aspecto adyacente preferido
    not(cumplido(Aspecto, PuntosDeseados)),
    aspectos_adyacentes(Aspecto, AspectoAdyacente, _),
    jugar(AspectoAdyacente),
    queJugarSL1(Aspecto, PuntosDeseados,Acciones,AspectoAdyacente).

queJugarSL1(Aspecto, PuntosDeseados,[OtroAdyacente | Acciones], AspectoAdyacente):- % juega con aspecto adyacente no preferido
    not(cumplido(Aspecto, PuntosDeseados)),
    aspectos_adyacentes(Aspecto, AspectoAdyacente, OtroAdyacente),
    jugar(OtroAdyacente),
    queJugarSL1(Aspecto, PuntosDeseados,Acciones,AspectoAdyacente).

queJugarSL1(Aspecto, PuntosDeseados,[Accion | Acciones], AspectoAdyacente):- % juega con aspecto opuesto al adyacente no preferido
    not(cumplido(Aspecto, PuntosDeseados)),
    jugarOpuestoAdyacente(Aspecto, AspectoAdyacente, Accion),
    queJugarSL1(Aspecto, PuntosDeseados,Acciones,AspectoAdyacente).

queJugarSL1(Aspecto, PuntosDeseados,[Otro | Acciones], AspectoAdyacente):- % juega con aspecto adycente al adyacente preferido
    not(cumplido(Aspecto, PuntosDeseados)),
    aspectos_adyacentes(Aspecto, AspectoAdyacente, _),
    aspectos_adyacentes(AspectoAdyacente, Otro, Aspecto),
    jugar(Otro),
    queJugarSL1(Aspecto, PuntosDeseados,Acciones,AspectoAdyacente).

queJugarSL1(Aspecto, PuntosDeseados,[Accion | Acciones], AspectoAdyacente):- % juega con aspecto opuesto al adyacente del adyacente preferido
    not(cumplido(Aspecto, PuntosDeseados)),
    aspectos_adyacentes(Aspecto, AspectoAdyacente, _),
    aspectos_adyacentes(AspectoAdyacente, Otro, Aspecto),
    jugarOpuesto(Otro, Accion),
    queJugarSL1(Aspecto, PuntosDeseados,Acciones,AspectoAdyacente).

queJugarSL1(Aspecto, PuntosDeseados,[Accion | Acciones], AspectoAdyacente):-  % juega con aspecto opuesto al adyacente preferido
    not(cumplido(Aspecto, PuntosDeseados)),
    jugarOpuesto(AspectoAdyacente, Accion),
    queJugarSL1(Aspecto, PuntosDeseados,Acciones,AspectoAdyacente).

queJugarSL1(Aspecto, PuntosDeseados,[Accion | Acciones], AspectoAdyacente):- % juega con aspecto opuesto
    not(cumplido(Aspecto, PuntosDeseados)),
    jugarOpuesto(Aspecto, Accion),
    queJugarSL1(Aspecto, PuntosDeseados,Acciones,AspectoAdyacente).


queJugar(Aspecto, PuntosDeseados, Acciones, AspectoAdyacente, Limite):-
    PuntosDeseados =< 8000, PuntosDeseados >= 0,
    queJugar1(Aspecto, PuntosDeseados,Acciones, AspectoAdyacente, Limite),
    tell('output.txt'), % Abre el archivo de salida
    write(Acciones), nl, % Escribe el resultado en el archivo seguido de un salto de línea
    length(Acciones, Largo),
    write(Largo), nl, % Escribe el resultado en el archivo seguido de un salto de línea
    told. % Cierra el archivo de salida.

% Agrega esta regla para manejar el caso cuando el límite es cero
queJugar1(_, _, _, _, 0):- !.

queJugar1(Aspecto, PuntosDeseados,[],_,_):- cumplido(Aspecto, PuntosDeseados).

queJugar1(Aspecto, PuntosDeseados,[Aspecto | Acciones], AspectoAdyacente, Limite):- % juega con aspecto
    Limite > 0,
    not(cumplido(Aspecto, PuntosDeseados)),
    jugar(Aspecto),
    NuevoLimite is Limite - 1,
    queJugar1(Aspecto, PuntosDeseados,Acciones,AspectoAdyacente, NuevoLimite).

queJugar1(Aspecto, PuntosDeseados,[AspectoAdyacente | Acciones], AspectoAdyacente, Limite):- % juega con aspecto adyacente preferido
    Limite > 0,
    not(cumplido(Aspecto, PuntosDeseados)),
    aspectos_adyacentes(Aspecto, AspectoAdyacente, _),
    jugar(AspectoAdyacente),
    NuevoLimite is Limite - 1,
    queJugar1(Aspecto, PuntosDeseados,Acciones,AspectoAdyacente, NuevoLimite).

queJugar1(Aspecto, PuntosDeseados,[OtroAdyacente | Acciones], AspectoAdyacente, Limite):- % juega con aspecto adyacente no preferido
    Limite > 0,
    not(cumplido(Aspecto, PuntosDeseados)),
    aspectos_adyacentes(Aspecto, AspectoAdyacente, OtroAdyacente),
    jugar(OtroAdyacente),
    NuevoLimite is Limite - 1,
    queJugar1(Aspecto, PuntosDeseados,Acciones,AspectoAdyacente, NuevoLimite).

queJugar1(Aspecto, PuntosDeseados,[Accion | Acciones], AspectoAdyacente, Limite):- % juega con aspecto opuesto al adyacente no preferido
    Limite > 0,
    not(cumplido(Aspecto, PuntosDeseados)),
    jugarOpuestoAdyacente(Aspecto, AspectoAdyacente, Accion),
    NuevoLimite is Limite - 1,
    queJugar1(Aspecto, PuntosDeseados,Acciones,AspectoAdyacente, NuevoLimite).

queJugar1(Aspecto, PuntosDeseados,[Otro | Acciones], AspectoAdyacente, Limite):- % juega con aspecto adycente al adyacente preferido
    Limite > 0,
    not(cumplido(Aspecto, PuntosDeseados)),
    aspectos_adyacentes(Aspecto, AspectoAdyacente, _),
    aspectos_adyacentes(AspectoAdyacente, Otro, Aspecto),
    jugar(Otro),
    NuevoLimite is Limite - 1,
    queJugar1(Aspecto, PuntosDeseados,Acciones,AspectoAdyacente, NuevoLimite).

queJugar1(Aspecto, PuntosDeseados,[Accion | Acciones], AspectoAdyacente, Limite):- % juega con aspecto opuesto al adyacente del adyacente preferido
    Limite > 0,
    not(cumplido(Aspecto, PuntosDeseados)),
    aspectos_adyacentes(Aspecto, AspectoAdyacente, _),
    aspectos_adyacentes(AspectoAdyacente, Otro, Aspecto),
    jugarOpuesto(Otro, Accion),
    NuevoLimite is Limite - 1,
    queJugar1(Aspecto, PuntosDeseados,Acciones,AspectoAdyacente, NuevoLimite).

queJugar1(Aspecto, PuntosDeseados,[Accion | Acciones], AspectoAdyacente, Limite):-  % juega con aspecto opuesto al adyacente preferido
    Limite > 0,
    not(cumplido(Aspecto, PuntosDeseados)),
    jugarOpuesto(AspectoAdyacente, Accion),
    NuevoLimite is Limite - 1,
    queJugar1(Aspecto, PuntosDeseados,Acciones,AspectoAdyacente, NuevoLimite).

queJugar1(Aspecto, PuntosDeseados,[Accion | Acciones], AspectoAdyacente, Limite):- % juega con aspecto opuesto
    Limite > 0,
    not(cumplido(Aspecto, PuntosDeseados)),
    jugarOpuesto(Aspecto, Accion),
    NuevoLimite is Limite - 1,
    queJugar1(Aspecto, PuntosDeseados,Acciones,AspectoAdyacente, NuevoLimite).