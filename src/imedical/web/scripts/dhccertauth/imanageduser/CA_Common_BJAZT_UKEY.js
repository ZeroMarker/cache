///北京安证通UKey客户端接口对接
var ca_key = (function() {
    var Const_Vender_Code = "BJAZT";
    var Const_Sign_Type = "UKEY";

    try {
        if (window.ActiveXObject || "ActiveXObject" in window) {
            GolEasyCAobj = document.createElement("object");
            GolEasyCAobj.setAttribute("width",1);
            GolEasyCAobj.setAttribute("height",1);
            GolEasyCAobj.setAttribute("id","GolEasyCA");
            GolEasyCAobj.setAttribute("name","GolEasyCA");
            GolEasyCAobj.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
            GolEasyCAobj.setAttribute("classid","clsid:5A41B8F3-2BE5-4000-8ABF-E6E269C20218");
        } else {
            GolEasyCAobj = document.createElement("embed");
            GolEasyCAobj.setAttribute("width",1);
            GolEasyCAobj.setAttribute("height",1);
            GolEasyCAobj.setAttribute("id","GolEasyCA");
            GolEasyCAobj.setAttribute("name","GolEasyCA");
            GolEasyCAobj.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
            GolEasyCAobj.setAttribute("type","application/x-itst-activex");
            GolEasyCAobj.setAttribute("clsid","{5A41B8F3-2BE5-4000-8ABF-E6E269C20218}");
        }
        document.documentElement.appendChild(GolEasyCAobj);
    } catch (e) {
	    alert("请检查证书应用环境是否正确安装!");
	}
    
    //提供给业务系统的接口01: 获取Ukey列表
    //返回串格式为    证书名称||硬件UKey的SN(之后获取信息使用)&&&..
    function GetUserList(){        
        var result = ""
        var userList0 = GolEasyCA.ESAGetCertInfoList();
        if (userList0 == "")
            return "";
        
        var userListArr = userList0.split("&&&");
        for (var i =0; i < userListArr.length; i++) {
            var tmpkey = userListArr[i].split("||")[1];
            var tmpName = userListArr[i].split("||")[0];
            
            if (result == "") {
                result = tmpName + "||" + tmpkey;
            } else {
                result = result + "&&&" + tmpName + "||" + tmpkey;
            }
        }
        return result;
    }
    
    //提供给业务系统的接口02：验证Ukey密码
    function Login(strFormName, strCertID, strPin, forceCheck) {
        strPin = strPin || "";
        if (iKeyExist(strCertID) && (SOF_IsLogin(strCertID)) && (strPin == "") && (!forceCheck)) {
            return true;
        }
        
        var lt = GolEasyCA.Login("",strCertID,strPin); 
        if(lt == 0){
            return true;
        }
        return false;
    }

    //提供给业务系统的接口03: 数据Hash
    function HashData(inData){
        if (inData == "") return "";
        
        var hashData = GolEasyCA.GetHashData(inData);
        return hashData;
    }

    //提供给业务系统的接口04：数据签名
    function SignedData(content,key){        
        var signedValue = GolEasyCA.GetSignData(content,key);  
        if (signedValue == "") {
			alert("获取签名结果为空");
			return "";
		}
        //签名结果验证
        var signAndTs = GolEasyCA.VerifySignAndTsa(content,signedValue);
		signAndTs = JSON.parse(signAndTs);
		if (signAndTs.SignVer == "0") {
			return signedValue;
		} else {
			alert("验证签名失败："+signAndTs);
		} 
		return ""; 
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
        usrSignatureInfo["VenderCode"] = "BJAZT";
        usrSignatureInfo["SignType"] = "UKEY";
        return usrSignatureInfo;
    }

    //获取Ukey证书
    function GetSignCert(key){
        var cert = GolEasyCA.GetSignCert(key);
        return cert;
    }

    //获取用户唯一标识UsrCertCode
    function GetUniqueID(cert,key){
        var ret = GolEasyCA.GetUniqueID(cert,key);  
		debugger;
        return ret;
    }

    //获取用户身份证号
    function GetIdentityID(key) {
        return "";
    }

    //获取证书编号CertificateNo  这里获取的是证书序列号
    function GetCertNo(key) {
		return key;
        //var result = GolEasyCA.GetSignCertSN(key);
        //return result;
    }

    //证书序列号CertificateSN
    function GetCertSN(key) {
        return key;
    }

    function GetKeySN(key) {
        return "Not Included";
    }

    //根据Ukey获取签名图base64位编码
    function GetPicBase64Data(key){
	    var result = GolEasyCA.GetKeyPic(key);
        return result;
    }

    //获取证书名称
    function GetCertCNName(key) {
        var userList0 = GolEasyCA.ESAGetCertInfoList();
        if (userList0 == "")
            return "";
        
        var userListArr = userList0.split("&&&");
        var result = "";
        
        for (var i =0; i < userListArr.length; i++) {
            var tmpkey = userListArr[i].split("||")[1];
            var tmpName = userListArr[i].split("||")[0];
            
            if (tmpkey == key) result = tmpName;
            if (result != "") break;
        }
        return result;
    }

    function getErrorMsg() {
        return "";
    }
    
    function SOF_IsLogin(key) {
        var lt = GolEasyCA.IsLogin(key);
        if(lt == 0){
            return true;
        }
        return false;
    }
    
    function iKeyExist(key) {
        var strUserList = GetUserList();
        var arrUsers = strUserList.split('&&&');
        for (var i = 0; i < arrUsers.length; i++) {
            var user = arrUsers[i];
            if (user != "") {
                if (key == user.split('||')[1]) return true;
            }
        }
        return false;
    }
    
    function LoginForm(paraObj) {
        return {retCode:"-1"};
    }
    
    return {
        OCX: GolEasyCA,
        VenderCode:Const_Vender_Code,
        SignType:Const_Sign_Type,
        GetUserList: function() {
            return GetUserList();
        },
        Login: function(strFormName, strCertID, strPin, forceCheck) {
            return Login(strFormName, strCertID, strPin, forceCheck);
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
function Login(strFormName, key, pin, forceCheck) {
    return ca_key.Login(strFormName, key, pin, forceCheck);
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