var ca_key = (function() {
	
	try {
        if ((window.ActiveXObject)||("ActiveXObject" in window)) {
            //document.writeln("<OBJECT classid=\"CLSID:8F8E6255-C0DB-4FC9-AA1A-AF29F005FB8B\" height=1 id=Suresec  style=\"HEIGHT: 1px; LEFT: 10px; TOP: 28px; WIDTH: 1px\" width=1 VIEWASTEXT></OBJECT>");
            Suresec = document.createElement("object");
            Suresec.setAttribute("width",1);
            Suresec.setAttribute("height",1);
            Suresec.setAttribute("id","Suresec");
            Suresec.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
            Suresec.setAttribute("classid","clsid:8F8E6255-C0DB-4FC9-AA1A-AF29F005FB8B");
            document.documentElement.appendChild(Suresec);
        } else {
            alert("山东确信CA签名暂不支持非IE浏览器，请联系CA开发人员确认！")
        }
        Suresec = document.getElementById("Suresec");
		Suresec.HashData("init");
		//Suresec.EmuKey("foo");
	} catch (e) {
		alert("请检查证书应用环境是否正确安装!");
	}
	
	var Const_Vender_Code = "SURE";
	var Const_Sign_Type = "UKEY";
		
	var globalPin = "";
	
	var Last_CertInfo_ContainerName = "";
	var Last_CertInfo_UserCertCode = "";
	var Last_CertInfo_CertNo = "";
	var Last_CertInfo_Cert = "";	
	
	function EmuKey(key) {
		return Suresec.EmuKey(key);
	}

	// 用户登录
	function Login(strFormName, strCertID, strPin) {
		if ((strFormName||"") != "") {
			var objForm = eval(strFormName);
			if(objForm == null) {
				alert("表单错误");
				return false;
			}
		}
		// 校验密码
		return Login2(strCertID, strPin);
	}

	function Login2(strCertID, strPin) {
		if (SOF_IsLogin(strCertID)) return true;
		if(strCertID == null || strCertID == "") {
			alert("获取用户信息失败");
			return false;
		}
		if(strPin == null || strPin == "") {
			alert("请输入证书密码");
			return false;
		}
		if(strPin.length < 4 || strPin.length > 16) {
			alert("密码长度应该在4-16位之间");
			return false;
		}
		if(!EmuKey(strCertID)) {
			return false;
		}
		// 校验密码
		//debugger;
		var ret = Suresec.Login(strCertID,strPin);
		if(ret) {
			globalPin = strCertID+'^'+strPin;
			SetKeyPinInsession(globalPin);
			Last_CertInfo_CertNo = GetCertNo(strCertID);	
	 		Last_CertInfo_Cert = Suresec.GetSignCert(strCertID);
	 		Last_CertInfo_UserCertCode = GetUniqueID(Last_CertInfo_Cert,strCertID);	
	 		Last_CertInfo_ContainerName = strCertID;
			return true;
		} 
		else {
			ret = Suresec.GetPwdRetryNum();
			if(ret>0) {
				alert("剩余密码重试次数 "+ret+" 次!");
			}
			else if(ret==0) {
				alert("UKey已经锁定，请联系系统管理员进行处理！");
			}
			return false;
		}
	}
	
	function SOF_IsLogin(key) {
		if (globalPin == "") {
			$.ajax({
				type: 'GET',
				dataType: 'text',
				url: '../CA.Ajax.Common.cls',
				async: false,
				cache: false,
                global:false,
				data: {
					"OutputType": "String",
					"Class": "CA.DigitalSignatureService",
					"Method": "GetKeyPinInSession",
					"p1":key
				},
				success:function(ret) {
					globalPin = ret	
				}
			});
		}
		
		
		var result = false;
		if ((globalPin != "")&&(globalPin.split("^").length == 2)&&(globalPin.split("^")[0] == key)&&(globalPin.split("^")[1] != "")){
			result = true;
		} else {
			globalPin = "";
		}
	
		return result;
	}
	
	function SetKeyPinInsession(data){
		$.ajax({
			type: 'GET',
			dataType: 'text',
			url: '../CA.Ajax.Common.cls',
			async: false,
			cache: false,
            global:false,
			data: {
				"OutputType": "String",
				"Class": "CA.DigitalSignatureService",
				"Method": "SetKeyPinInSession",
				"p1":data
			}
		});
	}

	function GetUserList() {
		//debugger;
		try {
			var ret = Suresec.GetUserList();
			//ret = "&&&C=CN,ST=Guangdong,L=广州,O=南昌大学第二附属医院测试证书4,CN=南昌大学第二附属医院测试证书4||F517034131000000::ENTERSAFE-ESPK&&&C=CN,ST=Guangdong,L=广州,O=南昌大学第二附属医院测试证书1,CN=南昌大学第二附属医院测试证书1||F517034140000000::ENTERSAFE-ESPK";
			var usrListOrg = ret.split("&&&");
			var usr = "";
			var usrName = "";
			var usrPass = "";
			var usrList = "";
			
			for(var i=0;i<usrListOrg.length;i++) {
				usr = usrListOrg[i];
				if(usr.indexOf("CN")<0) {
					continue;
				}
				//debugger;
				usrName = usr.split("||")[0].split("CN=")[1];
				usrPass = usr.split("||")[1];
				if(i==1) {
					usr = usrName + "||" + usrPass;
				}
				else{
					usr = "&&&" + usrName + "||" + usrPass;
				}
				usrList += usr;
			}
			
			return usrList;
		}
		catch(e) {
			//alert(e.message);
			return "";
		}
	}

	function SignedData(content, key) {
		//return Suresec.SignedData(content);
		if (!SOF_IsLogin(key)) {
			return "";
		}
		
		var ret = Suresec.Login(key, globalPin.split("^")[1])
		if(ret==true) {
			var signdata = Suresec.SignedDataPin(content,globalPin.split("^")[1]);
			return signdata;
		}
		else {
			return "";
		}
	}
	function SignedOrdData(content, key) {
		//return Suresec.SignedData(content);
		if (!SOF_IsLogin(key)) {
			return "";
		}
		
		var ret = Suresec.Login(key, globalPin.split("^")[1])
		if(ret==true) {
			var signdata = Suresec.SignedDataPin(content,globalPin.split("^")[1]);
			return signdata;
		}
		else {
			return "";
		}
	}
	// 获取身份证号
	function GetIdentityID(key) {
		return "";
	}

	function GetSignCert(key) {
		if ((key == Last_CertInfo_ContainerName)&&(Last_CertInfo_Cert!= ""))
		{
			return Last_CertInfo_Cert;
		}
		var rtn = Suresec.GetSignCert(key);
		if (rtn!=""){
			Last_CertInfo_ContainerName = key;
			Last_CertInfo_Cert = rtn; 
		}
		return rtn;
	}

	function GetCertSN(cert) {
		return GetUniqueID(cert);
	}

	function GetKeySN(key) {
		return key;
	}

	function HashData(InData) {
		return Suresec.HashData(InData);
	}

	function GetUniqueID(cert,key) {
		//return "";
		key = key||"";
		if ((key == Last_CertInfo_ContainerName)&&(Last_CertInfo_UserCertCode!= ""))
		{
			return Last_CertInfo_UserCertCode;
		}
		return Suresec.GetUniqueID(cert);
	}

	function GetPicBase64Data(key) {
		try {
			var ret = Suresec.ReadImageKeysn(key);
			return ret;
		}
		catch(e) {
			return "";
		}
	}

	function GetPicBase64ViaLogin(key,pin) {
		var ret = sure_Login(key, pin);
		if(ret) {
			return Suresec.ReadImage();
		}
		else{
			return "";
		}
	}

	function GetCertNo(key) {
		if ((key == Last_CertInfo_ContainerName)&&(Last_CertInfo_CertNo!= ""))
		{
			return Last_CertInfo_CertNo;
		}
		return Suresec.GetCertNo(key);
	}

	function GetCertCNName(cert) {
		return Suresec.GetCertSubject(cert).split("CN=")[1];
	}

	function getUsrSignatureInfo(key) {
		//debugger;
		try {
			var usrSignatureInfo = new Array();
			usrSignatureInfo["identityID"] = GetIdentityID(key);
			var cert = GetSignCert(key);
			usrSignatureInfo["certificate"] = cert;
			usrSignatureInfo["certificateNo"] = GetCertNo(key);
			usrSignatureInfo["CertificateSN"] = usrSignatureInfo["certificateNo"];
			usrSignatureInfo["CertificateSN"] = GetCertSN(cert);
			usrSignatureInfo["uKeyNo"] = GetKeySN(key);
			usrSignatureInfo["signImage"] = GetPicBase64Data(key);
			usrSignatureInfo["UsrCertCode"] = GetUniqueID(cert,key);
			usrSignatureInfo["CertName"] = GetCertCNName(cert);
			return usrSignatureInfo;
		}
		catch(e) {
			alert(e.Message);
		}
	}
	
	//校验输入的密码 正确返回空
	function CheckPWD(strCertID, strPin) {
		if(strCertID == null || strCertID == "") {
			return "获取用户信息失败";
		}
		if(strPin == null || strPin == "") {
			return "请输入证书密码";
		}
		if(strPin.length < 4 || strPin.length > 16) {
			return "密码长度应该在4-16位之间";
		}
		if(!EmuKey(strCertID)) {
			return "指定UKey不存在";
		}
		// 校验密码
		//debugger;
		var ret = Suresec.Login(strCertID,strPin);
		if(ret) {
			globalPin = strCertID+'^'+strPin;
			SetKeyPinInsession(globalPin);
			return "";
		} 
		else {
			ret = Suresec.GetPwdRetryNum();
			if(ret>0) {
				return "剩余密码重试次数 "+ret+" 次!";
			}
			else if(ret==0) {
				return "UKey已经锁定，请联系系统管理员进行处理！";
			}
			return "密码错误";
		}
	}
	
	//校验随机数
	function CheckForm(strCertID, strServerCert, strServerRan, strServerSignedData) {

	    var result = {};
		result.errMsg("不支持随机数校验功能!");
	    return result;
		
	    // 导出客户端证书
	    var userCert = GetSignCert(strCertID);
	    if (userCert == null || userCert == "") {
	        result.errMsg("导出用户证书失败!");
	        return result;
	    }

	    // 验证服务端签名
	    ret = SOF_VerifySignedData(strServerCert, strServerRan, strServerSignedData)
	    if (!ret) {
	        result.errMsg = '验证服务器端信息失败!';
	        return result;
	    }

	    // 对随机数做签名
	    if (strClientSignedData == null || strClientSignedData == '') {
	        result.errMsg = '客户端签名失败!';
	        return result;
	    }

	    result.errMsg = '';
	    result.UserSignedData = strClientSignedData;
	    result.UserCert = userCert;
	    result.ContainerName = strCertID;
   
	    return result;
	}
	
	function oGetLastError() {
		return "";
	}
	
	function iGetLoginedInfo() {
		var result = iGetData("GetLoginedInfo");
  		return result;
	}
	
	function iGetData(Func,P1,P2,P3,P4,P5,P6,P7,P8,P9) {
    	
    	var result = "";
    	
    	var para = {
	  		CAFunc: Func,
	  		CAVenderCode:Const_Vender_Code,
	  		CASignType:Const_Sign_Type,
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
	
	function oLoginForm(paraObj) {
		paraObj = paraObj||"";
		var forceLogin = paraObj.forceLogin||false;
		
		/*
		if ((!forceLogin)&&(Global_Last_Login_CertInfo != "")) {
			if (SOF_IsLogin(Global_Last_Login_CertInfo.certContainer)) {
				return Global_Last_Login_CertInfo;
			}
		}
		*/
		
		if ((!forceLogin)) {
			var loginedCert = iGetLoginedInfo();
			if ((loginedCert.retCode == 0)&&(loginedCert.certContainer != "")) {
				if (iKeyExist(loginedCert.certContainer)&&(SOF_IsLogin(loginedCert.certContainer))) {
					loginedCert.signCert = GetSignCert(loginedCert.certContainer);
					loginedCert.userCertCode = GetUniqueID(loginedCert.signCert);
					loginedCert.certNo = GetCertNo(loginedCert.certContainer);
					Global_Last_Login_CertInfo = loginedCert;
					return Global_Last_Login_CertInfo;
				}
			}	
		}
		
		
		var url = "../csp/dhc.certauth.login.ukey.csp?venderCode=" + Const_Vender_Code + "&signType=" + Const_Sign_Type;
		var para = {
			GetUserList: function() {
				return GetUserList();
			},
			CheckPWD: function(key, pin) {
				return CheckPWD(key, pin);
			},
			GetSignCert: function(key) {
				return GetSignCert(key);
			},
			GetCertNo: function(key) {
				return GetCertNo(key);
			},
			GetUniqueID: function(cert,key) {
				return GetUniqueID(cert);
			}
		};
		var rtnStr = window.showModalDialog(url,para,"dialogWidth:350px;dialogHeight:350px;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;fullscreen=no");
		
		if ((typeof(rtnStr) == "undefined")||(rtnStr == "")) {
			return {retCode:"-2",retMsg:"登录失败"};
		}
		
		//var rtn = JSON.parse(rtnStr);
		var rtn = $.parseJSON(rtnStr);
		if ((rtn)&&(rtn.retCode == "0")&&(rtn.hisUserName != "")) {
			Global_Last_Login_CertInfo = rtn;
		}
		
		return rtn||{retCode:"-2",retMsg:"登录失败"};
	}
	
	return {
    	OCX: Suresec,
    	VenderCode:"SURE",
    	SignType:"UKEY",
    	GetRealKey: function(key) {
	    	return key;
    	},
        CheckPWD: function(key, pwd) {
            return CheckPWD(key, pwd);
        },
        CheckForm: function(key, strServerCert, strServerRan, strServerSignedData) {
            return CheckForm(key, strServerCert, strServerRan, strServerSignedData);
        },
        Login: function(strFormName, strCertID, strPin) {
            return Login(strFormName, strCertID, strPin);
        },
        SOF_Islogin: function(strKey) {
            if ('undefined' != SOF_IsLogin) {
                return SOF_IsLogin(strKey);
            }
            return false;
        },
        GetUserList: function() {
            return GetUserList();
        },
		getUserList2: function() {
            return GetUserList();
        },
        GetSignCert: function(key) {
            return GetSignCert(key);
        },
        GetUniqueID: function(cert,key) {
            return GetUniqueID(cert,key);
        },
        GetCertNo: function(key) {
            return GetCertNo(key);
        },
        SignedData: function(contentHash, key) {
            return SignedData(contentHash, key)
        },
        SignedOrdData: function(contentHash, key) {
            return SignedOrdData(contentHash, key)
        },
        getUsrSignatureInfo: function(key) {
            return getUsrSignatureInfo(key);
        },
        HashData:function(content){
	    	return HashData(content)  
	    },
		LoginForm:function(paraObj) {
		    return oLoginForm(paraObj);
	    },
	  	GetPicBase64Data:function(key) {
	    	return GetPicBase64Data(key);
		},
		GetLastError:function() {
	    	return oGetLastError();
	    }
    }
	
})();

///1.登录相关
///登录验证
function Login(strFormName, key, pin) {
	return ca_key.Login(strFormName, key, pin);
}
///是否登陆过
function SOF_Islogin(key) {
	return ca_key.SOF_Islogin(key);
}
function IsLogin(key) {
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
	return ca_key.GetRealKey();
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
function HashData(content){
	return ca_key.HashData(content) 
}
///对待签数据的Hash值做签名
function SignedData(contentHash, key) {
	return ca_key.SignedData(contentHash, key)
}
function SignedOrdData(contentHash, key) {
	return ca_key.SignedOrdData(contentHash, key)
}

///5.其他
function CheckPWD(key, pwd) {
    return ca_key.CheckPWD(key, pwd);
}
function CheckForm(key, strServerCert, strServerRan, strServerSignedData) {
    return ca_key.CheckForm(key, strServerCert, strServerRan, strServerSignedData);
}
function LoginForm(paraObj) {
	return ca_key.LoginForm(paraObj);
}
function GetLastError() {
    return ca_key.GetLastError();
}