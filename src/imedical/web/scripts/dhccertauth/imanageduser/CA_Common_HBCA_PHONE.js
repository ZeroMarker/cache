var ca_key = (function() {
    /////
    var Const_Vender_Code = "HBCA";
    var Const_Sign_Type = "PHONE";
    
    var Global_Last_Login_CertInfo = "";
    var Global_Last_Login_SealInfo = ""
    var Global_Last_Login_Token = "";
    var Global_Last_Error_Code = "";
    var Global_Last_Error_Msg = "";
    
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
    
    function iGetCert(key) {
	    var userCertCode = key;
	    return iGetData("GetCert",userCertCode);
    }
    
    function iGetSeal(key) {
	    var userCertCode = key;
	    return iGetData("GetSeal",userCertCode);
    }
    
    function iGetSignQR() {
  		var result = iGetData("GetSignQR");
  		return result;
	}
    
    
    function iCheckAuthSignToken(key,token) {

		token = token||"";

		if (Global_Last_Login_CertInfo == "") {
			var loginedCert = iGetLoginedInfo();
			if (loginedCert.retCode == 0) {
				Global_Last_Login_CertInfo = loginedCert;
			}
		}

		if ((Global_Last_Login_CertInfo != "")&&(Global_Last_Login_CertInfo.certContainer == key)) {
			//优先使用传进来的token
			var currentToken = token || (Global_Last_Login_CertInfo.signToken || "");
			if (currentToken != "") {
				Global_Last_Login_CertInfo["signToken"] = currentToken;
				return Global_Last_Login_CertInfo;
			}
		}


		var para = {VenderCode:Const_Vender_Code,SignType:Const_Sign_Type,Key:key}
		var rtnStr = window.showModalDialog("../csp/dhc.certauth.auth.qrcode.csp",para,"dialogWidth:350px;dialogHeight:350px;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;fullscreen=no");

		if ((typeof(rtnStr) == "undefined")||(rtnStr == "")) {
			return {retCode:"-2",retMsg:"授权自动签名失败"};
		}

		var rtn = $.parseJSON(rtnStr);
		if ((rtn)&&(rtn.retCode == "0")&&(rtn.hisUserName != "")&&(rtn.certContainer == key)&&(rtn.signToken != "")) {
			Global_Last_Login_CertInfo = rtn;
			return rtn;
		}

		return {retCode:"-2",retMsg:"授权自动签名失败"};

	}
	
	
	// @signGUID 签名guid
	function iGetSignQRResult(signGUID) {
  		var result = iGetData("GetSignQRResult", signGUID);
  		return result;
	}
	
	function iGetLastErrorCode() {
	    return Global_Last_Error_Code;
	}

	function iGetLastErrorMsg() {
	    return "错误码[" + Global_Last_Error_Code + "] 错误描述[" + Global_Last_Error_Msg + "]"
	}

	function iCheckValid(userCert) {
	    return true;
	}

	// 用户登录
	function iLogin(strFormName, strCertID, strPin) {

        return false;
	}
	
	function iGetLoginedInfo() {
		var result = iGetData("GetLoginedInfo");
  		return result;
	}
	
	function iSignData(inData,key) {
		
		var ret = "";
		var rtn = iCheckAuthSignToken(key);
		if (rtn.retCode == "0") {
			var token = rtn.signToken || "";
			if(token != "") {
				var rtn = iGetData("AuthSign",inData,key,token);
				if ((rtn.retCode == "0")&&(rtn.signStatus = "FINISH")) {
					return rtn.signData;
				} else {
					Global_Last_Error_Msg = rtn.retMsg;
					return "";
				}
			}
		} 

		return ret;
		
		/*var rtn = iGetData("AuthSign",inData,key);
		if (rtn.retCode == "0") {
			return rtn.signData;
		} else {
			Global_Last_Error_Msg = rtn.retMsg;
			return "";
		}*/
	}
	
	function iHashData(inData) {
		var rtn = iGetData("HashData",inData);
		if ((rtn.retCode == "0")) {
			return rtn.hashData;
		} else {
			Global_Last_Error_Msg = rtn.retMsg;
			return "";
		}
	}
	
	function iIsLastLoginCert(key,cert) {
		key = key||"";
		cert = cert||"";
		if ((key != "")&&(Global_Last_Login_CertInfo != "")&&(Global_Last_Login_CertInfo.certContainer == key)){
			return true;
		} else if ((cert != "")&&(Global_Last_Login_CertInfo != "")&&(Global_Last_Login_CertInfo.signCert == cert)){
			return true;
		} else {
			return false;
		}
	}
	
	function iIsLastLoginSeal(key) {
		var usercertcode = key;
		if ((key != "")&&(Global_Last_Login_SealInfo != "")&&(Global_Last_Login_SealInfo.userCertCode == usercertcode)){
			return true;
		} else {
			return false;
		}
	}
	
    function iGetTokenIsValid(key,token) {
		var result = iGetData("GetTokenIsValid",key,token);
  		return result;
	}
    
	// /////////////////对外接口

	function GetUserList() {
	    return ""
	}
	
	function getUserList_pnp() {
	    return GetUserList();
	}
	
	function SignedData(content, key) {
	    return iSignData(content, key);
	}
	
	function SignedOrdData(content, key) {
	    return iSignData(content, key);
	}
	
	// 获取身份证号
	function GetIdentityID(key) {
		return "";
	}

	///不管理证书，返回工号accountID
	function GetSignCert(key) {
		return key;
	}

	function GetCertSN(cert) {
	    return "";

	}

	function GetKeySN(key) {
	    return "";
    }

	function GetPicBase64Data(key) {
        if (key == "") return "";
		var workId = key;
		var result = "";
		$.ajax({
			type: 'GET',
			dataType: 'text',
			url: "../EMRservice.Ajax.common.cls",
			async: false,
			cache: false,
			data: {
					"OutputType":"String",
					"Class":"CA.HBCAService",
					"Method":"GetImage",
					"p1":workId
			},
			success: function(ret) {
				if (ret != "") {
					result = ret;    
				}else {
					alert("签章信息为空值！");
				}
			},
			error: function(ret) {
				alert("获取签章信息失败！");    
			}
		});    
		return result;    
	}

	function HashData(InData) {
	
	    return iHashData(InData);
	}

	// 证书标识符，用于区分证书,放置用户证书唯一标识
	function GetUniqueID(cert, key) {
	    return cert;
	    /*if (cert == "") return "";
	   	
		if (iIsLastLoginCert("",cert)) {
			return Global_Last_Login_CertInfo.userCertCode;
		} else {
			
			var obj = iGetCert(key);
			if (obj.retCode == "0") {
				return obj.certNo;
			}

			return "";
		}
		 
		return "";*/
	}

	function GetCertCNName(cert) {
	   	 
	   	if (cert == "") return "";
	   	
		if (iIsLastLoginCert("",cert)) {
			return Global_Last_Login_CertInfo.certName;
		} else {
			/*
			var obj = iGetCert(key);
			if (obj.retCode == "0") {
				return obj.certNo;
			}
			*/
			return "";
		}
		 
		return "";
	}

	function getKeySN(key) {
	    if (key != "") {
	        var strs = new Array(); // 定义一数组
	        strs = key.split("/"); // 字符分割
	        var keysn = strs[1];
	        return keysn;

	    } else {
	        return null;
	    }
	}

	function GetGetPicBase64(key) {
	   key = getRealKey(key);
	   return GetPicBase64Data(key);
	}

	function GetCertNo(key) {
		key = getRealKey(key);
		if (key == "") return "";
		 
		if (iIsLastLoginCert(key)) {
			return Global_Last_Login_CertInfo.certNo;
		} else {
			var obj = iGetCert(key);
			if (obj.retCode == "0") {
				return obj.certNo;
			}
		}
		 
		return "";
	}

	function getUsrSignatureInfo(key) {
		var usrSignatureInfo = new Array();
	    
	    var ret = iGetData("GetCertByUserCode",userCode,"");
	    if ((ret == "")||(ret.retCode != "0")) return "";
	    
	    var ret2 = iGetData("GetSeal",userCode);
	    if ((ret2 == "")||(ret2.retCode != "0")) return "";
	    
	    usrSignatureInfo["identityID"] = "";
	    usrSignatureInfo["certificate"] = ret.signCert;
	    usrSignatureInfo["certificateNo"] = ret.certNo;
	    usrSignatureInfo["CertificateSN"] = ret.certSN;
	    usrSignatureInfo["uKeyNo"] = "";
	   	usrSignatureInfo["signImage"] = ret2.signSeal;
	    usrSignatureInfo["UsrCertCode"] = ret.userCertCode;
	    usrSignatureInfo["CertName"] = ret.certName;
	    return usrSignatureInfo;
	}
    
    function getCertInfoByUserCode(userCode, phoneNum) {
	    var usrSignatureInfo = new Array();
	    
	    var ret = iGetData("GetCertByUserCode",userCode,phoneNum);
	    if ((ret == "")||(ret.retCode != "0")) return "";
	    
	    var ret2 = iGetData("GetSeal",userCode);
	    if ((ret2 == "")||(ret2.retCode != "0")) return "";
	    
	    usrSignatureInfo["identityID"] = "";
	    usrSignatureInfo["certificate"] = ret.signCert;
	    usrSignatureInfo["certificateNo"] = ret.certNo;
	    usrSignatureInfo["CertificateSN"] = ret.certSN;
	    usrSignatureInfo["uKeyNo"] = "";
	   	usrSignatureInfo["signImage"] = ret2.signSeal;
	    usrSignatureInfo["UsrCertCode"] = ret.userCertCode;
	    usrSignatureInfo["CertName"] = ret.certName;
	    return usrSignatureInfo;
	}

	//校验输入的密码 正确返回空
	function CheckPWD(strCertID, strPin) {
	    if (strCertID == null || strCertID == "") {
	        return "获取用户信息失败";
	    }
		/*
	    if (strPin == null || strPin == "") {
	        return "请输入证书密码";
	    }
	    if (strPin.length < 6 || strPin.length > 16) {
	        return "密码长度应该在4-16位之间";
	    }
		*/
	    // 校验密码
	    var ret = iLogin(strCertID, strPin);
	    if (!ret) {
	        return "登录失败!";
	    }
		
	    return "";
	}

	//校验随机数
	function CheckForm(strCertID, strServerCert, strServerRan, strServerSignedData) {

	    var result = {};

	    // 导出客户端证书
	    //var userCert = SOF_ExportUserCert(strCertID, KEY_SIGNOREXCHANGE);
	    var userCert = GetSignCert(strCertID, KEY_SIGNOREXCHANGE);
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
	    //var strClientSignedData = SOF_SignData(strCertID, strServerRan);
	    var strClientSignedData = SignedData(strServerRan,strCertID);
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
    
    //封装基础平台websys_getMWToken()方法
    function getMWToken()
    {
        try{
            if (typeof(websys_getMWToken) != "undefined")
                return websys_getMWToken();
            return "";
        } catch(e) {
            return "";
        }
    }
    
    /// 创建HISUI-Dialog弹窗
    function createModalDialog(dialogId, dialogTitle, width, height, iframeId, iframeContent,callback,arr1,arr2,maximi,minimi){
        $("body").append("<div id='"+dialogId+"'</div>");
        if (isNaN(width)) width = 800;
        if (isNaN(height)) height = 500;  
        if(document.getElementById("editor")&&(judgeIsIE()==false))
        document.getElementById("editor").style.visibility="hidden"; //隐藏插件
        if (maximi == undefined) maximi = false;
        if (minimi == undefined) minimi = false;
        $HUI.dialog('#'+dialogId,{ 
            title: dialogTitle,
            width: width,
            height: height,
            cache: false,
            collapsible: false,
            minimizable:minimi,
            maximizable:maximi,
            resizable: false,
            modal: true,
            closed: false,
            closable: true,
            isTopZindex: true,
            content: iframeContent,
            onBeforeClose:function(){
                var tempFrame = $('#'+iframeId)[0].contentWindow;
                if (tempFrame && tempFrame.returnValue)
                {
                    rtnStr = tempFrame.returnValue;
                    
                    if ((typeof(rtnStr) == "undefined")||(rtnStr == "")) {
                        rtnStr = {retCode:"-2",retMsg:"登录失败"};
                    } else {
                        var rtn = $.parseJSON(rtnStr);
                        if ((rtn)&&(rtn.retCode == "0")&&(rtn.hisUserName != "")) {
                            Global_Last_Login_CertInfo = rtn;
                        }
                        rtnStr = rtn||{retCode:"-2",retMsg:"登录失败"};
                    }
                    
                    if ((rtnStr !== "") &&(typeof(callback) === "function"))
                    {
                        callback(rtnStr,arr1,arr2);
                    }
                }
            },
            onClose:function(){
                if(document.getElementById("editor"))
                document.getElementById("editor").style.visibility="visible"; //隐藏插件
             }
        });
    }
    
    function judgeIsIE() { //ie?
        if (!!window.ActiveXObject || "ActiveXObject" in window)
            return true;
        else
            return false;
    }

	function LoginForm(paraObj,callback,arr1,arr2) {
		paraObj = paraObj||"";
        var forceLogin = paraObj.forceLogin||false;
        if ((!forceLogin)&&(Global_Last_Login_CertInfo != "")) {
            if (oGetTokenIsValid(Global_Last_Login_CertInfo.certContainer,Global_Last_Login_CertInfo.signToken))
            {        
                if (judgeIsIE()){
                    return Global_Last_Login_CertInfo;
                }else {
                    callback(Global_Last_Login_CertInfo,arr1,arr2);    
                    return;
                }
            }
        }
        
        if ((!forceLogin)) {
            var loginedCert = iGetLoginedInfo();
            if (loginedCert.retCode == 0) {
                if (oGetTokenIsValid(loginedCert.certContainer,loginedCert.signToken))
                {
                    Global_Last_Login_CertInfo = loginedCert;
                    if (judgeIsIE()){
                        return Global_Last_Login_CertInfo;
                    }else {
                        callback(Global_Last_Login_CertInfo,arr1,arr2);    
                        return;
                    }
                }
            }
        }
        
        
        if (judgeIsIE())
        {
            var para = {VenderCode:Const_Vender_Code,SignType:Const_Sign_Type}
            var rtnStr = window.showModalDialog("../csp/dhc.certauth.login.qrcode.csp?venderCode="+Const_Vender_Code+"&signType="+Const_Sign_Type+"&MWToken="+getMWToken(),para,
                            "dialogWidth:350px;dialogHeight:350px;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;fullscreen=no");
            
            if ((typeof(rtnStr) == "undefined")||(rtnStr == "")) {
                return {retCode:"-2",retMsg:"登录失败"};
            }
            
            var rtn = $.parseJSON(rtnStr);
            if ((rtn)&&(rtn.retCode == "0")&&(rtn.hisUserName != "")) {
                Global_Last_Login_CertInfo = rtn;
            }
            return rtn||{retCode:"-2",retMsg:"登录失败"};
        }
        else
        {
            var content = '<iframe id="loginQrcodeFrame" scrolling="auto" frameborder="0" src="dhc.certauth.login.qrcode.csp?isNeedCallBack=1&venderCode='+Const_Vender_Code+'&signType='+Const_Sign_Type+'&MWToken='+getMWToken()+'" style="width:100%; height:100%;"></iframe>';
            createModalDialog("loginQrcode","扫码页面",350,400,'loginQrcodeFrame',content,callback,arr1,arr2);        
        }
	}
	
    function oGetTokenIsValid(key,token) {
		return iGetTokenIsValid(key,token)
	}
    
	function getRealKey(key) {
        key = key||"";
		if (key == "") {
			if (Global_Last_Login_CertInfo == "") {
				return "";
			} else {
				return Global_Last_Login_CertInfo.certContainer||"";
			}
		} else {
			return key;
		}
	}
    
    function oSetCertInfo(certInfo) {
		var tmpCertInfo = certInfo;
		
		Global_Last_Login_CertInfo = $.parseJSON(tmpCertInfo);
		return true;
	}

    return {
    	OCX: "",
    	VenderCode:Const_Vender_Code,
    	SignType:Const_Sign_Type,
    	GetRealKey: function(key) {
	    	return getRealKey(key);
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
        IsLogin: function(strKey) {
            return false;
        },
        GetUserList: function() {
            return GetUserList();
        },
        GetSignCert: function(key) {
            return GetSignCert(key);
        },
        GetUniqueID: function(cert, key) {
            return GetUniqueID(cert, key);
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
        getCertInfoByUserCode: function(userCode,phoneNum) {
            return getCertInfoByUserCode(userCode,phoneNum);
        },
        HashData:function(content){
	    	return HashData(content)  
	    },
        GetTokenIsValid:function(key,token) {
		    return oGetTokenIsValid(key,token);
	    },
	    LoginForm:function(paraObj,callback,arr1,arr2) {
		    return LoginForm(paraObj,callback,arr1,arr2);
	    },
	    SetCertInfo:function(certInfo) {
			return oSetCertInfo(certInfo);    
		}
    }
})();

///0.为兼容Ukey
function GetUserList() {
	return ca_key.GetUserList();
}
function getUserList_pnp() {
	return ca_key.GetUserList();
}
function GetList_pnp() {
	return ca_key.GetUserList();
}
function Login(strFormName, key, pin) {
	return Login(strFormName, key, pin);
}
function CheckPWD(key, pin) {
    return ca_key.CheckPWD(key, pin);
}
function CheckForm(key, strServerCert, strServerRan, strServerSignedData) {
    return ca_key.CheckForm(key, strServerCert, strServerRan, strServerSignedData);
}

///1.登录相关
function LoginForm(paraObj,callback,arr1,arr2) {
	return ca_key.LoginForm(paraObj,callback,arr1,arr2);
}
function IsLogin(key) {
	return ca_key.IsLogin(key);
}
function GetTokenIsValid(key,token) {
	return ca_key.GetTokenIsValid(key,token);	
}
function SetCertInfo(certInfo){
	return ca_key.SetCertInfo(certInfo);
}


///2.证书信息
///获取containerName
function GetRealKey(key) {
	return ca_key.GetRealKey();
}
///获取证书base64编码
function GetSignCert(key) {
	return ca_key.GetSignCert(key);
}
///获取CA用户唯一标识
function GetUniqueID(cert, key) {
	return ca_key.GetUniqueID(cert, key);
}
///获取证书唯一标识
function GetCertNo(key) {
	return ca_key.GetCertNo(key);
}
///获取证书信息集合
function getUsrSignatureInfo(key) {
	return ca_key.getUsrSignatureInfo(key);
}
///获取证书及图片信息供绑定证书使用
function getCertInfoByUserCode(userCode,phoneNum) {
	return ca_key.getCertInfoByUserCode(userCode,phoneNum);
}

///3.签名相关
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