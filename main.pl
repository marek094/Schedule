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
	scheduler(R),

	%print(Sch), nl,
	%print(R), nl,

	interpretResult(R,D,A),
	%print(R), nl,

	printSchedule(Sch),
        printAnswer(A),

	%print(A), nl,
	writeln('----'), nl,
	fail
	.

testData(0,D) :-
	D = [
	    ["A", [
		 [dt(mon,1), "Doc"],
		 [dt(mon,1), "Prof"]
	     ]
	    ]
	].

testData(2, D) :-
	D = [
	    ["A", [
		 [dt(mon,1), "Doc"],
		 [dt(mon,2), "Prof"]
	     ]
	    ]
	].


testData(1,D) :-
	D = [
	    ["NPG",[[dt(mon,3), "Dvorak"]]],
	    ["cNPG",[
		[dt(mon,5), "Hric"],
		[dt(fri,5), "Kren"]
	     ]
	    ],

	    ["Unix", [
		 [dt(mon, 7), "Forst"],
		 [dt(mon, 9), "Forst"]
	     ]
	    ],
	    ["cUnix",[
		 [dt(fri,5), "Marsik"]
	     ]
	    ],

	    ["cLA",[
		  [dt(mon, 5), "Sejnoha"],
		  [dt(mon, 7), "Sejnoha"]
	     ]
	    ],
	    ["cPGM",[
		 [dt(tue, 7), "Novotny"],
		 [dt(tue, 11), "Mares"]
	     ]
	    ]
	].



%?- main.


