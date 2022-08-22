import 'package:hive/hive.dart';
part 'musicplayer.g.dart';

@HiveType(typeId: 1)
class MusicPlayer extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<int> songIds;

  MusicPlayer({
    required this.name,
    required this.songIds,
  });

  add(int id) async {
    songIds.add(id);
    save();
  }

  deleteData(int id) {
    songIds.remove(id);
    save();
  }

  bool isValueIn(int id) {
    return songIds.contains(id);
  }

  bool isadded(song) {
    final playlist = Hive.box<MusicPlayer>('playlistDb');
    if (playlist.values.contains(song.id)) {
      return true;
    }

    return false;
  }
}
