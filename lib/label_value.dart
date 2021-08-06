import 'package:flutter/material.dart';

class LabelValue extends StatelessWidget {
  final String labelVal;
  final String value;

  LabelValue(this.labelVal, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(labelVal, style: TextStyle(color: Colors.grey)),
            Text(value, style: TextStyle(color: Colors.black)),
          ]),
    );
  }
}

class LabelIconVaccine extends StatelessWidget {
  final String labelVal;
  final String value;

  LabelIconVaccine(this.labelVal, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(labelVal, style: TextStyle(color: Colors.grey)),
            if (value == "1") Icon(Icons.check, color: Colors.green),
            if (value == "0") Icon(Icons.close, color: Colors.red)
          ]),
    );
  }
}

class LabelIconStatus extends StatelessWidget {
  final String labelVal;
  final String value;
  final String status;

  LabelIconStatus(this.labelVal, this.value, this.status);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(labelVal, style: TextStyle(color: Colors.grey)),
            if (status == "1") Icon(Icons.check, color: Colors.green),
            if (status == "2") Icon(Icons.check, color: Colors.yellow),
            if (status == "3") Icon(Icons.check, color: Colors.orange),
            if (status == "4") Icon(Icons.check, color: Colors.red),
            if (status == "5") Icon(Icons.close, color: Colors.red),
            Text(value, style: TextStyle(color: Colors.black)),
          ]),
    );
  }
}

class LabelCheckbox extends StatelessWidget {
  final String labelVal;
  final String checked;
  final void Function(String) onTap;

  LabelCheckbox(this.labelVal, this.onTap, this.checked);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(labelVal, style: TextStyle(color: Colors.grey)),
            Checkbox(
                value: checked == "1",
                onChanged: (newChecked) {
                  onTap((newChecked ?? false) ? "1" : "0");
                })
          ]),
    );
  }
}
