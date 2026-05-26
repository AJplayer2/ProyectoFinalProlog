# Battleship en Prolog
Proyecto final de Lógica Computacional
Juego de Batalla Naval implementado en SWI-Prolog.
Juega contra una IA que coloca y dispara de forma aleatoria.

## Integrantes
- Angel Jayden Maya Morales
- Aldo Yañez Ramirez
- Diego Hernandez Vazquez 320309935

## Reglas del juego

Cada jugador coloca una flota de 5 barcos en un tablero de 10x10:
portaaviones (5), acorazado (4), crucero (3), submarino (3) y destructor (2).
Por turnos, cada jugador elige una coordenada para disparar. Si impacta un barco,
la celda queda marcada como tocado; si no, como fallado. Gana quien hunda todos los barcos del rival primero.

## Inteligencia Artificial

La IA fue implementada en `ia.pl`. Utiliza aleatoriedad para colocar su flota
y para elegir dónde disparar cada turno. No tiene memoria de intentos anteriores
más allá de evitar celdas ya atacadas.
