var ca_key = (function() {
    
    _businessOrgCode = "";
	_businessSystemCode = "";
	_businessTypeCode = "007";
	
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

	var data = ajaxDATA('String', 'CA.ConfigService', 'GetServiceCfgByCode', "NETCAV3", "UKEY");
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
                _businessOrgCode = arr["OrganizationCode"];
				_businessSystemCode = arr["ProjectID"];
			}else {
				$.messager.alert("提示","请配置签名服务CA.ConfigService 厂商代码[NETCAV3] 签名类型[UKEY]");
			}
		},
		error: function (ret) {
			$.messager.alert("提示","CA.ConfigService.GetServiceCfgByCode Error:" + ret);
		}
	}); 

    
    var Const_Vender_Code = "NETCAV3";
    var Const_Sign_Type = "UKEY";
    
    _CurEncryptedToken = "";

	function SZWJ_GetUserList() {
        var respResult = [];
        jQuery.support.cors = true;
        jQuery.ajax({
            url: "http://localhost:55668/CaApi/SZWJ_GetUserList",
            type: "GET",
            dataType: "JSON",
            success: function(response) {
                respResult = response;
            },
            error: function(jqXHR, textStatus, errorThrown) {
                alert(errorThrown);
            },
            async: false
        });
        return respResult;
	}

	function SZWJ_Login(sn, pwd) {
        var respResult = [];
        var reqBody = {
            businessOrgCode: _businessOrgCode,
            businessSystemCode: _businessSystemCode,
            sn: sn,
            pwd: pwd
        }
        jQuery.support.cors = true;
        jQuery.ajax({
            url: "http://localhost:55668/CaApi/SZWJ_Login",
            type: "POST",
            data: reqBody,
            dataType: "JSON",
            success: function(response) {
              respResult = response;
            },
            error: function(jqXHR, textStatus, errorThrown) {
              alert(errorThrown);
            },
            async: false
        });
        return respResult;
	}

	function SZWJ_HashData(data) {
        var respResult = [];
        /*
        var reqBody = {
        inData: data
        }
        */
        var reqBody = data;
        jQuery.support.cors = true;
        jQuery.ajax({
            url: "http://localhost:55668/CaApi/SZWJ_HashData",
            type: "POST",
            data: reqBody,
            dataType: "JSON",
            success: function(response) {
              respResult = response;
            },
            error: function(jqXHR, textStatus, errorThrown) {
              alert(errorThrown);
            },
            async: false
        });
        return respResult;
	}

	function SZWJ_SignData(encryptedToken, data, detach, withTsa) {
        var respResult = [];
        var reqBody = {
            businessOrgCode: _businessOrgCode,
            businessSystemCode: _businessSystemCode,
            businessTypeCode: _businessTypeCode,
            encryptedToken: encryptedToken,
            data: data,
            detach: detach,
            withTsa: withTsa
        }
        jQuery.support.cors = true;
        jQuery.ajax({
            url: "http://localhost:55668/CaApi/SZWJ_SignData",
            type: "POST",
            data: reqBody,
            dataType: "JSON",
            success: function(response) {
              respResult = response;
            },
            error: function(jqXHR, textStatus, errorThrown) {
              alert(errorThrown);
            },
            async: false
        });
        return respResult;
	}

	function SZWJ_SignDataBySn(sn, data, detach, withTsa) {
        var respResult = [];
        var reqBody = {
            businessOrgCode: _businessOrgCode,
            businessSystemCode: _businessSystemCode,
            businessTypeCode: _businessTypeCode,
            sn: sn,
            data: data,
            detach: detach,
            withTsa: withTsa
        }
        jQuery.support.cors = true;
        jQuery.ajax({
            url: "http://localhost:55668/CaApi/SZWJ_SignData",
            type: "POST",
            data: reqBody,
            dataType: "JSON",
            success: function(response) {
              respResult = response;
            },
            error: function(jqXHR, textStatus, errorThrown) {
              alert(errorThrown);
            },
            async: false
        });
        return respResult;
	}

	function SZWJ_SignDataS(sn, data, detach, withTsa) {
        var respResult = [];
        var reqBody = {
            businessOrgCode: _businessOrgCode,
            businessSystemCode: _businessSystemCode,
            businessTypeCode: _businessTypeCode,
            sn: sn,
            dataList: data,
            detach: detach,
            withTsa: withTsa
        }
        jQuery.support.cors = true;
        $.ajax({
            url: "http://localhost:55668/CaApi/SZWJ_SignDatas",
            type: "POST",
            data: reqBody,
            dataType: "JSON",
            success: function(response) {
              respResult = response;
            },
            error: function(jqXHR, textStatus, errorThrown) {
              alert(errorThrown);
            },
            async: false
        });
        return respResult;
	}

	function SZWJ_VerSignData(encryptedToken, data, signValue, detach) {
        var respResult = [];
        var reqBody = {
            businessOrgCode: _businessOrgCode,
            encryptedToken: encryptedToken,
            data: data,
            signValue: signValue,
            detach: detach
        }
        jQuery.support.cors = true;
        jQuery.ajax({
            url: "http://localhost:55668/CaApi/SZWJ_VerSignData",
            type: "POST",
            data: reqBody,
            dataType: "JSON",
            success: function(response) {
              respResult = response;
            },
            error: function(jqXHR, textStatus, errorThrown) {
              alert(errorThrown);
            },
            async: false
        });
        return respResult;
	}

	function SZWJ_GetCheckKey(sn) {
        var respResult = [];
        var reqBody = {
            sn: sn
        }
        jQuery.support.cors = true;
        jQuery.ajax({
            url: "http://localhost:55668/CaApi/SZWJ_GetCheckKey",
            type: "POST",
            data: reqBody,
            dataType: "JSON",
            success: function(response) {
              respResult = response;
            },
            error: function(jqXHR, textStatus, errorThrown) {
              alert(errorThrown);
            },
            async: false
        });
        return respResult;
	}

	function SZWJ_GetUserCert(sn) {
        var respResult = [];
        var reqBody = {
            sn: sn
        }
        jQuery.support.cors = true;
        jQuery.ajax({
            url: "http://localhost:55668/CaApi/SZWJ_GetUserCert",
            type: "POST",
            data: reqBody,
            dataType: "JSON",
            success: function(response) {
              respResult = response;
            },
            error: function(jqXHR, textStatus, errorThrown) {
              alert(errorThrown);
            },
            async: false
        });
        return respResult;
	}

	function SZWJ_GetPicBySN(sn) {
        var respResult = [];
        var reqBody = {
            sn: sn
        }
        jQuery.support.cors = true;
        jQuery.ajax({
            url: "http://localhost:55668/CaApi/SZWJ_GetPicBySN",
            type: "POST",
            data: reqBody,
            dataType: "JSON",
            success: function(response) {
              respResult = response;
            },
            error: function(jqXHR, textStatus, errorThrown) {
              alert(errorThrown);
            },
            async: false
        });
        return respResult;
	}

	function SZWJ_SignPDF(encryptedToken, pdfByte, position, withTsa) {
        var respResult = [];
        var reqBody = {
            businessOrgCode: _businessOrgCode,
            businessSystemCode: _businessSystemCode,
            businessTypeCode: _businessTypeCode,
            encryptedToken: encryptedToken,
            pdfByte: pdfByte,
            position: position,
            withTsa: withTsa
        }
        jQuery.support.cors = true;
        jQuery.ajax({
            url: "http://localhost:55668/CaApi/SZWJ_SignPDF",
            type: "POST",
            data: reqBody,
            dataType: "JSON",
            success: function(response) {
              respResult = response;
            },
            error: function(jqXHR, textStatus, errorThrown) {
              alert(errorThrown);
            },
            async: false
        });
        return respResult;
	}

	function SZWJ_GetAuthorityBySN(sn) {
        var respResult = [];
        var reqBody = {
            sn: sn
        }
        jQuery.support.cors = true;
        jQuery.ajax({
            url: "http://localhost:55668/CaApi/SZWJ_GetAuthorityBySN",
            type: "POST",
            data: reqBody,
            dataType: "JSON",
            success: function(response) {
              respResult = response;
            },
            error: function(jqXHR, textStatus, errorThrown) {
              alert(errorThrown);
            },
            async: false
        });
        return respResult;
	}

    //根据获取用户列表的name值
    //参数 cert是certificate对象
    function getUserListName(key)
    {
        /*
        //获取逻辑:证书的主题的CN项,没有就O项
         if(cert.subjectCN=="")
         {
             return cert.subjectO;
         }
         
         return cert.subjectCN;
         */
         var rt = "";
        var response = SZWJ_GetUserList();
        if (null == response || response.length == 0) {
            alert('证书检测：失败!');
            return rt;
        }
        
        var responseStr = response;
        var responseJson = eval(response);
        if (0 != responseJson.statusCode) {
            alert('证书检测：失败!' + responseStr);
            return rt;
        }
        
        var userList = responseJson.eventValue.userCerts;
        var i=0;
        for (var i = 0; i < userList.length; i++) {
            var user = userList[i];
            if (user.Sn == key) {
                return user.UserName;
            }
        }

        return "";
    }

    //根据获取用户列表的Key值
    //参数 cert是certificate对象
    function getUserListKey(cert)
    {
        /*
        //获取逻辑:获取netca拓展oid
        //1.3.6.1.4.1.18760.1.12.11
        //如果没有用sha1算法的证书拇印
         var oidString=cert.getStringExtensionValue("1.3.6.1.4.1.18760.1.12.11");
         if(oidString=="")
         {
             return cert.computeThumbprint(NetcaPKI.SHA1);
         }

         if(typeof oidString === "string")
         {
             return oidString;
         }
         */
         return "";
    }
    
    //根据key获取设备证书库的证书
    function getCertByValue(key)
    {
        var rt = null;
        
        var response = SZWJ_GetUserCert(key);
        if (null == response || response.length == 0) {
            alert('获取Base64编码证书：失败!');
            return rt;
        }
        
        var responseStr = response;
        var responseJson = eval(response);
        if (0 != responseJson.statusCode) {
            alert('获取Base64编码证书：失败!' + responseStr);
            return rt;
        }
        
        return responseJson.eventValue.base64Cert;
    }

    // 1.function GetUserList() 返回当前插入的UsbKey中用户列表,格式 Name||key&&& Name||key
    // 注:Name是用于登录,选择UsbKey时,显示的名称,
    // Key为证书号或者用以取UsbKey相关数据的信息

    function GetUserList() {
        var rt = "";
        var response = SZWJ_GetUserList();
        if (null == response || response.length == 0) {
            alert('证书检测：失败!');
            return rt;
        }
        
        var responseStr = response;
        var responseJson = eval(response);
        if (0 != responseJson.statusCode) {
            alert('证书检测：失败!' + responseStr);
            return rt;
        }
        
        var userList = responseJson.eventValue.userCerts;
        var i=0;
        for (var i = 0; i < userList.length; i++) {
            var user = userList[i];
            if (i == 0) 
            {
                rt = rt + user.UserName+ "||" + user.Sn;
            }
            else 
            {
                rt = rt + "&&&" + user.UserName+ "||" + user.Sn;
            }
        }
        return rt;
    }


    function GetUkeyType(sn) {
        var rt = "";
        var response = SZWJ_GetUserList();
        if (null == response || response.length == 0) {
            alert('证书检测：失败!');
            return rt;
        }
        
        var responseStr = response;
        var responseJson = eval(response);
        if (0 != responseJson.statusCode) {
            alert('证书检测：失败!' + responseStr);
            return rt;
        }
        
        var userList = responseJson.eventValue.userCerts;
        for (var i = 0; i < userList.length; i++) {
            var user = userList[i];
            if (user.Sn == sn) 
            {
                rt = user.Type;
                break;
            }
        }

        return rt;
    }

    // 2. function HashData(InData) 对传入的数据生成Hash值
    function HashData(InData) {
        
        //return NetcaPKI.hash(NetcaPKI.SHA1,InData);
        var response = SZWJ_HashData(InData);
        if (null == response || response.length == 0) {
            alert('生成数据Hash：失败!');
            return rt;
        }
        
        var responseStr = response;
        var responseJson = eval(response);
        if (0 != responseJson.statusCode) {
            alert('生成数据Hash：失败!\n返回结果:\n' + responseStr);
            return rt;
        }

        return responseJson.eventValue.hashData;
    }

    function SignedOrdData(content, key, keyToken) {
        if (typeof(keyToken) == "undefined") {
            keyToken = _CurEncryptedToken;
        }
        
        if ("" == content)
        {
            return "";
        }
        
        if(key=="")
        {
            return "";
        }
        
        var rt = "";
        
        var token = keyToken; //动态口令
        var detach = false; //是否包含原文
        var withTsa = false; //是否进行时间戳签名
        
        //var response = SZWJ_SignData(token, content, detach, withTsa);
        var response = SZWJ_SignDataBySn(key, content, detach, withTsa);
        if (null == response || response.length == 0) {
            alert('PKCS7签名：失败!');
            return rt;
        }
        
        var responseStr = response;
        var responseJson = eval(response);
        if (0 != responseJson.statusCode) {
            alert('PKCS7签名：失败! \n返回结果:\n' + responseStr);
            return rt;
        }
        return responseJson.eventValue.signedData;
    }

    function SignedOrdDataS(content, key, keyToken) {
        if (typeof(keyToken) == "undefined") {
            keyToken = _CurEncryptedToken;
        }
        
        if ("" == content)
        {
            return "";
        }
        
        if(key=="")
        {
            return "";
        }
        
        var rt = "";
        
        var token = keyToken; //动态口令
        var detach = false; //是否包含原文
        var withTsa = false; //是否进行时间戳签名
        
        
        //var response = SZWJ_SignData(token, content, detach, withTsa);
        var response = SZWJ_SignDataS(key, content, detach, withTsa);
        if (null == response || response.length == 0) {
            alert('PKCS7签名：失败!');
            return rt;
        }
        
        var responseStr = response;
        var responseJson = eval(response);
        if (0 != responseJson.statusCode) {
            alert('PKCS7签名：失败! \n返回结果:\n' + responseStr);
            return rt;
        }
        return JSON.stringify(responseJson.eventValue);
    }

    // 3. function SignedData(content, key) 对传入的数据进行签名, key 参见function 1
    function SignedData(content, key, keyToken) {
        if (typeof(keyToken) == "undefined") {
            keyToken = _CurEncryptedToken;
        }
        
        if ("" == content)
        {
            return "";
        }
        
        /*
        if(keyToken=="")
        {
            return "";
        }
        */
        if(key=="")
        {
            return "";
        }
        
        var rt = "";
        
        var token = keyToken; //动态口令
        var detach = false; //是否包含原文
        var withTsa = false; //是否进行时间戳签名
        //var response = SZWJ_SignData(token, content, detach, withTsa);
        var response = SZWJ_SignDataBySn(key, content, detach, withTsa);
        if (null == response || response.length == 0) {
            alert('PKCS7签名：失败!');
            return rt;
        }
        
        var responseStr = response;
        var responseJson = eval(response);
        if (0 != responseJson.statusCode) {
            alert('PKCS7签名：失败! \n返回结果:\n' + responseStr);
            return rt;
        }
        
        return responseJson.eventValue.signedData;
    }

    // 4. function GetSignCert(key) 获取证书pem字符串, key参见function 1
    function GetSignCert(key) 
    {
        var base64Cert = getCertByValue(key);
        return base64Cert;
    }

    // 5. function GetUniqueID(cert)
    // 获取证书唯一编码,
    // 参数为Base64编码的证书
    function GetUniqueID(cert, key) 
    {
        var rt = "";
        
       var response = SZWJ_GetCheckKey(key);
        
        if (null == response || response.length == 0) {
            alert('获取证书唯一标识：失败!');
            return rt;
        }
        
        var responseStr = response;
        var responseJson = eval(response);
        if (0 != responseJson.statusCode) {
            alert('获取证书唯一标识：失败!\n返回结果:\n' + responseStr);
            return rt;
        }

        return responseJson.eventValue.checkKey;
    }

    // 6. function GetCertNo(key) 证书序列号hex
    function GetCertNo(key) {
        /*
        var oCert = getCertByValue(key);
        return oCert.serialNumber;
        */
        var certNo = key.split("/")[0];
        return certNo;
    }

    function GetNetcaSealImage(key)
    {
        var rt = "";
        
        var response = SZWJ_GetPicBySN(key);
        if (null == response || response.length == 0) {
            alert('获取签章图片：失败!');
            return rt;
        }
        
        var responseStr = response;
        var responseJson = eval(response);
        if (0 != responseJson.statusCode) {
            alert('获取签章图片：失败!\n返回结果:\n' + responseStr);
            return rt;
        }

        var dictionaryList = responseJson.eventValue.dictionary;
        if (dictionaryList.length == undefined) {
            return dictionaryList.signFlow;
        } else {
            return dictionaryList[0].signFlow;
        }
    }


    // 7.获取UsbKey中的信息
    function getUsrSignatureInfo(key)
    {
        var base64Cert = getCertByValue(key);
        if(base64Cert == null || base64Cert == "")
        {
            return null;
        }
        var usrSignatureInfo = new Array();
        usrSignatureInfo["identityID"] = ""; // 身份证号;
        usrSignatureInfo["certificate"]  =   GetSignCert(key); // 证书; GetSignCert(key)

        //usrSignatureInfo["certificateNo"] = getUserListKey(key); // 证书号;
        usrSignatureInfo["certificateNo"] = GetCertNo(key);
        
        usrSignatureInfo["CertificateSN"] = GetCertNo(key); // 证书序列号;

        usrSignatureInfo["uKeyNo"] = ""; // 我们壳子上面没有Key的编号,有客户的名字是否可以?
        usrSignatureInfo["signImage"] = GetNetcaSealImage(key); // sealArry[0]; // 签名图是否指的是电子印章/或手写签名图片?
        usrSignatureInfo["UsrCertCode"] = GetUniqueID(usrSignatureInfo["certificate"], key); // 证书唯一编码,由于CA公司不同,所以此处为可区别证书的编码(可为uKeyNo或CertificateNo等等)
        usrSignatureInfo["CertName"] = getUserListName(key); // 证书中文名;

        return usrSignatureInfo;
    }

    function Login(form, key, pwd) {
        if(pwd=="")
        {
         alert("请输入密码");
         return false;
        }
        
        var sn = key;
        var response = SZWJ_Login(key, pwd);
        if (null == response || response.length == 0) {
            alert('证书登录：失败!');
            return false;
        }
        
        var responseStr = response;
        var responseJson = eval(response);
        if (0 != responseJson.statusCode) {
            alert('证书登录：失败!\n返回结果:\n' + responseStr);
            return false;
        }
        
        var boundValue = responseJson.eventValue.boundValue
        var signCertB64 = eval(SZWJ_GetUserCert(sn)).eventValue.base64Cert;
        
          var type = GetUkeyType(sn);
          var authority = "NETCA";
          if (type == "2") {
            authority = "BJCA";
          }
          //var mapAuthorityList = new Map();
          //mapAuthorityList.set(1, "NETCA");
          //mapAuthorityList.set(2, "BJCA");

          var respResult = [];
          
          var reqparam = '{';
            reqparam = reqparam + '"businessOrgCode":"'+_businessOrgCode+'"';
            reqparam = reqparam + ',"businessSystemCode":"'+_businessSystemCode+'"';
            reqparam = reqparam + ',"businessTypeCode":"'+_businessTypeCode+'"';
            reqparam = reqparam + ',"authority":"' + authority + '"';
            reqparam = reqparam + ',"sn":"' + sn + '"';
            reqparam = reqparam + ',"signCert":"' + signCertB64 + '"';
            reqparam = reqparam + ',"passwd":"' + pwd + '"';
            reqparam = reqparam + ',"boundValue":"' + boundValue + '"';
            reqparam = reqparam + '}';
          
          var reqBody = {
            action: "GetLoginToken",
            reqparam: reqparam
          };
          jQuery.support.cors = true;
          jQuery.ajax({
            url: "../CA.Ajax.SignSrv.cls",
            type: "POST",
            data: reqBody,
            dataType: "JSON",
            success: function (response) {
              respResult = response;
            },
            error: function (jqXHR, textStatus, errorThrown) {
              alert(errorThrown);
            },
            async: false
          });
        
        
        if (null == respResult || respResult.length == 0) {
          alert('证书登录：失败!请求统一身份系统失败!');
          return false;
        }
        
        //responseStr = JSON.stringify(respResult);
        //responseStr = respResult;
        responseStr = "";
		if (typeof(respResult) == "object") {
			responseStr = respResult.eventMsg || "";
		} else {
			responseStr = respResult;
        }
        responseJson = eval(respResult);
        if (0 != responseJson.statusCode) {
          alert('证书登录：失败!\n统一身份系统返回结果:\n' + responseStr);
          return false;
        }
        
        _CurEncryptedToken = responseJson.eventValue.encryptedToken;
        //_CurEncryptedToken = responseJson.eventValue.boundValue;
        
        //以下三个已经赋值
        //strServerRan  随机数
        //strServerSignedData 服务器对随机数的签名 
        //strServerCert 服务器证书
        return true;
    }

    function GetToken() {
        if (typeof(csp_CurEncryptedToken) == "undefined") {
            return "";
        } else {
            return _CurEncryptedToken;
        }
    }

    function InitToken() {
        var reqBody = {
            action: "GetSessionToken"
        };
        
        jQuery.support.cors = true;
        jQuery.ajax({
            url: "../CA.Ajax.SignSrv.cls",
            type: "POST",
            data: reqBody,
            //dataType: "JSON",
            success: function (response) {
            respResult = response;
            if (respResult != "") {
                _CurEncryptedToken = respResult;
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
          alert(errorThrown);
        },
        async: false
      });
    }
    
    function SOF_IsLogin(strKey) {
	    return false;
	}
	
    return {
    	OCX: "",
    	VenderCode:Const_Vender_Code,
    	SignType:Const_Sign_Type,
    	GetRealKey: function(key) {
	    	return key;
    	},
        Login: function(strFormName, strCertID, strPin) {
            return Login(strFormName, strCertID, strPin);
        },
        IsLogin: function(strKey) {
            if ('undefined' != SOF_IsLogin) {
                return SOF_IsLogin(strKey);
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
            return SignedData(contentHash, key)
        },
        SignedOrdData: function(contentHash, key) {
            return SignedOrdData(contentHash, key)
        },
        SignedOrdDataS: function(contentHash, key) {
            return SignedOrdDataS(contentHash, key)
        },
        getUsrSignatureInfo: function(key) {
            return getUsrSignatureInfo(key);
        },
        HashData:function(content){
	    	return HashData(content);
	    },
        _CurEncryptedToken:_CurEncryptedToken,
        GetToken:function(){
	    	return GetToken();
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
function SignedOrdDataS(contentHash, key) {
	return ca_key.SignedOrdDataS(contentHash, key)
}

///5.其他
function GetToken(key) {
	return ca_key.GetToken();
}