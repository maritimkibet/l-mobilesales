/// @widget: Customer Map Screen
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Map view showing customer locations

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../controllers/customer_controller.dart';

class CustomerMapScreen extends ConsumerWidget {
  const CustomerMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerState = ref.watch(customerControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Locations'),
      ),
      body: customerState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: MapOptions(
                initialCenter: const LatLng(-1.286389, 36.817223),
                initialZoom: 11.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.leysco.l_mobilesales',
                ),
                MarkerLayer(
                  markers: customerState.customers.map((customer) {
                    return Marker(
                      point: LatLng(
                        customer.location.latitude,
                        customer.location.longitude,
                      ),
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(customer.name),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Contact: ${customer.contactPerson}'),
                                  Text('Phone: ${customer.phone}'),
                                  Text('Type: ${customer.type}'),
                                  Text('Category: ${customer.category}'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
    );
  }
}
