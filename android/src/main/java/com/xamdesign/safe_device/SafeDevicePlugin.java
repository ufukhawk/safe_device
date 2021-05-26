package com.xamdesign.safe_device;

import android.content.Context;
import android.location.Location;

import com.xamdesign.safe_device.Emulator.EmulatorCheck;
import com.xamdesign.safe_device.ExternalStorage.ExternalStorageCheck;
import com.xamdesign.safe_device.Rooted.RootedCheck;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** SafeDevicePlugin */
public class SafeDevicePlugin implements MethodCallHandler {
  private final Context context;
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "safe_device");
    channel.setMethodCallHandler(new SafeDevicePlugin(registrar.context()));
  }

  private SafeDevicePlugin(Context context){
    this.context = context;
  }

  @Override
  public void onMethodCall(MethodCall call, final Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("isJailBroken")) {
      result.success(RootedCheck.isJailBroken(context));
    }else if (call.method.equals("isRealDevice")) {
      result.success(!EmulatorCheck.isEmulator());
    }else if (call.method.equals("isOnExternalStorage")) {
      result.success(ExternalStorageCheck.isOnExternalStorage(context));
    }
    else {
      result.notImplemented();
    }
  }
}
