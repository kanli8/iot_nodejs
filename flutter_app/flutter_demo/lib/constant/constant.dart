import 'package:appwrite/appwrite.dart';

// const iotFontUrl= 'ws://ankemao.com:8082'; //production
const iotFontUrl = 'ws://192.168.31.186:8082/'; //本地

///action down
const actionQuery = 0x00;
const actionSetAndRun = 0x01;
const actionStop = 0x02;
const actionPause = 0x03;
const actionContinue = 0x04;

///action up
const actionWaitUserConfirm = 0x40;
const actionUserConfirm = 0x41;
const actionUserStart = 0x42;
const actionUserStop = 0x43;
const actionUserPause = 0x44;
const actionuUserContinue = 0x44;

///action error
const actionDeviceDeal = 0xD0;
const actionDeviceError = 0xE0;
