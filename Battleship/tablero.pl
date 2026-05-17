% tablero.pl - estado del tablero de Battleship

% Caso base: fila vacía cuando ya no quedan celdas.
construye_fila(0, []).
% Agrega una celda agua y sigue con el resto.
construye_fila(N, [agua|Resto]) :-
    N > 0,
    N1 is N - 1,
    construye_fila(N1, Resto).

% apila_filas
% Caso base: sin filas que apilar.
apila_filas(0, _, []).
% Agrega la fila al tablero y sigue apilando.
apila_filas(N, Fila, [Fila|Resto]) :-
    N > 0,
    N1 is N - 1,
    apila_filas(N1, Fila, Resto).

% tablero_vacio
% Genera un tablero 10x10 con todas las celdas en agua.
tablero_vacio(Tablero) :-
    construye_fila(10, Fila),
    apila_filas(10, Fila, Tablero).

% obten_n/3
% Saca el N-ésimo elemento de una lista, contando desde 1.
obten_n(1, [Elem|_], Elem).
obten_n(N, [_|Resto], Elem) :-
    N > 1,
    N1 is N - 1,
    obten_n(N1, Resto, Elem).

% celda/4
% Regresa el valor de la celda en fila X, columna Y del tablero.
celda(Tablero, X, Y, Valor) :-
    obten_n(X, Tablero, Fila),
    obten_n(Y, Fila, Valor).
