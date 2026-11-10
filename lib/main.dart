import 'package:flutter/material.dart';

import 'models/smart_device.dart';
import 'models/smart_light.dart';
import 'models/smart_speaker.dart';
import 'models/thermostat.dart';
import 'widgets/device_card.dart';
import 'widgets/device_details_sheet.dart';

void main() {
  runApp(const SmartHomeApp());
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home Controller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3366CC)),
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<SmartDevice> _devices;

  @override
  void initState() {
    super.initState();
    // OBJECTS: Her alt sınıftan birden fazla nesne.
    // Hem default hem de named constructor'lar kullanılıyor.
    _devices = [
      SmartLight('Living Room', brightness: 75), // default constructor
      SmartLight.off('Kitchen'), // named constructor
      Thermostat('Bedroom', targetTemperature: 24) // default constructor
        ..setSchedule('06:45'), // Schedulable mixin
      Thermostat.eco('Office'), // named constructor
      SmartSpeaker('Kitchen', isPlaying: true, volume: 40), // default
      SmartSpeaker.muted('Office'), // named constructor
    ];
  }

  void _refresh() => setState(() {});

  void _addDevice(String type) {
    final n = SmartDevice.totalDevices + 1;
    setState(() {
      _devices.add(switch (type) {
        'light' => SmartLight('Room $n', brightness: 60),
        'thermostat' => Thermostat('Room $n'),
        _ => SmartSpeaker('Room $n'),
      });
    });
  }

  void _openDetails(SmartDevice device) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => DeviceDetailsSheet(device: device, onChanged: _refresh),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Home Controller'),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Add device',
            icon: const Icon(Icons.add),
            onSelected: _addDevice,
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'light', child: Text('Add Smart Light')),
              PopupMenuItem(value: 'thermostat', child: Text('Add Thermostat')),
              PopupMenuItem(value: 'speaker', child: Text('Add Smart Speaker')),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _devices.length,
        itemBuilder: (_, i) => DeviceCard(
          device: _devices[i],
          onChanged: _refresh,
          onTap: () => _openDetails(_devices[i]),
        ),
      ),
      // BOTTOM TEXT: değer static değişkenden geliyor.
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: SafeArea(
          top: false,
          child: Text(
            'Total Devices: ${SmartDevice.totalDevices}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
