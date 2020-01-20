// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:digital_clock/background_controller.dart';
import 'package:digital_clock/datetime_utils.dart';
import 'package:digital_clock/tree_cotroller.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  List<PlantController> treeControllers = List();
  BackgroundController backgroundController;
  final int plantsCount = 4;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < plantsCount; i++) {
      treeControllers.add(PlantController());
    }
    backgroundController = BackgroundController(isNight());
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {

    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );

      backgroundController.isNight = isNight();
      var timeFormatter = getTimeDigits();
      for (int i = 0; i < plantsCount; i++) {
        treeControllers[i].counter = int.parse(timeFormatter[i]);
      }
    });
  }

  FlareActor _getFlareActorWidget(String artboard, FlareController controller) {
    return FlareActor(
      "assets/plant_clock_animations.flr",
      alignment: Alignment.center,
      fit: BoxFit.contain,
      artboard: artboard,
      controller: controller,
    );
  }

  List<Expanded> _getExpandedPlantsWidgets() {
    var plantsArtboards = [
      "two_leaves_plant_artboard",
      "nine_leaves_plant_artboard",
      "five_leaves_plant_artboard",
      "nine_leaves_plant_artboard"
    ];

    List<Expanded> expandedPlantsWidgets = List();
    for (int i = 0; i < plantsCount; i++) {
      expandedPlantsWidgets.add(Expanded(
          child: _getFlareActorWidget(plantsArtboards[i], treeControllers[i])));
    }
    return expandedPlantsWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey,
      body: new Stack(
        children: [
          Center(
              child:
              _getFlareActorWidget("sky_ground_artboard", backgroundController)
          ),
          Row(
              children: _getExpandedPlantsWidgets()
          ),
        ],
      ),
    );
  }
}
