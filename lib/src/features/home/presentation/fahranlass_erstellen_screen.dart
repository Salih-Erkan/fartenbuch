import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fartenbuch/src/features/home/domain/fahranlass.dart';

class FahranlassErstellenScreen extends StatefulWidget {
  const FahranlassErstellenScreen({super.key});

  @override
  State<FahranlassErstellenScreen> createState() =>
      _FahranlassErstellenScreenState();
}

class _FahranlassErstellenScreenState extends State<FahranlassErstellenScreen> {
  final nameController = TextEditingController();
  Color selectedColor = Colors.blue;
  IconData selectedIcon = FontAwesomeIcons.car;

  final List<Color> availableColors = [
    Colors.redAccent,
    Colors.pink,
    Colors.purple,
    Colors.indigo,
    Colors.blue,
    Colors.teal,
    Colors.green,
    Colors.lime,
    Colors.amber,
    Colors.orange,
    Colors.brown,
    Colors.grey,
  ];

  final List<IconData> iconChoices = [
    FontAwesomeIcons.car,
    FontAwesomeIcons.briefcase,
    FontAwesomeIcons.cartShopping,
    FontAwesomeIcons.houseUser,
    FontAwesomeIcons.ticket,
    FontAwesomeIcons.heart,
    FontAwesomeIcons.bus,
    FontAwesomeIcons.train,
    FontAwesomeIcons.utensils,
    FontAwesomeIcons.plane,
    FontAwesomeIcons.bicycle,
    FontAwesomeIcons.graduationCap,
    FontAwesomeIcons.laptop,
    FontAwesomeIcons.user,
    FontAwesomeIcons.school,
    FontAwesomeIcons.dumbbell,
    FontAwesomeIcons.building,
    FontAwesomeIcons.clock,
    FontAwesomeIcons.tree,
    FontAwesomeIcons.brain,
    FontAwesomeIcons.dog,
    FontAwesomeIcons.cat,
    FontAwesomeIcons.gamepad,
    FontAwesomeIcons.music,
    FontAwesomeIcons.camera,
    FontAwesomeIcons.shieldHalved,
    FontAwesomeIcons.screwdriverWrench,
    FontAwesomeIcons.bolt,
    FontAwesomeIcons.gear,
    FontAwesomeIcons.children,
    FontAwesomeIcons.child, // NEU
    FontAwesomeIcons.peopleGroup, // NEU
    FontAwesomeIcons.hospital, // NEU
    FontAwesomeIcons.landmark, // NEU
    FontAwesomeIcons.mountain, // NEU
  ];

  void _submit() {
    final name = nameController.text.trim();
    if (name.isEmpty) return;

    final neuerAnlass = Fahranlass(
      name: name,
      icon: selectedIcon,
      color: selectedColor,
    );

    Navigator.pop(context, neuerAnlass);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Neuer Fahranlass')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bezeichnung des Fahranlasses eintragen',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Bezeichnung',
                labelStyle: const TextStyle(color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Farbe auswählen',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 14,
              children:
                  availableColors.map((color) {
                    final isSelected = selectedColor == color;
                    return GestureDetector(
                      onTap: () => setState(() => selectedColor = color),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(radius: 28, backgroundColor: color),
                          if (isSelected)
                            const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 24,
                            ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 5),
            const Text(
              'Icon auswählen',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children:
                  iconChoices.map((icon) {
                    final isSelected = selectedIcon == icon;
                    return GestureDetector(
                      onTap: () => setState(() => selectedIcon = icon),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              isSelected
                                  ? selectedColor.withAlpha(60)
                                  : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? selectedColor : Colors.grey,
                          ),
                        ),
                        child: FaIcon(
                          icon,
                          color: isSelected ? selectedColor : Colors.black54,
                        ),
                      ),
                    );
                  }).toList(),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Speichern'),
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
