import 'package:flutter/foundation.dart';

class SelectionState with ChangeNotifier {
  String? selectedTopic;
  String? selectedEvent;
  String? selectedEra;
  String? selectedFigure;
  String? selectedArtifact;
  String? selectedPlace;

  void setSelectedTopic(String? topic) {
    selectedTopic = topic;
    notifyListeners();
  }

  void setSelectedEvent(String? event) {
    selectedEvent = event;
    notifyListeners();
  }

  void setSelectedEra(String? era) {
    selectedEra = era;
    notifyListeners();
  }

  void setSelectedFigure(String? figure) {
    selectedFigure = figure;
    notifyListeners();
  }

  void setSelectedArtifact(String? artifact) {
    selectedArtifact = artifact;
    notifyListeners();
  }

  void setSelectedPlace(String? place) {
    selectedPlace = place;
    notifyListeners();
  }
}
