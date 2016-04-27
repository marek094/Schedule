
print_string(_, 0) :- write('\n'), !.
print_string(String, N) :-
	write(String),
	N1 is N-1,
	print_string(String, N1).

print_sep() :- write('+'), print_string('------+', 10).


print_schedule :-
	   print_sep().


subject(ma,'Matematická analýza').
subject(kg,'Kombinatorika a grafy').
subject(la, 'Lineární algebra').

lectures(ma, mo, 10+11).
lectures(ma, mo, 8+9).




print_subjects :-
	subject(Zkratka,Jmeno),
	write(Zkratka), write(' - '), write(Jmeno), nl,
	fail.
print_subjects. % because of warning.


get_empty_day(0, []) :- !.
get_empty_day(N, [_|Ds]) :-
	N1 is N-1, get_empty_day(N1, Ds).


plan_day([],[]).
plan_day([D|Ds], [O|Os]) :-
	subject(Zkratka,_),
	(
	    var(D) -> O = Zkratka;
	    O = D
	),
	plan_day(Ds, Os).


random_day(D) :- get_empty_day(16, Empty), plan_day(Empty, D).

print_day([]) :- nl.
print_day([D|Ds]) :-
	write(D), write('\t'),
	print_day(Ds).


subject_list(List) :- bagof(A, B^subject(A,B), List).


is_ma(List) :-
	member(ma, List).

main :-
	%get_empty_day(16, Empty),
	Empty = [_,_,_, 'Tady', 'Neco', 'Je'],
	plan_day(Empty, D),
	print_day(D),
	(
	    member(ma,D) -> write('Obsahuje matalýzu') ;
	    true
	).



?- main.
