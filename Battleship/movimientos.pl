% movimientos.pl - lógica de movimientos del juego Battleship

% reemplazar_n/4
% Reemplaza el N-ésimo elemento de Lista por Nuevo.
reemplazar_n(1, [_|Resto], Nuevo, [Nuevo|Resto]).
reemplazar_n(N, [Cab|Resto], Nuevo, [Cab|NuevoResto]) :-
    N > 1,
    N1 is N - 1,
    reemplazar_n(N1, Resto, Nuevo, NuevoResto).

% reemplazar_celda/5
% Cambia la celda (X, Y) del tablero a Nuevo.
reemplazar_celda(Tablero, X, Y, Nuevo, NuevoTablero) :-
    obten_n(X, Tablero, Fila),
    reemplazar_n(Y, Fila, Nuevo, NuevaFila),
    reemplazar_n(X, Tablero, NuevaFila, NuevoTablero).

% colocar_celdas/7 - auxiliar de colocar_barco
% Coloca N celdas 'barco' desde (X,Y) avanzando (DX,DY) en cada paso.
colocar_celdas(Tablero, 0, _, _, _, _, Tablero).
colocar_celdas(Tablero, N, X, Y, DX, DY, NuevoTablero) :-
    N > 0,
    reemplazar_celda(Tablero, X, Y, barco, T1),
    X1 is X + DX,
    Y1 is Y + DY,
    N1 is N - 1,
    colocar_celdas(T1, N1, X1, Y1, DX, DY, NuevoTablero).

% colocar_barco/6
% Coloca un barco de Tam celdas desde (X,Y) en la orientacion indicada.
% No valida límites ni solapamiento; eso lo hace puede_colocar/5.
colocar_barco(Tablero, Tam, X, Y, horizontal, NuevoTablero) :-
    colocar_celdas(Tablero, Tam, X, Y, 0, 1, NuevoTablero).
colocar_barco(Tablero, Tam, X, Y, vertical, NuevoTablero) :-
    colocar_celdas(Tablero, Tam, X, Y, 1, 0, NuevoTablero).

% verifica_celdas/6 - auxiliar de puede_colocar
% Verifica que N celdas desde (X,Y) avanzando (DX,DY) sean coordenadas válidas y agua.
verifica_celdas(_, 0, _, _, _, _).
verifica_celdas(Tablero, N, X, Y, DX, DY) :-
    N > 0,
    coordenada_valida(X, Y),
    celda(Tablero, X, Y, agua),
    X1 is X + DX,
    Y1 is Y + DY,
    N1 is N - 1,
    verifica_celdas(Tablero, N1, X1, Y1, DX, DY).

% puede_colocar/5
% Verdadero si el barco cabe en el tablero y todas sus celdas son agua.
puede_colocar(Tablero, Tam, X, Y, horizontal) :-
    verifica_celdas(Tablero, Tam, X, Y, 0, 1).
puede_colocar(Tablero, Tam, X, Y, vertical) :-
    verifica_celdas(Tablero, Tam, X, Y, 1, 0).

% disparar/4
% Dispara a (X,Y): agua -> fallado, barco -> tocado.
% Falla si la celda ya fue disparada (tocado o fallado).
disparar(Tablero, X, Y, NuevoTablero) :-
    celda(Tablero, X, Y, agua),
    reemplazar_celda(Tablero, X, Y, fallado, NuevoTablero).
disparar(Tablero, X, Y, NuevoTablero) :-
    celda(Tablero, X, Y, barco),
    reemplazar_celda(Tablero, X, Y, tocado, NuevoTablero).
