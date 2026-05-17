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
