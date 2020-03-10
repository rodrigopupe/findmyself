import 'dart:async';

import 'package:find_myself/provider/user_location_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class UserLocationMapPage extends StatefulWidget {
  @override
  _UserLocationMapPageState createState() => _UserLocationMapPageState();
}

class _UserLocationMapPageState extends State<UserLocationMapPage> {
  Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  UserLocationProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<UserLocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Confirme a localização'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _drawMap(),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Text(
                    'Caso queira alterar, arraste o marcador e confirme a alteração.'),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Confirmar',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _confirmPosition,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _drawMap() {
    var marker = Marker(
      markerId: MarkerId('userId'),
      position: _provider.currentPosition,
      infoWindow: InfoWindow(title: 'Você está aqui'),
      draggable: true,
      onDragEnd: _onDragMarker,
    );

    return GoogleMap(
      mapToolbarEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: _provider.currentPosition,
        zoom: 18,
      ),
      onMapCreated: _onMapCreated,
      markers: [marker].toSet(),
    );
  }

  _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  _onDragMarker(LatLng position) {
    _provider.updateAddressFromCoordinate(position);
  }

  _confirmPosition() {
    Navigator.pop(context);
    // Os dados da localização já estarão sendo exibidos na tela inicial
  }
}
