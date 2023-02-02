package com.example.smart_cook.channel ;

import android.Manifest;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.app.Activity;

import android.content.Intent;
import android.content.Context ;
import android.content.BroadcastReceiver;
import android.content.pm.PackageManager;
import android.content.IntentFilter ;
import android.widget.Toast;
import android.util.Log;


import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothManager;
import android.bluetooth.le.ScanResult;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.core.app.ActivityCompat;


import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.EventChannel;

import com.espressif.provisioning.DeviceConnectionEvent;
import com.espressif.provisioning.ESPConstants;
import com.espressif.provisioning.ESPProvisionManager;
import com.espressif.provisioning.listeners.BleScanListener;
import com.espressif.provisioning.listeners.ResponseListener;
import com.espressif.provisioning.listeners.ProvisionListener;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;


import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Date;

import com.example.smart_cook.util.HexUtil;

/**
 * 配网
 */
public class ProvisioningChannel {
    private static final String TAG = "PVC";
    private static final String CHANNEL = "com.ankemao.provision";
    private static final String EVENT_CHANNEL = "com.ankemao.provision.event" ;

    private static final String HANDLER_PROTO_DEVICEID = "proto-deviceid";
    private static final String deviceNamePrefix = "PROV_";
    private static final String ESP_BLE_PIN="abcd1234";
    private static final String wifi_ssid = "piot";
    private static final String wifi_password = "haodayikeshu";
    // Request codes
    private static final int REQUEST_ENABLE_BT = 1;
    private static final int REQUEST_FINE_LOCATION = 2;

    //scan Time out 
    public static final int SCAN_TIMEOUT = 20000; //20秒

    // Time out
    private static final long DEVICE_CONNECT_TIMEOUT = 20000;

    private static ProvisioningChannel pvc ;
    private Context context ;
    private Activity mainActivity ;
    private Handler handler;
  
    private BluetoothAdapter bleAdapter;
    private ESPProvisionManager provisionManager;

    private FlutterEngine flutterEngine ;
    private EventChannel  methodChannelToFlutter;
    private EventChannel.EventSink eventSink;

    private Map<String,String> bluetoothDevicesUUid = new HashMap<>();
    private Map<String,BluetoothDevice> bluetoothDevices = new HashMap<>();

    private Date startScanTime ;

    private int provFlowStep = 0;

    private ProvisioningChannel(
        Activity mainActivity,
        Context context,
        FlutterEngine flutterEngine){
            
        this.context = context ;
        this.mainActivity = mainActivity ;
        provisionManager = ESPProvisionManager.getInstance(context);
        provisionManager.createESPDevice(
            ESPConstants.TransportType.TRANSPORT_BLE, 
            ESPConstants.SecurityType.SECURITY_1);
        final BluetoothManager bluetoothManager = 
            (BluetoothManager) mainActivity.getSystemService(Context.BLUETOOTH_SERVICE);
        bleAdapter = bluetoothManager.getAdapter();

        handler = new Handler();

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
            (call, result) -> {
               
                //检查位置权限信息
                if(call.method.equals("checkLocalPermission")){
                    boolean ishas = hasLocationPermissions() ;
                    result.success(ishas);
                }

                //检查蓝牙状态
                if(call.method.equals("checkblutoothStatus")){
                    boolean isBleOpen = isBleAdapterEnabled() ;
                    result.success(isBleOpen);
                }

                //请求定位权限
                if(call.method.equals("requestLocationPermission")){
                    requestLocationPermission() ;
                }


                //请求打开蓝牙
                if(call.method.equals("requestOpenBluetooth")){
                    requestBluetoothEnable(result) ;
                    // result.success(true);
                }
                


                //扫描蓝牙
                if (call.method.equals("startScanBletoothDevice")) {

                    String res = startScanBletoothDevice();
                    result.success(res);
                }
                
                //连接蓝牙
                if(call.method.equals("connectBleDevices")){
                    String res = connectBleDevices(call.argument("uuid").toString());
                    result.success(res);
                }
                
                //传输PIN码
                if(call.method.equals("sendPINtoBle")){
                    String res = sendPINtoBle();
                    result.success(res);
                }

                //get peer code
                if(call.method.equals("getPeerCode")){
                    String res = getDeviceIdAndPeerCode();
                    result.success(res);
                }

                
                //传输wifi配置
                if(call.method.equals("sendWifiConfig")){
                    String res = sendWifiConfig(call.argument("ssid").toString(),call.argument("password").toString());
                    result.success(res);
                }
            }
        );

        methodChannelToFlutter = new EventChannel(
            flutterEngine.getDartExecutor().getBinaryMessenger(),
                "com.ankemao.provision.event"
        );
        methodChannelToFlutter.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object o, EventChannel.EventSink eventSink) {
                ProvisioningChannel.this.eventSink = eventSink;
            }
 
            @Override
            public void onCancel(Object o) {
                ProvisioningChannel.this.eventSink = null;
            }
        });
    

        //注册事件
        EventBus.getDefault().register(this);


    }
    

    public static ProvisioningChannel init(Activity mainActivity,Context context,FlutterEngine flutterEngine){
        if(pvc==null){
            pvc = new ProvisioningChannel(mainActivity,context,flutterEngine);
        }
        return pvc ;
    }

    public static ProvisioningChannel getProvisioningChannel(){
        return pvc ;
    }





    public void callDartMethod(String methodName,Object data){
        // Log.d(TAG,"callDartMethod"+"::"+methodName+"---"+data);
        if(eventSink!=null){
            HashMap<String,Object> map = new HashMap<>();
            map.put("methodName",methodName);
            map.put("data",data);
            mainActivity.runOnUiThread(new Runnable() {

                @Override
                public void run() {
                    eventSink.success(map);
                }
            });
            
        }

        // if(methodChannelToFlutter!=null){
        //     Log.d(TAG,"methodChannelToFlutter..."+methodChannelToFlutter);
        //     this.methodChannelToFlutter.invokeMethod(methodName, data, new MethodChannel.Result() {
        //         @Override
        //         public void success(Object o) {
        //             Log.d(TAG,"callDartMethod....SUCCESS") ;
        //         }
        //         @Override
        //         public void error(String s, String s1, Object o) {
        //             Log.d(TAG,"callDartMethod....ERROR:"+s+s1) ;
        //         }
        //         @Override
        //         public void notImplemented() {
        //             Log.d(TAG,"callDartMethod....ERROR:notImplemented") ;
        //         }
        //     });
        // }
    }

    private boolean hasLocationPermissions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            return ActivityCompat.checkSelfPermission(context,Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED;
        }
        return true;
    }

    private void requestLocationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            ActivityCompat.requestPermissions(mainActivity,new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, REQUEST_FINE_LOCATION);
        }
    }

    
    private boolean isBleAdapterEnabled(){
        if (bleAdapter == null || !bleAdapter.isEnabled()) {
            return false;
        }
        return true ;
    }


    public void requestBluetoothEnableCallback(int requestCode, int resultCode){
        if(requestBluetoothResult==null){
            return  ;
        }

        if(requestCode==REQUEST_ENABLE_BT){
            if(resultCode!=0){
                //SUCCESS
                mainActivity.runOnUiThread(new Runnable() {

                    @Override
                    public void run() {
                        requestBluetoothResult.success(true);
                    }
                });
                
                // callDartMethod("openBleCallback",true);
            }else{
                //FAIL
                mainActivity.runOnUiThread(new Runnable() {

                    @Override
                    public void run() {
                        requestBluetoothResult.success(false);
                    }
                });
                
                // callDartMethod("openBleCallback",false);
            }
        } 
        requestBluetoothResult = null ;  
    }   

    MethodChannel.Result requestBluetoothResult ;
    private void requestBluetoothEnable(MethodChannel.Result result) {


        Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
        mainActivity.startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
        requestBluetoothResult = result ;
        Log.d(TAG, "Requested user enables Bluetooth.");
    }

    private boolean hasPermissions() {

        if (bleAdapter == null || !bleAdapter.isEnabled()) {

            // requestBluetoothEnable();
            return false;

        } else if (!hasLocationPermissions()) {

            requestLocationPermission();
            return false;
        }
        return true;
    }


    /**
     * 蓝牙连接回调
     * @param event
     */
    @Subscribe(threadMode = ThreadMode.MAIN)
    public void onEvent(DeviceConnectionEvent event) {

        Log.d(TAG, "ON Device Prov Event RECEIVED : " + event.getEventType());
        switch (event.getEventType()) {

            case ESPConstants.EVENT_DEVICE_CONNECTED:
                
                callDartMethod("bleConnectCallback",ESPConstants.EVENT_DEVICE_CONNECTED);
                break;

            case ESPConstants.EVENT_DEVICE_DISCONNECTED:
                callDartMethod("bleConnectCallback",ESPConstants.EVENT_DEVICE_DISCONNECTED);
                break;

            case ESPConstants.EVENT_DEVICE_CONNECTION_FAILED:
                callDartMethod("bleConnectCallback",ESPConstants.EVENT_DEVICE_CONNECTION_FAILED);
                break;
        }
    }

    /**
     * send pin code 
     */
    private String sendPINtoBle(){
        provisionManager.getEspDevice().setProofOfPossession(ESP_BLE_PIN);
        callDartMethod("addLog","开始发送PIN码:"+ESP_BLE_PIN);
        provisionManager.getEspDevice().initSession(new ResponseListener() {
            @Override
            public void onSuccess(byte[] returnData) {
                //成功返回后，可以输入wifi 账号密码
                Log.d(TAG, "addLog..PIN码回调成功.可以开始传输wifi 信息.....");
                
                callDartMethod("sendPinCallback",0);
                
                // Log.d(TAG, "addLog.PIN回调..call flutter.....");
            }

            @Override
            public void onFailure(Exception e) {
                //回调发送PIN失败的原因
                Log.d(TAG, "addLog..PIN码回调失败......"+e);
                callDartMethod("sendPinCallback",1);
            }
        });
        return "sendPINtoBle";
    }


    /**
     * get deviceId and peer code 
     */
    private String getDeviceIdAndPeerCode (){
        //
        Log.d(TAG, "getDeviceIdAndPeerCode..java..into....");
        provisionManager.getEspDevice().sendDataToCustomEndPoint(
                HANDLER_PROTO_DEVICEID,
                new byte[]{0},
            new ResponseListener() {
                @Override
                public void onSuccess(byte[] returnData) {
                    //成功返回后，可以输入wifi 账号密码
                    Log.d(TAG, "get peer info....."+HexUtil.bytesToHex(returnData));
                    callDartMethod("getPeerCallback",returnData);

                    // Log.d(TAG, "addLog.PIN回调..call flutter.....");
                }

                @Override
                public void onFailure(Exception e) {
                    //回调发送PIN失败的原因
                    Log.d(TAG, "addLog..PIN码回调失败......"+e);
                    callDartMethod("getPeerCallback",new byte[]{});
                }
            });
        return "";
    }


    



    /**
     * 蓝牙配对
     * @param uuid
     * @return
     */
    private String connectBleDevices(String uuid){
        Log.d(TAG, "connectBleDevices:"+uuid);
        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
            Log.d(TAG,"provisionManager.getEspDevice:::"+provisionManager.getEspDevice()) ;
            Log.d(TAG,"bluetoothDevices:::"+bluetoothDevices.get(uuid)) ;
            provisionManager.getEspDevice()
                .connectBLEDevice(bluetoothDevices.get(uuid), uuid);
            callDartMethod("addLog","调用蓝牙连接");
        } else {
            Log.e(TAG, "Not able to connect device as Location permission is not granted.");
            Toast.makeText(context, "Please give location permission to connect device", Toast.LENGTH_LONG).show();
        }
        return "connectBleDevices";
    }

    /**
     * 扫描蓝牙设备
     */
    private String startScanBletoothDevice(){
 
        startScanTime = new Date();
        return startScanBletoothDeviceNotSetTime();
    }

    /**
     * 扫描蓝牙设备
     */
    private String startScanBletoothDeviceNotSetTime(){
        if (!hasPermissions() ) {
            return "没有权限";
        }

        bluetoothDevices.clear();
        bluetoothDevicesUUid.clear();
        provisionManager.searchBleEspDevices(deviceNamePrefix, bleScanListener);
        return "success scan bletooth";
    }


    /**
     * 蓝牙扫描回调监听
     */
    private BleScanListener bleScanListener = new BleScanListener() {

        @Override
        public void scanStartFailed() {
            Toast.makeText(context, "Please turn on Bluetooth to connect BLE device", Toast.LENGTH_SHORT).show();
        }

        @Override
        public void onPeripheralFound(BluetoothDevice device, ScanResult scanResult) {

            Log.d(TAG, "====== onPeripheralFound ===== " + device.getName());
            boolean deviceExists = false;
            String serviceUuid = "";

            if (scanResult.getScanRecord().getServiceUuids() != null && scanResult.getScanRecord().getServiceUuids().size() > 0) {
                serviceUuid = scanResult.getScanRecord().getServiceUuids().get(0).toString();
            }
            Log.d(TAG, "Add service UUID : " + serviceUuid);

            if (bluetoothDevices.containsKey(serviceUuid)) {
                deviceExists = true;
            }

            if (!deviceExists) {
                bluetoothDevicesUUid.put(serviceUuid,device.getName() );
                bluetoothDevices.put(serviceUuid,device);
                callDartMethod("deviceListChange",bluetoothDevicesUUid);
            }
        }

        @Override
        public void scanCompleted() {
            //上报返回结果
            if(bluetoothDevices.size()>0){
                //扫描到了，不需要重复扫描
                callDartMethod("scanCompleted","");
                return ;
            }
            Date now = new Date();
            if(now.getTime() - startScanTime.getTime() < SCAN_TIMEOUT){
                startScanBletoothDeviceNotSetTime();
            }else{
                Log.d(TAG, "scanCompleted..... ");
                callDartMethod("scanCompleted","");
            }
           
        }

        @Override
        public void onFailure(Exception e) {
            Log.e(TAG, e.getMessage());
            e.printStackTrace();
        }
    };


    /**
     * 发送wifi 账号密码并处理回调
     */
    private String sendWifiConfig(String ssid,String password) {


        provisionManager.getEspDevice().provision(ssid, password, new ProvisionListener() {

            @Override
            public void createSessionFailed(Exception e) {
                //创建会话失败
                // Log.d(TAG, "addLog..wifi连接:createSessionFailed");
                callDartMethod("sendWifiCallback",1);
            }

            @Override
            public void wifiConfigSent() {
                //wifi 配置已经发送
                // Log.d(TAG, "addLog..wifi连接:wifiConfigSent");
                callDartMethod("sendWifiCallback",2);
                // Log.d(TAG, "addLog..wifi连接:wifiConfigSent...callDartMethod...");
            }

            @Override
            public void wifiConfigFailed(Exception e) {

                //wifi配置失败
                callDartMethod("sendWifiCallback",3);

            }

            @Override
            public void wifiConfigApplied() {
                //wifi 配置被接收
                callDartMethod("sendWifiCallback",4);
            }

            @Override
            public void wifiConfigApplyFailed(Exception e) {
                //wifi 配置接收失败
                callDartMethod("sendWifiCallback",5);
                
            }

            @Override
            public void provisioningFailedFromDevice(final ESPConstants.ProvisionFailureReason failureReason) {

                switch (failureReason) {
                    case AUTH_FAILED:
                        //鉴权失败
                        callDartMethod("sendWifiCallback",6);
                        break;
                    case NETWORK_NOT_FOUND:
                        //找不到WiFi
                        callDartMethod("sendWifiCallback",7);
                        break;
                    case DEVICE_DISCONNECTED:
                        callDartMethod("sendWifiCallback",8);
                        //设备断开连接
                    case UNKNOWN:
                        //未知错误
                        callDartMethod("sendWifiCallback",9);
                        break;
                }
               
            }

            @Override
            public void deviceProvisioningSuccess() {
                callDartMethod("sendWifiCallback",10);
                //设备配置成功
            }

            @Override
            public void onProvisioningFailed(Exception e) {
                callDartMethod("sendWifiCallback",11);
                //设备配置失败
                
            }
        });

        return "sendWifiConfig";
    }

    

}
