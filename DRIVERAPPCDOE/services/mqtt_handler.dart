import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';


final client = MqttServerClient('test.mosquitto.org', '');

var pongCount = 0; // Pong counter
var pingCount = 0; // Ping counter

Future<int> main() async {

  client.logging(on: false);
  client.setProtocolV311();
  client.keepAlivePeriod = 20;
  /// Add the unsolicited disconnection callback
  client.onDisconnected = onDisconnected;

  /// Add the successful connection callback
  client.onConnected = onConnected;
  client.onSubscribed = onSubscribed;

  final connMess = MqttConnectMessage()
      .withClientIdentifier('Mqtt_MyClientUniqueId')
      .withWillTopic('willtopic') // If you set this you must set a will message
      .withWillMessage('My Will message')
      .startClean() // Non persistent session for testing
      .withWillQos(MqttQos.atLeastOnce);
  print('Mosquitto client connecting....');
  client.connectionMessage = connMess;

  try {
    await client.connect();
  } on NoConnectionException catch (e) {
    // Raised by the client when connection fails.
    print('client exception - $e');
    client.disconnect();
  } on SocketException catch (e) {
    // Raised by the socket layer
    print('socket exception - $e');
    client.disconnect();
  }

  /// Check we are connected
  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('Mosquitto client connected');
  } else {
    /// Use status here rather than state if you also want the broker return code.
    print(
        'ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
    exit(-1);
  }

  /// Ok, lets try a subscription
  print('Subscribing to the test/lol topic');
  const topic = 'test/lol'; // Not a wildcard topic
  client.subscribe(topic, MqttQos.atMostOnce);

  client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    final pt =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    print(
        'Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    print('');
  });
  client.published!.listen((MqttPublishMessage message) {
    print(
        'Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
  });

  const pubTopic = 'Dart/Mqtt_client/testtopic';
  final builder = MqttClientPayloadBuilder();
  builder.addString('Hello from mqtt_client');

  /// Subscribe to it
  print('Subscribing to the Dart/Mqtt_client/testtopic topic');
  client.subscribe(pubTopic, MqttQos.exactlyOnce);

  /// Publish it
  print('Publishing our topic');
  client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);


  print('Sleeping....');
  await MqttUtilities.asyncSleep(60);

  print('Keep alive latencies');
  print(
      'The latency of the last ping/pong cycle is ${client.lastCycleLatency} milliseconds');
  print(
      'The average latency of all the ping/pong cycles is ${client.averageCycleLatency} milliseconds');

  /// Finally, unsubscribe and exit gracefully
  print('Unsubscribing');
  client.unsubscribe(topic);

  /// Wait for the unsubscribe message from the broker if you wish.
  await MqttUtilities.asyncSleep(2);
  print('Disconnecting');
  client.disconnect();
  print('Exiting normally');
  return 0;
}

/// The subscribed callback
void onSubscribed(String topic) {
  print('Subscription confirmed for topic $topic');
}

/// The unsolicited disconnect callback
void onDisconnected() {
  print('OnDisconnected client callback - Client disconnection');
  if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
    print('OnDisconnected callback is solicited, this is correct');
  } else {
    print(
        'OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
    exit(-1);
  }
  if (pongCount == 3) {
    print(' Pong count is correct');
  } else {
    print(' Pong count is incorrect, expected 3. actual $pongCount');
  }
  if (pingCount == 3) {
    print(' Ping count is correct');
  } else {
    print(' Ping count is incorrect, expected 3. actual $pingCount');
  }
}

/// The successful connect callback
void onConnected() {
  print(
      'OnConnected client callback - Client connection was successful');
}

/// Pong callback
void pong() {
  print('Ping response client callback invoked');
  pongCount++;
  print(
      'Latency of this ping/pong cycle is ${client.lastCycleLatency} milliseconds');
}

/// Ping callback
void ping() {
  print('Ping sent client callback invoked');
  pingCount++;
}