
var ca_key = (function() {
    
	//常量定义
	var Const_Vender_Code = "GDCA";
    var Const_Sign_Type = "UKEY";
	var Global_Last_Login_CertInfo = "";
    var Global_Last_Login_SealInfo = "";
    var Global_Last_Login_Token = "";
    var Global_Last_Error_Code = "";
    var Global_Last_Error_Msg = "";
	
    var SOR_OK              = 0;            //操作成功
    var SOR_UnknownErr      = 0x0b000001;   //异常错误
    var SOR_IndataLenErr    = 0x0b000200;   //输入数据长度错误
    var SOR_IndataErr       = 0x0b000201;   //输入数据错误
    var SOR_InitializeErr   = 0x0b000424;   //初始化失败
    //设备信息标识
    var SGD_DEVICE_SORT                   = 0x00000201;     //设备类别
    var SGD_DEVICE_TYPE                   = 0x00000202;     //设备型号
    var SGD_DEVICE_NAME                   = 0x00000203;     //设备名称
    var SGD_DEVICE_MANUFACTURER           = 0x00000204;     //生产厂商
    var SGD_DEVICE_HARDWARE_VERSION       = 0x00000205;     //硬件版本
    var SGD_DEVICE_SOFTWARE_VERSION       = 0x00000206;     //软件版本
    var SGD_DEVICE_STANDARD_VERSION       = 0x00000207;     //符合标准版本
    var SGD_DEVICE_SERIAL_NUMBER          = 0x00000208;     //设备编号
    var SGD_DEVICE_SUPPORT_ALG            = 0x00000209;     //设备能力字段,标识密码设备支持的非对称密码算法
    var SGD_DEVICE_SUPPORT_SYM            = 0x0000020A;     //设备能力字段,标识密码设备支持的对称密码算法
    var SGD_DEVICE_SUPPORT_HASH_ALG       = 0x0000020B;     //设备能力字段,标识密码设备支持的杂凑密码算法
    var SGD_DEVICE_SUPPORT_STORAGE_SPACE  = 0x0000020C;     //设备能力字段,标识密码设备最大文件存储空间
    var SGD_DEVICE_SUPPORT_FREE_SPACE     = 0x0000020D;     //设备能力字段,标识密码设备空闲文件存储空间
    var SGD_DEVICE_RUNTIME                = 0x0000020E;     //已运行时间
    var SGD_DEVICE_USED_TIMES             = 0x0000020F;     //设备调用次数
    var SGD_DEVICE_LOCATION               = 0x00000210;     //设备物理位置
    var SGD_DEVICE_DESCRIPTION            = 0x00000211;     //设备描述
    var SGD_DEVICE_MANAGER_INFO           = 0x00000212;     //设备管理者描述信息
    var SGD_DEVICE_MAX_DATA_SIZE          = 0x00000213;     //设备能力字段,一次能处理的数据容量
    //证书解析项标识
    var SGD_CERT_ALL                        = 0x00000000;    //证书信息
    var SGD_CERT_VERSION                    = 0x00000001;    //证书版本
    var SGD_CERT_SERIAL                     = 0x00000002;    //证书序列号
    var SGD_CERT_ISSUER                     = 0x00000005;    //证书颁发者信息
    var SGD_CERT_VALID_TIME                 = 0x00000006;    //证书有效期
    var SGD_CERT_SUBJECT                    = 0x00000007;    //证书拥有者信息
    var SGD_CERT_DER_PUBLIC_KEY             = 0x00000008;    //证书公钥信息
    var SGD_CERT_DER_EXTENSIONS             = 0x00000009;    //证书扩展项信息
    var SGD_EXT_AUTHORITYKEYIDENTIFIER_INFO = 0x00000011;    //证书颁发者密钥标识符
    var SGD_EXT_SUBJECTKEYIDENTIFIER_INFO   = 0x00000012;    //证书持有者密钥标识符
    var SGD_EXT_KEYUSAGE_INFO               = 0x00000013;    //密钥用途
    var SGD_EXT_PRIVATEKEYUSAGEPERIOD_INFO  = 0x00000014;    //私钥有效期
    var SGD_EXT_CERTIFICATEPOLICIES_INFO    = 0x00000015;    //证书策略
    var SGD_EXT_POLICYMAPPINGS_INFO         = 0x00000016;    //策略映射
    var SGD_EXT_BASICCONSTRAINTS_INFO       = 0x00000017;    //基本限制
    var SGD_EXT_POLICYCONTRAINTS_INFO       = 0x00000018;    //策略限制
    var SGD_EXT_EXTKEYUSAGE_INFO            = 0x00000019;    //扩展密钥用途
    var SGD_EXT_CRLDISTRIBUTIONPOINTS_INFO  = 0x0000001A;    //CRL发布点
    var SGD_EXT_NETSCAPE_CERT_TYPE_INFO     = 0x0000001B;    //Netscape属性
    var SGD_EXT_SELFDEFINED_EXTENSION_INFO  = 0x0000001C;    //私有的自定义扩展项
    var SGD_CERT_ISSUER_CN                  = 0x00000021;    //证书颁发者CN
    var SGD_CERT_ISSUER_O                   = 0x00000022;    //证书颁发者O
    var SGD_CERT_ISSUER_OU                  = 0x00000023;    //证书颁发者OU
    var SGD_CERT_SUBJECT_CN                 = 0x00000031;    //证书拥有者信息CN
    var SGD_CERT_SUBJECT_O                  = 0x00000032;    //证书拥有者信息O
    var SGD_CERT_SUBJECT_OU                 = 0x00000033;    //证书拥有者信息OU
    var SGD_CERT_SUBJECT_EMAIL              = 0x00000034;    //证书拥有者信息EMAIL
    //签名算法
    var SGD_SM3_RSA     = 0x00010001;   //基于SM3算法和RSA算法的签名
    var SGD_SHA1_RSA    = 0x00010002;   //基于SHA_1算法和RSA算法的签名
    var SGD_SHA256_RSA  = 0x00010004;   //基于SHA_256算法和RSA算法的签名
    var SGD_SM3_SM2     = 0x00020201;   //基于SM3算法和SM2算法的签名

    var SGD_SM1_ECB     = 0x00000101;   //SM1算法ECB加密模式
    var SGD_SM1_CBC     = 0x00000102;   //SM1算法CBC加密模式
    var SGD_SM1_CFB     = 0x00000104;   //SM1算法CFB加密模式
    var SGD_SM1_OFB     = 0x00000108;   //SM1算法OFB加密模式
    var SGD_SM1_MAC     = 0x00000110;   //SM1算法MAC运算

    var SGD_SSF33_ECB   = 0x00000201;   //SSF33算法ECB加密模式
    var SGD_SSF33_CBC   = 0x00000202;   //SSF33算法CBC加密模式
    var SGD_SSF33_CFB   = 0x00000204;   //SSF33算法CFB加密模式
    var SGD_SSF33_OFB   = 0x00000208;   //SSF33算法OFB加密模式
    var SGD_SSF33_MAC   = 0x00000210;   //SSF33算法MAC运算

    var SGD_SM4_ECB     = 0x00000401;   //SM4算法ECB加密模式
    var SGD_SM4_CBC     = 0x00000402;   //SM4算法CBC加密模式
    var SGD_SM4_CFB     = 0x00000404;   //SM4算法CFB加密模式
    var SGD_SM4_OFB     = 0x00000408;   //SM4算法OFB加密模式
    var SGD_SM4_MAC     = 0x00000410;   //SM4算法MAC运算

    var SGD_ZUC_EEA3    = 0x00000801;   //ZUC祖冲之机密性算法128-EEA3算法
    var SGD_ZUC_EEI3    = 0x00000802;   //ZUC祖冲之机密性算法128-EEI3算法

    var SIGN_FLAG_WITHOUT_ORI   =  1;   //不带原文
    var SIGN_FLAG_WITH_ORI      =  0;   //带原文

	var hexOut = false;
	var base64DecodeChars = new Array(
	    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
	    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
	    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63,
	    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1,
	    -1,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
	    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1,
	    -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
	    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1);

	function base64decode(str) {
	    var c1, c2, c3, c4;
	    var i, len, out;
	    var charCode;

	    len = str.length;
	    i = 0;
	    out = hexOut ? [] : "";
	    while(i < len) {
	    /* c1 */
	    do {
	        c1 = base64DecodeChars[str.charCodeAt(i++) & 0xff];
	    } while(i < len && c1 == -1);
	    if(c1 == -1)
	        break;

	    /* c2 */
	    do {
	        c2 = base64DecodeChars[str.charCodeAt(i++) & 0xff];
	    } while(i < len && c2 == -1);
	    if(c2 == -1)
	        break;

	    charCode = (c1 << 2) | ((c2 & 0x30) >> 4);
	    hexOut ? out.push(charCode) : out += String.fromCharCode(charCode);

	    /* c3 */
	    do {
	        c3 = str.charCodeAt(i++) & 0xff;
	        if(c3 == 61)
	        return out;
	        c3 = base64DecodeChars[c3];
	    } while(i < len && c3 == -1);
	    if(c3 == -1)
	        break;
	    charCode = ((c2 & 0XF) << 4) | ((c3 & 0x3C) >> 2);
	    hexOut ? out.push(charCode) : out += String.fromCharCode(charCode);

	    /* c4 */
	    do {
	        c4 = str.charCodeAt(i++) & 0xff;
	        if(c4 == 61)
	        return out;
	        c4 = base64DecodeChars[c4];
	    } while(i < len && c4 == -1);
	    if(c4 == -1)
	        break;
	    charCode = ((c3 & 0x03) << 6) | c4;
	    hexOut ? out.push(charCode) : out += String.fromCharCode(charCode);
	    }
	    return out;
	}

    try {
        GDCAobj = document.createElement("object");
        GDCAobj.setAttribute("width",1);
        GDCAobj.setAttribute("height",1);
        GDCAobj.setAttribute("id","GDCACom");
        GDCAobj.setAttribute("name","GDCACom");
        GDCAobj.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
        if((window.ActiveXObject)||("ActiveXObject" in window)) {
            GDCAobj.setAttribute("classid","clsid:BFEAA574-D032-49EE-BAB4-D09D0D511D52");
        } else {
            GDCAobj.setAttribute("type","application/gdca-activex");
            GDCAobj.setAttribute("clsid","{BFEAA574-D032-49EE-BAB4-D09D0D511D52}");
        }
        document.documentElement.appendChild(GDCAobj);
    } catch(e) {
        alert("请检查证书客户端环境是否正确安装!");
    }

    ////////////////SOFCom Wrapper////////////////
    function SOF_GetVersion(ComObj) {
        var sVer = ComObj.SOF_GetVersion();
        if(sVer == "")
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_GetVersion"};
            
        return sVer;
    }

    function SOF_Initialize(ComObj) {
        var rv = ComObj.SOF_Initialize();
        if(rv != SOR_OK)
            throw {code:rv,msg:"SOF_Initialize"}
    }

    function SOF_Finalize(ComObj) {
        var rv = ComObj.SOF_Finalize();
        if(rv != SOR_OK)
            throw {code:rv,msg:"SOF_Finalize"}
    }

    function GetDeviceInfo(ComObj, sContainerName, iInfoType, sTitle) {
        var sDevinfo = ComObj.SOF_GetDeviceInfo(sContainerName, iInfoType);
        return sTitle + ":" + sDevinfo + "\n";
    }

    function SOF_GetDeviceInfo(ComObj, sContainerName, iInfoType) {
        var sDevinfo = "";
        sDevinfo = ComObj.SOF_GetDeviceInfo(sContainerName, iInfoType);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_GetDeviceInfo"};
        
        return sDevinfo;
    }

    function SOF_SetSignMethod(ComObj, iSignMethod) {
        var rv = ComObj.SOF_SetSignMethod(iSignMethod);
        if(rv != SOR_OK)
            throw {code:rv,msg:"SOF_SetSignMethod"};
    }

    function SOF_GetSignMethod(ComObj) {
        return ComObj.SOF_GetSignMethod();
    }

    function SOF_SetEncryptMethod(ComObj, iEncryptMethod) {
        var rv = ComObj.SOF_SetEncryptMethod(iEncryptMethod);
        if(rv != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_SetEncryptMethod"};
    }

    function SOF_GetEncryptMethod(ComObj) {
        return ComObj.SOF_GetEncryptMethod();
    }

    function SOF_GetUserList(ComObj) {
        var sUserList = ComObj.SOF_GetUserList();
        if(ComObj.SOF_GetLastError() == 0xB000311) alert("请先插入UKey");
        else if (ComObj.SOF_GetLastError() != SOR_OK) throw {code:ComObj.SOF_GetLastError(),msg:"SOF_GetUserList"};
        
        return sUserList;
    }

    function SOF_ExportUserCert(ComObj, sContainerName) {
        var sCertB64 = ComObj.SOF_ExportUserCert(sContainerName);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_ExportUserCert"};
        
        return sCertB64;
    }

    function SOF_Login(ComObj, sContainerName, sPassWord) {
        var rv = ComObj.SOF_Login(sContainerName, sPassWord);
        if (ComObj.SOF_GetLastError() == 184549889) {
            alert("密码错误");
            return rv;
        } else if(ComObj.SOF_GetLastError() != SOR_OK) throw {code:ComObj.SOF_GetLastError(),msg:"SOF_Login"};
        return true;
    }

    function SOF_UserLogin(ComObj, sContainerName, nLoginType, sPassWord) {
        var rv = ComObj.SOF_UserLogin(sContainerName, nLoginType, sPassWord);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_UserLogin"};
        return true;
    }

    function SOF_GetPinRetryCount(ComObj, sContainerName) {
        return ComObj.SOF_GetPinRetryCount(sContainerName);
    }

    function SOF_ChangePassWd(ComObj, sContainerName, sOldPassWord, sNewPassWord) {
        var rv = ComObj.SOF_ChangePassWd(sContainerName, sOldPassWord, sNewPassWord);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_ChangePassWd"};
        
        return true;
    }

    function SOF_ExportExChangeUserCert(ComObj, sContainerName) {
        var sCertB64 = ComObj.SOF_ExportExChangeUserCert(sContainerName);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_ExportExChangeUserCert"};
        
        return sCertB64;
    }

    function SOF_GetCertInfo(ComObj, sCertB64, iInfoType) {
        var sCertInfo = "";
        var sCertInfo = ComObj.SOF_GetCertInfo(sCertB64, iInfoType);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_GetCertInfo"};
        
        return sCertInfo;
    }

    function SOF_GetCertInfoByOid(ComObj, sCertB64, sOID) {
        var sCertInfo = ComObj.SOF_GetCertInfoByOid(sCertB64, sOID);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_GetCertInfoByOid"};
        
        return sCertInfo;
    }

    function SOF_ValidateCert(ComObj, sCertB64) {
        var rv = ComObj.SOF_ValidateCert(sCertB64);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:rv, msg:"SOF_ValidateCert"};
    }

    function SOF_SignData(ComObj, sContainerName, sInData) {
        var sSignedDataB64 = ComObj.SOF_SignData(sContainerName, sInData);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_SignData"};
        
        return sSignedDataB64;
    }

    function SOF_VerifySignedData(ComObj, sCertB64, sOrignalData, sSignedDataB64) {
        var bRet = ComObj.SOF_VerifySignedData(sCertB64, sOrignalData, sSignedDataB64);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_VerifySignedData"};
        
        return bRet;
    }

    function SOF_EncryptData(ComObj, sEncryptCertB64, sPlainData) {
        var sEncryptedDataB64 = ComObj.SOF_EncryptData(sEncryptCertB64, sPlainData);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_EncryptData"};
        
        return sEncryptedDataB64;
    }

    function SOF_DecryptData(ComObj, sContainerName, sEncryptedDataB64) {
        var sDecryptedData = ComObj.SOF_DecryptData(sContainerName, sEncryptedDataB64);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_DecryptData"};
        
        return sDecryptedData;
    }

    function SOF_SignMessage(ComObj, lFlag, sContainerName, sOrignalData) {
        var sSignedDataB64 = ComObj.SOF_SignMessage(lFlag, sContainerName, sOrignalData);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_SignMessage"};
        
        return sSignedDataB64;
    }

    function SOF_VerifySignedMessage(ComObj, sSignedDataB64, sPlainData) {
        var bRet = ComObj.SOF_VerifySignedMessage(sSignedDataB64, sPlainData);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_VerifySignedMessage"};
        
        return bRet;
    }

    function SOF_GetInfoFromSignedMessage(ComObj, sSignedDataB64, lType) {
        var sInfo = ComObj.SOF_GetInfoFromSignedMessage(sSignedDataB64, lType);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_GetInfoFromSignedMessage"};
        
        return sInfo;
    }

    function SOF_GenRandom(ComObj, iRandomLen) {
        var sRandomDataB64 = ComObj.SOF_GenRandom(iRandomLen);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_GenRandom"};
        
        return sRandomDataB64;
    }

    function SOF_GetLastError(ComObj) {
        return ComObj.SOF_GetLastError();
    }

    function SOF_Ext_isLogin(ComObj, sContainerName, lLoginType) {
        var bRet = ComObj.SOF_Ext_isLogin(sContainerName, lLoginType);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_Ext_isLogin"};
        
        return bRet;
    }

    function SOF_Ext_ReadLabel(ComObj, sContainerName, sName, lType) {
        var sOutData = ComObj.SOF_Ext_ReadLabel(sContainerName, sName, lType);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_Ext_ReadLabel"};
        
        return sOutData;
    }

    function SOF_Ext_ReadUsrDataFile(ComObj, sContainerName, lFileType, lFileIndex, lOffset, lReadLen) {
        var sOutData = ComObj.SOF_Ext_ReadUsrDataFile(sContainerName, lFileType, lFileIndex, lOffset, lReadLen);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_Ext_ReadUsrDataFile"};
        
        return sOutData;
    }

    function SOF_Ext_WriteUsrDataFile(ComObj, sContainerName, sPin, lFileType, lFileIndex, lOffset, sWriteData) {
        var nRet = ComObj.SOF_Ext_WriteUsrDataFile(sContainerName, sPin, lFileType, lFileIndex, lOffset, sWriteData);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_Ext_WriteUsrDataFile"};
        
        return nRet;
    }

    function SOF_Ext_HashFile(ComObj, uiAlgorithmType, sPublicKey, sID, sInFile) {
        var sOutData = ComObj.SOF_Ext_HashFile(uiAlgorithmType, sPublicKey, sID, sInFile);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_Ext_HashFile"};
        
        return sOutData;
    }

    function SOF_Ext_TspGetTime(ComObj) {
        var sOutData = ComObj.SOF_Ext_TspGetTime();
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_Ext_TspGetTime"};
        
        return sOutData;
    }

    function SOF_Ext_TstGetStamp(ComObj, sContainerName, sInData) {
        var sOutData = ComObj.SOF_Ext_TstGetStamp();
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_Ext_TstGetStamp"};
        
        return sOutData;
    }

    function SOF_Ext_TspVerifyStamp(ComObj, sInData, sStamp, sTsaCert) {
        var sOutData = ComObj.SOF_Ext_TspVerifyStamp(sInData, sStamp, sTsaCert);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_Ext_TspVerifyStamp"};
        
        return sOutData;
    }

    function SOF_Ext_TspGetFileStamp(ComObj, sContainerName, sInFile) {
        var sOutData = ComObj.SOF_Ext_TspGetFileStamp(sContainerName, sInFile);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_Ext_TspGetFileStamp"};
        
        return sOutData;
    }

    function SOF_Ext_TspVerifyFileStamp(ComObj, sInFile, sStamp, sTsaCert) {
        var sOutData = ComObj.SOF_Ext_TspVerifyFileStamp();
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_Ext_TspVerifyFileStamp"};
        
        return sOutData;
    }

    function SOF_Ext_Base64Encode(ComObj, sInData) {
        var sOutData = ComObj.SOF_Ext_Base64Encode(sInData);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_Ext_Base64Encode"};
        
        return sOutData;
    }

    function SOF_Ext_Base64Decode(ComObj, sInData) {
        var sOutData = ComObj.SOF_Ext_Base64Decode(sInData);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_Ext_Base64Decode"};
        
        return sOutData;
    }

    function SOF_Ext_GetDeviceType(ComObj) {
        var nRet = ComObj.SOF_Ext_GetDeviceType();
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_Ext_GetDeviceType"};
        
        return nRet;
    }

    function SOF_Ext_Logout(ComObj, sContainerName, lLoginType) {
        var nRet = ComObj.SOF_Ext_Logout(sContainerName, lLoginType);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_Ext_Logout"};
        
        return nRet;
    }

    function SOF_EncryptFile(ComObj, sEncryptCertB64, sInFilePath, sOutFilePath) {
        var bRet = ComObj.SOF_EncryptFile(sEncryptCertB64, sInFilePath, sOutFilePath);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_EncryptFile"};
        
        return bRet;
    }

    function SOF_DecryptFile(ComObj, sContainerName, sInFilePath, sOutFilePath) {
        var bRet = ComObj.SOF_DecryptFile(sContainerName, sInFilePath, sOutFilePath);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_DecryptFile"};
        
        return bRet;
    }

    function SOF_SignFile(ComObj, sContainerName, sInFilePath) {
        var sSignedDataB64 = ComObj.SOF_SignFile(sContainerName, sInFilePath);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_SignFile"};
        
        return sSignedDataB64;
    }

    function SOF_VerifySignedFile(ComObj, sSignCertB64, sInFilePath, sSignedDataB64) {
        var bRet = ComObj.SOF_VerifySignedFile(sSignCertB64, sInFilePath, sSignedDataB64);
        if(ComObj.SOF_GetLastError() != SOR_OK)
            throw {code:ComObj.SOF_GetLastError(),msg:"SOF_VerifySignedFile"};
        
        return bRet;
    }

    ////////////////对外接口////////////////
    function ShowError(e) {
        if(e.msg != undefined)
            if(e.code == 0xB000001) {
                alert("错误:\n消息:" + "证书已过期！");
            } else {
                alert("错误:\n消息:" + e.msg + "\n代码:0x" + e.code.toString(16).toUpperCase());
            }
        else
            alert("Exception:\n" + e.message);
    }

    function CheckValid(userCert) {
        try {
            var validDT = SOF_GetCertInfo(GDCACom, userCert, SGD_CERT_VALID_TIME);
            validDT = validDT.split("notafter");
            var nb = validDT[0].split(" ");
            var na = validDT[1].split(" ");

            var notbefore = new Date();
            notbefore.setHours(0);
            notbefore.setMinutes(0);
            notbefore.setSeconds(0);
            notbefore.setFullYear(nb[0].split(":")[1].split("-")[0],nb[0].split(":")[1].split("-")[1]-1,nb[0].split(":")[1].split("-")[2]);
            //alert(notbefore.toString());

            var notafter = new Date();
            notafter.setHours(0);
            notafter.setMinutes(0);
            notafter.setSeconds(0);
            notafter.setFullYear(na[0].split(":")[1].split("-")[0],na[0].split(":")[1].split("-")[1]-1,na[0].split(":")[1].split("-")[2]);
            //alert(notafter.toString());
            var nowdate = new Date();
            var days = (Date.parse(notbefore)-Date.parse(nowdate))/1000/60/60/24;
            if (days >=0 && days <=30) {
                alert("您的证书还有" + days + "天过期,请尽快到数据中心办理证书更新!");
                return true;
            }
            
            if (days < 0) {
                alert("您的证书已过期 " + -days + " 天，\n请尽快到数据中心办理证书更新手续。");
                return false;
            }

            return true;
        } catch(e) {
            ShowError(e);
            return false;
        }
    }

    function Login(strFromName, strCertID, strPin) {
        try {
            var usrCert = SOF_ExportUserCert(GDCACom, strCertID);
            if(usrCert == null || usrCert == "") {
                alert("导出用户证书失败!");
                return false;
            }

            if(!CheckValid(usrCert))
                return false;
            
            if(strCertID == null || strCertID == "") {
                alert("获取用户信息失败!");
                return false;
            }
            if(strPin == null || strPin == "") {
                alert("请输入密码");
                return false;
            }
            if(strPin.length<4 || strPin.length>16) {
                alert("密码应在4-16位之间");
                return false;
            }
            var ret = SOF_Login(GDCACom, strCertID, strPin);
            if(!ret) {
                var retryCnt = SOF_GetPinRetryCount(GDCACom, strCertID);
                if(retryCnt>0) {
                    alert("校验证书密码失败!您还有" + retryCnt + "次机会重试!");
                    return false;
                } else {
                    alert("登录失败!");
                    return false;
                }
            }
            
            var strClientSignedData = SOF_SignData(GDCACom,strCertID, strServerRan);
            if(strClientSignedData == null || strClientSignedData == "") {
                alert("客户端签名失败!");
                return false;
            }
            return true;
        } catch(e) {
            ShowError(e);
            return false;
        }
    }

    function GetUserList() {
        var strUserList;
        try {
            strUserList = SOF_GetUserList(GDCACom);
            return strUserList;
        } catch(e) {
            if(e.msg == "SOF_GetUserList" && e.code == SOR_UnknownErr) alert("未插入KEY!");
            else ShowError(e);
            return "";
        }
    }

    function getUserList_pnp() {
        var strUserList;
        try {
            strUserList = SOF_GetUserList(GDCACom);
            return strUserList;
        } catch(e) {
            if(e.msg == "SOF_GetUserList" && e.code == SOR_UnknownErr) alert("未插入KEY!");
            else ShowError(e);
            return "";
        }
    }

    function SignedData(content, key) {
        try {
            SOF_SetSignMethod(GDCACom, SGD_SHA256_RSA);
            //return SOF_SignData(GDCACom, key, content);
            return SOF_SignMessage(GDCACom, SIGN_FLAG_WITH_ORI, key, content);
        } catch(e) {
            ShowError(e);
        }
    }

    function SignedOrdData(content, key) {
        try {
            SOF_SetSignMethod(GDCACom, SGD_SHA256_RSA);
            //return SOF_SignData(GDCACom, key, content);
            return SOF_SignMessage(GDCACom, SIGN_FLAG_WITH_ORI, key, content);
        } catch(e) {
            ShowError(e);
        }
    }

    function GetIdentityID(key) {
        return "";
    }

    function GetSignCert(key) {
        try {
            return SOF_ExportUserCert(GDCACom, key);
        } catch(e) {
            ShowError(e);
        }
    }

    function GetCertSN(key) {
        try {
            return SOF_GetCertInfo(GDCACom, GetSignCert(key), SGD_CERT_SERIAL);
        } catch(e) {
            ShowError(e);
        }
    }

    function GetKeySN(key) {
        try {
            return SOF_GetDeviceInfo(GDCACom, key, SGD_DEVICE_SERIAL_NUMBER);
        } catch(e) {
            ShowError(e);
        }
    }

    function GetUniqueID(cert) {
        try {
            var sOID = "1.2.86.21.1.3";
            if(cert == "") {
                alert("请先读取签名证书");
                return "";
            }
            var uniqueID = SOF_GetCertInfoByOid(GDCACom, cert, sOID);
            var uniqueID = uniqueID.replace(/\./g, '');
            return uniqueID;
        } catch(e) {
            ShowError(e);
        }
    }

    function GetCertCNName(cert) {
        try {
            return SOF_GetCertInfo(GDCACom, cert, SGD_CERT_SUBJECT_CN);
        } catch(e) {
            ShowError(e);
        }
    }

    function GetPicBase64Data(key) {
		//注意34为CA提供写死值，目前确认医院项目应该均为34，如取不出图片，请CA确认是否改变了这个值
		try
		{
			var sReadData = SOF_Ext_ReadUsrDataFile(GDCACom, key, 34, 1, 0, 8);
		}
		catch (e) {}
	    var signImage = SOF_Ext_ReadUsrDataFile(GDCACom, key, "34", 1, 0, 16384);
	    signImage = base64decode(signImage);
	    signImage = signImage.split("@@@@")[0];
	    signImage = signImage.split("||")[4];
	    return signImage;
        
        //0x22  GDCA电子印章16K  readLen = 16384;
        //0x24  GDCA电子印章20K  readLen = 51200;
        //0x50  GDCA电子印章50K  readLen = 20480;
    }

    function GetCertNo(key) {
        try {
            return SOF_GetCertInfo(GDCACom, GetSignCert(key), SGD_CERT_SERIAL);
        } catch(e) {
            ShowError(e);
        }
    }

    function getUsrSignatureInfo(key) {
        var usrSignatureInfo = new Array();
        usrSignatureInfo["identityID"] = GetIdentityID(key);
        var cert = GetSignCert(key);
        usrSignatureInfo["certificate"] = cert;
        usrSignatureInfo["certificateNo"] = GetCertNo(key);
        usrSignatureInfo["CertificateSN"] = GetCertSN(key);
        usrSignatureInfo["uKeyNo"] = GetKeySN(key);
        usrSignatureInfo["signImage"] = GetPicBase64Data(key);
        usrSignatureInfo["UsrCertCode"] = GetUniqueID(cert);
        usrSignatureInfo["CertName"] = GetCertCNName(cert);
        return usrSignatureInfo;
    }

    function HashData(InData) {
		var rtn = iGetData("HashData",InData);
		if ((rtn.retCode == "0")) {
			return rtn.hashData;
		} else {
			alert(rtn.retMsg);
			return "";
		}
    }

	//校验输入的密码 正确返回空
	function CheckPWD(strCertID, strPin) {
        if(strCertID == null || strCertID == "") {
            return "获取用户信息失败!";
        }
        if(strPin == null || strPin == "") {
            return "请输入密码";
        }
        if(strPin.length<4 || strPin.length>16) {
            return "密码应在4-16位之间";
        }
        var ret = SOF_Login(GDCACom, strCertID, strPin);
        if(!ret) {
            var retryCnt = SOF_GetPinRetryCount(GDCACom, strCertID);
            if(retryCnt>0) {
                return "校验证书密码失败!您还有" + retryCnt + "次机会重试!";
            } else {
                return "登录失败!";
            }
        }
        return "";
	}

	//校验随机数
	function CheckForm(strCertID, strServerCert, strServerRan, strServerSignedData) {

	    var result = {};

	    // 导出客户端证书
	    //var userCert = SOF_ExportUserCert(strCertID, KEY_SIGNOREXCHANGE);
	    var userCert = GetSignCert(strCertID);
	    if (userCert == null || userCert == "") {
	        result.errMsg("导出用户证书失败!");
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
        try{
            var islogin = SOF_Ext_isLogin(GDCACom,strKey,1);
            return islogin;
        } catch(e) {
            return false;
        }
	}

	function oGetLastError() {
		return ComObj.SOF_GetLastError();
	}
	
	function iGetLoginedInfo() {
		var result = iGetData("GetLoginedInfo");
  		return result;
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
	
	function oLoginForm(paraObj) {
		paraObj = paraObj||"";
		var forceLogin = paraObj.forceLogin||false;
		
		/*
		if ((!forceLogin)&&(Global_Last_Login_CertInfo != "")) {
			if (SOF_IsLogin(Global_Last_Login_CertInfo.certContainer)) {
				return Global_Last_Login_CertInfo;
			}
		}
		*/
		
		if ((!forceLogin)) {
			var loginedCert = iGetLoginedInfo();
			if ((loginedCert.retCode == 0)&&(loginedCert.certContainer != "")) {
				if (iKeyExist(loginedCert.certContainer)&&(SOF_IsLogin(loginedCert.certContainer))) {
					loginedCert.signCert = GetSignCert(loginedCert.certContainer);
					loginedCert.userCertCode = GetUniqueID(loginedCert.signCert);
					loginedCert.certNo = GetCertNo(loginedCert.certContainer);
					Global_Last_Login_CertInfo = loginedCert;
					return Global_Last_Login_CertInfo;
				}
			}	
		}
		
		var url = "../csp/dhc.certauth.login.ukey.csp?venderCode=" + Const_Vender_Code + "&signType=" + Const_Sign_Type;
		var para = {
			GetUserList: function() {
				return GetUserList();
			},
			CheckPWD: function(key, pin) {
				return CheckPWD(key, pin);
			},
			GetSignCert: function(key) {
				return GetSignCert(key);
			},
			GetCertNo: function(key) {
				return GetCertNo(key);
			},
			GetUniqueID: function(cert,key) {
				return GetUniqueID(cert);
			}
		};
		var rtnStr = window.showModalDialog(url,para,"dialogWidth:350px;dialogHeight:350px;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;fullscreen=no");
		
		if ((typeof(rtnStr) == "undefined")||(rtnStr == "")) {
			return {retCode:"-2",retMsg:"登录失败"};
		}
		
		var rtn = $.parseJSON(rtnStr);
		if ((rtn)&&(rtn.retCode == "0")&&(rtn.hisUserName != "")) {
			Global_Last_Login_CertInfo = rtn;
		}
		
		return rtn||{retCode:"-2",retMsg:"登录失败"};
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
    	OCX: GDCACom,
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
		getUserList2: function() {
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
		LoginForm:function(paraObj) {
		    return oLoginForm(paraObj);
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
function LoginForm(paraObj) {
	return ca_key.LoginForm(paraObj);
}
function GetLastError() {
    return ca_key.GetLastError();
}