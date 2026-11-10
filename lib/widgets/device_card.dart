import 'package:flutter/material.dart';

import '../models/smart_device.dart';
import '../models/smart_light.dart';
import '../models/smart_speaker.dart';
import '../models/thermostat.dart';

/// Tek bir cihazı gösteren kart: ad, cihaza özgü özellik, durum ve kontrol.
class DeviceCard extends StatelessWidget {
  final SmartDevice device;
  final VoidCallback onChanged;
  final VoidCallback onTap;

  const DeviceCard({
    super.key,
    required this.device,
    required this.onChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _iconFor(device);
    final active = device.isActive;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: active
                    ? color.withValues(alpha: 0.15)
                    : Colors.grey.shade200,
                child: Icon(icon, color: active ? color : Colors.grey),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            device.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          device.isConnected ? Icons.wifi : Icons.wifi_off,
                          size: 14,
                          color: device.isConnected
                              ? Colors.blueGrey
                              : Colors.redAccent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(device.getPropertyLabel(),
                        style: TextStyle(color: Colors.grey.shade700)),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(Icons.circle,
                            size: 8,
                            color: active ? Colors.green : Colors.grey),
                        const SizedBox(width: 5),
                        Text('Status: ${device.getStatus()}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade700)),
                      ],
                    ),
                  ],
                ),
              ),
              _buildControl(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Cihaz tipine göre uygun kontrolü döndürür.
  Widget _buildControl(BuildContext context) {
    final d = device;
    if (d is SmartLight) {
      return Switch(
        value: d.isOn,
        onChanged: (_) {
          d.performAction();
          onChanged();
        },
      );
    }
    if (d is Thermostat) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton.outlined(
            tooltip: 'Decrease',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.remove, size: 18),
            onPressed: d.isOn
                ? () {
                    d.decreaseTemperature();
                    onChanged();
                  }
                : null,
          ),
          IconButton.outlined(
            tooltip: 'Increase',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.add, size: 18),
            onPressed: d.isOn
                ? () {
                    d.increaseTemperature();
                    onChanged();
                  }
                : null,
          ),
        ],
      );
    }
    if (d is SmartSpeaker) {
      return IconButton.filled(
        tooltip: d.isPlaying ? 'Pause' : 'Play',
        icon: Icon(d.isPlaying ? Icons.pause : Icons.play_arrow),
        onPressed: () {
          d.performAction();
          onChanged();
        },
      );
    }
    return const SizedBox.shrink();
  }

  static (IconData, Color) _iconFor(SmartDevice d) => switch (d) {
        SmartLight() => (Icons.lightbulb, Colors.amber.shade700),
        Thermostat() => (Icons.thermostat, Colors.deepOrange),
        SmartSpeaker() => (Icons.speaker, Colors.blue),
        _ => (Icons.devices_other, Colors.grey),
      };
}
