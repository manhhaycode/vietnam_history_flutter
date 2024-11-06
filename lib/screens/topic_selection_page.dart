import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:vietnam_history/models/selection_state.dart';
import 'package:vietnam_history/screens/place_selection_page.dart';
import 'package:vietnam_history/utils/debouncer.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_card.dart';
import '../utils/dio_client.dart';

class TopicSelectionPage extends StatefulWidget {
  const TopicSelectionPage({super.key});

  @override
  _TopicSelectionPageState createState() => _TopicSelectionPageState();
}

class _TopicSelectionPageState extends State<TopicSelectionPage> {
  List<dynamic> topics = [];
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
    fetchTopics('');
    searchController.addListener(() {
      if (searchController.text != previousText) {
        previousText = searchController.text;
        _debouncer.run(() {
          fetchTopics(searchController.text);
        });
      }
    });
  }

  Future<void> fetchTopics(String name) async {
    searchFocusNode.unfocus();
    setState(() {
      isLoading = true;
    });
    try {
      var url = '/api/v1/topics';
      final response = await dio.get(url, queryParameters: {
        'page': '1',
        'pageSize': '10',
        'filter[name]': name,
      });
      if (response.statusCode == 200) {
        setState(() {
          topics = response.data['data'];
          // map topics and check if the selected topic is in the list
          final selectedTopic =
              Provider.of<SelectionState>(context, listen: false).selectedTopic;
          if (selectedTopic != null &&
              !topics.any((topic) => topic['id'] == selectedTopic)) {
            Provider.of<SelectionState>(context, listen: false)
                .setSelectedTopic(null);
          }
        });
      }
    } catch (e) {
      // do nothing
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void chagePage(String topicId) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: 'Chọn Chủ Đề'),
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
                              labelText: 'Tìm kiếm chủ đề',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        const Gap(20),
                        // display the button only when a topic is selected
                        IconButton.filledTonal(
                          icon: const Icon(Icons.done),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PlaceSelectionPage(),
                            ),
                          ),
                        )
                      ],
                    )),
                Expanded(
                  child: ListView.builder(
                    itemCount: topics.length,
                    itemBuilder: (context, index) {
                      final topic = topics[index];
                      return CustomCard(
                        child: CheckboxListTile(
                          title: Text(
                            topic['name'],
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          value: Provider.of<SelectionState>(context)
                                  .selectedTopic ==
                              topic['id'],
                          onChanged: (bool? value) {
                            Provider.of<SelectionState>(context, listen: false)
                                .setSelectedTopic(value! ? topic['id'] : null);
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
        ));
  }
}
