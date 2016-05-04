%%
% Scheduler - main logic part
% MarekCerny.com
%



% scheduler(+Subjects, -Schedule) :-
%    Expecting list of subjects

scheduler(Subjects) :-
	listSubj(Subjects,SubjectToBind),

	% sorting by options count
	computeLengths(Subjects,SubjLen),
	sort(SubjLen, SortSubjLen),
	computeLengths(SortedSubjects,SortSubjLen),
	%Subjects = SortedSubjects,

	solve(SortedSubjects, SubjectToBind).


% listVars(+ListOfSubj, -Out) :-
%    Make list of variables coresponding to hours

listSubj([],[]).
listSubj([i(S,_)|Ss], O) :-
    listSubj(Ss, O1),
    insertUniq(S, O1, O).


% insertUniq(+P,+List,-NewList) :-
%    Insert if not member.

insertUniq(P,[],[P]).
insertUniq(P,[L|Ls],[L|Ls]) :- \+( P@<L ), \+( P@>L ), !.
insertUniq(P,[L|Ls],[L|O]) :- insertUniq(P,Ls,O).

% solve(+Subjects,+ListOfSubjectsToBind) :-
%     Unificate each subject with session

solve(_,[]).
solve(S, [B|Bs]) :-
	member(i(B,PossibleTimes),S),
	selectEach(PossibleTimes, B), %Time = B,
	solve(S, Bs).

%
% selectEach(+List, Element) :-
%     unify with each element of List.
%     -> nondetermistic

selectEach([L|_], L).
selectEach([_|List], E) :- selectEach(List, E).

computeLengths([],[]).
computeLengths([T|Ts], [t(L,T)|Os]) :-
	i(_,List) = T,
	length(List,L),
	computeLengths(Ts,Os).
