import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../widgets/app_snackbar.dart';

//  <--------- Connectivity Controller --------->
//* TO watch the device network and announce when it drops or returns
class ConnectivityController extends GetxController {
  ConnectivityController({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  //  <--------- Fields --------->
  final Connectivity _connectivity;

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool? _online;
  int _notice = 0;

  //  <--------- Lifecycle --------->
  @override
  void onInit() {
    super.onInit();
    _subscription = _connectivity.onConnectivityChanged.listen(_onChanged);
    _connectivity.checkConnectivity().then(_onChanged);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  //  <--------- Status --------->
  //* TO ignore the first online reading and only snackbar on a real change, or when the app opens already offline
  void _onChanged(List<ConnectivityResult> results) {
    final online = results.any((result) => result != ConnectivityResult.none);
    final previous = _online;
    if (previous == online) return;
    _online = online;
    if (previous == null && online) return;
    _announce(online);
  }

  //  <--------- Snackbar --------->
  //* TO wait until this frame finishes so the bar is not shown during build, and skip it if a newer status already arrived
  void _announce(bool online) {
    final notice = ++_notice;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (isClosed || notice != _notice) return;
      AppSnackBar.connection(online: online);
    });
    //* TO make sure a frame actually runs, because the UI may be idle when the network changes
    SchedulerBinding.instance.ensureVisualUpdate();
  }
}
