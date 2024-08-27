import 'package:flutter/material.dart';

enum NavIDs { today, upcoming, all, topic0 }

class SelectedState extends ChangeNotifier {
  List<int> _selectedSection = [];
  List<int> get selectedSection => _selectedSection;

  int topicIDlength = 0;

  void toggleSection(int id) {
    // if already in list, remove
    var len = selectedSection.length;
    for (int i = 0; i < len; i++) {
      if (selectedSection[i] == id) {
        selectedSection.removeAt(i);

        // if id 2(All) is selected when topic is removed, remove that too
        if (id >= NavIDs.topic0.index) {
          selectedSection.remove(NavIDs.all.index);
        }

        notifyListeners();
        return;
      }
    }

    // id 0 (today) & id 1 (upcoming) -> exclusive
    if (id == NavIDs.today.index || id == NavIDs.upcoming.index) {
      selectedSection.clear();
    }

    // id 2 (All)
    else if (id == 2) {
      selectedSection.remove(NavIDs.today.index);
      selectedSection.remove(NavIDs.upcoming.index);

      // add all the other topics 커스텀
      for (int i = 0; i < topicIDlength; i++) {
        if (!selectedSection.contains(NavIDs.topic0.index + i)) {
          selectedSection.add(NavIDs.topic0.index + i);
        }
      }
    }

    // add the selected topic
    selectedSection.add(id);
    notifyListeners();
  }

  void setTopicLength(int len) {
    topicIDlength = len;
  }
}
