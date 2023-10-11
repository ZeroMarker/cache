// 全局对象
var ca_key = (function () {
    if(window.ActiveXObject || "ActiveXObject" in window) {
        try{
            HncaCtrl = document.createElement("object");
            HncaCtrl.setAttribute("width",1);
            HncaCtrl.setAttribute("height",1);
            HncaCtrl.setAttribute("id","HncaCtrlOcx");
            HncaCtrl.setAttribute("name","HncaCtrlOcx");
            HncaCtrl.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
            HncaCtrl.setAttribute("classid","clsid:990AC2E1-4439-436A-823A-F96855361CB3");
            document.documentElement.appendChild(HncaCtrl);
        } catch(e) {
            alert("请检查河南CA证书应用环境是否正确安装："+e.message);
        }
    } else {
        // Post 基准路径
        var baseUrl = "http://127.0.0.1:9651";
    }
    
    var Const_Vender_Code = "HNCA";
    var Const_Sign_Type = "UKEY";
    
    var HncaCtrlGoogle = {
        GetParamstrByKey: function (strKey,strSoucre) {
            var strRes = "";
            if(strKey == "")
                return strRes;
            if(strSoucre == "")
                return strRes;
            var istart = 0;
            do
            {
                istart = strSoucre.indexOf(strKey, istart);
                if (istart == -1)
                {
                    break;
                }
                istart = istart + strKey.length;
                if (strSoucre.charAt(istart) == '[')
                {
                    break;
                }
            }
            while(istart != -1)
            if (istart != -1)
            {   
                //查找到了
                var iend = strSoucre.indexOf("]", istart);
                if (iend == -1)
                {
                    return strRes;
                }
                strRes = strSoucre.substring(istart+1, iend);
            }
            return strRes;
        },
        
        // http请求
        http_request: function (inPutData) {
            var result = "";
            var mesg = inPutData + '\0';
            var sendData = {"ServeltData":mesg};
            var str = JSON.stringify(sendData);     //处理中文转换问题，强制统一编码utf-8 12.6 yl
            try {	
                $.ajax({
                    type: "POST",
                    url:  baseUrl,
                    data:  str,
                    async: false,
                    dataType:"text",
                    contentType:"text/json;charset=utf-8",
                    success: function(msg)
                    {
                        result = HncaCtrlGoogle.GetParamstrByKey("FunctionRes",msg);
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        alert("XMLHttpRequest.status:" + XMLHttpRequest.status + "；XMLHttpRequest.readyState:" + XMLHttpRequest.readyState + "；textStatus:" + textStatus + "；errorThrown" + errorThrown);
                    }
                });
            }
            catch (ex) {
                alert('调用CA接口异常：'+ex);
                return result;
            }
            return result;
        },
        // 请求api
        // 获取Ukey列表、所有key序列号
        GetAllDevice: function() {
            var inPutData = "";
            inPutData += "ProcessEntity-1{FunctionType[99]TrueNext[0]FalseNext[0]}";  //获取设备列表信息
            inPutData += "ProcessCallBackName{callback_SM2_GetDevList}";
            inPutData += "ProcessNum{1}";
            var ret = this.http_request(inPutData);
            if (ret == "-1")
            {
                alert("获取证书列表失败！")
                return "";
            }
            return ret;
        },
        // 通过GetUserList中获取的证书序列号进行证书初始化后获得证书主题
        SetCertEx: function(key) {
            inPutData = "ProcessEntity-1{FunctionType[1]Param1[1]TrueNext[2]FalseNext[0]}";      //指定证书的选择方式
            inPutData += "ProcessEntity-2{FunctionType[2]Param1[SC]Param2[]Param3["+key+"]Param4[]Param5[CN=HNCA,O=HeNan Certificate Authority,L=ZhengZhou,S=HeNan,C=CN]Param6[]Param7[SM2]TrueNext[3]FalseNext[0]}";       //设置签名、加密、解密或验签名证书
            inPutData += "ProcessEntity-3{FunctionType[3]Param1[0]Param2[]TrueNext[0]FalseNext[0]}"    //GetCertInfo(3, "8", "", 0, 0); //获取证书主题
            inPutData += "ProcessCallBackName{callback_RSA_SelectCertAndGetCertDN}";
            inPutData += "ProcessNum{3}";
            var ret = this.http_request(inPutData);
            if (ret == "-1")
            {
                alert("证书初始化并获取证书主题失败！")
                return "";
            }
            return ret;
        },
        // 获取证书序列号
        GetCertSN: function(key) {
            inPutData = "ProcessEntity-1{FunctionType[1]Param1[1]TrueNext[2]FalseNext[0]}";      //指定证书的选择方式
            inPutData += "ProcessEntity-2{FunctionType[2]Param1[SC]Param2[]Param3["+key+"]Param4[]Param5[CN=HNCA,O=HeNan Certificate Authority,L=ZhengZhou,S=HeNan,C=CN]Param6[]Param7[SM2]TrueNext[3]FalseNext[0]}";       //设置签名、加密、解密或验签名证书
            inPutData += "ProcessEntity-3{FunctionType[3]Param1[2]Param2[]TrueNext[0]FalseNext[0]}"   //获取证书SN
            inPutData += "ProcessCallBackName{callback_RSA_SelectCertAndGetCertSN}";
            inPutData += "ProcessNum{3}";
            var ret = this.http_request(inPutData);
            if (ret == "-1")
            {
                alert("证书初始化并获取证书序列号失败！")
                return "";
            }
            return ret;
        },
        // 获取用户唯一标识UsrCertCode    河南新郑是工号
        GetUniqueID: function(key) {
            inPutData = "ProcessEntity-1{FunctionType[1]Param1[1]TrueNext[2]FalseNext[0]}";      //指定证书的选择方式
            inPutData += "ProcessEntity-2{FunctionType[2]Param1[SC]Param2[]Param3["+key+"]Param4[]Param5[CN=HNCA,O=HeNan Certificate Authority,L=ZhengZhou,S=HeNan,C=CN]Param6[]Param7[SM2]TrueNext[3]FalseNext[0]}";       //设置签名、加密、解密或验签名证书
            inPutData += "ProcessEntity-3{FunctionType[3]Param1[7]Param2[1.2.86.11.7.11]TrueNext[0]FalseNext[0]}"   //获取用户唯一标识
            inPutData += "ProcessCallBackName{callback_RSA_SelectCertAndGetCertOID}";
            inPutData += "ProcessNum{3}";
            var ret = this.http_request(inPutData);
            if (ret == "-1")
            {
                alert("证书初始化并获取用户唯一标识失败！")
                return "";
            }
            return ret;
        },
        // 证书base64编码
        GetSignCert: function(key) {
            inPutData = "ProcessEntity-1{FunctionType[1]Param1[1]TrueNext[2]FalseNext[0]}";      //指定证书的选择方式
            inPutData += "ProcessEntity-2{FunctionType[2]Param1[SC]Param2[]Param3["+key+"]Param4[]Param5[CN=HNCA,O=HeNan Certificate Authority,L=ZhengZhou,S=HeNan,C=CN]Param6[]Param7[SM2]TrueNext[3]FalseNext[0]}";       //设置签名、加密、解密或验签名证书
            inPutData += "ProcessEntity-3{FunctionType[3]Param1[8]Param2[]TrueNext[0]FalseNext[0]}"   //获取证书编码
            inPutData += "ProcessCallBackName{callback_RSA_SelectCertAndGetCert}";
            inPutData += "ProcessNum{3}";
            var ret = this.http_request(inPutData);
            if (ret == "-1")
            {
                alert("证书初始化并获取签名证书失败！")
                return "";
            }
            return ret;
        },
        // 登陆
        SOF_Login: function(key, pwd) {
            var strDN = this.SetCertEx(key);
            if (strDN == "") return;
            
            inPutData = "ProcessEntity-1{FunctionType[92]Param1["+pwd+"]Param2["+strDN+"]TrueNext[2]FalseNext[0]}";      //校验pin码
            inPutData += "ProcessCallBackName{callback_HNCACheckUkey}";
            inPutData += "ProcessNum{1}";
            var ret = this.http_request(inPutData);
            if (ret != "0") {
                alert("密码校验失败:");
                return false;
            }
            return true;
        },
        // 获取签名图片
        GetSealPic: function(key) {
            inPutData = "ProcessEntity-1{FunctionType[98]Param1["+key+"]TrueNext[0]FalseNext[0]}";      //校验pin码
            inPutData += "ProcessCallBackName{callback_SM2_GetGMSealPicBase64FromDev}";
            inPutData += "ProcessNum{1}";
            var ret = this.http_request(inPutData);
            if (ret != "-1" && ret !="") 
            {
                return $.parseJSON(ret).picdata;
            }
            else
            {
                alert("获取签名图失败！")
                return "";
            }
        },
        // 判断是否登陆
        SOF_IsLogin: function(key) {
            return false;
        },
        // 签名
        SOF_SignData: function(inData, key) {
            var strDN = this.SetCertEx(key);
            if (strDN == "") return;
            
            inPutData = "ProcessEntity-1{FunctionType[96]Param1["+strDN+"]Param2["+inData+"]TrueNext[0]FalseNext[0]}";      //证书签名
            inPutData += "ProcessCallBackName{callback_GMSM2Signhash}";
            inPutData += "ProcessNum{1}";
            var ret = this.http_request(inPutData);
            if (ret == "-1")
            {
                alert("获取签名数据失败！")
                return "";
            }
            return ret;
        }
    };
    
    var HncaCtrlIE = {
        // 获取Ukey列表、所有key序列号
        GetAllDevice: function() {
            var ret = HncaCtrlOcx.GetUselist();
            return ret;
        },
        // 通过key序列号获取证书主题
        SetCertEx: function(key) {
            HncaCtrlOcx.SetCertChooseType(1);
            HncaCtrlOcx.SetCertEx("SC","",key,"","CN=HNCA,O=HeNan Certificate Authority,L=ZhengZhou,S=HeNan,C=CN","","SM2");
            return HncaCtrlOcx.GetCertInfo(0, "");
        },
        // 获取证书序列号
        GetCertSN: function(key) {
            HncaCtrlOcx.SetCertChooseType(1);
            HncaCtrlOcx.SetCertEx("SC","",key,"","CN=HNCA,O=HeNan Certificate Authority,L=ZhengZhou,S=HeNan,C=CN","","SM2");
            return HncaCtrlOcx.GetCertInfo(2, "");
        },
        // 获取用户唯一标识UsrCertCode    河南新郑是工号
        GetUniqueID: function(key) {
            HncaCtrlOcx.SetCertChooseType(1);
            HncaCtrlOcx.SetCertEx("SC","",key,"","CN=HNCA,O=HeNan Certificate Authority,L=ZhengZhou,S=HeNan,C=CN","","SM2");
            return HncaCtrlOcx.GetCertInfo(2, "1.2.86.11.7.11");
        },
        // 证书base64编码
        GetSignCert: function(key) {
            HncaCtrlOcx.SetCertChooseType(1);
            HncaCtrlOcx.SetCertEx("SC","",key,"","CN=HNCA,O=HeNan Certificate Authority,L=ZhengZhou,S=HeNan,C=CN","","SM2");
            return HncaCtrlOcx.GetCertInfo(8, "");
        },
        // 登陆
        SOF_Login: function(key, pwd) {
            var strDN = SetCertEx(key);
            var Ret = HncaCtrlOcx.CheckUkey(pwd,strDN); //校验密码
            if (Ret != "0") {
                alert("密码校验失败:"+Ret);
                return false;
            }
            return true;
        },
        // 获取签名图片
        GetSealPic: function(key) {
            return HncaCtrlOcx.HNCA_ReadSealPicBase64FromKeyByCertSN(key);
        },
        // 判断是否登陆 暂无
        SOF_IsLogin: function(key) {
            return false;
        },
        // 签名
        SOF_SignData: function(inData, key) {
            var strDN = SetCertEx(key);
            return HncaCtrlOcx.GMSM2Sign(strDN,inData);
        }
    };
    
    
    if(window.ActiveXObject || "ActiveXObject" in window) {
        var HncaCtrl = HncaCtrlIE;
    } else {
        var HncaCtrl = HncaCtrlGoogle;
    }

    // 获取用户列表    keySN1@@证书指纹1||用户1&&&keySN2@@证书指纹2||用户2
    // 列表的key值为CA的keySN + @@ + 证书SHA1指纹信息
    function GetUserList() {
        var keylist = "";
        var userList = "";
        var keylist = HncaCtrl.GetAllDevice();
        
        if (keylist == "") {
            alert("获取设备列表失败，请检查是否插入设备！");
            return ;    
        }
        
        keylist = keylist.replace(/&&&/g, '&');
        keylist = keylist.replace(/&&/g, '&');
        
        var tmpUkeyName = "";
        var tmpUkeySN = "";
        var arrkeylist = keylist.split("||");
        for (var i=0;i<arrkeylist.length;i++)
        {
            var arrUkeyInfo = arrkeylist[i].split("&");
            if (arrUkeyInfo[0] != ""){
                //tmpUkeyName = arrUkeyInfo[0].substring(arrUkeyInfo[0].indexOf("//")+2,arrUkeyInfo[0].lastIndexOf("/"));
                tmpUkeyName = arrUkeyInfo[3].substring(3,arrUkeyInfo[3].indexOf(","));
                tmpUkeySN = arrUkeyInfo[0].substring(arrUkeyInfo[0].indexOf("=")+1);
            }
            if ((arrUkeyInfo[1] != "")&&(arrUkeyInfo[2] != ""))
            {
                if ((arrUkeyInfo[1].substring(arrUkeyInfo[1].indexOf("=")) == "=Sign")&&(arrUkeyInfo[2].substring(arrUkeyInfo[2].indexOf("=")) == "=SM2"))
                {
                    if (userList == "") {
                        userList = tmpUkeyName+'||'+ tmpUkeySN ;
                    }else {
                        userList = userList + '&&&' + tmpUkeyName +'||'+ tmpUkeySN ;
                    }
                }
            }
        }
        return userList;
    }
    
    // 获取用户签名证书
    function GetSignCert(key) {
        var ret = HncaCtrl.GetSignCert(key);
		return ret;
    }
    
    // 获取用户唯一标识，取工号    
    function GetUniqueID(cert,key) {
        var ret = HncaCtrl.GetUniqueID(key);
        return ret;
    }
    
    // 获取身份证号   取空
    function GetIdentityID(key) {
        return "";
    }
    
    // 获取用户名
    function GetCertCNName(key) {
        var ret = HncaCtrl.SetCertEx(key);
        var certCNName = ret.substring(3,ret.indexOf(","));
        return certCNName;
    }
    
    // 获取证书编号
    function GetCertNo(key) {
        return HncaCtrl.GetCertSN(key);
    }
    
    // 获取证书序列号 
    function GetCertSN(key) {
        return key;
    }
    
    // 获取硬件编号
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
    function Login(key,pwd, forceCheck) {
        pwd = pwd || "";
        if ((IsLogin(key)) && (pwd == "") && (!forceCheck)) {
            return true;
        }
        
        var res = HncaCtrl.SOF_Login(key,pwd)
        return res;
    }
    
    // 获取签名图片
    function GetKeyPic(key) {
        return HncaCtrl.GetSealPic(key);
    }
    
    // 判断是否登陆
    function IsLogin(key) {
        return HncaCtrl.SOF_IsLogin(key);
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
    
    // 数据签名
    function SignedData(hashData, key) {
        if (hashData == "") {
            alert("待签数据为空");
            return "";
        }
        return HncaCtrl.SOF_SignData(hashData, key);
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
        usrSignatureInfo["CertName"] = GetCertCNName(key);
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
        OCX: HncaCtrl,
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