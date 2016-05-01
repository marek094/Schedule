%%
%
%  Instances => variables
%


unif(Sch, Ls, Sc) :- unif(Sch, Ls, Sc, 1).

unif(_, [],[],_).
unif(Sch, [inst(_,Time)|Ls], [n(Id,Var)|Sc], Id) :-
	atSchedule(Time, Sch, Var),

	Id1 is Id+1, unif(Sch, Ls, Sc, Id1).



genSchedule(Sch) :- genSchedule(t(5,16), Sch).




genSchedule(0, []).
genSchedule(N, [_|L]) :- N>0, N1 is N-1, genSchedule(N1, L).

atSchedule(0, [L|_], L).
atSchedule(N, [_|Ls], L) :-
	N > 0, N1 is N-1,
	atSchedule(N1, Ls, L).




testStart(X,Sch) :-
	genSchedule(Sch),
	X = 0.
%	L = [inst(a,1), inst(b,2), inst(d,4)],
%	genSchedule(16, Sch),
%	unif(Sch, L, X).
