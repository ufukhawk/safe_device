package com.xamdesign.safe_device;

import android.content.Context;
import androidx.annotation.NonNull;

import com.xamdesign.safe_device.DevelopmentMode.DevelopmentModeCheck;
import com.xamdesign.safe_device.Emulator.EmulatorCheck;
import com.xamdesign.safe_device.ExternalStorage.ExternalStorageCheck;
import com.xamdesign.safe_device.Rooted.RootedCheck;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** SafeDevicePlugin */
public class SafeDevicePlugin implements FlutterPlugin, MethodCallHandler {
  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    this.context = binding.getApplicationContext();
    final MethodChannel channel = new MethodChannel(
            binding.getBinaryMessenger(),
            "safe_device"
    );
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    context = null;
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
    }else if(call.method.equals("isDevelopmentModeEnable"))  {
      result.success(DevelopmentModeCheck.developmentModeCheck(context));
    }else if(call.method.equals("usbDebuggingCheck"))  {
      result.success(DevelopmentModeCheck.usbDebuggingCheck(context));
    }else {
      result.notImplemented();
    }
  }
}
