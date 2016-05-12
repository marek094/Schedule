%%
% Project inteface.
%

%?-[scheduler, schedulerio, text2var].
:- include('scheduler.pl').
:- include('schedulerio.pl').
:- include('text2var.pl').


main :-

	testData(X,D,W),
	print(["Runing test no. ", X, "\n"]),
	nb_setval(maxW, -9999),


	genSchedule(Sch),
	parseData(D, Sch, W, R1),
	sortByWeights(R1,R),

	computePotencialW(R,PotW),
	writeln(PotW),
	scheduler(R, PotW),
	interpretResult(R,S),
	getAnswer(D,S,A),


	printSchedule(Sch),
	printAnswer(A),

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

testData(2, D, W) :-
	D = [
	    ["Nice", [
		 [[dt(mon,1),dt(mon,2)], "Doc"],
		 [[dt(mon,3),dt(mon,4)], "Prof"]
	     ]
	    ]
	],
	W = ["Doc"-110,"Prof"-120].

testData(3,D,W) :-
	W = ["Dvorak"-120, "Hric"-120, "Forst"-90, "Sejnoha"-115, "Mares"-130],
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


%
% My schedule
testData(4,D,W) :-
	W = [
	    "Dvorak"-120,
	    "Hric"-120,
	    "Forst"-90,
	    "Sejnoha"-115,
	    "Mares"-130,
	    "DvorakZ"-90,
	    "Klavik"-121,
	    "Tancer"-110,
	    "Musilek"-119,
	    "Samal"-110,
	    "Holan"-101,
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
		[[dt(tue,3),dt(tue,4)], "Kryl"],
		[[dt(wed,7),dt(wed,8)], "Kryl"],
		[[dt(wed,7),dt(wed,8)], "Dvorak"],
		[[dt(fri,5),dt(fri,6)], "Kren"],
		[[dt(fri,7),dt(fri,8)], "Pilat"]
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
		 [[dt(wed,15),dt(wed,16)],"Hykl"],
		 [[dt(thu,5),dt(thu,6)],"Vernerova"],
		 [[dt(thu,7),dt(thu,8)],"KuceraP"],
		 [[dt(fri,3),dt(fri,4)],"Wirth"],
		 [[dt(fri,9),dt(fri,10)],"Platek"]
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
		 [[dt(tue, 5),dt(tue,6)], "DvorakP"],
		 [[dt(tue, 7),dt(tue,8)], "Kral"],
		 [[dt(tue, 9),dt(tue, 10)], "Horacek"],
		 [[dt(wed,9),dt(wed,10)], "Knop"],
		 [[dt(wed,11),dt(wed,12)], "Bok"],
		 [[dt(thu,7),dt(thu,8)], "Kaluza"],
		 [[dt(thu,5),dt(thu,6)], "Bok"],
		 [[dt(thu,13),dt(thu,14)], "Klavik"]
	     ]
	    ],

	    ["PGM", [
		 [[dt(mon,3),dt(mon,4)],"Pergel"],
		 [[dt(tue,9),dt(tue,10)], "Holan"],
		 [[dt(wed,9),dt(wed,10)], "Topfer"]
	     ]
	    ],
	    ["cPGM",[
		 [[dt(mon,7),dt(mon,8)], "Pergel"],
		 [[dt(mon,11),dt(mon,12)], "Holan"],

		 [[dt(tue,7),dt(tue,8)], "Novotny"],
		 [[dt(tue,11),dt(tue,12)], "Mares"],

		 [[dt(wed,5),dt(wed,6)], "Pergel"],
		 [[dt(wed,7),dt(wed,8)], "Topfer"],
		 [[dt(wed,9),dt(wed,10)], "Svec"],
		 [[dt(wed,11),dt(wed,12)], "Vytasil"],

		 [[dt(thu,5),dt(thu,6)], "Holan"],
		 [[dt(thu,7),dt(thu,8)], "Topfer"],
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
		 [[dt(tue, 5),dt(tue,6)], "Lopatkova"],
		 [[dt(tue, 7),dt(tue,8)], "Lopatkova"],
		 [[dt(wed, 7),dt(wed,8)], "Tancer"],
		 [[dt(wed, 9),dt(wed,10)], "Pokorny"],
		 [[dt(wed,11),dt(wed,12)], "Salac"],
		 [[dt(wed, 9),dt(wed, 10)], "Pokorny"],
		 [[dt(wed,11),dt(wed, 12)], "Pokorny"],
		 [[dt(fri, 5),dt(fri, 6)], "Krylova"]
	     ]
	    ],
	    ["cADS", [
		 [[dt(mon,7),dt(mon,8)],"Majerech"],
		 [[dt(mon,9),dt(mon,10)],"Koutecky"],
		 [[dt(mon,9),dt(mon,10)],"Musilek"],
		 [[dt(mon,9),dt(mon,10)],"Setnicka"],
		 [[dt(mon,11),dt(mon,12)],"Majerech"],
		 [[dt(tue,7),dt(tue,8)],"Chromy"],
		 [[dt(tue,11),dt(tue,12)],"Kucera"],
		 [[dt(thu,3),dt(thu,4)],"Husek"],
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
	    ]



	].
%		 [[dt(),dt()], ],
