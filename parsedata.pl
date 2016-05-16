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



% parseData(+InputSubjectList, +Schedule, +Weights, -ParsedData)
parseData([],_,_,_,[]).
parseData([[Su, Is]|Ds], Sch, Ws,Wws, [i(Su,R)|Rs]) :-
%	writeln(Id),
	parse(Is, Sch, Ws, Wws, R, 1),
	parseData(Ds, Sch, Ws, Wws, Rs).

% parse(+TicketList, +Schedule, +Weights, -ParsedLine)
parse([],_,_,_,[],_).
parse([[Dts, T|_]|Is], Sch, Ws,Wws, [t(W,Id,Vs)|Sc], Id) :-
	mapCoeficient(Dts, Wws, C_N),
	length(Dts, N),
	weight(T, Ws, W1),
	W is (C_N / N) * W1,

	mapScheduleAt(Dts, Sch, Vs),
	Id1 is Id+1,
	parse(Is, Sch, Ws,Wws, Sc, Id1).


mapCoeficient([],_,1).
mapCoeficient([Dt|Dts], Wws, C1+Cr) :-
	coeficient(Dt,Wws,C1),
	mapCoeficient(Dts, Wws, Cr).

coeficient(dt(D,H),w(WeekW,DayW), Cw*Cd) :-
	(   member(D-Cw,WeekW) -> true; Cw = 1),
	(   member(H-Cd, DayW) -> true; Cd = 1).

weight(T, Ws, W) :-
	(   member(T-W,Ws) -> true; W = 100).


mapScheduleAt([],_,[]).
mapScheduleAt([Dt|Dts], Sch, [Var|Vs]) :-
	scheduleAt(Dt, Sch, Var),
	mapScheduleAt(Dts,Sch,Vs).

%
%  get cell from schedule
scheduleAt(dt(D, H), Sch, E) :-
	weekDay(D1,D),
	listAt(D1, Sch, Es),
	listAt(H, Es, E).

% dt(Day, Time). Info about time.
%  listAt(?Index, ?List, ?Elem)
listAt(1, [L|_], L).
listAt(N, [_|Ls], E) :- N>1, N1 is N-1, listAt(N1, Ls, E).

genSchedule(Sch) :-
	nb_setval(maxW, -9999),
	define(weekLength, W),
	define(dayLength, D),
	length(Sch, W),
	genSchedule(Sch, D).
genSchedule([],_).
genSchedule([S|Ss], D) :-
	length(S, D),
	genSchedule(Ss,D).

% Answer
%

%interpretResult(+ResultList, -OutputList)
interpretResult(R,S) :-
	maplist(getSelected_, R, S).

getSelected_(A, Id) :- timeSelected(A,Id).
timeSelected(i(Su,[t(_,Id,[cell(Id1,Su)|_])|_]), cell(Id,Su)) :-
	nonvar(Id1),
	Id = Id1,
	!.
timeSelected(i(Su,[_|Ts]), Id) :- timeSelected(i(Su,Ts), Id).


%parseData(+InputSubjectList, +R, -ParsedData) :-
getAnswer([],_,[]).
getAnswer([[Su, Is]|Ds], Ls, [R|Rs]) :-
	getAnswerTime(Su, Is, Ls, R, 1),
	getAnswer(Ds, Ls, Rs).


%getAnswerTime(+Subject, +TicketList, +Schedule, -ParsedLine, +Id, -NewId) :-
getAnswerTime(_, [], _, _,_).
getAnswerTime(Su, [[Times,Teacher|_]|Is], Ls, Out, Id) :-
	(member(cell(Id,Su), Ls) -> Out = r(Su,Teacher,Times);true),
	Id1 is Id+1,
	getAnswerTime(Su, Is, Ls, Out, Id1)
	.


