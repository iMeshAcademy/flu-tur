class Config {
  final Map<String, String> _modelStoreConfig = {"InventoryModel": "JsonStore"};
  static final Config _instance = new Config._();
  Config._();

  factory Config() {
    return _instance;
  }

  String getModelStore(String modelName) {
    return _modelStoreConfig.containsKey(modelName)
        ? _modelStoreConfig[modelName]
        : '';
  }
}
