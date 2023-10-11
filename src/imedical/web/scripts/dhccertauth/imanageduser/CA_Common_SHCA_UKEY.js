var firstGetUserList = true;
//1.上海CAUkey当前只支持IE
//2.只支持单key操作
//3.获取图片通过服务端进行获取
var ca_key = (function() {
    var Const_Vender_Code = "SHCA";
    var Const_Sign_Type = "UKEY";
    var Global_Last_Login_CertInfo = "";
    var Global_Last_Login_Token = "";
    var Global_Last_Login_SealInfo = "";
    var Global_Last_Error_Code = "";
    var Global_Last_Error_Msg = "";
    
    try {
        if(!!window.ActiveXObject || "ActiveXObject" in window) {
            SafeEngineCtl = document.createElement("object");
            SafeEngineCtl.setAttribute("width",1);
            SafeEngineCtl.setAttribute("height",1);
            SafeEngineCtl.setAttribute("id","SafeEngineCtl");
            SafeEngineCtl.setAttribute("codeBase","JITComVCTK_S.cab#version=2.0");
            SafeEngineCtl.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
            SafeEngineCtl.setAttribute("classid","clsid:B48B9648-E9F0-48A3-90A5-8C588CE0898F");
            document.documentElement.appendChild(SafeEngineCtl);
            
            SafeEngineCtl.ESE_InitialSession(2,"", "", 0, 2, "", "");
        }else {
            alert("上海CA的Ukey当前只支持在IE浏览器中进行使用，请检查客户端环境。")
        }       
    } catch (e) {
        alert("没有正确安装证书应用环境或证书应用环境已经损坏！");
    }
    
    var tempSc = "";
    var DevNumber=0x24;
    var DevParam = "com1";
    var Certpath="com1";
    var CertArr;
    
    function checkUkey(key)
    {
        var myArr = CertArr;
        
        if (myArr.length > 1){
            alert("上海CA当前只支持单一Ukey操作，检测到电脑上插了多个key，请拔除多余Ukey后重试。");
            return false;
        }
        else if(myArr.length < 1){
            alert("当前电脑上未检测到上海CA的Ukey设备，请检查Ukey是否已成功插入电脑。")
            return false;
        }
        else {
            var sCertSN = SafeEngineCtl.ESE_GetCertDetail(myArr[0].cert,2);
            if (sCertSN != key){
                alert("初始化证书SN与传入证书SN不一致，初始化SN："+sCertSN+";用户登录传入SN："+key);
                return false;
            }
            else{
                return true;
            }
        }
    }
    
    function GetUserList(){
        var sInfo = SafeEngineCtl.ESE_ListCertInPlugDevice(3);
        if(SafeEngineCtl.ErrorCode!=0){
            alert("调用CA接口失败，ESE_ListCertInPlugDevice Error. Return:" + SafeEngineCtl.ErrorCode);
            return ""; 
        }else{
            var tmpArr = eval('('+sInfo+')');
            var myArr = new Array();
            
            for (var i=0;i<tmpArr.length;i++)
            {
                if (tmpArr[i].devType == "36")
                    myArr.push(tmpArr[i]);
                
            }    
            CertArr = myArr;
            if (myArr.length > 1){
                alert("上海CA当前只支持单一Ukey操作，检测到电脑上插了多个key，请拔除多余Ukey后重试。");
                return "";
            }
            else if(myArr.length < 1){
                alert("当前电脑上未检测到上海CA的Ukey设备，请检查Ukey是否已成功插入电脑。")
                return "";
            }
            else {
                var sCertSN = SafeEngineCtl.ESE_GetCertDetail(myArr[0].cert,2);
                var sCertCN = SafeEngineCtl.ESE_GetCertDetail(myArr[0].cert,17);
                if ((sCertSN == "")||(sCertCN == ""))
                    return "";
                tempSc = sCertSN;
                return sCertCN+"||"+sCertSN;
            }
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
        ///return "BA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD";
        var rtn = iGetData("HashData",inData);
        if ((rtn.retCode == "0")) {
            return rtn.hashData;
        } else {
            Global_Last_Error_Msg = rtn.retMsg;
            return "";
        }
    }    
    
    function SignedData(content,key){  
        if (tempSc == key) {
            strSigned = SafeEngineCtl.ESE_SignData(content, "");    
            if(SafeEngineCtl.ErrorCode!=0)
            {
                alert("ESE_SignData Error. Return:\n" + GetErrCode(SafeEngineCtl.ErrorCode));
                return "";
            }
            return strSigned;
        }
        return "";
    }

    //判读是否登录过
    function SOF_IsLogin(key) {
        return false;
    }

    //获取Ukey证书
    function GetSignCert(key){
        if (checkUkey(key)) {
            var result = SafeEngineCtl.ESE_GetSelfCertificate(DevNumber, Certpath);    
            if(SafeEngineCtl.ErrorCode!=0)
            {
                alert("ESE_GetSelfCertificate Error. Return:\n" + GetErrCode(SafeEngineCtl.ErrorCode));
                return "";
            }
            return result;
        }
        return "";
    }

    //获取用户唯一标识UsrCertCode  这里获取的身份证号
    function GetUniqueID(cert,key) {
        if (checkUkey(key)) {
            var result = SafeEngineCtl.ESE_GetCertInfoByOID(cert,"1.2.156.112570.148");
            if(SafeEngineCtl.ErrorCode!=0)
            {
                alert("ESE_GetCertInfoByOID205 Error. Return:\n" + GetErrCode(SafeEngineCtl.ErrorCode));
                return "";
            }
            return result;
        }
        return "";
    }

    //获取用户身份证号
    function GetIdentityID(key) {
        return "";
    }

    //获取证书编号CertificateNo  这里获取的是证书序列号
    function GetCertNo(key) {
        var cert = GetSignCert(key);
        if (cert == "")
            return "";
        if (checkUkey(key)) {
            var result = SafeEngineCtl.ESE_GetCertDetail(cert,2);
            if(SafeEngineCtl.ErrorCode!=0)
            {
                alert("ESE_GetCertDetail Error. Return:\n" + GetErrCode(SafeEngineCtl.ErrorCode));
                return "";
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
        return "暂时为空";
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
        var cert = GetSignCert(key);
        if (cert == "")
            return "";
        if (checkUkey(key)) {
            var result = SafeEngineCtl.ESE_GetCertDetail(cert,17);
            if(SafeEngineCtl.ErrorCode!=0)
            {
                alert("ESE_GetCertDetail Error. Return:\n" + GetErrCode(SafeEngineCtl.ErrorCode));
                return "";
            }
            return result;
        }
        return "";
    }

    function Login(form_,key,password_) {
        //初始化函数
        SafeEngineCtl.ESE_InitialSession(DevNumber,DevParam, password_, 0, 2, "", "" );
        if(SafeEngineCtl.ErrorCode!=0)
        {
            alert("ESE_InitialSession_Error_code:\n" + SafeEngineCtl.ErrorCode);
            alert("ESE_InitialSession Error. Return:\n" + GetErrCode(SafeEngineCtl.ErrorCode));
            return false;
        }
        
        var sInfo = SafeEngineCtl.ESE_ListCertInPlugDevice(3);
        if(SafeEngineCtl.ErrorCode!=0){
            alert("调用CA接口失败，ESE_ListCertInPlugDevice Error. Return:" + SafeEngineCtl.ErrorCode);
            return false; 
        }else{
            var tmpArr = eval('('+sInfo+')');
            var myArr = new Array();
            
            for (var i=0;i<tmpArr.length;i++)
            {
                if (tmpArr[i].devType == "36")
                    myArr.push(tmpArr[i]);
                
            }            
            CertArr = myArr;
            if (myArr.length > 1){
                alert("上海CA当前只支持单一Ukey操作，检测到电脑上插了多个key，请拔除多余Ukey后重试。");
                return false;
            }
            else if(myArr.length < 1){
                alert("当前电脑上未检测到上海CA的Ukey设备，请检查Ukey是否已成功插入电脑。")
                return false;
            }
            else {
                var sCertSN = SafeEngineCtl.ESE_GetCertDetail(myArr[0].cert,2);
                if (sCertSN == "")
                    return false;
                if (sCertSN != key){
                    alert("初始化证书SN与传入证书SN不一致，初始化SN："+sCertSN+";用户登录传入SN："+key);
                    return false;
                }
                tempSc = key;
                return true;
            }
        }
    }

    function CheckPWD(key, pwd) {
        return "";
    }
        
    function CheckForm(key, strServerCert, strServerRan, strServerSignedData) {
        return "";
    }

    function oGetLastError() {
        return SafeEngineCtl.ErrorCode;
    }
        
    function getUsrSignatureInfo(key){
        var usrSignatureInfo = new Array();
        if (!checkUkey(key))
            return usrSignatureInfo;
        
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
    
    
    function GetErrCode(errcode)
    {
        var result = '';
        switch (errcode)
        {
            case -2113601536 :
                result = "读取文件错误(-2113601536)";
                break;
            case -2113601535 :
                result = "密码错误(-2113601535)";
                break;
            case -2113601534 :
                result = "非法句柄错误(-2113601534)";
                break;
            case -2113601533 :
                result = "缺少ECC KEY错误(-2113601533)";
                break;
            case -2113601532 :
                result = "ECC KEY 与算法不匹配错误(-2113601532)";
                break;
            case -2113601531 :
                result = "非法算法错误(-2113601531)";
                break;
            case -2113601530 :
                result = "数字签名错误(-2113601530)";
                break;
            case -2113601529 :
                result = "摘要错误(-2113601529)";
                break;
            case -2113601528 :
                result = "缓冲区太小(-2113601528)";
                break;
            case -2113601527 :
                result = "证书格式错误(-2113601527)";
                break;
            case -2113601526 :
                result = "缺少公钥错误(-2113601526)";
                break;
            case -2113601525 :
                result = "验证签名错误(-2113601525)";
                break;
            case -2113601524 :
                result = "产生公私钥对错误(-2113601524)";
                break;
            case -2113601523 :
                result = "PKCS12编码错误(-2113601523)";
                break;
            case -2113601522 :
                result = "PKCS12格式错误(-2113601522)";
                break;
            case -2113601520 :
                result = "SE_ECC_ERROR_LOAD_BUILTIN_EC(-2113601520)";
                break;
            case -2113601519 :
                result = "公私钥不匹配错误(-2113601519)";
                break;
            case -2113601518 :
                result = "PKCS10编码错误(-2113601518)";
                break;
            case -2113601517 :
                result = "PKCS10解码错误(-2113601517)";
                break;
            case -2113601516 :
                result = "公钥格式错误(-2113601516)";
                break;
            case -2113601515 :
                result = "PKCS10格式错误(-2113601515)";
                break;
            case -2113601514 :
                result = "验证PKCS10错误(-2113601514)";
                break;
            case -2113601513 :
                result = "ECC KEY格式错误(-2113601513)";
                break;
            case -2113601512 :
                result = "公钥解码错误(-2113601512)";
                break;
            case -2113601511 :
                result = "签名格式错误(-2113601511)";
                break;
            case -2113601510 :
                result = "EC格式错误(-2113601510)";
                break;
            case -2113601509 :
                result = "ECC KEY解码错误(-2113601509)";
                break;
            case -2113601508 :
                result = "写入文件错误(-2113601508)";
                break;
            case -2113601507 :
                result = "证书链非法错误(-2113601507)";
                break;
            case -2113601506 :
                result = "内存分配错误(-2113601506)";
                break;
            case -2113601505 :
                result = "初始化环境错误(-2113601505)";
                break;
            case -2113601504 :
                result = "读取配置文件错误(-2113601504)";
                break;
            case -2113601503 :
                result = "打开设备错误(-2113601503)";
                break;
            case -2113601502 :
                result = "打开会话错误(-2113601502)";
                break;
            case -2113601501 :
                result = "装载动态库错误(-2113601501)";
                break;
            case -2113601500 :
                result = "设备类型错误(-2113601500)";
                break;
            case -2113601499 :
                result = "算法不支持错误(-2113601499)";
                break;
            case -2113601498 :
                result = "产生PKCS10错误(-2113601498)";
                break;
            case -2113601497 :
                result = "导出公钥错误(-2113601497)";
                break;
            case -2113601496 :
                result = "EC_POINT非法错误(-2113601496)";
                break;m
            case -2113601495 :
                result = "对称加密错误(-2113601495)";
                break;
            case -2113601494 :
                result = "对称解密错误(-2113601494)";
                break;
            case -2113601493 :
                result = "PEM解码错误(-2113601493)";
                break;
            case -2113601492 :
                result = "获取证书细目错误(-2113601492)";
                break;
            case -2113601491 :
                result = "PEM编码错误(-2113601491)";
                break;
            case -2113601490 :
                result = "获取证书扩展项错误(-2113601490)";
                break;
            case -2113601489 :
                result = "非法接口类型错误(-2113601489)";
                break;
            case -2113601488 :
                result = "非法参数错误(-2113601488)";
                break;
            case -2113601487 :
                result = "枚举设备错误(-2113601487)";
                break;
            case -2113601486 :
                result = "没有设备(-2113601486)";
                break;m
            case -2113601485 :
                result = "设备连接错误(-2113601485)";
                break;
            case -2113601484 :
                result = "产生随机数错误(-2113601484)";
                break;
            case -2113601483 :
                result = "SE_ECC_ERROR_SKF_SET_SYMKEY(-2113601483)";
                break;
            case -2113601482 :
                result = "对称加密初始化错误(-2113601482)";
                break;
            case -2113601481 :
                result = "对称加密错误(-2113601481)";
                break;
            case -2113601480 :
                result = "设备管理员口令错误(-2113601480)";
                break;
            case -2113601479 :
                result = "打开应用错误(-2113601479)";
                break;
            case -2113601478 :
                result = "设备已锁(-2113601478)";
                break;
            case -2113601477 :
                result = "设备口令错误(-2113601477)";
                break;
            case -2113601476 :
                result = "枚举应用错误(-2113601476)";
                break;
            case -2113601475 :
                result = "删除应用错误(-2113601475)";
                break;
            case -2113601474 :
                result = "创建应用错误(-2113601474)";
                break;
            case -2113601473 :
                result = "创建容器错误(-2113601473)";
                break;
            case -2113601472 :
                result = "设备不支持错误(-2113601472)";
                break;
            case -2113601471 :
                result = "打开容器错误(-2113601471)";
                break;
            case -2113601470 :
                result = "导出公钥错误(-2113601470)";
                break;
            case -2113601466 :
                result = "对称加密错误(-2113601466)";
                break;
            case -2113601465 :
                result = "导入密钥对错误(-2113601465)";
                break;
            case -2113601464 :
                result = "修改设备口令错误(-2113601464)";
                break;
            case -2113601463 :
                result = "导入证书错误(-2113601463)";
                break;
            case -2113601462 :
                result = "导出证书错误(-2113601462)";
                break;
            case -2113601461 :
                result = "创建文件错误(-2113601461)";
                break;
            case -2113601460 :
                result = "写入文件错误(-2113601460)";
                break;
            case -2113601459 :
                result = "获取文件信息错误(-2113601459)";
                break;
            case -2113601458 :
                result = "读取文件错误(-2113601458)";
                break;
            case -2113601457 :
                result = "获取公钥错误(-2113601457)";
                break;
            case -2113601454 :
                result = "生成密钥对错误(-2113601454)";
                break;
            case -2113601453 :
                result = "证书已过期(-2113601453)";
                break;
            case -2113601452 :
                result = "多个设备错误(-2113601452)";
                break;
            case -2113601451 :
                result = "没有设备(-2113601451)";
                break;
            case -2113601450 :
                result = "自动检测设备错误(-2113601450)";
                break;
            case -2113601449 :
                result = "设备无法识别(-2113601449)";
                break;
            case -2113601448 :
                result = "获取会话密钥错(-2113601448)";
                break;
            case -2113601447 :
                result = "导入会话密钥错(-2113601447)";
                break;
            case -2113601446 :
                result = "初始化摘要错误(-2113601446)";
                break;
            case -2113601445 :
                result = "更新摘要错误(-2113601445)";
                break;
            case -2113601444 :
                result = "生成会话密钥错(-2113601444)";
                break;
            case -2113601442 :
                result = "导入会话密钥错(-2113601442)";
                break;
            case -2113601441 :
                result = "缓冲区太小(-2113601441)";
                break;
            case -2113601440 :
                result = "P7签名数据初始化错误(-2113601440)";
                break;
            case -2113601439 :
                result = "产生随机数错误(-2113601439)";
                break; 
            case -2113601438 :
                result = "对称加密错误(-2113601438)";
                break; 
            case -2113601437 :
                result = "对称解密错误(-2113601437)";
                break; 
            case -2113601436 :
                result = "导出公钥错误(-2113601436)";
                break;   
            case -2113601435 :
                result = "添加p7算法错误(-2113601435)";
                break;   
            case -2113601434 :
                result = "P7数据处理错误(-2113601434)";
                break;   
            case -2113601433 :
                result = "SE_ECC_ERROR_ENVELOPE_ADD_RECIP(-2113601433)";
                break;   
            case -2113601432 :
                result = "签名数据错误(-2113601432)";
                break;   
            case -2113601431 :
                result = "摘要数据处理错误(-2113601431)";
                break;   
            case -2113601430 :
                result = "加密更新错误(-2113601430)";
                break;   
            case -2113601429 :
                result = "加密处理错误(-2113601429)";
                break;   
            case -2113601428 :
                result = "解密初始化错误(-2113601428)";
                break;   
            case -2113601427 :
                result = "解密更新错误(-2113601427)";
                break;   
            case -2113601426 :
                result = "解密处理错误(-2113601426)";
                break;   
            case -2113601425 :
                result = "p7格式错误(-2113601425)";
                break;   
            case -2113601424 :
                result = "SE_ECC_ERROR_P7_NO_RECIP(-2113601424)";
                break;  
            case -2113601423 :
                result = "算法非法(-2113601423)";
                break;   
            case -2113601422 :
                result = "私钥长度错误(-2113601422)";
                break;   
            case -2113601421 :
                result = "P7签名错误(-2113601421)";
                break;   
            case -2113601420 :
                result = "验证P7签名错误(-2113601420)";
                break;   
            case -2113601419 :
                result = "P7签名设置版本错误(-2113601419)";
                break;  
            case -2113601418 :
                result = "锁设备错误(-2113601418)";
                break;  
            case -2113601417 :
                result = "缓冲区太小(-2113601417)";
                break;  
            case -2113601416 :
                result = "从LDAP获取证书错误(-2113601416)";
                break;  
            case -2113601415 :
                result = "连接OCSP服务器错误(-2113601415)";
                break;   
            case -2113601414 :
                result = "参数错误(-2113601414)";
                break;   
            case -2113601413 :
                result = "CRL格式错误(-2113601413)";
                break;   
            case -2113601412 :
                result = "证书废除(-2113601412)";
                break;      
            case -2113601411 :
                result = "证书链格式错误(-2113601411)";
                break;   
            case -2113601410 :
                result = "验证证书链错误(-2113601410)";
                break;     
            case -2113601409 :
                result = "管理员密码错误(-2113601409)";
                break;  
            case -2113601408 :
                result = "设备标签格式错误(-2113601408)";
                break;      
            case -2113601407 :
                result = "删除容器错误(-2113601407)";
                break;      
            case -2113601406 :
                result = "枚举文件错误(-2113601406)";
                break;      
            case -2113601405 :
                result = "删除文件错误(-2113601405)";
                break;    
            case -2113601404 :
                result = "枚举容器错误(-2113601404)";
                break;      
            case -2113601403 :
                result = "关闭应用错误(-2113601403)";
                break;      
            case -2113568768 :
                result = "SE_ECC_ERROR_FUNC_LOCAL(-2113568768)";
                break;             
        // 以下错误用于登录
            case -2113666824 :
                result = "无效的登录凭证(-2113666824)";
                break;
            case -2113666823 :
                result = "参数错误(-2113666823)";
                break;
            case -2113666822 :
                result = "不是服务器证书(-2113666822)";
                break;
            case -2113666821 :
                result = "登录错误(-2113666821)";
                break;
            case -2113666820 :
                result = "证书验证方式错误(-2113666820)";
                break;
            case -2113666819 :
                result = "随机数验证错误(-2113666819)";
                break;
            case -2113666818 :
                result = "与单点登录客户端代理通信(-2113666818)";
            break;
        }
        result = "上海CA接口错误:"+result;
        return result;
    }
    

    return {
        OCX: SafeEngineCtl,
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