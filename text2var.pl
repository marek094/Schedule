%%
%
%  Instances => variables
%


unif(_, [],[]).
unif(Sch, [inst(P1,Index)|Ls], [inst(P1,Var)|Sc]) :-
	atSchedule(Index, Sch, Var),
	unif(Sch, Ls, Sc).


genSchedule(0, []).
genSchedule(N, [_|L]) :- N>0, N1 is N-1, genSchedule(N1, L).

atSchedule(0, [L|_], L).
atSchedule(N, [_|Ls], L) :-
	N > 0, N1 is N-1,
	atSchedule(N1, Ls, L).


testStart(X,Sch) :-
	L = [inst(a,1), inst(b,2), inst(d,4)],
	genSchedule(16, Sch),
	unif(Sch, L, X).
