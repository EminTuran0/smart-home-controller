import 'smart_device.dart';

/// INHERITANCE: SmartSpeaker, SmartDevice'ı miras alır.
class SmartSpeaker extends SmartDevice {
  bool isPlaying;
  int volume; // 0 - 100

  /// Default constructor.
  SmartSpeaker(super.name, {this.isPlaying = false, this.volume = 40});

  /// Named constructor: sessize alınmış ve ağa bağlı olmayan hoparlör.
  /// Üst sınıfın named constructor'ı `super.offline` ile çağrılır.
  SmartSpeaker.muted(super.name)
      : isPlaying = false,
        volume = 0,
        super.offline();

  @override
  String get typeName => 'Smart Speaker';

  @override
  String getStatus() => isPlaying ? 'Playing' : 'Paused';

  /// Ana eylem: oynat / duraklat. Bağlı değilse önce bağlanır.
  @override
  void performAction() {
    if (!isConnected) connect();
    isPlaying = !isPlaying;
  }

  @override
  String getPropertyLabel() => 'Volume: $volume%';

  @override
  bool get isActive => isPlaying;

  void setVolume(int volume) {
    // Parametre ile alan aynı isimde olduğu için `this` gereklidir.
    this.volume = volume.clamp(0, 100);
  }

  @override
  String getInfo() => '${super.getInfo()} | ${getPropertyLabel()}';
}
