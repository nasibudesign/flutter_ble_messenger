import 'package:flutter_ble_messenger/controller/login_controller.dart';
import 'package:flutter_ble_messenger/model/message.dart';
import 'package:get/get.dart';
import 'package:nearby_connections/nearby_connections.dart';

class MessagesController extends GetxController {
  LoginController loginController = Get.put(LoginController());
  var messages = RxList<Message>().obs;
  var username = ''.obs;
  var connectedIdList = RxList<String>().obs;

  @override
  void onInit() {
    super.onInit();
    username = RxString(loginController.username.value);
  }

  @override
  void onClose() {
    messages.close();
    super.onClose();
  }

  /// return true if the device id is included in the list of connected devices
  bool isDeviceConnected(String id) =>
      connectedIdList.value.contains(id) ? true : false;

  /// add the device id to the list of connected devices
  void onConnect(String id) => connectedIdList.value.add(id);

  /// remove the device id from the list of connected devices
  void onDisconnect(String id) =>
      connectedIdList.value.removeWhere((element) => element == id);

  void onSendMessage(
      {required String toId,
      required String toUsername,
      required String fromId,
      required String fromUsername,
      required String message}) {
    /// Add the message object received to the messages list
    messages.value.add(Message(
      sent: true,
      toId: toId,
      toUsername: toUsername,
      fromUsername: fromUsername,
      message: message,
      dateTime: DateTime.now(),
    ));

    /// This will force a widget rebuild
    update();
  }

  void onReceiveMessage(
      {required String fromId, required Payload payload, required ConnectionInfo fromInfo}) async {
    /// Once receive a payload in the form of Bytes,
    if (payload.type == PayloadType.BYTES) {
      /// we will convert the bytes into String
      String messageString = String.fromCharCodes(payload.bytes as Iterable<int>);

      /// Add the message object to the messages list
      messages.value.add(
        Message(
          sent: false,
          fromId: fromId,
          fromUsername: fromInfo.endpointName,
          toUsername: username.value,
          message: messageString,
          dateTime: DateTime.now(),
        ),
      );
    }

    /// This will force a widget rebuild
    update();
  }
}
