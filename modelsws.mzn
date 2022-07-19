enum WORKSHOP;
WORKSHOP = {DevOps, HuFaMo, LowCode, MASE, MDEIntelligence, ME, MLE, MoDDiT, MoDeVVa, MPM4CPS, MULTI, OCL};

enum DAY;
DAY = {Sunday, Monday, Tuesday};

% Preferences collected in the Google Form
% 10: Good match
% 5: Fair match
% 0: Poor match
array[WORKSHOP, DAY] of int: preferences;
preferences =
[| 0, 10, 5,
 | 0, 10, 5,
 | 0, 0, 10,
 | 0, 5, 10,
 | 0, 10, 10,
 | 0, 5, 10,
 | 5, 5, 5,
 | 0, 5, 10,
 | 0, 10, 10,
 | 10, 10, 10,
 | 10, 5, 5,
 | 0, 5, 10 |];

% Allocation constraints
array[WORKSHOP] of var DAY: allocation;
constraint allocation[MASE] != allocation[DevOps];              % OC overlap
constraint allocation[DevOps] != allocation[MoDDiT];            % OC overlap
constraint allocation[LowCode] != allocation[MULTI];            % OC overlap
constraint allocation[MPM4CPS] != allocation[MLE];              % Audience overlap
constraint allocation[MPM4CPS] != allocation[MoDeVVa];          % Audience overlap
constraint allocation[LowCode] != allocation[MDEIntelligence];  % Two of the three biggest workshops in the last years
constraint allocation[LowCode] != allocation[MoDDiT];           % Two of the three biggest workshops in the last years
constraint allocation[MDEIntelligence] != allocation[MoDDiT];   % Two of the three biggest workshops in the last years

% Room constraints
var int: sundayWorkshops = count(allocation, 1);
var int: mondayWorkshops = count(allocation, 2);
var int: tuesdayWorkshops = count(allocation, 3);
constraint sundayWorkshops <= 4;
constraint mondayWorkshops <= 5;
constraint tuesdayWorkshops <= 3;

% Schedule quality
var int: goodSchedule = sum(w in WORKSHOP)(preferences[w, allocation[w]]==10);
var int: fairSchedule = sum(w in WORKSHOP)(preferences[w, allocation[w]]==5);
var int: poorSchedule = sum(w in WORKSHOP)(preferences[w, allocation[w]]==0);
var int: satisfaction = sum(w in WORKSHOP)(preferences[w, allocation[w]]);
var float: weightedSatisfaction = satisfaction*((12-poorSchedule)/12);

% Choose goal
var float: GOAL = weightedSatisfaction;

% Solve
solve maximize GOAL;

% Some metrics
var float: satisfactionRatio = satisfaction/(length(WORKSHOP)*10)*100;


% Output
output[
  "Satisfaction: \(satisfaction) (out of \(length(WORKSHOP)*10) --", show_float(0, 1, satisfactionRatio), "%).\n",
  "~~~\n",
  "Allocation: \(allocation)\n",
  "~~~\n",
  "Good schedule: \(goodSchedule).\n",
  "Fair schedule: \(fairSchedule).\n",
  "Poor schedule: \(poorSchedule).\n",
  "~~~\n",
  "Sunday workshops: \(sundayWorkshops).\n",
  "Monday workshops: \(mondayWorkshops).\n",
  "Tuesday workshops: \(tuesdayWorkshops).\n"
]