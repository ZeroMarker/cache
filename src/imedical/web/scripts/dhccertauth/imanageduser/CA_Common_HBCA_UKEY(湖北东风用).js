var ca_key = (function() {
    var Const_Vender_Code = "HBCA";
    var Const_Sign_Type = "UKEY";
    
	try {
	    if ((window.ActiveXObject)||("ActiveXObject" in window)) {
            HBCASdkTool = document.createElement("object");
            HBCASdkTool.setAttribute("width",1);
            HBCASdkTool.setAttribute("height",1);
            HBCASdkTool.setAttribute("id","HBCASdkTool");
            HBCASdkTool.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
            HBCASdkTool.setAttribute("classid","clsid:8DD0214E-C884-4847-90E7-2F49DB3F0A2B");
            document.documentElement.appendChild(HBCASdkTool);
            
			HBCASealSdk = document.createElement("object");
            HBCASealSdk.setAttribute("width",1);
            HBCASealSdk.setAttribute("height",1);
            HBCASealSdk.setAttribute("id","HBCASealSdk");
            HBCASealSdk.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
            HBCASealSdk.setAttribute("classid","clsid:5DE87F29-01E0-49F8-A557-5936DCF2376E");
            document.documentElement.appendChild(HBCASealSdk);
	    } else {
            alert("湖北CAUkey签名暂不支持非IE浏览器，请联系CA开发人员确认！")
        }
	} catch (e) {
	    alert("没有正确安装证书应用环境或证书应用环境已经损坏！");
	}

	//var hbcaSdkTool = window.top.HBCASdkTool;
	var hbcaSdkTool = HBCASdkTool;

	function GetUserList(){
	    hbcaSdkTool.SOF_SetHashMethod("SHA1");
	    hbcaSdkTool.SOF_SetCertAppPolicy("SIGN");
	    var userList = hbcaSdkTool.SOF_GetUserList();
	    if(userList==undefined||userList==""){
	        return ""
	    }else{
	        var arrUsers = userList.split('&&&');
	        userList = "";
	        for (var i = 0; i < arrUsers.length; i++) {
	            var user = arrUsers[i];
	            if (user != "") {
	                var keyName = user.split('||')[1].split(',')[0].split('=')[1];
	                var uniqueID = user.split('||')[0];
	                user = keyName+"||"+uniqueID;
	                if (i==0)
	                {
	                    userList = user;
	                }
	                else { userList = userList+"&&&"+user };
	            }
	        }
	        return userList;
	    }
	}

	function HashData(inData){
	    if(inData==undefined||inData==""){
	        return "";
	    }
	    var hashValue = hbcaSdkTool.SOF_HashData(inData);
	    return hashValue;
	}
	
	function SignedData(content,key){
	    hbcaSdkTool.SOF_SetP7SignMode(1);
	    var signedValue = hbcaSdkTool.SOF_SignDataByP7(key,content);
	    return signedValue;
	}

	function SignedOrdData(content, key) {
		hbcaSdkTool.SOF_SetP7SignMode(1);
	    var signedValue = hbcaSdkTool.SOF_SignDataByP7(key,content);
	    return signedValue;

	}

	function GetSignCert(key){
	    var userList = hbcaSdkTool.SOF_GetUserList();
	    if(userList==undefined||userList==""){
	        return ""
	    }else{
	        var users = userList.split("&&&");
            for (var i=0;i<users.length;i++) {	
                var properties = users[i].split('||');
	            if(properties[0]==key){
	                return properties[3];
	            }
	        }
	        return "";
	    }
	}

	function GetUniqueID(cert){
	    var userId = hbcaSdkTool.SOF_GetCertInfoByOidEx(cert,"2.4.16.11.7.3");
	    return userId;
	}

	// reutrn 1 登录成功
	function Login(form_,key,password_){
	    //return 1
	    var Rtn=0
	    // 湖北CA成功返回0 和我们要求不一致 做转换
	    var LoginRtn= hbcaSdkTool.SOF_Login(key,password_);
	    if (LoginRtn==0) {Rtn=1}
	    return Rtn
	    
	}

	function getUsrSignatureInfo(key){
	    var usrSignatureInfo = new Array();
	    var usrSignatureInfo = {};
	    usrSignatureInfo["identityID"] = GetIdentityID(key);
	    usrSignatureInfo["certificate"] = GetSignCert(key);
	    usrSignatureInfo["certificateNo"] = GetCertNo(key);
	    usrSignatureInfo["CertificateSN"] = GetCertSN(key);
	    usrSignatureInfo["uKeyNo"] = GetKeySN(key);
	    usrSignatureInfo["signImage"] = GetPicBase64Data(key);
	    var certB64 = GetSignCert(key);
	    usrSignatureInfo["UsrCertCode"] = GetUniqueID(certB64);
	    usrSignatureInfo["CertName"] = GetCertCNName(key);
	    return usrSignatureInfo;
	}

	function GetIdentityID(key)
	{
	    var certB64 = GetSignCert(key);
	    var identityID = hbcaSdkTool.SOF_GetCertInfoByOidEx(certB64,"1.2.156.1001");
	    var ind = identityID.indexOf("SF");
	    //return "Not Included";
	    var ret = identityID.substring(ind, identityID.length);
	    return ret;
	}

	function GetCertNo(key)
	{
	    return key;
	}

	function GetCertSN(key)
	{
	    return key;
	}

	function GetKeySN(key)
	{
	    return "Not Included";
	}

	function GetPicBase64Data(key)
	{
	    //return "Not Included";
	    return HBCASealSdk.SOF_GetKeyPictureEx(key,"");
	}

	function GetCertCNName(key)
	{
	    var userList = hbcaSdkTool.SOF_GetUserList();
	    if(userList==undefined||userList==""){
	        return ""
	    }else{
	        //fetch for cert
	        var users = userList.split("&&&");
	        for (var i=0;i<users.length;i++) {
	            var properties = users[i].split('||');
	            if(properties[0]==key){
	                return properties[1].split(',')[0].split('=')[1];
	            }
	        }
	        return "";
	    }
	}

	function getErrorMsg(){
	    return hbcaSdkTool.SOF_GetErrorMsg()
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