%%
% Project inteface.
%

main :-
	genSchedule(Sch),
	testData(_,D),

	parseData(D, Sch, R),
	scheduler(R),
	interpretResult(R,D,A),

	printSchedule(Sch),
	printAnswer(A),

	writeln('----'),
	fail
	.



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
	    ]
	].



?- main.


