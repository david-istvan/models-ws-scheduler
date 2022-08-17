# MODELS Workshops Scheduler

Quick&dirty solver for the workshop allocation problem with (i) OC scheduling preferences, (ii) OC/audience overlaps, and (iii) room capacity considered.

- Run with `solve maximize GOAL;` first to find the maximal satisfaction score.
- Then run with `constraint satisfactionRatio >= [score]; %solve satisfy;` to generate all equally optimal schedules.

Power by [MiniZinc](https://www.minizinc.org/).
<img src="https://www.minizinc.org/MiniZn_logo.png" width="25">
