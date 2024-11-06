import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:vietnam_history/screens/topic_selection_page.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_card.dart';
import '../utils/dio_client.dart';
import '../models/selection_state.dart'; // Import your SelectionState model
import '../utils/debouncer.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<dynamic> events = [];
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
    fetchEvents('');
    searchController.addListener(() {
      if (searchController.text != previousText) {
        previousText = searchController.text;
        _debouncer.run(() {
          fetchEvents(searchController.text);
        });
      }
    });
  }

  Future<void> fetchEvents(String name) async {
    searchFocusNode.unfocus();
    setState(() {
      isLoading = true;
    });
    try {
      var url = '/api/v1/events'; // Change to your API endpoint for events
      final response = await dio.get(url, queryParameters: {
        'page': '1',
        'pageSize': '10',
        'filter[name]': name,
      });
      if (response.statusCode == 200) {
        setState(() {
          events = response.data['data'];
          // map event and check if the selected event is in the list
          final selectedEvent =
              Provider.of<SelectionState>(context, listen: false).selectedEvent;
          if (selectedEvent != null &&
              !events.any((era) => era['id'] == selectedEvent)) {
            Provider.of<SelectionState>(context, listen: false)
                .setSelectedEvent(null);
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
      appBar: const CustomAppBar(title: 'Chọn Sự Kiện'),
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
                          labelText: 'Tìm kiếm sự kiện',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    const Gap(20),
                    Visibility(
                      visible:
                          Provider.of<SelectionState>(context).selectedEvent !=
                              null,
                      child: IconButton.filledTonal(
                        icon: const Icon(Icons.done),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TopicSelectionPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return CustomCard(
                      child: CheckboxListTile(
                        title: Text(
                          event['name'],
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        value: Provider.of<SelectionState>(context)
                                .selectedEvent ==
                            event['id'],
                        onChanged: (bool? value) {
                          Provider.of<SelectionState>(context, listen: false)
                              .setSelectedEvent(value! ? event['id'] : null);
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
