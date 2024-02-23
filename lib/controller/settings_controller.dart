import 'package:flutter/material.dart';
import 'package:flutter_ble_messenger/view/widgets/common/custom_elevated_button.dart';
import 'package:flutter_ble_messenger/view/widgets/common/show_alert_dialog_box.dart';
import 'package:get/get.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsController extends GetxController {
  final nearby = Nearby();
  var isLocationPermitted = false.obs;
  var isBluetoothGranted = false.obs;
  var isLocationServicesGranted = false.obs;

  updateLocationPermissionNeeded() async {
    if (await Permission.location.isGranted) {
      /// Location Permission is already granted
      isLocationPermitted = RxBool(true);
    } else {
      /// Location Permission is not yet granted so let's request for it
      await Permission.location.request();
      if (await Permission.location.isGranted) {
        /// Location Permission is now granted
        isLocationPermitted = RxBool(true);
      } else {
        /// Location Permission is not granted
        isLocationPermitted = RxBool(false);
      }
    }
  }

  updateBluetoothPermission() async {
    bool granted = !(await Future.wait([
      // Check
      Permission.bluetooth.isGranted,
      Permission.bluetoothAdvertise.isGranted,
      Permission.bluetoothConnect.isGranted,
      Permission.bluetoothScan.isGranted,
    ]))
        .any((element) => false);

    if (granted) {
      isBluetoothGranted = RxBool(true);
    } else {
      [
        // Ask
        Permission.bluetooth,
        Permission.bluetoothAdvertise,
        Permission.bluetoothConnect,
        Permission.bluetoothScan
      ].request();
      if (granted) {
        isBluetoothGranted = RxBool(true);
      } else {}
    }
  }

  updateLocationServicesNeeded() async {
    if (await Permission.nearbyWifiDevices.isGranted) {
      /// Location Services is already granted
      isLocationServicesGranted = RxBool(true);
    } else {
      /// Location Services is not yet granted so let's request for it
      await Permission.nearbyWifiDevices.request();
      if (await Permission.location.isGranted) {
        /// Location Services is now granted
        isLocationServicesGranted = RxBool(true);
      } else {
        /// Location Services is not yet granted
        isLocationServicesGranted = RxBool(false);
      }
    }
  }

  Future<void> checkLocation(BuildContext context) async {
    if (this.isLocationPermitted.value ||
        this.isLocationServicesGranted.value|| this.isBluetoothGranted.value) {
      showLocationCheckerDialog(context);
    } else {
      showAlertDialogBox(
        context: context,
        header: 'Enable your location & Bluetooth',
        message:
            'We need to know where you are in order to scan nearby app users in your neighborhood.',
        actionButtons: [
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
              showLocationCheckerDialog(context);
            },
          ),
          customElevatedButton(
            context: context,
            label: 'Enable',
            callback: () {
              requestLocation().then((_) {
                return showLocationCheckerDialog(context);
              });

              Navigator.of(context).pop();
            },
          )
        ],
      );
    }
  }

  Future<void> requestLocation() async {
    await updateLocationPermissionNeeded();
    await updateLocationServicesNeeded();
    await updateBluetoothPermission();
  }

  showLocationCheckerDialog(BuildContext context) {
    showAlertDialogBox(
      context: context,
      header: 'Location Permission',
      message:
          this.isLocationPermitted.value && this.isLocationServicesGranted.value && this.isBluetoothGranted.value
              ? 'Location permission and service is granted. '
              : 'Location permission and service is not granted.',
      actionButtons: [
        OutlinedButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
