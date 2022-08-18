enum DAY;
DAY = {Sunday, Monday, Tuesday};

enum PREFERENCE;
PREFERENCE = {poor, fair, good};

enum WORKSHOP;
WORKSHOP = {DevOps, HuFaMo, LowCode, MASE, MDEIntelligence, ME, MLE, MoDDiT, MoDeVVa, MPM4CPS, MULTI, OCL};

% Preferences collected in the Google Form
array[WORKSHOP, DAY] of PREFERENCE: preferences;

% Workshop format: full-day or half-day
set of float: LENGTH = {1, 0.5};
array[WORKSHOP] of var LENGTH: format;
array[WORKSHOP] of bool: fixedFullday;
constraint forall(w in WORKSHOP)(if fixedFullday[w] then format[w]==1 endif);

predicate sameDay(var WORKSHOP: w1, var WORKSHOP: w2) =
  allocation[w1] == allocation[w2];

predicate notInParallel(var WORKSHOP: w1, var WORKSHOP: w2) =
  if sameDay(w1, w2) then format[w1]+format[w2] <= 1 endif;

% Allocation constraints
array[WORKSHOP] of var DAY: allocation;
constraint notInParallel(MASE, DevOps);              % OC overlap
constraint notInParallel(DevOps, MoDDiT);            % OC overlap
constraint notInParallel(LowCode, MULTI);            % OC overlap
constraint notInParallel(MPM4CPS, MLE);              % Audience overlap
constraint notInParallel(MPM4CPS, MoDeVVa);          % Audience overlap
constraint notInParallel(LowCode, MDEIntelligence);  % Two of the three biggest workshops in the last years
%constraint notInParallel(LowCode, MoDDiT);           % Two of the three biggest workshops in the last years
constraint notInParallel(MDEIntelligence, MoDDiT);   % Two of the three biggest workshops in the last years

% Room constraints
int: sundayWorkshopsMax;
int: mondayWorkshopsMax;
int: tuesdayWorkshopsMax;
var float: sundayWorkshops = sum(w in WORKSHOP)(format[w]*(allocation[w]==Sunday));
var float: mondayWorkshops = sum(w in WORKSHOP)(format[w]*(allocation[w]==Monday));
var float: tuesdayWorkshops = sum(w in WORKSHOP)(format[w]*(allocation[w]==Tuesday));
constraint sundayWorkshops <= sundayWorkshopsMax;
constraint mondayWorkshops <= mondayWorkshopsMax;
constraint tuesdayWorkshops <= tuesdayWorkshopsMax;

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

% Solve -- Use this to find maximized goal value
% solve maximize GOAL;
% Solve -- Use these two lines to generate all values for the previously found max
constraint satisfactionRatio >= 83.3;
solve satisfy;

% Some metrics
var float: satisfactionRatio = satisfaction/(length(WORKSHOP)*weights[good])*100;

% Output
output[
  "Satisfaction: \(satisfaction).",
  " -- ", show_float(0, 1, satisfactionRatio), "% of theoretical max (\(length(WORKSHOP)*weights[good])).\n",
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