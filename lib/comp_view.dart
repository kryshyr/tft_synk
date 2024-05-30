import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './detailed_view.dart';
import './firestore/firebase_service.dart';
import './utils/device_id.dart';
import 'app_constants.dart';
import 'player_page.dart';
import 'route_observer.dart';

class CompViewTab extends StatefulWidget {
  @override
  _CompViewTabState createState() => _CompViewTabState();
}

class _CompViewTabState extends State<CompViewTab> with RouteAware {
  final FirebaseService _firebaseService = FirebaseService();
  List<Composition> compositions = [];

  @override
  void initState() {
    super.initState();
    _fetchTeamComps();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
        this, ModalRoute.of(context)! as PageRoute<dynamic>);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _fetchTeamComps();
  }

  Future<void> _fetchTeamComps() async {
    String deviceId = await getDeviceID();
    CollectionReference compositionsRef = _firebaseService.firestore
        .collection('team_comps')
        .doc(deviceId)
        .collection('compositions');

    QuerySnapshot snapshot = await compositionsRef.get();

    List<Composition> fetchedCompositions = [];

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      List<dynamic> championPositions = data['championPositions'] ?? [];
      List<String> champions = championPositions.map((champion) {
        return champion['championName'] as String;
      }).toList();

      fetchedCompositions.add(Composition(name: doc.id, champions: champions));
    }

    setState(() {
      compositions = fetchedCompositions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Color.fromRGBO(200, 155, 60, 1),
            height: 1.0,
          ),
        ),
        title: const Row(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'MY COMPS',
                style: AppTextStyles.headline1BeaufortforLOL,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SummonerSearch(),
                  ),
                );
              },
              child: Image.asset(
                'assets/icons/user-search.png',
                width: 30,
                height: 30,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: compositions.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _fetchTeamComps,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: compositions.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailedViewPage(
                                title: compositions[index].name),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.primaryVariant,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                compositions[index].name.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.hintText,
                                ),
                              ),
                              SizedBox(height: 5),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: compositions[index]
                                      .champions
                                      .map((champion) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 1.0),
                                      child: Image.asset(
                                        'assets/champions/${champion}.png',
                                        width: 40,
                                        height: 40,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

class Composition {
  final String name;
  final List<String> champions;

  Composition({required this.name, required this.champions});
}
