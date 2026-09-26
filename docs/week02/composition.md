# AFL 1 Structure Rationale — Week 02 Composition & State Hoisting

## Case Study: EcoHome Smart Hub & Energy Management Dashboard

The **EcoHome Smart Hub** primary screen is designed to give users centralized monitoring and control over smart devices in their home, real-time power consumption metrics, quick environment mode presets, and category-based filtering.

---

## State Hoisting Architecture

To maintain a clean unidirectional data flow and ensure optimal Flutter widget rebuilding performance, state is **hoisted to the parent container (`SmartHomeScreen`)**. 

### Hoisted State Variables:
1. `_devices`: Master list of `SmartDevice` domain models (contains device ID, name, room, icon, toggle state `isOn`, and power consumption in Watts).
2. `_activeMode`: Currently selected preset mode (`Home`, `Away`, `Night`, `Eco`).
3. `_selectedRoomCategory`: Currently active room filter (`All Rooms`, `Living Room`, `Kitchen`, `Bedroom`, `Office`).
4. `_searchQuery`: Search text entered by the user in the header search field.

The child widgets are pure **stateless presentation components**. They receive data via `final` parameters and emit user actions upward using callbacks (`onToggle`, `onModeSelected`, `onCategorySelected`, `onSearchChanged`, `onNotificationTap`).

---

## Extracted Widget Classes & Justifications

### 1. `HeaderGreeting` (`lib/widgets/header_greeting.dart`)
* **Trigger**: **Readability**
* **What it owns**: Top banner visual styling (background gradient/color, rounded bottom corners, SafeArea padding), user greeting layout, search text field visual configuration, and notification badge positioning.
* **What it reports upward**:
  * `onSearchChanged`: Emits updated `String` query whenever the user types into the search field.
  * `onNotificationTap`: Emits a `VoidCallback` event when the user taps the notification icon.

---

### 2. `StatMetricCard` (`lib/widgets/stat_metric_card.dart`)
* **Trigger**: **Reuse**
* **What it owns**: Visual layout of key numerical telemetry cards (icon, label, numeric value, unit text, tinted background container, and border decoration).
* **What it reports upward**:
  * `onTap` (optional): Emits a `VoidCallback` event if the metric card is tapped for deeper analytics.

---

### 3. `QuickModeSelector` (`lib/widgets/quick_mode_selector.dart`)
* **Trigger**: **Readability & Reuse**
* **What it owns**: Section title layout, horizontal scrolling list container (`ListView.separated`), chip shape, and selected/unselected visual highlight states (`ChoiceChip`).
* **What it reports upward**:
  * `onModeSelected`: Emits `ValueChanged<String>` reporting the newly selected preset mode string (e.g. `'Away'`, `'Eco'`) to trigger parent state updates.

---

### 4. `CategoryFilterTabs` (`lib/widgets/category_filter_tabs.dart`)
* **Trigger**: **Reuse & Readability**
* **What it owns**: Horizontal room navigation bar layout, active border highlight styling, and category tab padding.
* **What it reports upward**:
  * `onCategorySelected`: Emits `ValueChanged<String>` reporting the selected room category string (e.g., `'Living Room'`, `'Kitchen'`).

---

### 5. `DeviceControlTile` (`lib/widgets/device_control_tile.dart`)
* **Trigger**: **Reuse**
* **What it owns**: Individual device card presentation (device icon avatar, device label, room category label, power consumption wattage formatting, conditional color scheme for ON/OFF states, and switch widget UI).
* **What it reports upward**:
  * `onToggle`: Emits `ValueChanged<bool>` reporting the new boolean switch state (`true`/`false`) associated with the specific device ID.

---

## Widget Breakdown Matrix

| Widget Class | Trigger | What it Owns | What it Reports Upward |
| :--- | :--- | :--- | :--- |
| **`HeaderGreeting`** | Readability | Header layout, profile badge, search field styling | `onSearchChanged(String)`, `onNotificationTap()` |
| **`StatMetricCard`** | Reuse | Stat card visual design, icon, value & unit formatting | `onTap()` (optional) |
| **`QuickModeSelector`** | Readability & Reuse | Horizontal mode chip bar UI & active highlight style | `onModeSelected(String)` |
| **`CategoryFilterTabs`** | Reuse & Readability | Horizontal room filter tabs & selection border UI | `onCategorySelected(String)` |
| **`DeviceControlTile`** | Reuse | Device card styling, ON/OFF color state & switch UI | `onToggle(bool)` |

---

## Conclusion
By splitting the primary screen into five decoupled, single-responsibility widgets with hoisted state management, the codebase achieves high readability, modular reusability, strict adherence to Dart/Flutter linter rules, and effortless testability.
