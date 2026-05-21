% victoria.pl - condición de victoria del juego Battleship

% fila_sin_barcos/1 - auxiliar
% Verdadero si ninguna celda de la fila es 'barco'.
fila_sin_barcos([]).
fila_sin_barcos([Celda|Resto]) :-
    Celda \= barco,
    fila_sin_barcos(Resto).

% tablero_sin_barcos/1 - auxiliar
% Verdadero si ninguna fila del tablero contiene 'barco'.
tablero_sin_barcos([]).
tablero_sin_barcos([Fila|Resto]) :-
    fila_sin_barcos(Fila),
    tablero_sin_barcos(Resto).

% todos_tocados/1
% Verdadero si no queda ninguna celda 'barco' en el tablero.
todos_tocados(Tablero) :-
    tablero_sin_barcos(Tablero).

% estado_ganador/1
% Verdadero si todos los barcos del tablero han sido hundidos.
estado_ganador(Tablero) :-
    todos_tocados(Tablero).
