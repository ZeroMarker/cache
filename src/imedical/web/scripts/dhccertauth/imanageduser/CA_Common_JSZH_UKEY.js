// 全局对象
var ca_key = (function () {
    if(window.ActiveXObject || "ActiveXObject" in window) {
        try{
            OneKeyObj = document.createElement("object");
            OneKeyObj.setAttribute("width",1);
            OneKeyObj.setAttribute("height",1);
            OneKeyObj.setAttribute("id","OneKeyObj");
            OneKeyObj.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
            OneKeyObj.setAttribute("classid","clsid:44CD5091-C022-4B9B-9F47-9E4C182B4459");
            document.documentElement.appendChild(OneKeyObj);
            
            OneCertObj = document.createElement("object");
            OneCertObj.setAttribute("width",1);
            OneCertObj.setAttribute("height",1);
            OneCertObj.setAttribute("id","OneCertObj");
            OneCertObj.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
            OneCertObj.setAttribute("classid","clsid:DDF735A8-97E6-4DAC-87DC-6BDBB0A5742F");
            document.documentElement.appendChild(OneCertObj);
            var colxCert = OneCertObj.CreateCertificateCollectionXInstance();
        } catch(e) {
            alert("请检查江苏智慧CA驱动是否正确安装："+e.message);
        }
    } else {
        // XMLHttpRequest基准路径
        var baseUrl = "http://localhost:9630/onecertx?";
    }
    
    //获取图片路径
    var imageUrl = "";
    function ajaxDATA() {
		var data = {
			OutputType: arguments[0],
			Class: arguments[1],
			Method: arguments[2]
		};

		for (var i = 3; i < arguments.length; i++) {
			data['p' + (i - 2)] = arguments[i];
		}

		return data;
	}

	var data = ajaxDATA('String', 'CA.ConfigService', 'GetServiceCfgByCode', "JSZH", "UKEY");
	jQuery.ajax({
		type: 'POST',
		dataType: 'text',
		url: '../CA.Ajax.Common.cls',
		async: true,
		cache: false,
        global:false,
		data: data,
		success: function (ret) {
			if (ret != ""){
				var arr = $.parseJSON(ret);
                imageUrl = arr["IMLocation"];
			}else {
				$.messager.alert("提示","请配置签名服务CA.ConfigService 厂商代码[JSZH] 签名类型[UKEY]");
			}
		},
		error: function (ret) {
			$.messager.alert("提示","CA.ConfigService.GetServiceCfgByCode Error:" + ret);
		}
	}); 
    
    //var imageUrl = "http://192.168.120.44:8080/simp";
    var Const_Vender_Code = "JSZH";
    var Const_Sign_Type = "UKEY";
    
    var SmartCAGoogle = {
        // http请求
        http_request: function (data) {
            var result;

            var ajax = new XMLHttpRequest();
            ajax.open("post", baseUrl, false);
            // ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

            /*ajax.onload = function () {
                if (this.status == 200) {
                    result = JSON.parse(this.responseText);
                }
            };*/

            if (data) {
                ajax.send(data);
            } else {
                ajax.send();
            }

            //return result;
            if (ajax.readyState == 4 && ajax.status == 200) {
                var dataObj = JSON.parse(ajax.responseText)
                return dataObj;
                /*if (dataObj.ErrorCode != 0) {
                    alert('调用CA接口异常：'+dataObj.ErrorMsg);
                    return dataObj.Result
                } else {
                    return dataObj.ErrorMsg
                }*/
            }
        },
        // 请求api
        // 获取Ukey列表: 所有key个数 --暂时不需要调用
        GetDeviceCount: function() {
            var form = {
                "method": "GetDeviceCount"
            }
            var ret = this.http_request(JSON.stringify(form));
            if (ret.ErrorCode != "0") {
                alert("获取Ukeyg个数时，调用CA接口异常："+ret.ErrorMsg+"，错误码："+ret.ErrorCode);
                return "";
            }
            
            var count = ret.Result.lDevNum;
            if (count == "0")
                return "";
            return count;
        },
        // 获取Ukey列表、所有key序列号
        getAllDeviceSN: function() {
            var form = {
                "method": "getAllDeviceSN"
            }
            var ret = this.http_request(JSON.stringify(form));
            if (ret.ErrorCode != "0") {
                alert("获取所有Ukey序列号时，调用CA接口异常："+ret.ErrorMsg+"，错误码："+ret.ErrorCode);
                return "";
            }
            
            var data = ret.Result.sDeviceSNs;
            if (data == "")
                return "";
            
            var sn = data.split(";");
            return sn;
        },
        // 通过key序列号获取证书主题
        getCertDn: function(keySN) {
            var form = {
                "method": "GetCertDn",
                "param": {
                    "sDeviceSN": keySN 
                }
            }
            var ret = this.http_request(JSON.stringify(form));
            if (ret.ErrorCode != "0") {
                alert("获取证书主题时，调用CA接口异常："+ret.ErrorMsg+"，错误码："+ret.ErrorCode);
                return "";
            }
            
            var data = ret.Result.sCertDn;
            if (data == ""){
                alert("获取证书主题为空，证书序列号为："+keySN);
                return "";
            }
            return data.split("|")[0];
        },
        // 通过key序列号|证书指纹|证书主题  获取证书信息 
        getCertInfo: function(cert, finger, subjectContains) {
            var form = {
                "method": "SOF_GetCertInfo",
                "param": {
                    "cert": cert,
                    "finger": finger,
                    "subjectContains": subjectContains,
                    "issuerContains": "",
                    "keyUsage": 32,                     //32|16;  //32签名证书，16加密证书，32|16 枚举所有,
                    "cryptoInterface": 3,               //1|2|3： //1只枚举SM2证书； 2：只枚举RSA证书；3：枚举所有证书,
                    "defaultSelect": 1,                 //0|1  ;  //1:默认选择唯一的那张证书， 0：不设置
                    "noCertErr": 1                      //0|1  ;  //1:没有证书的时候，不再弹出空的证书选择列表， 0：不设置
                }
            }
            var ret = this.http_request(JSON.stringify(form));
            if (ret.ErrorCode != "0") {
                alert("获取证书信息时，调用CA接口异常："+ret.ErrorMsg+"，错误码："+ret.ErrorCode);
                return "";
            }
            
            var data = ret.Result;
            if (data == "") {
                alert("获取证书信息为空，证书指纹为："+finger+"；主题为："+subjectContains);
                return "";
            }
            
            if (finger != "")             {
                if (finger != data.ThumbprintSHA1) {
                    alert("获取证书结果中的证书指纹为："+data.ThumbprintSHA1+"与实际证书指纹不一致，证书指纹为："+finger);
                    return "";
                }
            }
            
            if (subjectContains != "") {
                if (subjectContains != data.Subject) {
                    alert("获取证书结果中的证书主题为："+data.Subject+"与实际证书主题不一致，证书主题为："+subjectContains);
                    return "";
                }
            }
            return data;
        },
        // 登陆
        SOF_Login: function(keySN, pwd) {
            var form = {
                "method": "VerifyUserPin",
                "param": {
                    "sDeviceSN": keySN,
                    "sUserPin": pwd
                }
            }
            var ret = this.http_request(JSON.stringify(form));
            if (ret.ErrorCode != "0") {
                alert("验证密码错误："+ret.ErrorMsg+"，错误码："+ret.ErrorCode);
                return false;
            }
            
            var retStatus = ret.Status;
            if (retStatus != "1"){
                alert("验证密码失败");
                return false;
            }
            return true;
        },
        // 获取签名图片
        GetSealPic: function(finger) {
            var form = {
                "method": "SOF_GetStampFromSIMP",
                "param": {
                    "url": imageUrl,                        
                    "cert": "",
                    "finger": finger,
                    "cryptoInterface": 3,                     //1|2|3;  //1：只枚举SM2证书； 2：只枚举RSA证书；3：枚举所有证书
                    "defaultSelect": 1,                       //0|1;    //0：代表弹出证书选择框，1：代表，当仅有一张证书的时候，默认选择第一张证书
                    "noCertErr": 1                            //0|1;    //1：则没有证书的时候，不再弹出空的证书选择框，而是返回错误码
                }
            };
            
            var ret = this.http_request(JSON.stringify(form));
            if (ret.ErrorCode != "0") {
                alert("获取签名图片时，调用CA接口异常："+ret.ErrorMsg+"，错误码："+ret.ErrorCode);
                return "";
            }
            
            var data = ret.Result;
            if (data == "") {
                alert("获取签名图片为空，证书指纹为："+finger);
                return "";
            }

            if (data.finger != finger) {
                alert("获取签名图片结果中的证书指纹为："+data.finger+"与实际签名证书指纹不一致，证书指纹为："+finger);
                return "";
            }
            return data.base64Image;
        },
        // 判断是否登陆
        SOF_IsLogin: function(finger) {
            var form = {
                "method": "SOF_IsPINCache",
                "param": {
                    "cert": "",
                    "finger": finger
                }
            }
            var ret = this.http_request(JSON.stringify(form));
            if (ret.ErrorCode != "0") {
                alert("验证pin码是否缓存错误："+ret.ErrorMsg+"，错误码："+ret.ErrorCode);
                return false;
            }
            
            var retStatus = ret.Status;
            if (retStatus != "1"){
                alert("验证密码是否缓存失败");
                return false;
            }
            
            var isCachePin = ret.Result.isCachePin;
            return isCachePin == 1;   //1：缓存；0：未缓存
        },
        // 签名
        SOF_SignData: function(inData, finger) {
            var form = {
                "method": "SOF_Pkcs7Silent",
                "param": {
                    "data": inData,
                    "cert": "",                                    //证书，传空，通过证书指纹进行选择证书
                    "finger": finger,
                    "alg": "",                                     //签名算法，默认为空；（RSA证书默认是SHA1，SM2证书固定SM3），如设置仅对RSA证书有效，用与解决部分CA证书仅支持sha256签名算法。需要key支持相应的签名算法
                    "pwd": "",
                    "detach": 0,                                   //0|1;    //0: 带原文，1: 不带原文
                    "cryptoInterface": 3                           //1|2|3;  //1：只枚举SM2证书； 2：只枚举RSA证书；3：枚举所有证书 
                }
            };
            
            var ret = this.http_request(JSON.stringify(form));
            if (ret.ErrorCode != "0") {
                alert("获取签名结果时，调用CA接口异常："+ret.ErrorMsg+"，错误码："+ret.ErrorCode);
                return "";
            }
            
            var data = ret.Result;
            if (data == "") {
                alert("获取签名结果为空，证书指纹为："+finger);
                return "";
            }

            if (data.finger != finger) {
                alert("获取签名结果中的证书指纹为："+data.finger+"与实际签名证书指纹不一致，证书指纹为："+finger);
                return "";
            }
            return data.signData;
        }
    };
    
    var SmartCAIE = {
        //返回错误的应答
        retError: function (errCode, errString) {
            var resultJson = {
                ErrorCode: errCode,
                ErrorMsg: errString,
                Result: 0,
                Status: 0
            };
            return resultJson;
        },

        //返回成功的应答
        retSuccess: function (result) {
            var resultJson = {
                ErrorCode: 0,
                ErrorMsg: "",
                Result: result,
                Status: 1
            };
            return resultJson;
        },
        // 获取Ukey列表、所有key序列号
        getAllDeviceSN: function() {
            var ret0 = OneKeyObj.GetAllDeviceSN();
            if (ret0 == "") {
                var ret = this.retError(OneKeyObj.GetLastError(), OneKeyObj.errorstring);
            }
            else {
                var result = {
                    sDeviceSNs: ret0
                };
                var ret = this.retSuccess(result);
            }
            
            if (ret.ErrorCode != "0") {
                alert("获取所有Ukey序列号时，调用CA接口异常："+ret.ErrorMsg+"，错误码："+ret.ErrorCode);
                return "";
            }
            
            var data = ret.Result.sDeviceSNs;
            if (data == "")
                return "";
            
            var sn = data.split(";");
            return sn;
        },
        // 通过key序列号获取证书主题
        getCertDn: function(keySN) {
            var ret0 = OneKeyObj.GetCertDn(keySN);
            if (ret0 == "") {
                var ret = this.retError(OneKeyObj.GetLastError(), OneKeyObj.errorstring);
            } else {
                var result = {
                    sCertDn: ret0
                };
                var ret = this.retSuccess(result);
            }
        
            if (ret.ErrorCode != "0") {
                alert("获取证书主题时，调用CA接口异常："+ret.ErrorMsg+"，错误码："+ret.ErrorCode);
                return "";
            }
            
            var data = ret.Result.sCertDn;
            if (data == ""){
                alert("获取证书主题为空，证书序列号为："+keySN);
                return "";
            }

            return data.split("|")[0];
        },
        // 通过key序列号|证书指纹|证书主题  获取证书信息 
        getCertInfo: function(cert, finger, subjectContains) {
            //证书对象
            var certx = "";

            if (!colxCert) {
                alert("请执行“智慧CA证书助手”的环境检测功能，然后刷新网页");
                return "";
            }

            if (finger && finger != "") {
                //根据证书指纹创建证书实例
                certx = colxCert.Find(finger);
            } else {
                //设置证书筛选规则
                colxCert.CF_KeyUsage = 32;       //32|16;  //32签名证书，16加密证书，32|16 枚举所有,
                colxCert.CryptoInterface = 3;    //1|2|3： //1只枚举SM2证书； 2：只枚举RSA证书；3：枚举所有证书,
                colxCert.CF_Subject_Contains = subjectContains;
                colxCert.CF_Issuer_Contains = "";
                //加载证书
                var certCount = colxCert.Load();
                //没有证书的情况下，根据参数是否报错
                if (0 == certCount) {
                    alert("浏览器中没有证书");
                    return "";
                }
                //默认选择唯一证书
                certx = colxCert.GetAt(0);
            }
            
            if (!certx) {
                alert("获取证书主题时，调用CA接口异常："+colxCert.ErrorString+"，错误码："+colxCert.LastError);
                return "";
            }
            
            if (finger != "") {
                if (finger != certx.ThumbprintSHA1) {
                    alert("获取证书结果中的证书指纹为："+certx.ThumbprintSHA1+"与实际证书指纹不一致，证书指纹为："+finger);
                    return "";
                }
            }
            
            if (subjectContains != "") {
                if (subjectContains != certx.Subject) {
                    alert("获取证书结果中的证书主题为："+certx.Subject+"与实际证书主题不一致，证书主题为："+subjectContains);
                    return "";
                }
            }
            return certx;
        },
        // 登陆
        SOF_Login: function(keySN, pwd) {
            var ret0 = OneKeyObj.VerifyUserPin(keySN,pwd);
            if (ret0 != 1) {
                var ret = this.retError(OneKeyObj.GetLastError(), OneKeyObj.errorstring);
            } else {
                var ret = this.retSuccess(0);
            }
            
            if (ret.ErrorCode != "0") {
                alert("验证密码错误："+ret.ErrorMsg+"，错误码："+ret.ErrorCode);
                return false;
            }
            
            var retStatus = ret.Status;
            if (retStatus != "1"){
                alert("验证密码失败");
                return false;
            }
            return true;
        },
        // 获取签名图片
        GetSealPic: function(finger) {
            if (imageUrl == "") {
                alert("获取签名图异常：未配置有效的签章服务地址");
                return "";
            }
            
            var retCert = this.getCertInfo("",finger,"");
            if (retCert == "") {
                return "";
            }
            
            //开始
            var signData = retCert.GetStampFromSIMP(imageUrl);
            if (signData == "") {
                alert("获取签名图片时，调用CA接口异常："+retCert.ErrorString+"，错误码："+retCert.LastError);
                return "";
            }

            if (retCert.ThumbprintSHA1 != finger) {
                alert("获取签名图片结果中的证书指纹为："+retCert.ThumbprintSHA1+"与实际签名证书指纹不一致，证书指纹为："+finger);
                return "";
            }
            return signData;
        },
        // 判断是否登陆 暂无
        SOF_IsLogin: function(finger) {
            var retCert = this.getCertInfo("",finger,"");
            if (retCert == "") {
                return false;
            }

            var verifyPinResult = retCert.IsCachePIN();
            if (verifyPinResult != 0 && verifyPinResult != 1) {
                alert("验证pin码是否缓存错误："+ retCert.ErrorString+","+verifyPinResult+"，错误码："+retCert.LastError);
                return false;
            } 
            
            return verifyPinResult == 1;
        },
        // 签名
        SOF_SignData: function(inData, finger) {
            //进行PKCS7签名
            var retCert = this.getCertInfo("",finger,"");
            if (retCert == "") {
                return "";
            }

            //PKCS7签名
            var ret = retCert.PKCS7String(inData, 0);    //0|1;    //0: 带原文，1: 不带原文
            if (ret == "") {
                alert("获取签名结果为空，调用CA接口异常："+retCert.ErrorString+"，错误码："+retCert.LastError);
                return "";
            }

            if (retCert.ThumbprintSHA1 != finger) {
                alert("获取签名结果中的证书指纹为："+retCert.ThumbprintSHA1+"与实际签名证书指纹不一致，证书指纹为："+finger);
                return "";
            }
            return ret;
        }
    };
    
    
    if(window.ActiveXObject || "ActiveXObject" in window) {
        var SmartCA = SmartCAIE;
    } else {
        var SmartCA = SmartCAGoogle;
    }

    // 获取用户列表    keySN1@@证书指纹1||用户1&&&keySN2@@证书指纹2||用户2
    // 列表的key值为CA的keySN + @@ + 证书SHA1指纹信息
    function GetUserList() {
        var result = "";
        var keysn = SmartCA.getAllDeviceSN();
        if (keysn == "") return "";
        
        for (var i =0; i < keysn.length; i++) {
            var onekey = keysn[i];
            if (onekey == "") continue;
            
            var onekeyDn = SmartCA.getCertDn(onekey);
            if (onekeyDn == "") continue;
            
            var onekeyCertInfo = SmartCA.getCertInfo("","",onekeyDn);
            if (onekeyCertInfo == "") continue;
            
            var strName = onekeyDn.replace(/\s/g,"").split(",CN=")[1].split("@")[0];
            var strContainer = onekeyCertInfo.ThumbprintSHA1;
            
            if ((strName == "")||(strContainer == "")) continue;
            
            if (result == "") {
                result = strName + "||" + onekey + "@@" + strContainer;
            } else {
                result = result + "&&&" + strName + "||" + onekey + "@@" + strContainer;
            }
        }
        return result;
    }
    
    // 获取用户签名证书
    function GetSignCert(key) {
        // 通过证书指纹获取
        var key = key.split("@@")[1];
        var ret = SmartCA.getCertInfo("",key,"");
        if (ret == "") return ret;
        return ret.Content;
    }
    
    // 获取用户唯一标识，取工号    
    function GetUniqueID(cert,key) {
        // 通过keySN获取证书主题
        var key = key.split("@@")[0];
        var ret = SmartCA.getCertDn(key);
        if (ret == "") return ret;
        // 截取主题数据获取工号
        return ret.replace(/\s/g,"").split(",O=")[1].split(",OU=")[0];
    }
    
    // 获取身份证号   取空
    function GetIdentityID(key) {
        return "";
    }
    
    // 获取用户名
    function GetCertCNName(key) {
        // 通过keySN获取证书主题
        var key = key.split("@@")[0]
        var ret = SmartCA.getCertDn(key);
        if (ret == "") return ret;
        // 截取主题数据获取用户姓名
        return ret.replace(/\s/g,"").split(",CN=")[1].split("@")[0];
    }
    
    // 获取证书编号   取的证书指纹
    function GetCertNo(key) {
        return key.split("@@")[1];
    }
    
    // 获取证书序列号 
    function GetCertSN(key) {
        // 通过证书指纹获取
        var key = key.split("@@")[1];
        var ret = SmartCA.getCertInfo("",key,"");
        if (ret == "") return ret;
        return ret.SerialNumber;
    }
    
    // 获取硬件编号   取的KeySN
    function GetKeySN(key) {
        return key.split("@@")[0];
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
        // 验证密码时通过keySN验证
        var key = key.split("@@")[0];
        var res = SmartCA.SOF_Login(key,pwd)
        return res;
    }
    
    // 获取签名图片
    function GetKeyPic(key) {
        // 通过证书指纹获取
        var key = key.split("@@")[1];
        return SmartCA.GetSealPic(key);
    }
    
    // 判断是否登陆
    function IsLogin(key) {
        // 通过证书指纹判断
        var key = key.split("@@")[1];
        return SmartCA.SOF_IsLogin(key);
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
        // 通过证书指纹签名
        var key = key.split("@@")[1];
        return SmartCA.SOF_SignData(hashData, key);
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
        OCX: SmartCA,
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