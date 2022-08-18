# MODELS Workshops Scheduler

Quick&dirty (Dijkstra-would-not-have-liked-it) solver for workshop allocation with (i) OC scheduling preferences, (ii) OC/audience overlaps, (iii) room capacity, and (iv) full-day/half-day preferences considered.

- Step 1: Maximize satisfaction.
- Step 2: Generate all allocations that meet the maximal satisfaction goal.


## Contents
- `modelsws-python.mzn` - Model file for Python-based execution.
- `modelsws-nopython.mzn` - Model file for manual execution.
- `ws2022.dzn` - Data file with the 2022 workshop preferences and resource constraints.

## Automated run via Python
- `pip install -r requirements.txt`
- `python runner.py`

## Manual run via MiniZinc IDE
- Run with `solve maximize GOAL;` first to find the maximal satisfaction score.
- Then run with `constraint satisfactionRatio >= [score]; %solve satisfy;` to generate all equally optimal schedules.

Power by [MiniZinc](https://www.minizinc.org/).
<img src="https://www.minizinc.org/MiniZn_logo.png" width="25">
