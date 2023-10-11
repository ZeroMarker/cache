var ca_key = (function() {
	
    var Const_Vender_Code = "AHCA";
    var Const_Sign_Type = "UKEY";
	var Global_Last_Login_CertInfo = "";
    var Global_Last_Login_Token = "";
    var Global_Last_Login_SealInfo = "";
    var Global_Last_Error_Code = "";
    var Global_Last_Error_Msg = "";
    
    //马鞍山医院与安徽省立均为安徽CA，但是获取签章代码逻辑不同，以安徽省立为准，马鞍山医院在项目ID配置AHMAS
	var projectID = "";
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
	var data = ajaxDATA('String', 'CA.ConfigService', 'GetServiceCfgByCode', "AHCA", "UKEY");
	jQuery.ajax({
		type: 'POST',
		dataType: 'text',
		url: '../CA.Ajax.Common.cls',
		async: false,
		cache: false,
        global:false,
		data: data,
		success: function (ret) {
			if (ret != ""){
				var arr = $.parseJSON(ret);
				projectID = arr["ProjectID"];
			}else {
				$.messager.alert("提示","请配置签名服务CA.ConfigService 厂商代码[AHCA] 签名类型[UKEY]");
			}
		},
		error: function (ret) {
			$.messager.alert("提示","CA.ConfigService.GetServiceCfgByCode Error:" + ret);
		}
	}); 
    
    if (projectID == "AHMAS")
    {
        //以下为马鞍山医院签章相关代码
        var WordArray =  function (words, sigBytes) {
            words = this.words = words || [];
            if (sigBytes != undefined) {
                this.sigBytes = sigBytes;
            } else {
                this.sigBytes = words.length * 4;
            }
        };

        WordArray.prototype = {
            clamp: function () {
                var words = this.words;
                var sigBytes = this.sigBytes;
                words[sigBytes >>> 2] &= 0xffffffff << (32 - (sigBytes % 4) * 8);
                words.length = Math.ceil(sigBytes / 4);
            },
            toString: function (encoder) {
                return (encoder || Hex).stringify(this);
            }
        }

        var Hex = {
            stringify: function (wordArray) {
                var words = wordArray.words;
                var sigBytes = wordArray.sigBytes;

                var hexChars = [];
                for (var i = 0; i < sigBytes; i++) {
                    var bite = (words[i >>> 2] >>> (24 - (i % 4) * 8)) & 0xff;
                    hexChars.push((bite >>> 4).toString(16));
                    hexChars.push((bite & 0x0f).toString(16));
                }

                return hexChars.join('');
            },
            parse: function (hexStr) {
                var hexStrLength = hexStr.length;
                var words = [];
                for (var i = 0; i < hexStrLength; i += 2) {
                    words[i >>> 3] |= parseInt(hexStr.substr(i, 2), 16) << (24 - (i % 8) * 4);
                }

                return new WordArray.init(words, hexStrLength / 2);
            }
        };


        var Latin1 = {
            stringify: function (wordArray) {
                var words = wordArray.words;
                var sigBytes = wordArray.sigBytes;
                var latin1Chars = [];
                for (var i = 0; i < sigBytes; i++) {
                    var bite = (words[i >>> 2] >>> (24 - (i % 4) * 8)) & 0xff;
                    latin1Chars.push(String.fromCharCode(bite));
                }

                return latin1Chars.join('');
            },

            parse: function (latin1Str) {
                var latin1StrLength = latin1Str.length;
                var words = [];
                for (var i = 0; i < latin1StrLength; i++) {
                    words[i >>> 2] |= (latin1Str.charCodeAt(i) & 0xff) << (24 - (i % 4) * 8);
                }

                return new WordArray(words, latin1StrLength);
            }
        };

        var Utf8 = {
            stringify: function (wordArray) {
                try {
                    return decodeURIComponent(escape(Latin1.stringify(wordArray)));
                } catch (e) {
                    throw new Error('Malformed UTF-8 data');
                }
            },
            parse: function (utf8Str) {
                return Latin1.parse(unescape(encodeURIComponent(utf8Str)));
            }
        };


        var Base64 = function(map){
            this.map = map;
        }
        Base64.map = {};
        Base64.of = function(map){
            var m =  map || 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
            var b = Base64.map[m] ;
            if(!b){
                b = new Base64(m);
            }
            return b;
        }

        Base64.prototype = {
            decodeByte: function(base64Str){
                var base64StrLength = base64Str.length;
                var map = this.map;
                var paddingChar = map.charAt(64);
                if (paddingChar) {
                    var paddingIndex = base64Str.indexOf(paddingChar);
                    if (paddingIndex != -1) {
                        base64StrLength = paddingIndex;
                    }
                }
                var words = [];
                var nBytes = 0;
                for (var i = 0; i < base64StrLength; i++) {
                    if (i % 4) {
                        var bits1 = map.indexOf(base64Str.charAt(i - 1)) << ((i % 4) * 2);
                        var bits2 = map.indexOf(base64Str.charAt(i)) >>> (6 - (i % 4) * 2);
                        words[nBytes >>> 2] |= (bits1 | bits2) << (24 - (nBytes % 4) * 8);
                        nBytes++;
                    }
                }
                return new WordArray(words , nBytes);
            },
            
            decode: function(s){
                return Utf8.stringify(this.decodeByte(s));
            },
            
            encode: function(s){
                if(!s){  
                    return;  
                }
                return this.encodeByte(Utf8.parse(s));
                
            },
            
            encodeByte: function(wordArray){
                var words = wordArray.words;
                var sigBytes = wordArray.sigBytes;
                var map = this.map;
                wordArray.clamp();
                var base64Chars = [];
                for (var i = 0; i < sigBytes; i += 3) {
                    var byte1 = (words[i >>> 2]       >>> (24 - (i % 4) * 8))       & 0xff;
                    var byte2 = (words[(i + 1) >>> 2] >>> (24 - ((i + 1) % 4) * 8)) & 0xff;
                    var byte3 = (words[(i + 2) >>> 2] >>> (24 - ((i + 2) % 4) * 8)) & 0xff;

                    var triplet = (byte1 << 16) | (byte2 << 8) | byte3;

                    for (var j = 0; (j < 4) && (i + j * 0.75 < sigBytes); j++) {
                        base64Chars.push(map.charAt((triplet >>> (6 * (3 - j))) & 0x3f));
                    }
                }
                var paddingChar = map.charAt(64);
                if (paddingChar) {
                    while (base64Chars.length % 4) {
                        base64Chars.push(paddingChar);
                    }
                }
                return base64Chars.join('');
            }
        }
        
        try {
            iWebAssist = document.createElement("object");
            iWebAssist.setAttribute("width",1);
            iWebAssist.setAttribute("height",1);
            iWebAssist.setAttribute("id","iWebAssist");
            iWebAssist.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
            iWebAssist.setAttribute("classid","clsid:E99768C0-3DE2-4C53-AA41-188550CA66AC");
            document.documentElement.appendChild(iWebAssist);
	    } catch (e) {
	        alert("没有正确安装证书应用环境或证书应用环境已经损坏！");
	    }
    }
    
    try {
        //document.writeln('<OBJECT classid="clsid:2B92874C-DCA6-4641-AEA5-BAEDE459B41C" style="width:0%;height:0%;"  height="0"width="0"size="0"id="CMSSign" name="CMSSign"></OBJECT>');
        //调用控件接口：
        //CMSSign.Initialize("P11","111111");
        //document.writeln('<OBJECT classid="clsid:3F1A0364-AD32-4E2F-B550-14B878E2ECB1"  id="DMakeSealV61"  name="DMakeSealV61"  VIEWASTEXT width=0 height=0></OBJECT>');
        CMSSign = document.createElement("object");
        CMSSign.setAttribute("width",1);
        CMSSign.setAttribute("height",1);
        CMSSign.setAttribute("id","CMSSign");
        CMSSign.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
        CMSSign.setAttribute("classid","clsid:2B92874C-DCA6-4641-AEA5-BAEDE459B41C");
        document.documentElement.appendChild(CMSSign);
        
        DMakeSealV61 = document.createElement("object");
        DMakeSealV61.setAttribute("width",1);
        DMakeSealV61.setAttribute("height",1);
        DMakeSealV61.setAttribute("id","DMakeSealV61");
        DMakeSealV61.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
        DMakeSealV61.setAttribute("classid","clsid:3F1A0364-AD32-4E2F-B550-14B878E2ECB1");
        document.documentElement.appendChild(DMakeSealV61);
    } catch (e) {
        alert("没有正确安装证书应用环境或证书应用环境已经损坏！");
    }

    //var _EncryptedToken = "";

    /*function InitToken(token) {
        _EncryptedToken = token;
    }*/

    // 安徽CA返回串格式为    硬件UKey的SN(之后获取信息使用)|证书序列号|证书名称&..
    function GetUserList(){
        //var userList = "FakeUser1||8A1D45A5C4E189B7&&&FakeUser2||A8B9D7A20C12A401";
        var userList = "";
        var bRet = CMSSign.GetUKeyList();
        if (!bRet)
        {
            var strerr = CMSSign.GetLastErrorInfo(0);
            //alert("枚举key失败："+strerr + "没有设备！");
            return "";
        }
        var keylist = CMSSign.AllUKeyList;
        
        var arrkeylist = keylist.split("&");
        for (var i=0;i<arrkeylist.length-1;i++)
        {
            var arrUkeyInfo = arrkeylist[i].split("|");
            if (userList == "") {
                userList = arrUkeyInfo[2]+'||'+ arrUkeyInfo[0]
            }else {
                userList = userList + '&&&' + arrUkeyInfo[2]+'||'+ arrUkeyInfo[0]
            }
        }
        return userList;
    }

    //通过Ukey的SN获取证书序列号
    /*function GetCertNoByUserList(key) {
        var CertNo = "";
        var keylist = CMSSign.AllUKeyList;
        
        var arrkeylist = keylist.split("&");
        for (var i=0;i<arrkeylist.length-1;i++)
        {
            var arrUkeyInfo = arrkeylist[i].split("|");
            if (key == arrUkeyInfo[0]) {
                CertNo = arrUkeyInfo[1] ;
            }
        }
        return CertNo;
    }*/

    function HashData(inData){
        
        var ret = CMSSign.Digest(inData,3);
        if (ret) {
            return CMSSign.DigestData
        } else {
            var error = CMSSign.GetLastErrorInfo("0");
            alert(error);
            return "";
        }
    }

    function SignedData(content,key){  
        var bRet = CMSSign.Sign(content);//签名
        if (!bRet)
        {
            var strerr = CMSSign.GetLastErrorInfo(0);
            alert("签名失败："+strerr);
            return "";
        } else {
            return CMSSign.SignedData;
        }  
    }

    //判读是否登录过
    function SOF_IsLogin(key)
    {
        var ret = false;
        if (typeof CMSSign.IsLogIn !="undefined"  )
        {
            var flag = CMSSign.IsLogIn(key);
            if (flag) {
                var Pwd = CMSSign.DevPWD;
                var Ret = CMSSign.SelectUKey(key,Pwd);     //选择哪一个UKey
                if (Ret) {
                    ret = true;
                }
            }
        }
        return ret;
    }

    //获取Ukey证书
    function GetSignCert(key){
        CMSSign.GetUKeyList();
        var cert = CMSSign.GetCertFromUKey(key);
        return cert;
    }

    //获取用户唯一标识UsrCertCode  这里获取的身份证号
    function GetUniqueID(strCert) {
        //var strCert = GetSignCert(key);
        return CMSSign.GetCertInfo(strCert, "3003", '');
    }

    //获取用户身份证号
    function GetIdentityID(key) {
        var strCert = GetSignCert(key);
        return CMSSign.GetCertInfo(strCert, "3003", '');
    }

    //获取证书编号CertificateNo  这里获取的是证书序列号
    function GetCertNo(key) {
        var strCert = GetSignCert(key);
        return CMSSign.GetCertInfo(strCert, "3031", '');
        //return GetCertNoByUserList(key);
    }

    //证书序列号CertificateSN
    function GetCertSN(key) {
        var strCert = GetSignCert(key);
        return CMSSign.GetCertInfo(strCert, "3031", '');
        //return GetCertNoByUserList(key);
    }

    //UKey编号（介质编号）    获取证书序列号？？
    function GetKeySN(key) {
        return "";
    }

    //暂时没有提供根据Ukey获取签名图功能，暂不获取
    function GetPicBase64Data(key) {
        if (projectID == "AHMAS") {
            iWebAssist.SetParamByName('SOFTTYPE', '0');//标准版
            iWebAssist.SetParamByName('LICCODE', '08e39f7e8b0b62394f040746a17ca1f6');

            var keyInfo = iWebAssist.KGGetKeyInfo();   //key印章信息
            var obj=JSON.parse(keyInfo);
            var imgdata=obj.seals[0].imgdata;
            //图片base64
            var encry=obj.seals[0].signsn;		//非标准加密串
            imgdata = imgdata.substr(65);
            imgdata = Base64.of().encodeByte(Base64.of(encry).decodeByte(imgdata));
            
            return imgdata;
        } else {
            /*var isLoad = DMakeSealV61.LoadSeal(2,"",0);
            var vID = DMakeSealV61.GetNextSeal(0);
            DMakeSealV61.SelectSeal(vID);
            return DMakeSealV61.GetPreviewImg(1);
            */
            DMakeSealV61.SetValue("SET_FILTERSERIAL_CERTFROMSTORE",key);
            var isLoad = DMakeSealV61.LoadSeal(2,"",0);
            var vID = DMakeSealV61.GetNextSeal(0);
            DMakeSealV61.SelectSeal(vID);
            return DMakeSealV61.SaveCurrSealData();
        }
    }

    //获取证书名称        正式库为姓名+身份证号后六位
    function GetCertCNName(key) {
        var strCert = GetSignCert(key);
        return CMSSign.GetCertInfo(strCert, "3007", '');
    }

    function Login(strFormName, strCertID, strPin) {
        var Ret = CMSSign.SelectUKey(strCertID,strPin);     //选择哪一个UKey
        if (!Ret) {
            var strerr = CMSSign.GetLastErrorInfo(0);
            alert("选择key失败："+strerr);
            return false;
        }
        //InitToken(strPin);
        return true;
    }

    function CheckPWD(key, pwd) {
            return "";
        }
        
    function CheckForm(key, strServerCert, strServerRan, strServerSignedData) {
        return "";
    }

    function oGetLastError() {
        return CMSSign.GetLastErrorInfo(0);
    }
        
    function getUsrSignatureInfo(key){
        var usrSignatureInfo = new Array();
        //获取身份证号
        usrSignatureInfo["identityID"] = GetIdentityID(key);
        //获取Ukey证书
        usrSignatureInfo["certificate"] = GetSignCert(key);
        //获取证书编码  这里获取的是证书序列号
        usrSignatureInfo["certificateNo"] = GetCertNo(key);
        //获取证书序列号
        usrSignatureInfo["CertificateSN"] = GetCertSN(key);
        //UKey编号      获取空值
        usrSignatureInfo["uKeyNo"] = GetKeySN(key);
        //图片          获取空值
        usrSignatureInfo["signImage"] = GetPicBase64Data(key);
        //用户唯一标识  这里获取的是身份证号
        var certB64 = GetSignCert(key);
        usrSignatureInfo["UsrCertCode"] = GetUniqueID(certB64);
        //获取证书名称
        usrSignatureInfo["CertName"] = GetCertCNName(key);
        
        return usrSignatureInfo;
    }

	return {
    	OCX: CMSSign,
    	VenderCode:Const_Vender_Code,
    	SignType:Const_Sign_Type,
    	GetRealKey: function(key) {
	    	return key;
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
            return SignedData(contentHash, key)
        },
        getUsrSignatureInfo: function(key) {
            return getUsrSignatureInfo(key);
        },
        HashData:function(content){
	    	return HashData(content)  
	    },
	  	GetPicBase64Data:function(key) {
	    	return GetPicBase64Data(key);
		},
		GetLastError:function() {
	    	return oGetLastError();
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