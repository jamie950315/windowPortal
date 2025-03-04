# windowPortal
Move and manage windows across monitors like magic

**windowPortal** is an AutoHotkey v1 script for multi-monitor window and cursor management. It allows you to seamlessly switch between different monitor modes by teleporting your cursor and moving windows from an ignored monitor to the active one.  

## Features

- **Monitor Mode Switching:**  
  Easily switch between modes (e.g., AB mode vs. AC mode) with hotkeys.  
- **Cursor Teleportation:**  
  When the cursor enters the region of the ignored monitor, it automatically teleports to the correct edge of the active monitor.  
- **Window Management:**  
  Windows (based on their center point) on the ignored monitor are moved to the active monitor while preserving their relative positions.
- **Customizable Layout:**  
  Adjust monitor indexes and timer delays to suit your specific multi-monitor setup.


## Usage Scenario

In modern workflows, many users utilize multiple monitors to boost productivity. However, switching between monitor configurations or dealing with windows appearing on the wrong screen can be disruptive. **windowPortal** addresses these issues by:

- **Automatically Relocating Your Cursor:**  
  If your cursor accidentally drifts into the inactive monitor's area, the script instantly teleports it back to the active monitor—keeping your workflow smooth.
- **Moving Windows to the Active Screen:**  
  When an application window appears on the ignored monitor, **windowPortal** automatically moves it to the active monitor. This ensures that no window gets “lost” off-screen.
- **Streamlining Monitor Setups:**  
  Whether you change between configurations frequently (e.g., switching GPU outputs or input sources) or simply want an organized desktop, this script helps maintain a tidy and efficient workspace.


## Requirements

- **AutoHotkey v1:**  
  This script is written using AutoHotkey v1 syntax.  
- **Windows OS:**  
  Designed for Windows environments with multiple monitors.

## Installation & Usage

1. **Download & Install AutoHotkey v1:**  
   [Download here](https://www.autohotkey.com/download/) if you haven't already.
2. **Clone or Download this Repository:**  
   ```bash
   git clone https://github.com/yourusername/windowPortal.git
   ```
3. **Configure Monitor Indexes:**  
   Open the script file and adjust the monitor indexes if needed:
   ```ahk
   A_monitor := 3  ; Monitor A
   B_monitor := 2  ; Monitor B
   C_monitor := 1  ; Monitor C
   ```
4. **Run the Script:**  
   Double-click the `.ahk` file to run it.
5. **Switch Modes:**  
   - Press `Ctrl + Win + Shift + B` to switch to **AB mode** (use Monitor A+B, ignore C).  
   - Press `Ctrl + Win + Shift + C` to switch to **AC mode** (use Monitor A+C, ignore B).

## Customization

- **Adjust Timer Delay:**  
  The script uses a timer (`MonitorMouse`) set to 30ms. You can modify this value if needed.
- **Cursor Position Logic:**  
  Modify the relative calculations in the script to suit your monitor layout or personal preferences.

## Contributing

Contributions, issues, and feature requests are welcome!  
Feel free to check the [issues page](https://github.com/yourusername/windowPortal/issues) if you want to contribute.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

*windowPortal* helps you manage your multi-monitor setup effortlessly by "teleporting" your cursor and windows between screens. Enjoy a smoother workflow!

