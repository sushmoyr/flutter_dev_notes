import 'dart:async';

import 'package:flutter/foundation.dart';

enum _ViewModelLifecycle {
  none,
  created,
  initiated,
  disposed,
}

abstract class ViewModel extends ChangeNotifier {
  _ViewModelLifecycle _lifecycle = _ViewModelLifecycle.none;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    scheduleMicrotask(() {
      if (!isDisposed) {
        notifyListeners();
      }
    });
  }

  bool get initialized =>
      (_lifecycle != _ViewModelLifecycle.none) ||
      (_lifecycle != _ViewModelLifecycle.disposed);

  bool get isDisposed => _lifecycle == _ViewModelLifecycle.disposed;

  ViewModel() {
    _onCreate();
  }

  void _onCreate() async {
    //viewmodel created
    _lifecycle = _ViewModelLifecycle.created;
    //start loading
    _isLoading = true;
    //call the method for the user to override
    await onCreate();
    //initialization done
    _lifecycle = _ViewModelLifecycle.initiated;
    //finish loading
    _isLoading = false;
  }

  @protected
  @mustCallSuper
  Future<void> onCreate() async {}

  void reload() {
    if (!isLoading) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _lifecycle = _ViewModelLifecycle.disposed;
    super.dispose();
  }
}
