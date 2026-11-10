import 'smart_device.dart';

/// MIXIN: Kalıtım zinciri kurmadan birden fazla sınıfa ortak davranış ekler.
/// `on SmartDevice` sayesinde yalnızca SmartDevice alt sınıflarında
/// kullanılabilir ve SmartDevice üyelerine (ör. name) erişebilir.
mixin Schedulable on SmartDevice {
  String? _scheduledTime;

  String? get scheduledTime => _scheduledTime;

  bool get hasSchedule => _scheduledTime != null;

  /// Cihaz için bir zamanlama (ör. "07:30") ayarlar.
  void setSchedule(String time) {
    _scheduledTime = time;
  }

  void clearSchedule() {
    _scheduledTime = null;
  }

  String get scheduleInfo =>
      hasSchedule ? '$name: scheduled at $_scheduledTime' : 'No schedule';
}
