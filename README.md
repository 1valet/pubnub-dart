# PubNub for Dart

This is a Dart wrapper for only the _basic_ [PubNub](https://www.pubnub.com) functionality.

Currently you can do the following:

* Connect to PubNub
* Begin listening to a channel
* React to messages in a channel
* Post a message to a channel

This is enough to cover their "[Getting Started Guide][getting-started]".

## Getting Started (Dart)

Here is PubNub's "[Getting Started Guide][getting-started]", translated to Dart.

First, you need to include PubNub's JavaScript file in your host HTML site:

    <!-- Include the PubNub Library -->
    <script src="https://cdn.pubnub.com/sdk/javascript/pubnub.[version number].js"></script>

Be sure to replace `[version number]` with the current version. At the time of this writing it's `4.1.0`. So, it would read like this:
   
    <script src="https://cdn.pubnub.com/sdk/javascript/pubnub.4.1.0.js"></script>
    
Include this Dart library:

    import 'package:pubnub/pubnub.dart';

Instantiate PubNub:
    
    var pubnubDemo = new PubNub(
        publishKey: '[your-publish-key]',
        subscribeKey: '[your-subscribe-key]');
        
(Of course replace `[your-XXX-key]` with your personal keys from PubNub).

In order to send and receive JSON structures you need the [JS interop](https://pub.dartlang.org/packages/js) package. With it, you can declare an anonymous JS class / JSON structure like this:

    @JS()
    library example;
    
    import 'package:js/js.dart';

    @JS()
    @anonymous
    class ColorMsg {
      external String get color;
      external factory ColorMsg({String color});
    }

This is the equivalent of the JSON structure in the original guide:

    {
      color: 'someColor'
    }

Add a listener:

    pubnubDemo.addListener((PubNubEvent<ColorMsg> event) {
      ColorMsg msg = event.message;
      print(msg.color);
    });

The listener above assumes that the messages you receive have only one type. You can leave out the generic type if you need more flexibility:
 
    pubnubDemo.addListener((PubNubEvent event) {
      var msg = event.message;
      print(msg.color);
    });

(Note that the `PubNubEvent instance is not the message that you post to the channel. This instance _wraps_ the message, and contains additional PubNub information).

Subscribe to a channel:

    pubnubDemo.subscribe('demo_tutorial');

Publish to a channel:
    
    pubnubDemo.publish(channel: 'demo_tutorial',
            message: new ColorMsg(color: 'blue'));

(Note again that we are sending the "JS interop" derived class from above. You can not send Dart `Map` or other Dart objects directly).

And that's it. Have fun with your real-time Dart apps!

[getting-started]: https://www.pubnub.com/docs/getting-started-guides/pubnub-publish-subscribe
