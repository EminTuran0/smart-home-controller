import 'connectable.dart';

/// ABSTRACT CLASS: SmartDevice'tan doğrudan nesne oluşturulamaz.
/// Tüm akıllı cihazlar (SmartLight, Thermostat, SmartSpeaker) bu sınıfı
/// `extends` ile miras alır. Ayrıca Connectable interface'ini uygular.
abstract class SmartDevice implements Connectable {
  /// STATIC: Nesneye değil sınıfa ait değişken.
  /// Oluşturulan toplam cihaz sayısını tutar (ekranın altında gösterilir).
  static int totalDevices = 0;

  /// STATIC: Her cihaza benzersiz bir id vermek için kullanılan sayaç.
  static int _nextId = 1;

  final int id;
  final String name;
  bool _connected;

  /// Varsayılan (default) constructor.
  /// `this.name` ile parametre doğrudan alana atanır.
  SmartDevice(this.name, {bool connected = true})
      : id = _nextId++,
        // ignore: prefer_initializing_formals
        _connected = connected {
    totalDevices++; // her yeni nesnede static sayaç artar
  }

  /// Named constructor: ağa bağlı olmayan (offline) bir cihaz oluşturur.
  /// `this(...)` ile varsayılan constructor'a yönlendirir.
  SmartDevice.offline(String name) : this(name, connected: false);

  /// Cihaz tipinin okunabilir adı (ör. "Smart Light").
  String get typeName;

  // ---------------- ABSTRACT METOTLAR ----------------

  /// Cihazın mevcut durumunu döndürür (ör. "ON", "Heating", "Playing").
  String getStatus();

  /// Cihazın ana eylemini gerçekleştirir (aç/kapat, oynat/duraklat ...).
  void performAction();

  /// Cihaza özgü özelliğin metni (ör. "Brightness: 75%").
  String getPropertyLabel();

  /// Durum "aktif" mi? (UI'da yeşil/gri durum noktası için)
  bool get isActive;

  // ---------------- Connectable interface uygulaması ----------------

  @override
  bool get isConnected => _connected;

  @override
  void connect() => _connected = true;

  @override
  void disconnect() => _connected = false;

  // ---------------- Ortak metotlar ----------------

  /// Alt sınıfların `super.getInfo()` ile genişlettiği ortak bilgi.
  String getInfo() =>
      '#$id $typeName: $name (${isConnected ? 'Online' : 'Offline'})';

  /// Kart başlığında gösterilen metin.
  String get title => '$typeName: $name';

  /// STATIC metot: sayaçları sıfırlar (testlerde kullanılır).
  static void resetCounter() {
    totalDevices = 0;
    _nextId = 1;
  }

  @override
  String toString() => getInfo();
}
