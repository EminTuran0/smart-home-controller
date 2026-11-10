import 'schedulable.dart';
import 'smart_device.dart';

/// INHERITANCE + MIXIN: Thermostat, SmartDevice'ı miras alır ve
/// Schedulable mixin'ini kullanır.
class Thermostat extends SmartDevice with Schedulable {
  /// STATIC sabitler: tüm termostatlar için ortak sınırlar.
  static const int minTemperature = 10;
  static const int maxTemperature = 30;

  int targetTemperature;
  final int roomTemperature;
  bool isOn;

  /// Default constructor.
  Thermostat(
    super.name, {
    this.targetTemperature = 22,
    this.roomTemperature = 20,
    this.isOn = true,
  });

  /// Named constructor: ekonomik (eco) modda başlayan termostat.
  Thermostat.eco(super.name)
      : targetTemperature = 18,
        roomTemperature = 20,
        isOn = true;

  @override
  String get typeName => 'Thermostat';

  @override
  String getStatus() {
    if (!isOn) return 'OFF';
    if (targetTemperature > roomTemperature) return 'Heating';
    if (targetTemperature < roomTemperature) return 'Cooling';
    return 'Idle';
  }

  /// Ana eylem: termostatı açar / kapatır.
  @override
  void performAction() => isOn = !isOn;

  @override
  String getPropertyLabel() => 'Temperature: $targetTemperature°C';

  @override
  bool get isActive => isOn && getStatus() != 'Idle';

  void increaseTemperature() {
    if (targetTemperature < maxTemperature) targetTemperature++;
  }

  void decreaseTemperature() {
    if (targetTemperature > minTemperature) targetTemperature--;
  }

  @override
  String getInfo() =>
      '${super.getInfo()} | ${getPropertyLabel()} (room: $roomTemperature°C)';
}
