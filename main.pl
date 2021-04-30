checkdistance([PX|[PY|_]], [QX|[QY|_]], MINDISTANCE) :-
    Distance is sqrt( (QX - PX)*(QX - PX) + (QY - PY)*(QY - PY) ),
    Distance >= MINDISTANCE.

isPeople(X, P) :- 
    length(P, L),
    L == 0 -> true;
              socialDistanced(X, P).


% (X, Y) has to be safe from all points in [P] to return true.
socialDistanced([X|[Y|_]],[[Xo|[Yo|_]]|P]) :-
    length(P, L),
    L == 0 -> checkdistance([X,Y],[Xo,Yo],6);
                checkdistance([X,Y],[Xo,Yo],6), socialDistanced([X, Y], P).

bounded([X|[Y|_]],[A|[B|_]]) :- X >= 0, X < A, Y >= 0, Y < B.

safe(State, Q, Grid) :- bounded(State, Grid), isPeople(State, Q).

move([X|[Y|_]], [NewX, NewY]) :- NewX is X, NewY is Y.

moveup([X|[Y|_]], [X1, Y1], Q, Grid)   :- NewY is Y + 1, safe([X, NewY], Q, Grid), move([X, NewY], [X1, Y1]).
moveleft([X|[Y|_]], [X1, Y1], Q, Grid) :- NewX is X - 1, safe([NewX, Y], Q, Grid), move([NewX, Y], [X1, Y1]).
moveright([X|[Y|_]], [X1, Y1], Q, Grid) :- NewX is X + 1, safe([NewX, Y], Q, Grid), move([NewX, Y], [X1, Y1]).
movedown([X|[Y|_]], [X1, Y1], Q, Grid)   :- NewY is Y - 1, safe([X, NewY], Q, Grid), move([X, NewY], [X1, Y1]).

checkFinal([_|[Y|_]], Final) :- Y = Final, !.      

not_member(_, []) :- !.
 
not_member(X, [Head|Tail]) :-
     X \= Head,
    not_member(X, Tail).

solve([State | _], Final, _, _, _) :- checkFinal(State, Final), !. % Prevent backtracking here - causes moving along row 24.
solve([State|Path], Final, Grid, Q, [NextState|P]) :- moveup(State, NextState, Q, Grid), not_member(NextState, [State|Path]),  solve([NextState, State | Path], Final, Grid, Q, P);
                                               moveleft(State, NextState, Q, Grid), not_member(NextState, [State|Path]), solve([NextState, State | Path], Final, Grid, Q, P);
                                               moveright(State, NextState, Q, Grid), not_member(NextState, [State|Path]), solve([NextState, State | Path], Final, Grid, Q, P);
                                               movedown(State, NextState, Q, Grid), not_member(NextState, [State|Path]), solve([NextState, State | Path], Final, Grid, Q, P).
                                      
