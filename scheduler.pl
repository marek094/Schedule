

%%
%
% Scheduler
% MarekCerny.com
%
%%


% scheduler(+Subjects, -Schedule) :-
%    Expecting list of subjects

scheduler(Subjects) :-
	listSubj(Subjects,SubjectToBind),

	% sorting by options count
	computeLengths(Subjects,SubjLen),
	sort(SubjLen, SortSubjLen),
	computeLengths(SortedSubjects,SortSubjLen),

	solve(SortedSubjects, SubjectToBind).



% listVars(+ListOfSubj, -Out) :-
%    Make list of variables coresponding to hours

listSubj([],[]).
listSubj([subj(S,_)|Ss], O) :-
    listSubj(Ss, O1),
    insertUniq(S, O1, O).


% insertUniq(+P,+List,+NewList) :-
%    Insert if not member.

insertUniq(P,[],[P]).
insertUniq(P,[L|Ls],[L|Ls]) :- \+( P@<L ), \+( P@>L ), !.
insertUniq(P,[L|Ls],[L|O]) :- insertUniq(P,Ls,O).

% solve(+Subjects,+ListOfSubjectsToBind) :-
%     Unificate each subject with session

solve(_,[]).
solve(S, [B|Bs]) :-
	member(subj(B,PossibleTimes),S),
	selectEach(PossibleTimes, B), %Time = B,
	solve(S, Bs).



%
% selectEach(+List, Element) :-
%     unify with each element of List.
%

selectEach([L|_], L).
selectEach([_|List], E) :- selectEach(List, E).

length(Ls, N) :- length(Ls,0,N).
length([],N,N).
length(Ls,N,Out) :- N1 is N+1, length(Ls,N1,Out).

computeLengths([],[]).
computeLengths([T|Ts], [t(L,T)|Os]) :-
	subj(_,List) = T,
	length(List,L),
	computeLengths(Ts,Os).



%%
%
% Predicates preparing terms from input
%


%
% unif(Sch, Ls, Sc) :-
%   Unify time of lesson with given schedule

unif(Sch, Ls, Sc) :- unif(Sch, Ls, Sc, 1).
unif(_, [],[],_).
unif(Sch, [inst(_,Time)|Ls], [n(Id,Var)|Sc], Id) :-
	atSchedule(Time, Sch, Var),

	Id1 is Id+1, unif(Sch, Ls, Sc, Id1).


genSchedule(0, []).
genSchedule(N, [_|L]) :- N>0, N1 is N-1, genSchedule(N1, L).

atSchedule(0, [L|_], L).
atSchedule(N, [_|Ls], L) :-
	N > 0, N1 is N-1,
	atSchedule(N1, Ls, L).





%
% Sample data

testStart :-
	test(Test,Su, Sc),
        nl, write(Test), nl,
	scheduler(Su),
	write(Sc), nl,
	fail.

test(1, Subjects, [H1,H2]) :-
	Subjects = [
	    subj(ma, [H2, H1]),
	    subj(la, [H1, H2])
	].

test(2, Su, Sc) :-
	Sc = [H1,H2,H3,H4,H5,H6],
	Su = [
	    subj(ma, [H3, H1, H2]),
	    subj(la, [H1]),
	    subj(kg, [H4,H5,H6])
	].

test(3, Su, Sc) :-
	Sc = [H10,H9,H8,H7,H6,H5,H4,H3,H2,H1],
	Su = [

	    subj(a, [H1,H2,H3,H4,H5,H6,H7,H8,H9,H10]),
	    subj(b, [H1,H2,H3,H4,H5,H6,H7,H8,H9]),
	    subj(c, [H1,H2,H3,H4,H5,H6,H7,H8]),
	    subj(d, [H1,H2,H3,H4,H5,H6,H7]),
	    subj(e, [H1,H2,H3,H4,H5,H6]),
	    subj(f, [H1,H2,H3,H4,H5]),
	    subj(g, [H1,H2,H3,H4]),
	    subj(h, [H1,H2,H3]),
	    subj(i, [H1,H2]),
	    subj(j, [H1])
	].

test(4, Su, Sc) :-
	Sc = [H1,H2,H3,H4],
	Su = [
	    subj(ma, [H1,H2,H3]),
	    subj(la, [H1,H2]),
	    subj(kg, [H1,_])
	].






