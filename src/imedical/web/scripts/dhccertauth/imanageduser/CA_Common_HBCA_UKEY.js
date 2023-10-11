var ca_key = (function() {
    var Const_Vender_Code = "HBCA";
    var Const_Sign_Type = "UKEY";
    
	try {
		if ((window.ActiveXObject)||("ActiveXObject" in window)) {
			//document.writeln("<OBJECT classid=\"CLSID:18201fef-1ac1-4900-8862-5ec6154bb307\" height=1 id=HBCASdkTool  style=\"HEIGHT: 1px; LEFT: 10px; TOP: 28px; WIDTH: 1px\" width=1 VIEWASTEXT></OBJECT>");
			HBCASdkTool = document.createElement("object");
            HBCASdkTool.setAttribute("width",1);
            HBCASdkTool.setAttribute("height",1);
            HBCASdkTool.setAttribute("id","HBCASdkTool");
            HBCASdkTool.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
            HBCASdkTool.setAttribute("classid","clsid:18201fef-1ac1-4900-8862-5ec6154bb307");
            document.documentElement.appendChild(HBCASdkTool);
		} else {
            alert("湖北CAUkey签名暂不支持非IE浏览器，请联系CA开发人员确认！")
        }
	} catch (e) {
		alert("没有正确安装证书应用环境或证书应用环境已经损坏！");
	}

	var hbcaSdkTool = document.getElementById("HBCASdkTool");
	var hbcaCurKey = "";

	//对CA接口的通用封装01: 初始化证书集
	function initCertList() {
		try {
			//根据属性设置过滤条件(1表示使用SKF接口，2表示CSP(CSP不能枚举SM2证书)，)
			hbcaSdkTool.CryptoInterface = 1;//SKF
			//过滤签名证书算法("sm2","rsa")
			hbcaSdkTool.setCF_CertAlg("sm2");
			//获取签名证书
			hbcaSdkTool.setCF_KeyUsage(0x20);
			//加载证书集返回值等于0表示成功
			var loadResult = hbcaSdkTool.Load();
			if (loadResult == 0) {
				return true;
			} else {
				return false;
			}
		} catch (e) {
			alert("湖北CA证书初始化错误!");
			return false;
		}
	}

	//对CA接口的通用封装02: 获取指定Ukey的证书对象
	function getCertObjByKey(key) {
		
		if (hbcaSdkTool.Size == 0) {
			hbcaCurKey = "";
			alert("请插入UKey");
			return false;
		}
		
		if ((hbcaCurKey != "")&&(hbcaCurKey.SerialNumber == key))
		{
			return true;
		}
		
		hbcaCurKey = "";
		var hasKey = false;
		for (var i = 0; i < hbcaSdkTool.Size; i++) {
			var cert_obj = hbcaSdkTool.GetAt(i);
			if (cert_obj.KeyUsage != "1") continue;
			if (cert_obj.SerialNumber != key) continue;	//是否要查询的ukey
			
			hbcaCurKey = cert_obj;
			hasKey = true;
			break;
		}
		
		if (!hasKey) {
			alert("未找到指定UKey,序列号:" + key);
		}
		return hasKey;
	}
	
	function iGetData(Func,P1,P2,P3,P4,P5,P6,P7,P8,P9) {
    	
    	var result = "";
    	
    	var para = {
	  		CAFunc: Func,
	  		CAVenderCode:"HBCA",
	  		CASignType:"UKEY",
	  		P1:P1||"",
	  		P2:P2||"",
	  		P3:P3||"",
	  		P4:P4||"",
	  		P5:P5||"",
	  		P6:P6||"",
	  		P7:P7||"",
	  		P8:P8||"",
	  		P9:P9||""
  		};
  		
  		$.ajax({
    		url: "../CA.Ajax.DS.cls",
    		type: "POST",
    		dataType: "JSON",
    		async: false,
            global:false,
    		data: para,
    		success: function(ret) {
            	if (ret && ret.retCode == "0") {
                	result = ret;
            	} else {
	            	alert(ret.retMsg);
            	}
            },
        	error: function(err) {
            	alert(err.retMsg || err);
        	}
  		});
  		
  		return result;
    }

	//提供给业务系统的接口01: 获取Ukey列表
	function GetUserList(){
		//证书集初始化
		if (!initCertList()) return "";
		
		if (hbcaSdkTool.Size == 0) return "";
		
		var userList = "";
		for (var i = 0; i < hbcaSdkTool.Size; i++) {
			var cert_obj = hbcaSdkTool.GetAt(i);
			if (cert_obj.KeyUsage != "1") continue;
			
			var keyName  = cert_obj.FriendlyName;
			var uniqueID = cert_obj.SerialNumber;
			var user     = keyName+"||" + uniqueID;
			if (userList == "") {
				userList = user;
			} else { 
				userList = userList+"&&&"+user 
			};
		}
		
		return userList;
	}

	//提供给业务系统的接口02：验证Ukey密码
	function Login(form_,key,password_){
		try {
			
			if (key == "") {
				alert("请选择UKey");
				return false;
			}
			
			var hasKey = getCertObjByKey(key);
			if (!hasKey) return false;
			
			var sc = hbcaCurKey.setUserPin(password_);
			//alert(sc);
			if (sc != "0") {
				return false;
			} else {
				var sc2 = SignedData("123abc",key)
				if (sc2 == "") {
					//alert("验证Ukey密码异常");
					return false;	
				}else{
					hbcaCurKey.setUserPin(password_);
					return true;
				}
			}
		} catch (e) {
			alert("验证Ukey密码异常");
			return false;
		}
	}

	//提供给业务系统的接口03: 数据Hash
	function HashData(inData){
		if (inData == "") return "";
		
		var rtn = iGetData("HashData",inData);
		if ((rtn.retCode == "0")) {
			return rtn.hashData;
		} else {
			return "";
		}
	}


	//提供给业务系统的接口04：数据签名
	function SignedData(content,key){
		//if (hbcaCurKey == "") return "";
		var hasKey = getCertObjByKey(key);
		if (!hasKey) return "";
		
		var signedValue = hbcaCurKey.PKCS7String(content,0);
		return signedValue;	
	}

	//提供给业务系统的接口04：数据签名, 兼容性支持医生站
	function SignedOrdData(content, key) {
		return SignedData(content,key);
	}

	//提供给业务系统的接口05：获取指定Ukey的信息
	function getUsrSignatureInfo(key){
		var usrSignatureInfo = new Array();
		var usrSignatureInfo = {};
		
		var certB64 = GetSignCert(key);
		usrSignatureInfo["certificate"] = certB64;
		usrSignatureInfo["UsrCertCode"] = GetUniqueID(certB64,key);
		usrSignatureInfo["identityID"] = GetIdentityID(key);
		usrSignatureInfo["certificateNo"] = GetCertNo(key);
		usrSignatureInfo["CertificateSN"] = GetCertSN(key);
		usrSignatureInfo["uKeyNo"] = GetKeySN(key);
		usrSignatureInfo["signImage"] = GetPicBase64Data(key);
		usrSignatureInfo["CertName"] = GetCertCNName(key);
		usrSignatureInfo["VenderCode"] = "HBCA";
		usrSignatureInfo["SignType"] = "UKEY";
		return usrSignatureInfo;
	}

	function GetSignCert(key){
		var hasKey = getCertObjByKey(key);
		if (!hasKey) return "";
		
		return hbcaCurKey.getContent();
	}

	function GetUniqueID(cert,key){
		if (typeof key != "undefined") {
			var hasKey = getCertObjByKey(key);
			if (!hasKey) return "";
		}
		var userId = hbcaCurKey.GetExtensionString("2.4.16.11.7.3","0");
		return userId;
	}

	function GetIdentityID(key) {
		//暂时置空
		return "";
		
		var hasKey = getCertObjByKey(key);
		if (!hasKey) return "";
			
		var identityID = hbcaCurKey.GetExtensionString("1.2.156.1001","0");
		
		var ind = identityID.indexOf("SF");
		var ret = identityID.substring(ind, identityID.length);
		return ret;
	}

	function GetCertNo(key) {
		return key;
	}

	function GetCertSN(key) {
		return key;
	}

	function GetKeySN(key) {
		return "Not Included";
	}

	function GetPicBase64Data(key){

		var hasKey = getCertObjByKey(key);
		if (!hasKey) return "";
		
		var workId = hbcaCurKey.GetExtensionString("2.4.16.11.7.3","0");
		var rtn = iGetData("GetSeal",workId);
		if ((rtn.retCode == "0")) {
			return rtn.signSeal;
		} else {
			return "";
		}
	}

	function GetCertCNName(key) {
		var hasKey = getCertObjByKey(key);
		if (!hasKey) return "";
		
		var cnName = hbcaCurKey.getFriendlyName();
		return cnName;
	}

	function getErrorMsg() {
		return hbcaSdkTool.getErrorString ()
	}
	
	///无记住密码功能IsLogin
	function SOF_IsLogin(key) {
		return false;
	}
	
	function LoginForm(paraObj) {
		//paraObj = paraObj||"";
		//var forceLogin = paraObj.forceLogin||false;
		
		return {retCode:"-1"};
	}
	
	return {
    	OCX: HBCASdkTool,
    	VenderCode:Const_Vender_Code,
    	SignType:Const_Sign_Type,
		GetUserList: function() {
			return GetUserList();
		},
		Login: function(strFormName, strCertID, strPin) {
			return Login(strFormName, strCertID, strPin);
			
		},
		HashData: function(inData) {
			return HashData(inData);
		},
		SignedData: function(content,key) {
			return SignedData(content,key);
		},
		SignedOrdData: function(content,key) {
			return SignedOrdData(content,key);
		},
		getUsrSignatureInfo: function(key) {
			return getUsrSignatureInfo(key);
		},
		GetSignCert: function(key) {
			return GetSignCert(key);
		},
		GetUniqueID: function(cert,key) {
			return GetUniqueID(cert,key);
		},
        GetRealKey: function(key) {
	    	return key;
    	},
		GetCertNo: function(key) {
			return GetCertNo(key);
		},
		GetLastError: function() {
			return getErrorMsg();
		},
		IsLogin: function(key) {
			return SOF_IsLogin(key);
		},
		LoginForm:function(paraObj) {
		    return LoginForm(paraObj);
	    }	
	}  
})();

///1.登录相关
///登录验证
function Login(strFormName, key, pin) {
	return ca_key.Login(strFormName, key, pin);
}
///是否登陆过
function IsLogin(key) {
	return ca_key.IsLogin(key);
}
function SOF_IsLogin(key) {
	return ca_key.IsLogin(key);
}

///2.证书列表
///获取证书列表
function GetUserList() {
	return ca_key.GetUserList();
}
function GetList_pnp() {
	return ca_key.GetUserList();
}
function getUserList2() {
	return ca_key.GetUserList();
}
function getUserList_pnp() {
	return ca_key.GetUserList();
}

///3.证书信息
///获取containerName
function GetRealKey(key) {
	return ca_key.GetRealKey(key);
}
///获取证书base64编码
function GetSignCert(key) {
	return ca_key.GetSignCert(key);
}
///获取CA用户唯一标识
function GetUniqueID(cert,key) {
	return ca_key.GetUniqueID(cert,key);
}
///获取证书唯一标识
function GetCertNo(key) {
	return ca_key.GetCertNo(key);
}
///获取证书信息集合
function getUsrSignatureInfo(key) {
	return ca_key.getUsrSignatureInfo(key);
}

///4.签名相关
///对待签数据做Hash
function HashData(content) {
	return ca_key.HashData(content);
}
///对待签数据的Hash值做签名
function SignedData(contentHash,key) {
	return ca_key.SignedData(contentHash,key);
}
function SignedOrdData(contentHash, key) {
	return ca_key.SignedOrdData(contentHash, key);
}

///5.其他
function LoginForm(paraObj) {
	return ca_key.LoginForm(paraObj);
}
function GetLastError() {
    return ca_key.GetLastError();
}