const Validator = require('jsonschema').Validator;
const v = new Validator();

const SCHEMA_FLOW_DEFINE = {
    "id": "/SimpleAddress",
    "type": "object",
    "properties": {
      "lines": {
        "type": "array",
        "items": {"type": "string"}
      },
      "zip": {"type": "string"},
      "city": {"type": "string"},
      "country": {"type": "string"}
    },
    "required": ["country"]
  };
  
/**
 * 校验json 合法性，通过返回true，不通过返回false
 */
const validate = (data,schema) =>{
   // return v.validate(data, schema)
   return true ;
}

/**
 * 校验并且过滤掉json中多余的字段
 * 非定义的json 会被过滤
 * 校验不通过会throw错误
 */
const validateAndFilter = (data,schema) =>{
    //TODO: 
    //return v.validate(data, schema)
    return true ;
}



module.exports = {
    SCHEMA_FLOW_DEFINE,
    validate,
    validateAndFilter
};
