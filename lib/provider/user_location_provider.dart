import 'dart:async';

import 'package:find_myself/model/user.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class UserLocationProvider with ChangeNotifier {
  LatLng _currentPosition = LatLng(0.0, 0.0);
  LatLng get currentPosition => _currentPosition;

  StreamController<User> _userController = StreamController.broadcast();
  Stream<User> get outputUser => _userController.stream;

  UserLocationProvider() {
    _startGPSMonitor();
  }

  Future _startGPSMonitor() async {
    // Resolvi usar o package "location" pois tem uma verificação de permissão melhor do que o GeoLocator
    var permission = await Location().requestPermission();

    if (permission == PermissionStatus.GRANTED) {
      _currentPosition = await geo.Geolocator().getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high
      ).then(
        (locationData) {
          return LatLng(locationData.latitude, locationData.longitude);
        },
      );
      notifyListeners();
    }
  }

  Future updateAddressFromCoordinate(LatLng position) async {
    var list = await geo.Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    var address = list.first;
    var user = User(
      neighborhood: address.subLocality,
      city: address.subAdministrativeArea,
      state: address.administrativeArea,
      country: address.country
    );
    _userController.add(user);
  }

  @override
  void dispose() {
    _userController.close();
    super.dispose();
  }
}
