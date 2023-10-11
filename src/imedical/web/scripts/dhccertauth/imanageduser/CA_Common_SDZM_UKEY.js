// 全局对象
var ca_key = (function () {
    // 基准路径
    var baseUrl = 'http://localhost:7618/';
    var Const_Vender_Code = "SDZM";
    var Const_Sign_Type = "UKEY";
    
    var sdzm = {
        // http请求
        http_request: function (url, data) {
            var ajax = new XMLHttpRequest();
            ajax.open('post', url, false);
            // ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            if (data) {
                ajax.send(data);
            } else {
                ajax.send();
            }

            if (ajax.readyState == 4 && ajax.status == 200) {
                var dataObj = JSON.parse(ajax.responseText)
                if (dataObj.code == 0) {
                    return dataObj.data
                } else {
                    return dataObj.msg
                }
            }
        },
        // 请求api

        // 获取用户列表
        SOF_GetUserList: function() {
            return this.http_request(baseUrl + 'SOF_GetUserList', null);
        },
        // 获取用户证书base64
        SOF_ExportUserCert: function(certId) {
            return this.http_request(baseUrl + 'SOF_ExportUserCert', JSON.stringify({ certId: certId}));
        },
        // 获取证书信息
        SOF_GetCertInfo: function(cert,type) {
            var form = {
                cert: cert,
                type: type
            }
            return this.http_request(baseUrl + 'SOF_GetCertInfo', JSON.stringify(form));
        },
        // 登陆
        SOF_Login: function(certId, pwd) {
            var form = {
                certId: certId,
                passWd: pwd
            }
            return this.http_request(baseUrl + 'SOF_Login', JSON.stringify(form));
        },
        // 获取签名图片
        GetSealPic: function(certId) {
            var form = {
                certId: certId
            }
            return this.http_request(baseUrl + 'GetSealPic', JSON.stringify(form));
        },
        // 判断是否登陆
        SOF_IsLogin: function(certId) {
            var form = {
                certId: certId
            }
            return this.http_request(baseUrl + 'SOF_IsLogin', JSON.stringify(form));
        },
        // 签名
        SOF_SignData: function(inData, certId) {
            var form = {
                certId: certId,
                inData: inData
            }
            return this.http_request(baseUrl + 'SOF_SignData', JSON.stringify(form));
        }
    }
    
    // 获取用户列表
    function GetUserList() {
        return sdzm.SOF_GetUserList();
    }
    
    // 获取用户签名证书
    function GetSignCert(key) {
        var cert = sdzm.SOF_ExportUserCert(key);
        return cert;
    }
    
    // 获取用户唯一标识 这里获取包含工号的字符串
    function GetUniqueID(cert,key) {
        if (cert.indexOf('请求参数错误') == -1) {
            var res = sdzm.SOF_GetCertInfo(cert,54);
            if (res == "") {
                res = key.match(/EZCA(\S*)@/)[1];
            }
            return res;
        } else {
            return cert;
        }
    }
    
    // 获取用户申请证书时所用的身份证号 
    function GetIdentityID(key) {
		var arr = key.split("@");
		var arr2 = arr[1].split("SF");
        return arr2[1];
    }
    
    // 获取用户申请证书的姓名
    function GetCertCNName(cert) {
        if (cert.indexOf('请求参数错误') == -1) {
            return sdzm.SOF_GetCertInfo(cert,23);
        } else {
            return cert;
        }
    }
    
    // 获取证书编号 
    function GetCertNo(key) {
        var cert = GetSignCert(key)
        if(cert.indexOf('请求参数错误') == -1) {
            return sdzm.SOF_GetCertInfo(cert,2);
        } else {
            return cert;
        }
    }
    
    function GetCertSN(key) {
        return GetCertNo(key);
    }
    
    function GetKeySN(key) {
        return "";
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
    
    // 登录
    function Login(key,pwd, forceCheck) {
	    pwd = pwd || "";
        if (iKeyExist(key) && (SOF_IsLogin(key)) && (pwd == "") && (!forceCheck)) {
            return true;
        }
	    
        var res = sdzm.SOF_Login(key,pwd)
        if (res != 0) {
            return false;
        }
        return true;
    }
    
    // 获取签名图片
    function GetKeyPic(key) {
        return sdzm.GetSealPic(key);
    }
    
    // 判断是否登陆
    function IsLogin(key) {
        return sdzm.SOF_IsLogin(key);
    }
    
    // hash算法
    function HashData(inData) {
        if (inData == "") return "";
        
        var rtn = iGetData("HashData",inData);
        if ((rtn.retCode == "0")) {
            return rtn.hashData;
        } else {
            return "";
        }
    }
    
    // 签名
    function SignedData(hashData, key) {
        return sdzm.SOF_SignData(hashData, key);
    }
    
    function getUsrSignatureInfo(key) {
	    var usrSignatureInfo = new Array();
	    usrSignatureInfo["identityID"] = GetIdentityID(key);
	    var cert = GetSignCert(key);
	    usrSignatureInfo["certificate"] = cert;
	    usrSignatureInfo["certificateNo"] = GetCertNo(key);
	    usrSignatureInfo["CertificateSN"] = GetCertSN(key);
	    usrSignatureInfo["uKeyNo"] = GetKeySN(key);
	    usrSignatureInfo["signImage"] = GetKeyPic(key);
	    usrSignatureInfo["UsrCertCode"] = GetUniqueID(cert,key);
	    usrSignatureInfo["CertName"] = GetCertCNName(cert);
	    return usrSignatureInfo;
	}
    
    function getErrorMsg() {
        return "";
    }
    
    function LoginForm(paraObj) {
        return {retCode:"-1"};
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
    
    return {
    	OCX: sdzm,
    	VenderCode:Const_Vender_Code,
    	SignType:Const_Sign_Type,
    	GetRealKey: function(key) {
	    	return key;
    	},
        Login: function(strFormName, strCertID, strPin, forceCheck) {
            return Login(strCertID, strPin, forceCheck);
        },
        IsLogin: function(strKey) {
            if ('undefined' != IsLogin) {
                return IsLogin(strKey);
            }
            return false;
        },
        GetUserList: function() {
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
            return SignedData(contentHash, key);
        },
        SignedOrdData: function(contentHash, key) {
            return SignedData(contentHash, key)
        },
        SignedOrdDataS: function(contentHash, key) {
            return SignedData(contentHash, key)
        },
        getUsrSignatureInfo: function(key) {
            return getUsrSignatureInfo(key);
        },
        HashData:function(content){
	    	return HashData(content);
	    },
        GetLastError: function() {
            return getErrorMsg();
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