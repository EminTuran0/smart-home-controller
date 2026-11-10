import 'schedulable.dart';
import 'smart_device.dart';

/// INHERITANCE: SmartLight, SmartDevice'ı miras alır.
/// MIXIN: Schedulable ile zamanlama özelliği kazanır.
class SmartLight extends SmartDevice with Schedulable {
  bool isOn;
  int brightness; // 0 - 100

  /// Default constructor: `this.` ile alanlar doğrudan atanır,
  /// `super.name` ile parametre üst sınıfın constructor'ına iletilir.
  SmartLight(super.name, {this.isOn = true, this.brightness = 75});

  /// Named constructor: kapalı ve parlaklığı 0 olan bir lamba oluşturur.
  SmartLight.off(super.name)
      : isOn = false,
        brightness = 0;

  @override
  String get typeName => 'Smart Light';

  @override
  String getStatus() => isOn ? 'ON' : 'OFF';

  /// Ana eylem: lambayı açar / kapatır.
  @override
  void performAction() {
    isOn = !isOn;
    // Açılınca parlaklık 0 ise makul bir değere getir.
    if (isOn && brightness == 0) brightness = 50;
  }

  @override
  String getPropertyLabel() => 'Brightness: ${isOn ? brightness : 0}%';

  @override
  bool get isActive => isOn;

  void setBrightness(int brightness) {
    // Parametre ile alan aynı isimde olduğu için `this` gereklidir.
    this.brightness = brightness.clamp(0, 100);
    isOn = this.brightness > 0;
  }

  /// `super` ile üst sınıftaki metodu genişletme.
  @override
  String getInfo() => '${super.getInfo()} | ${getPropertyLabel()}';
}
