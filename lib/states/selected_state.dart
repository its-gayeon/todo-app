import 'package:flutter/material.dart';

enum NavIDs { today, upcoming, all, topic0 }

class SelectedState extends ChangeNotifier {
  List<int> _selectedTopics = [];
  List<int> get selectedTopics => _selectedTopics;

  bool todaySelected = true;
  bool upcomingSelected = false;
  bool allSelected = false;

  int topicIDlength = 0;

  void toggleSection(int id) {
    // if already in list, remove
    var len = selectedTopics.length;
    for (int i = 0; i < len; i++) {
      if (selectedTopics[i] == id) {
        selectedTopics.removeAt(i);

        // if all is de-selected remove all the topics
        if (id == NavIDs.all.index) {
          selectedTopics.clear();
        }

        // if id 2(All) is selected when topic is removed, remove that too
        if (id >= NavIDs.topic0.index) {
          selectedTopics.remove(NavIDs.all.index);
        }

        notifyListeners();
        return;
      }
    }

    // id 0 (today) & id 1 (upcoming) -> exclusive
    if (id == NavIDs.today.index || id == NavIDs.upcoming.index) {
      selectedTopics.clear();
    }

    // id 2 (All)
    else if (id == 2) {
      selectedTopics.remove(NavIDs.today.index);
      selectedTopics.remove(NavIDs.upcoming.index);

      // add all the other topics
      for (int i = 0; i < topicIDlength; i++) {
        if (!selectedTopics.contains(NavIDs.topic0.index + i)) {
          selectedTopics.add(NavIDs.topic0.index + i);
        }
      }
    }

    // add the selected topic
    selectedTopics.add(id);

    if (id != NavIDs.today.index &&
        selectedTopics.contains(NavIDs.today.index)) {
      selectedTopics.remove(NavIDs.today.index);
    }
    if (id != NavIDs.upcoming.index &&
        selectedTopics.contains(NavIDs.upcoming.index)) {
      selectedTopics.remove(NavIDs.upcoming.index);
    }

    notifyListeners();
  }

  void setTopicLength(int len) {
    topicIDlength = len;
  }
}
