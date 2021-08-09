import 'package:cached_network_image/cached_network_image.dart';
import 'package:dump/screens/Drawer/drawer.dart';
import 'package:dump/screens/DriverMainPage/driverMainViewModel.dart';
import 'package:dump/widget/LoadingState.dart';
import 'package:latlng/latlng.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:map/map.dart';

class DriverHomeView extends StatefulWidget {
  const DriverHomeView({Key key}) : super(key: key);

  @override
  _DriverHomeViewState createState() => _DriverHomeViewState();
}

class _DriverHomeViewState extends State<DriverHomeView> {
  MapController controller = MapController(
    location: LatLng(0, 0),
  );

  void _gotoDefault(model) {
    model.liveLocationTracking();
    model.fetchResidentDetails();
    controller.center = model.liveLocation;
    // controller.center = LatLng(12.97623, 74.60529);
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

  Widget _buildMarkerWidget(Offset pos, Color color, model, String name) {
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy - 16,
      child: Column(
        children: [
          Container(
            height: 30.0,
            child: Text(name.isEmpty ? "Unknown" : name),
          ),
          Icon(
            Icons.location_on,
            color: color,
            size: 30.0,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DriverMainPageModel>.reactive(
        onModelReady: (model) {
          model.fetchResidentDetails();
          model.liveLocationTracking();
          controller.center = model.liveLocation;
          model.notifyListeners();
        },
        builder: (context, model, _) => Scaffold(
              appBar: AppBar(
                title: Text('Dump App '),
                actions: [
                  IconButton(
                    tooltip: 'Refresh',
                    onPressed: () {
                      model.fetchResidentDetails();
                      model.liveLocationTracking();
                    },
                    icon: Icon(Icons.refresh),
                  ),
                ],
              ),
              drawer: drawer(),
              body: model.isBusy
                  ? loadingState()
                  : Stack(children: [
                      RaisedButton(
                        onPressed: () {},
                        child: Text("Start Trip"),
                      ),
                      MapLayoutBuilder(
                        controller: controller,
                        builder: (context, transformer) {
                          final markerPositions = model.allMarkers
                              .map(transformer.fromLatLngToXYCoords)
                              .toList();

                          final markerWidgets = markerPositions.map((pos) =>
                              _buildMarkerWidget(
                                  pos, Colors.green, model, "Home"));

                          final centerLocation = transformer
                              .fromLatLngToXYCoords(model.liveLocation);

                          final centerMarkerWidget = _buildMarkerWidget(
                              centerLocation,
                              Colors.red,
                              model,
                              model.currentUser.name);

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
                                      final url =
                                          'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

                                      return CachedNetworkImage(
                                        imageUrl: url,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                  ...markerWidgets,
                                  centerMarkerWidget,
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ]),
              floatingActionButton: FloatingActionButton(
                onPressed: () => _gotoDefault(model),
                tooltip: 'My Location',
                child: Icon(Icons.my_location),
              ),
            ),
        viewModelBuilder: () => DriverMainPageModel());
  }
}
