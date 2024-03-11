import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:polygonal_draft/src/features/polygon/data/repositories/project_data_repository_impl.dart';

import '../../domain/providers/project_data_provider.dart';
import '../widgets/widgets.dart';

Logger logger = Logger();

class PolygonalDraft extends ConsumerStatefulWidget {
  const PolygonalDraft(this.pointer, {super.key});
  final ui.Image pointer;

  @override
  ConsumerState<PolygonalDraft> createState() => _PolygonalDraftState();
}

class _PolygonalDraftState extends ConsumerState<PolygonalDraft> {
  int changingPointIndex = -1;
  // final _debouncerTouch = Debouncer(milliseconds: 250);
  // final _debouncerMove = Debouncer(milliseconds: 100);

  void _onTapUp(
      TapUpDetails details, ProjectDataRepositoryImpl projectProvider) {
    if (projectProvider.points.length > 1 &&
        projectProvider.checkIntersection(
            projectProvider.points.length, details.localPosition)) {
      logger.e('intersection');
      projectProvider.intersectionAlarm();
      return;
    }
    if (projectProvider.currentState.isPolygonClosed) {
      logger.e('polygon closed');
      return;
    }
    if (projectProvider.whatPointIsNear(details.localPosition) == 0) {
      if (projectProvider.points.length == 1) {
        return;
      } else {
        projectProvider.setPolygonClosed();
        return;
      }
    }

    projectProvider.putPoint(details.localPosition);
  }

  void _onLongPressStart(LongPressStartDetails details,
      ProjectDataRepositoryImpl projectProvider) {
    setState(() {
      changingPointIndex =
          projectProvider.whatPointIsNear(details.localPosition);
    });
    if (changingPointIndex != -1) {
      projectProvider.changePointChoordsStart();
    }
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details,
      ProjectDataRepositoryImpl projectProvider) {
    if (changingPointIndex == projectProvider.points.length - 1 &&
        projectProvider.whatPointIsNear(details.localPosition,
                deviation: 2 * kTouchSlop) ==
            0) {
      projectProvider.gluing();
      return;
    }
    if (projectProvider.checkIntersection(
        changingPointIndex, details.localPosition)) {
      logger.e('intersection');
      projectProvider.intersectionAlarm();
      return;
    }
    if (changingPointIndex != -1) {
      projectProvider.changePointChoords(
          changingPointIndex, details.localPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = ref.watch(projectDataProvider);
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Positioned.fill(
            child: GestureDetector(
              child: CustomPaint(
                painter: PolygonPainter(
                    projectProvider, changingPointIndex, widget.pointer),
              ),
              onTapUp: (TapUpDetails details) {
                // _debouncerTouch.run(() {
                _onTapUp(details, projectProvider);
                // });
              },
              onLongPressStart: (LongPressStartDetails details) {
                _onLongPressStart(details, projectProvider);
              },
              onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
                // _debouncerMove.run(() {
                _onLongPressMoveUpdate(details, projectProvider);
                // });
              },
              onLongPressEnd: (LongPressEndDetails details) => setState(() {
                changingPointIndex = -1;
              }),
            ),
          ),
          Positioned(
              top: 16,
              left: 8,
              child: SwitchStateButtons(projectProvider: projectProvider)),
          Positioned(
            bottom: 34,
            left: 8,
            right: 8,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (projectProvider.currentState.isPolygonClosed)
                      ? const SizedBox()
                      : const Info(),
                  const SizedBox(
                    height: 8,
                  ),
                  Cancel(projectProvider: projectProvider),
                ]),
          )
        ]),
      ),
    );
  }
}
