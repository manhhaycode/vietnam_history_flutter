import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:vietnam_history/screens/figure_page.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_card.dart';
import '../utils/dio_client.dart';
import '../models/selection_state.dart'; // Import your SelectionState model
import '../utils/debouncer.dart';

class ArtifactPage extends StatefulWidget {
  const ArtifactPage({super.key});

  @override
  _ArtifactPageState createState() => _ArtifactPageState();
}

class _ArtifactPageState extends State<ArtifactPage> {
  List<dynamic> artifacts = [];
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
    fetchArtifacts('');
    searchController.addListener(() {
      if (searchController.text != previousText) {
        previousText = searchController.text;
        _debouncer.run(() {
          fetchArtifacts(searchController.text);
        });
      }
    });
  }

  Future<void> fetchArtifacts(String name) async {
    searchFocusNode.unfocus();
    setState(() {
      isLoading = true;
    });
    try {
      var url =
          '/api/v1/artifacts'; // Change to your API endpoint for artifacts
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        setState(() {
          artifacts = response.data['data'];
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
      appBar: const CustomAppBar(title: 'Chọn Di Vật'),
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
                          labelText: 'Tìm kiếm di vật',
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
                            builder: (context) => const FigurePage(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: artifacts.length,
                  itemBuilder: (context, index) {
                    final artifact = artifacts[index];
                    return CustomCard(
                      child: CheckboxListTile(
                        title: Text(
                          artifact['name'],
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        value: Provider.of<SelectionState>(context)
                                .selectedArtifact ==
                            artifact['id'],
                        onChanged: (bool? value) {
                          Provider.of<SelectionState>(context, listen: false)
                              .setSelectedArtifact(
                                  value! ? artifact['id'] : null);
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
