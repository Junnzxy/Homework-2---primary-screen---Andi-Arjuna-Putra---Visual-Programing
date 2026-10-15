import 'package:flutter/material.dart';

import '../models/smart_device.dart';
import '../widgets/category_filter_tabs.dart';
import '../widgets/device_control_tile.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/header_greeting.dart';
import '../widgets/quick_mode_selector.dart';
import '../widgets/stat_metric_card.dart';

class SmartHomeScreen extends StatefulWidget {
  final VoidCallback? onThemeToggle;
  final bool isDarkMode;

  const SmartHomeScreen({
    super.key,
    this.onThemeToggle,
    this.isDarkMode = false,
  });

  @override
  State<SmartHomeScreen> createState() => _SmartHomeScreenState();
}

class _SmartHomeScreenState extends State<SmartHomeScreen> {
  // Hoisted state
  String _activeMode = 'Home';
  String _selectedRoomCategory = 'All Rooms';
  String _searchQuery = '';
  bool _isStressTestMode = false;
  final TextEditingController _searchController = TextEditingController();

  static const List<SmartDevice> _defaultDevices = [
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

  late List<SmartDevice> _devices;

  final List<String> _modes = const ['Home', 'Away', 'Night', 'Eco'];
  final List<String> _roomCategories = const [
    'All Rooms',
    'Living Room',
    'Kitchen',
    'Bedroom',
    'Office',
  ];

  @override
  void initState() {
    super.initState();
    _devices = List.of(_defaultDevices);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Generates 500 items for long-list verification using .builder without shrinkWrap: true
  List<SmartDevice> _build500Devices() {
    final icons = [
      Icons.lightbulb_outline,
      Icons.ac_unit,
      Icons.tv,
      Icons.speaker,
      Icons.air,
      Icons.power,
      Icons.sensors,
      Icons.microwave,
    ];
    final rooms = ['Living Room', 'Kitchen', 'Bedroom', 'Office'];

    return List.generate(500, (i) {
      final room = rooms[i % rooms.length];
      final icon = icons[i % icons.length];
      return SmartDevice(
        id: 'stress_device_$i',
        name: 'Smart Device #${i + 1} ($room)',
        room: room,
        icon: icon,
        isOn: i % 3 == 0,
        powerConsumptionWatts: 20.0 + (i % 25) * 15.0,
      );
    });
  }

  void _toggleStressTestMode() {
    setState(() {
      _isStressTestMode = !_isStressTestMode;
      _devices = _isStressTestMode ? _build500Devices() : List.of(_defaultDevices);
    });
  }

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
        _devices = _devices
            .map((device) => device.copyWith(isOn: false))
            .toList();
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

  void _handleResetFilters() {
    setState(() {
      _selectedRoomCategory = 'All Rooms';
      _searchQuery = '';
      _searchController.clear();
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
      final matchesCategory =
          _selectedRoomCategory == 'All Rooms' ||
          device.room == _selectedRoomCategory;
      final matchesSearch =
          _searchQuery.isEmpty ||
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
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 720 && constraints.maxHeight >= 500;
          final isNarrowPhone = constraints.maxWidth <= 360;

          if (isTablet) {
            return _buildTabletLayout(context, constraints, filteredList);
          } else {
            return _buildMobileLayout(context, isNarrowPhone, filteredList);
          }
        },
      ),
    );
  }

  // ==========================================
  // MOBILE LAYOUT (< 720 dp or landscape phone)
  // Uses CustomScrollView with Slivers (No shrinkWrap: true)
  // ==========================================
  Widget _buildMobileLayout(
    BuildContext context,
    bool isNarrowPhone,
    List<SmartDevice> filteredList,
  ) {
    final tileAspectRatio = isNarrowPhone ? 0.88 : 1.08;

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverToBoxAdapter(
          child: HeaderGreeting(
            userName: 'Andi Arjuna',
            activeDeviceCount: _activeCount,
            onSearchChanged: _handleSearchChange,
            onNotificationTap: _handleNotificationTap,
            onThemeToggle: widget.onThemeToggle,
            isDarkMode: widget.isDarkMode,
            searchController: _searchController,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 18)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: StatMetricCard(
                    title: 'Current Power',
                    value: _totalPowerConsumptionKw.toStringAsFixed(2),
                    unit: 'kW',
                    icon: Icons.electric_bolt,
                    highlighted: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatMetricCard(
                    title: 'Active Devices',
                    value: '$_activeCount',
                    unit: 'devices',
                    icon: Icons.power,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 18)),
        SliverToBoxAdapter(
          child: QuickModeSelector(
            modes: _modes,
            activeMode: _activeMode,
            onModeSelected: _handleModeChange,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(
          child: CategoryFilterTabs(
            categories: _roomCategories,
            selectedCategory: _selectedRoomCategory,
            onCategorySelected: _handleCategoryChange,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Smart Devices (${filteredList.length})',
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FilterChip(
                      label: Text(_isStressTestMode ? '500 Items' : 'Sample'),
                      selected: _isStressTestMode,
                      onSelected: (_) => _toggleStressTestMode(),
                      visualDensity: VisualDensity.compact,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Mode: $_activeMode',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        if (filteredList.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyStateWidget(
              title: 'No devices found',
              message: _searchQuery.isNotEmpty
                  ? 'No devices matched "$_searchQuery" in $_selectedRoomCategory.'
                  : 'No devices found in room "$_selectedRoomCategory".',
              actionLabel: 'Reset Filters',
              onAction: _handleResetFilters,
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            sliver: SliverGrid.builder(
              itemCount: filteredList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: tileAspectRatio,
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
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 28)),
      ],
    );
  }

  // ==========================================
  // TABLET LAYOUT (>= 720 dp && height >= 500 dp)
  // Structural change: Dual-Pane Master-Detail Command Center
  // ==========================================
  Widget _buildTabletLayout(
    BuildContext context,
    BoxConstraints constraints,
    List<SmartDevice> filteredList,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final gridColumns = constraints.maxWidth >= 1050 ? 3 : 2;
    final sidebarWidth = constraints.maxWidth < 900 ? 280.0 : 320.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Control Sidebar
        SizedBox(
          width: sidebarWidth,
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              border: Border(
                right: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderGreeting(
                    userName: 'Andi Arjuna',
                    activeDeviceCount: _activeCount,
                    onSearchChanged: _handleSearchChange,
                    onNotificationTap: _handleNotificationTap,
                    onThemeToggle: widget.onThemeToggle,
                    isDarkMode: widget.isDarkMode,
                    searchController: _searchController,
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        StatMetricCard(
                          title: 'Current Power',
                          value: _totalPowerConsumptionKw.toStringAsFixed(2),
                          unit: 'kW',
                          icon: Icons.electric_bolt,
                          highlighted: true,
                        ),
                        const SizedBox(height: 12),
                        StatMetricCard(
                          title: 'Active Devices',
                          value: '$_activeCount',
                          unit: 'devices',
                          icon: Icons.power,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  QuickModeSelector(
                    modes: _modes,
                    activeMode: _activeMode,
                    onModeSelected: _handleModeChange,
                  ),
                  const SizedBox(height: 16),
                  CategoryFilterTabs(
                    categories: _roomCategories,
                    selectedCategory: _selectedRoomCategory,
                    onCategorySelected: _handleCategoryChange,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      color: colorScheme.surfaceContainerHigh,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Stress Test (500 items)',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Transform.scale(
                              scale: 0.85,
                              child: Switch(
                                value: _isStressTestMode,
                                onChanged: (_) => _toggleStressTestMode(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),

        // Right Column: Devices Grid / Empty State (Independently Scrollable)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 14.0,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Smart Devices',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Badge(
                            backgroundColor: colorScheme.primaryContainer,
                            textColor: colorScheme.onPrimaryContainer,
                            label: Text('${filteredList.length}'),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_selectedRoomCategory != 'All Rooms' ||
                              _searchQuery.isNotEmpty)
                            TextButton.icon(
                              onPressed: _handleResetFilters,
                              icon: const Icon(Icons.clear_all, size: 16),
                              label: const Text('Reset'),
                              style: TextButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Mode: $_activeMode',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: filteredList.isEmpty
                    ? EmptyStateWidget(
                        title: 'No devices found',
                        message: _searchQuery.isNotEmpty
                            ? 'No devices matched "$_searchQuery" in $_selectedRoomCategory.'
                            : 'No devices found in room "$_selectedRoomCategory".',
                        actionLabel: 'Reset Filters',
                        onAction: _handleResetFilters,
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(18.0),
                        itemCount: filteredList.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridColumns,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.15,
                        ),
                        itemBuilder: (context, index) {
                          final device = filteredList[index];
                          return DeviceControlTile(
                            key: ValueKey(device.id),
                            device: device,
                            onToggle: (isOn) =>
                                _handleDeviceToggle(device.id, isOn),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
