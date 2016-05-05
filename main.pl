%%
% Project inteface.
%

%?-[scheduler, schedulerio, text2var].
:- include('scheduler.pl').
:- include('schedulerio.pl').
:- include('text2var.pl').

main :-
	genSchedule(Sch),
	testData(X,D),
	print(["Runing test no. ", X, "\n"]),
	parseData(D, Sch, R),
%	writeln(R),
	scheduler(R),

%	print(Sch), nl,
	%print(R), nl,

	%interpretResult(R,D,A),
	%print(R), nl,

	printSchedule(Sch),
        %printAnswer(A),

	%print(A), nl,
	writeln('----'), nl,
	fail
	.

testData(0,D) :-
	D = [
	    ["Bad", [
		 [[dt(mon,1)], "Doc"],
		 [[dt(mon,1)], "Prof"]
	     ]
	    ]
	].

testData(2, D) :-
	D = [
	    ["Nice", [
		 [[dt(mon,1),dt(mon,2)], "Doc"],
		 [[dt(mon,3),dt(mon,4)], "Prof"]
	     ]
	    ]
	].


testData(1,D) :-
	D = [
	    ["NPG",[
		 [[dt(mon,3),dt(mon,4)], "Dvorak"]]
	    ],
	    ["cNPG",[
		[[dt(mon,5),dt(mon,6)], "Hric"],
		[[dt(fri,5),dt(fri,6)], "Kren"]
	     ]
	    ],

	    ["Unix", [
		 [[dt(mon, 7),dt(mon,8)], "Forst"],
		 [[dt(mon, 9),dt(mon,10)], "Forst"]
	     ]
	    ],
	    ["cUnix",[
		 [[dt(fri,5),dt(fri,6)], "Marsik"]
	     ]
	    ],

	    ["cLA",[
		  [[dt(mon, 5),dt(mon,6)], "Sejnoha"],
		  [[dt(mon, 7),dt(mon,8)], "Sejnoha"]
	     ]
	    ],
	    ["cPGM",[
		 [[dt(tue, 7),dt(tue,8)], "Novotny"],
		 [[dt(tue, 11),dt(tue,12)], "Mares"]
	     ]
	    ],
	    ["Tv", [
		 [[dt(wed,3),dt(wed,4),dt(wed,2)], "Jaros"]
	     ]
	    ]
	].
