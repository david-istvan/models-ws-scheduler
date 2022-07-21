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
var int: sundayWorkshops = count(allocation, Sunday);
var int: mondayWorkshops = count(allocation, Monday);
var int: tuesdayWorkshops = count(allocation, Tuesday);
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
  "Satisfaction: \(satisfaction) (out of \(length(WORKSHOP)*weights[good]) --", show_float(0, 1, satisfactionRatio), "%).\n",
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