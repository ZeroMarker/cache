// 全局对象
var ca_key = (function () {
    if(window.ActiveXObject || "ActiveXObject" in window) {
        try{
            SDCACAClient = document.createElement("object");
            SDCACAClient.setAttribute("width",1);
            SDCACAClient.setAttribute("height",1);
            SDCACAClient.setAttribute("id","CASecurityClient");
            SDCACAClient.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
            SDCACAClient.setAttribute("classid","clsid:F8119DB1-73CB-49F7-8559-2B5EDD869D2A");
            document.documentElement.appendChild(SDCACAClient);
        } catch(e) {
            alert("请检查山东CA驱动是否正确安装："+e.message);
        }
    } else {
        // XMLHttpRequest基准路径
        var baseUrl = "http://127.0.0.1:8222";
    }
    
    var Const_Vender_Code = "SDCA";
    var Const_Sign_Type = "UKEY";
    
    var SDCAGoogle = {
        // http请求
        http_request: function (data) {
            var result;

            var ajax = new XMLHttpRequest();
            ajax.open("post", baseUrl, false);
            ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

            /*ajax.onload = function () {
                if (this.status == 200) {
                    result = JSON.parse(this.responseText);
                }
            };*/            
            
            try {
                if (data) {
                    ajax.send(data);
                } else {
                    ajax.send();
                }

                if (ajax.readyState == 4 && ajax.status == 200) {
                    var dataObj = ajax.responseText;
                    return dataObj;
                } else {
                    alert("调用CA接口状态异常，状态码："+ ajax.status)
                    return "";
                }
            }
            catch (e)
			{
                alert("调用CA接口异常："+e)
				return "";
			}
        },
        // 请求api
        // 设置证书筛选规则
        SOF_InitialVar: function(sectionName, keyName, ProfileString) {
            var json = '{"Function":"SOF_InitialVar",   "SectionName":"' + sectionName+ '", "KeyName":"' + keyName + '", "ProfileString":"' + ProfileString + '"}';
			return this.http_request(json);
        },
        // 获取Ukey列表、所有key序列号
        SOF_GetUserList: function() {
            var json = '{"Function":"SOF_GetUserList"}';		
			return this.http_request(json);
        },
        // 对待签数据做Hash数据
        SOF_HashData: function(inData) {
            var json = '{"Function":"SOF_HashData", "InData":"' + inData + '"}';	
			return this.http_request(json);
        },
        // 签名
        SOF_SignData: function(certID, inData) {	
            var json = '{"Function":"SOF_SignData",   "CertID":"' + certID+ '", "InData":"' + inData + '"}';
			return this.http_request(json);
        },
        //导出证书
        SOF_ExportUserCert: function(certID) {	
            var json = '{"Function":"SOF_ExportUserCert",  "CertID":"' + certID+ '"}';
			return this.http_request(json);
        },
        //根据拓展项获取证书信息
        SOF_GetCertInfo: function(cert, type) {	
            var json = '{"Function":"SOF_GetCertInfo", "Cert":"' + cert + '", "Type":' + type + '}';
			return this.http_request(json);
        },
        SOF_ShowSealData: function(certID, sealIndex, flagRGB) {	
            var json = '{"Function":"SOF_ShowSealData",  "CertID":"' + certID+ '" ,"SealIndex":' + sealIndex+ ',"RGBFlag":' + flagRGB+ '}';
			return this.http_request(json);
        },
        SOF_VerifySignedData: function(cert, inData, signedData) {
			var json = '{"Function":"SOF_VerifySignedData", "Cert":"' + cert + '", "InData":"' + inData + '", "SignValue":"' + signedData + '"}';
			return this.http_request(json);
		},
        SOF_Login: function(certID, pwd) {
            var json = '{"Function":"SOF_Login",   "CertID":"' + certID+ '", "PassWd":"' + pwd + '"}';
			return this.http_request(json);
        },
        SOF_GetLastError: function() {
			var json = '{"Function":"SOF_GetLastError"}';
			return this.http_request(json);
		},
        // 判断是否登陆
        SOF_IsLogin: function(finger) {
            return false;
        }
    };
    
    if(window.ActiveXObject || "ActiveXObject" in window) {
        var SDCAOcx = CASecurityClient;
    } else {
        var SDCAOcx = SDCAGoogle;
    }

    // 获取用户列表    keySN1||用户1&&&keySN2||用户2..
    // 列表的key值为CA的证书序列号
    function GetUserList() {
        //验证一次口令后不再输入口令
        SDCAOcx.SOF_InitialVar("CERTID", "KeyLoginPolicy", "0");
        //不弹出CA选择证书页面
        SDCAOcx.SOF_InitialVar("CERTID", "CertSelectPolicy", "0");
        //按照证书序列号设置
        SDCAOcx.SOF_InitialVar("CERTID", "CertInfoID", "SGD_GET_CERT_SERIAL"); 
        var result = SDCAOcx.SOF_GetUserList();

        //UserList分割处理
        var key = result.split('&&&');
        var Name = new Array();
        var ListArray = new Array();
        for (var i = 0; i < key.length; i++) {
            var ListSplit = key[i];
            if (ListSplit != "") {
                var cert = SDCAOcx.SOF_ExportUserCert(ListSplit);
				if ((cert == "null")||(cert == "")) continue
                Name[i] = SDCAOcx.SOF_GetCertInfo(cert, 23);
                ListArray[i] = Name[i] + "||" + key[i];
            }
        }
        //格式合并，格式 Name||key&&& Name||key
        var userList = ListArray.join("&&&");
        return userList;
    }
    
    // 获取用户签名证书
    function GetSignCert(key) {
        return SDCAOcx.SOF_ExportUserCert(key);
    }
    
    // 获取用户唯一标识   
    function GetUniqueID(cert,key) {
        return SDCAOcx.SOF_GetCertInfo(cert, 53);
    }
    
    // 获取身份证号   将带OU=I(身份证号码)的字符串查找出来
    function GetIdentityID(key,cert) {
        cert = cert || "";
        if (cert == "") cert = GetSignCert(key);
        var ret = SDCAOcx.SOF_GetCertInfo(cert, 33)
        var number = /OU=I(\d{18}|\d{17}[x|X])/g;
        if (number.test(ret)) {
            var tmp = ret.match(number)[0];
        } else {
            return "";
        }
        var result = tmp.split("OU=I");
        return result[1];
    }
    
    // 获取用户名
    function GetCertCNName(key) {
        var cert = GetSignCert(key);
        return SDCAOcx.SOF_GetCertInfo(cert, 23);
    }
    
    // 获取证书编号
    function GetCertNo(key) {
        return key;
    }
    
    // 获取证书序列号 
    function GetCertSN(key) {
        return key;
    }
    
    // 获取硬件编号   空
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
    
    // 登录  验证密码
    function Login(form, key, pwd, forceCheck) {
        pwd = pwd || "";
        if ((IsLogin(key)) && (pwd == "") && (!forceCheck)) {
            return true;
        }
        
        if (key == null || key == "") {
            alert("获取用户信息失败");
            return false;
        }
        if (pwd == null || pwd == "") {
            alert("请输入证书密码");
            return false;
        }
        if (pwd.length < 6 || pwd.length > 16) {
            alert("密码长度应该在4-16位之间");
            return false;
        }
        
        //对服务器传回的数据进行验证
        /*var flag = SDCAOcx.SOF_VerifySignedData(strServerCert, strServerRan, strServerSignedData);
        if (!ret) {
            alert("验证服务器端信息失败!");
            return false;
        }*/
        
        //对USBKEY证书的登陆进行验证
        var count = SDCAOcx.SOF_Login(key, pwd); //只适用于USBKEY证书，软证书无需校验，测试使用软证书可屏蔽此处代码
        if (count == 0)
            return true;
        else if (count == -1) {
            alert("尝试次数过多,USBKey已锁死,请与管理员联系");
            return false;
        } else if (count == -2) {
            switch (SDCAOcx.SOF_GetLastError()) {
                case 0x0B000201:
                    alert("登录失败，参数输入有误，请确认输入口令是否正确");
                    break;
                case 0x0B000200:
                    alert("登录失败，参数输入有误，请确认输入口令的有效性");
                    break;
                case 0x0B000310:
                    alert("登录失败，未找到指定证书，请确认USBKey是否插入或重新插拔USBKey后重试");
                    break;
                case 0x0B000002:
                    alert("登录失败，未找到指定证书容器，请确认USBKey是否插入或重新插拔USBKey后重试");
                    break;
                case 0x0B000420:
                    alert("登录失败");
                    break;
                default:
                    alert("登录失败，未知错误，错误码为:0X" + SDCAOcx.SOF_GetLastError().toString(16));
                    break;
            }
            return false;
        } else {
            alert("验证口令失败，您还能尝试:" + count + "次");
            return false;
        }
    }
    
    // 获取签名图片
    function GetKeyPic(key) {
        return SDCAOcx.SOF_ShowSealData(key, 0, 0); //医师姓名图片，base64格式
    }
    
    // 判断是否登陆
    function IsLogin(key) {
        return false;  //SDCAOcx.SOF_IsLogin(key);
    }
    
    // hash算法
    function HashData(inData) {
        return SDCAOcx.SOF_HashData(inData);
    }
    
    // 数据签名
    function SignedData(hashData, key) {
        if (hashData == "") {
            alert("待签数据为空");
            return "";
        }
        return SDCAOcx.SOF_SignData(key, hashData);
    }
    
    function getUsrSignatureInfo(key) {
        var usrSignatureInfo = new Array();
        var cert = GetSignCert(key);
        usrSignatureInfo["identityID"] = GetIdentityID(key,cert);
        usrSignatureInfo["certificate"] = cert;
        usrSignatureInfo["certificateNo"] = GetCertNo(key);
        usrSignatureInfo["CertificateSN"] = GetCertSN(key);
        usrSignatureInfo["uKeyNo"] = GetKeySN(key);
        usrSignatureInfo["signImage"] = GetKeyPic(key);
        usrSignatureInfo["UsrCertCode"] = GetUniqueID(cert,key);
        usrSignatureInfo["CertName"] = GetCertCNName(key);
        return usrSignatureInfo;
    }
    
    function getErrorMsg() {
        return "";
    }
    
    function LoginForm(paraObj) {
        return {retCode:"-1"};
    }
    
    return {
        OCX: SDCAOcx,
        VenderCode:Const_Vender_Code,
        SignType:Const_Sign_Type,
        GetRealKey: function(key) {
            return key;
        },
        Login: function(strFormName, strCertID, strPin, forceCheck) {
            return Login(strFormName, strCertID, strPin, forceCheck);
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
        HashData:function(content) {
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