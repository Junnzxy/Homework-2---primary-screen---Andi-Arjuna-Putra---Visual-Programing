import 'package:flutter/material.dart';
import '../models/smart_device.dart';

class DeviceControlTile extends StatelessWidget {
  final SmartDevice device;
  final ValueChanged<bool> onToggle;

  const DeviceControlTile({
    super.key,
    required this.device,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: device.isOn
            ? primaryColor.withOpacity(0.08)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: device.isOn
              ? primaryColor.withOpacity(0.4)
              : Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor:
                    device.isOn ? primaryColor : Colors.grey[400],
                child: Icon(
                  device.icon,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              Switch(
                value: device.isOn,
                onChanged: onToggle,
                activeColor: primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                device.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: device.isOn ? Colors.black87 : Colors.grey[700],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    device.room,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${device.powerConsumptionWatts.toStringAsFixed(0)} W',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: device.isOn ? primaryColor : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
