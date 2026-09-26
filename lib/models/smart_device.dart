import 'package:flutter/material.dart';

class SmartDevice {
  final String id;
  final String name;
  final String room;
  final IconData icon;
  final bool isOn;
  final double powerConsumptionWatts;

  const SmartDevice({
    required this.id,
    required this.name,
    required this.room,
    required this.icon,
    this.isOn = false,
    required this.powerConsumptionWatts,
  });

  SmartDevice copyWith({
    String? id,
    String? name,
    String? room,
    IconData? icon,
    bool? isOn,
    double? powerConsumptionWatts,
  }) {
    return SmartDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      room: room ?? this.room,
      icon: icon ?? this.icon,
      isOn: isOn ?? this.isOn,
      powerConsumptionWatts:
          powerConsumptionWatts ?? this.powerConsumptionWatts,
    );
  }
}
