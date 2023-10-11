// 全局对象
var ca_key = (function () {
    var Const_Vender_Code = "XACA";
    var Const_Sign_Type = "UKEY";
    
    // 管理员key类型配置
    var ks_provider = "XACA"; // 介质
    var ks_alg = 0;    // 非对称算法，根据证书内容适配
    var ks_path = "C:\\CONT\\?";   // 如果为软算法，对应路径
    var ks_hash_alg = 0; // 自动适配算法，RSA时为SHA1, SM2时为SM3

    //var baseUrl = "http://localhost:9002/WebServerPrinter/Client/signPostData.do";
    var baseUrl = "http://localhost:26596/WebServerPrinter/Client/signPostData.do";
    
    var Last_CertInfo_ContainerName = "";
	var Last_CertInfo_UserCertCode = [];
	var Last_CertInfo_Cert = [];	
    
    if (window.ActiveXObject || "ActiveXObject" in window) {
	    try{
            SecCtrlObj = document.createElement("object");
	        SecCtrlObj.setAttribute("width",1);
	        SecCtrlObj.setAttribute("height",1);
	        SecCtrlObj.setAttribute("id","SecCtrlIE");
	        SecCtrlObj.setAttribute("name","SecCtrlIE");
	        SecCtrlObj.setAttribute("codebase","npSecCtrl.cab#version=1,3,2,0")
	        SecCtrlObj.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
	        SecCtrlObj.setAttribute("classid","clsid:17F8D3CF-857C-4D7C-9355-7A2398930B6A");
	        document.documentElement.appendChild(SecCtrlObj);
        } catch(e) {
            alert("请检查CA驱动是否正确安装："+e.message);
        }
    }
    
    //封装请求
    var SecCtrlGoogle = {
        KS_SetProv: function(str_prov,lalg,str_path) {
            var result = "-1";
            var formDataJson = {
                "interface_type": "2",
                "str_prov": str_prov,
                "lalg": Number(lalg),
                "str_path": str_path
            }
            var formData = JSON.stringify(formDataJson);
            $.ajax({
                type :"POST",
                url : baseUrl,
                dataType: "json",
                async : false,
                cache: false,
                data:formData,
                success : function(data) {
                    result = data.error_code;
                }
            });	
            return result;
        },
        KS_GetLastErrorCode: function() {
            var result = "-1";
            var formDataJson = {
                "interface_type": "40"
            }
            var formData = JSON.stringify(formDataJson);
            $.ajax({
                type :"POST",
                url : baseUrl,
                dataType: "json",
                async : false,
                cache: false,
                data:formData,
                success : function(data) {
                    result = data.error_code;
                }
            });	
            return result;
        },
        KS_GetLastErrorMsg: function() {
            var result = "";
            var formDataJson = {
                "interface_type": "40"
            }
            var formData = JSON.stringify(formDataJson);
            $.ajax({
                type :"POST",
                url : baseUrl,
                dataType: "json",
                async : false,
                cache: false,
                data:formData,
                success : function(data) {
                    result = data.str_errormsg;
                }
            });	
            return result;
        },
        KS_GetCertInfo: function(str_cert,str_type) {
            var result = "";
            var formDataJson = {
                "interface_type": "10",
                "str_cert": str_cert,
                "str_type": Number(str_type)
            }
            var formData = JSON.stringify(formDataJson);
            $.ajax({
                type :"POST",
                url : baseUrl,
                dataType: "json",
                async : false,
                cache: false,
                data:formData,
                success : function(data) {
                    result = data.str_info;
                }
            });	
            return result;
        },
        KS_GetCert: function(str_type) {
            var result = "";
            var formDataJson = {
                "interface_type": "9",
                "str_type": Number(str_type)
            }
            var formData = JSON.stringify(formDataJson);
            $.ajax({
                type :"POST",
                url : baseUrl,
                dataType: "json",
                async : false,
                cache: false,
                data:formData,
                success : function(data) {
                    result = data.str_base64cert;
                }
            });	
            return result;
        },
        KS_SetParam: function(str_paramname,str_path) {
            var result = "-1";
            var formDataJson = {
                "interface_type": "3",
                "str_paramname": str_paramname,
                "str_path":str_path
            }
            var formData = JSON.stringify(formDataJson);
            $.ajax({
                type :"POST",
                url : baseUrl,
                dataType: "json",
                async : false,
                cache: false,
                data:formData,
                success : function(data) {	
                    result = data.error_code;
                }
            });	
            return result;
        },
        KS_GetSealList: function() {
            var result = "";
            var formDataJson = {
                "interface_type": "36"
            }
            var formData = JSON.stringify(formDataJson);
            $.ajax({
                type :"POST",
                url : baseUrl,
                dataType: "json",
                async : false,
                cache: false,
                data:formDataJson,
                success : function(data) {
                    result = data.str_seallistdata;
                }
            });	
            return result;
        },
        KS_GetSeal: function(str_sealid) {
            var result = "";
            var formDataJson = {
                "interface_type": "37",
                "str_sealid":str_sealid
            }
            var formData = JSON.stringify(formDataJson);
            $.ajax({
                type :"POST",
                url : baseUrl,
                dataType: "json",
                async : false,
                cache: false,
                data:formData,
                success : function(data) {
                    result = data.str_sealdata;
                }
            });	
            return result;
        },
        KS_GetInfoFromSeal: function(str_sealdata,str_type) {
            var result = "";
            var formDataJson = {
                "interface_type": "38",
                "str_sealdata":str_sealdata,
                "str_type":Number(str_type)
            }
            var formData = JSON.stringify(formDataJson);
            $.ajax({
                type :"POST",
                url : baseUrl,
                dataType: "json",
                async : false,
                cache: false,
                data:formData,
                success : function(data) {
                    result = data.str_sealinfo;
                }
            });	
            return result;
        },
        KS_VerifyUserPIN: function(str_Pin) {
            var result = "-1";
            var formDataJson = {
                "interface_type": "YL002",
                "str_Pin":str_Pin
            }
            var formData = JSON.stringify(formDataJson);
            $.ajax({
                type :"POST",
                url : baseUrl,
                dataType: "json",
                async : false,
                cache: false,
                data:formData,
                success : function(data) {
                    result = data.error_code;
                }
            });	
            return result;
        },
        KS_GetCertInfoList: function(str_JsonInData) {
            var result = "";
            var formDataJson = {
                "interface_type": "GetCertInfoList",
                "str_JsonInData":str_JsonInData
            }
            var formData = JSON.stringify(formDataJson);
            $.ajax({
                type :"POST",
                url : baseUrl,
                dataType: "json",
                async : false,
                cache: false,
                data:formData,
                success : function(data) {
                    result=data.str_JsonData;
                }
            });	
            return result;
        },
        KS_SignData: function(str_indata,str_hashalg) {
            var result = "";
            var formDataJson = {
                "interface_type": "15",
                "str_indata":str_indata,
                "str_hashalg":Number(str_hashalg)
            }
            var formData = JSON.stringify(formDataJson);
            $.ajax({
                type :"POST",
                url : baseUrl,
                dataType: "json",
                async : false,
                cache: false,
                data:formData,
                success : function(data) {
                    result = data.str_signdata;
                }
            });	
            return result;
        },
        KS_batchSignData: function(str_indata,str_hashalg) {
            var result = "";
			var tmp = {"indata":JSON.parse(str_indata)}
			
            var formDataJson = {
                "interface_type": "BatchSign",
                "str_JsonInData":JSON.stringify(tmp),
                "str_hashalg":Number(str_hashalg)
            }
            var formData = JSON.stringify(formDataJson);
            $.ajax({
                type :"POST",
                url : baseUrl,
                dataType: "json",
                async : false,
                cache: false,
                data:formData,
                success : function(data) {
					result = data.str_JsonData;
                }
            });	
            return result;
        },
        KS_HashData: function(str_indata,str_alg) {
            var result;
            var formDataJson = {
                "interface_type": "13",
                "str_indata":str_indata,
                "str_alg":Number(str_alg)
            }
            var formData = JSON.stringify(formDataJson);
            $.ajax({
                type :"POST",
                url : baseUrl,
                dataType: "json",
                async : false,
                cache: false,
                data:formData,
                success : function(data) {
                    result = data.str_hashdata;
                }
            });	
            return result;
        },
        KS_GetImage: function(str_shebao,str_o) {
			var result;
			var formDataJson = {
                "interface_type": "27",
                "str_shebao":str_shebao,
                "str_o":str_o
            }
            var formData = JSON.stringify(formDataJson);
			$.ajax({
				type :"POST",
				url : baseUrl,
		        dataType: "json",
				async : false,
				cache: false,
				data:formData,
				success : function(data) {
		            result = data.str_signimage;
				}
			});
			return result;
		},
        KS_CheckPIN: function(str_pin) {
			var result;
			var formDataJson = {
                "interface_type": "28",
                "str_pin":str_pin
            }
            var formData = JSON.stringify(formDataJson);
			$.ajax({
				type :"POST",
				url : baseUrl,
		        dataType: "json",
				async : false,
				cache: false,
				data:formData,
				success : function(data) {
		            result = data.error_code;
				}
			});
			return result;
		}
    };
   
    if(window.ActiveXObject || "ActiveXObject" in window) {
        var SecCtrl = SecCtrlIE;
    } else {
        var SecCtrl = SecCtrlGoogle;
    }
   
    function CA_Init(){
	    if (Last_CertInfo_ContainerName != "") return true;
	    
        var lRet = SecCtrl.KS_SetProv(ks_provider, ks_alg, ks_path);
        if(lRet != 0){
            alert(SecCtrl.KS_GetLastErrorMsg());
            return false;
        }
        Last_CertInfo_ContainerName = "-1";
        return true;
    }

    //获取证书信息
    //cert: Base64编码证书
    //item: 解析项，具体ID如下：
    //1、证书版本；2、证书序列号；3、证书签名算法标识；4、证书颁发者国家(C); 5、证书颁发者组织名(O);
    //6、证书颁发者部门名(OU); 7、证书颁发者所在的省、自治区、直辖市(S); 8、证书颁发者通用名称(CN); 9、证书颁发者所在的城市、地区(L);
    //10、证书颁发者Email; 11、证书有效期：起始日期; 12、证书有效期：终止日期; 13、证书拥有者国家(C ); 14、证书拥有者组织名(O);
    //15、证书拥有者部门名(OU); 16、证书拥有者所在的省、自治区、直辖市(S); 17、证书拥有者通用名称(CN); 18、证书拥有者所在的城市、地区(L);
    //19、证书拥有者Email; 20、证书颁发者DN; 21、证书拥有者DN; 22、证书公钥信息; 23、CRL发布点.
    function CA_GetCertInfo(cert, item){
        var result = "";
        result = SecCtrl.KS_GetCertInfo(cert, item);
        if(result == ""){
            alert(SecCtrl.KS_GetLastErrorMsg());
        }
        return result;
    }
    
    //获取签名证书
    function CA_GetSignCert(key){
        if ((Last_CertInfo_Cert[key] || "") != "")
            return Last_CertInfo_Cert[key]
        
        var result = "";
        result = SecCtrl.KS_GetCert(2);   //1为加密证书、2为签名证书
        if(result == ""){
            alert(SecCtrl.KS_GetLastErrorMsg());
            return "";
        }
        Last_CertInfo_Cert[key] = result;
        Last_CertInfo_ContainerName = key;
        
        return result;
    }
    
    //判断是否为已设置为默认key
    /*function CA_isDefaultKey(key) {
        if (!CA_Init()) return false;
        var cert = CA_GetSignCert(key);
        var _key = CA_GetCertInfo(cert,2);
        return (key == _key);
    }*/

    //设置为默认key
    function CA_setDefaultKey(key) {
        /*if (CA_isDefaultKey(key)){
            return true;
        } else {*/
            if (!CA_Init()) return false;
            
            if (key == Last_CertInfo_ContainerName) return true;
                
            //SecCtrl.KS_SetParam("defaultkey", "")                       //清理默认key缓存数据
            var lRet = SecCtrl.KS_SetParam("defaultkey", key);          //设置默认key数据
            if (lRet != 0) {
                alert("设置默认key失败！")
                return false;
            }
            var lRet2 = SecCtrl.KS_SetParam("preselectkey", "defaultkey");
            if (lRet2 != 0) {
                alert("设置默认key失败！")
                return false;
            }
        //}
        return true;
    }

    //用户证书唯一标示为身份证号
    function CA_GetUniqueID(cert,key) {
        if ((Last_CertInfo_UserCertCode[key] || "") != "")
            return Last_CertInfo_UserCertCode[key]

        Last_CertInfo_ContainerName = key;
        
        var uniqueID = CA_GetCertInfo(cert,17);
        Last_CertInfo_UserCertCode[key] = uniqueID;
        return uniqueID;
    }
    
    //获取身份证号
    function CA_GetIdentityID(cert) {
        return CA_GetCertInfo(cert,17);
    }

    //获取证书号
    function CA_GetCertNo(key) {
        return key;
    }

    function CA_GetCertSN(key) {
        return key;
    }

    function CA_GetKeySN(key) {
        return key;
    }
    
    //获取签名图
    function CA_GetPicBase64Data(key) {
        var result = "";
        if (CA_setDefaultKey(key)) {
            result = SecCtrl.KS_GetImage("{\"UseType\":1}", "");
	        if(result == ""){
	            alert(SecCtrl.KS_GetLastErrorMsg());
	        }
	        return result;
        } else {
            alert("设置默认签名证书失败！")
            return result;
        }
    }

    //获取用户名
    function CA_GetCertCNName(certB64) {
        return CA_GetCertInfo(certB64,15);
    }

    //获取插入电脑的Ukey列表 格式为"FakeUser1||8A1D45A5C4E189B7&&&FakeUser2||A8B9D7A20C12A401";
    function GetUserList(){
        var userList = "";
        if (!CA_Init()) return userList;
        
        var certList = SecCtrl.KS_GetCertInfoList("");
        if(certList == ""){
            alert(SecCtrl.KS_GetLastErrorMsg());
            return "";
        }
        var certList = eval(certList);
        for(var i =0;i<certList.length;i++){
            if (userList == "") {
                userList = certList[i].SubjectOu + '||' + certList[i].CertSn
            }else {
                userList = userList + '&&&' + certList[i].SubjectOu + '||' + certList[i].CertSn
            }
        }
        if (userList == "||") userList = ""
        return userList;
    }

    //验证密码
    function Login(form_,key,password_) {
        if (!CA_Init()) return false;

        var result = "";
        var lRet = SecCtrl.KS_SetParam("defaultkey", key);
        if (lRet != 0) {
            alert("设置默认key失败！");
            return false;
        }
        var lRet2 = SecCtrl.KS_SetParam("preselectkey", "defaultkey");
        if (lRet2 != 0) {
            alert("设置默认key失败！")
            return false;
        }
        
        var isLogin = SOF_IsLogin(key);
        if (isLogin) return true;
        
        var lRet = SecCtrl.KS_VerifyUserPIN(password_);
        if(lRet != 0){
            alert(SecCtrl.KS_GetLastErrorMsg());
            return false;
        }
        return true;
    }

    function SignedData(content,key){
        var result = "";
        if (CA_setDefaultKey(key)) {
            SecCtrl.KS_SetParam("signtype", "pksc7");
            result = SecCtrl.KS_SignData(content, 0);    //0为自动     //hashAlg: 1-SHA1, 2-SHA256, 3-SHA512, 4-MD5, 5-MD4, 6-SM3
            if(result == ""){
                alert(SecCtrl.KS_GetLastErrorMsg());
            }
            return result;
        } else {
            alert("设置默认签名证书失败！")
            return result;
        }
        return result;
    }

    function SignedOrderData(content,key){
        return SignedData(content,key);
    }
    
    function SignedDataS(content, key) {
        var contentArr = content.split("&&&&")
        var contentLength = contentArr.length;
        
        if (contentLength < 1)
        {
            alert("签名失败：批量签名接口至少需要传入一组数据！")
            return "";
        }

		var result = "";
        if (CA_setDefaultKey(key)) {
            SecCtrl.KS_SetParam("signtype", "pksc7");
            
            //组织签名格式，医生站传入格式为：1||||医嘱1Hash值&&&&2||||医嘱2Hash值.....
            //CA接口入参格式为：{"indata":[{"hashdata":"123"},{"hashdata":"1234"}]}
            var tmpArr = new Array();
            for (var i=0;i<contentLength;i++) {
                var tmpContent = contentArr[i].split("||||")[1]
                var obj = {"hashdata":tmpContent}
                tmpArr.push(obj);
            }
            var realContent = JSON.stringify(tmpArr);

            result = SecCtrl.KS_batchSignData(realContent, 0);    //0为自动     //hashAlg: 1-SHA1, 2-SHA256, 3-SHA512, 4-MD5, 5-MD4, 6-SM3
            if(result == ""){
                alert(SecCtrl.KS_GetLastErrorMsg());
            }
			
			try{
				var outData = JSON.parse(result).outdata;
			
				var tmpArr = new Array();
				for (var i=0;i<outData.length;i++) {
					var tmpContent = outData[i].str_signdata
					var obj = {"signedData":tmpContent}
					tmpArr.push(obj);
				}
				result = JSON.stringify(tmpArr);
			} catch(e) {
				alert("获取签名结果异常："+e);
				result = "";
			}
			
            return result;
        } else {
            alert("设置默认签名证书失败！")
            return result;
        }
        return result;
	}

    /*function HashData(inData){
        var result = "";
        result = SecCtrl.KS_HashData(inData, 2);   //1-SHA1, 2-SHA256, 3-SHA512, 4-MD5, 5-MD4
        if(SecCtrl.KS_GetLastErrorCode() != 0){
            alert(SecCtrl.KS_GetLastErrorMsg());
            return "";
        }
        return result;
    }*/
    
    // hash算法,由于CA接口运行较慢，所以替换HIS自行实现Hash，Hash算法与CA保持一致，SHA256-Base64
    function HashData(inData) {
        if (inData == "") return "";
        
        var rtn = iGetData("HashData",inData);
        if ((rtn.retCode == "0")) {
            return rtn.hashData;
        } else {
            return "";
        }
    }

    function GetCertNo(key) {
        //var result = "";
        //if (CA_setDefaultKey(key)) {
            return key;
        //} else {
        //    alert("设置默认签名证书失败！")
        //    return result;
        //}
    }

    function GetPicBase64Data(key) {
        var result = "";
        if (CA_setDefaultKey(key)) {
            return CA_GetPicBase64Data(key);
        } else {
            alert("设置默认签名证书失败！")
            return result;
        }
    }

    function GetSignCert(key){
        var result = "";
        if (CA_setDefaultKey(key)) {
            return CA_GetSignCert(key);
        } else {
            alert("设置默认签名证书失败！")
            return result;
        }
    }

    function GetUniqueID(cert,key) {
        var result = ""
        if (CA_setDefaultKey(key)) {
            return CA_GetUniqueID(cert,key);
        } else {
            alert("设置默认签名证书失败！")
            return result;
        }
    }

    //判读是否登录过
    function SOF_IsLogin(key) {
        var indata = "certsn:"+key;
        var result = SecCtrl.KS_CheckPIN(indata);
        
	    if (result == "0")
	    	return true;
        return false;
    }

    function getUsrSignatureInfo(key){
        var usrSignatureInfo = new Array();
        
        if (!CA_Init()) return usrSignatureInfo;
        SecCtrl.KS_SetParam("defaultkey", "")                       //清理默认key缓存数据
        var lRet = SecCtrl.KS_SetParam("defaultkey", key);          //设置默认key数据
        if (lRet != 0) {
            alert("设置默认key失败！")
            return usrSignatureInfo;
        }
        var lRet2 = SecCtrl.KS_SetParam("preselectkey", "defaultkey");
        if (lRet2 != 0) {
            alert("设置默认key失败！")
            return usrSignatureInfo;
        }
        
        usrSignatureInfo["certificateNo"] = CA_GetCertNo(key);
        usrSignatureInfo["CertificateSN"] = CA_GetCertSN(key);
        usrSignatureInfo["uKeyNo"] = CA_GetKeySN(key);
        usrSignatureInfo["signImage"] = CA_GetPicBase64Data(key);
        var certB64 = CA_GetSignCert(key);
        usrSignatureInfo["certificate"] = certB64;
        usrSignatureInfo["UsrCertCode"] = CA_GetUniqueID(certB64,key);
        usrSignatureInfo["CertName"] = CA_GetCertCNName(certB64);
        usrSignatureInfo["identityID"] = CA_GetIdentityID(certB64);
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
        OCX: SecCtrl,
        VenderCode:Const_Vender_Code,
        SignType:Const_Sign_Type,
        GetRealKey: function(key) {
            return key;
        },
        Login: function(strFormName, strCertID, strPin, forceCheck) {
            return Login(strFormName, strCertID, strPin, forceCheck);
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
            return SignedData(contentHash, key);
        },
        SignedOrdData: function(contentHash, key) {
            return SignedData(contentHash, key)
        },
        SignedDataS: function(contentHash, key) {
            return SignedDataS(contentHash, key)
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
function SignedDataS(contentHash, key) {
    return ca_key.SignedDataS(contentHash, key)
}

///5.其他
function LoginForm(paraObj) {
    return ca_key.LoginForm(paraObj);
}
function GetLastError() {
    return ca_key.GetLastError();
}