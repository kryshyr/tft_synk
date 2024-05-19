import 'package:flutter/material.dart';

import './utils/device_id.dart';

class CompViewTab extends StatefulWidget {
  @override
  _CompViewTabState createState() => _CompViewTabState();
}

class _CompViewTabState extends State<CompViewTab> {
  String _deviceID = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchDeviceID();
  }

  Future<void> _fetchDeviceID() async {
    try {
      String deviceID = await getDeviceID();
      setState(() {
        _deviceID = deviceID;
      });
    } catch (e) {
      setState(() {
        _deviceID = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Device ID: $_deviceID',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
    );
  }
}
