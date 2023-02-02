const SUCCESS ={ 
    result: '0', 
    message: '成功' } ;

const REQ_JSON_SCHEMA_CHECK_ERROR ={ 
    result: '7001', 
    message: '请求表单合法性校验失败，请检查必填字段及字段类型是否正确' } ;

/**------------flow start---------- */
const FLOW_INSTANCE_ID_NOT_FOUND={ 
    result: 8001, 
    message: '流程实例不存在' } ;

const FLOW_STEP_ID_ERROR={ 
    result: '8002', 
    message: '流程节点不存在' } ;

const FLOW_STEP_NO_ACTIVE={ 
    result: '8003', 
    message: '不是活动的流程节点' } ;

const FLOW_STEP_FORM_NAME_ERROR ={ 
    result: '8004', 
    message: '您不可以修改定义表单类型' } ;

const FLOW_STEP_FORM_FIELD_CANNOT_EMPTY ={ 
    result: '8005', 
    message: '表单必填字段不完整' } ;

const FLOW_NODE_NO_AUTHORITY ={ 
    result: '8006', 
    message: '不是您的任务' } ;

const FLOW_DEFINE_ERROR_PERSET_FORM_NOT_FOUND ={ 
    result: '8007', 
    message: '流程定义错误，流程预设表单未找到' } ;

const FLOW_DEFINE_FUNC_NOT_FOUND ={ 
    result: '8008', 
    message: '自动节点函数不存在，处理失败，请修改流程定义' } ;


const FLOW_DEFINE_FUNC_RUN_ERROR ={ 
    result: '8009', 
    message: '自动节点函数执行错误，请检查' } ;

const FLOW_END_NODE_ERROR ={ 
    result: '8010', 
    message: '结束节点出错，请检查' } ;

const FLOW_DEFINE_NAME_IS_REPEAT ={ 
    result: '8011', 
    message: '流程名称不能重复，请检查' } ;


const FLOW_DEFINE_NO_FOUND ={ 
    result: '8012', 
    message: '流程定义不存在，请检查' } ;

/**------------flow end---------- */

/**------------group start---------- */
const GROUP_NO_FOUND = { 
    result: '8101', 
    message: '群组不存在，请检查' } ;

const GROUP_APPLY_USER_NOT_FOUND = { 
    result: '8102', 
    message: '申请列表中未找到此用户' } ;

const GROUP_MEMBER_NO_FOUND = {
    result: '8103', 
    message: '人员不在群组中' }

const GROUP_IS_NOT_OWNER = {
    result: '8104', 
    message: '没有所有权' }

const GROUP_CONNOT_REMOVE_OWNER = {
    result: '8105', 
    message: '不能删除群组所有者' }

const GROUP_ISNOT_MANAGER = {
    result: '8105', 
    message: '当前用户不是管理员' }
const GROUP_MEMBER_EXIST = {
    result: '8105', 
    message: '人员已在群组中' }
/**------------group end---------- */

const SYSTEM_IS_MAINTAINING ={ 
    result: '9001', 
    message: '功能维护中，暂时无法提供服务' } ;

const SYSTEM_IS_BUILDING ={ 
    result: '9002', 
    message: '功能正在建设中，敬请期待' } ;

const USER_REGISTER_ERROR = {
    result: '10001',
    message: '注册失败'
}

const USER_REGISTER_EXIST = {
    result: '10002',
    message: '用户名已存在'
}

const USER_LOGIN_ERROR = {
    result: '10003',
    message: '用户名不存在，或者密码错误'
}

const USER_LOGOFF_NOTEXIST = {
    result: '10004',
    message: '注销用户失败，用户名不存在，或者密码错误'
}

const USER_FIND_NOTEXIST = {
    result: '10005',
    message: "用户不存在"
}

const ORGANIZE_ADD_ERROR = {
    result: '11001',
    message: '新增组织失败'
}

const ORGANIZE_ADD_EXIST = {
    result: '11002',
    message: "组织已存在"
}

const ORGANIZE_REMOVE_NOAUTH = {
    result: '11003',
    message: "只有所有者可以注销组织"
}

const ORGANIZE_OWNER_TRANSFER_ISNOT_OWNER = {
    result: '11004',
    message: '非所有者不能转让组织所有权'
}

const ORGANIZE_OWNER_TRANSFER_USER_NOTEXIST = {
    result: '11005',
    message: '转出人员不存在'
}

const ORGANIZE_OWNER_TRANSFER_ERROR = {
    result: '11006',
    message: '组织所有者转让异常'
}

const ORGANIZE_NOTEXIST = {
    result: '11007',
    message: '组织不存在'
}

const ORGANIZE_JOIN_USER_EXIST = {
    result: '11008',
    message: '人员已在组织中，无需申请'
}

const ORGANIZE_RESIGN_OWNER = {
    result: '11009',
    message: '组织所有者不允许退出群组'
}

const ORGANIZE_UPDATE_CODE_EXIST = {
    result: '11010',
    message: '组织编码已被占用'
}

const ORGANIZE_NAME_EXIST = {
    result: '11011',
    message: '组织名称已被占用'
}


const GROUP_NOT_FIND = {
    result: '12001',
    message: '群组不存在'
}

const GROUP_NOT_FIND_USER = {
    result: '12002',
    message: '人员不在群组中'
}

const FORM_ADD_EXIST = {
    result: '13001',
    message: '表名已被占用'
}

const FORM_FORMNAME_VALIDATION_FAILED = {
    result: '13002',
    message: '表单名称校验不通过，表单名称规则：小写字母开头的，由小写字母、下划线和数字组成的字符串'
}

const FORM_NO_DDL_AUTH = {
    result: '13003',
    message: '没有表单DDL权限'
}

const FORM_NO_OWNER_AUTH = {
    result: '13004',
    message: '不是表单所有者'
}

const FORM_NO_WRITE_AUTH = {
    result: '13005',
    message: '没有表单写权限'
}

const FORM_NO_READ_AUTH = {
    result: '13006',
    message: '没有表单读权限'
}

const FUNC_ADD_EXIST = {
    result: '14001',
    message: '函数名已被占用'
}

const FUNC_NO_ORGANIZE_AUTH = {
    result: '14002',
    message: '没有组织数据读写权限'
}

const FUNC_FIND_NOT_EXIST = {
    result: '14003',
    message: '函数不存在'
}

const CUSTOM_API_ADD_EXIST = {
    result: '15001',
    message: 'URI已存在'
}

const CUSTOM_API_ADD_PARAMS_ERR = {
    result: '15002',
    message: '参数不全'
}

const CUSTOM_API_FIND_NOT_EXIST = {
    result: '15003',
    message: 'API不存在'
}



const FILE_NOT_EXIST = {
    result: '16003',
    message: '文件不存在'
}



module.exports = {
    SUCCESS,

    REQ_JSON_SCHEMA_CHECK_ERROR,

    FLOW_INSTANCE_ID_NOT_FOUND,
    FLOW_STEP_ID_ERROR,
    FLOW_STEP_NO_ACTIVE,
    FLOW_STEP_FORM_NAME_ERROR,
    FLOW_STEP_FORM_FIELD_CANNOT_EMPTY,
    FLOW_NODE_NO_AUTHORITY,
    FLOW_DEFINE_ERROR_PERSET_FORM_NOT_FOUND,
    FLOW_DEFINE_FUNC_NOT_FOUND,
    FLOW_DEFINE_FUNC_RUN_ERROR,
    FLOW_END_NODE_ERROR,
    FLOW_DEFINE_NAME_IS_REPEAT,
    FLOW_DEFINE_NO_FOUND,

    GROUP_NO_FOUND,
    GROUP_APPLY_USER_NOT_FOUND,
    GROUP_MEMBER_NO_FOUND,
    GROUP_IS_NOT_OWNER,
    GROUP_CONNOT_REMOVE_OWNER,
    GROUP_ISNOT_MANAGER,
    GROUP_MEMBER_EXIST,

    SYSTEM_IS_MAINTAINING,
    SYSTEM_IS_BUILDING,
    USER_REGISTER_ERROR,
    USER_REGISTER_EXIST,
    USER_LOGIN_ERROR,
    USER_LOGOFF_NOTEXIST,
    USER_FIND_NOTEXIST,
    ORGANIZE_ADD_ERROR,
    ORGANIZE_ADD_EXIST,
    ORGANIZE_REMOVE_NOAUTH,
    ORGANIZE_OWNER_TRANSFER_ISNOT_OWNER,
    ORGANIZE_OWNER_TRANSFER_USER_NOTEXIST,
    ORGANIZE_OWNER_TRANSFER_ERROR,
    ORGANIZE_NOTEXIST,
    ORGANIZE_JOIN_USER_EXIST,
    ORGANIZE_RESIGN_OWNER,
    ORGANIZE_UPDATE_CODE_EXIST,
    ORGANIZE_NAME_EXIST,
    GROUP_NOT_FIND,
    GROUP_NOT_FIND_USER,
    FORM_ADD_EXIST,
    FORM_FORMNAME_VALIDATION_FAILED,
    FORM_NO_DDL_AUTH,
    FORM_NO_OWNER_AUTH,
    FORM_NO_WRITE_AUTH,
    FORM_NO_READ_AUTH,
    FUNC_ADD_EXIST,
    FUNC_NO_ORGANIZE_AUTH,
    FUNC_FIND_NOT_EXIST,
    CUSTOM_API_ADD_EXIST,
    CUSTOM_API_ADD_PARAMS_ERR,
    CUSTOM_API_FIND_NOT_EXIST,

    FILE_NOT_EXIST,
};

