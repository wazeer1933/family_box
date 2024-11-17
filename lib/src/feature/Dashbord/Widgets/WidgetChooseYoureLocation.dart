import 'package:family_box/src/feature/Dashbord/controllers/controllerAddActions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerDialog extends StatefulWidget {
  @override
  _LocationPickerDialogState createState() => _LocationPickerDialogState();
}

class _LocationPickerDialogState extends State<LocationPickerDialog> {
  final controllerAddCations controllerAddCation = Get.put(controllerAddCations());

  LatLng? _selectedLocation;
  GoogleMapController? _mapController;


  @override
  void initState() {
      
    super.initState();
  }



  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (controllerAddCation.currentPosition != null) {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(controllerAddCation.currentPosition!.latitude, controllerAddCation.currentPosition!.longitude),
            zoom: 20,
          ),
        ),
      );
    }
  }

  void _onTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _confirmLocation() {
    if (_selectedLocation != null) {
      print("Selected Latitude: ${_selectedLocation!.latitude}");
      print("Selected Longitude: ${_selectedLocation!.longitude}");
      controllerAddCation.latitude = '${_selectedLocation!.latitude}';
      controllerAddCation.longitude = '${_selectedLocation!.longitude}';
       controllerAddCation.latitude="${_selectedLocation!.latitude}";
       controllerAddCation.longitude="${_selectedLocation!.longitude}";

      // Fetch and print the name of the city and street
     controllerAddCation. getAddressFromLatLng(_selectedLocation!);

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a location on the map")),
      );
    }
  }

 


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Choose your location"),
      content: Container(
        width: double.maxFinite,
        height: 400,
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: 
                 LatLng(double.parse('${controllerAddCation.latitude}'), double.parse('${controllerAddCation.longitude}')),
                 // Default to San Francisco if location is not available
            zoom: 20,
          ),
          onTap: _onTap,
          markers: _selectedLocation != null
              ? {
                  Marker(
                    markerId: MarkerId("selectedLocation"),
                    position: _selectedLocation!,
                  )
                }
              : {},
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("الغاء"),
        ),
        TextButton(
          onPressed: _confirmLocation,
          child: Text("التالي"),
        ),
      ],
    );
  }
}

// Function to show the location picker dialog
void showLocationPickerDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return LocationPickerDialog();
    },
  );
}
