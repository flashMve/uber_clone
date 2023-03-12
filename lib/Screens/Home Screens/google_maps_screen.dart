import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_rider_app/Global/constants.dart';

class GoogleMapScreen extends StatefulWidget {
  static const String routeName = '/google_map_screen';
  const GoogleMapScreen({
    Key? key,
    required Completer<GoogleMapController> controller,
  })  : _controller = controller,
        super(key: key);
  final Completer<GoogleMapController> _controller;

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  CameraPosition defaultCameraPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  getCurrentLocation() async {
    final status = await GeolocatorPlatform.instance.checkPermission();

    if (status == LocationPermission.always ||
        status == LocationPermission.whileInUse) {
      await getLocation();
    } else {
      final status = await GeolocatorPlatform.instance.requestPermission();
      if (status == LocationPermission.always ||
          status == LocationPermission.whileInUse) {
        await getLocation();
      } else if (status == LocationPermission.denied ||
          status == LocationPermission.deniedForever) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Location Permission Denied'),
            content: const Text(
                'Please enable location permission. So the App can use your location'),
            actions: <Widget>[
              TextButton(
                child: const Text('Open Settings'),
                onPressed: () {
                  pop(context);
                  GeolocatorPlatform.instance.openAppSettings();
                },
              ),
            ],
          ),
        );
      }
    }
  }

  getLocation() async {
    final CameraPosition cameraPosition =
        getAddressProvider(context).getDefaultCameraPosition;
    widget._controller.future.then((controller) {
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      getAddressProvider(context)
          .getAddressFromLatLng(LatLng(
              cameraPosition.target.latitude, cameraPosition.target.longitude))
          .then((address) {
        getAddressProvider(context).addPickUpAddress(address);
        getRiderRequest(context).initGeoFire();
      });
    });
    setState(() {
      defaultCameraPosition = cameraPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<Polyline>>(
        valueListenable: getAddressProvider(context).getPolylinesNotifier,
        builder: (ctx, polylines, __) {
          return ValueListenableBuilder<Set<Marker>>(
              valueListenable:
                  getAddressProvider(context).getDriverMarkersNotifier,
              builder: (ctx, driverMarkers, __) {
                log("Drivers Available ${driverMarkers.length}");
                return ValueListenableBuilder<Set<Marker>>(
                    valueListenable:
                        getAddressProvider(context).getMarkersNotifier,
                    builder: (ctx, markers, __) {
                      return GoogleMap(
                        trafficEnabled: false,
                        padding: EdgeInsets.only(
                            bottom: markers.isNotEmpty ? 30 : 30),
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        zoomGesturesEnabled: true,
                        compassEnabled: false,
                        mapToolbarEnabled: false,
                        polylines: {if (polylines.isNotEmpty) ...polylines},
                        mapType: MapType.normal,
                        markers: {
                          if (markers.isNotEmpty) ...markers,
                          if (driverMarkers.isNotEmpty) ...driverMarkers
                        },
                        gestureRecognizers: <
                            Factory<OneSequenceGestureRecognizer>>{
                          Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer(),
                          ),
                        },
                        onCameraMove: (pos) {
                          getAddressProvider(context)
                              .getCustomInfoWindowController
                              .onCameraMove!();
                        },
                        initialCameraPosition: defaultCameraPosition,
                        onMapCreated: (GoogleMapController controller) {
                          widget._controller.complete(controller);
                          widget._controller.future.then((controller) {
                            controller.setMapStyle(MAP_STYLE);
                          });
                          getAddressProvider(context)
                              .getCustomInfoWindowController
                              .googleMapController = controller;
                          getCurrentLocation();
                        },
                      );
                    });
              });
        });
  }
}
