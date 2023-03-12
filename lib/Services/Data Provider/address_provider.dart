import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:uber_rider_app/Models/predictions.dart';
import 'package:uber_rider_app/Services/Data%20Provider/request_assist.dart';

import '../../Global/config.dart';
import '../../Models/address.dart';
import '../../Models/directions.dart';
import '../../Widgets/custom_info_window.dart';

class AddressProvider with ChangeNotifier {
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  final googlePlace = GooglePlace(GOOGLE_MAP_API_KEY,
      proxyUrl: 'https://localhost:5000',
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD"
      });

  String? country = '';
  ValueNotifier<AddressModel?> pickupAddress = ValueNotifier(null);
  ValueNotifier<AddressModel?> dropoffAddress = ValueNotifier(null);
  ValueNotifier<Directions?> directions = ValueNotifier(null);
  ValueNotifier<List<Predictions>?> searchResults =
      ValueNotifier<List<Predictions>?>([]);
  ValueNotifier<bool> isAddressSet = ValueNotifier<bool>(false);
  final ValueNotifier<Set<Polyline>> _polylines =
      ValueNotifier<Set<Polyline>>({});
  final ValueNotifier<BitmapDescriptor?> _mapIconBlack = ValueNotifier(null);
  final ValueNotifier<BitmapDescriptor?> _mapIconBlue = ValueNotifier(null);
  final ValueNotifier<BitmapDescriptor?> _carMapIcon = ValueNotifier(null);
  final ValueNotifier<Set<Marker>> _markers = ValueNotifier<Set<Marker>>({});
  final ValueNotifier<Set<Marker>> _driverMarkers =
      ValueNotifier<Set<Marker>>({});
  CameraPosition _defaultCameraPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  ValueNotifier<AddressModel?> get getPickupAddressNotifier => pickupAddress;
  ValueNotifier<AddressModel?> get getDropoffAddressNotifier => dropoffAddress;
  ValueNotifier<Directions?> get getDirectionsNotifier => directions;
  ValueNotifier<List<Predictions>?> get getSearchResultsNotifier =>
      searchResults;

  CustomInfoWindowController get getCustomInfoWindowController =>
      _customInfoWindowController;
  CameraPosition get getDefaultCameraPosition => _defaultCameraPosition;

  ValueNotifier<Set<Polyline>> get getPolylinesNotifier => _polylines;
  ValueNotifier<Set<Marker>> get getMarkersNotifier => _markers;
  ValueNotifier<Set<Marker>> get getDriverMarkersNotifier => _driverMarkers;

  clearDriveMarker() {
    _driverMarkers.value = {};
    _driverMarkers.notifyListeners();
  }

  void setMarker({
    required LatLng pos,
    required String markerId,
    Function? onTap,
    bool isDriver = false,
    BitmapDescriptor? icon,
  }) {
    _addMarker(
      position: pos,
      markerId: markerId,
      onTap: onTap,
      isDriver: isDriver,
      icon: icon,
    );
    log("Marker Set");
  }

  ValueNotifier<bool> get getIsAddressSetNotifier => isAddressSet;

  AddressProvider() {
    getIcon();
    getLocation();
  }

  Future<bool> addPickUpAddress(AddressModel address) async {
    if (address.address == null) {
      pickupAddress.value = await getPlaceDetail(address.placeid!);
    } else {
      pickupAddress.value = address;
    }
    checkIfAddressIsSet();
    notifyListeners();
    return true;
  }

  Future<AddressModel> getAddressFromLatLng(LatLng position) async {
    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
        googleMapApiKey: GOOGLE_MAP_API_KEY);
    country = data.countryCode;
    log(data.countryCode);
    return AddressModel(
      address: data.address,
      lat: data.latitude,
      lng: data.longitude,
      placeid: "${data.latitude + data.longitude}",
    );
  }

  void searchAddress(String search) async {
    try {
      List<Predictions> temp = [];
      if (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS) {
        AutocompleteResponse? result =
            await googlePlace.autocomplete.get(search);

        if (result != null && result.status == "OK") {
          for (var result in result.predictions!) {
            temp.add(Predictions(
              placeId: result.placeId!,
              mainText: result.structuredFormatting!.mainText!,
              secondaryText: result.structuredFormatting!.secondaryText!,
            ));
          }
        }
      } else {
        final suggestions = await fetchSuggestionsWeb(search);
        temp = suggestions;
      }
      searchResults.value = temp;
      notifyListeners();
    } catch (e) {
      log("SearchAddress $e");
    }
  }

  Future<List<Predictions>> fetchSuggestionsWeb(String input) async {
    log("$country");
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&components=country:${country?.toLowerCase()}&key=$GOOGLE_MAP_API_KEY';
    var response = await http.get(Uri.parse(url), headers: {
      'Access-Control-Allow-Origin': '*',
    });

    if (response.statusCode == 200) {
      final data = response.body;
      final result = json.decode(data);

      print(result);

      if (result['status'] == 'OK') {
        return result['predictions']
            .map<Predictions>(
              (p) => Predictions(
                placeId: p['place_id'],
                secondaryText: p['structured_formatting']['secondary_text'],
                mainText: p['structured_formatting']['main_text'],
              ),
            )
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<AddressModel> getPlaceDetailFromId(String placeId) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=formatted_address,name,geometry/location&key=$GOOGLE_MAP_API_KEY';
    var response = await http.get(Uri.parse(url), headers: {
      'Access-Control-Allow-Origin': '*',
    });

    if (response.statusCode == 200) {
      final data = response.body;
      final result = json.decode(data);
      log('getPlaceDetailFromId $result');

      if (result['status'] == 'OK') {
        // build result
        final place = AddressModel();
        place.address = result['result']['formatted_address'];
        place.lat = result['result']['geometry']['location']['lat'];
        place.lng = result['result']['geometry']['location']['lng'];
        place.id = result['place_id'];
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  getCurrentLocation() async {
    final position = await GeolocatorPlatform.instance.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      ),
    );
    final CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14.4746,
    );

    _defaultCameraPosition = cameraPosition;

    notifyListeners();
  }

  bool isPickupAddressSet() {
    return pickupAddress.value != null;
  }

  bool isDropoffAddressSet() {
    return dropoffAddress.value != null;
  }

  Future<AddressModel?> getPlaceDetail(String placeId) async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      var googlePlace = GooglePlace(GOOGLE_MAP_API_KEY);
      DetailsResponse? detail = await googlePlace.details.get(placeId);
      return AddressModel(
        address: detail!.result!.formattedAddress!,
        lat: detail.result!.geometry!.location!.lat!,
        lng: detail.result!.geometry!.location!.lng!,
        placeid: detail.result!.placeId!,
      );
    } else {
      final AddressModel address = await getPlaceDetailFromId(placeId);
      return address;
    }
  }

  Future<void> getLocation() async {
    final status = await GeolocatorPlatform.instance.checkPermission();

    if (status == LocationPermission.always ||
        status == LocationPermission.whileInUse) {
      await getCurrentLocation();
    } else {
      final status = await GeolocatorPlatform.instance.requestPermission();
      if (status == LocationPermission.always ||
          status == LocationPermission.whileInUse) {
        await getCurrentLocation();
      } else if (status == LocationPermission.denied ||
          status == LocationPermission.deniedForever) {
        GeolocatorPlatform.instance.openAppSettings();
      }
    }
  }

  checkIfAddressIsSet() {
    isAddressSet.value = isPickupAddressSet() && isDropoffAddressSet();
    drawPolyLine();
  }

  clearPickUpAddress() {
    pickupAddress.value = null;
    isAddressSet.value = false;
    notifyListeners();
  }

  clearDropoffAddress() {
    dropoffAddress.value = null;
    isAddressSet.value = false;

    notifyListeners();
  }

  void drawPolyLine() async {
    final pick = getPickupAddressNotifier.value;
    final drop = getDropoffAddressNotifier.value;
    if (pick != null && drop != null) {
      final pickLatLng = LatLng(pick.lat!, pick.lng!);
      final dropLatLng = LatLng(drop.lat!, drop.lng!);
      final Directions? direction =
          await getDirection(pickUp: pickLatLng, dropOff: dropLatLng);
      directions.value = direction;
      _addMarker(
        position: pickLatLng,
        markerId: "Pick Up",
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
              InfoWindowsCustom(time: "Now", address: pick.address),
              pickLatLng);
        },
        icon: _mapIconBlue.value!,
      );

      _addMarker(
        position: dropLatLng,
        markerId: "Drop Off",
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
              InfoWindowsCustom(
                  time: direction!.duration, address: drop.address),
              dropLatLng);
        },
        icon: _mapIconBlack.value!,
      );

      _customInfoWindowController.googleMapController!.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(pick.lat!, pick.lng!),
            zoom: 13.5,
          ),
        ),
      );
      if (_polylines.value.isNotEmpty) {
        _polylines.value.clear();
      }
      _polylines.value.add(
        Polyline(
          zIndex: 1000,
          polylineId: const PolylineId("Ride Poly Line"),
          visible: true,
          jointType: JointType.round,
          points: direction!.points!
              .map((e) => LatLng(e.latitude, e.longitude))
              .toList(),
          width: 6,
          patterns: [PatternItem.dash(30), PatternItem.gap(0)],
          color: Colors.blue,
        ),
      );
    }
  }

  Future<Directions?> getDirection(
      {required LatLng pickUp, required LatLng dropOff}) async {
    try {
      final response = await RequestAssistent.get(
          url:
              '''https://maps.googleapis.com/maps/api/directions/json?origin=${pickUp.latitude},${pickUp.longitude}&destination=${dropOff.latitude},${dropOff.longitude}&key=$GOOGLE_MAP_API_KEY''');

      if (response["status"] == RequestAssistStatus.success) {
        return Directions.fromMap(response["data"]);
      } else {
        return null;
      }
    } catch (e) {
      log('Get Directions $e');
    }
    return null;
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.fromList(img), (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  Future<Uint8List> getBytesFromCanvas(int width, int height, urlAsset) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final ByteData datai = await rootBundle.load(urlAsset);
    var imaged = await loadImage(Uint8List.view(datai.buffer));
    canvas.drawImageRect(
      imaged,
      Rect.fromLTRB(
          0.0, 0.0, imaged.width.toDouble(), imaged.height.toDouble()),
      Rect.fromLTRB(0.0, 0.0, width.toDouble(), height.toDouble()),
      Paint(),
    );

    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  getIcon() async {
    _mapIconBlack.value = BitmapDescriptor.fromBytes(
        await getBytesFromCanvas(55, 55, "assets/images/map_icon_black.png"));
    _mapIconBlue.value = BitmapDescriptor.fromBytes(
        await getBytesFromCanvas(55, 55, "assets/images/map_icon_blue.png"));
    _carMapIcon.value = BitmapDescriptor.fromBytes(
        await getBytesFromCanvas(55, 100, "assets/images/car.png"));
  }

  void _addMarker({
    required LatLng position,
    required String markerId,
    Function? onTap,
    bool isDriver = false,
    BitmapDescriptor? icon,
  }) {
    getIcon();
    LatLng newMarkerPosition = LatLng(
      position.latitude,
      position.longitude,
    );

    if (isDriver) {
      if (_driverMarkers.value.isNotEmpty) {
        // Marker? m = _driverMarkers.value.firstWhere(
        //   (p) => p.markerId == MarkerId(markerId),
        //   orElse: () => const Marker(markerId: MarkerId("")),
        // );
        // if (m.markerId.value.isNotEmpty) {
        //   log("Removed this");
        //   _driverMarkers.value.remove(m);
        // }
        _driverMarkers.value.clear();
      }
      log("Drivers ${_driverMarkers.value.length.toString()}");
      _driverMarkers.value.add(
        Marker(
          icon: _carMapIcon.value!,
          markerId: MarkerId(markerId),
          anchor: const Offset(0.5, 1),
          onTap: () {
            if (onTap != null) {
              onTap();
            }
          },
          infoWindow: const InfoWindow(
            title: "Driver",
          ),
          zIndex: 1000,
          visible: true,
          position: newMarkerPosition,
          draggable: false,
        ),
      );
      _driverMarkers.notifyListeners();
    } else {
      if (_markers.value.isNotEmpty) {
        Marker? m = _markers.value.firstWhere(
          (p) => p.markerId == MarkerId(markerId),
          orElse: () => const Marker(markerId: MarkerId("")),
        );
        if (m.markerId.value.isNotEmpty) {
          _markers.value.remove(m);
        }
      }

      _markers.value.add(
        Marker(
          icon: icon ?? _mapIconBlue.value!,
          markerId: MarkerId(markerId),
          anchor: const Offset(0.5, 1),
          onTap: () {
            if (onTap != null) {
              onTap();
            }
          },
          zIndex: 1000,
          visible: true,
          position: newMarkerPosition,
          draggable: false,
        ),
      );
      _markers.notifyListeners();
    }
    notifyListeners();
  }

  Future<bool> addDestinationAddress(AddressModel address) async {
    if (address.address == null) {
      dropoffAddress.value = await getPlaceDetail(address.placeid!);
    } else {
      dropoffAddress.value = address;
    }
    checkIfAddressIsSet();
    notifyListeners();
    return true;
  }

  void clearAddresses() {
    pickupAddress.value = null;
    dropoffAddress.value = null;
    isAddressSet.value = false;
    directions.value = null;
    _polylines.value.clear();
    _markers.value.clear();
    _driverMarkers.value.clear();
    getLocation().then((value) async {
      _customInfoWindowController.googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(_defaultCameraPosition),
      );
      final pickUpAddress = await getAddressFromLatLng(
        LatLng(_defaultCameraPosition.target.latitude,
            _defaultCameraPosition.target.longitude),
      );
      addPickUpAddress(pickUpAddress);
    });

    notifyListeners();
  }

  void clearSearchResults() {
    searchResults.value = null;
    notifyListeners();
  }
}
