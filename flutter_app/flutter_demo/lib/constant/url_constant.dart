class UrlConstant{
  // static String baseUrl = "http://192.168.128.157:13000";//开发内网
  // static String baseUrl = "http://dev.supercook.summitsmartech.com/api";//开发公网
  static String baseUrl = "http://supercook.summitsmartech.com/api";//生产公网
  // static String m2mBaseUrl = "http://192.168.128.157:13002";//开发内网
  // static String m2mBaseUrl = "http://dev.supercook.summitsmartech.com/m2mapi";//开发公网
  static String m2mBaseUrl = "http://supercook.summitsmartech.com/m2mapi";//生产公网

  // 查询菜谱列表
  // static String queryRecipesListUrl = baseUrl + "/v1/recipeDetail/query";
  static String queryRecipesListUrlV2 = baseUrl + "/v2/recipeDetail/queryList";
  
  // 根据id查询菜谱
  // static String queryRecipesById = baseUrl + "/v1/recipeDetail/queryById";
  static String queryRecipesByIdV2 = baseUrl + "/v2/recipeDetail/queryById";
  // 根据名称模糊查询菜谱
  // static String queryRecipesListLikeName = baseUrl + "/v1/recipeDetail/findByRecipeDetailText";
  static String queryRecipesListLikeNameV2 = baseUrl + "/v2/recipeDetail/queryListByRecipeName";

  // 根据标签列表查询菜谱
  // static String queryRecipesListByTags = baseUrl + "/v1/recipeDetail/queryByTags";
  static String queryRecipesListByTagsV2 = baseUrl + "/v2/recipeDetail/queryRecipesListByTags";
  
  // 查询食谱标签列表
  // static String queryTagList = baseUrl + "/v1/tags/queryAll";
  static String queryTagListV2 = baseUrl + "/v2/recipeTag/queryAll";

  ///根据设备id查询常用菜谱列表
  // static String queryCommonRecipeListByDeviceId = baseUrl + "/v1/deviceCommonRecipe/queryRecipeDetailByDeviceId";
  static String queryCommonRecipeListByDeviceIdV2 = baseUrl + "/v2/deviceCommonRecipe/queryRecipeDetailByDeviceId";

  ///根据用户id查日程菜谱列表
  // static String queryScheduleRecipeListByUserId = baseUrl + "/v1/recipeSchedule/queryByUserIdWithRecipeDetail";
  static String queryScheduleRecipeListByUserIdV2 = baseUrl + "/v2/recipeSchedule/queryByUserIdWithRecipeDetail";

  ///根据设备id查日程菜谱列表
  static String queryScheduleListByDeviceIdV2 = baseUrl + "/v2/recipeSchedule/queryByDeviceIdWithRecipeDetailV2";

  ///添加日程菜谱
  static String insertScheduleRecipeV2 = baseUrl + "/v2/recipeSchedule/create";

  ///修改日程菜谱
  static String updateScheduleRecipeV2 = baseUrl + "/v2/recipeSchedule/update";

  ///删除菜谱日程
  static String deleteRecipeScheduleV2 = baseUrl + "/v2/recipeSchedule/delete";

  ///根据设备id查固定菜谱列表
  // static String queryFixedRecipeListByDeviceID = baseUrl + "/v1/deviceFixedRecipe/queryRecipeDetailListByDeviceId";
  static String queryFixedRecipeListByDeviceIDV2 = baseUrl + "/v2/deviceFixedRecipe/queryRecipeDetailListByDeviceIdV2";

  ///添加固定菜谱
  static String insertFixedRecipe = baseUrl+"/v2/deviceFixedRecipe/insert";

  ///移除固定菜谱
  static String removeFixedRecipe = baseUrl + "/v2/deviceFixedRecipe/delete";

  ///查推荐菜谱列表
  // static String queryRecommendedRecipeList = baseUrl + "/v1/recipeDetail/recommendedRecipe";
  static String queryRecommendedRecipeListV2 = baseUrl + "/v2/recipeDetail/recommendedRecipe";

  ///根据deviceId查收藏菜谱
  static String queryLikeRecipesByDeviceIdV2 = baseUrl + "/v2/recipeCollect/queryByDeviceId";

  ///根据deviceId和recipeId添加藏菜谱
  static String insertLikeRecipeV2 = baseUrl + "/v2/recipeCollect/create";

  ///根据服务器后台收藏菜谱主键删除菜谱收藏
  static String removeLikeRecipeV2 = baseUrl + "/v2/recipeCollect/delete";

  ///根据菜谱id查关联菜谱
  static String queryAssociatedRecipeById = baseUrl + "/v2/recipeDetail/associatedRecipe";
  
  /// 获取菜谱图片地址前缀，使用方式：${getImageUrlPre/imgs.png}
  static String getImageUrlPre = baseUrl + "/v1/projectImageInfo/recipe/image";
  
  /// 获取菜谱食材图片地址前缀，使用方式：${getImageUrlPre/imgs.png}
  static String getIngredientImageUrlPre = baseUrl + "/v1/projectImageInfo/recipeIngredient/image";

  ///音频下载
  static String downLoadAudio = baseUrl + "/v1/voiceTextManage/download/";

  // 系统用户登录API
  static String userLogin = baseUrl + "/v1/sysUser/loginByUserName";

  // 业务用户登录API
  static String businessUserLogin = baseUrl + "/v1/businessUser/loginByUserName";

  //异常日志上报API
  static String exceptionLogReport = baseUrl + "/v1/deviceExceptionLog/logReport";

  // 根据groupId查询设备信息列表
  static String queryDeviceByGroupId = m2mBaseUrl + "/v1/groupDevice/queryDevice/groupId";

  // app版本信息
  static String queryAppVersionUrl = baseUrl + "/v1/deviceApkVersion/getLatestVersion";

  // apk版本下载
  static String downloadAppVersionPath = baseUrl + "/v1/deviceApkVersion/download";

}