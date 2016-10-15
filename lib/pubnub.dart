@JS()
library pubnub;

import 'src/pubnub_interop.dart' as interop;
import 'package:js/js.dart';

/// A function of a single parameter of type [PubNubEvent].
///
/// The passed [PubNubEvent] wraps the incoming JSON message and
/// provides additional properties. The JSON message itself can be accessed
/// through the `message` property.
///
/// Used in [PubNub.addListener].
///
typedef void PubNubListenerCallback(PubNubEvent);

/// Entry-point class. Used to connect to the PubNub service.
///
/// This class provides a Dart interface to basic PubNub features.
///
class PubNub {

  /// The real JavaScript PubNub interop class.
  ///
  /// The real work is done by this object. While it is the "real" thing,
  /// it does not provide a Dart-friendly interface. That's why it has been
  /// wrapped by this "outer" class.
  interop.PubNub _interop;

  /// Connects to the PubNub service, using the keys supplied.
  PubNub({String subscribeKey, String publishKey}) {
    this._interop = new interop.PubNub(new interop.PubNubOptions(
        subscribeKey: subscribeKey,
        publishKey: publishKey));
  }

  /// Subscribes to a channel.
  ///
  /// Note: with this method you subscribe to ONE channel. This diverges
  /// from the JavaScript PubNub interface, where you pass an array of
  /// channels. This might change in the future.
  ///
  void subscribe(String channel) {
    _interop.subscribe(new interop.SubscribeOptions(channels: [channel]));
  }

  /// Adds a listener for incoming [PubNubEvent]s (which wrap messages).
  ///
  /// The incoming [PubNubEvent]s are _not_ directly the messages sent to
  /// a channel, but a wrapper around them. These events contain other
  /// properties as well.
  ///
  /// The message itself is found in the property `message` of the event.
  ///
  /// When adding a listener and passing a [PubNubListenerCallback], you can
  /// choose to specify the type of the expected JSON message, by using the
  /// generic argument of [PubNubEvent] like this:
  ///
  ///     pubnubDemo.addListener((PubNubEvent<ChatMsg> event) {
  ///         ChatMsg chatMsg = event.message;
  ///         print(chatMsg.text);
  ///     });
  ///
  /// Or you can leave it out, which is useful if you don't know the type or
  /// there can be more than one type:
  ///
  ///     pubnubDemo.addListener((PubNubEvent event) {
  ///         var someJsonObject = event.message;
  ///         // Access a property in a non-typesafe way:
  ///         print(someJsonObject.someProperty);
  ///     });
  ///
  /// NOTE: the object to be found in `message` property is not a Dart
  /// object or Map, but a JavaScript JSON object. You can access their
  /// properties as you expect, but they will look "strange" in a debugger.
  ///
  void addListener(PubNubListenerCallback callback) {
    _interop.addListener(new interop.ListenerOptions(message: allowInterop((PubNubEvent event){
      callback(event);
    })));
  }

  /// Posts a [message] (JSON object) on a [channel]
  ///
  /// Note that the [message] has to be an anonymous JavaScript class
  /// as defined by the `@JS()` and `@anonymous` annotations of the "JS interop"
  /// package. Passing _any_ Dart object, even a Map, will not work.
  ///
  /// For example:
  ///
  ///     @JS()
  ///     library pubnub_chat_demo;
  ///
  ///     import 'package:js/js.dart';
  ///
  ///     @JS()
  ///     @anonymous
  ///     class ChatMsg {
  ///         external String get text;
  ///         external factory ChatMsg({String text});
  ///     }
  ///
  ///     // Somewhere else ...
  ///
  ///     pubnubDemo.publish(channel: 'demo_tutorial',
  ///         message: new ChatMsg(text: 'hello'));
  ///
  /// This would send the JSON `{"text": "hello"}` to the channel.
  ///
  void publish({String channel, Object message}) {
    _interop.publish(new interop.PublishOptions(
        message: message,
        channel: channel));
  }

}

/// Event received when listening to a channel.
///
/// When "listening" to a channel [PubNub.addListener] the incoming objects
/// are instance of this class. The JSON message posted to the channel is
/// contained in the property `message`.
///
@JS()
class PubNubEvent<T> {
  external String get actualMsg;
  external String get channel;
  external T get message;
  external String get subscribedChannel;
  external String get subscription;
  external String get timetoken;
}
