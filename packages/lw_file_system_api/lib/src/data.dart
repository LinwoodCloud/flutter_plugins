import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'data.mapper.dart';

@MappableClass()
class ArchiveState with ArchiveStateMappable {
  final Map<String, Uint8List> added;
  final Set<String> removed;

  const ArchiveState({this.added = const {}, this.removed = const {}});
}

abstract class ArchiveData<T> {
  final Archive archive;
  final ArchiveState state;

  ArchiveData(this.archive, {this.state = const ArchiveState()});

  ArchiveData.empty()
      : archive = Archive(),
        state = ArchiveState();

  ArchiveData.fromBytes(List<int> bytes)
      : archive = ZipDecoder().decodeBytes(bytes),
        state = ArchiveState();

  Archive export() {
    final archive = Archive();
    for (final entry in state.added.entries) {
      archive.addFile(ArchiveFile(entry.key, entry.value.length, entry.value));
    }
    for (final file in this.archive) {
      if (state.removed.contains(file.name) ||
          state.added.containsKey(file.name)) {
        continue;
      }
      archive.addFile(file);
    }
    return archive;
  }

  List<int>? exportBytes() {
    return ZipEncoder().encode(export());
  }

  Uint8List? getAsset(String name) {
    final added = state.added[name];
    if (added != null) {
      return added;
    }
    if (state.removed.contains(name)) {
      return null;
    }
    final file = archive.findFile(name);
    if (file == null) {
      return null;
    }
    return file.content;
  }

  T _updateState(ArchiveState state);

  T addAsset(String name, Uint8List data) => _updateState(state.copyWith(
        added: {...state.added, name: data},
        removed: state.removed..remove(name),
      ));
  T removeAsset(String name) => removeAssets([name]);
  T removeAssets(Iterable<String> names) =>
      _updateState(state.copyWith(removed: {...state.removed, ...names}));
}

class SimpleArchiveData extends ArchiveData<SimpleArchiveData> {
  SimpleArchiveData(super.archive, {super.state});
  SimpleArchiveData.empty() : super.empty();
  SimpleArchiveData.fromBytes(List<int> bytes) : super.fromBytes(bytes);

  @override
  SimpleArchiveData _updateState(ArchiveState state) =>
      SimpleArchiveData(archive, state: state);
}
