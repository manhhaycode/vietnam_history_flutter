import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:vietnam_history/components/custom_app_bar.dart';
import 'package:vietnam_history/screens/event_page.dart';

import 'package:vietnam_history/utils/debouncer.dart';
import '../models/selection_state.dart';
import '../utils/dio_client.dart'; // Make sure to import your Dio client
import '../components/custom_card.dart'; // Import your CustomCard component

class EraSelectionPage extends StatefulWidget {
  const EraSelectionPage({super.key});
  @override
  _EraSelectionPageState createState() => _EraSelectionPageState();
}

class _EraSelectionPageState extends State<EraSelectionPage> {
  List<dynamic> eras = [];
  List<dynamic> selectedEras = [];
  TextEditingController searchController = TextEditingController();
  final _dio = DioClient.instance;
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
    fetchEras('');
    searchController.addListener(() {
      if (searchController.text != previousText) {
        previousText = searchController.text;
        _debouncer.run(() {
          fetchEras(searchController.text);
        });
      }
    });
  }

  Future<void> fetchEras(String name) async {
    searchFocusNode.unfocus();
    setState(() {
      isLoading = true; // Set loading to true before the API call
    });

    try {
      var url = '/api/v1/eras'; // Change to your API endpoint for eras
      final response = await _dio.get(url, queryParameters: {
        'page': '1',
        'pageSize': '10',
        'filter[name]': name,
      });
      if (response.statusCode == 200) {
        setState(() {
          eras = response.data['data']; // Adjust based on your API response
          // map era and check if the selected era is in the list
          final selectedEra =
              Provider.of<SelectionState>(context, listen: false).selectedEra;
          if (selectedEra != null &&
              !eras.any((era) => era['id'] == selectedEra)) {
            Provider.of<SelectionState>(context, listen: false)
                .setSelectedEra(null);
          }
        });
      }
    } catch (e) {
      // Handle error if needed
    } finally {
      setState(() {
        isLoading = false; // Set loading to false after the API call
      });
    }
  }

  void chagePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EventPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Chọn thời kỳ'),
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
                          labelText: 'Tìm kiếm thời kỳ',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    const Gap(20),
                    Visibility(
                      visible:
                          Provider.of<SelectionState>(context).selectedEra !=
                              null,
                      child: IconButton.filledTonal(
                          icon: const Icon(Icons.done),
                          onPressed: () {
                            chagePage();
                          }),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: eras.length,
                  itemBuilder: (context, index) {
                    final era = eras[index];
                    return CustomCard(
                      child: CheckboxListTile(
                        title: Text(
                          era['name'],
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        value:
                            Provider.of<SelectionState>(context).selectedEra ==
                                era['id'],
                        onChanged: (bool? value) {
                          Provider.of<SelectionState>(context, listen: false)
                              .setSelectedEra(value! ? era['id'] : null);
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
