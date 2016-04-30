

%%
%
% Scheduler
% MarekCerny.com
%
%%


% scheduler(+Subjects, -Schedule) :-
%    Expecting list of subjects

scheduler(Subjects) :-
	%listVars(Subjects,Schedule),
	%sort(Schedule1,Schedule),
	listSubj(Subjects,SubjectToBind),
	solve(Subjects, SubjectToBind).


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

%
% Sample data



testStart :-
	test(Test,Su, Sc),
        nl, write(Test), nl,
	scheduler(Su),
	write(Sc), nl,
	fail.

test(1, Subjects, [H1,H2,H3,H4,H5,H6]) :-
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






