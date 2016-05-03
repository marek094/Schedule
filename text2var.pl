%%
%
%  Instances => variables
%


weekDay(1, mon).
weekDay(2, tue).
weekDay(3, wed).
weekDay(4, thu).
weekDay(5, fri).

define(dayLength, 4).
define(weekLength, 5).


unifData([],_,[]).
unifData([[Su, Is]|Ds], Sch, [i(Su,R)|Rs]) :-
	unif(Su, Is, Sch, R),
	unifData(Ds, Sch, Rs).


%unif(_,_,1).
unif(_, [], _, []).
unif(Su, [[Dt|_]|Is], Sch, [Var|Sc]) :-
	scheduleAt(Dt, Sch, Var),
	unif(Su, Is, Sch, Sc).


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




testStart(Sch, R) :-
	genSchedule(Sch),
	%scheduleAt(dt(X,2), Sch, muHAHAHAHAHA),
	Data = [
	    [a,
	     [
		 [dt(mon,1), 'Hric']
	     ]
	    ],
	    [b,
	     [
		 [dt(tue,2), 'Mares'],
		 [dt(tue,3), 'Karel']
	     ]
	    ],
	    [c,
	     [
		 [dt(tue,2), 'Ales'],
		 [dt(mon,1), 'Leos']
	     ]
	    ]

	],
	unifData(Data, Sch, R).
	%unif(Sch, Data, R)
	%.
	%L = [inst(a,1), inst(b,2), inst(d,4)],
	%unif(Sch, L, X).


