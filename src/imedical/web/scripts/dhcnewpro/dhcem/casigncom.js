///qqa
///2019-06-07
///CA签名调用公共js


/// 数字签名调用 if (!isTakeDigSign()) return;	
/// 数字签名检查
function isTakeDigSign(){
	if(CAInit==1) IsCAWin = GetUserList();
    var caIsPass = 0;
    if (CAInit == 1){
        if (IsCAWin == "") {
            $.messager.alert("警告", "请先插入KEY");
            return false;
        }
        //判断当前key是否是登陆时候的key
        var resultObj = dhcsys_getcacert();
        var result = resultObj.ContainerName;
        if ((result == "") || (result == "undefined") || (result == null)) {
            return false;
        }
        ContainerName = result;   ///拿全局变量存
        caIsPass = 1;
    }
    return true;
}



///增加人脸，扫码后修改
///入参：参考基础平台ca文档，与其入参相同即可,logonType,singleLogon,forceOpen
///全局变量：IsCA：true/false,ca_key：object
function isTakeDigSignNew(ParamObj){
	var _thisCallBack=ParamObj.callback||function(){};
	
	ParamObj.callback=function(resultObj){
		if (!resultObj.IsSucc){
			$.messager.alert("警告", "证书登录失败!");
			return;
		}
		
		//是否CA证书登录。true:须CA证书登录，false:当前无须CA证书登陆
		IsCA=resultObj.IsCA; 
		if (!IsCA){
			_thisCallBack();
			return;
		}
		//alert(resultObj.ContainerName)
	    if ((resultObj.ContainerName||"")=="") {
		    $.messager.alert("警告", "未开启CA,使用HIS系统签名!");
	        return;
	    }
	    //ContainerName = resultObj.ContainerName;   ///拿全局变量存
	    //CACertNo=resultObj.CACertNo;
	    //ca_key=resultObj.ca_key
	    CAObj=resultObj; ///整个对象返回
	    _thisCallBack();
	}
	
	var _thisDefParamObj=$.extend({},ParamObj)
    //判断当前key是否是登陆时候的key
    dhcsys_getcacert(_thisDefParamObj); 
	
    return;
}

/// CA数字签名认证函数:(医嘱ID,登录用户ID,开A,撤S)
function InsDigitalSignOld(mOrditmData,LgUserID,XmlType){
	
    try {
        //1.批量签名认证
		var itmValData = ""; var itmHashData = ""; var itmSignData = "";
		var mOrditmArr = mOrditmData.split("^");
		for (var i=0; i < mOrditmArr.length; i++){
			/// 医嘱信息串
			var itmsXml = GetOrdItemXml(mOrditmArr[i], XmlType);
			var itmXmlArr = itmsXml.split(String.fromCharCode(2));
			for (var j = 0; j < itmXmlArr.length; j++) {
				if (itmXmlArr[j] == "") continue;
				var itmXml = itmXmlArr[j].split(String.fromCharCode(1))[1];
                var itmOpType = itmXmlArr[j].split(String.fromCharCode(1))[0];
                var itmXmlHash = HashData(itmXml);
                /// 签名串Hash值
                if (itmHashData == "") itmHashData = itmXmlHash;
                else itmHashData = itmHashData + "&&&&&&&&&&" + itmXmlHash;
                /// 签名串
                var SignedData = SignedOrdData(itmXmlHash, ContainerName);
                if (itmSignData == "") itmSignData = SignedData;
                else itmSignData = itmSignData + "&&&&&&&&&&" + SignedData;
                
                if (itmValData == "") itmValData = itmOpType + String.fromCharCode(1) + mOrditmArr[i];
                else itmValData = itmValData + "^" + itmOpType + String.fromCharCode(1) + mOrditmArr[i];
			}
		}
		
        if (itmHashData != "") itmHashData = itmHashData + "&&&&&&&&&&";
        if (itmSignData != "") itmSignData = itmSignData + "&&&&&&&&&&";

        //获取客户端证书
        var varCert = GetSignCert(ContainerName);   ///这两个函数电子病历提供
        var varCertCode = GetUniqueID(varCert);
        
        //3.保存签名信息记录
        if ((itmValData != "") && (itmHashData != "") && (varCert != "") && (itmSignData != "")) {
            var ret = InsBatchSign(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData);
            if (ret != "0") $.messager.alert("警告", "数字签名没成功");
        } else {
            $.messager.alert("警告", "数字签名错误");
        }
    }catch(e){
	    $.messager.alert("警告", e.message);
    }
}

/// CA数字签名认证函数:扫码登录等新增
/// Datas:签名的数据
/// LgUserID:用户ID
/// XmlType:按照各自模块标识(开A,撤S)
/// CA数字签名认证函数:(医嘱ID,登录用户ID,开A,撤S)
function InsDigitalSignBak(Datas,LgUserID,XmlType){
	
    try {
        //1.批量签名认证
		var itmValData = ""; var itmHashData = ""; var itmSignData = "";
		var DatasArr = Datas.split("^");
		for (var i=0; i < DatasArr.length; i++){
			/// 医嘱信息串:
			var itmsXml = GetOrdItemXml(DatasArr[i], XmlType);
			var itmXmlArr = itmsXml.split(String.fromCharCode(2));
			for (var j = 0; j < itmXmlArr.length; j++) {
				if (itmXmlArr[j] == "") continue;
				var itmXml = itmXmlArr[j].split(String.fromCharCode(1))[1];
                var itmOpType = itmXmlArr[j].split(String.fromCharCode(1))[0];
                var itmXmlHash = ca_key.HashData(itmXml);
                /// 签名串Hash值
                if (itmHashData == "") itmHashData = itmXmlHash;
                else itmHashData = itmHashData + "&&&&&&&&&&" + itmXmlHash;
                /// 签名串
                var SignedData = ca_key.SignedOrdData(itmXmlHash, ContainerName);
                if (itmSignData == "") itmSignData = SignedData;
                else itmSignData = itmSignData + "&&&&&&&&&&" + SignedData;
                
                if (itmValData == "") itmValData = itmOpType + String.fromCharCode(1) + DatasArr[i];
                else itmValData = itmValData + "^" + itmOpType + String.fromCharCode(1) + DatasArr[i];
			}
		}
		
        if (itmHashData != "") itmHashData = itmHashData + "&&&&&&&&&&";
        if (itmSignData != "") itmSignData = itmSignData + "&&&&&&&&&&";

		var ContainerName = ca_Obj.ContainerName; //证书容器名
		var CALogonType = ca_Obj.CALogonType; //登录方式代码
		var varCert = ca_Obj.varCert; //数字证书
		var varCertCode = ca_Obj.CAUserCertCode; //用户唯一标识
		var varCertNo = ca_Obj.CACertNo; //证书唯一标识

        //获取客户端证书
        if(varCertCode==""){
        	varCert = ca_key.GetSignCert(ContainerName);   ///这两个函数电子病历提供
        	varCertCode = ca_key.GetUniqueID(varCert);
        }
        //if((CACertNo||"")!=""){varCert=CACertNo};
        
        //3.保存签名信息记录
        if ((itmValData != "") && (itmHashData != "") && (varCert != "") && (itmSignData != "")) {
            var ret = InsBatchSign(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData, varCert);
            if (ret != "0") $.messager.alert("警告", "数字签名没成功");
        } else {
            $.messager.alert("警告", "数字签名错误");
        }
    }catch(e){
	    $.messager.alert("警告", e.message);
    }
}

/// CA数字签名认证函数:标板扫码登录等新增
/// Datas:签名的数据
/// LgUserID:用户ID
/// XmlType:按照各自模块标识(护士执行F/执行,C/撤销执行)
///		(MDT F/签名,C/撤销签名)
/// ModuleMark:模块标识：
///		(OrdCaByDoc为医嘱走医生站)
///		(EXE为护士执行)
///		(MDT为MDT会诊)
/// OtherParams:需要前台传递到后台的参数
function InsDigitalSignNew(Datas,LgUserID,XmlType,ModuleMark,OtherParams){
	if ((CAObj.ContainerName == "") || (!CAObj.IsSucc)) return false;

	//获取客户端证书
	var ContainerName = CAObj.ContainerName; //证书容器名
	var CALogonType = CAObj.CALogonType; //登录方式代码
	var varCert = CAObj.varCert; //数字证书
	var varCertCode = CAObj.CAUserCertCode; //用户唯一标识
	var varCertNo = CAObj.CACertNo; //证书唯一标识
	var ca_key=CAObj.ca_key;
    try {
        //1.批量签名认证
		var itmValData = ""; var itmHashData = ""; var itmSignData = "";
		var DatasArr = Datas.split("^");
		for (var i=0; i < DatasArr.length; i++){
			/// 信息串:按照自己的ModuleMark去后台方法添加XML串的获取
			var itmsXml = "";
			if(ModuleMark=="OrdCaByDoc"){ ///走医生站方法
				itmsXml = GetOrdItemXml(DatasArr[i], XmlType);	
			}else{
				itmsXml =GetDataXml(DatasArr[i],ModuleMark,XmlType,OtherParams);
			}
			var itmXmlArr = itmsXml.split(String.fromCharCode(2));
			for (var j = 0; j < itmXmlArr.length; j++) {
				if (itmXmlArr[j] == "") continue;
				var itmXml = itmXmlArr[j];
                var itmOpType = XmlType;
                var itmXmlHash = ca_key.HashData(itmXml);
                /// 签名串Hash值
                if (itmHashData == "") itmHashData = itmXmlHash;
                else itmHashData = itmHashData + "&&&&&&&&&&" + itmXmlHash;
                /// 签名串
                var SignedData = ca_key.SignedOrdData(itmXmlHash, ContainerName);
                if (itmSignData == "") itmSignData = SignedData;
                else itmSignData = itmSignData + "&&&&&&&&&&" + SignedData;
                
                if (itmValData == "") itmValData = itmOpType + String.fromCharCode(1) + DatasArr[i];
                else itmValData = itmValData + "^" + itmOpType + String.fromCharCode(1) + DatasArr[i];
			}
		}
		
        if (itmHashData != "") itmHashData = itmHashData + "&&&&&&&&&&";
        if (itmSignData != "") itmSignData = itmSignData + "&&&&&&&&&&";

       
        //3.保存签名信息记录
        if ((itmValData != "") && (itmHashData != "") && (varCert != "") && (itmSignData != "")) {
            var ret = "";
           	if(ModuleMark=="OrdCaByDoc"){
	           	ret = InsBatchSign(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData, varCertNo ,ContainerName);
            }else{
            	ret = InsBatchSignNew(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData,varCertNo,ContainerName,ModuleMark);
            }
            if (ret != "0") $.messager.alert("警告", "数字签名没成功");
        } else {
            $.messager.alert("警告", "数字签名错误");
        }
    }catch(e){
	    $.messager.alert("警告", e.message);
    }
}

/// 保存签名
function InsBatchSign(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData, varCertNo, expStr){ 
	
	var retFlag = "";
	runClassMethod("web.DHCDocSignVerify","InsertSignBatchSignRecord",
		{
			"CurrOrderItemStr":itmValData,
			"UserID":LgUserID,
			"OperationType":XmlType,
			"OrdItemsHashVal":itmHashData,
	    	"MainSignCertCode":varCertCode,
	    	"MainSignValue":itmSignData,
	    	"ExpStr":expStr,
	    	"MainSignCertNo":varCertNo
		},function(jsonString){	
			retFlag = jsonString;
		},'',false)
	return retFlag;
}

/// 保存签名
function InsBatchSignOld(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData){
	
	var retFlag = "";
	runClassMethod("web.DHCDocSignVerify","InsertBatchSignRecord",{"CurrOrderItemStr":itmValData, "UserID":LgUserID, "OperationType":XmlType, "OrdItemsHashVal":itmHashData,
	    "MainSignCertCode":varCertCode, "MainSignValue":itmSignData, "ExpStr":""},function(jsonString){
		
		retFlag = jsonString;
	},'',false)
	return retFlag;
}

/// 取医嘱信息串
function GetOrdItemXml(Oeori, XmlType){
	
	var OrdItemXml = "";
	runClassMethod("web.DHCDocSignVerify","GetOEORIItemXML",{"newOrdIdDR":Oeori, "OperationType":XmlType},function(jsonString){
		OrdItemXml = jsonString;
	},'',false)
	return OrdItemXml;
}

/// 标版CA改进后：获取Hash值的XML数据,要根据自己不同的模块进行XML数据获取
function GetDataXml(DataRowId,ModuleMark,XmlType,OtherParams){
	var RetXml = "";
	runClassMethod("web.DHCEMSignVerify","GetItemXML",{"DataRowId":DataRowId, "ModuleMark":ModuleMark, "OperationType":XmlType,"OtherParams":OtherParams},function(jsonString){
		RetXml = jsonString;
	},'',false)
	return RetXml;
}

/// 保存签名
function InsBatchSignNew(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData ,varCertNo, expStr, ModuleMark){
	
	var retFlag = "";
	runClassMethod("web.DHCEMSignVerify","InsertSignBatchSignRecord",
		{
			"CurrDataStr":itmValData, 
			"UserID":LgUserID, 
			"OperationType":XmlType, 
			"ItemsHashVal":itmHashData,
	    	"MainSignCertCode":varCertCode, 
	    	"MainSignValue":itmSignData, 
	    	"ExpStr":expStr,
	    	"MainSignCertNo":varCertNo,
	    	"ModuleMark":ModuleMark
	    },function(jsonString){
			retFlag = jsonString;
		}
	,'',false)
	return retFlag;
}
