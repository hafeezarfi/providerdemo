## Getting Started

Illustrating provider in less ui way.

# Project Structure

Whole stateless app with state change can be achieved by using <b>InheritedWidgets, ChangeNotifiers</b> without using provider instead using custom Listenable. In small scale it's good.
But time consuming at medium or large scale.

The applet shows the use of <b>read\<T\>()</b> method which gets the value of T from nearest or specified provider

- lib
  - main.dart

# Dependencies

- provider
- uuid

# Key Points

- Uuid to override the equality operator
- ChangeNotifier


