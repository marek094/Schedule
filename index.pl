
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

lectures(ma, mo, 10-11).
lectures(ma, mo, 8-9).
lectures(kg, mo, 2-3).




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









test(1,Ps,Ss) :-
	Ps = [a,b,c,d,e,f],
	Ss = [
	    p(a, [_1,_3]),
	    p(b, [_3,_1]),
	    p(c, [_6,_9]),
	    p(d, [_3]),
	    p(e, [_6,_9]),
	    p(f, [_4])
	].

test(2,Ps,Ss) :-
	Ps = [a,b,c,d,e,f],
	Ss = [
	    p(a, [_]),
	    p(b, [_]),
	    p(c, [_]),
	    p(d, [_]),
	    p(e, [_]),
	    p(f, [_])
	].


solve([],[]).
solve([p(P,Ss)|L], Ps) :-
	member(P,Ps),
	bind(Ss, P),
	delete(Ps,P,Ps1),
	solve(L,Ps1).

solve([p(P,_)|L],Ps) :- \+member(P,Ps) ,solve(L,Ps).


bind([P|_], P).
bind([_|Ss],P) :- bind(Ss,P).


test_bind(T) :- T = [_,_,_,_].
test_bind(T) :- T = [a, a, a, a].

