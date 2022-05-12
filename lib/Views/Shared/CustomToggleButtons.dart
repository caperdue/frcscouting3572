import 'package:flutter/material.dart';
import 'package:frcscouting3572/Constants.dart';

class CustomToggleButtons extends StatefulWidget {
  final List<bool> buttonState;
  final List<Widget> buttons;
  final Function(int) onPressed;
  bool enabled;
  int value;

  CustomToggleButtons(
      {required this.buttonState,
      required this.buttons,
      required this.onPressed,
      required this.value,
      required this.enabled});

  @override
  State<CustomToggleButtons> createState() => _CustomToggleButtonsState();
}

class _CustomToggleButtonsState extends State<CustomToggleButtons> {
  @override
  void initState() {
    setSelectionToggle(widget.value);
    super.initState();
  }

  void setSelectionToggle(int selected) {
    for (int i = 0; i < widget.buttonState.length; i++) {
      widget.buttonState[i] = i == selected;
      widget.value = selected;
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
        if (widget.enabled) {
          setState(() {
            setSelectionToggle(index);
            widget.onPressed(index);
          });
        }
      },
    );
  }
}
