%%
% scheduler.pl
%
% Scheduler
%   MarekCerny.com
%
% variables to unify ---> unification
%



% scheduler(+Subjects, -Schedule) :-
%    Expecting list of subjects, output is selection
scheduler(Subjects, PotW) :-
	computeLengths(Subjects,SubjLen),
	sort(SubjLen, SortSubjLen),
	computeLengths(SortedSubjects,SortSubjLen),

	listSubj(SortedSubjects,SubjectToBind),
	solve(SortedSubjects, SubjectToBind, PotW, Weight),
	checkWeight(Weight)
	.

% listVars(+SubjectList, -Out) :-
%    Make list of variables coresponding to hours
listSubj([],[]).
listSubj([i(S,_)|Ss], O) :-
    listSubj(Ss, O1),
    insertUniq(S, O1, O).

% insertUniq(+P, +List,-NewList) :-
%    Insert P if not member of List.
insertUniq(P,[],[P]).
insertUniq(P,[L|Ls],[L|Ls]) :- \+( P@<L ), \+( P@>L ), !.
insertUniq(P,[L|Ls],[L|O]) :- insertUniq(P,Ls,O).

% solve(+Subjects, +SubjectsListToBind) :-
%     Unificate each subject with session
solve(_,[],_, 0).
solve(Ss, [B|Bs], PotW, W) :-
	[i(_,[t(BestW,_,_)|_])|_] = Ss,

	member(i(B,PossibleTimes),Ss),

	unifEach(B, PossibleTimes, ThisW),
	PotW1 is PotW-BestW+ThisW,
	checkPotencial(PotW1),
	solve(Ss, Bs, PotW1, Wr),
	W is ThisW+Wr
	.

% unifEach(+Subject, ?ListOfListsOfLessonTimes) :-
%    Try unif Subject with List
unifEach(B, [t(W,Id,Ts)|_], W) :- unifList(B, Ts, Id).
unifEach(B, [_|Tss], W) :- unifEach(B,Tss, W).

% unifList(+Subject, ?ListOfLessonTimes) :-
%    Try unif all from list
unifList(_,[], _).
unifList(B, [L|Ls], Id) :-
	L = cell(Id,B),
	unifList(B, Ls, Id).

% computeLengths(+SubjectsList, -StructureSubjects) :-
%    Returns structure with number of lessonTimes as first paramets
computeLengths([],[]).
computeLengths([T|Ts], [s(L,T,_)|Os]) :-
	i(_,List) = T,
	length(List,L),
	computeLengths(Ts,Os).

% sortByWeights(+SubjectsList, -SortedSubjectList) :-
%    Sort lessonTimes of each subject by weights
sortByWeights([],[]).
sortByWeights([i(A,T)|Ss],[i(A,R)|Rs]) :-
	sort(T,R1),
	reverse(R1, R),
	sortByWeights(Ss,Rs).

% computeWeights(+SelectedLessonsList, -WeightsSum) :-
%    Compute Weight of given solution
computeWeights([],0).
computeWeights([t(W,_,_)|Ts],W1) :-
	computeWeights(Ts, Wr),
	W1 is W+Wr.

% computePotencialW(+SortedSubjectList, -PotencialWeight)
%    get upper bound of weight
computePotencialW([],0).
computePotencialW([i(_,[t(W1,_,_)|_])|Ss],W) :-
	computePotencialW(Ss,Wr),
	W is Wr+W1.


% checkWeight(+Weight) :-
%    fails if is not better than maximum
checkWeight(Weight) :-
	nb_getval(maxW, MaxW),
	Weight >= MaxW,
	nb_setval(maxW,Weight).

% checkPotencial(+PotencialWeight) :-
%    fails if maximumPotencial not better than maximum
checkPotencial(PotW1) :-
	nb_getval(maxW, MaxW),
	PotW1 >= MaxW.

