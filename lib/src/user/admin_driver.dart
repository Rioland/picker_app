import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pickrr_app/src/values/values.dart';

import '../home.dart';

class AdminDriver extends StatefulWidget {
  @override
  _AdminDriverState createState() => _AdminDriverState();
}

class _AdminDriverState extends State<AdminDriver> {
  GoogleMapController myMapController;
  final Set<Marker> _markers = new Set();
  static const LatLng _mainLocation = const LatLng(4.814340, 7.000848);
  double amount = 500;
  final currencyFormatter =
  NumberFormat.currency(locale: 'en_US', symbol: '\u20a6');
  final rider_flr = 'assets/flare/rider.flr';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Container(
                color: Colors.white,
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          children: [
                            Hero(
                              tag: 'map',
                              flightShuttleBuilder: _flightShuttleBuilder,
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: _mainLocation,
                                  zoom: 15.6,
                                ),
                                markers: this.myMarker(),
                                mapType: MapType.normal,
                                myLocationButtonEnabled: false,
                                zoomControlsEnabled: false,
                                onMapCreated: (controller) {
                                  setState(() {
                                    myMapController = controller;
                                  });
                                },
                              ),
                            ),
                            SafeArea(
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(14, 15, 16, 8),
                                  child: Hero(
                                    tag: "nav",
                                    flightShuttleBuilder: _flightShuttleBuilder,
                                    child: GestureDetector(
                                        child: Container(
                                          // color: Colors.yellow,
                                          padding: EdgeInsets.only(right: 10),
                                          child: Card(
                                              elevation: 8,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(50.0),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.arrow_back,
                                                  size: 23,
                                                ),
                                              )),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                        }),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              Shadows.primaryShadow,
                            ],
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Container(
                                height: 8,
                                width: 60,
                                margin: EdgeInsets.only(top: 15, bottom: 18),
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                              Container(height: 200,
                                child: new FlareActor(rider_flr,
                                    alignment: Alignment.center, fit: BoxFit.contain, animation: 'RidertoStore'),
                              ),
                              new Text(
                                "A driver will be assigned\nto you shortly...",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: "Ubuntu",
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    height: 1.35),
                              ),
                              SizedBox(height: 20),
                              // Hero(
                              //   tag: "btn",
                              //   flightShuttleBuilder: _flightShuttleBuilder,
                              //   child: GestureDetector(
                              //     child: Container(
                              //       height: 45,
                              //       alignment: Alignment.center,
                              //       margin: EdgeInsets.only(
                              //           bottom: 10, left: 25, right: 25, top: 30),
                              //       decoration: BoxDecoration(
                              //         color: AppColors.primaryText,
                              //         boxShadow: [Shadows.secondaryShadow],
                              //         borderRadius: Radii.kRoundpxRadius,
                              //       ),
                              //       child: Row(
                              //         mainAxisAlignment: MainAxisAlignment.center,
                              //         children: [
                              //           Icon(Icons.phone_rounded,
                              //               color: Colors.white, size: 18),
                              //           SizedBox(width: 8),
                              //           Text('Call Driver',
                              //               style: TextStyle(
                              //                   fontSize: 15,
                              //                   fontFamily: 'Ubuntu',
                              //                   color: Colors.white,
                              //                   fontWeight: FontWeight.w500)),
                              //         ],
                              //       ),
                              //     ),
                              //     onTap: () => launch("tel://08161654006"),
                              //   ),
                              // ),
                              GestureDetector(
                                child: Container(
                                  height: 45,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      bottom: 10, left: 25, right: 25, top: 0),
                                  child: Text('Cancel ride',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Ubuntu',
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500)),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Home()),
                                  );
                                },
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            )));
  }

  Set<Marker> myMarker() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(_mainLocation.toString()),
        position: _mainLocation,
        infoWindow: InfoWindow(
          title: 'Bikers City',
          snippet: 'George Howfa na :)',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
    return _markers;
  }

  Widget _flightShuttleBuilder(
      BuildContext flightContext,
      Animation<double> animation,
      HeroFlightDirection flightDirection,
      BuildContext fromHeroContext,
      BuildContext toHeroContext,
      ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }
}
