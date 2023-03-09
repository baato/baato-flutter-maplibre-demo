import 'dart:typed_data';

import 'package:baato_api/baato_api.dart';
import 'package:baato_api/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maplibre_gl/mapbox_gl.dart';

class BaatoLocationPickerExample extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Baato Location Picker Example"),
        backgroundColor: Color.fromRGBO(8, 30, 42, 50),
      ),
      body: BaatoReversePage(),
    );
  }
}

class BaatoReversePage extends StatefulWidget {
  @override
  _BaatoReversePageState createState() => _BaatoReversePageState();
}

class _BaatoReversePageState extends State<BaatoReversePage> {
  late MaplibreMapController mapController;
  PlaceResponse? placeResponse;
  bool isCameraMoving = false;

  void _onMapCreated(MaplibreMapController controller) {
    this.mapController = controller;
    //show initial information
    Fluttertoast.showToast(
        msg:
            "Move the map to change the marker location and get location details of that point... ",
        toastLength: Toast.LENGTH_LONG);

    mapController.addListener(() {
      if (mapController.isCameraMoving && mapController.symbols.isNotEmpty)
        mapController.removeSymbol(mapController.symbols.first);
      setState(() {
        isCameraMoving = mapController.isCameraMoving;
      });
    });
  }

  void _onCameraIdle() {
    if (!mapController.isCameraMoving) {
      _requestLocationDetails(context, mapController.cameraPosition!.target,
          BaatoExampleApp.BAATO_ACCESS_TOKEN);
      _showMarkerOnTheTappedLocation(mapController.cameraPosition!.target);
    }
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  @override
  Widget build(BuildContext context) {
    /*map style can be 'retro','breeze','monochrome'*/
    String baatoAccessToken = BaatoExampleApp.BAATO_ACCESS_TOKEN;
    String mapStyle = "retro";

    return new Scaffold(
      body: Stack(children: [
        MaplibreMap(
          trackCameraPosition: true,
          onMapCreated: _onMapCreated,
          onCameraIdle: _onCameraIdle,
          onMapClick: (point, latLng) async {
            mapController.moveCamera(
              CameraUpdate.newLatLng(
                latLng,
              ),
            );
            _requestLocationDetails(context, latLng, baatoAccessToken);
            _showMarkerOnTheTappedLocation(latLng);
          },
          initialCameraPosition: const CameraPosition(
              target: LatLng(27.7192873, 85.3238007), zoom: 14.0),
          styleString: "https://api.baato.io/api/v1/styles/" +
              mapStyle +
              "?key=" +
              baatoAccessToken,
        ),
        Center(
          child: Container(
              child: isCameraMoving
                  ? Image.asset('assets/images/ic_marker.png')
                  : null),
        ),
      ]),
    );
  }

  _requestLocationDetails(
      BuildContext context, LatLng latLng, String baatoAccessToken) async {
    BaatoReverse baatoReverse = BaatoReverse.initialize(
      latLon: GeoCoord(latLng.latitude, latLng.longitude),
      accessToken: baatoAccessToken,
    );

    //perform reverse Search
    PlaceResponse response = await baatoReverse.reverseGeocode();
    print(response);

    setState(() {
      placeResponse = response;
    });

    _showAddressInfo(response);
  }

  _showAddressInfo(PlaceResponse response) {
    if (response.data!.isEmpty)
      print("No result found");
    else {
      Fluttertoast.showToast(
          msg:
              "Name: ${response.data![0].name}\nAddress: ${response.data![0].address}");
    }
  }

  void _showMarkerOnTheTappedLocation(LatLng latLng) {
    if (mapController.symbols.isNotEmpty)
      mapController.removeSymbol(mapController.symbols.first);
    mapController.addSymbol(
      new SymbolOptions(
        geometry: latLng,
        iconImage: "assets/images/ic_marker.png",
      ),
    );
  }
}
