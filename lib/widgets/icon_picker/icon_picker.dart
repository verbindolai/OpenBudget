import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconWithColor {
  final IconData iconData;
  final Color iconColor;
  final Color backgroundColor;

  IconWithColor(this.iconData, this.iconColor, this.backgroundColor);

  static Color iconColorWhite = Colors.white;
  static Color iconColorBlack = Colors.black;
  static Color backgroundColorWhite = Colors.white;
  static Color backgroundColorBlack = Colors.black;
}

List<IconWithColor> icons = [
  IconWithColor(
    Icons.account_balance_wallet,
    Colors.white,
    const Color(0xAA6342f5),
  ),
  IconWithColor(
    FontAwesomeIcons.ghost,
    Colors.white,
    const Color.fromARGB(170, 18, 214, 236),
  ),
  IconWithColor(
    FontAwesomeIcons.heartCircleBolt,
    Color.fromARGB(255, 227, 49, 49),
    Colors.black,
  ),

  IconWithColor(
    FontAwesomeIcons.guitar,
    Color.fromARGB(255, 116, 78, 1),
    Colors.white,
  ),

  IconWithColor(
    FontAwesomeIcons.masksTheater,
    Color.fromARGB(255, 0, 50, 119),
    Colors.white,
  ),

  IconWithColor(
    Icons.restaurant,
    Color.fromARGB(255, 0, 50, 119),
    Colors.white,
  ),
  IconWithColor(
    Icons.fastfood,
    Color.fromARGB(255, 0, 50, 119),
    Colors.white,
  ),
  IconWithColor(
    Icons.maps_home_work,
    Color.fromARGB(255, 0, 50, 119),
    Colors.white,
  ),
  IconWithColor(
    Icons.security,
    Color.fromARGB(255, 0, 50, 119),
    Colors.white,
  ),
  IconWithColor(
    Icons.music_note,
    Color.fromARGB(255, 0, 50, 119),
    Colors.white,
  ),
  IconWithColor(
    Icons.cake,
    Color.fromARGB(255, 0, 50, 119),
    Colors.white,
  ),
  IconWithColor(
    Icons.camera_alt,
    Color.fromARGB(255, 0, 50, 119),
    Colors.white,
  ),
  IconWithColor(
    Icons.directions_bus,
    Color.fromARGB(255, 0, 50, 119),
    Colors.white,
  ),
  IconWithColor(
    Icons.home_repair_service,
    Color.fromARGB(255, 0, 50, 119),
    Colors.white,
  ),
  IconWithColor(
    Icons.emergency,
    Color.fromARGB(255, 138, 0, 0),
    Colors.white,
  ),
  IconWithColor(
    Icons.sports_esports,
    Color.fromARGB(255, 0, 50, 119),
    Colors.white,
  ),
  IconWithColor(
    Icons.sports_baseball,
    Color.fromARGB(255, 0, 50, 119),
    Colors.white,
  ),
  IconWithColor(
    Icons.bedtime_sharp,
    Color.fromARGB(255, 0, 50, 119),
    Colors.white,
  ),
  IconWithColor(
    Icons.sports_bar,
    Color.fromARGB(255, 0, 50, 119),
    Colors.white,
  ),
  IconWithColor(
    Icons.hub,
    Color.fromARGB(255, 0, 50, 119),
    Colors.white,
  ),
  IconWithColor(
    Icons.local_hotel,
    Color.fromARGB(255, 0, 50, 119),
    Colors.white,
  ),
  IconWithColor(
    Icons.local_hospital_rounded,
    Color.fromARGB(255, 221, 11, 11),
    Colors.yellow.shade800,
  ),
  // FontAwesomeIcons.guitar,
  // FontAwesomeIcons.gamepad,
  // FontAwesomeIcons.dragon,
  // FontAwesomeIcons.fire,
  // FontAwesomeIcons.iceCream,
  // FontAwesomeIcons.fish,
  // FontAwesomeIcons.frog,
  // FontAwesomeIcons.bug,
  // FontAwesomeIcons.dove,
  // FontAwesomeIcons.dog,
  // FontAwesomeIcons.cat,
  // FontAwesomeIcons.cow,
  // FontAwesomeIcons.horse,
  // FontAwesomeIcons.socks,
  // FontAwesomeIcons.spider,
];

class IconPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              children: <Widget>[
                for (var icon in icons)
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: icon.backgroundColor,
                    child: IconButton(
                      iconSize: 35,
                      onPressed: () {},
                      icon: Icon(
                        icon.iconData,
                        color: icon.iconColor,
                      ),
                    ),
                  )
              ]),
        ),
      ),
    );
  }
}
