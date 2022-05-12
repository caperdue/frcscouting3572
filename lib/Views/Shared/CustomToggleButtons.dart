import 'package:flutter/material.dart';

class CustomToggleButtons extends StatefulWidget {
  final List<bool> buttonState;
  final List<Widget> buttons;
  final Function(int) onPressed;
  final bool initialEnabled;
  final int initialValue;

  CustomToggleButtons(
      {required this.buttonState,
      required this.buttons,
      required this.onPressed,
      required this.initialValue,
      required this.initialEnabled});

  @override
  State<CustomToggleButtons> createState() => _CustomToggleButtonsState();
}

class _CustomToggleButtonsState extends State<CustomToggleButtons> {
  late int value;
  late bool enabled;
  @override
  void initState() {
    this.value = widget.initialValue;
    this.enabled = widget.initialEnabled;
    this.setSelectionToggle(this.value);
    super.initState();
  }

  void setSelectionToggle(int selected) {
    for (int i = 0; i < widget.buttonState.length; i++) {
      widget.buttonState[i] = i == selected;
      this.value = selected;
    }
  }

  Widget build(BuildContext context) {
    return ToggleButtons(
      borderColor: Colors.white,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      disabledBorderColor: Colors.transparent,
      fillColor: Colors.blueGrey[50],
      children: widget.buttons,
      isSelected: widget.buttonState,
      borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
      onPressed: (int index) {
        if (this.enabled) {
          setState(() {
            setSelectionToggle(index);
            widget.onPressed(index);
          });
        }
      },
    );
  }
}
