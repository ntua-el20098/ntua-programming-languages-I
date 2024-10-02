% Helper predicate to check if a number is divisible by another
is_divisible(N, D) :- N mod D =:= 0.

% Recursive predicate to check if a number can be represented as a repdigit in the given base
is_base_valid(1, _) :- !.
is_base_valid(Num, Base) :- 
    is_divisible(Num - 1, Base),
    NextNum is (Num - 1) // Base,
    is_base_valid(NextNum, Base).

% Predicate to find the smallest base for a number
find_base(Num, Digit, Base) :- 
    search_base(Num, Digit + 1, Base).

% Helper predicate to search for the base
search_base(Num, Base, Base) :- 
    is_base_valid(Num, Base), !.
search_base(Num, Base, Result) :- 
    Base * Base > Num, !, 
    Result is Num - 1.
search_base(Num, Base, Result) :- 
    NextBase is Base + 1,
    search_base(Num, NextBase, Result).

% Predicate to solve for the minimal base of a given number
solve_min_base(1, 2) :- !.
solve_min_base(2, 3) :- !.
solve_min_base(N, MinBase) :-
    check_divisor(N, 1, N + 1, MinBase).

% Helper predicate to check divisors and find the minimal base
check_divisor(N, Divisor, CurrentMin, MinBase) :-
    Divisor * Divisor >= N, !,
    MinBase is CurrentMin.
check_divisor(N, Divisor, CurrentMin, MinBase) :-
    is_divisible(N, Divisor), !,
    Quotient is N // Divisor,
    find_base(Quotient, Divisor, PotentialBase),
    ( PotentialBase < CurrentMin 
    -> UpdatedMin is PotentialBase
    ;  UpdatedMin is CurrentMin),
    NextDivisor is Divisor + 1,
    check_divisor(N, NextDivisor, UpdatedMin, MinBase).
check_divisor(N, Divisor, CurrentMin, MinBase) :-
    NextDivisor is Divisor + 1,
    check_divisor(N, NextDivisor, CurrentMin, MinBase).

% Predicate to find the minimal bases for a list of numbers
find_min_bases([], []).
find_min_bases([Num|Nums], [Base|Bases]) :-
    solve_min_base(Num, Base),
    find_min_bases(Nums, Bases).

% Main entry point to find minimal bases for a list of numbers
minbases(Nums, Bases) :- find_min_bases(Nums, Bases).