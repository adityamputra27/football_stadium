import 'package:flutter/material.dart';

class CustomScrollBehaviour extends ScrollBehavior {
  Widget buildOversrollIndicator(
    BuildContext context,
    Widget child,
    Scrollable parent,
  ) {
    return child;
  }
}
