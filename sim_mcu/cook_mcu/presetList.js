var rice =  require('./pre_cook_rice').presetCommond; 

const presetList = [
    rice
];

const getPresetbyName=(name)=>{

    let res = presetList.filter(item => item.name==name);
    if(res!=null && res.length>0){
        return res[0] ;
    }
    return null;
}

const getPresetbyCommand=(buf)=>{
    //0xFF 过滤掉
    let res = presetList.filter(item => item.runComond.equals(buf));
    if(res!=null && res.length>0){
        return res[0] ;
    }
    return null;
}



module.exports = {
    presetList,
    getPresetbyName,
    getPresetbyCommand
}