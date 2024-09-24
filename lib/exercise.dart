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
  double _lastNote = 0.0;

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
    print(event.name); // Access event name, e.g. NoteChosen

    // If an event has custom properties
    var note = event.properties['note'] as double;
    print(note); // Access event properties, e.g. numbers from -8 to 16

    // If a change has to be made to the UI
    // Schedule the setState for the next frame, as an event can be
    // triggered during a current frame update
    // This is recommended by the Rive docs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _lastNote = note;
      });
    });
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
