import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveExercise extends StatefulWidget {
  const RiveExercise({super.key});

  @override
  State<RiveExercise> createState() => _RiveExerciseState();
}

class _RiveExerciseState extends State<RiveExercise> {
  double _verticalSwipeDistance = 0.0;
  double _lastXSwipe = 0.0;
  SMITrigger? _sweepDown;
  SMITrigger? _sweepUp;

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _verticalSwipeDistance += details.delta.dy;
      _lastXSwipe = details.localPosition.dx;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_lastXSwipe > 250) {
      _verticalSwipeDistance = 0.0;
      return;
    }

    if (_verticalSwipeDistance > 0) {
      // User swiped down
      print("Swiped Down");
      _sweepDown?.fire();
    } else if (_verticalSwipeDistance < 0) {
      // User swiped up
      print("Swiped Up");
      _sweepUp?.fire();
    }
    // Reset the swipe distance
    _verticalSwipeDistance = 0.0;
  }

  void _onInit(Artboard artboard) {
    var controller = StateMachineController.fromArtboard(artboard, "Exercise")
        as StateMachineController;
    controller.addEventListener(onRiveEvent);
    artboard.addController(controller);
    _sweepDown = controller.findInput<bool>("sweepDown") as SMITrigger;
    _sweepUp = controller.findInput<bool>("sweepUp") as SMITrigger;
  }

  void onRiveEvent(RiveEvent event) {
    print(event);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      child: RiveAnimation.asset(
        'assets/1_1_toene_notieren.riv',
        fit: BoxFit.contain,
        artboard: "Render",
        onInit: _onInit,
      ),
    );
  }
}
