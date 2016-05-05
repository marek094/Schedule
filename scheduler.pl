%%
% Scheduler - main logic part
% MarekCerny.com
%



% scheduler(+Subjects, -Schedule) :-
%    Expecting list of subjects

scheduler(Subjects) :-
	listSubj(Subjects,SubjectToBind),
	%writeln(SubjectToBind),
	% sorting by options count
	%computeLengths(Subjects,SubjLen),
	%sort(SubjLen, SortSubjLen),
	%computeLengths(SortedSubjects,SortSubjLen),
	Subjects = SortedSubjects,

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
solve(Ss, [B|Bs]) :-
	member(i(B,PossibleTimes),Ss),
%	!, % unif one
	member(B,PossibleTimes),
%	print([B,'\t',PossibleTimes, '\n']),
%	print(Ss),nl,
	solve(Ss, Bs).


computeLengths([],[]).
computeLengths([T|Ts], [t(L,T)|Os]) :-
	i(_,List) = T,
	length(List,L),
	computeLengths(Ts,Os).
