# Smart Home Controller – BIM493 Assignment #2

A Flutter app for viewing and controlling smart home devices (lights, thermostats, speakers).

## Run

```bash
flutter pub get
flutter run
```

## Where each requirement is implemented

| Concept | Where |
|---|---|
| Class | `SmartDevice` (base), `SmartLight`, `Thermostat`, `SmartSpeaker` in `lib/models/` |
| Objects | `_HomeScreenState.initState` in `lib/main.dart` creates 6 devices (2 of each subclass); more can be added with the **+** button |
| Constructor | Default: `SmartLight(...)`, `Thermostat(...)`, `SmartSpeaker(...)`. Named: `SmartLight.off`, `Thermostat.eco`, `SmartSpeaker.muted`, `SmartDevice.offline` |
| Inheritance | All three subclasses `extends SmartDevice` |
| Abstraction | `abstract class SmartDevice` with the abstract methods `getStatus()`, `performAction()`, `getPropertyLabel()` and the getters `typeName`, `isActive` |
| Interface | `abstract interface class Connectable` (`connect()`, `disconnect()`, `isConnected`), implemented by `SmartDevice` |
| Mixin | `mixin Schedulable on SmartDevice`, used by `SmartLight` and `Thermostat` |
| static | `SmartDevice.totalDevices` (shown as "Total Devices"), `SmartDevice.resetCounter()`, `Thermostat.minTemperature/maxTemperature` |
| super | `super.name` constructor parameters, `super.offline()` in `SmartSpeaker.muted`, `super.getInfo()` in overridden `getInfo()` |
| this | `this.name`/`this.isOn` initializing formals, `this(...)` redirect in `SmartDevice.offline`, `this.volume = volume` in `setVolume` |

## UI

- Each card shows the device name, its property (brightness / temperature / volume) and its status.
- Controls: a switch for lights, −/+ buttons for thermostats, and play/pause for speakers.
- Tap a card to open details: connection toggle (Connectable), schedule (Schedulable), brightness/volume sliders, and thermostat power.
- The bottom bar shows `Total Devices`, read from the static `SmartDevice.totalDevices`.
