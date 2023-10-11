//1.吉林安信当前只支持IE版本下获取图片
//2.获取图片时需要输入密码，当前写死初始密码111111
//3.不支持插入多个key获取图片，所以获取图片时增加控制只能有一个key
function ca_key_IE() {
    var Const_Vender_Code = "JLAX";
    var Const_Sign_Type = "UKEY";
    var Global_Last_Login_CertInfo = "";
    var Global_Last_Login_Token = "";
    var Global_Last_Login_SealInfo = "";
    var Global_Last_Error_Code = "";
    var Global_Last_Error_Msg = "";
    
    try {
        JITDSignOcx = document.createElement("object");
        JITDSignOcx.setAttribute("width",1);
        JITDSignOcx.setAttribute("height",1);
        JITDSignOcx.setAttribute("id","JITDSignOcx");
        JITDSignOcx.setAttribute("codeBase","JITComVCTK_S.cab#version=2.0");
        JITDSignOcx.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;display:none;");
        JITDSignOcx.setAttribute("classid","clsid:B0EF56AD-D711-412D-BE74-A751595F3633");
        document.documentElement.appendChild(JITDSignOcx);
        
        JITSeal = document.createElement("object");
        JITSeal.setAttribute("width",1);
        JITSeal.setAttribute("height",1);
        JITSeal.setAttribute("id","JITSeal");
        JITSeal.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;display:none;");
        JITSeal.setAttribute("classid","clsid:6FA144DC-ADDC-45EE-B5D5-7F8888F92C36");
        document.documentElement.appendChild(JITSeal);        
    } catch (e) {
        alert("没有正确安装证书应用环境或证书应用环境已经损坏！");
    }
    
    var InitParam = "<?xml version=\"1.0\" encoding=\"utf-8\"?>"+"<authinfo><liblist>"+
        "<lib type=\"SKF\" version=\"1.1\" dllname=\"bXRva2VuX2dtMzAwMF9wY3NjLmRsbA==\" ><algid val=\"SHA1\" sm2_hashalg=\"sm3\"/></lib>"+                                        
        "</liblist></authinfo>"; 
    
    function GetUserList(){
        JITDSignOcx.Initialize(InitParam);
        if (JITDSignOcx.GetErrorCode() != 0) {
            alert('初始化失败，错误信息：' + JITDSignOcx.GetErrorMessage(JITDSignOcx.GetErrorCode()));
            JITDSignOcx.Finalize();
            return "";
        }
        
        var result = ""
        strCertDN = JITDSignOcx.GetCertList("SC", "", "", "", "", -1);
        if (strCertDN == "") 
        {
            message = JITDSignOcx.GetErrorMessage(ret);
            alert("请插入电子钥匙");
            return "";
        }   
        result = strCertDN.split(',')[0].substring(3)+"||"+strCertDN;
        while (strCertDN != "") 
        {
            strCertDN = JITDSignOcx.GetCertList("SC", "", "", "", "", -1);
            if (strCertDN != "")
            {
                result = result + "&&&" + strCertDN.split(',')[0].substring(3)+"||"+strCertDN;
            }
        }
        /*
        JITHTTPCLIENT.Finalize();
        */
        tempSc = "";
        return result;
    }
    
    function selectCert(key,cert) {
        JITDSignOcx.SetCertChooseType(1);//不弹出证书选择框
        ret = JITDSignOcx.GetErrorCode();
        if (ret != 0) {
            message = JITDSignOcx.GetErrorMessage(ret);
            alert("设置证书选择类型失败，错误码：" + ret + " 错误信息：" + message);
            return false;
        }
        
        if (tempSc != key)
        {
            var ret = JITDSignOcx.SetCert("SC", key, "", "","", "");//可筛选证书
            JITDSignOcx.GetErrorCode();
            if (JITDSignOcx.GetErrorCode() != 0) {
                alert('选择证书失败，错误信息：' + JITDSignOcx.GetErrorMessage(JITDSignOcx.GetErrorCode()));
                JITDSignOcx.Finalize();
                return false;
            }
            return true;
        }else {
            return true;
        }
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
            global:false,
            async: false,
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
    
    function HashData(inData) {
        var rtn = iGetData("HashData",inData);
        if ((rtn.retCode == "0")) {
            return rtn.hashData;
        } else {
            Global_Last_Error_Msg = rtn.retMsg;
            return "";
        }
    }
    
    //十六进制的ascII码转换成字符串
    function AscToStr(asc){
        tmp=asc.split(" ");
        tmp_str="";
        for(i=6;i<tmp.length;i++){//去掉前几位乱字符
            tmp_str+=String.fromCharCode(parseInt(tmp[i],16));
        }
        return tmp_str;
    }    
    
    function SignedData(content,key){  
        if (tempSc == "")
            tempSc = key;
        if (selectCert(key)) {     
            var result = JITDSignOcx.DetachSignStr("",content);
            ret = JITDSignOcx.GetErrorCode();
            if (ret != 0) {
                message = JITDSignOcx.GetErrorMessage(ret);
                alert("签名失败，错误码：" + ret + " 错误信息：" + message);
                return '';
            }
            tempSc = key;
            return result;
        }
        return "";
    }

    //判读是否登录过
    function SOF_IsLogin(key) {
        return false;
    }

    //获取Ukey证书
    function GetSignCert(key){
        if (selectCert(key)) {
            var result = JITDSignOcx.GetCertInfo("SC",8,"");
            ret = JITDSignOcx.GetErrorCode();
            if (ret != 0) {
                message = JITDSignOcx.GetErrorMessage(ret);
                alert("签名失败，错误码：" + ret + " 错误信息：" + message);
                return '';
            }
            return result;
        }
        return "";
    }

    //获取用户唯一标识UsrCertCode  这里获取的身份证号
    function GetUniqueID(cert,key) {
        if (selectCert(key)) {
            var result = JITDSignOcx.GetCertInfo("SC",7,"1.2.86.11.7.1");
            ret = JITDSignOcx.GetErrorCode();
            if (ret != 0) {
                message = JITDSignOcx.GetErrorMessage(ret);
                alert("签名失败，错误码：" + ret + " 错误信息：" + message);
                return '';
            }
            return AscToStr(result);
        }
        return "";
    }

    //获取用户身份证号
    function GetIdentityID(key) {
        return "";
    }

    //获取证书编号CertificateNo  这里获取的是证书序列号
    function GetCertNo(key) {
        if (selectCert(key)) {
            var result = JITDSignOcx.GetCertInfo("SC",2,"");
            ret = JITDSignOcx.GetErrorCode();
            if (ret != 0) {
                message = JITDSignOcx.GetErrorMessage(ret);
                alert("签名失败，错误码：" + ret + " 错误信息：" + message);
                return '';
            }
            return result;
        }
        return "";
    }

    //证书序列号CertificateSN
    function GetCertSN(key) {
        return GetCertNo(key);
    }

    //UKey编号(介质编号)
    function GetKeySN(key) {
        return "";
    }

    //获取图片时需要输入密码，当前写死初始密码111111
    function GetPicBase64Data(key) {
        var result = "";
        try {
            result = JITSeal.ReadImageData("ANXINLONGMAIGM","111111");
        }catch(e) {
            result = "";
        }
        return result;
    }

    //获取证书名称
    function GetCertCNName(key) {
        if (selectCert(key)) {
            var result = JITDSignOcx.GetCertInfo("SC",9,"");
            ret = JITDSignOcx.GetErrorCode();
            if (ret != 0) {
                message = JITDSignOcx.GetErrorMessage(ret);
                alert("签名失败，错误码：" + ret + " 错误信息：" + message);
                return '';
            }
            return result;
        }
        return "";
    }

    function Login(form_,key,password_) {
        GetUserList();
        if (selectCert(key)) {
            JITDSignOcx.setpincode(password_);
            ret = JITDSignOcx.GetErrorCode();
            if (ret != 0) {
                message = JITDSignOcx.GetErrorMessage(ret);
                alert("通过证书DN选择证书失败，错误码：" + ret + " 错误信息：" + message);
                return false;
            }
            tempSc = key;
            return true;
        }
        return false;
    }

    function CheckPWD(key, pwd) {
        return "";
    }
        
    function CheckForm(key, strServerCert, strServerRan, strServerSignedData) {
        return "";
    }

    function oGetLastError() {
        return JITDSignOcx.GetErrorCode();
    }
        
    function getUsrSignatureInfo(key){
        var usrSignatureInfo = new Array();
        //不支持插入多个key获取图片，所以获取图片时增加控制只能有一个key
        var result = "";
        strCertDN = JITDSignOcx.GetCertList("SC", "", "", "", "", -1);
        result = strCertDN;
        while (strCertDN != "") 
        {
            strCertDN = JITDSignOcx.GetCertList("SC", "", "", "", "", -1);
            if (strCertDN != "")
            {
                result = result + "&&&" + strCertDN;
            }
        }
        
        var count = result.split('&&&').length
        if (count > 1) {
            alert("由于获取CA图片不支持多key操作，关联证书时不可插入多个key，请拔出多余Ukey后在进行操作！");
            return usrSignatureInfo;
        }
        
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
        usrSignatureInfo["UsrCertCode"] = GetUniqueID(certB64,key);
        //获取证书名称
        usrSignatureInfo["CertName"] = GetCertCNName(key);
        
        return usrSignatureInfo;
    }

    return {
        OCX: JITDSignOcx,
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
}

function ca_key_CHROME() {
    
    var Const_Vender_Code = "JLAX";
    var Const_Sign_Type = "UKEY";
    var Global_Last_Login_CertInfo = "";
    var Global_Last_Login_Token = "";
    var Global_Last_Login_SealInfo = "";
    var Global_Last_Error_Code = "";
    var Global_Last_Error_Msg = "";
    
    var JITHTTPCLIENT = function () {
        var xmlHttp = null;
        var url = "http://127.0.0.1:45679";          
        var FinalizeCmd = "{\"name\": \"Finalize\"}";    
        var ClearPinCodeCmd = "{\"name\": \"ClearPinCode\"}";        
        var GeterrocodeCmd = "{\"name\": \"GetErrorCode\"}";    
        var GetDataCmd = "{\"name\": \"GetData\"}";    
        var GetVersionCmd = "{\"name\": \"JITGetVersion\"}";
        var GetMacCmd = "{\"name\": \"JITGetMAC\"}";    
        
        function createXmlHttp() {
              var temphttp = null;  
              //用来判断浏览器是否支持ActiveX控件
            //"ActiveXObject" in window是为了兼容IE11，IE11不支持window.ActiveXObject，会提示undefined   
            if (window.ActiveXObject || "ActiveXObject" in window) {
                var arr = new Array("Microsoft.XMLHTTP", "MSXML2.XMLHTTP.6.0", "MSXML2.XMLHTTP.5.0", "MSXML2.XMLHTTP.4.0", "MSXML2.XMLHTTP.3.0", "MSXML2.XMLHTTP.2.6", "MSXML2.XMLHTTP");
                for (var i = 0; i < arr.length; i++) {
                    try {
                        temphttp = new ActiveXObject(arr[i]);
                        break;
                    } catch (e) {
                        alert(e.message);
                    }
                }
            } else if (window.XMLHttpRequest) {
                temphttp = new XMLHttpRequest();
            }
            return temphttp;   
        } 
        
        function _sleep(numberMillis) {
                    var now = new Date();
                    var exitTime = now.getTime() + numberMillis;
                    while (true) {
                        now = new Date();
                        if (now.getTime() > exitTime)
                        return;
              }
        }
        
        function DisConn() {
            xmlHttp.abort();
        }
        
        function Ajax(senddata) { 
              var errormsg = "{\"error\":999,\"value\":\"与服务断开连接\"}";  
            //1.创建Ajax对象
            xmlHttp = createXmlHttp();
            
                //2.连接服务器 open方法只是启动一个请求以备发送，还未发送
            xmlHttp.open("POST", url, false);//false: 同步
            
            //打开下面这句可以测试chrome OPTIONS 跨域
            //xmlHttp.setRequestHeader('content-type','application/json');
            
            //3.发送请求    
            try{
                //console.log("senddata: " + senddata);
                    xmlHttp.send(senddata);   
                  }catch(e) {
                  //console.log("DisConn Exception: " + e + ", status = " + xmlHttp.status + ", responseText: " + xmlHttp.responseText);
                      DisConn();    
                    
              return errormsg;            
                  };       
                  
            //4.接收返回值 和服务器通讯的时候此事件发生     
            if(xmlHttp.readyState == 4 && (xmlHttp.status == 200 || xmlHttp.status == 0))
            {
                if (xmlHttp.responseText == null) 
                {
                    return errormsg;
                }                
                return xmlHttp.responseText;
            }else{
                  //console.log("return: " + xmlHttp.status + "===" +senddata + "==="+xmlHttp.responseText+"==="+xmlHttp.readyState);
                        return errormsg;    
            }       
        }
             
          function _Getretcode(Cmdname){
            var ret = -1;
            var str = Ajax(Cmdname);
              ret = JSON.parse(str).error;
            return ret;          
          }
          
          function _Getretmsg(Cmdname){
            var ret = "";
            var str = Ajax(Cmdname);
              ret = JSON.parse(str).value;
            return ret;          
          }      
          
          function _Getretvalue(Cmdname){
            var ret = "";
            var str = Ajax(Cmdname);
              ret = "返回信息："+JSON.parse(str).value + "     返回错误码："+JSON.parse(str).error;
            return ret;          
          }    
      
          
          return {
                 //common
                         Initialize: function (strinitParam) {
                              var InitCmd = "{\"name\": \"Initialize\", \"p1\": \""+strinitParam+"\"}";
                              return _Getretcode(InitCmd);
               },
               Finalize: function () {
                    return _Getretcode(FinalizeCmd);
               },
               RegisterParam: function (strinitParam) {
                              var RegisterParamCmd = "{\"name\": \"RegisterParam\", \"p1\": \""+strinitParam+"\"}";
                              return _Getretcode(RegisterParamCmd);
               },
               GetErrorCode: function () {
                    return _Getretcode(GeterrocodeCmd);
               },
               GetErrorMessage: function (errorcode) {
                  var GeterromessageCmd = "{\"name\": \"GetErrorMessage\", \"p1\": \""+errorcode+"\"}";
                    return _Getretmsg(GeterromessageCmd);
               },        
               VerifyPinCode: function  (strPinCode, strNewPinCode) {
                  var VerifyPinCodeParamCmd = "{\"name\": \"VerifyPinCode\", \"p1\": \""+strPinCode+"\", \"p2\": \""+strNewPinCode+"\"}";
                              return _Getretcode(VerifyPinCodeParamCmd);
               },  
               //org
               SetCertChooseType: function (types) {
                    var SetCertChooseTypeCmd = "{\"name\": \"SetCertChooseType\", \"p1\": "+types+"}";
                    return _Getretcode(SetCertChooseTypeCmd);    
               },           
               ClearPinCode: function () {
                    return _Getretcode(ClearPinCodeCmd);
               },
               SetPinCode: function (strpincode) {
                  var SetPinCodeCmd = "{\"name\": \"SetPinCode\", \"p1\": \""+strpincode+"\"}";
                    return _Getretcode(SetPinCodeCmd);
               },
               SetCert: function (strCertType,strDN,strSN,strEmail,strDNIssuer,strCertBase64){
                    var SetCertCmd = "{\"name\": \"SetCert\", \"p1\": \""+strCertType+"\", \"p2\": \""+strDN+"\", \"p3\": \""+strSN+"\", \"p4\": \""+strEmail+"\", \"p5\": \""+strDNIssuer+"\", \"p6\": \""+strCertBase64+"\"}";
                    return _Getretcode(SetCertCmd);    
               },
               SetCert2: function (strCertType,strDN,strSN,strEmail,strDNIssuer,strCertBase64,strCertNameType){
                    var SetCert2Cmd = "{\"name\": \"SetCert2\", \"p1\": \""+strCertType+"\", \"p2\": \""+strDN+"\", \"p3\": \""+strSN+"\", \"p4\": \""+strEmail+"\", \"p5\": \""+strDNIssuer+"\", \"p6\": \""+strCertBase64+"\", \"p7\": \""+strCertNameType+"\"}";
                    return _Getretcode(SetCert2Cmd);    
               },
               SetCertEx: function (strCertStoreType, strCertType,strDN,strSN,strEmail,strDNIssuer,strCertBase64){
                    var SetCertExCmd = "{\"name\": \"SetCertEx\", \"p1\": \""+strCertStoreType+"\", \"p2\": \""+strCertType+"\", \"p3\": \""+strDN+"\", \"p4\": \""+strSN+"\", \"p5\": \""+strEmail+"\", \"p6\": \""+strDNIssuer+"\", \"p7\": \""+strCertBase64+"\"}";
                    return _Getretcode(SetCertExCmd);    
               },
               P1SignStr: function (strdn,strsrc) {
                  var P1SignStrCmd = "{\"name\": \"P1SignStr\", \"p1\": \""+strdn+"\", \"p2\": \""+strsrc+"\"}";
                    return _Getretmsg(P1SignStrCmd);
               },
               AttachSignStr: function (strdn,strsrc) {
                  var AttachSignStrCmd = "{\"name\": \"AttachSignStr\", \"p1\": \""+strdn+"\", \"p2\": \""+strsrc+"\"}";
                    return _Getretmsg(AttachSignStrCmd);
               },
               DetachSignStr: function (strdn,strsrc) {
                  var DetachSignStrCmd = "{\"name\": \"DetachSignStr\", \"p1\": \""+strdn+"\", \"p2\": \""+strsrc+"\"}";
                    return _Getretmsg(DetachSignStrCmd);
               },
               VerifyAttachedSign: function (strSignedData) {
                  var VerifyAttachedSignCmd = "{\"name\": \"VerifyAttachedSign\", \"p1\": \""+strSignedData+"\"}";
                    return _Getretcode(VerifyAttachedSignCmd);
               },           
               VerifyDetachedSignStr: function (strSignedData,strsrc) {
                  var VerifyDetachedSignStrCmd = "{\"name\": \"VerifyDetachedSignStr\", \"p1\": \""+strSignedData+"\", \"p2\": \""+strsrc+"\"}";
                    return _Getretcode(VerifyDetachedSignStrCmd);
               },
               EncryptEnvelopStr: function (strdn,strsrc) {
                  var EncryptEnvelopStrCmd = "{\"name\": \"EncryptEnvelopStr\", \"p1\": \""+strdn+"\", \"p2\": \""+strsrc+"\"}";
                    return _Getretmsg(EncryptEnvelopStrCmd);
               },
               DecryptEnvelop: function (strEnvelop) {
                  var DecryptEnvelopStrCmd = "{\"name\": \"DecryptEnvelop\", \"p1\": \""+strEnvelop+"\"}";
                    return _Getretcode(DecryptEnvelopStrCmd);
               },
               Digest: function (strSrcData) {
                  var DigestCmd = "{\"name\": \"Digest\", \"p1\": \""+strSrcData+"\"}";
                    return _Getretmsg(DigestCmd);
               },
               CreateSignedEnvelopStr: function (strSignCertDN, strEncCertDN, strSrc) {
                  var CreateSignedEnvelopStrCmd = "{\"name\": \"CreateSignedEnvelopStr\", \"p1\": \""+strSignCertDN+"\", \"p2\": \""+strEncCertDN+"\", \"p3\": \""+strSrc+"\"}";
                    return _Getretmsg(CreateSignedEnvelopStrCmd);
               },
               VerifySignedEnvelop: function (strEnvelop) {
                  var VerifySignedEnvelopCmd = "{\"name\": \"VerifySignedEnvelop\", \"p1\": \""+strEnvelop+"\"}";
                    return _Getretcode(VerifySignedEnvelopCmd);
               },
               GetCertInfo: function (strCertType,lInfoType,strOID){
                    var GetCertInfoCmd = "{\"name\": \"GetCertInfo\", \"p1\": \""+strCertType+"\", \"p2\": "+lInfoType+", \"p3\": \""+strOID+"\"}";    
                    return _Getretmsg(GetCertInfoCmd);
               },           
               SetAlgorithm: function (strHashAlg, strEncAlg){ 
                  var SetAlgorithmCmd = "{\"name\": \"SetAlgorithm\", \"p1\": \""+strHashAlg+"\", \"p2\": \""+strEncAlg+"\"}";                          
                    return _Getretcode(SetAlgorithmCmd);
               },
               SymmetricEncrypt: function (strSymmetricKey, strSrcData, isPad){ 
                  var SymmetricEncryptCmd = "{\"name\": \"SymmetricEncrypt\", \"p1\": \""+strSymmetricKey+"\", \"p2\": \""+strSrcData+"\", \"p3\": "+isPad+"}";                          
                    return _Getretmsg(SymmetricEncryptCmd);
               },
               SymmetricDecrypt: function (strSymmetricKey, strEncryptData, isPad){ 
                  var SymmetricDecryptCmd = "{\"name\": \"SymmetricDecrypt\", \"p1\": \""+strSymmetricKey+"\", \"p2\": \""+strEncryptData+"\", \"p3\": "+isPad+"}";                          
                    return _Getretmsg(SymmetricDecryptCmd);
               },
               GetCertList: function (strCertType, strCertDN, strCertSN, strCertEmail, strCertIssuerDN, lInfoType){ 
                  var GetCertListCmd = "{\"name\": \"GetCertList\", \"p1\": \""+strCertType+"\", \"p2\": \""+strCertDN+"\", \"p3\": \""+strCertSN+"\", \"p4\": \""+strCertEmail+"\", \"p5\": \""+strCertIssuerDN+"\", \"p6\": "+lInfoType+"}";                          
                    return _Getretmsg(GetCertListCmd);
               },
               GetCertLists: function (strCertType, strCertDN, strCertSN, strCertEmail, strCertIssuerDN, lInfoType){ 
                  var GetCertListsCmd = "{\"name\": \"GetCertLists\", \"p1\": \""+strCertType+"\", \"p2\": \""+strCertDN+"\", \"p3\": \""+strCertSN+"\", \"p4\": \""+strCertEmail+"\", \"p5\": \""+strCertIssuerDN+"\", \"p6\": "+lInfoType+"}";                          
                    return _Getretmsg(GetCertListsCmd);
               },
               SetCertByBase64: function (strBase64){ 
                  var SetCertByBase64Cmd = "{\"name\": \"SetCertByBase64\", \"p1\": \""+strBase64+"\"}";                          
                    return _Getretcode(SetCertByBase64Cmd);
               }, 
               ChangeCertDN: function (strCertDN, lChangeFlag){ 
                  var ChangeCertDNCmd = "{\"name\": \"ChangeCertDN\", \"p1\": \""+strCertDN+"\", \"p2\": "+lChangeFlag+"}";                          
                    return _Getretmsg(ChangeCertDNCmd);
               },          
               GetVersion: function (){                       
                    return _Getretmsg(GetVersionCmd);
               },
               GetMac: function (){                       
                    return _Getretmsg(GetMacCmd);
               },
               GetData: function (){                       
                    return _Getretmsg(GetDataCmd);
               },
               CheckCertIsExist: function(strCertSN){ 
                  var CheckCertIsExistCmd = "{\"name\": \"CheckCertIsExist\", \"p1\": \""+strCertSN+"\"}";                     
                    return _Getretvalue(CheckCertIsExistCmd);
               },            
               AttachSignStr_Batch: function (types,strCertType,strDN,strSN,strEmail,strDNIssuer,strCertBase64,strpincode, strdn,strsrc) {                     
                                var AttachSignStr_BatchCmd ="{\"name\": \"BatchCmd\", "+
                                              "\"Items\": [{\"name\": \"SetCertChooseType\", \"p1\": "+types+"},"+
                                                                                    "{\"name\": \"SetCert\", \"p1\": \""+strCertType+"\", \"p2\": \""+strDN+"\", \"p3\": \""+strSN+"\", \"p4\": \""+strEmail+"\", \"p5\": \""+strDNIssuer+"\", \"p6\": \""+strCertBase64+"\"},"+
                                                                                    "{\"name\": \"AttachSignStr\", \"p1\": \""+strdn+"\", \"p2\": \""+strsrc+"\"}]}";                                                                                     
                    return _Getretvalue(AttachSignStr_BatchCmd);
               },   
               VerifyAttachedSign_Batch: function (strSignedData) {                     
                  var VerifyAttachedSign_BatchCmd ="{\"name\": \"BatchCmd\", "+
                                                   "\"Items\": [{\"name\": \"VerifyAttachedSign\", \"p1\": \""+strSignedData+"\"}]}";    
                    return _Getretvalue(VerifyAttachedSign_BatchCmd);
               },        
               //file           
               DigestFromFile: function (strSrcFileName) {  
                  var strFileName = strSrcFileName.replace(/\\/g,'\\\\');               
                  var DigestFromFileCmd = "{\"name\": \"DigestFromFile\", \"p1\": \""+strFileName+"\"}";
                    return _Getretmsg(DigestFromFileCmd);
               },
               SetFileNameUseUTF8: function (isUTF8) {                
                  var SetFileNameUseUTF8Cmd = "{\"name\": \"SetFileNameUseUTF8\", \"p1\": "+isUTF8+"}";
                    return _Getretcode(SetFileNameUseUTF8Cmd);
               },
               AttachSignEx: function (strDN, strFileName, strFileNameOut) {
                  var strFileName1 = strFileName.replace(/\\/g,'\\\\');   
                  var strFileName2 = strFileNameOut.replace(/\\/g,'\\\\');                   
                  var AttachSignExCmd = "{\"name\": \"AttachSignEx\", \"p1\": \""+strDN+"\", \"p2\": \""+strFileName1+"\", \"p3\": \""+strFileName2+"\"}";
                    return _Getretmsg(AttachSignExCmd);
               },
               VerifyAttachedSignEx: function (strFileNameAttached) {
                  var strFileName = strFileNameAttached.replace(/\\/g,'\\\\');   
                  var VerifyAttachedSignCmd = "{\"name\": \"VerifyAttachedSignEx\", \"p1\": \""+strFileName+"\"}";
                    return _Getretcode(VerifyAttachedSignCmd);
               },
               GetFile: function (strFileSavePath) {
                  var strFileName = strFileSavePath.replace(/\\/g,'\\\\');   
                  var GetFileCmd = "{\"name\": \"GetFile\", \"p1\": \""+strFileName+"\"}";
                    return _Getretmsg(GetFileCmd);
               },
               JITVerifyAttachFromFile_BigData: function (strInFileName, strOutFilePath) {
                  var strFileName1 = strInFileName.replace(/\\/g,'\\\\');   
                  var strFileName2 = strOutFilePath.replace(/\\/g,'\\\\'); 
                  var JITVerifyAttachFromFile_BigDataCmd = "{\"name\": \"JITVerifyAttachFromFile_BigData\", \"p1\": \""+strFileName1+"\", \"p2\": \""+strFileName2+"\"}";
                    return _Getretcode(JITVerifyAttachFromFile_BigDataCmd);
               },
               JITAttachFromFile_BigData: function (strCertDN, strSrcFileName, strOutFileName) {
                  var strFileName1 = strSrcFileName.replace(/\\/g,'\\\\');   
                  var strFileName2 = strOutFileName.replace(/\\/g,'\\\\'); 
                  var JITAttachFromFile_BigDataCmd = "{\"name\": \"JITAttachFromFile_BigData\", \"p1\": \""+strCertDN+"\", \"p2\": \""+strFileName1+"\", \"p3\": \""+strFileName2+"\"}";
                    return _Getretcode(JITAttachFromFile_BigDataCmd);
               },
               DetachSignEx: function (strDN, strFileName, strFileNameOut) {
                  var strFileName1 = strFileName.replace(/\\/g,'\\\\');   
                  var strFileName2 = strFileNameOut.replace(/\\/g,'\\\\');                   
                  var DetachSignExCmd = "{\"name\": \"DetachSignEx\", \"p1\": \""+strDN+"\", \"p2\": \""+strFileName1+"\", \"p3\": \""+strFileName2+"\"}";
                    return _Getretmsg(DetachSignExCmd);
               },
               JITDetachFromFile_BigData: function (strCertDN, strSrcFileName, strOutFileName) {
                  var strFileName1 = strSrcFileName.replace(/\\/g,'\\\\');   
                  var strFileName2 = strOutFileName.replace(/\\/g,'\\\\'); 
                  var JITDetachFromFile_BigDataCmd = "{\"name\": \"JITDetachFromFile_BigData\", \"p1\": \""+strCertDN+"\", \"p2\": \""+strFileName1+"\", \"p3\": \""+strFileName2+"\"}";
                    return _Getretcode(JITDetachFromFile_BigDataCmd);
               },
               JITDetachFromFile_BigData_Val: function (strCertDN, strSrcFileName, strOutFileName) {
                  var strFileName1 = strSrcFileName.replace(/\\/g,'\\\\');   
                  var strFileName2 = strOutFileName.replace(/\\/g,'\\\\'); 
                  var JITDetachFromFile_BigData_ValCmd = "{\"name\": \"JITDetachFromFile_BigData_Val\", \"p1\": \""+strCertDN+"\", \"p2\": \""+strFileName1+"\", \"p3\": \""+strFileName2+"\"}";
                    return _Getretmsg(JITDetachFromFile_BigData_ValCmd);
               },
               VerifyDetachedSignEx: function (strSignedData, strFileNameDetached, strFileName) {
                  var strFileName1 = strFileNameDetached.replace(/\\/g,'\\\\');   
                  var strFileName2 = strFileName.replace(/\\/g,'\\\\'); 
                  var VerifyDetachedSignExCmd = "{\"name\": \"VerifyDetachedSignEx\", \"p1\": \""+strSignedData+"\", \"p2\": \""+strFileName1+"\", \"p3\": \""+strFileName2+"\"}";
                    return _Getretcode(VerifyDetachedSignExCmd);
               },
               JITVerifyDetachFromFile_BigData: function (strSrcFileName, strSignFileName) {
                  var strFileName1 = strSrcFileName.replace(/\\/g,'\\\\');   
                  var strFileName2 = strSignFileName.replace(/\\/g,'\\\\'); 
                  var JITVerifyDetachFromFile_BigDataCmd = "{\"name\": \"JITVerifyDetachFromFile_BigData\", \"p1\": \""+strFileName1+"\", \"p2\": \""+strFileName2+"\"}";
                    return _Getretcode(JITVerifyDetachFromFile_BigDataCmd);
               },
               CreateSignedEnvelopEx: function (strSignCertDN, strEncCertDN, strFileName, strFileNameOut) {
                  var strFileName1 = strFileName.replace(/\\/g,'\\\\');   
                  var strFileName2 = strFileNameOut.replace(/\\/g,'\\\\');                   
                  var CreateSignedEnvelopExCmd = "{\"name\": \"CreateSignedEnvelopEx\", \"p1\": \""+strSignCertDN+"\", \"p2\": \""+strEncCertDN+"\", \"p3\": \""+strFileName1+"\", \"p4\": \""+strFileName2+"\"}";
                    return _Getretmsg(CreateSignedEnvelopExCmd);
               },
               JITSignEnvelopeFromFile_BigData: function (strSignCertDN, strEncCertDN, strSrcFileName, strOutFileName) {
                  var strFileName1 = strSrcFileName.replace(/\\/g,'\\\\');   
                  var strFileName2 = strOutFileName.replace(/\\/g,'\\\\');                   
                  var JITSignEnvelopeFromFile_BigDataCmd = "{\"name\": \"JITSignEnvelopeFromFile_BigData\", \"p1\": \""+strSignCertDN+"\", \"p2\": \""+strEncCertDN+"\", \"p3\": \""+strFileName1+"\", \"p4\": \""+strFileName2+"\"}";
                    return _Getretmsg(JITSignEnvelopeFromFile_BigDataCmd);
               },
               VerifySignedEnvelopEx: function (strEvpFile) {
                  var strFileName = strEvpFile.replace(/\\/g,'\\\\');  
                  var VerifySignedEnvelopExCmd = "{\"name\": \"VerifySignedEnvelopEx\", \"p1\": \""+strFileName+"\"}";
                    return _Getretcode(VerifySignedEnvelopExCmd);    
               },
               JITDecryptSignEnvelopeFromFile_BigData: function (strInFileName, strOutFilePath) {
                  var strFileName1 = strInFileName.replace(/\\/g,'\\\\');   
                  var strFileName2 = strOutFilePath.replace(/\\/g,'\\\\'); 
                  var JITDecryptSignEnvelopeFromFile_BigDataCmd = "{\"name\": \"JITDecryptSignEnvelopeFromFile_BigData\", \"p1\": \""+strFileName1+"\", \"p2\": \""+strFileName2+"\"}";
                    return _Getretcode(JITDecryptSignEnvelopeFromFile_BigDataCmd);
               },
               SymmetricEncryptFromFile: function (strSymmetricKey, strSrcFileName, strEncryptFileName,  isPad) {
                  var strFileName1 = strSrcFileName.replace(/\\/g,'\\\\');   
                  var strFileName2 = strEncryptFileName.replace(/\\/g,'\\\\');                   
                  var SymmetricEncryptFromFileCmd = "{\"name\": \"SymmetricEncryptFromFile\", \"p1\": \""+strSymmetricKey+"\", \"p2\": \""+strFileName1+"\", \"p3\": \""+strFileName2+"\", \"p4\": "+isPad+"}";
                    return _Getretcode(SymmetricEncryptFromFileCmd);
               },
               SymmetricDecryptFromFile: function (strSymmetricKey, strEncryptFileName, strSrcFileName,  isPad ) {
                  var strFileName1 = strEncryptFileName.replace(/\\/g,'\\\\');   
                  var strFileName2 = strSrcFileName.replace(/\\/g,'\\\\');                   
                  var SymmetricDecryptFromFileCmd = "{\"name\": \"SymmetricDecryptFromFile\", \"p1\": \""+strSymmetricKey+"\", \"p2\": \""+strFileName1+"\", \"p3\": \""+strFileName2+"\", \"p4\": "+isPad+"}";
                    return _Getretcode(SymmetricDecryptFromFileCmd);
               },   
               EncryptEnvelopEx: function (strDN, strFileName, strFileNameOut) {
                  var strFileName1 = strFileName.replace(/\\/g,'\\\\');   
                  var strFileName2 = strFileNameOut.replace(/\\/g,'\\\\');                   
                  var EncryptEnvelopExCmd = "{\"name\": \"EncryptEnvelopEx\", \"p1\": \""+strDN+"\", \"p2\": \""+strFileName1+"\", \"p3\": \""+strFileName2+"\"}";
                    return _Getretmsg(EncryptEnvelopExCmd);
               },
               DecryptEnvelopEx: function (strFileName) {
                  var strFileName = strFileName.replace(/\\/g,'\\\\');                     
                  var DecryptEnvelopExCmd = "{\"name\": \"DecryptEnvelopEx\", \"p1\": \""+strFileName+"\"}";
                    return _Getretcode(DecryptEnvelopExCmd);
               },
               JITCreateEnvelopeFromFile_BigData: function (strDN, strFileName, strFileNameOut) {
                  var strFileName1 = strFileName.replace(/\\/g,'\\\\');   
                  var strFileName2 = strFileNameOut.replace(/\\/g,'\\\\');                   
                  var JITCreateEnvelopeFromFile_BigDataCmd = "{\"name\": \"JITCreateEnvelopeFromFile_BigData\", \"p1\": \""+strDN+"\", \"p2\": \""+strFileName1+"\", \"p3\": \""+strFileName2+"\"}";
                    return _Getretcode(JITCreateEnvelopeFromFile_BigDataCmd);
               },
               JITDecryptEnvelopeFromFile_BigData: function (strInFileName, strOutFilePath) {
                  var strFileName1 = strInFileName.replace(/\\/g,'\\\\');   
                  var strFileName2 = strOutFilePath.replace(/\\/g,'\\\\'); 
                  var JITDecryptEnvelopeFromFile_BigDataCmd = "{\"name\": \"JITDecryptEnvelopeFromFile_BigData\", \"p1\": \""+strFileName1+"\", \"p2\": \""+strFileName2+"\"}";
                    return _Getretcode(JITDecryptEnvelopeFromFile_BigDataCmd);
               }
               
                               
           }
    }();

    function GetUserList(){
        var InitParam = "<?xml version=\\\"1.0\\\" encoding=\\\"utf-8\\\"?>"+
                "<authinfo><liblist>"+
                "<lib type=\\\"SKF\\\" version=\\\"1.1\\\" dllname=\\\"bXRva2VuX2dtMzAwMF9wY3NjLmRsbA==\\\" ><algid val=\\\"SHA1\\\" sm2_hashalg=\\\"sm3\\\"/></lib>"+                                        
                "</liblist></authinfo>"; 

        var ret = JITHTTPCLIENT.RegisterParam(InitParam);
        if (ret != 0) {
            if (ret == 100) {
                alert("数据格式错误");
            } else if (ret == 500) {
                alert("业务处理中");
            } else {
                ret = JITHTTPCLIENT.GetErrorCode();
                if (ret != 0) {
                    message = JITHTTPCLIENT.GetErrorMessage(ret);
                    alert("初始化失败，错误码：" + ret + " 错误信息：" + message);
                }
            }
            return;
        }
        
        var result = ""
        strCertDN = JITHTTPCLIENT.GetCertList("SC", "", "", "", "", -1);
        
        ret = JITHTTPCLIENT.GetErrorCode();
        if (ret != 0) 
        {
            message = JITHTTPCLIENT.GetErrorMessage(ret);
            alert("请插入电子钥匙");
            return "";
        }   
        result = strCertDN.split(',')[0].substring(3)+"||"+strCertDN;
        while (strCertDN != "") 
        {
            strCertDN = JITHTTPCLIENT.GetCertList("SC", "", "", "", "", -1);
            if (strCertDN != "")
            {
                result = result + "&&&" + strCertDN.split(',')[0].substring(3)+"||"+strCertDN;
            }
        }
        /*
        JITHTTPCLIENT.Finalize();
        */
        tempSc = "";
        return result;
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
            global:false,
            async: false,
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
    
    function HashData(inData) {
        var rtn = iGetData("HashData",inData);
        if ((rtn.retCode == "0")) {
            return rtn.hashData;
        } else {
            Global_Last_Error_Msg = rtn.retMsg;
            return "";
        }
    }
    
    function SOF_IsLogin(key) {
        return false;
    }
    
    function SignedData(content,key) {
        if (tempSc == "")
            tempSc = key;
        if (selectCert(key)){
            var result = JITHTTPCLIENT.DetachSignStr("",content);
            ret = JITHTTPCLIENT.GetErrorCode();
            if (ret != 0) {
                message = JITHTTPCLIENT.GetErrorMessage(ret);
                alert("签名失败，错误码：" + ret + " 错误信息：" + message);
                return '';
            }
            tempSc = key;
            return result;
        }
        return "";
    }

    function GetSignCert(key) {
        if (selectCert(key)){
            var result = JITHTTPCLIENT.GetCertInfo("SC",8,"");
            ret = JITHTTPCLIENT.GetErrorCode();
            if (ret != 0) {
                message = JITHTTPCLIENT.GetErrorMessage(ret);
                alert("签名失败，错误码：" + ret + " 错误信息：" + message);
                return '';
            }
            return result;
        }
        return "";
    }

    function GetUniqueID(cert,key) {
        if (selectCert(key)){
            var result = JITHTTPCLIENT.GetCertInfo("SC",7,"1.2.86.11.7.1");
            ret = JITHTTPCLIENT.GetErrorCode();
            if (ret != 0) {
                message = JITHTTPCLIENT.GetErrorMessage(ret);
                alert("签名失败，错误码：" + ret + " 错误信息：" + message);
                return '';
            }
            return AscToStr(result);
        }
        return "";
    }

    //十六进制的ascII码转换成字符串
    function AscToStr(asc) {
        tmp=asc.split(" ");
        tmp_str="";
        for(i=6;i<tmp.length;i++){//去掉前几位的乱字符
            tmp_str+=String.fromCharCode(parseInt(tmp[i],16));
        }
        return tmp_str;
    }

    function GetIdentityID(key){
        return "";
    }

    function GetCertNo(key) {
        if (selectCert(key)) {
            var result = JITHTTPCLIENT.GetCertInfo("SC",2,"");
            ret = JITHTTPCLIENT.GetErrorCode();
            if (ret != 0) {
                message = JITHTTPCLIENT.GetErrorMessage(ret);
                alert("签名失败，错误码：" + ret + " 错误信息：" + message);
                return '';
            }
            return result;
        }
        return "";
    }

    function GetCertSN(key) {
        return GetCertNo(key);
    }

    function GetKeySN(key) {
        return "";
    }

    function GetPicBase64Data(key) {
        alert("请注意：吉林安信当前只支持IE版本下获取图片。");
        return "";
    }

    function GetCertCNName(key) {
        if (selectCert(key)) {
            var result = JITHTTPCLIENT.GetCertInfo("SC",9,"");
            ret = JITHTTPCLIENT.GetErrorCode();
            if (ret != 0) {
                message = JITHTTPCLIENT.GetErrorMessage(ret);
                alert("签名失败，错误码：" + ret + " 错误信息：" + message);
                return '';
            }
            return result;
        }
        return "";
    }

    function selectCert(key,cert) {
        JITHTTPCLIENT.SetCertChooseType(1);//不弹出证书选择框
        ret = JITHTTPCLIENT.GetErrorCode();
        if (ret != 0) {
            message = JITHTTPCLIENT.GetErrorMessage(ret);
            alert("设置证书选择类型失败，错误码：" + ret + " 错误信息：" + message);
            return false;
        }
        
        if (tempSc != key)
        {
            var ret = JITHTTPCLIENT.SetCertEx("", "SC", key, "", "","", "");//可筛选证书
            ret = JITHTTPCLIENT.GetErrorCode();
            if (ret != 0) {
                message = JITHTTPCLIENT.GetErrorMessage(ret);
                alert("通过证书DN选择证书失败，错误码：" + ret + " 错误信息：" + message);
                return false;
            }
            return true;
        }else {
            
            return true;
        }
    }

    function Login(form_,key,password_) {
        GetUserList();
        if (selectCert(key)) {
            JITHTTPCLIENT.SetPinCode(password_);
            ret = JITHTTPCLIENT.GetErrorCode();
            if (ret != 0) {
                message = JITHTTPCLIENT.GetErrorMessage(ret);
                alert("通过证书DN选择证书失败，错误码：" + ret + " 错误信息：" + message);
                return false;
            }
            tempSc = key;
            return true;
        }
        return false;
    }

    function getUsrSignatureInfo(key){
        var usrSignatureInfo = new Array();
        usrSignatureInfo["identityID"] = GetIdentityID(key);
        usrSignatureInfo["certificate"] = GetSignCert(key);
        usrSignatureInfo["certificateNo"] = GetCertNo(key);
        usrSignatureInfo["CertificateSN"] = GetCertSN(key);
        usrSignatureInfo["uKeyNo"] = GetKeySN(key);
        usrSignatureInfo["signImage"] = GetPicBase64Data(key);
        var certB64 = GetSignCert(key);
        usrSignatureInfo["UsrCertCode"] = GetUniqueID(certB64,key);
        usrSignatureInfo["CertName"] = GetCertCNName(key);
        return usrSignatureInfo;
    }

    function CheckPWD(key, pwd) {
            return "";
    }
        
    function CheckForm(key, strServerCert, strServerRan, strServerSignedData) {
        return "";
    }

    function oGetLastError() {
        return "";
    }

    return {
        OCX: "",
        VenderCode:Const_Vender_Code,
        SignType:Const_Sign_Type,
        GetVersion: function() {
            return GetVersion();
        },
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
};


var ca_key = "";
var tempSc = "";
if(!!window.ActiveXObject || "ActiveXObject" in window) {
    ca_key = ca_key_IE();
} else {
    ca_key = ca_key_CHROME();
}

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
///对待签数据的Hash值做批量签名
function SignedDataS(contentHash, key) {
    return ca_key.SignedDataS(contentHash, key)
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