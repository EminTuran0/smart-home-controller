import 'package:flutter/material.dart';

import '../models/schedulable.dart';
import '../models/smart_device.dart';
import '../models/smart_light.dart';
import '../models/smart_speaker.dart';
import '../models/thermostat.dart';

/// Karta dokunulduğunda açılan detay paneli.
/// - Connectable interface'i: bağlantı aç/kapat
/// - Schedulable mixin'i: zamanlama ayarla
/// - Cihaza özgü ayar: parlaklık / ses / termostat gücü
class DeviceDetailsSheet extends StatefulWidget {
  final SmartDevice device;
  final VoidCallback onChanged;

  const DeviceDetailsSheet(
      {super.key, required this.device, required this.onChanged});

  @override
  State<DeviceDetailsSheet> createState() => _DeviceDetailsSheetState();
}

class _DeviceDetailsSheetState extends State<DeviceDetailsSheet> {
  void _update(VoidCallback fn) {
    setState(fn);
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.device;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(d.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(d.getInfo(),
                style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
            const Divider(height: 24),

            // Connectable interface
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Icon(d.isConnected ? Icons.wifi : Icons.wifi_off),
              title: const Text('Connected'),
              value: d.isConnected,
              onChanged: (v) => _update(() => v ? d.connect() : d.disconnect()),
            ),

            // Cihaza özgü ayarlar
            if (d is SmartLight) ...[
              Text(d.getPropertyLabel()),
              Slider(
                value: d.brightness.toDouble(),
                max: 100,
                divisions: 20,
                label: '${d.brightness}%',
                onChanged: (v) => _update(() => d.setBrightness(v.round())),
              ),
            ],
            if (d is SmartSpeaker) ...[
              Text(d.getPropertyLabel()),
              Slider(
                value: d.volume.toDouble(),
                max: 100,
                divisions: 20,
                label: '${d.volume}%',
                onChanged: (v) => _update(() => d.setVolume(v.round())),
              ),
            ],
            if (d is Thermostat)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: const Icon(Icons.power_settings_new),
                title: const Text('Power'),
                subtitle: Text(
                    'Range ${Thermostat.minTemperature}-${Thermostat.maxTemperature}°C'),
                value: d.isOn,
                onChanged: (_) => _update(d.performAction),
              ),

            // Schedulable mixin (sadece bu mixin'i kullanan cihazlarda)
            if (d is Schedulable) _buildSchedule(context, d),
          ],
        ),
      ),
    );
  }

  Widget _buildSchedule(BuildContext context, Schedulable s) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.schedule),
      title: Text(s.scheduleInfo),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (s.hasSchedule)
            IconButton(
              tooltip: 'Clear schedule',
              icon: const Icon(Icons.close),
              onPressed: () => _update(s.clearSchedule),
            ),
          TextButton(
            onPressed: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 7, minute: 30),
              );
              if (time != null && mounted) {
                _update(() => s.setSchedule(_format(time)));
              }
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  static String _format(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}
