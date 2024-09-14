import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:parents_app/globals.dart';
import 'package:parents_app/providers/authentication_provider.dart';
import 'package:parents_app/widgets/rounded_image.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isPlaying = true;
    late double _deviceHeight, _devicWidth;
  late AuthenticationProvider _auth;
  final VlcPlayerController _videoPlayerController =
      VlcPlayerController.network(
          "https://media.w3.org/2010/05/sintel/trailer.mp4",
          hwAcc: HwAcc.full,
          autoPlay: true,
          options: VlcPlayerOptions());
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    _deviceHeight = MediaQuery.of(context).size.height;
    _devicWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _appBar(),
      drawer: _drawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          VlcPlayer(
            controller: _videoPlayerController,
            aspectRatio: 16 / 9,
            placeholder: const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () async {
                    // Get the current playback position
                    final curPosition =
                        await _videoPlayerController.getPosition();

                    // Subtract 10 seconds
                    final rewindPosition =
                        curPosition - const Duration(seconds: 10);

                    // Ensure the position doesn't go below 0
                    final newPosition = rewindPosition < Duration.zero
                        ? Duration.zero
                        : rewindPosition;

                    // Seek to the new position
                    _videoPlayerController.seekTo(newPosition);
                  },
                  child: const Icon(
                    Icons.fast_rewind,
                    size: 28,
                    color: Colors.black,
                  )),
              TextButton(
                  onPressed: () {
                    if (_isPlaying) {
                      setState(() {
                        _isPlaying = false;
                      });
                      _videoPlayerController.pause();
                    } else {
                      setState(() {
                        _isPlaying = true;
                      });
                      _videoPlayerController.play();
                    }
                  },
                  child: Icon(
                    _isPlaying ? Icons.play_arrow : Icons.stop,
                    size: 28,
                    color: Colors.black,
                  )),
              TextButton(
                  onPressed: () async {
                    // Get the current playback position
                    final curPosition =
                        await _videoPlayerController.getPosition();

                    // Get the total duration of the video
                    final totalDuration =
                        await _videoPlayerController.getDuration();

                    // Add 10 seconds
                    final forwardPosition =
                        curPosition + const Duration(seconds: 10);

                    // Ensure the position doesn't go beyond the total duration
                    final newPosition = forwardPosition > totalDuration
                        ? totalDuration
                        : forwardPosition;

                    // Seek to the new position
                    _videoPlayerController.seekTo(newPosition);
                  },
                  child: const Icon(
                    Icons.fast_forward,
                    size: 28,
                    color: Colors.black,
                  )),
            ],
          ),
          
        ],
      ),
    );
  }

  
  PreferredSizeWidget _appBar() {
    return AppBar(
      toolbarHeight: 0.08 * _deviceHeight,
      backgroundColor: darkBlue,
      title: _title(),
      actions: [
        GestureDetector(
          onTap: () {},
          child: const Stack(
            children: [
              Icon(
                Icons.notifications,
                color: Colors.white,
                size: 26,
              ),
              Positioned(
                top: 1,
                right: 4,
                child: Icon(
                  Icons.fiber_manual_record,
                  color: Colors.red,
                  size: 10,
                ),
              )
            ],
          ),
        ),
        IconButton(
            onPressed: () => _auth.logout(),
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            )),
      ],
    );
  }

  Row _title() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "We",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Icon(
          Icons.favorite,
          color: Colors.white,
        ),
        Text(
          "AIT",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        children: [
          _profile(),
          const ListTile(
            title: Text("Profile"),
            leading: Icon(Icons.person),
          ),
          const ListTile(
            title: Text("Settings"),
            leading: Icon(Icons.settings),
          )
        ],
      ),
    );
  }

  Widget _profile() {
    return Stack(children: [
      Container(
        width: double.infinity,
        height: 0.2 * _deviceHeight,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              darkBlue,
              const Color.fromRGBO(50, 52, 168, 1.0),
              Colors.white
            ])),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: RoundedImageNetwork(
            key: UniqueKey(), imagePath: parentUser.imageURL, size: 80),
      ),
      Container(
        alignment: Alignment.bottomLeft,
        height: 0.2 * _deviceHeight,
        padding: const EdgeInsets.all(16),
        child: Text(
          parentUser.email,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
        ),
      )
    ]);
  }

  triggerNotifications() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: 'Child Onboarded',
            body: "Your child has deboarded at your gate"));
  }

  Widget childOnBoardedButton(String text) {
    return ElevatedButton(
      onPressed: triggerNotifications,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.rectangle,
            border: Border.all(color: Colors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Text(
          textAlign: TextAlign.center,
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
          ),
        ),
      ),
    );
  }
}
