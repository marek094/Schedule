%%
% Instances => variables
%

%
% Constants
weekDay(1, mon).
weekDay(2, tue).
weekDay(3, wed).
weekDay(4, thu).
weekDay(5, fri).

define(dayLength, 16).
define(weekLength, 5).

parseData([],_,[]).
parseData([[Su, Is]|Ds], Sch, [i(Su,R)|Rs]) :-
	parse(Su, Is, Sch, R),
	parseData(Ds, Sch, Rs).

parse(_, [], _, []).
parse(Su, [[Dt|_]|Is], Sch, [Var|Sc]) :-
	scheduleAt(Dt, Sch, Var),
	parse(Su, Is, Sch, Sc).

% dt(Day, Time). Info about time.
%
%  listAt(?Index, ?List, ?Elem)
listAt(1, [L|_], L).
listAt(N, [_|Ls], E) :- N>1, N1 is N-1, listAt(N1, Ls, E).

%
%  get cell from schedule
scheduleAt(dt(D, H), Sch, E) :-
	weekDay(D1,D),
	listAt(D1, Sch, Es),
	listAt(H, Es, E).

genSchedule(Sch) :-
	define(weekLength, W),
	define(dayLength, D),
	length(Sch, W),
	genSchedule(Sch, D).
genSchedule([],_).
genSchedule([S|Ss], D) :-
	length(S, D),
	genSchedule(Ss,D).

interpretResultLine(i(Su,[Su|_]), [DI|_], [Su|DI]). %:- writeln(Su), writeln(DI).
interpretResultLine(i(Su,[I|Is]), [_|DIs], A) :-
	Su \= I,
	interpretResultLine(i(Su,Is), DIs, A).


interpretResult([],[],[]).
interpretResult([i(Su, Is)|Xs], [[Su,DIs|_]|Ds], [A|As]) :-
	interpretResultLine(i(Su,Is), DIs, A),
	%write(A),
	interpretResult(Xs, Ds, As).
