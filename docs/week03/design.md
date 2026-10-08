# Week 03: Theme, Hierarchy, and Component Audit

The EcoHome Smart Hub uses a leaf-green seed because household users need to understand energy use and make lower-impact choices quickly; green gives the control surface a familiar cue for efficient, healthy home management, while a restrained amber accent calls attention to energy-related signals without competing with the readings. The most important element on the primary screen is current power consumption, so it now leads the metrics row in the primary color role with a larger value type scale, while active-device count remains clearly readable in a supporting container. The before and after captures show this hierarchy pass.

## Hierarchy captures

- Before: [before.png](before.png)
- After: [after.png](after.png)

## Component audit

- Replaced the hand-built room filter tabs (`GestureDetector` and decorated `Container`) with Material `ChoiceChip` controls; quick modes already used `ChoiceChip`.
- Replaced the metric and device-tile surface containers with Material `Card`; the metric card uses `InkWell` for its optional tap behavior.
- Replaced the positioned notification counter with Material `Badge`; the action uses Material `IconButton`, and its feedback already uses Material `SnackBar`.
- No custom dialog or toast was present to replace.