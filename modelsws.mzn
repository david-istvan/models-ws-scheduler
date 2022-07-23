enum WORKSHOP;
WORKSHOP = {DevOps, HuFaMo, LowCode, MASE, MDEIntelligence, ME, MLE, MoDDiT, MoDeVVa, MPM4CPS, MULTI, OCL};

enum DAY;
DAY = {Sunday, Monday, Tuesday};

enum PREFERENCE;
PREFERENCE = {poor, fair, good};

% Preferences collected in the Google Form
array[WORKSHOP, DAY] of PREFERENCE: preferences;
preferences =
[| poor, good, fair,
 | poor, good, fair,
 | poor, poor, good,
 | poor, fair, good,
 | poor, good, good,
 | poor, fair, good,
 | fair, fair, fair,
 | poor, fair, good,
 | poor, good, good,
 | good, good, good,
 | good, fair, fair,
 | poor, fair, good |];

% Workshop format: full-day or half-day
set of float: LENGTH = {1, 0.5};
array[WORKSHOP] of var LENGTH: format;
array[WORKSHOP] of bool: fixedFullday = [true, true, true, true, true, true, true, true, true, true, true, true];
constraint forall(w in WORKSHOP)(if fixedFullday[w] then format[w]==1 endif);


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
var float: sundayWorkshops = sum(w in WORKSHOP)(format[w]*(allocation[w]==Sunday));
var float: mondayWorkshops = sum(w in WORKSHOP)(format[w]*(allocation[w]==Monday));
var float: tuesdayWorkshops = sum(w in WORKSHOP)(format[w]*(allocation[w]==Tuesday));
constraint sundayWorkshops <= 4;
constraint mondayWorkshops <= 5;
constraint tuesdayWorkshops <= 3;

% Schedule quality
var int: goodSchedule = sum(w in WORKSHOP)(preferences[w, allocation[w]]==good);
var int: fairSchedule = sum(w in WORKSHOP)(preferences[w, allocation[w]]==fair);
var int: poorSchedule = sum(w in WORKSHOP)(preferences[w, allocation[w]]==poor);

% Metrics
array[PREFERENCE] of var int: weights = [0, 5, 10];
var int: satisfaction = sum(w in WORKSHOP)(weights[preferences[w, allocation[w]]]);
var float: weightedSatisfaction = satisfaction*((length(WORKSHOP)-poorSchedule)/length(WORKSHOP));

% Choose goal
var float: GOAL = weightedSatisfaction;

% Solve
solve maximize GOAL;

% Some metrics
var float: satisfactionRatio = satisfaction/(length(WORKSHOP)*weights[good])*100;


% Output
output[
  "Satisfaction: \(satisfaction).",
  " -- ", show_float(0, 1, satisfactionRatio), "% of theoretical max (\(length(WORKSHOP)*weights[good])), ",
  show_float(0, 1, 100*satisfaction/105), "% of feasible max (105).\n",
  "~~~\n",
  "Allocation: \(allocation)\n",
  "Format: \(format)\n",
  "~~~\n",
  "Good schedule: \(goodSchedule).\n",
  "Fair schedule: \(fairSchedule).\n",
  "Poor schedule: \(poorSchedule).\n",
  "~~~\n",
  "Sunday workshops: \(sundayWorkshops).\n",
  "Monday workshops: \(mondayWorkshops).\n",
  "Tuesday workshops: \(tuesdayWorkshops).\n"
]