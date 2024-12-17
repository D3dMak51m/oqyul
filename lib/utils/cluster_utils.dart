import 'dart:ui' as ui;
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/marker_model.dart';

class MarkerWithScreenPos {
  final MarkerModel marker;
  final ScreenCoordinate screenPosition;

  MarkerWithScreenPos(this.marker, this.screenPosition);
}

LatLng calculateClusterCenter(List<MarkerWithScreenPos> cluster) {
  double latSum = 0;
  double lngSum = 0;
  for (var c in cluster) {
    latSum += c.marker.latitude;
    lngSum += c.marker.longitude;
  }
  return LatLng(latSum / cluster.length, lngSum / cluster.length);
}

List<List<MarkerWithScreenPos>> clusterMarkers(List<MarkerWithScreenPos> markers, double radius) {
  final clusters = <List<MarkerWithScreenPos>>[];
  final visited = <MarkerWithScreenPos>{};

  for (var m in markers) {
    if (visited.contains(m)) continue;

    List<MarkerWithScreenPos> cluster = [];
    cluster.add(m);
    visited.add(m);

    for (var other in markers) {
      if (!visited.contains(other)) {
        final dx = (m.screenPosition.x - other.screenPosition.x).abs();
        final dy = (m.screenPosition.y - other.screenPosition.y).abs();
        final dist = Math.sqrt(dx * dx + dy * dy);
        if (dist < radius) {
          cluster.add(other);
          visited.add(other);
        }
      }
    }

    clusters.add(cluster);
  }

  return clusters;
}

Future<BitmapDescriptor> createClusterBitmap(int count) async {
  final pictureRecorder = ui.PictureRecorder();
  final canvas = Canvas(pictureRecorder);

  const size = 100.0;
  const radius = size / 2;

  Paint circlePaint = Paint()..color = Colors.red;
  canvas.drawCircle(const Offset(radius, radius), radius, circlePaint);

  final text = count.toString();
  TextSpan span = TextSpan(
    style: const TextStyle(
      color: Colors.white,
      fontSize: 40,
      fontWeight: FontWeight.bold,
    ),
    text: text,
  );
  TextPainter tp =
  TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
  tp.layout();
  final textOffset = Offset((size - tp.width) / 2, (size - tp.height) / 2);
  tp.paint(canvas, textOffset);

  final image = await pictureRecorder.endRecording().toImage(size.toInt(), size.toInt());
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  final bytes = data!.buffer.asUint8List();

  return BitmapDescriptor.fromBytes(bytes);
}
