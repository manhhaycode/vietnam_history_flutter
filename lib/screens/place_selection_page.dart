import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:vietnam_history/screens/artifact_page.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_card.dart';
import '../utils/dio_client.dart';
import '../models/selection_state.dart'; // Import your SelectionState model
import '../utils/debouncer.dart';

class PlaceSelectionPage extends StatefulWidget {
  const PlaceSelectionPage({super.key});

  @override
  _PlaceSelectionPageState createState() => _PlaceSelectionPageState();
}

class _PlaceSelectionPageState extends State<PlaceSelectionPage> {
  List<dynamic> places = [];
  TextEditingController searchController = TextEditingController();
  Dio dio = DioClient.instance;
  final _debouncer = Debouncer(milliseconds: 700);
  bool isLoading = false;
  FocusNode searchFocusNode = FocusNode();
  String previousText = '';

  @override
  void dispose() {
    searchController.dispose();
    _debouncer.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchPlaces('');
    searchController.addListener(() {
      if (searchController.text != previousText) {
        previousText = searchController.text;
        _debouncer.run(() {
          fetchPlaces(searchController.text);
        });
      }
    });
  }

  Future<void> fetchPlaces(String name) async {
    searchFocusNode.unfocus();
    setState(() {
      isLoading = true;
    });
    try {
      var url = '/api/v1/places'; // Change to your API endpoint for places
      final response = await dio.get(url, queryParameters: {
        'page': '1',
        'pageSize': '10',
        'filter[name]': name,
      });
      if (response.statusCode == 200) {
        setState(() {
          places = response.data['data'];
          // map place and check if the selected place is in the list
          final selectedPlace =
              Provider.of<SelectionState>(context, listen: false)
                  .selectedFigure;
          if (selectedPlace != null &&
              !places.any((place) => place['id'] == selectedPlace)) {
            Provider.of<SelectionState>(context, listen: false)
                .setSelectedPlace(null);
          }
        });
      }
    } catch (e) {
      // Handle error if needed
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Chọn Địa Điểm'),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        focusNode: searchFocusNode,
                        decoration: const InputDecoration(
                          labelText: 'Tìm kiếm địa điểm',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    const Gap(20),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.done),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ArtifactPage(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    final place = places[index];
                    return CustomCard(
                      child: CheckboxListTile(
                        title: Text(
                          place['name'],
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        value: Provider.of<SelectionState>(context)
                                .selectedPlace ==
                            place['id'],
                        onChanged: (bool? value) {
                          Provider.of<SelectionState>(context, listen: false)
                              .setSelectedPlace(value! ? place['id'] : null);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          if (isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }
}
