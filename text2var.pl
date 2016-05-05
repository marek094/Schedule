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
parseData(Ds,Sch,Rs) :- parseData(Ds,Sch,Rs,1).
parseData([],_,[],_).
parseData([[Su, Is]|Ds], Sch, [i(Su,R)|Rs], Id) :-
%	writeln(Id),
	parse(Su, Is, Sch, R, Id, Id1),
	parseData(Ds, Sch, Rs, Id1).

% parse(+Subject, +TicketList, +Schedule, -ParsedLine, +Id, -NewId) :-
parse(_, [], _, [],Id,Id).
parse(Su, [[Dts|_]|Is], Sch, [t(Id,Vs)|Sc], Id, IdR) :-
%	scheduleAt(Dt, Sch, Var),
	mapScheduleAt(Dts, Sch, Vs),
	Id1 is Id+1,
	parse(Su, Is, Sch, Sc, Id1, IdR).

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

% readSchedule(+Schedule, -Result) :-
%readSchedule(Sch, R) :- readSchedule(dt(1,1), Sch, R).
%readSchedule(dt(W1,_),_,[]) :- define(weekLength, W), W1 is W+1.
%readSchedule(dt(N,_), [SchD|Sch], R) :-
%	define(weekLength, W),
%	N =< W, N1 is N+1,
%	readScheduleDay(d(N, 1), SchD, R),
%	readSchedule(dt(N1,1), Sch, R).
%
%
%readScheduleDay(dt(N,T), SchD, R) :-
%	define(weekLength, W),
%	N =< W, N1 is N+1,
%	readScheduleDay(dt(N,T), SchD, R).








interpretResultLine(i(Su,[Psu|_]), [DI|_], [Su|DI]) :- nonvar(Psu), Su = Psu, !.
interpretResultLine(i(Su,[_|Is]), [_|DIs], A) :-
	interpretResultLine(i(Su,Is), DIs, A).

interpretResult([],[],[]).
interpretResult([i(Su, Is)|Xs], [[Su,DIs|_]|Ds], [A|As]) :-
	interpretResultLine(i(Su,Is), DIs, A),
	%write(A),
	interpretResult(Xs, Ds, As).


inc(A,B) :- B is A+1.
