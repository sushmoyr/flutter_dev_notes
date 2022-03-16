import 'dart:async';

import 'package:flutter/cupertino.dart';

abstract class ViewModel extends ChangeNotifier {
  bool _isLoading = false;
  set isLoading(value) {
    _isLoading = value;
    scheduleMicrotask(() {
      if (!_isDisposed) {
        notifyListeners();
      }
    });
  }

  get isLoading => _isLoading;
  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;
  bool _isInitializeDone = false;
  bool get isInitializeDone => _isInitializeDone;

  FutureOr<void> _initState;
  FutureOr<void> get initState => _initState;

  ViewModel() {
    _init();
  }

  FutureOr<void> init();

  void _init() async {
    isLoading = true;
    _initState = init();
    await _initState;
    _isInitializeDone = true;
    isLoading = false;
  }

  void changeStatus() => isLoading = !isLoading;

  void reloadState() {
    if (!isLoading) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
