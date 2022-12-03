import 'dart:async';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:flutter/services.dart';
import 'package:tezpay_pusher_example/chat_model.dart';

class PusherService {
  late PusherChannelsClient pusher;
  String? lastConnectionState;
  Channel? channel;
  StreamSubscription? eventSubscription;
  final StreamController<ChatMessage> _eventData =
      StreamController<ChatMessage>();

  Sink get _inEventData => _eventData.sink;

  Stream get eventStream => _eventData.stream;

  Future<void> initPusher() async {
    try {
      const options = PusherChannelsOptions.wss(
        host: 'https://tez-pay.uz/',
        port: 443,
        key: 'nMRoD9nHgwGCXVNXXS7S',
        protocol: 7,
        cluster: "ap1",
      );
      pusher = PusherChannelsClient.websocket(
          options: options,
          onConnectionErrorHandle: (error, trace, refresh) {
            print(error);
          });
    } on PlatformException catch (e) {
      print(e.details);
    }
  }

  void unbindEvent(String eventName) {
    eventSubscription?.cancel();
    channel?.unsubscribe();
    pusher.close();
    _eventData.close();
  }

  Future<void> firePusher(String channelName, String eventName) async {
    await initPusher();
    pusher.onConnectionEstablished.listen((event) async {
      channel ??= pusher.publicChannel(channelName);
      await eventSubscription?.cancel();
      eventSubscription = channel?.bind(eventName).listen((event) {
        print("CONNECTED:${event.data}");
        final ChatMessage data = ChatMessage.fromJson(event.data['message']);
        _inEventData.add(data);
      });
      channel!.subscribe();
    });
    pusher.connect();
  }
}
