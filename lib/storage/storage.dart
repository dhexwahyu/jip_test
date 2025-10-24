
import '../model/base.dart';
import 'base_storage.dart';

class Storage {
  static Storage instance = Storage();
  Map<Type, Future<BaseStorage>> storages = {};
  Future<BaseStorage<T>> resolve<T extends BaseModel<T>>() async {
    if (!storages.containsKey(T)) {
      final storage = BaseStorage.resolve<T>();
      storages[T] = storage;
    }
    return await (storages[T] as Future<BaseStorage<T>>);
  }
}

Future<BaseStorage<T>> getStorage<T extends BaseModel<T>>() {
  return Storage.instance.resolve();
}
