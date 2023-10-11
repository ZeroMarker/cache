var ca_key = (function() {
    var Const_Vender_Code = "BJCA";
    var Const_Sign_Type = "FACE";
    
    var Global_Last_Login_CertInfo = "";
    var Global_Last_Login_SealInfo = "";
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
    
   	// 日期类型格式化方法的定义
	Date.prototype.Format = function(fmt) { 
		//author: meizz 
		var o = { 
		    "M+" : this.getMonth()+1,                 //月份 
		    "d+" : this.getDate(),                    //日 
		    "h+" : this.getHours(),                   //小时 
		    "m+" : this.getMinutes(),                 //分 
		    "s+" : this.getSeconds(),                 //秒 
		    "q+" : Math.floor((this.getMonth()+3)/3), //季度 
		    "S" : this.getMilliseconds()             //毫秒 
		}; 
		if(/(y+)/.test(fmt)) {
		    fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
		}
		for(var k in o) {
		    if(new RegExp("("+ k +")").test(fmt)) {
				fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length))); 
		    }
		}
		return fmt; 
	}
	
	// ////// 常量 //////////////

	// 分组加密算法标识
	var SGD_SM1_ECB = 0x00000101; // SM1算法ECB加密模式
	var SGD_SM1_CBC = 0x00000102; // SM1算法CBC加密模式
	var SGD_SSF33_ECB = 0x00000201; // SSF33算法ECB加密模式
	var SGD_SSF33_CBC = 0x00000202; // SSF33算法CBC加密模式
	var SGD_SMS4_ECB = 0x00000401; // SMS4算法ECB加密模式
	var SGD_SMS4_CBC = 0x00000402; // SMS4算法CBC加密模式
	var SGD_3DES_ECB = 0x00002001; // 3DES算法ECB加密模式
	var SGD_3DES_CBC = 0x00002002; // 3DES算法CBC加密模式

	// 签名算法标识
	var SGD_SM3_RSA = 0x00010001; // 基于SM3算法和RSA算法的签名
	var SGD_SHA1_RSA = 0x00010002; // 基于SHA_1算法和RSA算法的签名
	var SGD_SHA256_RSA = 0x00010004; // 基于SHA_256算法和RSA算法的签名
	var SGD_SM3_SM2 = 0x00020101; // 基于SM2算法和SM3算法的签名

	// 密码杂凑算法标识
	var SGD_SM3 = 0x00000001; // SM3杂凑算法
	var SGD_SHA1 = 0x00000002; // SHA_1杂凑算法
	var SGD_SHA256 = 0x00000004; // SHA_256杂凑算法

	// 证书和密钥类型标识
	var KEY_SIGNOREXCHANGE = 0; // 签名或加密 先获取签名 不成功再获取加密
	var KEY_SIGNATURE = 1; // 签名位置
	var KEY_KEYEXCHANGE = 2; // 加密位置

	// 产生密钥对时的密钥标识
	var KEY_TYPE_RSA1024 = 1; // RSA1024位
	var KEY_TYPE_RSA2048 = 2; // RSA2048位
	var KEY_TYPE_SM2_256 = 3; // SM2 256位

	// 获取设备信息
	var DEVICE_TYPE_LABEL = 1; // 设备标签
	var DEVICE_TYPE_FREESPACE = 2; // 剩余空间
	var DEVICE_TYPE_SERIALNUM = 3; // 硬件设备序列号
	var DEVICE_TYPE_TYPE = 4; // 硬件类型 返回 RSA 或 SM2
	var DEVICE_TYPE_KEY_TYPE = 115; // SM2设备返回20 RSA设备返回10
	var DEVICE_TYPE_VID_PID = 116; // 设备的VID PID

	// 获取的证书信息类型
	var CERT_VERSION = 1; // 证书版本 返回V1 V2 V3
	var CERT_SERIAL = 2; // 证书序列号
	var CERT_SIGN_METHOD = 3; // 获取证书类型 返回 rsa或sm2
	var CERT_ISSUER_C = 4; // 证书发放者国家名 多个之间用&&&隔开
	var CERT_ISSUER_O = 5; // 证书发放者组织名
	var CERT_ISSUER_OU = 6; // 证书发放者部门名
	var CERT_ISSUER_ST = 7; // 证书发放者省州名
	var CERT_ISSUER_CN = 8; // 证书发放者通用名
	var CERT_ISSUER_L = 9; // 证书发放者城市名
	var CERT_ISSUER_E = 10; // 证书发放者EMAIL地址
	var CERT_NOT_BEFORE = 11; // 证书有效期起始 格式YYYYMMDDHHMMSS
	var CERT_NOT_AFTER = 12; // 证书有效期截止 格式YYYYMMDDHHMMSS
	var CERT_SUBJECT_C = 13; // 用户国家名
	var CERT_SUBJECT_O = 14; // 用户组织名
	var CERT_SUBJECT_OU = 15; // 用户部门名
	var CERT_SUBJECT_ST = 16; // 用户省州名
	var CERT_SUBJECT_CN = 17; // 用户通用名
	var CERT_SUBJECT_L = 18; // 用户城市名
	var CERT_SUBJECT_E = 19; // 用户EMAIL地址
	var CERT_PUBKEY = 20; // 证书公钥
	var CERT_SUBJECT_DN = 33; // 用户DN
	var CERT_ISSUER_DN = 34; // 颁发者DN
	var CERT_UNIQUEID = 35; // 唯一实体ID

	try {
        XTXAPPobj = document.createElement("object");
        XTXAPPobj.setAttribute("width",1);
        XTXAPPobj.setAttribute("height",1);
        XTXAPPobj.setAttribute("id","XTXAPP");
        XTXAPPobj.setAttribute("name","XTXAPP");
        XTXAPPobj.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
        
        picobj = document.createElement("object");
        picobj.setAttribute("width",1);
        picobj.setAttribute("height",1);
        picobj.setAttribute("id","picobj");
        picobj.setAttribute("name","picobj");
        picobj.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
        
        if (window.ActiveXObject || "ActiveXObject" in window) {
            XTXAPPobj.setAttribute("classid","clsid:3F367B74-92D9-4C5E-AB93-234F8A91D5E6");
            picobj.setAttribute("classid","clsid:3BC3C868-95B5-47ED-8686-E0E3E94EF366");
        }
        else {
            XTXAPPobj.setAttribute("type","application/x-xtx-axhost");
            XTXAPPobj.setAttribute("clsid","{3F367B74-92D9-4C5E-AB93-234F8A91D5E6}");
            picobj.setAttribute("type","application/x-xtx-axhost");
            picobj.setAttribute("clsid","{3BC3C868-95B5-47ED-8686-E0E3E94EF366}");
        }
        document.documentElement.appendChild(XTXAPPobj);
        document.documentElement.appendChild(picobj);
        XTXAPP.SOF_GetVersion();
	} catch (e) {
	    alert("请检查证书应用环境是否正确安装!");
	}

	// 获取用户列表 并填充到证书列表
	function FillUserList(strListID) {
	    var objListID = eval(strListID);
	    //var strUserList = SOF_GetUserList();
	    var strUserList = GetUserList();
	    while (1) {
	        var i = strUserList.indexOf("&&&");
	        if (i <= 0) {
	            break;
	        }
	        var strOneUser = strUserList.substring(0, i);
	        var strName = strOneUser.substring(0, strOneUser.indexOf("||"));
	        var strUniqueID = strOneUser.substring(strOneUser.indexOf("||") + 2,
					strOneUser.length);
	        var objItem = new Option(strName, strUniqueID);
	        objListID.add(objItem);
	        var len = strUserList.length;
	        strUserList = strUserList.substring(i + 3, len);
	    }
	    var objListID = null;
	    return;
	}
	// 清空证书列表
	function RemoveUserList(strListID) {
	    var objListID = eval(strListID);
	    var i;
	    var n = objListID.length;
	    for (i = 0; i < n; i++) {
	        objListID.remove(0);
	    }
	}
	// 重新填充用户列表
	function ChangeUserList(strListID) {
	    RemoveUserList(strListID);
	    FillUserList(strListID);
	}

	// 非IE浏览器下用到的函数
	function OnUsbKeyChange() {
	    // alert("OnUsbKeyChange called!");
	    ChangeUserList("LoginForm.UserList");
	}

	// 设置加密算法
	function SOF_SetEncryptMethod(encMethod) {
	    return XTXAPP.SOF_SetEncryptMethod(encMethod);
	}

	// 设置签名算法
	function SOF_SetSignMethod(signMethod) {
	    return XTXAPP.SOF_SetSignMethod(signMethod);
	}

	// 获取用户列表
	function SOF_GetUserList() {
	    return XTXAPP.SOF_GetUserList();
	}

	// 导出用户证书
	function SOF_ExportUserCert(CertID, certType) {
	    if (certType == KEY_SIGNOREXCHANGE) {
	        return XTXAPP.SOF_ExportUserCert(CertID);
	    } else if (certType == KEY_SIGNATURE) {
	        var signCert = XTXAPP.SOF_ExportUserCert(CertID);
	        var encCert = XTXAPP.SOF_ExportExChangeUserCert(CertID);
	        if (signCert != encCert) {
	            return signCert;
	        } else { /* 不存在签名证书 */
	            return "";
	        }
	    } else if (certType == KEY_KEYEXCHANGE) {
	        return XTXAPP.SOF_ExportExChangeUserCert(CertID);
	    } else {
	        return "";
	    }
	}

	// 校验用户口令
	function SOF_Login(CertID, passwd) {
	    var ret = XTXAPP.SOF_Login(CertID, passwd);
	    if (ret) {
	        return true;
	    } else {
	        return false;
	    }
	}

	// 获取密码重试次数
	function SOF_GetPinRetryCount(CertID) {
	    return XTXAPP.SOF_GetPinRetryCount(CertID);
	}

	// 修改证书密码
	function SOF_ChangePassWd(CertID, OldPassWd, NewPassWd) {
	    var ret = XTXAPP.SOF_ChangePassWd(CertID, OldPassWd, NewPassWd);
	    if (ret) {
	        return true;
	    } else {
	        return false;
	    }
	}

	// 获取证书信息
	function XTXAPP_GetCertDetail(sCert, type) {
	    if (type == CERT_UNIQUEID) {
	        var ret = XTXAPP.SOF_GetCertInfoByOid(sCert, "1.2.86.11.7.1.8");
	        if (ret != "") {
	            return ret;
	        } else {
	            ret = XTXAPP.SOF_GetCertInfoByOid(sCert, "2.16.840.1.113732.2");
	            if (ret != "") {
	                return ret;
	            } else {
	                return XTXAPP.SOF_GetCertInfoByOid(sCert,
							"1.2.156.112562.2.1.1.1");
	            }
	        }
	    } else {
	        return XTXAPP.SOF_GetCertInfo(sCert, type);
	    }
	}

	// 数据签名
	function SOF_SignData(CertID, inData) {
	    return XTXAPP.SOF_SignData(CertID, inData);
	}

	// 数据验签
	function SOF_VerifySignedData(sCert, inData, signValue) {
	    var ret = XTXAPP.SOF_VerifySignedData(sCert, inData, signValue);
	    if (ret) {
	        return true;
	    } else {
	        return false;
	    }
	}

	function SOF_GetLastError() {
	    return XTXAPP.SOF_GetLastError();
	}

	function SOF_GetLastErrorMsg() {
	    var code = XTXAPP.SOF_GetLastError();
	    var msg = XTXAPP.SOF_GetLastErrMsg();

	    return "CA错误码[" + code + "] 错误描述[" + msg + "]"
	}

	function CheckValid(userCert) {
	    // 检查证书有效期
	    var strNotBefore = XTXAPP_GetCertDetail(userCert, CERT_NOT_BEFORE);
	    var strNotBefore_year = strNotBefore.substring(0, 4);
	    var strNotBefore_month = strNotBefore.substring(4, 6);
	    var strNotBefore_day = strNotBefore.substring(6, 8);
	    var notBeforeDate = strNotBefore_year + "/" + strNotBefore_month + "/"
				+ strNotBefore_day;
	    var nowDate = new Date().Format("yyyy/MM/dd");
	    var days = (Date.parse(notBeforeDate) - Date.parse(nowDate))
				/ (1000 * 60 * 60 * 24);
	    if (days > 0) {
	        alert("您的证书尚未生效!距离生效日期还剩" + days + "天!");
	        return false;
	    }

	    var strNotAfter = XTXAPP_GetCertDetail(userCert, CERT_NOT_AFTER);
	    var strNotAfter_year = strNotAfter.substring(0, 4);
	    var strNotAfter_month = strNotAfter.substring(4, 6);
	    var strNotAfter_day = strNotAfter.substring(6, 8);
	    var notAfterDate = strNotAfter_year + "/" + strNotAfter_month + "/"
				+ strNotAfter_day;
	    var nowDate = new Date().Format("yyyy/MM/dd");
	    days = (Date.parse(notAfterDate) - Date.parse(nowDate))
				/ (1000 * 60 * 60 * 24);

	    if (days <= -45) {
	        alert("您的证书已过期 " + -days + " 天，超过了最后使用期限！\n请到北京数字证书认证中心办理证书更新手续。");
	        return false;
	    }

	    if (days >= 0 && days <= 60) {
	        alert("您的证书还有" + days + "天过期，\n请您尽快到北京数字证书认证中心办理证书更新手续。");
	        return true;
	    }

	    if (days < 0) {
	        alert("您的证书已过期 " + -days + " 天，\n请尽快到北京数字证书认证中心办理证书更新手续。");
	    }

	    return true;
	}

	// 用户登录
	function Login(strFormName, strCertID, strPin) {
	    if  (SOF_IsLogin(strCertID)) {
            return true;
        }
		var objForm = eval(strFormName);
	    if (objForm == null) {
	        alert("表单错误");
	        return false;
	    }
		
	
	    if (strCertID == null || strCertID == "") {
	        alert("获取用户信息失败");
	        return false;
	    }
		/*
	    if (strPin == null || strPin == "") {
	        alert("请输入证书密码");
	        return false;
	    }
	    if (strPin.length < 6 || strPin.length > 16) {
	        alert("密码长度应该在4-16位之间");
	        return false;
	    }
		*/
	    // 校验密码
        var ret = SOF_Login(strCertID, strPin);
        if (!ret) {
            var retryCount = SOF_GetPinRetryCount(strCertID);
            if (retryCount > 0) {
                alert("校验证书密码失败!您还有" + retryCount + "次机会重试!");
                return false;
            } else if (retryCount == 0) {
                alert("您的证书密码已被锁死,请联系BJCA进行解锁!");
                return false;
            } else {
                alert("登录失败!");
                return false;
            }
        }
        strCertID = getRealKey(strCertID);
        // 导出客户端证书
        var userCert = SOF_ExportUserCert(strCertID, KEY_SIGNOREXCHANGE);
        if (userCert == null || userCert == "") {
            alert("导出用户证书失败!");
            return false;
        }

        // 检查证书有效期
        if (!CheckValid(userCert)) {
            return false;
        }

        // 验证服务端签名
        ret = SOF_VerifySignedData(strServerCert, strServerRan, strServerSignedData)
        if (!ret) {
            alert("验证服务器端信息失败!");
            return false;
        }

        // 对随机数做签名
        var strClientSignedData = SOF_SignData(strCertID, strServerRan);
        if (strClientSignedData == null || strClientSignedData == "") {
            alert("客户端签名失败!");
            return false;
        }
        // Add a hidden item ...
        var strSignItem = "<input type=\"hidden\" name=\"UserSignedData\" value=\"\">";
        if (objForm.UserSignedData == null) {
            objForm.insertAdjacentHTML("BeforeEnd", strSignItem);
        }
        var strCertItem = "<input type=\"hidden\" name=\"UserCert\" value=\"\">";
        if (objForm.UserCert == null) {
            objForm.insertAdjacentHTML("BeforeEnd", strCertItem);
        }
        var strContainerItem = "<input type=\"hidden\" name=\"ContainerName\" value=\"\">";
        if (objForm.ContainerName == null) {
            objForm.insertAdjacentHTML("BeforeEnd", strContainerItem);
        }

        objForm.UserSignedData.value = strClientSignedData;
        objForm.UserCert.value = userCert;
        objForm.ContainerName.value = strCertID;

        return true;
	}

	// /////////////////对外接口

	function GetUserList() {
	    var strUserList = "";
	    var ret = "";
	    try {
	        strUserList = SOF_GetUserList();
	        
	        var arr = strUserList.split("&&&");
	        for (var i =0; i < arr.length; i++) {
	        	var strOneUser = arr[i];
		        if (strOneUser == "") continue;
		        
		        var strName = strOneUser.split("||")[0];
		        var strUniqueID = strOneUser.split("||")[1];
		       	
		        if (strName != "易签盾证书") continue;
		        
		        if (ret == "") {
		        	ret = strOneUser;
		        } else {
			        ret = ret + "&&&" + strOneUser;
		        }
	        }
	        
	        return ret;
	    } catch (e) {

	        return "";
	    }
	}
	/**
	 * function Loginxx(document.caAuditForm, key, pwd) { return null; }
	 */
	function getUserList_pnp() {
	    return GetUserList();
	}
	function SignedData(content, key) {
		key = getRealKey(key);
	    return SOF_SignData(key, content);
	}
	function SignedOrdData(content, key) {
		key = getRealKey(key);
	    return SOF_SignData(key, content);

	}
	// 获取身份证号
	function GetIdentityID(key) {
		key = getRealKey(key);
	    var oid = "2.16.840.1.113732.2"; // RSA key
	    // var oid = "1.2.156.112562.2.1.1.1";//SM2 key
	    var cert;
	    cert = SOF_ExportUserCert(key, KEY_SIGNATURE);
	    var sf_id = XTXAPP.SOF_GetCertInfoByOid(cert, oid);
	    return sf_id;
	}

	function GetSignCert(key) {

		key = getRealKey(key);
	    return SOF_ExportUserCert(key, KEY_SIGNATURE);
	}

	function GetCertSN(cert) {
	    return XTXAPP_GetCertDetail(cert, CERT_SERIAL);

	}

	function GetPicBase64Data(key) {
        key = getRealKey(key);
	    //return picobj.GetPic();
	    var fileName = "ESEAL";
		return XTXAPP.ReadFile(key, fileName);
	}

	function HashData(inData) {
	    //return picobj.Hash(InData);
		var rtn = iGetData("HashData",inData);
		if ((rtn.retCode == "0")) {
			return rtn.hashData;
		} else {
			Global_Last_Error_Msg = rtn.retMsg;
			return "";
		}
	}

	// 证书标识符，用于区分证书,放置用户证书唯一标识
	function GetUniqueID(cert) {
	    // var oid = "1.2.156.112562.2.1.4.1"; // SM2 key
	    // var oid = "1.2.156.112562.2.1.1.14"; // SM2 key
	    //var oid = "2.16.840.1.113732.2"; // ca测试库SM2 key
	    //var oid ="1.2.156.112562.2.1.2.2";// ca正试库SM2 key
	    //var uniqueID = XTXAPP.SOF_GetCertInfoByOid(cert, oid);
        
	    //修改为不通过拓展oid获取，可以匹配通用项目
        var uniqueID = XTXAPP.SOF_GetCertEntity(cert);
        return uniqueID;
	}

	function GetCertCNName(cert) {
	    return XTXAPP_GetCertDetail(cert, CERT_SUBJECT_CN);
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
	    // 由于ca的问题，必须先hash，才能取到图片,2012年8月份以后新项目可以不加该语句。
	    //HashData("test");
		key = getRealKey(key);
	    return GetPicBase64Data(key);
	}

	// 人脸识别的证书唯一标识，不再使用硬件容器号
	// 人脸识别的证书唯一标识，使用证书sn
	function GetCertNo(key) {
		//key = getRealKey(key);
		//var par = key.split('/');
	    //return par[0];
	    key = getRealKey(key);
		var cert = GetSignCert(key);
		var sn = GetCertSN(cert);
	    return sn;
	}

	function getUsrSignatureInfo(key) {
	    var usrSignatureInfo = new Array();
	    usrSignatureInfo["identityID"] = GetIdentityID(key);
	    var cert = GetSignCert(key);
	    usrSignatureInfo["certificate"] = cert;
	    usrSignatureInfo["certificateNo"] = GetCertNo(key);
	    usrSignatureInfo["CertificateSN"] = GetCertSN(cert);
	    usrSignatureInfo["uKeyNo"] = getKeySN(key);
	    //由于ca的问题，必须先hash，才能取到图片,2012年8月份以后新项目可以不加该语句。
	    usrSignatureInfo["signImage"] = GetPicBase64Data(key);
	    usrSignatureInfo["UsrCertCode"] = GetUniqueID(cert);
	    usrSignatureInfo["CertName"] = GetCertCNName(cert);
	    return usrSignatureInfo;
	}
	
	function oGetCertInfoByUserCode(userCode) {
	    var usrSignatureInfo = new Array();
	    
	    var ret = iGetData("GetCertByUserCode",userCode,"");
	    if ((ret == "")||(ret.retCode != "0")) return "";
	    
	    //var ret2 = iGetData("GetSeal",userCode);
	    //if ((ret2 == "")||(ret2.retCode != "0")) return "";
	    
	    usrSignatureInfo["identityID"] = "";
	    usrSignatureInfo["certificate"] = ret.signCert;
	    usrSignatureInfo["certificateNo"] = ret.certNo;
	    usrSignatureInfo["CertificateSN"] = ret.certSN;
	    usrSignatureInfo["uKeyNo"] = "";
	   	usrSignatureInfo["signImage"] = ret.signSeal;
	    usrSignatureInfo["UsrCertCode"] = GetUniqueID(ret.signCert);;
	    usrSignatureInfo["CertName"] = ret.certCN;
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
	    var ret = SOF_Login(strCertID, strPin);
	    if (!ret) {
	        return "登录失败!";
	    }
		
	    return "";
	}

	//校验随机数
	function CheckForm(strCertID, strServerCert, strServerRan, strServerSignedData) {
        strCertID = getRealKey(strCertID);
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

	function SOF_IsLogin(strKey) {
        ///return true;
	    return XTXAPP.SOF_IsLogin(strKey);
	}

	function getRealKey(key) {
		return SOF_GetLastLoginCertID();
	}

	//获取最后一次登录证书ID
	function SOF_GetLastLoginCertID() {
		return XTXAPP.SOF_GetLastLoginCertID();
	}
	
	function oGetLastError() {
		return SOF_GetLastErrorMsg();
	}
	
	function oVerifySign(certBase64, inData, signData) {
		
		var rtn = iGetData("VerifySign",certBase64, inData, signData);
		if (typeof(rtn) != "object") return false;
		
		if ((rtn.retCode == "0")&&(rtn.verifyResult == "1")) {
			return true;
		} else {
			return false;
		}
	}
	
    return {
    	OCX: XTXAPP,
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
        HashData:function(content){
	    	return HashData(content)  
	    },
	    GetLastError:function() {
	    	return oGetLastError();
	    },
	    VerifySign:function(certBase64, inData, signData) {
		    return oVerifySign(certBase64, inData, signData);
	    },
	    GetCertInfoByUserCode:function(userCode){
			return oGetCertInfoByUserCode(userCode);    
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
function getCertInfoByUserCode(userCode) {
	return ca_key.GetCertInfoByUserCode(userCode);	
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
function GetLastError() {
    return ca_key.GetLastError();
}
function VerifySign(certBase64, inData, signData) {
	return ca_key.VerifySign(certBase64, inData, signData);
}
