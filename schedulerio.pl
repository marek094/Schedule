%%
% schedulerio.pl
%
% Scheduler
%   MarekCerny.com
%
% result ---> print
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
	nb_getval(maxW,MaxW),
	print(["Weight: ", MaxW, "\n"]),

	printNl,
	printHeader,
	printNl,
	weekToList(Ds),
	printSchedule(Sch,Ds),
	nl.
printSchedule([],[]).
printSchedule([Ss|Sss],[D|Ds]) :-
	printDay([cell(_,D)|Ss]),
	printNl,
	printSchedule(Sss, Ds).

printDay([]) :- write('|'), nl.
printDay([cell(_,S)|Ss]) :-
	printCell(S),
	printDay(Ss).


% Answer predicates

printAnswerLine(r(Su,Teacher,Times)) :-
	print([Su, '\t', Teacher, '\t\t']),
	print(Times), nl
	.


printAnswer([]).
printAnswer([A|As]) :-
	printAnswerLine(A),
	printAnswer(As).
