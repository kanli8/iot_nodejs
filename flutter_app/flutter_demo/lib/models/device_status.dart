
///
///上下文信息
///
///
class DeviceStatus  {

  ////constant/////////
  final int actionLocalchangeparams=0x45 ;


  ////constant end////



  static final DeviceStatus _deviceStatus= DeviceStatus._internal();
  static int downSerials = 0;


   DeviceStatus._internal();

    static DeviceStatus getInstance() {
    
    return _deviceStatus;
  }

  //set params
  int p1=0;  //1byte
  int p2 =0; //2byte
  int rt =0;
  int st = 0;

  int status = 0; //1.run 2.pause 3.stop 0.no change
  bool isTime = true;
  bool isRe = false ;
  bool isReserve = false ;

  int model = 0;


  int rId = 0;
  int step = 0;

  //env params 
  int t1 = 0 ; //1byte
  int t2 = 0 ; //2byte
  int pogress =0;


  int serial =0;
  int action = 0;

  DateTime preTime = DateTime.now();

  void setStatus(value){
      // 0000 1000
      if((value & 0x08) > 0 ){
        isTime = false ;
      }else{
        isTime = true ;
      }

    	if((value & 0x80) > 0 ){
        isRe = true ;
      }else{
        isRe = false ;
      }

      if((value & 0x40) >0){
        isReserve = true;
      }else{
        isReserve = false ;
      }

      status =  (value &  0x07) ;



  }

  void setParams(Map<String,dynamic> map){
    map.forEach((key, value) {
      switch(key){
        case 'p1':
          p1 = value;
          break;
        case 'p2':
          p2 = value;
          break;
        case 'rt':
          rt = value;
          break;
        case 'pogress':
          pogress = value ;
          break;
        case 'stu':
          setStatus(value);
          break;
        case 'mod':
          model = value ;
          break;
        case 'rid':
          rId = value;
          break;
        case 'set_time':
          st = value;
          break;
        case 'step':
          step = value ;
          break;
        case 't1':
          t1 = value ;
          break;
        case 't2':
          t2 = value ;
          break;
        case 'serial':
          serial = value;
          break;
        case 'action':
          action = value;
          break;
      }
    });
  }
  

 

}