%%
% Project inteface.
%

:- include('scheduler.pl').
:- include('schedulerio.pl').
:- include('text2var.pl').


main :-
	%Test = 3,
	testData(Test,D,W),
	nl,nl,nl,
	print(["Runing test no. ", Test, "\n"]),
	nb_setval(maxW, -9999),

	genSchedule(Sch),
	parseData(D, Sch, W, R1),

	sortByWeights(R1,R),
	computePotencialW(R,PotW),

	scheduler(R, PotW),
	interpretResult(R,S),
	getAnswer(D,S,A),

	nb_getval(maxW,MaxW),
	print(["Weight: ", MaxW, "\n"]),

	printSchedule(Sch),
	printAnswer(A),

	writeln('----'), nl,
	fail
	.



testData(1, D, W) :-
	W = ["Doc"-110,"Prof"-120],
	D = [
	    ["Subj", [
		 [[dt(mon,1),dt(mon,2)], "Doc"],
		 [[dt(mon,3),dt(mon,4)], "Prof"]
	     ]
	    ]
	].


testData(2,D,[]) :-
	D = [
	    ["A", [
		 [[dt(mon,1)], "a1"],
		 [[dt(mon,4)], "a1"],
		 [[dt(mon,2)], "a2"]
	     ]
	    ],
	    ["B", [
		 [[dt(mon,2)], "b1"],
		 [[dt(mon,3)], "b2"]
	     ]
	    ],
	    ["C", [
		 [[dt(tue,2),dt(mon,2)], "c1"]
	     ]
	    ]
	].

%
% Part of real schedule
testData(3,D,W) :-
	W = [
	    "Dvorak"-120,
	    "Hric"-120,
	    "Forst"-90,
	    "Sejnoha"-115,
	    "Mares"-130,
	    "DvorakZ"-90,
	    "Klavik"-114,
	    "Tancer"-110,
	    "Musilek"-119,
	    "Holan"-101,
	    "Topfer"-111,
	    "Fiala"-131
	],
	D = [
	    ["NPG",[
		 [[dt(mon,3),dt(mon,4)], "Dvorak"],
		 [[dt(wed,5),dt(mon,6)], "Dvorak"]
	     ]
	    ],
	    ["cNPG",[
		[[dt(mon,5),dt(mon,6)], "Hric"],
		[[dt(tue,3),dt(tue,4)], "Pilat"],
		[[dt(tue,3),dt(tue,4)], "Kryl"]
	     ]
	    ],

	    ["Unix", [
		 [[dt(mon, 7),dt(mon,8)], "Forst"],
		 [[dt(mon, 9),dt(mon,10)], "Forst"]
	     ]
	    ],
	    ["cUnix",[
		 [[dt(fri,5),dt(fri,6)], "Marsik"],
		 [[dt(tue,5),dt(tue,6)],"Moudrik"],
		 [[dt(tue,7),dt(tue,8)],"Musilek"],
		 [[dt(tue,11),dt(tue,12)],"Kratochvil"],
		 [[dt(thu,5),dt(thu,6)],"Vernerova"]
	     ]
	    ],

	    ["LA", [
		 [[dt(thu,3),dt(thu,4)], "Pangrac"],
		 [[dt(thu,5),dt(thu,6)], "DvorakZ"],
		 [[dt(fri,7),dt(fri,8)], "Kucera"]
	     ]
	    ],
	    ["cLA",[
		 [[dt(mon, 5),dt(mon,6)], "Sejnoha"],
		 [[dt(mon, 7),dt(mon,8)], "Sejnoha"],
		 [[dt(mon, 11),dt(mon,12)], "DvorakP"],
		 [[dt(thu,13),dt(thu,14)], "Klavik"]
	     ]
	    ],

	    ["PGM", [
		 [[dt(tue,9),dt(tue,10)], "Holan"],
		 [[dt(wed,9),dt(wed,10)], "Topfer"]
	     ]
	    ],
	    ["cPGM",[
		 [[dt(mon,7),dt(mon,8)], "Pergel"],
		 [[dt(mon,11),dt(mon,12)], "Holan"],

		 [[dt(tue,7),dt(tue,8)], "Novotny"],
		 [[dt(tue,11),dt(tue,12)], "Mares"],
		 [[dt(thu,9),dt(thu,10)], "Gemrot"]
	     ]
	    ],
	    ["Tv", [
		 [[dt(wed,3),dt(wed,5),dt(wed,4),dt(wed,2)], "Jaros"]
	     ]
	    ],

	    ["MA", [
		 [[dt(mon,5),dt(mon,6)], "Hans Raj"],
		 [[dt(fri,7),dt(fri,8)], "Samal"],
		 [[dt(fri,9),dt(fri,10)], "Pokorny"]
	     ]
	    ],
	    ["cMA", [
		 [[dt(mon, 9),dt(mon, 10)], "Hans Raj"],
		 [[dt(wed, 7),dt(wed,8)], "Tancer"],
		 [[dt(fri, 5),dt(fri, 6)], "Krylova"]
	     ]
	    ],
	    ["cADS", [
		 [[dt(mon,7),dt(mon,8)],"Majerech"],
		 [[dt(thu,7),dt(thu,8)],"Hric"],
		 [[dt(wed,9),dt(wed,10)],"Bok"]
	     ]
	    ],
	    ["ADS", [
		 [[dt(tue,3),dt(tue,4)],"Kucera"],
		 [[dt(tue,3),dt(tue,4)],"Hric"],
		 [[dt(tue,3),dt(tue,4)],"Cepek"]
	     ]
	    ],

	    ["KG", [
		 [[dt(tue,5),dt(tue,6)],"Mares"],
		 [[dt(tue,7),dt(tue,8)],"Jelinek"],
		 [[dt(fri,3),dt(fri,4)],"Fiala"]
	     ]
	    ],
	    ["cKG", [
		 [[dt(thu,5),dt(thu,6)],"Fiala"]
	     ]
	    ],
	    ["NJ", [
		 [[dt(thu,11),dt(thu,12)],"Vachalovska"],
		 [[dt(mon,9),dt(mon,10)],"Vachalovska"]
	      ]
	    ],
	    ["AJ", [
		 [[dt(mon,12),dt(mon,13)],"Mikulas"],
		 [[dt(mon,3),dt(mon,4)],"Mikulas"]
	     ]
	    ],
	    ["IPS", [
		 [[dt(thu,13),dt(thu,14),dt(thu,15)],"Mares"]
	     ]
	    ],
	    ["Arch", [
		 [[dt(tue,5),dt(tue,6)],"Bulej"]
	     ]
	    ],
	    ["FS", [
		 [[dt(tue,13),dt(tue,14)],"Sejnoha"]
	     ]
	    ]




	].
