import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_card.dart';
import '../utils/dio_client.dart';
import '../models/selection_state.dart'; // Import your SelectionState model
import '../utils/debouncer.dart';

class FigurePage extends StatefulWidget {
  const FigurePage({super.key});

  @override
  _FigurePageState createState() => _FigurePageState();
}

class _FigurePageState extends State<FigurePage> {
  List<dynamic> figures = [];
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
    fetchFigures('');
    searchController.addListener(() {
      if (searchController.text != previousText) {
        previousText = searchController.text;
        _debouncer.run(() {
          fetchFigures(searchController.text);
        });
      }
    });
  }

  Future<void> fetchFigures(String name) async {
    searchFocusNode.unfocus();
    setState(() {
      isLoading = true;
    });
    try {
      var url = '/api/v1/figures'; // Change to your API endpoint for figures
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        setState(() {
          figures = response.data['data'];
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
      appBar: const CustomAppBar(title: 'Chọn Nhân Vật'),
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
                          labelText: 'Tìm kiếm nhân vật',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    const Gap(20),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.done),
                      onPressed: () {
                        Navigator.pushNamed(context, '/quiz');
                      },
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: figures.length,
                  itemBuilder: (context, index) {
                    final figure = figures[index];
                    return CustomCard(
                      child: CheckboxListTile(
                        title: Text(
                          figure['name'],
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        value: Provider.of<SelectionState>(context)
                                .selectedFigure ==
                            figure['id'],
                        onChanged: (bool? value) {
                          Provider.of<SelectionState>(context, listen: false)
                              .setSelectedFigure(value! ? figure['id'] : null);
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
