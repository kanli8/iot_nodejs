import 'package:appwrite/appwrite.dart';

const appwriteUrl = 'https://appwrite.ankemao.com/v1';
const appwriteProjectId = '6305ce5fc916f9662a50';
const databaseBssId = '6305cefc1f0cdeaa8b96';
const databaseOssId = '6305cf020fd7c3e0174e';
const recipesCollectionId = '6305d8d861e52a8e3f87';
const rcpImgBucketId = '632a7686aa32dbbc977b';
const ingredientsImgBucketId = '63311306db7e9505f233';

const avatarsImgBucketId = '63105e08325569ddae7c';

//device and family
const dbUserFamily = '63085f9f85baf18ab66d';
const dbFamily = '63085fae908b32733d3f';
const dbDeviceFamily = '63086186adb68ca2efe5';

Client client = Client();
bool isInit = false;
//login info
String userId = '';
String username = '';
String sessionId = '';
String userAvatorUrl = '';
String userFamilyId = '';
//初始化appwrite

void initAppwirteClient() {
  client
      .setEndpoint(appwriteUrl) // Your Appwrite Endpoint
      .setProject(appwriteProjectId) // Your project ID
      .setSelfSigned(status: true);
}
