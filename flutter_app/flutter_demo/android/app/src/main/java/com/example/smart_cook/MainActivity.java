package com.example.smart_cook;

import android.content.Intent;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import androidx.annotation.NonNull;

import com.example.smart_cook.channel.ProvisioningChannel ;

public class MainActivity extends FlutterActivity {

    private static final int REQUEST_ENABLE_BT = 3;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        ProvisioningChannel.init(this,getApplicationContext(),flutterEngine);
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        ProvisioningChannel
            .getProvisioningChannel()
            .requestBluetoothEnableCallback(requestCode,resultCode);
        System.out.println("requestCode:::"+requestCode+";;;resultCode:::"+resultCode);

    }



    
}
