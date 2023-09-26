///DHCInsuPort.js
/// 版本号：V2.0

var INSUXMLHttp;
//Zhan 20200620 原来的全局变量太多,放在这里
var INSUPORTGLOBAL={
	SysIp:"",
	AddDivideFlag:"",
	InsuType:"",
	iniFileName:"",
	fso:"",
	iniServerIP:0,	//是否初始化ECP服务器IP。0不初始化IP，从DHCInsu.ini中取；1初始化传入的IP,
	INSUSerIP:"",
	INSUblltype:"",	//程序自动获取,
	httpFlag:0,	//在字典DLLType中的医保描述中配置,0:默认用传统模式，1:用http模式传参数(此模式时INSUPORTGLOBAL.iniServerIP要为0)，2:头菜单模式，3：websocket模式,
	ServerMode:0, //0:客户端模式,每个客户端要部署中间件服务程序 1:服务器模式只用在服务器上部署,脱卡时使用，客户端不用装医保环境,需要修改GetInsuIPAddress中的服务器IP,
	DHCINSUBLL:null,
	tmpCnt:0,
	isIE:false,
	isSSL:false,
	SerStatus:0,
	isWinXP:false,
	dbEncrypt:"|||",
	HospID:session['LOGON.HOSPID'],
	INSULOCALSERVICE:0,
};
//----------------医保组和计费组接口标准版----------------
//读医保卡
//入参:
//     Handle：句柄默认0;UserId:SS_User.SSUSR_RowId;InsuNo:医保编号(身份证号);CardType:卡类型(有、无卡等)
//     ExpString:InsuType^数据库连接串^姓名^业务类型
//出参：参见\09yb\标准版\Doc医保读卡返回固定参数列表V2.00.xls
//      0或-1|^^^^^^^^^^^^^^^|^^^^^^^^^^^^^^^^  "|"的第一部分成功与否标志，第二部分是各个医保公用的串，第三部分是医保读卡剩余返回值的的拼串
function InsuReadCard(Handle,UserId,InsuNo,CardType,ExpString)
{  
 try{
 	//dhcsys_alert("读卡开始:InsuNo="+InsuNo+"^UserId="+UserId+"^ExpString="+ExpString)
 	//return "0|6003105182^603991952^120000650601001^张?^女^1971-01-01^31^0^888888^宝安洪浪南路??号有限公司^1^1^2^Z000^1175.02^200907^5^0^0^0^0^0^0^0^0^0^^^^^^^1^0^0^0^0^0^综合##2^@@"
	//InsuTypeCode=GetInsuTypeCode(AdmReasonId)
    //if (InsuTypeCode=="") {return -1;} 
 
    var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
        InsuTypeCode=ExpString.split("^")[0]
    var rtn="-1";
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
		if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
    	if(INSUPORTGLOBAL.httpFlag==0){
    		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)}	//Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
			rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuASReadCard(Handle,UserId,InsuNo,CardType,ExpStrForNet)  
	    	DHCINSUBLL= null;
    	}else{
			var getInStr="Handle="+Handle+"&userid="+UserId+"&InsuNo="+InsuNo+"&CardType="+CardType+"&ExpString="+toINSUSafeCode(ExpStrForNet);
			rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuASReadCard",getInStr,"")
	    }
		    return rtn;
 }catch(e){
	dhcsys_alert("调用医保接口发生异常"+e.message);
	return "-1"
}finally{
	
} 
}

//读医保卡(弹窗)
//入参:
//     Handle：句柄默认0;UserId:SS_User.SSUSR_RowId;InsuNo:医保编号(身份证号);CardType:卡类型(有、无卡等)
//     ExpString:InsuType^数据库连接串^姓名^业务类型
//出参：参见\09yb\标准版\Doc医保读卡返回固定参数列表V2.00.xls
//      0或-1|^^^^^^^^^^^^^^^|^^^^^^^^^^^^^^^^  "|"的第一部分成功与否标志，第二部分是各个医保公用的串，第三部分是医保读卡剩余返回值的的拼串
function InsuReadCardFrm(Handle,UserId,InsuNo,CardType,ExpString)
{  
 try{
 	//dhcsys_alert("读卡开始:InsuNo="+InsuNo+"^UserId="+UserId+"^ExpString="+ExpString)
 	//return "0|6003105182^603991952^120000650601001^张?^女^1971-01-01^31^0^888888^宝安洪浪南路??号有限公司^1^1^2^Z000^1175.02^200907^5^0^0^0^0^0^0^0^0^0^^^^^^^1^0^0^0^0^0^综合##2^@@"
	//InsuTypeCode=GetInsuTypeCode(AdmReasonId)
    //if (InsuTypeCode=="") {return -1;} 
	var rtn="-1";
    var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
        InsuTypeCode=ExpString.split("^")[0]
    
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/

		if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
    	if(INSUPORTGLOBAL.httpFlag==0){
	    	if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)}	//Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
			var rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuASReadCardFrm(Handle,UserId,InsuNo,CardType,ExpStrForNet)  
		    DHCINSUBLL= null;
    	}else{
			var getInStr="Handle="+Handle+"&userid="+UserId+"&InsuNo="+InsuNo+"&CardType="+CardType+"&ExpStrForNet="+toINSUSafeCode(ExpStrForNet);
			rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuASReadCardFrm",getInStr,"")
	    }

		    return rtn;
 }catch(e){
	dhcsys_alert("调用医保接口发生异常"+e.message);
	return "-1"
}finally{
	
} 
}

///入院登记
///入参:
/// Handle：句柄默认0;UserId:SS_User.SSUSR_RowId;PaadmRowid:Pa_Adm.Rowid;AdmReasonNationCode:Pac_AdmReason.REA_NationalCode
/// AdmReasonId:Pac_AdmReason.Rowid
/// ExpString: 入院类别(普通,急观,家床)^医保诊断编码^医保诊断名称^医保个人编号^就诊日期^就诊时间^治疗方式^补偿方式^医保类型^数据库连接^卡类型^待遇类别
//出参?0或-1
//说明 
function InsuIPReg(Handle,UserId,PaadmRowid,AdmReasonNationCode,AdmReasonId,ExpString)
{
 try{
 	//dhcsys_alert("医保入院登记开始Handle="+Handle+"^UserId="+UserId+"^PaadmRowid="+PaadmRowid+"^AdmReasonNationCode="+AdmReasonNationCode+"^AdmReasonId="+AdmReasonId+"^ExpString="+ExpString)
   // InsuTypeCode=GetInsuTypeCode(AdmReasonId)
      InsuTypeCode=ExpString.split("^")[8] ;
    var ExpStrForNet=BuildInsuExpStrStd(ExpString,9)
	var rtn="-1";
    if (InsuTypeCode=="") 
    {
	    dhcsys_alert("医保类型为空，请选择医保类型")
	    return -1;
	} 
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/

		if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
    	if(INSUPORTGLOBAL.httpFlag==0){
			if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
			rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuIPReg(Handle,UserId,PaadmRowid,AdmReasonNationCode, AdmReasonId,ExpStrForNet);
			DHCINSUBLL= null;
    	}else{
			var getInStr="Handle="+Handle+"&UserId="+UserId+"&PaadmRowid="+PaadmRowid+"&AdmReasonNationCode="+AdmReasonNationCode+"&AdmReasonId="+AdmReasonId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
			rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuIPReg",getInStr,"")
	    }

    return rtn;
  }catch(e){
	dhcsys_alert("调用医保接口发生异常"+e.message);
	return "-1"
  }finally{
	
  }     
    
}


///入院登记修改
///入参:
/// Handle：句柄默认0;UserId:SS_User.SSUSR_RowId;PaadmRowid:Pa_Adm.Rowid;AdmReasonNationCode:Pac_AdmReason.REA_NationalCode
/// AdmReasonId:Pac_AdmReason.Rowid
/// ExpString: 入院类别(普通,急观,家床)^医保诊断编码^医保诊断名称^医保个人编号^就诊日期^就诊时间^治疗方式^补偿方式^医保类型^数据库连接^卡类型^待遇类别
//出参?0或-1
//说明 
function InsuIPRegMod(Handle,UserId,PaadmRowid,AdmReasonNationCode,AdmReasonId,ExpString)
{
 try{
 	//dhcsys_alert("医保入院登记开始Handle="+Handle+"^UserId="+UserId+"^PaadmRowid="+PaadmRowid+"^AdmReasonNationCode="+AdmReasonNationCode+"^AdmReasonId="+AdmReasonId+"^ExpString="+ExpString)
   // InsuTypeCode=GetInsuTypeCode(AdmReasonId)
      InsuTypeCode=ExpString.split("^")[8] ;
	var rtn="-1";
    var ExpStrForNet=BuildInsuExpStrStd(ExpString,9)

    if (InsuTypeCode=="") 
    {
	    dhcsys_alert("医保类型为空，请选择医保类型")
	    return -1;
	} 
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuIPRegMod(Handle,UserId,PaadmRowid,AdmReasonNationCode, AdmReasonId,ExpStrForNet);
		DHCINSUBLL= null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&PaadmRowid="+PaadmRowid+"&AdmReasonNationCode="+AdmReasonNationCode+"&AdmReasonId="+AdmReasonId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuIPRegMod",getInStr,"")
	}

    return rtn;
  }catch(e){
	dhcsys_alert("调用医保接口发生异常"+e.message);
	return "-1"
  }finally{
	
  }     
    
}

//登记撤销
//入参:
///   Handle：句柄默认0;UserId:SS_User.SSUSR_RowId;PaadmRowid:Pa_Adm.Rowid;AdmReasonNationCode:Pac_AdmReason.REA_NationalCode
///   AdmReasonId:Pac_AdmReason.Rowid
///   ExpString: 医保类型^数据库连接串
//出参?0或-1
//说明?
function InsuIPRegStrike(Handle,UserId,PaadmRowid, AdmReasonNationCode, AdmReasonId,ExpString)
{
  try {	
     //dhcsys_alert("医保登记取消开始")
	//dhcsys_alert("医保入院登记撤销开始"+Handle+"^"+UserId+"^"+PaadmRowid+"^"+AdmReasonNationCode+"^"+AdmReasonId+"^"+ExpString)   
	 var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
	 InsuTypeCode=GetInsuTypeCode(AdmReasonId)
	var rtn="-1";
    if (InsuTypeCode=="") {return -1;} 		
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuIPRegDestroy(Handle,UserId,PaadmRowid, AdmReasonNationCode, AdmReasonId,ExpStrForNet);
		DHCINSUBLL= null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&PaadmRowid="+PaadmRowid+"&AdmReasonNationCode="+AdmReasonNationCode+"&AdmReasonId="+AdmReasonId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuIPRegDestroy",getInStr,"")
	}
    return rtn;
 }catch(e){
	dhcsys_alert("调用医保接口发生异常"+e.message);
	return "-1"
}finally{
	
} 

}

//住院预结算
//入参:
///   Handle：句柄默认0;UserId:SS_User.SSUSR_RowId;BillNO:DHC_PatientBill.Rowid;AdmReasonNationCode:Pac_AdmReason.REA_NationalCode
///   AdmReasonId:Pac_AdmReason.Rowid
///   ExpString: 医保类型^数据库连接串
//出参? 0 ?-1
//说明?
function InsuIPDividePre(Handle,UserId,BillNO,AdmReasonNationCode,AdmReasonId,ExpString)
{
	try{
		//dhcsys_alert("医保住院预结算开始"+Handle+"^"+UserId+"^"+BillNO+"^"+AdmReasonNationCode+"^"+AdmReasonId+"^"+ExpString) 
		//return 0;
	 var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
	 InsuTypeCode=GetInsuTypeCode(AdmReasonId)
	var rtn="-1";
    if (InsuTypeCode=="") {return -1;} 		
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuIPDividePre(Handle,UserId,BillNO,AdmReasonNationCode,AdmReasonId,ExpStrForNet);
		DHCINSUBLL= null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&BillNO="+BillNO+"&AdmReasonNationCode="+AdmReasonNationCode+"&AdmReasonId="+AdmReasonId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuIPDividePre",getInStr,"")
	}

    if(rtn.split("^")[0]=="0"){
		dhcsys_alert("医保预结算成功");
	}
    return rtn;
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
    
}

///住院明细上传
///入参:
///   Handle：句柄默认0;UserId:SS_User.SSUSR_RowId;BillNO:DHC_PatientBill.Rowid;AdmReasonNationCode:Pac_AdmReason.REA_NationalCode
///   AdmReasonId:Pac_AdmReason.Rowid
///   ExpString: 医保类型^数据库连接串
///出参? 0 ?-1
///说明?
function InsuIPMXUnload(Handle,UserId,BillNO,AdmReasonNationCode,AdmReasonId,ExpString)
{
	try{

	 var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
	 InsuTypeCode=GetInsuTypeCode(AdmReasonId)
	var rtn="-1";
    if (InsuTypeCode=="") {return -1;} 		
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		var rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuIPMXUpload(Handle,UserId ,BillNO,AdmReasonNationCode,AdmReasonId,ExpStrForNet);
		DHCINSUBLL= null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&BillNO="+BillNO+"&AdmReasonNationCode="+AdmReasonNationCode+"&AdmReasonId="+AdmReasonId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuIPMXUpload",getInStr,"")
	}
    if(rtn==="0"){
		dhcsys_alert("费用上传成功"); 		   
	}
    return rtn;
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
    
}

///住院明细费用删除
//入参:
///   Handle：句柄默认0;UserId:SS_User.SSUSR_RowId;BillNO:DHC_PatientBill.Rowid;AdmReasonNationCode:Pac_AdmReason.REA_NationalCode
///   AdmReasonId:Pac_AdmReason.Rowid
///   ExpString: 医保类型^数据库连接串
///出参? 0 ?-1
///说明?
function InsuIPMXCancel(Handle,UserId,BillNO,AdmReasonNationCode,AdmReasonId,ExpString)
{
	try{
	InsuTypeCode=GetInsuTypeCode(AdmReasonId)
    if (InsuTypeCode=="") {return -1;} 
    //dhcsys_alert(InsuTypeCode)
	var rtn="-1";
    var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
	 InsuTypeCode=GetInsuTypeCode(AdmReasonId)
    if (InsuTypeCode=="") {return -1;} 		
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
      //return -1
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuIPMXCancel(Handle,UserId,BillNO,AdmReasonNationCode,AdmReasonId,ExpStrForNet);
		DHCINSUBLL= null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&BillNO="+BillNO+"&AdmReasonNationCode="+AdmReasonNationCode+"&AdmReasonId="+AdmReasonId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuIPMXCancel",getInStr,"")
	}
    if(rtn==="0"){
		dhcsys_alert("费用撤销成功"); 		   
	}
    return rtn;
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
    
}

///医保病人住院结算
//入参:
///   Handle：句柄默认0;UserId:SS_User.SSUSR_RowId;BillNO:DHC_PatientBill.Rowid;AdmReasonNationCode:Pac_AdmReason.REA_NationalCode
///   AdmReasonId:Pac_AdmReason.Rowid
///   ExpString: 医保类型^数据库连接串
///Return:成功:0,失败:-1
function InsuIPDivide(Handle,UserId,BillNO,AdmReasonNationCode,AdmReasonId,ExpString)
{
	try {
	//dhcsys_alert("医保结算开始")
	//dhcsys_alert("医保结算开始:Handle="+Handle+"^UserId="+UserId+"^BillNO="+BillNO+"^AdmReasonNationCode="+AdmReasonNationCode+"^AdmReasonId="+AdmReasonId+"^ExpString="+ExpString)
	INSUPORTGLOBAL.AddDivideFlag=false;	//向计费组结算界面添加费用成功与否的标志
	if(BillNO==""){dhcsys_alert("帐单号不能空!");return;}
	 InsuTypeCode=GetInsuTypeCode(AdmReasonId)
    if (InsuTypeCode=="") {return -1;} 
	 var DivideStr="-1";
     //dhcsys_alert(InsuTypeCode)      
	//dhcsys_alert(0+":"+InsuTypeCode);
     var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
	 InsuTypeCode=GetInsuTypeCode(AdmReasonId)
    if (InsuTypeCode=="") {return -1;} 		
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
		//dhcsys_alert(Handle+"+"+BillNO+"+"+UserId+"+"+AdmReasonNationCode+"+"+AdmReasonId+"+"+ExpString)

		if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return DivideStr}	//Zhan 20181213增加配置并增加中间件功能
    	if(INSUPORTGLOBAL.httpFlag==0){
			if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
			DivideStr=INSUPORTGLOBAL.DHCINSUBLL.InsuIPDivide(Handle,UserId,BillNO,AdmReasonNationCode,AdmReasonId,ExpStrForNet);
			//dhcsys_alert(DivideStr)  //标志^总金额^统筹^附加^干保基金^帐户^现金  
			//DivideStr="0^146.7^0^0^0^146.7^0"
			//var	DivideStr="0^200^11.5^"+BillNO+String.fromCharCode(2)+"15^21.5"+String.fromCharCode(2)+"16^1000"+String.fromCharCode(2)+"17^0"+String.fromCharCode(2)+"18^500"
			DHCINSUBLL=null;  
    	}else{
			var getInStr="Handle="+Handle+"&UserId="+UserId+"&BillNO="+BillNO+"&AdmReasonNationCode="+AdmReasonNationCode+"&AdmReasonId="+AdmReasonId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
			DivideStr=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuIPDivide",getInStr,"")
	    }

		if((DivideStr=="")||(DivideStr=="-1")||(DivideStr==undefined))
		{
			return -1;
		}
		if(DivideStr=="-2") //什么情况返回-2,不用添加支付方式?
		{
			return 0;
		}
		
		//-----------如果计费组用的是老版的组件结算的界面，就用下边的添加支付方式的代码----->
		/*
		INSUAdd(DivideStr,1)	//向计费组结算界面添加各支付方式费用
		if(INSUPORTGLOBAL.AddDivideFlag==true)
		{
			return 0;
		}	
		else
		{
			return -1;
		}
		*/
		//<---------------------------------------------------------------------------------//
		
		//-------如果计费组用的是新版easyui界面，就用下边的代码，注释上边的不回支付方式的代码-->
		if("1"==GetIusujsMsgFlag("IPDIVIDE")){dhcsys_alert("医保结算完毕,返回值:"+DivideStr)}	//Zhan 20161219 弹窗增加配置
		//dhcsys_alert("DivideStr="+DivideStr)
		return DivideStr
		//<---------------------------------------------------------------------------------//
		
		

 	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
}


//医保住院结算单打印
//入参:
///   Handle：句柄默认0;UserId:SS_User.SSUSR_RowId;BillNO:DHC_PatientBill.Rowid;AdmReasonNationCode:Pac_AdmReason.REA_NationalCode
///   AdmReasonId:Pac_AdmReason.Rowid
///   ExpString: 医保类型^数据库连接串
//出参? 0 ?-1
//说明?
function InsuIPJSDPrint(Handle,UserId,BillNO,AdmReasonNationCode,AdmReasonId,ExpString)
{
	try{
		//dhcsys_alert("医保住院结算单打印开始"+Handle+"^"+UserId+"^"+BillNO+"^"+AdmReasonNationCode+"^"+AdmReasonId+"^"+ExpString) 
		//return 0;
	 var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
	 InsuTypeCode=GetInsuTypeCode(AdmReasonId)
	var rtn="-1";
    if (InsuTypeCode=="") {return -1;} 		
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuIPJSDPrint(Handle,UserId,BillNO,AdmReasonNationCode,AdmReasonId,ExpStrForNet);
		DHCINSUBLL= null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&BillNO="+BillNO+"&AdmReasonNationCode="+AdmReasonNationCode+"&AdmReasonId="+AdmReasonId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuIPJSDPrint",getInStr,"")
	}
	
	//润乾报表打印方式
	if (rtn.split("^")[0]=="0")
	{
	    var url=rtn.split("^")[1] ; //缺省例子 InsuIPJSDDefault.raq&BillDr=282055&InDivDr=&AdmDr=&ExpStr="
		DHCCPM_RQPrint(url,700,600);//DHCCPMRQCommon.js
	}
    return rtn;
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
    
}



///住院取消结算
//入参:
///   Handle：句柄默认0;UserId:SS_User.SSUSR_RowId;BillNO:DHC_PatientBill.Rowid;AdmReasonNationCode:Pac_AdmReason.REA_NationalCode
///   AdmReasonId:Pac_AdmReason.Rowid
///   ExpString: 医保类型^数据库连接串
///Return:成功:0,失败:-1
function InsuIPDivideCancle(Handle,UserId,BillNO,AdmReasonNationCode,AdmReasonId,ExpString)
{
	try {
		//dhcsys_alert("医保住院退费开始")
		//dhcsys_alert("医保住院退费开始"+Handle+"^"+UserId+"^"+BillNO+"^"+AdmReasonNationCode+"^"+AdmReasonId+"^"+ExpString)
	  	if(BillNO==""){dhcsys_alert("帐单号不能空!");return -1;}
		InsuTypeCode=GetInsuTypeCode(AdmReasonId)
	   var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
	 InsuTypeCode=GetInsuTypeCode(AdmReasonId)
	var flag="-1"
    if (InsuTypeCode=="") {return -1;} 		
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
		if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return flag}	//Zhan 20181213增加配置并增加中间件功能
		if(INSUPORTGLOBAL.httpFlag==0){
			if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
			flag=INSUPORTGLOBAL.DHCINSUBLL.InsuIPDivideStrike(Handle,UserId,BillNO,AdmReasonNationCode,AdmReasonId,ExpStrForNet);
			DHCINSUBLL=null;
		}else{
			var getInStr="Handle="+Handle+"&UserId="+UserId+"&BillNO="+BillNO+"&AdmReasonNationCode="+AdmReasonNationCode+"&AdmReasonId="+AdmReasonId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
			flag=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuIPDivideStrike",getInStr,"")
		}
		if ((flag=="0")||(flag=="-2"))
		{
			//dhcsys_alert("医保住院退费成功"); 
			if("1"==GetIusujsMsgFlag("IPDIVIDECANCLE")){dhcsys_alert("医保取消结算成功,返回值:0")}	//Zhan 20161219 弹窗增加配置
			return 0;
		}
		else
		{
			if("1"==GetIusujsMsgFlag("IPDIVIDECANCLE")){dhcsys_alert("医保取消结算失败,返回值:-1")}	//Zhan 20161219 弹窗增加配置
			return -1;
		}
 	}
 	catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
}

///医保病人门诊挂号
///入参 	Handle                    Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    用户表Rowid
///			PaadmRowid                Paadm表的Rowid
///         AdmReasonAdmSource	      Pac _admreason.rea_AdmSource
///         AdmReasonId               Pac _admreason.Rowid
///		    ExpString(:Type^Name^TotalAmount^HisDepCode^UserId^Doctor^InsuNo^CardType^YLLB^DiagCode^DiagDesc^GHLY^CacheConStr^GroupDr^AccId^AccAmt^GrzfPMDr^AdmDateTime^HisDepDesc!TarItemDr^Code^Desc^Amount!TarItemDr2^Code2^Desc2^Amount2!……	
///Return:成功:0,失败:-1 ?Rtn^InsuAdmInfoDr^InsuDivDr^PayModeDr!PayModeDr1^cash$c(2)PayModeDr2^fund$c(2)PayModeDr3^count                      
function InsuOPReg(Handle,UserId,PaadmRowid,AdmSource,AdmReasonId,ExpString)
{

	try{
	//dhcsys_alert("医保病人门诊挂号:"+Handle+"^"+UserId+"^"+PaadmRowid+"^"+AdmSource+"^"+AdmReasonId+"^"+ExpString)
	InsuTypeCode=GetInsuTypeCode(AdmReasonId)
    //if (InsuTypeCode=="") {return -1;} 
    //InsuTypeCode="SZ"
	var InsuRegStr="-1";
     var ExpStrForNet=BuildInsuExpStrStd(ExpString,12)
	 InsuTypeCode=GetInsuTypeCode(AdmReasonId)
    if (InsuTypeCode=="") {return -1;} 		
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/

	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return InsuRegStr}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		InsuRegStr=INSUPORTGLOBAL.DHCINSUBLL.InsuOPReg(Handle,UserId,PaadmRowid,AdmSource,AdmReasonId,ExpStrForNet)  
		//dhcsys_alert("InsuRegStr="+InsuRegStr)
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&PaadmRowid="+PaadmRowid+"&AdmSource="+AdmSource+"&AdmReasonId="+AdmReasonId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		InsuRegStr=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuOPReg",getInStr,"")
    }

	if ((InsuRegStr=="")||(InsuRegStr=="-1")||(InsuRegStr==undefined)) {
		if("1"==GetIusujsMsgFlag("OPREG")){dhcsys_alert("门诊挂号失败,返回值:-1")}	//Zhan 20161219 弹窗增加配置
		return "-1";
	}
	if("1"==GetIusujsMsgFlag("OPREG")){dhcsys_alert("门诊挂号成功,返回值:"+InsuRegStr)}	//Zhan 20161219 弹窗增加配置
	return InsuRegStr
	}
	catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
	finally
	{}
}

///医保病人门诊退号
///入参?	Handle                    Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    用户表Rowid
///			AdmInfoRowid              Insu_AdmInfo表的Rowid
///         AdmReasonAdmSource   	  Pac _admreason.rea_AdmSource
///         AdmReasonId               Pac _admreason.Rowid
///         ExpString:                医保类型^数据库连接串
///Return:成功:0,失败:-1
function InsuOPRegStrike(Handle,UserId,AdmInfoRowid,AdmSource,AdmReasonId,ExpString)
{
	try{
	var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)	
	InsuTypeCode=GetInsuTypeCode(AdmReasonId)
    if (InsuTypeCode=="") {return -1;} 
	var RetStr="-1"
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
    //dhcsys_alert(Handle+"^"+AdmInfoRowid+"^"+UserId+"^"+AdmSource+"^"+AdmReasonId+"^"+ExpString)
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return RetStr}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		RetStr=INSUPORTGLOBAL.DHCINSUBLL.InsuOPRegDestroy(Handle,UserId,AdmInfoRowid,AdmSource,AdmReasonId,ExpStrForNet)
		//var RetStr=INSUPORTGLOBAL.DHCINSUBLL.InsuOPRegDestroy(Handle,AdmInfoRowid,UserId,ExpString)
		//InsuOPRegDestroy(ByVal dHandle As Integer, ByVal INADMRowid As String, ByVal UserID As String, ByVal ExpStr As String) As Boolean
		//dhcsys_alert(DivideStr)
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&AdmInfoRowid="+AdmInfoRowid+"&AdmSource="+AdmSource+"&AdmReasonId="+AdmReasonId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		RetStr=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuOPRegDestroy",getInStr,"")
    }

	if ((RetStr=="")||(RetStr=="-1")||(RetStr==undefined)) {
		if("1"==GetIusujsMsgFlag("OPREGSTRIKE")){dhcsys_alert("门诊退号失败,返回值:-1")}	//Zhan 20161219 弹窗增加配置
		return "-1";
	}
	if("1"==GetIusujsMsgFlag("OPREGSTRIKE")){dhcsys_alert("门诊退号成功,返回值:"+RetStr)}	//Zhan 20161219 弹窗增加配置
	return RetStr
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
}



///医保病人门诊收费
///入参?	Handle                  Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                  用户表Rowid
///			StrInvDr                DHC_InvPrtDr表的Rowid的串   分割符为?^〃
///     AdmReasonAdmSource   		Pac_admreason.rea_AdmSource
///     AdmReasonId             	Pac_admreason.Rowid
///     ExpString                   StrikeFlag^安全组Dr^InsuNo^CardType^YLLB^DicCode^DicDesc^总金额^结算来源^数据库连接串^待遇类型^院内账户ID^院区指针^GrzfPMDr！Money^MoneyType
///											StrikeFlag：S代表退费重收的发票，如果是磁条卡需要传医保号,安全组Dr：操作员当前安全组,InsuNo：医保个人编号、医保卡号、医保号的加密串 供磁卡的地方用 
///											CardType：有无医保卡,YLLB：医疗类别（普通门诊、门诊特病、门诊工伤、门诊生育）,DicCode：病种代码,总金额：各种卡的余额合计
///										    DYLB：医保待遇类别（"131"门诊特殊病、"161"特殊检查、"162"特殊治疗）,Money:卡余额,MoneyType：卡类型 His就诊卡，银行卡。。。
///                                         GrzfPMDr: 门诊收费界面选择的支付方式Dr             
///		CPPFlag					    集中打印发票标志(Y:集中打印;NotCPPFlag:非预交金;ECPP:急诊留观)
///Return:成功:0,失败:-1
///注：给计费返回-3，计费不删除发票信息；返回-4，计费删除发票信息。
function InsuOPDivide(Handle , UserId, StrInvDr, AdmSource, AdmReasonId,ExpString,CPPFlag)
{
	try {
	OutStr="-3"
	Handle=0
	//dhcsys_alert("医保门诊收费开始")
	//dhcsys_alert("医保门诊收费开始:StrInvDr="+StrInvDr+"^UserId="+UserId+"^AdmSource="+AdmSource+"^AdmReasonId="+AdmReasonId+"^ExpString="+ExpString+"^CPPFlag="+CPPFlag)
	if (ExpString.split("!")[0].split("^").length<8) {
		dhcsys_alert("扩展参数串ExpString位数不够"+ExpString) 
		return OutStr
	}
	var DivideStr="-1";
	var ExpStrForNet=BuildInsuExpStrStd(ExpString,9)
	//dhcsys_alert("ExpStrForNet:"+ExpStrForNet)
	InsuTypeCode=GetInsuTypeCode(AdmReasonId)
    if (InsuTypeCode=="") {return OutStr;} 
    //dhcsys_alert(InsuTypeCode)
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return OutStr}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		//dhcsys_alert("医保调门诊医保接口开始:StrInvDr="+StrInvDr+"^UserId="+UserId+"^AdmSource="+AdmSource+"^AdmReasonId="+AdmReasonId+"^ExpString="+ExpString+"^CPPFlag="+CPPFlag)
		DivideStr=INSUPORTGLOBAL.DHCINSUBLL.InsuOPDivide(Handle,UserId,StrInvDr,AdmSource,AdmReasonId,ExpStrForNet,CPPFlag)

		//ExpString=ExpString+"2"
		//dhcsys_alert("ExpString="+ExpString)

		//dhcsys_alert(DivideStr)
		//var DivideStr="0^200^11.5^"+StrInvDr+String.fromCharCode(2)+"15^21.5"+String.fromCharCode(2)+"16^1000"+String.fromCharCode(2)+"17^0"+String.fromCharCode(2)+"18^500"
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&StrInvDr="+StrInvDr+"&AdmSource="+AdmSource+"&AdmReasonId="+AdmReasonId+"&ExpString="+toINSUSafeCode(ExpStrForNet)+"&CPPFlag="+CPPFlag;
		DivideStr=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuOPDivide",getInStr,"")
		if(DivideStr==""){DivideStr="-3"}
    }
	if ((DivideStr=="")||(DivideStr=="-3")||(DivideStr==undefined)) {
		if(GetIusujsMsgFlag("OPDIVIDE")=="1"){dhcsys_alert("医保结算失败,返回值:"+OutStr)}	//Zhan 20161219 弹窗增加配置
		return OutStr;
	}
	if(GetIusujsMsgFlag("OPDIVIDE")=="1"){dhcsys_alert("医保结算成功,返回值:"+DivideStr)}	//Zhan 20161219 弹窗增加配置
	return DivideStr
	
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -4 ;		//计费-4调用删除
	}
}
///医保病人门诊结算单打印
///入参?	Handle                   	Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    	用户表Rowid
///			StrInvDr                  	DHC_INVPRT.Rowid或进程号或DHC_PE_INVPRT.Rowid
///         AdmReasonAdmSource   		Pac_admreason.rea_AdmSource
///         AdmReasonId             	Pac_admreason.Rowid
///         ExpString:                  医保类型^数据库连接串
///			CPPFlag						集中打印发票标志
///Return:成功:0,失败:-1
function InsuOPJSDPrint(Handle,UserId,StrInvDr,AdmSource,AdmReasonId,ExpString,CPPFlag)
{
	try {
	OutStr="-1"
	Handle=0
	//dhcsys_alert("医保门诊结算单打印开始:StrInvDr="+StrInvDr"^UserId="+UserId+"^AdmReasonId="+AdmReasonId+"^ExpString="+ExpString+"^CPPFlag="+CPPFlag)
    var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
	InsuTypeCode=GetInsuTypeCode(AdmReasonId)
    if (InsuTypeCode=="") {return -1;} 
	var DivideStr="-1";
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return DivideStr}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		DivideStr=INSUPORTGLOBAL.DHCINSUBLL.InsuOPJSDPrint(Handle,UserId,StrInvDr,AdmSource,AdmReasonId,ExpStrForNet,CPPFlag)
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&StrInvDr="+StrInvDr+"&AdmSource="+AdmSource+"&AdmReasonId="+AdmReasonId+"&ExpString="+toINSUSafeCode(ExpStrForNet)+"&CPPFlag="+CPPFlag;
		DivideStr=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuOPJSDPrint",getInStr,"")
		if(DivideStr==""){DivideStr="-3"}
    }
	return DivideStr
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
}
///医保病人门诊退费
///入参?	Handle                   	Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    	用户表Rowid
///			DivRowid                  	Insu_Divide表的Rowid的
///         AdmReasonAdmSource   		Pac_admreason.rea_AdmSource
///         AdmReasonId             	Pac_admreason.Rowid
///         ExpString:                  医保类型^计费异常回滚标识(Y,)^医保组异常回滚标识(Y,)^读卡标识^结算来源^数据库连接串
///			CPPFlag						集中打印发票标志
///Return:成功:0,失败:-1
function InsuOPDivideStrike(Handle,UserId,DivRowid,AdmSource,AdmReasonId,ExpString,CPPFlag)
{
	try {
	OutStr="-1"
	Handle=0
	//dhcsys_alert("医保门诊撤销开始")
	//dhcsys_alert("医保门诊退费开始:DivRowid="+DivRowid+"^UserId="+UserId+"^AdmReasonId="+AdmReasonId+"^ExpString="+ExpString+"^CPPFlag="+CPPFlag)
    var ExpStrForNet=BuildInsuExpStrStd(ExpString,5)
	InsuTypeCode=GetInsuTypeCode(AdmReasonId)
    if (InsuTypeCode=="") {return -1;} 

	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return OutStr}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		var DivideStr=INSUPORTGLOBAL.DHCINSUBLL.InsuOPDivideStrike(Handle,UserId,DivRowid,AdmSource,AdmReasonId,ExpStrForNet,CPPFlag)
		//var DivideStr=INSUPORTGLOBAL.DHCINSUBLL.InsuOPDivideStrike(Handle,DivRowid,UserId,ExpString)
		
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&DivRowid="+DivRowid+"&AdmSource="+AdmSource+"&AdmReasonId="+AdmReasonId+"&ExpString="+toINSUSafeCode(ExpStrForNet)+"&CPPFlag="+CPPFlag;
		DivideStr=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuOPDivideStrike",getInStr,"")
		if(DivideStr==""){DivideStr="-1"}
    }
	if ((DivideStr=="")||(DivideStr=="-1")||(DivideStr==undefined)) {
		if(GetIusujsMsgFlag("OPDIVIDECANCLE")==""){dhcsys_alert("医保取消结算失败,返回值:"+OutStr)}	//Zhan 20161219 弹窗增加配置
		return OutStr;
	}
	if(GetIusujsMsgFlag("OPDIVIDECANCLE")==""){dhcsys_alert("医保取消结算成功,返回值:"+DivideStr)}	//Zhan 20161219 弹窗增加配置
	return DivideStr
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
}



///医保病人门诊体检收费
///入参?	Handle                   Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    用户表Rowid
///			StrInvDr                  DHC_PE_INVPRT表的RowID^RowID1^RowID2
///     AdmReasonAdmSource   		Pac_admreason.rea_AdmSource
///     AdmReasonId             	Pac_admreason.Rowid
///     ExpString(JS)               StrikeFlag^安全组Dr^InsuNo^CardType^YLLB^DicCode^DicDesc^总金额^结算来源^待遇类型！Money^MoneyType
///     ExpString                   StrikeFlag^安全组Dr^InsuNo^CardType^YLLB^DicCode^DicDesc^总金额^结算来源^数据库连接串^待遇类型^院内账户ID^院区指针^GrzfPMDr！Money^MoneyType
///											StrikeFlag：S代表退费重收的发票，如果是磁条卡需要传医保号,安全组Dr：操作员当前安全组,InsuNo：医保个人编号、医保卡号、医保号的加密串 供磁卡的地方用 
///											CardType：有无医保卡,YLLB：医疗类别（普通门诊、门诊特病、门诊工伤、门诊生育）,DicCode：病种代码,总金额：各种卡的余额合计
///										    DYLB：医保待遇类别（"131"门诊特殊病、"161"特殊检查、"162"特殊治疗）,Money:卡余额,MoneyType：卡类型 His就诊卡，银行卡。。。
///                                         GrzfPMDr: 门诊收费界面选择的支付方式Dr   
///			CPPFlag					集中打印发票标志
///Return:0：成功，-1：失败（可以直接出自费发票）-3：失败 （需要删除自费结算的数据）
function InsuPEDivide(Handle,UserId,StrInvDr,AdmSource, AdmReasonId,ExpString,CPPFlag)
{ 
	try {
	OutStr="-3"
	Handle=0
	//dhcsys_alert("医保门诊收费开始:StrInvDr="+StrInvDr+"^UserId="+UserId+"^AdmSource="+AdmSource+"^AdmReasonId="+AdmReasonId+"^ExpString="+ExpString+"^CPPFlag="+CPPFlag)
	if (ExpString.split("!")[0].split("^").length<7) {
		dhcsys_alert("扩展参数串ExpString位数不够"+ExpString) 
		return OutStr
	}
	var DivideStr="-1";
    var ExpStrForNet=BuildInsuExpStrStd(ExpString,9)
	InsuTypeCode=GetInsuTypeCode(AdmReasonId)
    if (InsuTypeCode=="") {return OutStr;} 
    //dhcsys_alert(InsuTypeCode)
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return OutStr}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		DivideStr=INSUPORTGLOBAL.DHCINSUBLL.InsuPEDivide(Handle,UserId,StrInvDr,AdmSource,AdmReasonId,ExpStrForNet,CPPFlag)

		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&StrInvDr="+StrInvDr+"&AdmSource="+AdmSource+"&AdmReasonId="+AdmReasonId+"&ExpString="+toINSUSafeCode(ExpStrForNet)+"&CPPFlag="+CPPFlag;
		DivideStr=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuPEDivide",getInStr,"")
		if(DivideStr==""){DivideStr="-3"}
    }
	if ((DivideStr=="")||(DivideStr=="-3")||(DivideStr==undefined)) {
		if(GetIusujsMsgFlag("PEDIVIDE")==""){dhcsys_alert("医保结算失败,返回值:"+OutStr)}	//Zhan 20161219 弹窗增加配置
		return OutStr;
	}
	if(GetIusujsMsgFlag("PEDIVIDE")==""){dhcsys_alert("医保结算成功,返回值:"+DivideStr)}	//Zhan 20161219 弹窗增加配置
	return DivideStr
	
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -4 ;		//计费-4调用删除
	}  
}

///医保病人体检退费
///入参?	Handle                   	Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    	用户表Rowid
///			DivRowid                  	Insu_Divide表的Rowid的
///         AdmReasonAdmSource   		Pac_admreason.rea_AdmSource
///         AdmReasonId             	Pac_admreason.Rowid
///         ExpString:                  医保类型^计费异常回滚标识(Y,)^医保组异常回滚标识(Y,)^读卡标识^结算来源^数据库连接串
///			CPPFlag						集中打印发票标志
///Return:成功:0,失败:-1
function InsuPEDivideStrike(Handle,UserId,DivRowid,AdmSource,AdmReasonId,ExpString,CPPFlag)
{
	try {
	OutStr="-1"
	Handle=0
	//dhcsys_alert("医保门诊退费开始:DivRowid="+DivRowid+"^UserId="+UserId+"^AdmReasonId="+AdmReasonId+"^ExpString="+ExpString+"^CPPFlag="+CPPFlag)
    var ExpStrForNet=BuildInsuExpStrStd(ExpString,5)
	InsuTypeCode=GetInsuTypeCode(AdmReasonId)
    if (InsuTypeCode=="") {return -1;} 
	var DivideStr="-1";
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return DivideStr}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		DivideStr=INSUPORTGLOBAL.DHCINSUBLL.InsuPEDivideStrike(Handle,UserId,DivRowid,AdmSource,AdmReasonId,ExpStrForNet,CPPFlag)
		//var DivideStr=INSUPORTGLOBAL.DHCINSUBLL.InsuOPDivideStrike(Handle,DivRowid,UserId,ExpString)
		
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&DivRowid="+DivRowid+"&AdmSource="+AdmSource+"&AdmReasonId="+AdmReasonId+"&ExpString="+toINSUSafeCode(ExpStrForNet)+"&CPPFlag="+CPPFlag;
		DivideStr=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuPEDivideStrike",getInStr,"")
		if(DivideStr==""){DivideStr="-1"}
    }
	if ((DivideStr=="")||(DivideStr=="-1")||(DivideStr==undefined)) {
		if(GetIusujsMsgFlag("PEDivideStrike")==""){dhcsys_alert("医保体检取消结算失败,返回值:"+OutStr)}
		return OutStr;
	}
	if(GetIusujsMsgFlag("PEDivideStrike")==""){dhcsys_alert("医保体检取消结算成功,返回值:"+DivideStr)}
	return DivideStr
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
}


/// 医保目录下载
///入参 	Handle                   	Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    	用户表Rowid
///         ExpString:                  医保类型^数据库连接串
///出参:成功:0,失败:-1
function InsuTarItmDL(Handle,UserId,ExpString) 
{
	try {
	OutStr="-1"
	//dhcsys_alert("医保目录下载开始Handle="+Handle+"UserId="+UserId+"ExpString="+ExpString)
	InsuTypeCode=ExpString.split("^")[0]
	var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
    if (InsuTypeCode=="") 
    {
	    dhcsys_alert("扩展参数医保类型为空")
	    return -1;
	 } 
	var rtn="-1";
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuTarItmDL(Handle,UserId,ExpStrForNet)
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuTarItmDL",getInStr,"")
		if(rtn==""){rtn="-1"}
    }
	if ((rtn=="")||(rtn=="-1")||(rtn==undefined)) {return OutStr;}
	return rtn
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
	
}

/// 医保诊断下载
///入参 	Handle                   	Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    	用户表Rowid
///         ExpString:                 医保类型^数据库连接串
///出参:成功:0,失败:-1
function InsuDiagnosisDL(Handle,UserId,ExpString) 
{
	try {
	OutStr="-1"
	//dhcsys_alert("医保诊断下载开始Handle="+Handle+"UserId="+UserId+"ExpString="+ExpString)
	InsuTypeCode=ExpString.split("^")[0]
	var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
    if (InsuTypeCode=="") 
    {
	    dhcsys_alert("扩展参数医保类型为空")
	    return -1;
	 } 
	var rtn="-1";
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuDiagnosisDL(Handle,UserId,ExpStrForNet)
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuDiagnosisDL",getInStr,"")
		if(rtn==""){rtn="-1"}
    }
	if ((rtn=="")||(rtn=="-1")||(rtn==undefined)) {return OutStr;}
	return rtn
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
	
}

/// 医保字典下载
///入参 	Handle                   	Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    	用户表Rowid
///         ExpString:                  医保类型^数据库连接串
///出参:成功:0,失败:-1
function InsuBasDicDL(Handle,UserId,ExpString) 
{
	try {
	OutStr="-1"
	//dhcsys_alert("医保字典下载开始Handle="+Handle+"UserId="+UserId+"ExpString="+ExpString)
	InsuTypeCode=ExpString.split("^")[0]
	var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
    if (InsuTypeCode=="") 
    {
	    dhcsys_alert("扩展参数医保类型为空")
	    return -1;
	 } 
	 var rtn="-1";
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuBasDicDL(Handle,UserId,ExpStrForNet)
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuBasDicDL",getInStr,"")
		if(rtn==""){rtn="-1"}
    }
	if ((rtn=="")||(rtn=="-1")||(rtn==undefined)) {return OutStr;}
	return rtn
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
	
}
/// 医保目录对照关系下载
///入参 	Handle                   	Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    	用户表Rowid
///         ConDr                       INSU_TarContrast.Rowid(可为空)
///         ExpString:                  医保类型^数据库连接串
///出参:成功:0,失败:-1
function InsuTarConDL(Handle,UserId,ConDr,ExpString)
{
	try {
	OutStr="-1"
	//dhcsys_alert("医保对照关系下载开始Handle="+Handle+"UserId="+UserId+"ConDr="+ConDr+"ExpString="+ExpString)
	InsuTypeCode=ExpString.split("^")[0]
	var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
    if (InsuTypeCode=="") 
    {
	    dhcsys_alert("扩展参数医保类型为空")
	    return -1;
	 } 
	 var rtn="-1";
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuTarConDL(Handle,UserId,ConDr,ExpStrForNet)
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&ConDr="+ConDr+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuTarConDL",getInStr,"")
		if(rtn==""){rtn="-1"}
    }
	if ((rtn=="")||(rtn=="-1")||(rtn==undefined)) {return OutStr;}
	return rtn
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
	
}

/// 医保目录对照关系上传
///入参 	Handle                   	Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    	用户表Rowid
///         ConDr                       INSU_TarContrast.Rowid
///         ExpString:                  医保类型^数据库连接串
///出参:成功:0,失败:-1
function InsuTarConUL(Handle,UserId,ConDr,ExpString)
{
	try {
	OutStr="-1"
	//dhcsys_alert("医保目录对照关系上传开始Handle="+Handle+"UserId="+UserId+"ConDr="+ConDr+"ExpString="+ExpString)
	InsuTypeCode=ExpString.split("^")[0]
	var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
    if (InsuTypeCode=="") 
    {
	    dhcsys_alert("扩展参数医保类型为空")
	    return -1;
	 } 
	 var rtn="-1";
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuTarConUL(Handle,UserId,ConDr,ExpStrForNet)
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&ConDr="+ConDr+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuTarConUL",getInStr,"")
		if(rtn==""){rtn="-1"}
    }
	if ((rtn=="")||(rtn=="-1")||(rtn==undefined)) {return OutStr;}
	return rtn
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
	
}

/// 医保目录对照关系删除
///入参 	Handle                   	Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    	用户表Rowid
///         ConDr                       INSU_TarContrast.Rowid
///         ExpString:                  医保类型^数据库连接串
///出参:成功:0,失败:-1
function InsuTarConDelete(Handle,UserId,ConDr,ExpString)
{
	try {
	OutStr="-1"
	var rtn="-1";
	//dhcsys_alert("医保目录对照关系删除开始Handle="+Handle+"UserId="+UserId+"ConDr="+ConDr+"ExpString="+ExpString)
	InsuTypeCode=ExpString.split("^")[0]
	var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
    if (InsuTypeCode=="") 
    {
	    dhcsys_alert("扩展参数医保类型为空")
	    return -1;
	 } 
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuTarConDelete(Handle,UserId,ConDr,ExpStrForNet)
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&ConDr="+ConDr+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuTarConDelete",getInStr,"")
		if(rtn==""){rtn="-1"}
    }
	if ((rtn=="")||(rtn=="-1")||(rtn==undefined)) {return OutStr;}
	return rtn
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
	
}

/// 医保字典对照上传
///入参 	Handle                   	Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    	用户表Rowid
///         ExpString:                  医保类型^数据库连接串
///出参:成功:0,失败:-1
function InsuBasDicUL(Handle,UserId,ExpString)
{
	try {
	OutStr="-1"
	var rtn="-1";
	//dhcsys_alert("医保字典对照上传开始Handle="+Handle+"UserId="+UserId+"ExpString="+ExpString)
	InsuTypeCode=ExpString.split("^")[0]
	var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
    if (InsuTypeCode=="") 
    {
	    dhcsys_alert("扩展参数医保类型为空")
	    return -1;
	 } 
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuBasDicUL(Handle,UserId,ExpStrForNet)
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuBasDicUL",getInStr,"")
		if(rtn==""){rtn="-1"}
    }
	if ((rtn=="")||(rtn=="-1")||(rtn==undefined)) {return OutStr;}
	return rtn
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
	
}

/// 医护人员信息上传
///入参 	Handle                   	Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    	用户表Rowid
///         ExpString:                  医保类型^数据库连接串
///出参:成功:0,失败:-1
function InsuDicCTCareprovUL(Handle,UserId,ExpString)
{
	try {
	OutStr="-1"
	var rtn="-1";
	//dhcsys_alert("医保医护人员信息上传开始Handle="+Handle+"UserId="+UserId+"ExpString="+ExpString)
	InsuTypeCode=ExpString.split("^")[0]
	var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
    if (InsuTypeCode=="") 
    {
	    dhcsys_alert("扩展参数医保类型为空")
	    return -1;
	 } 
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuDicCTCareprovUL(Handle,UserId,ExpStrForNet)
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuDicCTCareprovUL",getInStr,"")
		if(rtn==""){rtn="-1"}
    }
	if ((rtn=="")||(rtn=="-1")||(rtn==undefined)) {return OutStr;}
	return rtn
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
	
}



/// 医护人员信息下载
///入参 	Handle                   	Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    	用户表Rowid
///         ExpString:                  医保类型^数据库连接串
///出参:成功:0,失败:-1
function InsuDicCTCareprovDL(Handle,UserId,ExpString)
{
	try {
	OutStr="-1"
	var rtn="-1";
	//dhcsys_alert("医保医护人员信息下载开始Handle="+Handle+"UserId="+UserId+"ExpString="+ExpString)
	InsuTypeCode=ExpString.split("^")[0]
	var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
    if (InsuTypeCode=="") 
    {
	    dhcsys_alert("扩展参数医保类型为空")
	    return -1;
	 } 
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuDicCTCareprovUL(Handle,UserId,ExpStrForNet)
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuDicCTCareprovDL",getInStr,"")
		if(rtn==""){rtn="-1"}
    }
	if ((rtn=="")||(rtn=="-1")||(rtn==undefined)) {return OutStr;}
	return rtn
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
	
}




/// 剂型信息上传
///入参 	Handle                   	Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    	用户表Rowid
///         ExpString:                  医保类型^数据库连接串
///出参:成功:0,失败:-1
function InsuDicJXUL(Handle,UserId,ExpString)
{
	try {
	OutStr="-1"
	var rtn="-1";
	//dhcsys_alert("医保剂型信息上传开始Handle="+Handle+"UserId="+UserId+"ExpString="+ExpString)
	InsuTypeCode=ExpString.split("^")[0]
	var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
    if (InsuTypeCode=="") 
    {
	    dhcsys_alert("扩展参数医保类型为空")
	    return -1;
	 } 
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuDicJXUL(Handle,UserId,ExpStrForNet)
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuDicJXUL",getInStr,"")
		if(rtn==""){rtn="-1"}
    }
	if ((rtn=="")||(rtn=="-1")||(rtn==undefined)) {return OutStr;}
	return rtn
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
	
}

/// 科室信息上传
///入参 	Handle                   	Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    	用户表Rowid
///         ExpString:                  医保类型^数据库连接串
///出参:成功:0,失败:-1
function InsuDicCTLocUL(Handle,UserId,ExpString)
{
	try {
	OutStr="-1"
	var rtn="-1";
	//dhcsys_alert("医保科室信息上传开始Handle="+Handle+"UserId="+UserId+"ExpString="+ExpString)
	InsuTypeCode=ExpString.split("^")[0]
	var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
    if (InsuTypeCode=="") 
    {
	    dhcsys_alert("扩展参数医保类型为空")
	    return -1;
	 } 
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuDicCTLocUL(Handle,UserId,ExpStrForNet)
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuDicCTLocUL",getInStr,"")
		if(rtn==""){rtn="-1"}
    }
	if ((rtn=="")||(rtn=="-1")||(rtn==undefined)) {return OutStr;}
	return rtn
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
	
}



/// 科室信息下载
///入参 	Handle                   	Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    	用户表Rowid
///         ExpString:                  医保类型^数据库连接串
///出参:成功:0,失败:-1
function InsuDicCTLocDL(Handle,UserId,ExpString)
{
	try {
	OutStr="-1"
	var rtn="-1";
	//dhcsys_alert("医保科室信息下载开始Handle="+Handle+"UserId="+UserId+"ExpString="+ExpString)
	InsuTypeCode=ExpString.split("^")[0]
	var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
    if (InsuTypeCode=="") 
    {
	    dhcsys_alert("扩展参数医保类型为空")
	    return -1;
	 } 
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuDicCTLocDL(Handle,UserId,ExpStrForNet)
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuDicCTLocDL",getInStr,"")
		if(rtn==""){rtn="-1"}
    }
	if ((rtn=="")||(rtn=="-1")||(rtn==undefined)) {return OutStr;}
	return rtn
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
	
}





/// 收费类别信息上传
///入参 	Handle                   	Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    	用户表Rowid
///         ExpString:                  医保类型^数据库连接串
///出参:成功:0,失败:-1
function InsuDicTarCateUL(Handle,UserId,ExpString)
{
	try {
	OutStr="-1"
	var rtn="-1";
	//dhcsys_alert("收费类别信息上传开始Handle="+Handle+"UserId="+UserId+"ExpString="+ExpString)
	InsuTypeCode=ExpStr.split("^")[0]
	var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
    if (InsuTypeCode=="") 
    {
	    dhcsys_alert("扩展参数医保类型为空")
	    return -1;
	 } 
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuDicTarCateUL(Handle,UserId,ExpStrForNet)
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuDicTarCateUL",getInStr,"")
		if(rtn==""){rtn="-1"}
    }
	if ((rtn=="")||(rtn=="-1")||(rtn==undefined)) {return OutStr;}
	return rtn
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
	
}


/// HIS字典信息上传
///入参 	Handle                   	Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    	用户表Rowid
///         ExpString:                  医保类型^数据库连接串
///出参:成功:0,失败:-1
function InsuHisDicUL(Handle,UserId,ExpString)
{
	try {
	OutStr="-1"
	var rtn="-1";
	//dhcsys_alert("HIS字典信息上传开始Handle="+Handle+"UserId="+UserId+"ExpString="+ExpString)
	InsuTypeCode=ExpStr.split("^")[0]
	var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
    if (InsuTypeCode=="") 
    {
	    dhcsys_alert("扩展参数医保类型为空")
	    return -1;
	 } 
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuHisDicUL(Handle,UserId,ExpStrForNet)
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuHisDicUL",getInStr,"")
		if(rtn==""){rtn="-1"}
    }
	if ((rtn=="")||(rtn=="-1")||(rtn==undefined)) {return OutStr;}
	return rtn
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
	
}


/// 医保签到
///入参 	Handle                   	Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    	用户表Rowid
///         ExpString):                 医保类型^数据库连接串^部门性质(1:门诊，2：住院)
///出参:成功:0,失败:-1
function InsuASSignIn(Handle,UserId,ExpString)
{
	try {
	OutStr="-1"
	var rtn="-1";
	//dhcsys_alert("医保签到开始Handle="+Handle+"UserId="+UserId+"ExpString="+ExpString)
	InsuTypeCode=ExpString.split("^")[0]
	var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
    if (InsuTypeCode=="") 
    {
	    dhcsys_alert("扩展参数医保类型为空")
	    return -1;
	 } 
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuASSignIn(Handle,UserId,ExpStrForNet)
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuASSignIn",getInStr,"")
		if(rtn==""){rtn="-1"}
    }
	if ((rtn=="")||(rtn=="-1")||(rtn==undefined)) {return OutStr;}
	return rtn
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
	
}



// 医保签退
///入参 	Handle                   	Interger?医保返回的句柄?目前大部分项目部用?不用的地方固定成?0〃
///			UserId                    	用户表Rowid
///         ExpString:                  医保类型^数据库连接串^部门性质(1:门诊，2：住院)^业务周期号
///出参:成功:0,失败:-1
function InsuASSignOut(Handle,UserId,ExpString)
{
	try {
	OutStr="-1"
	var rtn="-1";
	//dhcsys_alert("医保签退开始Handle="+Handle+"UserId="+UserId+"ExpString="+ExpString)
	InsuTypeCode=ExpString.split("^")[0]
	var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
    if (InsuTypeCode=="") 
    {
	    dhcsys_alert("扩展参数医保类型为空")
	    return -1;
	 } 
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuASSignOut(Handle,UserId,ExpStrForNet)
		DHCINSUBLL=null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuASSignOut",getInStr,"")
		if(rtn==""){rtn="-1"}
    }
	if ((rtn=="")||(rtn=="-1")||(rtn==undefined)) {return OutStr;}
	return rtn
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
	
}


//住院，只取消医保结算
///Input:
///         Handle                      除合肥外固定为0
///         BillNo                      DHC_PatientBill.Rowid              
///         AdmReasonNationCode    		pa_admreason.rea_nationcode
///         AdmReasonId             	pa_admreason.Rowid
///         ExpString                   医保类型^结算单据流水号^发送方交易流水发送方交易流水号^数据库连接串
///Return:成功:0,失败:-1
function InsuIPDivideCancleForInsu(Handle,UserId,djlsh0,AdmReasonNationCode,AdmReasonId,ExpString)
{
	try {
		//dhcsys_alert("医保住院退费[只退医保]开始"+Handle+"^"+UserId+"^"+djlsh0+"^"+AdmReasonNationCode+"^"+AdmReasonId+"^"+ExpString)
	  	if(djlsh0==""){dhcsys_alert("单据流水号不能空!");return -1;}
	  	var ExpStrForNet=BuildInsuExpStrStd(ExpString,3)
		InsuTypeCode=GetInsuTypeCode(AdmReasonId)
	    if (InsuTypeCode=="") {return -1;} 
		var rtn="-1";
	   	//dhcsys_alert(InsuTypeCode)
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
			if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
			if(INSUPORTGLOBAL.httpFlag==0){
				if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
				var flag=INSUPORTGLOBAL.DHCINSUBLL.InsuIPDivideStrikeForInsu(Handle,UserId,djlsh0,AdmReasonNationCode,AdmReasonId,ExpStrForNet);
				DHCINSUBLL=null;
			}else{
				var getInStr="Handle="+Handle+"&UserId="+UserId+"&djlsh0="+djlsh0+"&AdmReasonNationCode="+AdmReasonNationCode+"&AdmReasonId="+AdmReasonId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
				flag=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuIPDivideStrikeForInsu",getInStr,"")
			}
	  		if ((flag=="0")||(flag=="-2"))
	  		{
		  		//dhcsys_alert("医保住院退费[只退医保]成功"); 
		  		if(GetIusujsMsgFlag("IPDIVIDECANCLE")=="1"){dhcsys_alert("医保住院退费[只退医保]成功,返回值:0")}	//Zhan 20161219 弹窗增加配置 
	    		return 0;
	  		}
	  		else
			{
				if(GetIusujsMsgFlag("IPDIVIDECANCLE")=="1"){dhcsys_alert("医保住院退费[只退医保]失败,返回值:-1")}	//Zhan 20161219 弹窗增加配置 
				return -1;
			}
 	}
 	catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
}




///住院，只取消His结算
///Input:
///         Handle                      除合肥外固定为0 
///         BillNo                      DHC_PatientBill.Rowid              
///         AdmReasonNationCode    		pa_admreason.rea_nationcode
///         AdmReasonId             	pa_admreason.Rowid
///         ExpString                   医保类型^结算单据流水号^发送方交易流水发送方交易流水号^数据库连接串
///Return:成功:0,失败:-1
function InsuIPDivideCancleForHis(Handle,UserId,BillNo,AdmReasonNationCode,AdmReasonId,ExpString)
{
	try {
		var rtn="-1";
		var flag="-1";
		//dhcsys_alert("医保住院退费[只退HIS]开始"+Handle+"^"+UserId+"^"+djlsh0+"^"+AdmReasonNationCode+"^"+AdmReasonId+"^"+ExpString)
	  	if(BillNo==""){dhcsys_alert("账单号不能空!");return -1;}
	  	var ExpStrForNet=BuildInsuExpStrStd(ExpString,3)
		InsuTypeCode=GetInsuTypeCode(AdmReasonId)
	    if (InsuTypeCode=="") {return -1;} 
	   	//dhcsys_alert(InsuTypeCode)
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
			if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return flag}	//Zhan 20181213增加配置并增加中间件功能
			if(INSUPORTGLOBAL.httpFlag==0){
				if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
				flag=INSUPORTGLOBAL.DHCINSUBLL.InsuIPDivideStrikeForHis(Handle,UserId,BillNo,AdmReasonNationCode,AdmReasonId,ExpStrForNet);
				DHCINSUBLL=null;
			}else{
				var getInStr="Handle="+Handle+"&UserId="+UserId+"&BillNo="+BillNo+"&AdmReasonNationCode="+AdmReasonNationCode+"&AdmReasonId="+AdmReasonId+"&ExpString="+toINSUSafeCode(ExpStrForNet);
				flag=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuIPDivideStrikeForHis",getInStr,"")
			}
	  		if ((flag=="0")||(flag=="-2"))
	  		{
		  		//dhcsys_alert("医保住院退费[只退HIS]成功");
		  		if(GetIusujsMsgFlag("IPDIVIDECANCLE")=="1"){dhcsys_alert("医保住院退费[只退HIS]成功,返回值:0")}	//Zhan 20161219 弹窗增加配置 
	    		return 0;
	  		}
	  		else
			{
				if(GetIusujsMsgFlag("IPDIVIDECANCLE")=="1"){dhcsys_alert("医保住院退费[只退HIS]失败,返回值:-1")}	//Zhan 20161219 弹窗增加配置 
				return -1;
			}
 	}
 	catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
}


//门诊，只取消医保结算
///Input:
///         Handle                      除合肥外固定为0
///         djlsh0                      结算单据流水号
///         AdmSource    		         pa_admreason.AdmSource
///         AdmReasonId             	pa_admreason.Rowid
///         ExpString                   医保类型^发送方交易流水号^数据库连接串
///         CPPFlag                     集中打印标识
///Return:成功:0,失败:-1
function InsuOPDivideCancleForInsu(Handle,UserId,djlsh0,AdmSource,AdmReasonId,ExpString,CPPFlag)
{
	try {
		//dhcsys_alert("医保住院退费[只退医保]开始"+Handle+"^"+UserId+"^"+djlsh0+"^"+AdmReasonNationCode+"^"+AdmReasonId+"^"+ExpString)
	  	if(djlsh0==""){dhcsys_alert("单据流水号不能空!");return -1;}
		var flag="-1";
	  	var ExpStrForNet=BuildInsuExpStrStd(ExpString,2)
		InsuTypeCode=GetInsuTypeCode(AdmReasonId)
	    if (InsuTypeCode=="") {return -1;} 
	   	//dhcsys_alert(InsuTypeCode)
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
			if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return flag}	//Zhan 20181213增加配置并增加中间件功能
			if(INSUPORTGLOBAL.httpFlag==0){
				if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
				flag=INSUPORTGLOBAL.DHCINSUBLL.InsuOPDivideStrikeForInsu(Handle,UserId,djlsh0,AdmSource,AdmReasonId,ExpStrForNet,CPPFlag);
				DHCINSUBLL=null;
			}else{
				var getInStr="Handle="+Handle+"&UserId="+UserId+"&djlsh0="+djlsh0+"&AdmSource="+AdmSource+"&AdmReasonId="+AdmReasonId+"&ExpString="+toINSUSafeCode(ExpStrForNet)+"&CPPFlag="+CPPFlag;
				flag=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuOPDivideStrikeForInsu",getInStr,"")
			}
	  		if ((flag=="0")||(flag=="-2"))
	  		{
		  		//dhcsys_alert("医保住院退费[只退医保]成功"); 
		  		if(GetIusujsMsgFlag("OPDIVIDECANCLE")==""){dhcsys_alert("医保退费[只退医保]成功,返回值:0")}	//Zhan 20161219 弹窗增加配置
	    		return 0;
	  		}
	  		else
			{
				if(GetIusujsMsgFlag("OPDIVIDECANCLE")==""){dhcsys_alert("医保退费[只退医保]失败,返回值:-1")}	//Zhan 20161219 弹窗增加配置
				return -1;
			}
 	}
 	catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
}

///门诊，只取消His结算
///Input:
///         Handle                      除合肥外固定为0
///         DivRowid                    Insu_Divide.Rowid   
///         AdmSource    		        pa_admreason.rea_AdmSource
///         AdmReasonId             	pa_admreason.Rowid
///         ExpString                   医保类型^数据库连接串
///         CPPFlag                     集中打印标识
///Return:成功:0,失败:-1
function InsuOPDivideCancleForHis(Handle,UserId,DivRowid,AdmSource,AdmReasonId,ExpString,CPPFlag)
{
	try {
		//dhcsys_alert("医保住院退费[只退HIS]开始"+Handle+"^"+UserId+"^"+DivRowid+"^"+AdmSource+"^"+AdmReasonId+"^"+ExpString)
	  	if(DivRowid==""){dhcsys_alert("Insu_Divide.Rowid不能空!");return -1;}
	  	var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
		InsuTypeCode=GetInsuTypeCode(AdmReasonId)
		var flag="-1";
	    if (InsuTypeCode=="") {return -1;} 
	   	//dhcsys_alert(InsuTypeCode)
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/
			if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return flag}	//Zhan 20181213增加配置并增加中间件功能
			if(INSUPORTGLOBAL.httpFlag==0){
				if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
				flag=INSUPORTGLOBAL.DHCINSUBLL.InsuOPDivideStrikeForHis(Handle,UserId,DivRowid,AdmSource,AdmReasonId,ExpStrForNet,CPPFlag);
				DHCINSUBLL=null;
			}else{
				var getInStr="Handle="+Handle+"&UserId="+UserId+"&DivRowid="+DivRowid+"&AdmSource="+AdmSource+"&AdmReasonId="+AdmReasonId+"&ExpString="+toINSUSafeCode(ExpStrForNet)+"&CPPFlag="+CPPFlag;
				flag=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuOPDivideStrikeForHis",getInStr,"")
			}
	  		if ((flag=="0")||(flag=="-2"))
	  		{
		  		//dhcsys_alert("医保住院退费[只退HIS]成功"); 
		  		if(GetIusujsMsgFlag("OPDIVIDECANCLE")==""){dhcsys_alert("医保退费[只退HIS]成功,返回值:0")}	//Zhan 20161219 弹窗增加配置
	    		return 0;
	  		}
	  		else
			{
				if(GetIusujsMsgFlag("OPDIVIDECANCLE")==""){dhcsys_alert("医保退费[只退HIS]失败,返回值:-1")}	//Zhan 20161219 弹窗增加配置
				return -1;
			}
 	}
 	catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
}


///****************************公共函数*****************


///根据病人类型得到医保类型XZA,XZB等
function GetInsuTypeCode(AdmreaonDr)
	{
	var VerStr="";
	VerStr=tkMakeServerCall("web.INSUDicDataCom","QueryByCode","AdmReasonDrToDLLType",AdmreaonDr,INSUPORTGLOBAL.HospID);
	if ((VerStr=="0")||(VerStr=="")){
		dhcsys_alert(VerStr + "根据费别表rowid未取到医保类型。\n\n请核对病人费别是否改成自费了,或者检查AdmReasonDrToDLLType对照")
		return "";
	}
    InsuTypeCode=VerStr.split("^")[5]    //得到医保类型代码  XZA,XZB.XZC等 
	return InsuTypeCode
	} 
function GetINSUdbEncrypt()
	{
	var VerStr="";
	VerStr=tkMakeServerCall("web.INSUDicDataCom","QueryByCode","SYS","DBEncrypt",INSUPORTGLOBAL.HospID);
	if ((VerStr=="0")||(VerStr=="")){
		dhcsys_alert(VerStr + "未取到数据库连接加密信息串,请在医保字典的系统中配置DBEncrypt")
		return "";
	}else{
		INSUPORTGLOBAL.dbEncrypt="|"+VerStr.split("^")[5]+"|"+VerStr.split("^")[6]+"|"+VerStr.split("^")[4]+"|"+VerStr.split("^")[11]+"|"+document.location.port+"|"+"HOSPID:"+INSUPORTGLOBAL.HospID
	}
	return INSUPORTGLOBAL.dbEncrypt
	} 
// 功能描述:获取医保类型对应的医保DLL相关配置
// Zhan 20181213
// 入参:InsuTypeCode:医保类别代码如ZZB
// 返回:true或false
function GetInsuDLLOBJByCode(InsuTypeCode)
{
	try{
		var VerStr="";
		INSUPORTGLOBAL.httpFlag="";
		INSUPORTGLOBAL.INSUblltype="";
		var ModeDesc=""
		VerStr=tkMakeServerCall("web.INSUDicDataCom","QueryByCode","DLLType",InsuTypeCode,INSUPORTGLOBAL.HospID);
		if ((VerStr=="0")||(VerStr=="")){
			dhcsys_alert(VerStr + "根据InsuTypeCode医保类型的DLL配置信息！请检查DLLType(医保接口DLL)配置")
			return false;
		}
		if(VerStr.indexOf("DHCINSUBLL.")==-1){
			dhcsys_alert(VerStr + InsuTypeCode+"的医保类型未配置DLL信息，请联系管理员处理")		
			return false;
		}
		var VerStrArr=VerStr.split("^")
		INSUPORTGLOBAL.httpFlag=VerStrArr[6]
		
		if ((INSUPORTGLOBAL.SerStatus!="1")&&(INSUPORTGLOBAL.isWinXP)){
	      	INSUPORTGLOBAL.httpFlag="0"
		}	
		//dhcsys_alert(INSUPORTGLOBAL.isWinXP+"-"+INSUPORTGLOBAL.httpFlag)
		switch (INSUPORTGLOBAL.httpFlag){ 
			/*
			case "2" :
				//头菜单或窗体调用模式，山东地纬的项目有用，以后准备用中间件实现
				ModeDesc="头菜单对象模式，DLL不重复加载"
				var parent=window.dialogArguments; 
				if (parent==undefined) { DHCINSUBLL=top.GetInsuObj(InsuTypeCode,session['LOGON.USERID'],"^"+ServerNameSpace);} //头菜单直接调用
				else {DHCINSUBLL=parent.top.GetInsuObj(InsuTypeCode,session['LOGON.USERID'],"^"+ServerNameSpace)} //非头菜单弹出窗体调用 
				break;
				*/
			case "1" :case "3" :case "2" :
				//中间件模式
				ModeDesc="中间件"
				INSUPORTGLOBAL.INSUblltype=VerStrArr[5].split(".")[1]
				break;
			default :
				ModeDesc="DLL";
				INSUPORTGLOBAL.DHCINSUBLL = new ActiveXObject(VerStrArr[5]);	//默认为ActiveXObject调用方式
		    	break;	
			}
			//dhcsys_alert(INSUPORTGLOBAL.httpFlag+"_"+INSUPORTGLOBAL.INSUblltype+"\n"+VerStr)
		return true
	}catch(e){
		dhcsys_alert("GetInsuDLLOBJByCode调用"+ModeDesc+"时发生异常："+e.message);
		return false;
	}
} 

  ///通过字符串自动填充对象 行分割符 "!"  列分割符 "^"
function FillTypeList(obj,InsuDicQuery,IPType){
	var i,n=1;
	var VerArr1=VerStr.split("!");
	var ArrTxt= new Array(VerArr1.length-2);
	var ArrValue = new Array(VerArr1.length-2);
	for(i=1;i<VerArr1.length;i++){
		var VerArr2=VerArr1[i].split("^");
		if (VerArr2[5]==IPType){   //区分门诊和住院
			ArrTxt[n-1]=VerArr2[3];
		    ArrValue[n-1]=VerArr2[2];	
			n++;
		 }	
		}
	 for(i=1;i<n;i++){ 
	    obj.options[i-1]=new Option(ArrTxt[i-1],ArrValue[i-1]);
		}
	}


function GetIusujsMsgFlag(dicCode)
{
	//调试时使用的
	/*var VerStr="";
	VerStr=tkMakeServerCall("web.INSUDicDataCom","QueryByCode","INSUJSMSGFLAG",dicCode,INSUPORTGLOBAL.HospID);
	if ((VerStr=="0")||(VerStr=="")){
		return "";
	}
	return VerStr.split("^")[5]*/
    return "2"
} 

/*
//功能描述: 生成新ExpStr ExpStr中增加数据库连接串
//DingSH    20180419
// 入参 ExpStr 扩展串;Ind:第几位插入字符数据库连接串ServerNameSpace
// 出参:新ExpStr串
function BuildInsuExpStrStd(ExpStr,Ind)
{
	if (ExpStr==""){ExpStr="^"}
	var NewExpStr=ExpStr
	try
	{
		
	var TAry=ExpStr.split("^")
	var Len=TAry.length;
	var PreExpStr  = ""
	var LastExpStr  =""
	for (var i=0;i<Len;i++)
	{
		if (i<Ind)
		{
			if(PreExpStr==""){PreExpStr=TAry[i]}
			else{PreExpStr=PreExpStr+"^"+TAry[i]}
		}else{
			if(LastExpStr==""){LastExpStr=TAry[i]}
			else{LastExpStr=LastExpStr+"^"+TAry[i]}
			}
		 	
					
	}
	NewExpStr=PreExpStr+"^"+ServerNameSpace+"^"+LastExpStr
	}
	catch(e)
	{
		dhcsys_alert("拼ExpStr发生异常! \n错误内容:"+e.message);
		return NewExpStr
	}
	finally
	{
       return NewExpStr
	 } 
	
	
}
*/
//Zhan 20180620,重写上边BuildInsuExpStrStd函数
// 入参 ExpStr 扩展串;Ind:第几位插入字符数据库连接串ServerNameSpace
// 出参:新ExpStr串
function BuildInsuExpStrStd(ExpStr,Ind)
{
	var NewExpStr=ExpStr;
	if (ExpStr==""){return ExpStr+"^"+ServerNameSpace+INSUPORTGLOBAL.dbEncrypt;}
	if("undefined"==typeof(Ind)){return NewExpStr ;}
	if(Ind<1){return NewExpStr;}
	try
	{
		var tmpArr=ExpStr.split("^")
		if((tmpArr.length-1)==Ind){NewExpStr=ExpStr+"^"+ServerNameSpace+INSUPORTGLOBAL.dbEncrypt; return NewExpStr;}
		var tmpNewArr=tmpArr.slice(0,Ind)
		var tmprightArr=tmpArr.slice(Ind+1)
		tmpNewArr.push(ServerNameSpace+INSUPORTGLOBAL.dbEncrypt)
		NewExpStr=tmpNewArr.concat(tmprightArr).join("^")
	}
	catch(e)
	{
		dhcsys_alert("拼ExpStr发生异常! \n错误内容:"+e.message);
	}
	finally
	{
       return NewExpStr
	} 
}

///把费用添加到计费组结算页面上
///Input:费用拼串
function INSUAdd(DivideStr,InsuTypeCode)
{
	//dhcsys_alert(DivideStr)
	//标志^总金额^统筹^大病^帐户^现金
	//0|0^1003^0^2028686^45
    //0^结算表Rowid^现金支付^发票rowid Chr(2)^10^账户Chr(2)^11^大病支付Chr(2)^8^卡支付Chr(2)
   //DivideStr="0^887^10806^19921410^011^08^390.8"
    //dhcsys_alert(DivideStr.split(String.fromCharCode(2)))
	if(DivideStr.slice(0,1)=="0")
	//if(DivideStr.split("|")[0]=="0")
	{
		var INSUFeeslength=DivideStr.split(String.fromCharCode(2)).length
		//dhcsys_alert(INSUFeeslength)
		var PayRowid,PayAmount
		for (i=1;i<=INSUFeeslength-1;i++)
		{   
			PayAmount=DivideStr.split(String.fromCharCode(2))[i].split("^")[1]
			PayRowid=DivideStr.split(String.fromCharCode(2))[i].split("^")[0]
		    amounttopayobj.value="";
		    paymodeobj.value="";
			//dhcsys_alert(PayRowid+"^"+PayAmount)	
		   if(eval(PayAmount)>0){
				switch (PayRowid)				//支付方式表rowid
				{		
					/*
					case "15":  
				       paymodeobj.value="医保账户支付" 	//和CT_PayMode表里的支付方式的描述一样
					   amounttopayobj.value=PayAmount
					   PayModeRowIDObj.value=PayRowid
					   Addtabrow();
					   break;
					   */
					case "6":			//支付方式表rowid
					   paymodeobj.value="统筹支付" 	//和CT_PayMode表里的支付方式的描述一样
					   amounttopayobj.value=PayAmount
					   PayModeRowIDObj.value=PayRowid
					   
					   InsuPayM="Y";  //add 2014-11-24  计费界面增加医保标识
					   Addtabrow();
					   break;
					 /*
					 case "17":
					   paymodeobj.value="大病救助支付" 	//和CT_PayMode表里的支付方式的描述一样
					   amounttopayobj.value=PayAmount
					   PayModeRowIDObj.value=PayRowid
					   InsuPayM="Y";  //add 2014-11-24  计费界面增加医保标识
					   Addtabrow();
					   break;
					case "18":
					   paymodeobj.value="公务员补助支付" 	//和CT_PayMode表里的支付方式的描述一样
					   amounttopayobj.value=PayAmount
					   PayModeRowIDObj.value=PayRowid
					   InsuPayM="Y";  //add 2014-11-24  计费界面增加医保标识
					   Addtabrow();
					   break;
					   */
				}		      	 
			}
		}
		//dhcsys_alert(depositsumobj.value)
		amounttopayobj.value=eval(eval(DivideStr.split("^")[2])-depositsumobj.value)   //医保返回的现金支付-预交金	
		amounttopayobj.value=eval(amounttopayobj.value).toFixed(2).toString(10)
		balanceobj.value=amounttopayobj.value;
		paymodeobj.value="现金";
		PayModeRowIDObj.value="1"   			//支付方式表rowid  现金
		//pay=balanceobj.value
		tmppay=amounttopayobj.value
		INSUPORTGLOBAL.AddDivideFlag=true;
		if (tmppay<0)
		{ 
			balanceobj.style.color="red";
		}	
		InsuPayM="N"   //add 2014-11-24  计费界面增加医保标识
	}
}



///****************************不常用函数*****************
function ReadCardNew(InsuNo,Type)
{
	try{
		var dHandle=0;
		var RtnStr="";
		UserID=session['LOGON.USERID']
		//return "0|6003105182^603991952^120000650601001^张?^女^1971-01-01^31^0^888888^宝安洪浪南路??号有限公司^1^1^2^Z000^1175.02^200907^5^0^0^0^0^0^0^0^0^0^^^^^^^1^0^0^0^0^0^综合##2^@@"
		//医疗证号1^电脑号2^身份证号(可以取自数据库)3^姓名(可以取自数据库)4^性别?代码?性别??(可以取自数据库)5^出生时间(可以取自数据库)6^年龄(可以取自数据库)7^特殊人群?代码?8^单位编码9^单位名称10^就业状态?代码?就业状态??11^参保类型?代码?参保类型??12^经费来源?代码?经费来源??13^管理属地?代码?管理属地??14^帐户余额15^年月16^连续参保月数17^基本医疗保险共济基金支付最高限额?当前?18^基本医疗保险共济基金已用金额?本年度内?19^基本医疗保险共济基金可用余额?当前?20^地方补充医疗保险共济基金支付最高限额?当前?21^地方补充医疗保险共济基金已用金额?本年度内?22^地方补充医疗保险共济基金可用余额?当前?23^?帐户?不足自付限额?当前?24^?帐户?自付已用金额?本年度内?25^?帐户?自付可用余额?当前?26^监护人1电脑号*27^监护人2电脑号*28^监护人1身份证号*29^监护人2身份证号*30^监护人1姓名*31^监护人2姓名*32^医保参加情况?"0"未参加,"1"参加?33^统筹参加情况?"0"未参加,"1"参加?34^离休参加情况?"0"未参加,"1"参加?35^生育参加情况?"0"未参加,"1"参加?36^工伤参加情况?"0"未参加,"1"参加?37^少儿参加情况?"0"未参加,"1"参加?*38
	    
    	if(INSUPORTGLOBAL.httpFlag==0){
			insuDHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST");
			if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
			RtnStr=insuDHCINSUBLL.InsuASReadCard(dHandle,UserID,InsuNo,Type);
			insuDHCINSUBLL=null
    	}else{
			var getInStr="Handle="+Handle+"&userid="+UserId+"&InsuNo="+InsuNo+"&Type="+Type;
			RtnStr=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuASReadCard",getInStr,"")
	    }
	    return RtnStr
	}catch(e){
		dhcsys_alert("调用医保接口发生异常,请检查你的医保环境是否正常。\n错误内容:"+e.message);
		return ""
	}finally{

	} 
}


function InsuReport(Handle,Indata,UserId,ExpString){
	try{
 	//dhcsys_alert("读卡开始:InsuNo="+InsuNo+"^UserId="+UserId+"^ExpString="+ExpString)
 	//return "0|6003105182^603991952^120000650601001^张?^女^1971-01-01^31^0^888888^宝安洪浪南路??号有限公司^1^1^2^Z000^1175.02^200907^5^0^0^0^0^0^0^0^0^0^^^^^^^1^0^0^0^0^0^综合##2^@@"
	//InsuTypeCode=GetInsuTypeCode(AdmReasonId)
    //if (InsuTypeCode=="") {return -1;} 
	var rtn="-1";
    var ExpStrForNet=BuildInsuExpStrStd(ExpString,1)
        InsuTypeCode=ExpString.split("^")[0]
    
	/* Zhan 20181213注释，改为取配置
    switch (InsuTypeCode){ 
	    case "ZZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB_TEST"); //Zhan 20160615 test 
	    	break;
	    case "YZB" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA");     //扬中市居民医保
	    	break;
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuTypeCode="+InsuTypeCode);
	    	return -1;
	    	break;
	    }
		*/

		if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
    	if(INSUPORTGLOBAL.httpFlag==0){
	    	if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)}	//Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
			var rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuApplyItems(Handle,Indata,UserId,ExpStrForNet)  
		    DHCINSUBLL= null;
    	}else{
			var getInStr="Handle="+Handle+"&Indata="+Indata+"&UserId="+UserId+"&ExpStrForNet="+toINSUSafeCode(ExpStrForNet);
			rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuApplyItems",getInStr,"");
	    }

		    return rtn;
 }catch(e){
	dhcsys_alert("调用医保接口发生异常"+e.message);
	return "-1"
}finally{
	
} 

}

//读二代身份证
//入参:病人类型    InsuTypeCode
//出参?
function ReadIDCard()
{  
 try{
	 var CardNo="";
	var rtn="-1";
	if(INSUPORTGLOBAL.httpFlag==0){
		 var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_HN_ZZB"); 
		 if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		 rtn=INSUPORTGLOBAL.DHCINSUBLL.ReadIDCard(1,CardNo) 
		 DHCINSUBLL= null; 
	}else{
		var getInStr="Handle="+Handle+"&InsuNo="+InsuNo;
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"ReadIDCard",getInStr,"")
	}
    return rtn;
 }catch(e){
	dhcsys_alert("调用医保接口发生异常"+e.message);
	return "-1"
}finally{
	
} 
 
}

//登记查询
//入参: ExpStr(医保卡号^登记类别^大病代码)
//出参?查询串(卡类别标志|卡号|姓名|帐户标志|登记类别|登记号|开始日期|结束日期|诊断编码|大病项目代码|登记医院标志|登记医院名称)
//说明 帐户标志(职退情况|保健对象|公务员|特殊待遇标识|封存标志|在职享受退休标志|适用医保办法标志|等待期标识|特殊标识)
function InsuIPRegQuery(UserDr,ExpStr,AdmReasonNationCode,AdmReasonId)
{
	var flag="-1"
	var rtn="-1"
	if (AdmReasonId=="") {AdmReasonNationCode="01"}//可能直接输入医保号来查,没有获得nationalcode
	/*
	switch (AdmReasonNationCode){
	    case "01":
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_SH"); //实时结算
	    	break;
	    default:
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;AdmReasonNationCode="+AdmReasonNationCode);
	    	return -1;
	    	break;
	    }
	*/
	InsuTypeCode=GetInsuTypeCode(AdmReasonId)
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return flag}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuIPRegQuery(1,UserDr,ExpStr);
		DHCINSUBLL= null;
	}else{
		var getInStr="Handle="+Handle+"&UserId="+UserId+"&ExpString="+toINSUSafeCode(ExpStr);
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuIPRegQuery",getInStr,"")
	}
    return rtn;
}


//医保零结算 为了医保病人取消结算后医保中心变为出院结算状态 Lou 2010-02
function InsuIPDivideOut(Handle,UserId,BillNO,AdmReasonNationCode,AdmReasonId,ExpString)
{
	var DivideStr="-1";
	//dhcsys_alert("医保结算开始"+Handle+"^"+UserId+"^"+BillNO+"^"+AdmReasonNationCode+"^"+AdmReasonId+"^"+ExpString)
	if (AdmReasonNationCode!="01"){
		dhcsys_alert("实时结算病人才可以做零结算!");
		return -1;
		}
    var truthOut = window.confirm("确定进行医保零结算?");
    if (!truthOut) {return -1;}
	
	INSUPORTGLOBAL.AddDivideFlag=false;	//向计费组结算界面添加费用成功与否的标志
	if(BillNO==""){dhcsys_alert("帐单号不能空!");return;}
	InsuTypeCode=GetInsuTypeCode(AdmReasonId)
	if(GetInsuDLLOBJByCode(InsuTypeCode)==false){return flag}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_SH");
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		DivideStr=INSUPORTGLOBAL.DHCINSUBLL.InsuIPDivideOut(Handle,BillNO,UserId,ExpString);
		DHCINSUBLL=null;  
	}else{
		var getInStr="Handle="+Handle+"&BillNO="+BillNO+"&UserId="+UserId+"&ExpString="+toINSUSafeCode(ExpString);
		DivideStr=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuIPDivideOut",getInStr,"")
	}
	if(DivideStr=="0") //???什么情况返回-2,不用添加支付方式?
	{
		return 0;
	}
	else {return -1;}
	
}


///动态显示不同医保病人的医疗类别
///入参?HIS收费类型Rowid?Pac_Admreason的Rowid,IPType:OP/IP
///出参?失败或者直接填写下拉框?
///作者?耿昌金 2010-08-11
///说明?
function InsuTypeOnchangeLink(AdmreaonDr,IPType){
	var obj=document.getElementById("PatType");   ///设置填充的对象
	if(obj){
		ClearAllList(obj)       	  
		obj.size=1; 
		obj.multiple=false;
	   	///设置默认值
	   	if(IPType=="IP"){obj.options[0]=new Option("普通住院","");}
	   	else{obj.options[0]=new Option("普通门诊","");}
	   }
	InsuTypeCode=GetInsuTypeCode(AdmreaonDr)
	if (InsuTypeCode=="") return false;  
	
    var InsuDicQuery ="AKA130"+InsuTypeCode;
	var VerStr="";
	VerStr=tkMakeServerCall("web.INSUDicDataCom","GetSys","","",InsuDicQuery,INSUPORTGLOBAL.HospID);
	if ((VerStr=="0")||(VerStr=="")){
		return false;
	   }
    FillTypeList(obj,VerStr,IPType)
}
function InsuNotice(Guser,NowDate){
	dhcsys_alert("无数据")
	return 0
}

//上传对照审批
function INSUUpLoadConAudit(InsuType) {
	try {
	OutStr="-1"
	Handle=0
	var rtn="-1";
	//dhcsys_alert("医保对照审批上报开始InsuType="+InsuType)
	//InsuTypeCode=GetInsuTypeCode(AdmReasonId)
    //if (InsuTypeCode=="") {return -1;} 
	/*
    switch (InsuType){ 
	     case "SZ" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_GD_SZ"); //扬中市职工医保
	    	break;
	    case "SZA" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_GD_SZA"); //扬中市居民医保
	    	break;		    	
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;AdmReasonId="+AdmReasonId);
	    	return -1;
	    	break;
	    }
	*/
	if(GetInsuDLLOBJByCode(InsuType)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuUpLoadConAudit()
		DHCINSUBLL=null;
	}else{
		var getInStr="";
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuUpLoadConAudit",getInStr,"")
    }
	if ((rtn=="")||(rtn=="-1")||(rtn==undefined)) {return OutStr;}
	return rtn
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
	
}

//下载对照审批
function INSUDownLoadConAudit(InsuType) {
	try {
	OutStr="-1"
	Handle=0
	var rtn="-1";
	//dhcsys_alert("医保对照审批下载开始InsuType="+InsuType)
	//InsuTypeCode=GetInsuTypeCode(AdmReasonId)
    //if (InsuTypeCode=="") {return -1;} 
	/*
    switch (InsuType){ 
	     case "SZ" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_GD_SZ"); //扬中市职工医保
	    	break;
	    case "SZA" :
	    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_GD_SZA"); //扬中市居民医保
	    	break;		    	
	    default :
	    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;AdmReasonId="+AdmReasonId);
	    	return -1;
	    	break;
	    }
	*/
	if(GetInsuDLLOBJByCode(InsuType)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
	if(INSUPORTGLOBAL.httpFlag==0){
		if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
		rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuDownLoadConAudit()
		DHCINSUBLL=null;
	}else{
		var getInStr="";
		rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuDownLoadConAudit",getInStr,"")
    }
	if ((rtn=="")||(rtn=="-1")||(rtn==undefined)) {return OutStr;}
	return rtn
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return -1;
	}
	
//注释掉，否则与计费函数重名冲突
/*function getpath()
{
	var PaMasNO="VERSION"
  	encmeth="TMkA852NIjVG153Mv4vv1fKyu5yin0784Ded1TVYOkL0tNdqsfXN1yQDdnn78rmk"
 	var OutStr=cspRunServerMethod(encmeth,PaMasNO);
 	dhcsys_alert(OutStr)
	}
	*/
	
}

function InsuBasDL(InsuType,ExpString)
{
	try {	
		var rtn="-1";
		/*
	    switch (InsuType){ 
		    case "YZA" :
		    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZA"); //扬中市职工医保
		    	break;
		    case "YZB" :
		    	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_JS_YZB"); //扬中市居民医保
		    	break;    				    	
		    default :
		    	dhcsys_alert("此类型不联医保接口,请检查程序或数据;InsuType="+InsuType);
		    	return -1;
		    	break;
		    }
		*/
		if(GetInsuDLLOBJByCode(InsuType)==false){return rtn}	//Zhan 20181213增加配置并增加中间件功能
		if(INSUPORTGLOBAL.httpFlag==0){
			if(INSUPORTGLOBAL.iniServerIP){var ini=INSUPORTGLOBAL.DHCINSUBLL.Initialize(ServerNameSpace)} //Zhan 20170419,var ServerNameSpace = 'cn_iptcp:172.19.19.57[1972]:DHC-APP';
			rtn=INSUPORTGLOBAL.DHCINSUBLL.InsuBasDL(InsuType,"");
			DHCINSUBLL= null;
		}else{
			var getInStr="InsuType="+InsuType+"&ExpString="+toINSUSafeCode(ExpString);
			rtn=CallInsuComGet(INSUPORTGLOBAL.INSUblltype,"InsuBasDL",getInStr,"")
		}
	    return rtn;
	}catch(e){
		dhcsys_alert("调用医保接口发生异常"+e.message);
		return "-1"
	}finally{
	} 

}
//----------------医保中间件相关----------------

//获取中间件服务IP
function GetInsuIPAddress() {
    var obj = null;
	var rslt=""
    INSUPORTGLOBAL.INSUSerIP = "127.0.0.1";	//不用rcbdyctl.dll取本机IP了,如果是服务器模式就填服务器IP
	return INSUPORTGLOBAL.INSUSerIP
	/*
	if("undefined" != typeof ClientIPAddress){
		INSUPORTGLOBAL.INSUSerIP=ClientIPAddress	//ClientIPAddress是系统JS中的变量		
	}
	if(INSUPORTGLOBAL.INSUSerIP!=""){return INSUPORTGLOBAL.INSUSerIP};
    try {
        obj = new ActiveXObject("rcbdyctl.Setting");
        rslt = obj.GetIPAddress;
        if(rslt!=""){
	    	if(rslt.split(";").length>1){rslt=rslt.split(";")[0]}
	    }
        INSUPORTGLOBAL.INSUSerIP=rslt;
        obj = null;
    } catch(e) {
	    dhcsys_alert("获取客户端IP失败。\n错误内容:"+e.message);
        //异常发生
    }
	*/
    return rslt;
}
//启动医保中间件服务程序,支持IE8+,Chrome
//Zhan 20181123,配合20181123及以后版本的服务程序
function openINSUSers(strPath)
{
	try{

		if(document.getElementById('openINSUSers')) {
			document.body.removeChild(document.getElementById('openINSUSers'));
		}
		var openINSUSers = document.body.appendChild(document.createElement('openINSUSers'));
		openINSUSers.innerHTML = '<a href="INSUshell://" id="openINSUSerlk">';
		document.getElementById('openINSUSerlk').click();
		INSUPORTGLOBAL.tmpCnt=INSUPORTGLOBAL.tmpCnt+1
		return true;
		//var element= $('<a id="INSUshell" href="INSUshell://test">insushell</a>')
		//element.trigger("click");
		//document.getElementById("")
		//var wo=window.open("INSUshell://");
		//wo.close();		

		try{
			var aw=window.open("INSUshell://");
			//aw.opener = null;
			//aw.location.href ="INSUshell://";
			aw.close();
			aw=null;
		}catch(ex){
		}		
		return true;
	}catch(e)
	{
		dhcsys_alert('INSUShell:'+e.message);
		return false
	}
	return false;
	//下边的方法不推荐
	try{
		var wsa = new ActiveXObject("wscript.shell");    
		wsa.run(strPath); 
		wsa=null;
	}catch(e)
	{
		dhcsys_alert('发生错误:' + e.message+',启动'+strPath+'失败,请检查文件是否存在或是否有权限启动!' );
	}
}
//创建XMLHttp
function createInsuXMLHttpRequest() {  
	//var xmlHttp;
    if (window.XMLHttpRequest) {  
		try{
			INSUXMLHttp = new XMLHttpRequest();  
			if (INSUXMLHttp.overrideMimeType)  
				INSUXMLHttp.overrideMimeType('text/xml');  
		}catch(e){
		}
    } else if (window.ActiveXObject) {  
        try {  
            INSUXMLHttp = new ActiveXObject("Msxml2.XMLHTTP");  
        } catch (e) {  
            try {  
                INSUXMLHttp = new ActiveXObject("Microsoft.XMLHTTP");  
            } catch (e) {  
            }  
        }  
    }  
    return INSUXMLHttp;  
} 
// HTTP get 方法,Zhan 20170412
// blltype:医保类名，如：INSU_HN_ZZB
// funName:.NET中的函数名
// inUrl:函数的参数拼串
// ExpStr:扩展参数
function CallInsuComGet(blltype,funName,inUrl,ExpStr)
{
	var RtnINSUComStr="";
	try{
		if(INSUPORTGLOBAL.INSUSerIP==""){GetInsuIPAddress();}
        var childurl="";
        childurl=window.location.href.split("/web/")[0]
		var tmpArgs={ 
			test:Insubtoa(INSUPORTGLOBAL.httpFlag+":"+Date.now()+"/"+blltype+"/"+funName+"?"+inUrl),
			win:window 
		}			
		var tmpurlArgs=Insubtoa(INSUPORTGLOBAL.httpFlag+":"+Date.now()+"/"+blltype+"/"+funName+"?"+inUrl);
		var urlArgs=""
		if(INSUPORTGLOBAL.httpFlag==3){
			//websocket
	        if(INSUPORTGLOBAL.isSSL && INSUPORTGLOBAL.isIE){
		        urlArgs=childurl+"/web/INSUModalOpen.html?temps="+Math.random()+"&url="+childurl.replace(/https/, "http")+"/web/INSUModalLocal.html?tmpurlArgs="+tmpurlArgs; 
			}else{
				urlArgs=childurl+"/web/INSUModalchild.html?temps="+Math.random()+"&tmpurlArgs="+tmpurlArgs; 
			}
			RtnINSUComStr=InsuWebsocket(urlArgs,tmpArgs,"")
		}else{
			RtnINSUComStr=InsuHTTPGet(tmpurlArgs,tmpArgs,"")
		}
	    return RtnINSUComStr
	}catch(e){
		dhcsys_alert("服务状态异常:"+e.message)	
	}finally{
	} 
}
function InsuHTTPGet(urlArgs,tmpArgs,ExpStr)
{
	var RtnHTTPStr="";
	try{
		var tmpuserAgent = navigator.userAgent; //取得浏览器的userAgent字符串
		var INSUURL="http://" + INSUPORTGLOBAL.INSUSerIP + ":888/"+urlArgs;
		if(INSUXMLHttp=="") {createInsuXMLHttpRequest()};  
	
		INSUXMLHttp.open("GET", INSUURL, false); 
		INSUXMLHttp.onreadystatechange =function() {
	        if (INSUXMLHttp.readyState == 4) {
				if (INSUXMLHttp.status == 200) {
					var tmpdata=INSUXMLHttp.responseText
					//RtnHTTPStr = tmpdata.replace(/[\r\n]$/g,"");
					//dhcsys_alert("tmpdata:"+tmpdata)
					if(tmpdata.split(String.fromCharCode(13)).length>0){
						RtnHTTPStr = tmpdata.split(String.fromCharCode(13))[0];
					}else{
						RtnHTTPStr = tmpdata;
					}
					
				}  
				if((INSUXMLHttp.status==12029)&& tmpArgs!="12029"){
					//dhcsys_alert("status:"+INSUXMLHttp.status)
					if(INSUPORTGLOBAL.tmpCnt>1){dhcsys_alert("启动医保服务程序失败1");return;}
					openINSUSers("")
					dhcsys_alert("正在启动中间件服务,稍后可能需要重新办理……")
				}
				
	        }  
		}
		/*
		if (tmpuserAgent.indexOf("compatible") > -1 && tmpuserAgent.indexOf("MSIE") > -1 && tmpuserAgent.indexOf("Opera")==-1) { //判断是否IE浏览器
			INSUXMLHttp.setRequestHeader("If-Modified-Since", "0");
		}
		*/

		//
		INSUXMLHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");  
		INSUXMLHttp.send();  
	    return RtnHTTPStr
	}catch(e){
		if(INSUPORTGLOBAL.tmpCnt>1){return;dhcsys_alert("启动医保服务程序失败2");}
		if(tmpArgs!="12029"){
			var tmpmsg=e.message.toUpperCase()
			if((tmpmsg.indexOf("NETWORK")!=-1)||(tmpmsg.indexOf("FAILED")!=-1)) {
				openINSUSers("")
				//dhcsys_alert("服务状态异常2:"+e.message+",正在启动服务,稍后可能需要重新办理……")
			}else{
				//dhcsys_alert("服务状态异常2:"+e.message)
				return RtnHTTPStr
			}
			return InsuHTTPGet(urlArgs,tmpArgs,ExpStr)
		}
		return RtnHTTPStr;
	}finally{
	} 
}
function InsuWebsocket(urlArgs,tmpArgs,ExpStr)
{
	//
	var RtnwebStr="";
	
	try{
		//if(INSUPORTGLOBAL.isIE)
		RtnwebStr=window.showInsuModalDialog(urlArgs,tmpArgs,"dialogWidth:300px;dialogHeight:200px;toolbar:no;location:no;directories:no;menubar:no"); 
		//
	    return RtnwebStr
	    //
	}catch(e){
		dhcsys_alert("Websocket服务状态异常:"+e.message)
		return RtnwebStr
		//
	}finally{
	} 
	
	
}
// 替换参数中的特殊字符
function toINSUSafeCode(inArg)
{
	try{
		/*
		inArg=inArg.replace(/\+/g, '%2B');
		inArg=inArg.replace(/\s/g, '%20');
		inArg=inArg.replace(/\//g, '%2F');
		inArg=inArg.replace(/\?/g, '%3F');
		inArg=inArg.replace(/\%/g, '%25');
		inArg=inArg.replace(/\#/g, '%23');
		inArg=inArg.replace(/\&/g, '%26');
		inArg=inArg.replace(/\=/g, '%3D');
		
	    return inArg
	    */
	    return Insubtoa(inArg)
	}catch(e){
		dhcsys_alert("替换参数中的特殊字符。\n错误内容:"+e.message);
		return inArg
	}finally{
	} 
}
function Insubtoa(INSUinArgs){
	try{
		//return window.btoa(unescape(encodeURIComponent(inArgs)))
		return window.btoa(encodeURIComponent(INSUinArgs))
	}catch(ex){
		return INSUinArgs
	}
}
function Insuatob(INSUinArgs){
	try{
		//return decodeURIComponent(escape(window.atob(inArgs)))
		return decodeURIComponent(window.atob(INSUinArgs))
	}catch(ex){
		return INSUinArgs
	}
}
function GetInsuStatusBak(){
	try{
		if(INSUPORTGLOBAL.INSUSerIP==""){GetInsuIPAddress();}
		var tmpurlArgs="/test/GetStatus?";		
		INSUPORTGLOBAL.SerStatus=InsuHTTPGet(tmpurlArgs,"12029","")
		//console.log('zhan test:hello:'+INSUPORTGLOBAL.SerStatus);			
		
	}catch(exg){
		//console.log('zhan test:error:'+eex.message);
	}
}
function GetInsuStatus()
{
	//urlArgs,tmpArgs,ExpStr
	var tmpArgs=""
	var ExpStr=""
	if(INSUPORTGLOBAL.INSUSerIP==""){GetInsuIPAddress();}
	var tmpurlArgs="/test/GetStatus?";		
	try{
		var tmpuserAgent = navigator.userAgent; //取得浏览器的userAgent字符串
		var INSUURL="http://" + INSUPORTGLOBAL.INSUSerIP + ":888/"+tmpurlArgs;
		if(INSUXMLHttp=="") {createInsuXMLHttpRequest()};  
		INSUXMLHttp.open("GET", INSUURL, true); 
		INSUXMLHttp.onreadystatechange =function() {
	        if (INSUXMLHttp.readyState == 4) {
				if (INSUXMLHttp.status == 200) {
					var tmpdata=INSUXMLHttp.responseText
					if(tmpdata.split(String.fromCharCode(13)).length>0){
						INSUPORTGLOBAL.SerStatus = tmpdata.split(String.fromCharCode(13))[0];
					}else{
						INSUPORTGLOBAL.SerStatus = tmpdata;
					}
					
				}  
				if((INSUXMLHttp.status==12029)&& tmpArgs!="12029"){
					//dhcsys_alert("status:"+INSUXMLHttp.status)
					if(INSUPORTGLOBAL.tmpCnt>1){dhcsys_alert("启动医保服务程序失败1");return;}
					openINSUSers("")
					//dhcsys_alert("正在启动中间件服务,稍后可能需要重新办理……")
				}
				
	        }  
		}
		INSUXMLHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");  
		INSUXMLHttp.send(); 
		/* 
		$.get(INSUURL,function(tmpdata){
			if(tmpdata.split(String.fromCharCode(13)).length>0){
				INSUPORTGLOBAL.SerStatus = tmpdata.split(String.fromCharCode(13))[0];
			}else{
				INSUPORTGLOBAL.SerStatus = tmpdata;
			}
		});
		*/
		
	    return INSUPORTGLOBAL.SerStatus
	}catch(e){
		if(INSUPORTGLOBAL.tmpCnt>1){return;dhcsys_alert("启动医保服务程序失败2");}
		if(tmpArgs!="12029"){
			var tmpmsg=e.message.toUpperCase()
			if((tmpmsg.indexOf("NETWORK")!=-1)||(tmpmsg.indexOf("FAILED")!=-1)) {
				openINSUSers("")
				//dhcsys_alert("服务状态异常2:"+e.message+",正在启动服务,稍后可能需要重新办理……")
			}else{
				//dhcsys_alert("服务状态异常2:"+e.message)
				return INSUPORTGLOBAL.SerStatus
			}
			return InsuHTTPGet(urlArgs,tmpArgs,ExpStr)
		}
		return INSUPORTGLOBAL.SerStatus;
	}finally{
	} 
}
function RestartINSUService()
{
	//urlArgs,tmpArgs,ExpStr
	var tmpArgs=""
	var ExpStr=""
	var RtnCode="-1"
	if(INSUPORTGLOBAL.INSUSerIP==""){GetInsuIPAddress();}
	var tmpurlArgs="/test/RestartService?";		
	try{
		var tmpuserAgent = navigator.userAgent; //取得浏览器的userAgent字符串
		var INSUURL="http://" + INSUPORTGLOBAL.INSUSerIP + ":888/"+tmpurlArgs;
		if(INSUXMLHttp=="") {createInsuXMLHttpRequest()};  
		INSUXMLHttp.open("GET", INSUURL, true); 
		INSUXMLHttp.onreadystatechange =function() {
	        if (INSUXMLHttp.readyState == 4) {
				if (INSUXMLHttp.status == 200) {
					var tmpdata=INSUXMLHttp.responseText
					if(tmpdata.split(String.fromCharCode(13)).length>0){
						RtnCode = tmpdata.split(String.fromCharCode(13))[0];
					}else{
						RtnCode = tmpdata;
					}
					
				}  
	        }  
		}
		INSUXMLHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");  
		INSUXMLHttp.send(); 
	    return RtnCode
	}catch(e){
		return RtnCode;
	}finally{
	} 
}
//下边代码不影响其它产品组,不用动
(function() {

	try{
		if ("ActiveXObject" in window){
			INSUPORTGLOBAL.isIE=true;
		}
		if(window.location.href.indexOf("https")!==-1){
		   INSUPORTGLOBAL.isSSL=true;
		}else{
		   INSUPORTGLOBAL.isSSL=false;
		}
		INSUPORTGLOBAL.SysIp=document.location.hostname;
	}catch(ee){
	}
	var sUserAgent = navigator.userAgent;
	INSUPORTGLOBAL.isWinXP = sUserAgent.indexOf("Windows NT 5.1") > -1 || sUserAgent.indexOf("Windows XP") > -1;
  	if (INSUPORTGLOBAL.isWinXP){
      	//Zhan 20190318XP系统不启用中间件
      	INSUPORTGLOBAL.SerStatus="0"
	}else{
		try{
			//GetInsuStatus();
			//setTimeout("GetInsuStatus()",500);
			GetInsuStatus();
		}catch(eex){
			
		}
		/*
		try{
			if(INSUPORTGLOBAL.SerStatus!="1"){var tstatus=setTimeout("GetInsuStatus()",3000);}	
		}catch(eexx){}	
		*/
	}
	
    window.spawn = window.spawn || function(gen) {
        function continuer(verb, arg) {
            var result;
            try {
                result = generator[verb](arg);
            } catch (err) {
                return Promise.reject(err);
            }
            if (result.done) {
                return result.value;
            } else {
                return Promise.resolve(result.value).then(onFulfilled, onRejected);
            }
        }
        var generator = gen();
        var onFulfilled = continuer.bind(continuer, 'next');
        var onRejected = continuer.bind(continuer, 'throw');
        return onFulfilled();
    };
    window.showInsuModalDialog = window.showModalDialog || function(url, arg, opt) {
        url = url || ''; //URL of a dialog
        arg = arg || null; //arguments to a dialog
        opt = opt || 'dialogWidth:300px;dialogHeight:200px'; //options: dialogTop;dialogLeft;dialogWidth;dialogHeight or CSS styles
        var caller = showInsuModalDialog.caller.toString();
        var dialog = document.body.appendChild(document.createElement('dialog'));
        dialog.setAttribute('style', opt.replace(/dialog/gi, ''));
        dialog.innerHTML = '<a href="#" id="dialog-close" style="position: absolute; top: 0; right: 5px; font-size: 20px; color: #000; text-decoration: none; outline: none;">&times;</a><iframe id="dialog-body" src="' + url + '" style="border: 0; width: 100%; height: 100%;"></iframe>';
        document.getElementById('dialog-body').contentWindow.dialogArguments = arg;
        document.getElementById('dialog-close').addEventListener('click', function(e) {
            e.preventDefault();
            dialog.close();
        });
        dialog.showModal();
        //if using yield or async/await
        if(caller.indexOf('yield') >= 0 || caller.indexOf('await') >= 0) {
            return new Promise(function(resolve, reject) {
                dialog.addEventListener('close', function() {
                    var returnValue = document.getElementById('dialog-body').contentWindow.returnValue;
                    document.body.removeChild(dialog);
                    resolve(returnValue);
                });
            });
        }
        //if using eval
        var isNext = false;
        var nextStmts = caller.split('\n').filter(function(stmt) {
            if(isNext || stmt.indexOf('showInsuModalDialog(') >= 0)
                return isNext = true;
            return false;
        });
        dialog.addEventListener('close', function() {
            var tmpreturnValue = document.getElementById('dialog-body').contentWindow.returnValue;
            document.body.removeChild(dialog);
            nextStmts[0] = nextStmts[0].replace(/(window\.)?showInsuModalDialog\(.*\)/g, JSON.stringify(tmpreturnValue));
            eval('{\n' + nextStmts.join('\n'));
        });
        throw 'Execution stopped until showInsuModalDialog is closed';
    };

	setTimeout("GetINSUdbEncrypt()",600);

	try{
		var newscript = document.createElement('script');
		newscript.setAttribute('type','text/javascript');
		newscript.setAttribute('src','http://127.0.0.1:888/insulocalservice.js');
		var insuhead = document.getElementsByTagName('head')[0];
		insuhead.appendChild(newscript);
	}catch(e){
		//alert("newscript发生异常"+e.message);
		return "-1"
	}finally{

	}   

})();

