@JS()
library pubnub;

import 'package:js/js.dart';

@JS()
class PubNub {
  external PubNub(PubNubOptions options);

  external void addListener(ListenerOptions options);
  external void subscribe(SubscribeOptions options);
  external void publish(PublishOptions options);
}

@JS()
@anonymous
class PubNubOptions {
  external String get publishKey;
  external String get subscribeKey;
  external factory PubNubOptions({String subscribeKey, String publishKey});
}

@JS()
@anonymous
class SubscribeOptions {
  external List<String> get channels;
  external factory SubscribeOptions({List<String> channels});
}

@JS()
@anonymous
class ListenerOptions {
  external Function get message;
  external factory ListenerOptions({Function message});
}

@JS()
@anonymous
class PublishOptions<T> {
  external T get message;
  external String get channel;
  external factory PublishOptions({T message, String channel});
}
