:- use_module(library(readutil)).
:- use_module(library(assoc)).
:- dynamic cell_value/2, target_position/1.

% Define possible moves
move(nw, -1, -1).
move(n, -1, 0).
move(ne, -1, 1).
move(w, 0, -1).
move(e, 0, 1).
move(sw, 1, -1).
move(s, 1, 0).
move(se, 1, 1).

% Clear all dynamic facts to reset before new runs
clear_facts :-
    retractall(cell_value(_, _)),
    retractall(target_position(_)).

% Main predicate to read the matrix file and store values
load_matrix(File) :-
    open(File, read, Stream),
    read_line_to_codes(Stream, FirstLine),
    number_codes(N, FirstLine),
    assertz(target_position(N-N)),
    read_values(Stream, N, 1),
    close(Stream).

% Helper predicate to parse and store values
read_values(_, 0, _) :- !.
read_values(Stream, N, Row) :-
    N > 0,
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, Values),
    save_values(Row, 1, Values),
    NextRow is Row + 1,
    Remaining is N - 1,
    read_values(Stream, Remaining, NextRow).

% Helper predicate to store values of a row
save_values(_, _, []) :- !.
save_values(Row, Col, [Value|Values]) :-
    assertz(cell_value(Row-Col, Value)),
    NextCol is Col + 1,
    save_values(Row, NextCol, Values).

% Check if the move results in a decreasing value
valid_move(X-Y, X1-Y1) :-
    cell_value(X-Y, StartValue),
    cell_value(X1-Y1, EndValue),
    StartValue > EndValue.

% Apply a move to a position
apply_move(X-Y, Direction, X1-Y1) :-
    move(Direction, DX, DY),
    X1 is X + DX,
    Y1 is Y + DY,
    valid_move(X-Y, X1-Y1).

% Find a path from Start to Target using BFS
find_path(Start, Target, Path) :-
    empty_assoc(Visited),
    bfs([[Start, []]|Tail]-Tail, Visited, Target, Path).

% BFS traversal to find the shortest path
bfs(Queue-Tail, Visited, Target, Moves) :-
    (Queue = [] ->
        Moves = 'IMPOSSIBLE'
    ;
        Queue = [[Current, Path]|Rest],
        (Current = Target ->
            reverse(Path, Moves)
        ;
            (get_assoc(Current, Visited, _) ->
                bfs(Rest-Tail, Visited, Target, Moves)
            ;
                put_assoc(Current, Visited, true, NewVisited),
                findall(
                    [Next, [Direction|Path]],
                    (apply_move(Current, Direction, Next), \+ get_assoc(Next, NewVisited, _)),
                    NextSteps
                ),
                append_to_queue(NextSteps, Rest-Tail, NewQueue),
                bfs(NewQueue, NewVisited, Target, Moves)
            )
        )
    ).

append_to_queue([], Queue-Tail, Queue-Tail).
append_to_queue([H|T], Queue-[H|NewTail], NewQueue) :-
    append_to_queue(T, Queue-NewTail, NewQueue).

% Entry point predicate to find the sequence of moves
moves(File, Moves) :-
    clear_facts,
    load_matrix(File),
    target_position(NN),
    (find_path(1-1, NN, Moves) -> true ; Moves = 'IMPOSSIBLE').