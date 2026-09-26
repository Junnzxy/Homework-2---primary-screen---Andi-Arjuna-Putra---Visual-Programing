import 'package:flutter/material.dart';
import '../models/smart_device.dart';
import '../widgets/header_greeting.dart';
import '../widgets/stat_metric_card.dart';
import '../widgets/quick_mode_selector.dart';
import '../widgets/category_filter_tabs.dart';
import '../widgets/device_control_tile.dart';

class SmartHomeScreen extends StatefulWidget {
  const SmartHomeScreen({super.key});

  @override
  State<SmartHomeScreen> createState() => _SmartHomeScreenState();
}

class _SmartHomeScreenState extends State<SmartHomeScreen> {
  // Hoisted state
  String _activeMode = 'Home';
  String _selectedRoomCategory = 'All Rooms';
  String _searchQuery = '';

  List<SmartDevice> _devices = const [
    SmartDevice(
      id: 'd1',
      name: 'Main Living AC',
      room: 'Living Room',
      icon: Icons.ac_unit,
      isOn: true,
      powerConsumptionWatts: 1200.0,
    ),
    SmartDevice(
      id: 'd2',
      name: 'Ambient Ceiling Light',
      room: 'Living Room',
      icon: Icons.lightbulb_outline,
      isOn: true,
      powerConsumptionWatts: 45.0,
    ),
    SmartDevice(
      id: 'd3',
      name: 'Smart Oven',
      room: 'Kitchen',
      icon: Icons.microwave,
      isOn: false,
      powerConsumptionWatts: 1500.0,
    ),
    SmartDevice(
      id: 'd4',
      name: 'Kitchen Exhaust Fan',
      room: 'Kitchen',
      icon: Icons.air,
      isOn: false,
      powerConsumptionWatts: 80.0,
    ),
    SmartDevice(
      id: 'd5',
      name: 'Master Bed Lamp',
      room: 'Bedroom',
      icon: Icons.bedtime,
      isOn: false,
      powerConsumptionWatts: 15.0,
    ),
    SmartDevice(
      id: 'd6',
      name: 'Office Monitor Array',
      room: 'Office',
      icon: Icons.desktop_windows,
      isOn: true,
      powerConsumptionWatts: 150.0,
    ),
  ];

  final List<String> _modes = const ['Home', 'Away', 'Night', 'Eco'];
  final List<String> _roomCategories = const [
    'All Rooms',
    'Living Room',
    'Kitchen',
    'Bedroom',
    'Office',
  ];

  // Callback handlers for state modification
  void _handleDeviceToggle(String deviceId, bool isOn) {
    setState(() {
      _devices = _devices.map((device) {
        if (device.id == deviceId) {
          return device.copyWith(isOn: isOn);
        }
        return device;
      }).toList();
    });
  }

  void _handleModeChange(String mode) {
    setState(() {
      _activeMode = mode;
      if (mode == 'Away') {
        _devices =
            _devices.map((device) => device.copyWith(isOn: false)).toList();
      } else if (mode == 'Eco') {
        _devices = _devices.map((device) {
          if (device.powerConsumptionWatts > 500) {
            return device.copyWith(isOn: false);
          }
          return device;
        }).toList();
      }
    });
  }

  void _handleCategoryChange(String category) {
    setState(() {
      _selectedRoomCategory = category;
    });
  }

  void _handleSearchChange(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _handleNotificationTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Active devices running: ${_devices.where((d) => d.isOn).length}',
        ),
      ),
    );
  }

  // Derived state calculations
  List<SmartDevice> get _filteredDevices {
    return _devices.where((device) {
      final matchesCategory = _selectedRoomCategory == 'All Rooms' ||
          device.room == _selectedRoomCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          device.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          device.room.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  int get _activeCount => _devices.where((d) => d.isOn).length;

  double get _totalPowerConsumptionKw {
    final totalWatts = _devices
        .where((d) => d.isOn)
        .fold(0.0, (sum, item) => sum + item.powerConsumptionWatts);
    return totalWatts / 1000.0;
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredDevices;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderGreeting(
              userName: 'Alex Morgan',
              activeDeviceCount: _activeCount,
              onSearchChanged: _handleSearchChange,
              onNotificationTap: _handleNotificationTap,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  StatMetricCard(
                    title: 'Active Devices',
                    value: '$_activeCount',
                    unit: 'devices',
                    icon: Icons.power,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  StatMetricCard(
                    title: 'Current Power',
                    value: _totalPowerConsumptionKw.toStringAsFixed(2),
                    unit: 'kW',
                    icon: Icons.electric_bolt,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            QuickModeSelector(
              modes: _modes,
              activeMode: _activeMode,
              onModeSelected: _handleModeChange,
            ),
            const SizedBox(height: 20),
            CategoryFilterTabs(
              categories: _roomCategories,
              selectedCategory: _selectedRoomCategory,
              onCategorySelected: _handleCategoryChange,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Smart Devices (${filteredList.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Mode: $_activeMode',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (filteredList.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(
                  child: Text(
                    'No devices found matching your filter.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final device = filteredList[index];
                  return DeviceControlTile(
                    key: ValueKey(device.id),
                    device: device,
                    onToggle: (isOn) => _handleDeviceToggle(device.id, isOn),
                  );
                },
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
