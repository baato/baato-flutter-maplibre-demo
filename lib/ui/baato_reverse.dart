import 'dart:typed_data';

import 'package:baato_api/baato_api.dart';
import 'package:baato_api/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maplibre_gl/mapbox_gl.dart';

class BaatoReverseExample extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Baato Reverse"),
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

  void _onMapCreated(MaplibreMapController controller) {
    this.mapController = controller;
  }

  void _onStyleLoaded() {
    // addImageFromAsset("assetImage", "assets/symbols/placeholder.png");
    Fluttertoast.showToast(
        msg:
            "Tap on any point on the map to get location details of that point... ",
        toastLength: Toast.LENGTH_LONG);
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

    return Scaffold(
      body: MaplibreMap(
        onMapCreated: _onMapCreated,
        onStyleLoadedCallback: _onStyleLoaded,
        onMapClick: (point, latLng) {
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
    _showAddressInfo(response, context);
  }

  _showAddressInfo(PlaceResponse response, BuildContext context) {
    if (response.data!.isEmpty)
      print("No result found");
    else {
      Fluttertoast.showToast(
          msg:
              "Name: ${response.data![0].name} \nAddress: ${response.data![0].address}",
          toastLength: Toast.LENGTH_LONG);
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
