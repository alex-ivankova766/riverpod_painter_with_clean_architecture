import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../data/repositories/project_data_repository_impl.dart';
import '../../domain/entities/point.dart';
import 'consts.dart';

class PolygonPainter extends CustomPainter {
  PolygonPainter(this.projectProvider, this.changingPointIndex, this.image);
  final ProjectDataRepositoryImpl projectProvider;
  final int changingPointIndex;
  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = BACKGROUND_COLOR;
    canvas.drawRect(
        Rect.fromPoints(Offset.zero, Offset(size.width, size.height)), paint);
    dotsPaint(canvas, size);
    if (projectProvider.isPolygonClosed) {
      fill(canvas, size);
    }
    sidesPaint(canvas, size);
    vertexPaint(canvas, size);
    pointerPaint(canvas, size);
    textPaint(canvas, size);
  }

  void dotsPaint(Canvas canvas, Size size) {
    double unit = size.width / MARKING_FREQUENCY;
    int verticalUnitsCount = size.height ~/ unit;
    Paint dotsPaint = Paint();
    dotsPaint.color = DOTS_COLOR;
    dotsPaint.strokeWidth = 1;
    dotsPaint.style = PaintingStyle.fill;
    for (int row = 0; row < verticalUnitsCount; row++) {
      for (int col = 0; col < 15; col++) {
        double x = col * unit + unit / 2;
        double y = row * unit + unit / 2;
        canvas.drawCircle(Offset(x, y), DOT_RADIUS, dotsPaint);
      }
    }
  }

  void pointerPaint(Canvas canvas, Size size) {
    if (projectProvider.currentState.points.isEmpty ||
        projectProvider.isPolygonClosed) {
      return;
    }
    double unit = size.width / 15;
    double imageWidth = image.width.toDouble();
    double imageHeight = image.height.toDouble();
    double scaledWidth = unit * POINTER_SCALE_ABOUT_UNIT;
    double scaledHeight = unit * POINTER_SCALE_ABOUT_UNIT;
    Rect sourceRect =
        Rect.fromPoints(Offset.zero, Offset(imageWidth, imageHeight));
    Rect destRect = Rect.fromCenter(
        center: (changingPointIndex != -1)
            ? projectProvider.currentState.points[changingPointIndex].toOffset()
            : projectProvider.currentState.points.last.toOffset(),
        width: scaledWidth,
        height: scaledHeight);
    canvas.drawImageRect(image, sourceRect, destRect, Paint());
  }

  void vertexPaint(Canvas canvas, Size size) {
    double unit = size.width / 15;
    Paint vertexPaint = Paint();
    Paint counturPaint = Paint();
    if (projectProvider.isPolygonClosed) {
      counturPaint.color = POLYGON_VERTEX_COUNTUR;
      vertexPaint.color = WHITE_COLOR;
    } else {
      counturPaint.color = WHITE_COLOR;
      vertexPaint.color = VERTEX_COLOR;
    }
    double counturVertexCircleRadius = projectProvider.isPolygonClosed
        ? INSIDE_POLYGON_VERTEX_SCALE_ABOUT_UNIT
        : INSIDE_VERTEX_SCALE_ABOUT_UNIT;

    for (Point point in projectProvider.points) {
      canvas.drawCircle(point.toOffset(),
          unit / OUTSIDE_VERTEX_SCALE_ABOUT_UNIT, counturPaint);
      canvas.drawCircle(
          point.toOffset(), unit / counturVertexCircleRadius, vertexPaint);
    }
  }

  void sidesPaint(Canvas canvas, Size size) {
    if (projectProvider.points.length < 2) {
      return;
    }
    Paint sidePaint = Paint();
    sidePaint.color = projectProvider.currentState.isIntersectionCatched
        ? ATTENTION_SIDES_COLOR
        : SIDES_COLOR;
    sidePaint.strokeWidth = 8;
    sidePaint.style = PaintingStyle.fill;

    for (int pointIndex = 0;
        pointIndex < projectProvider.points.length;
        pointIndex++) {
      if (pointIndex == projectProvider.points.length - 1) {
        continue;
      }
      canvas.drawLine(projectProvider.points[pointIndex].toOffset(),
          projectProvider.points[pointIndex + 1].toOffset(), sidePaint);
    }
    if (projectProvider.isPolygonClosed) {
      canvas.drawLine(projectProvider.points.first.toOffset(),
          projectProvider.points.last.toOffset(), sidePaint);
    }
  }

  void fill(Canvas canvas, Size size) {
    Path path = Path();
    if (projectProvider.points.isNotEmpty) {
      path.moveTo(projectProvider.points[0].dx, projectProvider.points[0].dy);
      for (int i = 1; i < projectProvider.points.length; i++) {
        path.lineTo(projectProvider.points[i].dx, projectProvider.points[i].dy);
      }
      path.close();
    }
    Paint fillPaint = Paint()
      ..color = WHITE_COLOR
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);
  }

  bool isClockwise(Point a, Point b, Point c) {
    double crossProduct =
        (b.dx - a.dx) * (c.dy - b.dy) - (b.dy - a.dy) * (c.dx - b.dx);
    return crossProduct < 0;
  }

  void rotateCanvas(Canvas canvas, Size size, double midPointX,
      double midPointY, double rotationAngle) {
    canvas.save();
    canvas.translate(midPointX, midPointY);
    canvas.rotate(rotationAngle);
    canvas.translate(-midPointX, -midPointY);
  }

  void writeText(Canvas canvas, Size size, TextPainter textPainter,
      double distance, double midPointX, double midPointY, double deviation) {
    textPainter.text = TextSpan(
      text: distance.toStringAsFixed(2),
      style: const TextStyle(
        fontFamily: 'SF-Pro',
        color: TEXT_COLOR,
        fontSize: 11,
      ),
    );
    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(midPointX - textPainter.width / 2,
          midPointY - textPainter.height / 2 - deviation),
    );
  }

  void textPaint(Canvas canvas, Size size) {
    double unit = size.width / MARKING_FREQUENCY;
    if (!projectProvider.isPolygonClosed || projectProvider.points.isEmpty) {
      return;
    }
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    double deviation = isClockwise(projectProvider.points[0],
            projectProvider.points[1], projectProvider.points[2])
        ? -10
        : 10;

    for (int index = 0; index < projectProvider.points.length; index++) {
      final Point currentPoint = projectProvider.points[index];
      final Point nextPoint = (index == projectProvider.points.length - 1)
          ? projectProvider.points.first
          : projectProvider.points[index + 1];
      final double midPointX = (currentPoint.dx + nextPoint.dx) / 2;
      final double midPointY = (currentPoint.dy + nextPoint.dy) / 2;

      final double dx = nextPoint.dx - currentPoint.dx;
      final double dy = nextPoint.dy - currentPoint.dy;

      double rotationAngle = atan2(dy, dx);
      double distance = getDistance(currentPoint, nextPoint, unit);
      rotateCanvas(canvas, size, midPointX, midPointY, rotationAngle);
      writeText(
          canvas, size, textPainter, distance, midPointX, midPointY, deviation);
      canvas.restore();
    }
  }

  double getDistance(Point point1, Point point2, double unit) {
    return sqrt(pow(point1.dx - point2.dx, 2) + pow(point1.dy - point2.dy, 2)) /
        (2 * unit);
  }

  @override
  bool shouldRepaint(PolygonPainter oldDelegate) {
    return true;
  }
}
