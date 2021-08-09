import 'package:dump/screens/ResidentHomeView/ResidentHomeView.dart';
import 'package:dump/screens/ResidentLocation/ResidentLocationViewModel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

class ResidentLocation extends StatefulWidget {
  @override
  _ResidentLocationState createState() => _ResidentLocationState();
}

class _ResidentLocationState extends State<ResidentLocation> {
  final controller = MapController(
    location: LatLng(0.0, 0.0),
  );

  void _gotoDefault(model) {
    controller.center = model.myLocation;
    setState(() {});
  }

  void _onDoubleTap() {
    controller.zoom += 0.5;
    setState(() {});
  }

  Offset _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart;
      _dragStart = now;
      controller.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  Widget _buildMarkerWidget(Offset pos, Color color) {
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy - 16,
      width: 24,
      height: 24,
      child: Icon(Icons.location_on, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ResidentLocationViewModel>.reactive(
        disposeViewModel: false,
        onModelReady: (model) {
          controller.center = model.myLocation;
          model.notifyListeners();
        },
        builder: (context, model, _) => Scaffold(
              body: model.currentUser.lat == 0.01 ||
                      model.currentUser.lat == null
                  ? setLocation(context, model)
                  : MapLayoutBuilder(
                      controller: controller,
                      builder: (context, transformer) {
                        final markerPositions = markers
                            .map(transformer.fromLatLngToXYCoords)
                            .toList();

                        final markerWidgets = markerPositions.map(
                          (pos) => _buildMarkerWidget(pos, Colors.red),
                        );

                        final centerLocation =
                            transformer.fromLatLngToXYCoords(model.myLocation);

                        final centerMarkerWidget =
                            _buildMarkerWidget(centerLocation, Colors.purple);

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onDoubleTap: _onDoubleTap,
                          onScaleStart: _onScaleStart,
                          onScaleUpdate: _onScaleUpdate,
                          onTapUp: (details) {
                            final location = transformer
                                .fromXYCoordsToLatLng(details.localPosition);

                            final clicked =
                                transformer.fromLatLngToXYCoords(location);

                            print(
                                '${location.longitude}, ${location.latitude}');
                            print('${clicked.dx}, ${clicked.dy}');
                            print(
                                '${details.localPosition.dx}, ${details.localPosition.dy}');
                          },
                          child: Listener(
                            behavior: HitTestBehavior.opaque,
                            onPointerSignal: (event) {
                              if (event is PointerScrollEvent) {
                                final delta = event.scrollDelta;

                                controller.zoom -= delta.dy / 1000.0;
                                setState(() {});
                              }
                            },
                            child: Stack(
                              children: [
                                Map(
                                  controller: controller,
                                  builder: (context, x, y, z) {
                                    //Legal notice: This url is only used for demo and educational purposes. You need a license key for production use.

                                    //Google Maps
                                    final url =
                                        'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

                                    return CachedNetworkImage(
                                      imageUrl: url,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                                // homeMarkerWidget,
                                ...markerWidgets,
                                centerMarkerWidget,
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => _gotoDefault(model),
                // onPressed: () => model.showNotificaiton(),
                tooltip: 'My Location',
                child: Icon(Icons.my_location),
              ),
            ),
        viewModelBuilder: () => ResidentLocationViewModel());
  }
}

Widget setLocation(context, model) {
  return Center(
    child: ElevatedButton(
      child: Text('Set Location'),
      onPressed: () {
        model.getCurrentLocationAndUpdate(context);
      },
    ),
  );
}
