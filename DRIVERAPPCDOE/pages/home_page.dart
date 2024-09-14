import 'package:drivers_app/globals.dart';
import 'package:drivers_app/providers/authentication_provider.dart';
import 'package:drivers_app/widgets/driver_details.dart';
import 'package:drivers_app/widgets/rounded_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight, _devicWidth;
  late AuthenticationProvider _auth;
  
  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    _deviceHeight = MediaQuery.of(context).size.height;
    _devicWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _appBar(),
      drawer: _drawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 0.02 * _deviceHeight,
              ),
              const DriverDetails(),
              TodaysRide()
            ],
          ),
        ),
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
            key: UniqueKey(), imagePath: driverUser.imageURL, size: 80),
      ),
      Container(
        alignment: Alignment.bottomLeft,
        height: 0.2 * _deviceHeight,
        padding: const EdgeInsets.all(16),
        child: Text(
          driverUser.email,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
        ),
      )
    ]);
  }
}
