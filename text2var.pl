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


% parseData(+InputSubjectList, +Schedule, -ParsedData) :-
parseData(Ds,Sch, Ws, Rs) :- parseData(Ds, Sch, Ws, Rs,1).
parseData([],_,_,[],_).
parseData([[Su, Is]|Ds], Sch, Ws, [i(Su,R)|Rs], Id) :-
%	writeln(Id),
	parse(Su, Is, Sch, Ws, R, Id, Id1),
	parseData(Ds, Sch, Ws, Rs, Id1).

% parse(+Subject, +TicketList, +Schedule, -ParsedLine, +Id, -NewId) :-
parse(_, [], _, _, [], Id, Id).
parse(Su, [[Dts, T|_]|Is], Sch, Ws, [t(W,Id,Vs)|Sc], Id, IdR) :-

	(member(T-W1,Ws) -> W is W1;W is 100),
	mapScheduleAt(Dts, Sch, Vs),
	Id1 is Id+1,
	parse(Su, Is, Sch, Ws, Sc, Id1, IdR).

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
	define(weekLength, W),
	define(dayLength, D),
	length(Sch, W),
	genSchedule(Sch, D).
genSchedule([],_).
genSchedule([S|Ss], D) :-
	length(S, D),
	genSchedule(Ss,D).

% Answer

interpretResult(R,S) :-
	maplist(getSelected_, R, S).

getSelected_(i(_,Ts), Id) :- timeSelected(Ts,Id).
timeSelected([t(_,Id,[cell(Id1,_)|_])|_], Id) :- nonvar(Id1), Id = Id1, !.
timeSelected([_|Ts], Id) :- timeSelected(Ts, Id).


%parseData(+InputSubjectList, +R, -ParsedData) :-
getAnswer(Ds,Ls,Rs) :- getAnswer(Ds,Ls,Rs,1).
getAnswer([],_,[],_).
getAnswer([[Su, Is]|Ds], Ls, [R|Rs], Id) :-
	getAnswerTime(Su, Is, Ls, R, Id, Id1),
	getAnswer(Ds, Ls, Rs, Id1).


%getAnswerTime(+Subject, +TicketList, +Schedule, -ParsedLine, +Id, -NewId) :-
getAnswerTime(_, [], _, _,Id,Id).
getAnswerTime(Su, [[Times,Teacher|_]|Is], Ls, Out, Id, IdR) :-
	(member(Id, Ls) -> Out = r(Su,Teacher,Times);true),
	Id1 is Id+1,
	getAnswerTime(Su, Is, Ls, Out, Id1, IdR)
	.


