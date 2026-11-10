import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_home_controller/main.dart';
import 'package:smart_home_controller/models/smart_device.dart';
import 'package:smart_home_controller/models/smart_light.dart';
import 'package:smart_home_controller/models/smart_speaker.dart';
import 'package:smart_home_controller/models/thermostat.dart';

void main() {
  setUp(SmartDevice.resetCounter);

  test('static counter counts created devices', () {
    SmartLight('A');
    Thermostat.eco('B');
    SmartSpeaker.muted('C');
    expect(SmartDevice.totalDevices, 3);
  });

  test('device actions and status', () {
    final light = SmartLight.off('Kitchen');
    expect(light.getStatus(), 'OFF');
    light.performAction();
    expect(light.getStatus(), 'ON');
    expect(light.brightness, 50);

    final t = Thermostat('Bedroom', targetTemperature: 24);
    expect(t.getStatus(), 'Heating');
    t.decreaseTemperature();
    t.decreaseTemperature();
    t.decreaseTemperature();
    t.decreaseTemperature();
    t.decreaseTemperature();
    expect(t.getStatus(), 'Cooling');
    t.setSchedule('07:30');
    expect(t.hasSchedule, isTrue);

    final s = SmartSpeaker.muted('Office');
    expect(s.isConnected, isFalse);
    s.performAction();
    expect(s.isConnected, isTrue);
    expect(s.getStatus(), 'Playing');
  });

  testWidgets('home screen shows devices and total', (tester) async {
    await tester.pumpWidget(const SmartHomeApp());

    expect(find.text('Smart Home Controller'), findsOneWidget);
    expect(find.text('Smart Light: Living Room'), findsOneWidget);
    expect(find.text('Thermostat: Bedroom'), findsOneWidget);
    expect(find.text('Smart Speaker: Kitchen'), findsOneWidget);
    expect(find.text('Total Devices: 6'), findsOneWidget);

    // Bedroom thermostat: 24 -> 25
    await tester.tap(find.byTooltip('Increase').first);
    await tester.pump();
    expect(find.text('Temperature: 25°C'), findsOneWidget);

    // Add a device -> static counter increases
    await tester.tap(find.byTooltip('Add device'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Smart Light'));
    await tester.pumpAndSettle();
    expect(find.text('Total Devices: 7'), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
    expect(find.byIcon(Icons.lightbulb), findsWidgets);
  });
}
