import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HomePage extends InAppBrowser {
  @override
  Future onBrowserCreated() async {
    print("Browser Created!");
  }

  @override
  Future onLoadStart(url) async {
    print("Started $url");
  }

  @override
  Future onLoadStop(url) async {
    print("Stopped $url");
  }

  @override
  void onLoadError(url, code, message) {
    print("Can't load $url.. Error: $message");
  }

  @override
  void onProgressChanged(progress) {
    if (progress < 100) {
      ShouldOverrideUrlLoadingAction();
    }

    print("Progress: $progress");
  }

  @override
  void onExit() {
    print("Browser closed!");
    SystemNavigator.pop();
  }

  // @override
  // Future<ShouldOverrideUrlLoadingAction> shouldOverrideUrlLoading(
  //     ShouldOverrideUrlLoadingRequest shouldOverrideUrlLoadingRequest) async {
  //   return ShouldOverrideUrlLoadingAction.ALLOW;
  // }
}

class ShouldOverrideUrlLoadingAction {}
