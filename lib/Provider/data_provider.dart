import 'package:flutter/cupertino.dart';
import '../Models/data_model.dart';
import '../Services/api_service.dart';

enum LoadMoreStatus { LOADING, STABLE }

/*
Class : DataProvider
Description : used for state management Provider - ChangeNotifier
 */
class DataProvider with ChangeNotifier {
  late APIService _apiService;
  late DataModel _dataFetcher;
  int totalPages = 0;
  int pageSize = 10;

  List<GameData> get allUsers => _dataFetcher.data;
  String get cursorData => _dataFetcher.cursor;
  double get totalRecords => _dataFetcher.totalRecords.toDouble();

  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;
  getLoadMoreStatus() => _loadMoreStatus;

  DataProvider() {
    _initStreams();
  }

  void _initStreams() {
    _apiService = APIService();
    _dataFetcher = DataModel(totalRecords:0,data: [],cursor: "");
  }

  void resetStreams() {
    _initStreams();
  }

  // fetch new data
  fetchAllUsers() async {
    // if ((totalPages == 0) || pageNumber <= totalPages) {
      DataModel itemModel =
      await _apiService.getData(_dataFetcher.cursor);

      if (_dataFetcher.data.isEmpty) {
        // t
        _dataFetcher = itemModel;
      } else {
        _dataFetcher.data.addAll(itemModel.data);
        _dataFetcher.cursor=itemModel.cursor;
        _dataFetcher = _dataFetcher;
        setLoadingState(LoadMoreStatus.STABLE);
      }

      notifyListeners();

  }

  // Used for Setting loading state to LOADING/STABLE for bottom loading
  // indicator in infinte scroll list
  setLoadingState(LoadMoreStatus loadMoreStatus) {
    _loadMoreStatus = loadMoreStatus;
    notifyListeners();
  }
}