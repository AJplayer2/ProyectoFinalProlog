% Elaborado por Hernandez Vazquez Diego
% La IA coloca sus barcos de forma aleatoria al inicio y dispara
% a coordenadas aleatorias
% Predicados principales:
%   ia_colocar_flota/2      - coloca todos los barcos
%   ia_turno/3              - elige una coordenada aleatoria y dispara

% Inicializa la semilla aleatoria con el tiempo del sistema.
% Llamar una vez al inicio de la partida.
ia_init_random :-
    true.

% Define los barcos que se colocarán:
ia_barco(portaaviones,  5).
ia_barco(acorazado,     4).
ia_barco(crucero,       3).
ia_barco(submarino,     3).
ia_barco(destructor,    2).

% Elige aleatoriamente si horizontal o vertical
orientacion_aleatoria(horizontal) :-
    random(R),
    R >= 0.5.
orientacion_aleatoria(vertical) :-
    random(R),
    R < 0.5.

% Genera una coordenada (X, Y) aleatoria dentro del tablero 10x10.

coordenada_aleatoria(X, Y) :-
    random_between(1, 10, X),
    random_between(1, 10, Y).

% Reintenta con nuevas coordenadas hasta atinarle 
ia_colocar_barco(TableroIn, Tam, TableroOut) :-
    coordenada_aleatoria(X, Y),
    orientacion_aleatoria(Orient),
    puede_colocar(TableroIn, Tam, X, Y, Orient), !,
    colocar_barco(TableroIn, Tam, X, Y, Orient, TableroOut).

% Si la posición no sirve reintenta.
ia_colocar_barco(TableroIn, Tam, TableroOut) :-
    ia_colocar_barco(TableroIn, Tam, TableroOut).

ia_colocar_flota(TableroIn, TableroOut) :-
    findall(Tam, ia_barco(_, Tam), Tamanos),
    ia_colocar_lista(TableroIn, Tamanos, TableroOut).

ia_colocar_lista(Tablero, [], Tablero).
ia_colocar_lista(TableroIn, [Tam|Resto], TableroOut) :-
    ia_colocar_barco(TableroIn, Tam, TableroMed),
    ia_colocar_lista(TableroMed, Resto, TableroOut).

% Genera la lista de coordenadas del tablero que aún no han sido
% atacadas 

celdas_disponibles(Tablero, Lista) :-
    findall(X-Y, (
        between(1, 10, X),
        between(1, 10, Y),
        celda(Tablero, X, Y, V),
        V \= tocado,
        V \= fallado
    ), Lista).


% Elige un elemento al azar de una lista
elegir_aleatorio(Lista, Elem) :-
    length(Lista, Len),
    Len > 0,
    random_between(0, Len, Idx0),
    (Idx0 =:= Len -> Idx is Len - 1 ; Idx is Idx0),
    nth0(Idx, Lista, Elem).


% La IA selecciona una celda no atacada al azar y dispara y l tablero se actualiza

ia_turno(Tablero, X, Y) :-
    celdas_disponibles(Tablero, Disponibles),
    Disponibles \= [],
    elegir_aleatorio(Disponibles, X-Y).


ia_jugar(TableroIn, TableroOut, X-Y) :-
    ia_turno(TableroIn, X, Y),
    disparar(TableroIn, X, Y, TableroOut).
