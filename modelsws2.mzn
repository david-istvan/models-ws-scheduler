enum WORKSHOP;
WORKSHOP = {DevOps, HuFaMo, LowCode, MASE, MDEIntelligence, ME, MLE, MoDDiT, MoDeVVa, MPM4CPS, MULTI, OCL};

set of int: DAY = 1..3;

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

array[WORKSHOP] of var DAY: allocation;

var int: satisfaction = sum(w in WORKSHOP)(preferences[w, allocation[w]]);

constraint allocation[MASE] != allocation[DevOps];
constraint allocation[DevOps] != allocation[MoDDiT];
constraint allocation[MPM4CPS] != allocation[MLE];
constraint allocation[MPM4CPS] != allocation[MoDeVVa];
constraint allocation[LowCode] != allocation[MULTI];
constraint allocation[LowCode] != allocation[MDEIntelligence];
constraint allocation[LowCode] != allocation[MoDDiT];
constraint allocation[MDEIntelligence] != allocation[MoDDiT];

var int: sundayWorkshops = count(allocation, 1);
var int: mondayWorkshops = count(allocation, 2);
var int: tuesdayWorkshops = count(allocation, 3);

constraint sundayWorkshops <= 4;
constraint mondayWorkshops <= 5;
constraint tuesdayWorkshops <= 3;

solve maximize satisfaction;

var float: satRatio = satisfaction/120*100;

output[
  "Satisfaction: \(satisfaction) (out of 120 -- \(satRatio)%).\n",
  "Allocation: \(allocation).\n",
  "Sunday workshops: \(sundayWorkshops).\n",
  "Monday workshops: \(mondayWorkshops).\n",
  "Tuesday workshops: \(tuesdayWorkshops).\n"
]