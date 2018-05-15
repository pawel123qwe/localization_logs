### Before using this script
1. Unlock all safety in a car so that vehicle can move.
2. Connect USB cable with ROS label.
3. Check COM port and update it in Trigger class in trigger_log.py script.
4. Run script by double click or from terminal.

### Description of .csv file
For sequence of commands use "input.csv" file. Separate steering wheel, throttle and brake command by start and end flags:
- t1, t2 - throttle start and end flags,
- s1, s2 - steering wheel start and end flags,
- b1, b2 - brake start and end flags.
There is no specific order of type of commands so brake command can be before or after of throttle command etc. **Remember** that flag with numer 1 has to be before flag with number 2 of the same type **(b1 has to be before b2)**

### Usage of script
When open, script will prompt with list of possible commands to run:
- 0 - Throttle,
- 1 - Multiple throttle,
- 2 - Steering wheel,
- 3 - Multiple steering wheel,
- 4 - Brake (not included in ROS CMD),
- 5 - Multiple brake (not included in ROS CMD),
- 0 - Stop,
Every "multiple" command runs values from "input.csv" file. For switching to another command in sequence press Ctrl + C. Others options after choose will prompt you to enter proper value and affirm by pressing Enter.

### Frame send to STM
- '2' - for STM to recognize type of frame
- steering wheel high byte,
- steering wheel low byte,
- throttle high byte,
- throttle low byte,
- uart state - for purposes of this script 'automatic' (1) value should be send,
- EVE control register - to enable car send 0b00000010 (2 decimal) value.