/// INTERFACE: Dart'ta interface, `implements` ile uygulanan bir sözleşmedir.
/// Bu interface'i uygulayan her sınıf aşağıdaki üyelerin hepsini
/// kendisi tanımlamak zorundadır.
abstract interface class Connectable {
  /// Cihaz ağa bağlı mı?
  bool get isConnected;

  /// Cihazı ev ağına bağlar.
  void connect();

  /// Cihazın ağ bağlantısını keser.
  void disconnect();
}
