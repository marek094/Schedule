%%
% Predicates for printing
%


% Schedule predicates

weekToList(L) :- weekToList(1, L).
weekToList(6, []).
weekToList(N, [L|Ls]) :-
	N =< 5,
	weekDay(N,L),
	N1 is N+1,
	weekToList(N1, Ls).

print([]).
print([L|Ls]) :- write(L), print(Ls).

printCell(Cont) :- var(Cont), printCell(' ').
printCell(Cont)	:- \+var(Cont), format('|~|~t~a~t~6+', [Cont]).

printNl :-
	define(dayLength, D),
	D1 is D+1,
	printNl(D1).
printNl(0) :- write('+'), nl.
printNl(N) :-
	N>0, N1 is N-1,
	write('+------'),
	printNl(N1).

printHeader :-
	define(dayLength, D),
	printCell('D\\H'),
	printHeader(0,D).
printHeader(M,M) :- write('|'), nl.
printHeader(N, Max) :-
	N < Max, N1 is N+1,
	printCell(N1),
	printHeader(N1, Max).


printSchedule(Sch) :-
	printNl,
%	writeln("Here"),
	printHeader,
%	writeln("Here2"),
	printNl,
%	writeln("Here3"),
	weekToList(Ds),
%	writeln("Here4"),
	printSchedule(Sch,Ds),
	nl.
printSchedule([],[]).
printSchedule([Ss|Sss],[D|Ds]) :-
%	write('//////'),
%	writeln(D),
	printDay([cell(_,D)|Ss]),
	printNl,
	printSchedule(Sss, Ds).

printDay([]) :- write('|'), nl.
printDay([cell(_,S)|Ss]) :-
	%nl,writeln(S),
	%S = cell(_, V),
	%writeln(V),
	printCell(S),
	printDay(Ss).


% Answer predicates

printAnswerLine([Su,dt(Day,Time),Teacher|_]) :-
	print([Su, ' ', Day, ' ', Time, ', ', Teacher, '\n']).

printAnswer([]).
printAnswer([A|As]) :-
	%writeln(A),
	printAnswerLine(A),
	printAnswer(As),
	nl.
