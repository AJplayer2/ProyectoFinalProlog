% ui.pl - Interfaz de usuario para Battleship

% Representación visual de las celdas para el jugador
simbolo_jugador(agua, '~').
simbolo_jugador(barco, 'B').
simbolo_jugador(tocado, 'X').
simbolo_jugador(fallado, 'O').

% Representación visual de las celdas para el enemigo (oculta barcos)
simbolo_enemigo(agua, '~').
simbolo_enemigo(barco, '~').
simbolo_enemigo(tocado, 'X').
simbolo_enemigo(fallado, 'O').

% Dibuja el tablero con coordenadas numéricas
imprimir_tablero(Tablero, Tipo) :-
    writeln('   1 2 3 4 5 6 7 8 9 10'),
    imprimir_filas(Tablero, 1, Tipo).

imprimir_filas([], _, _).
imprimir_filas([Fila|Resto], Num, Tipo) :-
    (Num < 10 -> write(' ') ; true),
    write(Num), write(' '),
    imprimir_celdas(Fila, Tipo),
    nl,
    N1 is Num + 1,
    imprimir_filas(Resto, N1, Tipo).

imprimir_celdas([], _).
imprimir_celdas([Celda|Resto], Tipo) :-
    ( Tipo = jugador -> simbolo_jugador(Celda, S) ; simbolo_enemigo(Celda, S) ),
    write(S), write(' '),
    imprimir_celdas(Resto, Tipo).

% Función principal para arrancar todo
iniciar_juego :-
    ia_init_random,
    tablero_vacio(TableroIAVacio),
    ia_colocar_flota(TableroIAVacio, TableroIA),
    tablero_vacio(TableroJugadorVacio),
    nl, writeln('--- COLOCACIÓN DE TU FLOTA ---'),
    writeln('Tamaños disponibles: 5, 4, 3, 3, 2.'),
    colocar_flota_jugador(TableroJugadorVacio, [5, 4, 3, 3, 2], TableroJugador),
    nl, writeln('¡Comienza la batalla!'),
    loop_juego(TableroJugador, TableroIA).

% Ciclo recursivo para colocar la flota manual del jugador
colocar_flota_jugador(Tablero, [], Tablero).
colocar_flota_jugador(TableroIn, [Tam|Resto], TableroOut) :-
    nl, imprimir_tablero(TableroIn, jugador),
    format('~nColocando barco de tamaño ~w.~n', [Tam]),
    writeln('Ingresa Fila (1-10) terminada en punto:'), read(X),
    writeln('Ingresa Columna (1-10) terminada en punto:'), read(Y),
    writeln('Ingresa Orientacion (horizontal o vertical) terminada en punto:'), read(Orientacion),
    ( puede_colocar(TableroIn, Tam, X, Y, Orientacion) ->
        colocar_barco(TableroIn, Tam, X, Y, Orientacion, TableroTemp),
        colocar_flota_jugador(TableroTemp, Resto, TableroOut)
    ;
        writeln('Posición inválida o ocupada. Intenta de nuevo.'),
        colocar_flota_jugador(TableroIn, [Tam|Resto], TableroOut)
    ).

% Lógica para solicitar la coordenada al jugador
turno_jugador(TableroEnemigoIn, TableroEnemigoOut) :-
    nl, writeln('--- TU TURNO ---'),
    writeln('Tablero Enemigo:'),
    imprimir_tablero(TableroEnemigoIn, enemigo),
    writeln('Coordenada para disparar.'),
    writeln('Fila (1-10) terminada en punto:'), read(X),
    writeln('Columna (1-10) terminada en punto:'), read(Y),
    ( disparar(TableroEnemigoIn, X, Y, TableroEnemigoOut) ->
        writeln('¡Disparo registrado!')
    ;
        writeln('Coordenada inválida o ya atacada. Intenta de nuevo.'),
        turno_jugador(TableroEnemigoIn, TableroEnemigoOut)
    ).

% Bucle de juego y evaluación de victoria
loop_juego(_, TableroIA) :-
    estado_ganador(TableroIA), !,
    nl, imprimir_tablero(TableroIA, jugador),
    writeln('¡Felicidades! Has hundido todos los barcos enemigos.').

loop_juego(TableroJugador, _) :-
    estado_ganador(TableroJugador), !,
    nl, imprimir_tablero(TableroJugador, jugador),
    writeln('La IA ha hundido tu flota. Fin del juego.').

loop_juego(TabJugIn, TabIAIn) :-
    turno_jugador(TabIAIn, TabIAOut),
    ( estado_ganador(TabIAOut) ->
        loop_juego(TabJugIn, TabIAOut)
    ;
        nl, writeln('--- TURNO DE LA IA ---'),
        ia_jugar(TabJugIn, TabJugOut, X-Y),
        format('La IA disparó en la fila ~w, columna ~w.~n', [X, Y]),
        writeln('Tu tablero actual:'),
        imprimir_tablero(TabJugOut, jugador),
        loop_juego(TabJugOut, TabIAOut)
    ).