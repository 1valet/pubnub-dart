@JS()
library pubnub;

import 'src/pubnub_interop.dart' as interop;
import 'package:js/js.dart';

typedef void PubNubCallback(PubNubEvent);

class PubNub {

  interop.PubNub _interop;

  PubNub({String subscribeKey, String publishKey}) {
    this._interop = new interop.PubNub(new interop.PubNubOptions(
        subscribeKey: subscribeKey,
        publishKey: publishKey));
  }

  void subscribe(String channel) {
    _interop.subscribe(new interop.SubscribeOptions(channels: [channel]));
  }

  void addListener(PubNubCallback callback) {
    _interop.addListener(new interop.ListenerOptions(message: allowInterop((PubNubEvent event){
      callback(event);
    })));
  }

  void publish({String channel, Object message}) {
    _interop.publish(new interop.PublishOptions(
        message: message,
        channel: channel));
  }

}

@JS()
class PubNubEvent<T> {
  external String get actualMsg;
  external String get channel;
  external T get message;
  external String get subscribedChannel;
  external String get subscription;
  external String get timetoken;
}
