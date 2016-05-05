%
% Unused/sample declaratons
%
%
%print_string(_, 0) :- write('\n'), !.
%print_string(String, N) :-
%	write(String),
%	N1 is N-1,
%	print_string(String, N1).
%
%print_sep() :- write('+'), print_string('------+', 10).
%
%
%print_schedule :-
%	   print_sep().
%
%
%subject(ma,'Matematická analýza').
%subject(kg,'Kombinatorika a grafy').
%subject(la, 'Lineární algebra').
%
%lectures(ma, mo, 10-11).
%lectures(ma, mo, 8-9).
%lectures(kg, mo, 2-3).
%
%
%
%
%print_subjects :-
%	subject(Zkratka,Jmeno),
%	write(Zkratka), write(' - '), write(Jmeno), nl,
%	fail.
%print_subjects. % because of warning.
%%
%%
%%get_empty_day(0, []) :- !.
%%get_empty_day(N, [_|Ds]) :-
%%	N1 is N-1, get_empty_day(N1, Ds).
%%
%%
%%plan_day([],[]).
%plan_day([D|Ds], [O|Os]) :-
%	subject(Zkratka,_),
%	(
%	    var(D) -> O = Zkratka;
%	    O = D
%	),
%	plan_day(Ds, Os).
%
%
%random_day(D) :- get_empty_day(16, Empty), plan_day(Empty, D).
%
%print_day([]) :- nl.
%print_day([D|Ds]) :-
%	write(D), write('\t'),
%	print_day(Ds).
%
%
%subject_list(List) :- bagof(A, B^subject(A,B), List).
%
%
%is_ma(List) :-
%	member(ma, List).
%
%
%test(1,Ps,Ss, Hs) :-
%	Ps = [a,b,c,d,e,f],
%	Hs = [H1,H2,H3,H4,H5,H6],
%	Ss = [
%	    p(a, [H1,H3]),
%	    p(b, [H1,H3]),
%	    p(c, [H5,H6]),
%	    p(d, [H2]),
%	    p(e, [H5,H6]),
%	    p(f, [H4])
%	].
%
%test(4,Ps,Ss, Hs) :-
%	Ps = [a,b,c,z,e,f],
%	Hs = [H1,H2,H3,H4,H5,H6,H7],
%	Ss = [
%	    p(a, [H1,H1]),
%	    p(b, [H2,H1]),
%	    p(c, [H3,H4]),
%	    p(z, [H4,H3]),
%	    p(e, [H5]),
%	    p(f, [H6])
%	].
%
%
%test(2,Ps,Ss, Hs) :-
%	Ps = [a],
%	Hs = [H1],
%	Ss = [
%	    p(a, [H1])
%	].
%
%test(3, Ps, Ss, Hs) :-
%	Ps = [a,b,c,d,e,f],
%	Hs = [H1,H2,H3,H4,H5,H6],
%	Ss = [
%	    p(a, [H1,H2]),
%	    p(b, [H2,H3]),
%	    p(c, [H3,H4]),
%	    p(d, [H4,H5]),
%	    p(e, [H5,H6]),
%	    p(f, [H6,H6])
%	].
%
%
%
%solve([],[],[]).
%solve([p(P,Ss)|L], Ps, [P|Hs]) :-
%	member(P,Ps),
%	bind(Ss, P),
%	delete(Ps,P,Ps1),
%	solve(L,Ps1,Hs).
%
%solve([p(P,_)|L],Ps, Hs) :- \+member(P,Ps) ,solve(L,Ps, Hs).
%
%
%bind([P|_], P).
%bind([_|Ss],P) :- bind(Ss,P).
%
%
%test_bind(T) :- T = [_,_,_,_].
%test_bind(T) :- T = [a, a, a, a].
%
%
%
%
%listVars([],[]).
%listVars([subj(_,Hs)|Ss], O) :-
%    listVars(Ss, O1),
%    insertListUniq(Hs, O1, O).
%
%
%insertListUniq([],X,X).
%insertListUniq([P|Ps], Ls, Out) :-
%	insertUniq(P,Ls,Ls1),
%	insertListUniq(Ps,Ls1,Out).
%
