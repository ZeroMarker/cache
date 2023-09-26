
/*
文件修改记录 
2012-10-16 修改者  陆汉民
增加了旧姆印的获取
2011-04-29  修改者：王伟
根据secuInter当前最新版本(V4.1)修改创建对象的方式，解决WIN7下多次弹出的问题。
先尝试使用新的创建方式创建对象，不成功则用旧的方式创建，目的是做到兼容V4.1以前的secuInter版本
2012-04-8  修改者：陆汉民
按规范化文档整理文件
*/
/***************************************************/
/***********  5.1.  常量 2012.04.08      ***********/
/***************************************************/

var SECUINTER_LOCAL_MACHINE_STORE = 0;
var SECUINTER_CURRENT_USER_STORE = 1;

var SECUINTER_MY_STORE = 0;
var SECUINTER_OTHER_STORE = 1;
var SECUINTER_CA_STORE = 2;
var SECUINTER_ROOT_STORE = 3;

var SECUINTER_CERTTYPE_ALL = 0;
var SECUINTER_CERTTYPE_SIGN = 1;
var SECUINTER_CERTTYPE_ENV = 2;

var SECUINTER_NETCA_ALL = 0;
var SECUINTER_NETCA_YES = 1;
var SECUINTER_NETCA_NO = 2;
/*NETCA和其他CA*/
var SECUINTER_NETCA_OTHER = 3;



var SECUINTER_SHA1_ALGORITHM = 1;
var SECUINTER_ALGORITHM_RC2 = 0;
var SECUINTER_ALGORITHM_DES = 6;
var SECUINTER_SHA1WithRSA_ALGORITHM = 2;

var SECUINTER_CERT_ENCODE_PEM = 1;


/*CA证书的CN*/
var CASTR = new Array("CN=NETCA", "CN=GDCA", "CN=WGCA");
var SECUINTER_CMS_ENCODE_BASE64 = 1;

/***************************************************/
/***********  载入控件 2012.10.29       ***********/
/***************************************************/
try {
    if (window.ActiveXObject) {
        document.writeln("<OBJECT classid=\"CLSID:11E27019-33D7-4B76-B73C-11DB7F496813\" id=oSecuInter CODEBASE=\"SecuInter.dll#version=4,1,0,1\" height=1  style=\"HEIGHT: 1px; LEFT: 10px; TOP: 28px; WIDTH: 1px\" width=1 VIEWASTEXT>");
        document.writeln("</OBJECT>");
        //DISPLAY: none
    } else {
        document.writeln("<embed id=oSecuInter0 type=application/x-xtx-axhost clsid={CLSID:11E27019-33D7-4B76-B73C-11DB7F496813}  width=1 height=1 />");
        oSecuInter = document.getElementById("oSecuInter0");
    }
} catch (e) {
    alert("请检查证书应用环境是否正确安装!");
}

/*作用是在WIN7下载入JS时就提示加载控件*/
var initialObj = new ActiveXObject("SecuInter.Utilities");


/***************************************************/
/***********  5.2.  检测类 2012.3.24       ***********/
/***************************************************/

/*5.2.1 判断控件是否安装成功 2010-01-28  */
function isPKIInstalled() {
    try {
        var oUtil = new ActiveXObject("SecuInter.Utilities");
        if (typeof (oUtil) == "object") {
            //if( (oUtil.object != null) )
            //{
            return true;
            //}
        }
        return false;
    }
    catch (e) {
        //alert("安装不成功!"+e.description);
        return false;
    }
    return false;
}
/*5.2.2   判断是否有网证通证书2010.09.02     ************/
function isHasCert(caType) {
    var MyCerts = getX509Certificates(SECUINTER_CURRENT_USER_STORE, SECUINTER_MY_STORE, SECUINTER_CERTTYPE_ALL, caType);
    if (MyCerts == null || MyCerts.Count <= 0) {
        alert("找不到证书，请插好密钥!");
        return false;
    }
    return true;
}
/*5.2.3     判断是否安装证书链2010.09.02     ************/
function isHasChain(caType) {
    var MyCerts = getX509Certificates(SECUINTER_CURRENT_USER_STORE, SECUINTER_ROOT_STORE, SECUINTER_CERTTYPE_ALL, caType);
    if (MyCerts == null || MyCerts.Count <= 0) {
        alert("未安装网证通证书链,请到www.cnca.net下载证书链,并安装!");
        return false;
    }
    return true;
}


/***************************************************/
/***********  5.3. 证书及证书解析 2012.3.23       ***********/
/***************************************************/


/*5.3.1 获取证书集,     2010-03-01 修改
whereType:SECUINTER_LOCAL_MACHINE_STORE = 0;SECUINTER_CURRENT_USER_STORE= 1;
storeType:SECUINTER_MY_STORE=0(个人);SECUINTER_OTHER_STORE:1(其他人);SECUINTER_CA_STORE= 2;SECUINTER_ROOT_STORE= 3;
certType: SECUINTER_CERTTYPE_ALL= 0;SECUINTER_CERTTYPE_SIGN= 1;SECUINTER_CERTTYPE_ENV= 2;
netcaType:SECUINTER_NETCA_ALL= 0;SECUINTER_NETCA_YES= 1;SECUINTER_NETCA_NO= 2;SECUINTER_NETCA_OTHER=3
*/
function getX509Certificates(whereType, storeType, certType, netcaType) {
    var oMyStore;
    var MyCerts;
    try {
        try {
            oMyStore = initialObj.CreateStoreObject();
        } catch (e) {
            oMyStore = new ActiveXObject("SecuInter.Store");
        }
    }
    catch (e) {
        alert("安装失败");
        return;
    }
    try {
        oMyStore.Open(whereType, storeType);
    }
    catch (e) {
        alert("打开证书库失败");
        return null;
    }
    var certs = oMyStore.X509Certificates;
    oMyStore.Close();
    oMyStore = null;
    try {
        try {
            MyCerts = initialObj.CreateX509CertificatesObject();
        } catch (e) {
            MyCerts = new ActiveXObject("SecuInter.X509Certificates");
        }
    } catch (e) {
        alert("安装失败");
        return;
    }

    for (i = 0; i < certs.Count; i++) {
        if (certType == SECUINTER_CERTTYPE_ALL) {
            issuer = certs.Item(i).Issuer;
            if (netcaType == SECUINTER_NETCA_ALL) {
                MyCerts.add(certs.Item(i));
            }
            else if (netcaType == SECUINTER_NETCA_YES) {
                if (issuer.indexOf("CN=NETCA") >= 0) {
                    MyCerts.add(certs.Item(i));
                }
            }
            else if (netcaType == SECUINTER_NETCA_NO) {
                if (issuer.indexOf("CN=NETCA") < 0) {
                    MyCerts.add(certs.Item(i));
                }
            }
            //限制可以使用NETCA证书和其他CA证书
            else if (netcaType == SECUINTER_NETCA_OTHER) {
                for (var j = 0; j < CASTR.length; j++) {
                    if (issuer.indexOf(CASTR[j]) >= 0) {
                        MyCerts.add(certs.Item(i));
                    }
                }
            }
        }
        else if (certType == SECUINTER_CERTTYPE_SIGN) {
            issuer = certs.Item(i).Issuer;
            if (netcaType == SECUINTER_NETCA_ALL) {
                if (certs.Item(i).KeyUsage == 3) {
                    MyCerts.add(certs.Item(i));
                }
                if (certs.Item(i).KeyUsage == -1) {
                    MyCerts.add(certs.Item(i));
                }
            }
            else if (netcaType == SECUINTER_NETCA_YES) {
                if (issuer.indexOf("CN=NETCA") >= 0) {
                    if (certs.Item(i).KeyUsage == 3) {
                        MyCerts.add(certs.Item(i));
                    }
                    if (certs.Item(i).KeyUsage == -1) {
                        MyCerts.add(certs.Item(i));
                    }
                }
            }
            else if (netcaType == SECUINTER_NETCA_NO) {
                if (issuer.indexOf("CN=NETCA") < 0) {
                    if (certs.Item(i).KeyUsage == 3) {
                        MyCerts.add(certs.Item(i));
                    }
                    if (certs.Item(i).KeyUsage == -1) {
                        MyCerts.add(certs.Item(i));
                    }
                }
            }
            //限制可以使用NETCA证书和其他CA证书
            else if (netcaType == SECUINTER_NETCA_OTHER) {
                for (var j = 0; j < CASTR.length; j++) {
                    if (issuer.indexOf(CASTR[j]) >= 0) {
                        if (certs.Item(i).KeyUsage == 3) {
                            MyCerts.add(certs.Item(i));
                        }
                        if (certs.Item(i).KeyUsage == -1) {
                            MyCerts.add(certs.Item(i));
                        }
                    }
                } //end this for
            }
        }
        else if (certType == SECUINTER_CERTTYPE_ENV) {
            issuer = certs.Item(i).Issuer;
            if (netcaType == SECUINTER_NETCA_ALL) {
                if (certs.Item(i).KeyUsage == 12) {
                    MyCerts.add(certs.Item(i));
                }
                if (certs.Item(i).KeyUsage == -1) {
                    MyCerts.add(certs.Item(i));
                }

            }
            else if (netcaType == SECUINTER_NETCA_YES) {
                if (issuer.indexOf("CN=NETCA") >= 0) {
                    if (certs.Item(i).KeyUsage == 12) {
                        MyCerts.add(certs.Item(i));
                    }
                    if (certs.Item(i).KeyUsage == -1) {
                        MyCerts.add(certs.Item(i));
                    }
                }
            }
            else if (netcaType == SECUINTER_NETCA_NO) {
                if (issuer.indexOf("CN=NETCA") < 0) {
                    if (certs.Item(i).KeyUsage == 12) {
                        MyCerts.add(certs.Item(i));
                    }
                    if (certs.Item(i).KeyUsage == -1) {
                        MyCerts.add(certs.Item(i));
                    }
                }
            }
            //限制可以使用NETCA证书和其他CA证书
            else if (netcaType == SECUINTER_NETCA_OTHER) {
                for (var j = 0; j < CASTR.length; j++) {
                    if (issuer.indexOf(CASTR[j]) >= 0) {
                        //	alert(certs.Item(i).Subject+":"+certs.Item(i).KeyUsage);					
                        if (certs.Item(i).KeyUsage == 12) {
                            MyCerts.add(certs.Item(i));
                        }
                        if (certs.Item(i).KeyUsage == -1) {
                            MyCerts.add(certs.Item(i));
                        }
                    }
                } //end this for
            }
        }
    } //END FOR
    return MyCerts;

}

/*5.3.2 获取证书              //2010-03-01 修改
whereType:SECUINTER_LOCAL_MACHINE_STORE = 0(本地计算机);SECUINTER_CURRENT_USER_STORE= 1(当前用户);
storeType:SECUINTER_MY_STORE=0(个人);SECUINTER_OTHER_STORE:1(其他人);SECUINTER_CA_STORE= 2;SECUINTER_ROOT_STORE= 3;
certType: SECUINTER_CERTTYPE_ALL= 0(所有);SECUINTER_CERTTYPE_SIGN= 1(签名);SECUINTER_CERTTYPE_ENV= 2(加密);
netcaType:SECUINTER_NETCA_ALL= 0(所有);SECUINTER_NETCA_YES= 1(网证通);SECUINTER_NETCA_NO= 2(非网证通);
*/
function getX509Certificate(whereType, storeType, certType, netcaType) {
    var MyCerts = getX509Certificates(whereType, storeType, certType, netcaType);
    if (MyCerts == null) {
        return null;
    }
    if (MyCerts.Count > 0) {
        return MyCerts.SelectCertificate();
    }
    window.status = "";
    return null;
}
/*5.3.3 获取证书            
certContent:证书BASE64编码
*/
function getX509CertificateByString(certContent) {
    var oX509Certificate = null;
    try {
        try {
            oX509Certificate = initialObj.CreateX509CertificateObject();
        } catch (e) {
            oX509Certificate = new ActiveXObject("SecuInter.X509Certificate");
        }
    }
    catch (e) {
        alert("安装不成功!");
        return null;
    }
    oX509Certificate.Decode(certContent);
    return oX509Certificate;
}
/*
5.3.4 获取证书        //2012-10-29 修改     
*/
function getX509CertificateByValue(StoreLocation, StoreName, certType, netcaType, iValueType, value) {
    if (value == "") {
        alert("查找证书的值太短!");
        return null;
    }
    var MyCerts = getX509Certificates(StoreLocation, StoreName, certType, netcaType);
    for (i = 0; i < MyCerts.Count; i++) {
        var oCert = MyCerts.Item(i);
        if (getX509CertificateInfo(oCert, iValueType).toLowerCase() == value.toLowerCase()) {
            return oCert;
        }
    }
    window.status = "";
    return null;
}
/*
5.3.5 获取证书            
iValueType:参见规范5.1.1
*/
function getX509CertificateInfo(oCert, iValueType) {
    if (oCert == null) {
        return "";
    }
    if (iValueType == 0) {
        //2012-12-04 modify luhanmin 去掉了头尾
        var certPem = oCert.Encoded(SECUINTER_CERT_ENCODE_PEM);
        var certHeader = "-----BEGIN CERTIFICATE-----\r\n";
        var certEnd = "-----END CERTIFICATE-----\r\n";
        if (certPem.indexOf(certHeader) >= 0) {
            certPem = certPem.substring(certHeader.length, certPem.length);
            certPem = certPem.substring(0, certPem.length - certEnd.length);
        }
        return certPem;
    }
    if (iValueType == 1) {
        return initialObj.BinaryToHex(oCert.Thumbprint(SECUINTER_SHA1_ALGORITHM)).toUpperCase();
    }
    else if (iValueType == 2) {
        return oCert.SerialNumber;
    }
    else if (iValueType == 3) {
        return oCert.Subject;
    }
    else if (iValueType == 4) {
        return oCert.Issuer;
    }
    else if (iValueType == 5) {//证书有效期起
        var fromDate = new Date(oCert.ValidFromDate);
        return fromDate.toDateString();
    }
    else if (iValueType == 6) {//证书有效期止
        var toDate = new Date(oCert.ValidToDate);
        return toDate.toDateString();
    }
    else if (iValueType == 7) {
        return "" + oCert.KeyUsage;
    }
    else if (iValueType == 9) {
        var caType = getX509CertificateInfo(oCert, 21);
        if (caType == "1") {
            var rt = "";
            rt = getX509CertificateInfo(oCert, 23);
            if (rt == "") {
                rt = getX509CertificateInfo(oCert, 36);
                if (rt == "") {
                    rt = getX509CertificateInfo(oCert, 1);
                }
            }
            return rt;
        }
        else if (caType == "2") {
            return getX509CertificateInfo(oCert, 51);
        }
    }
    else if (iValueType == 10) {
        if (getX509CertificateInfo(oCert, 21) == "1") {
            var rt = "";
            rt = getX509CertificateInfo(oCert, 23);
            if (rt == "") {
                rt = getX509CertificateInfo(oCert, 36);
                if (rt == "") {
                    rt = getX509CertificateInfo(oCert, 31);
                }
            }
            return rt;
        }
        else if (getX509CertificateInfo(oCert, 21) == "2") {
            return getX509CertificateInfo(oCert, 51);
        }
    }
    else if (iValueType == 11) { // 证书主题名称；有CN项取CN项值；无CN项，取O的值；  
        var rvStr = getX509CertificateInfo(oCert, 12);
        if (rvStr == "") {
            rvStr = getX509CertificateInfo(oCert, 13);
        }
        return rvStr;
    }
    else if (iValueType == 12) { //Subject中的CN项（人名）  
        var subjectDN = getX509CertificateInfo(oCert, 3)
        return parseDN(subjectDN, "CN");
    }
    else if (iValueType == 13) { // Subject中的O项（人名）  
        var subjectDN = getX509CertificateInfo(oCert, 3)
        return parseDN(subjectDN, "O");
    }
    else if (iValueType == 14) { // Subject中的地址（L项） 
        var subjectDN = getX509CertificateInfo(oCert, 3)
        return parseDN(subjectDN, "L");
    }
    else if (iValueType == 15) {//证书颁发者的Email
        return "" + oCert.GetInfo(2);
    }
    else if (iValueType == 16) { // Subject中的部门名（OU项） 
        var subjectDN = getX509CertificateInfo(oCert, 3)
        return parseDN(subjectDN, "OU");
    }
    else if (iValueType == 17) { // 用户国家名（C项）  
        var subjectDN = getX509CertificateInfo(oCert, 3)
        return parseDN(subjectDN, "C");
    }
    else if (iValueType == 18) { // 用户省州名（S项） 
        var subjectDN = getX509CertificateInfo(oCert, 3)
        return parseDN(subjectDN, "S");
    }
    else if (iValueType == 21) {
        issuer = oCert.Issuer;
        if (issuer.indexOf(CASTR[0]) >= 0) {
            return "1";
        }
        if (issuer.indexOf(CASTR[1]) >= 0) {
            return "2";
        }
        if (issuer.indexOf(CASTR[2]) >= 0) {
            return "3";
        }
        return "0";

    }
    else if (iValueType == 22) { // 证书类型  
        return "";
    }
    else if (iValueType == 23) { // 证书唯一标识(一般为客户号等)  
        if (getX509CertificateInfo(oCert, 21) == "1") {
            return "";
        }
        else if (getX509CertificateInfo(oCert, 21) == "2") {
            return getX509CertificateInfo(oCert, 51);
        }
    }
    else if (iValueType == 31) { // //证书旧姆印 
        if (getX509CertificateInfo(oCert, 21) == "1")//NETCA 
        {
            try {
                return initialObj.BinaryToHex(oCert.PrevCertThumbprint(SECUINTER_SHA1_ALGORITHM)).toUpperCase();
            }
            catch (e) {
                return "";
            }
        }
        else {
            return "";
        }
    }
    else if (iValueType == 32) { // 纳税人编码  
        return "";
    }
    else if (iValueType == 36) { // 证书证件号码扩展域 
        if (getX509CertificateInfo(oCert, 21) == "1")//NETCA 
        {
            try {
                //注意不同项目的OID不同
                //NETCA通用定义OID为1.3.6.1.4.1.18760.1.12.11
                //深圳项目中采用（3家CA都采用此做唯一标识）   2.16.156.112548
                return oCert.GetUTF8ExtValue("1.3.6.1.4.1.18760.1.12.11");
            }
            catch (e) {
                return "";
            }
        }
        else {
            return "";
        }
    }
    else if (iValueType == 51) { // GDCA 证书信任号  
        if (getX509CertificateInfo(oCert, 21) == "2")//GDCA 
        {
            try {
                var oid = "1.2.86.21.1.3";
                return oCert.GetUTF8ExtValue(oid);
                //temp = utilObj.Decode(oCert.GetUTF8ExtValue(oid));
                //rvStr = temp.substr(2,temp.length-2);
            }
            catch (e) {
                return "";
            }
        }
        else {
            return "";
        }
    }
    return "";
}
/*
5.3.6 获取证书特定OID的信息            
暂不实现
*/
function getX509CertificateInfoByOID(oCert, OID) {
    return "";
}

/**************************************************************************/
/************************  5.4 签名功能 2009.11.13   **************************/
/**************************************************************************/
/*** 5.4.1   PKCS7签名 对应以前的sign函数 2009-12-21 ***/
function signPKCS7(bContent, IsNotHasSource) {
    return signPKCS7ByPwd(bContent, IsNotHasSource, "");
}
/*** 5.4.2   PKCS7签名 带pin码的签名 对应以前的sign函数 2009-12-21 ***/
function signPKCS7ByPwd(bContent, IsNotHasSource, pwd) {
    var oCert = getX509Certificate(SECUINTER_CURRENT_USER_STORE, SECUINTER_MY_STORE, SECUINTER_CERTTYPE_SIGN, SECUINTER_NETCA_OTHER);
    if (oCert == null) {
        alert("未选择证书,请检查是否插入密钥!");
        return null;
    }
    return signPKCS7ByCert(bContent, oCert, IsNotHasSource, pwd);
}
/*** 5.4.3     PKCS7签名,兼容以前 2009-12-21 ***/
function signNetCA(bContent, IsNotHasSource) {
    return signPKCS7(bContent, IsNotHasSource);
}


/*** 5.4.4    使用证书进行PKCS7签名 2009-12-21  ***/
function signPKCS7ByCert(bContent, oCert, IsNotHasSource, pwd) {
    if (bContent == "") {
        alert("原文内容为空!");
        return null;
    }
    var oSigner;
    var oSignedData;


    try {

        try {
            oSigner = initialObj.CreateSignerObject();
        } catch (e) {
            oSigner = new ActiveXObject("SecuInter.Signer");
        }

        try {
            oSignedData = initialObj.CreateSignedDataObject();
        } catch (e) {

            oSignedData = new ActiveXObject("SecuInter.SignedData");
        }
    }
    catch (e) {
        alert("安装不成功!");
        return null;
    }
    oSigner.Certificate = oCert;
    oSigner.HashAlgorithm = SECUINTER_SHA1_ALGORITHM;
    oSigner.UseSigningCertificateAttribute = false;
    oSigner.UseSigningTime = false;
    if (pwd != "") {
        var ok = oSigner.SetUserPIN(pwd);
    }
    oSignedData.content = bContent;
    oSignedData.Detached = IsNotHasSource;

    var arrRT = oSignedData.sign(oSigner, SECUINTER_CMS_ENCODE_BASE64);
    oSignedData = null;
    oSigner = null;
    return arrRT;
}


/***     5.4.5 PKCS#7签名验证 修改名字,原名verify ,修改验证显示时间戳的方法 2009-12-21 ***/
function verifyPKCS7(bContent, bSignData, isNotHasSource) {
    var oSigner;
    var oSignedData;

    var oX509Certificate;
    try {

        try {
            oSigner = initialObj.CreateSignerObject();
        } catch (e) {
            oSigner = new ActiveXObject("SecuInter.Signer");
        }

        try {
            oSignedData = initialObj.CreateSignedDataObject();
        } catch (e) {
            oSignedData = new ActiveXObject("SecuInter.SignedData");
        }

    }
    catch (e) {
        alert("安装不成功!");
        return null;
    }
    if (isNotHasSource == true) {//不含原文情况,将原文设入签名数据中
        oSignedData.Content = bContent;
    }
    if (!oSignedData.Verify(bSignData, 0)) {
        alert("签名验证不正确");
        return null;
    }
    if (isNotHasSource == false) {
        //含原文情况,比对原文和签名信息,进行验证
        if (initialObj.ByteArraytoString(bContent) != initialObj.ByteArraytoString(oSignedData.content)) {
            alert("签名与原文不一致!");
            return null;
        }
    }


    var iCertCount = oSignedData.Signers.Count;

    if (iCertCount == 1) {
        //oSignedData.Signers.Item(0).Certificate.Display();
        if (oSignedData.hasTSATimestamp(0)) {
            alert("签名时间=" + oSignedData.getTSATimeStamp(0));
        }
        oX509Certificate = oSignedData.Signers.Item(0).Certificate;
    }
    else {

        for (var i = 0; i < iCertCount; i++) {
            oSignedData.Signers.Item(i).Certificate.Display();
            if (oSignedData.hasTSATimestamp(i)) {
                alert("签名时间=" + oSignedData.getTSATimeStamp(i));
            }
            oX509Certificate = oSignedData.Signers.Item(0).Certificate;
        }
    }

    oSignedData = null;
    oSigner = null;

    return oX509Certificate;
}

/***5.4.7	PKCS#1签名 ***/
function signPKCS1ByCert(bContent, oCert) {
    var oSignature;
    try {
        try {
            oSignature = initialObj.CreateSignatureObject();
        } catch (e) {
            oSignature = new ActiveXObject("SecuInter.Signature");
        }
    }
    catch (e) {
        alert("安装不成功!");
        return null;
    }

    oSignature.Certificate = oCert;
    oSignature.Algorithm = SECUINTER_SHA1WithRSA_ALGORITHM;
    var arrRT = oSignature.sign(bContent)

    var rt = initialObj.Base64Encode(arrRT);
    oSignature = null;
    return rt;
}
/*** 5.4.7    纯签名 ***/
function signPKCS1(bContent) {
    var oCert = getX509Certificate(SECUINTER_CURRENT_USER_STORE, SECUINTER_MY_STORE, SECUINTER_CERTTYPE_SIGN, SECUINTER_NETCA_OTHER);
    if (oCert == null) {
        alert("未选择证书!");
        return null;

    }
    return signPKCS1ByCert(bContent, oCert);
}
/*** 5.4.9	PKCS#1签名验证 ***/
function verifyPKCS1(bContent, bSignData, oCert) {
    if (oCert == null) {
        alert("未选择证书!");
        return null;
    }

    var oSignature;
    try {

        try {
            oSignature = initialObj.CreateSignatureObject();
        } catch (e) {
            oSignature = new ActiveXObject("SecuInter.Signature");
        }
    }
    catch (e) {
        return -1;
    }
    oSignature.Certificate = oCert;
    oSignature.Algorithm = SECUINTER_SHA1WithRSA_ALGORITHM;

    if (!oSignature.Verify(bContent, initialObj.Base64Decode(bSignData))) {
        return -3;
    }

    oSignedData = null;
    oCert = null;

    return 0;
}
/*** 5.4.10	PKCS#1签名验证 ***/
function verifyPKCS1(bContent, bSignData) {
    var oCert = getX509Certificate(SECUINTER_CURRENT_USER_STORE, SECUINTER_MY_STORE, SECUINTER_CERTTYPE_SIGN, SECUINTER_NETCA_OTHER);
    if (oCert == null) {
        alert("未选择证书!");
        return null;
    }

    var oSignature;
    try {

        try {
            oSignature = initialObj.CreateSignatureObject();
        } catch (e) {
            oSignature = new ActiveXObject("SecuInter.Signature");
        }
    }
    catch (e) {
        return -1;
    }
    oSignature.Certificate = oCert;
    oSignature.Algorithm = SECUINTER_SHA1WithRSA_ALGORITHM;

    if (!oSignature.Verify(bContent, initialObj.Base64Decode(bSignData))) {
        return -3;
    }


    oSignedData = null;
    oCert = null;

    return 0;
}

/***   5.4.11	PKCS#7多人签名 2010-09-02 ***/
function coSignPKCS7(bContent, bProcContent, IsNotHasSource) {

    var oSigner;
    var oSignedData;
    try {

        try {
            oSigner = initialObj.CreateSignerObject();
        } catch (e) {
            oSigner = new ActiveXObject("SecuInter.Signer");
        }

        try {
            oSignedData = initialObj.CreateSignedDataObject();
        } catch (e) {
            oSignedData = new ActiveXObject("SecuInter.SignedData");
        }
    }
    catch (e) {
        alert("安装不成功!");
        return null;
    }
    if (IsNotHasSource) {
        oSignedData.content = bContent
    }
    if (!oSignedData.verify(bProcContent, 0)) {
        alert("原始签名信息验证没通过!");
        return null;
    }
    var oCert = getX509Certificate(SECUINTER_CURRENT_USER_STORE, SECUINTER_MY_STORE, SECUINTER_CERTTYPE_SIGN, SECUINTER_NETCA_OTHER);
    if (oCert == null) {
        alert("未选择证书!");
        return null;
    }

    oSigner.Certificate = oCert;
    oSigner.HashAlgorithm = SECUINTER_SHA1_ALGORITHM;
    oSigner.UseSigningCertificateAttribute = false;
    oSigner.UseSigningTime = false;
    //oSignedData.content = bContent;
    //oSignedData.Detached = IsNotHasSource;//加后出错.注意

    var arrRT = oSignedData.sign(oSigner, SECUINTER_CMS_ENCODE_BASE64)
    oSignedData = null;
    oSigner = null;
    return arrRT;

}
/***    5.4.12	PKCS#7时间戳签名 2010-09-02 ***/
function signPKCS7WithTSA(bContent, tsaUrl, IsNotHasSource) {
    if (bContent == "") {
        alert("原文内容为空!");
        return null;
    }
    if (tsaUrl == "") {
        alert("时间戳URL为空!");
        return null;
    }
    var oSigner;
    var oSignedData;
    var oX509Certificate;

    var oCert = getX509Certificate(SECUINTER_CURRENT_USER_STORE, SECUINTER_MY_STORE, SECUINTER_CERTTYPE_SIGN, SECUINTER_NETCA_OTHER);
    if (oCert == null) {
        alert("未选择证书!");
        return null;
    }
    try {

        try {
            oSigner = initialObj.CreateSignerObject();
        } catch (e) {
            oSigner = new ActiveXObject("SecuInter.Signer");
        }

        try {
            oSignedData = initialObj.CreateSignedDataObject();
        } catch (e) {
            oSignedData = new ActiveXObject("SecuInter.SignedData");
        }

        try {
            oX509Certificate = initialObj.CreateX509CertificateObject();
        } catch (e) {
            oX509Certificate = new ActiveXObject("SecuInter.X509Certificate");
        }

    }
    catch (e) {
        alert("安装不成功!");
        return null;
    }
    oSigner.Certificate = oCert;
    oSigner.HashAlgorithm = SECUINTER_SHA1_ALGORITHM;
    oSigner.UseSigningCertificateAttribute = false;
    oSigner.UseSigningTime = true;
    oSignedData.content = bContent;
    oSignedData.Detached = IsNotHasSource;

    var arrRT = oSignedData.SignWithTSATimeStamp(oSigner, tsaUrl, "", oX509Certificate, SECUINTER_CMS_ENCODE_BASE64);
    oSignedData = null;
    oSigner = null;
    return arrRT;
}

/***************************************************/
/***********   5.5 加密类 2012.3.23         ***********/
/***************************************************/

/***    5.5.1	PKCS#7加密 2010-09-02 ***/

function encryptPKCS7(bContent, oCert) {
    var oEnv;
    try {
        try {
            oEnv = initialObj.CreateEnvelopedDataObject();
        } catch (e) {
            oEnv = new ActiveXObject("SecuInter.EnvelopedData");
        }
    }
    catch (e) {
        alert("安装不成功!");
        return null;
    }

    oEnv.Algorithm = SECUINTER_ALGORITHM_RC2;
    oEnv.Recipients.Add(oCert);
    oEnv.content = bContent;
    var arrRT = oEnv.encrypt(SECUINTER_CMS_ENCODE_BASE64);
    oEnv = null;
    return arrRT;
}
/***    5.5.2	PKCS#7解密 2010-09-02 ***/
function decryptPKCS7(bEnvData) {
    var oEnv;
    try {
        try {
            oEnv = initialObj.CreateEnvelopedDataObject();
        } catch (e) {
            oEnv = new ActiveXObject("SecuInter.EnvelopedData");
        }
    }
    catch (e) {
        alert("安装不成功!");
        return null;
    }
    oEnv.decrypt(bEnvData);
    //oEnv.Recipients.Item(0).Display();
    var arrRt = oEnv.content;
    oEnv = null;
    return initialObj.ByteArraytoString(arrRt);
}
/***************************************************/
/***********   5.6 工具类 2012.3.23         ***********/
/***************************************************/

/** 5.6.1 Base64编码 
* 输入：string sSource
* 输出：编码值
*/
function base64Encode(sSource) {
    var utilobj;

    try {
        utilobj = new ActiveXObject("SecuInter.Utilities");
    }
    catch (e) {
        alert("安装不成功!");
        return null;
    }

    return utilobj.Base64Encode(sSource);
}

/** 5.6.2 Base64解码 
* 输入：string strBase64
* 输出：解码值
*/
function base64Decode(strBase64) {
    var utilobj;

    try {
        utilobj = new ActiveXObject("SecuInter.Utilities");
    }
    catch (e) {
        alert("安装不成功!");
        return null;
    }

    return utilobj.Base64Decode(strBase64);
}
/** 5.6.3	获取随机数 
* 输入：int 长度
* 输出：随机数
*/
function getRandom(len) {
    var utilobj;
    try {
        utilobj = new ActiveXObject("SecuInter.Utilities");
    }
    catch (e) {
        alert("安装不成功!");
        return null;
    }

    return utilobj.GetRandom(len);
}
/** 5.6.4 得到Hash值，默认算法为sha1 
* 输入：string 
* 输出：hash值(base64编码）
*/
function hash(strBase64) {
    var utilobj;

    try {
        utilobj = new ActiveXObject("SecuInter.Utilities");
    }
    catch (e) {
        alert("安装不成功!");
        return null;
    }
    return utilobj.BinaryToHex(utilobj.Hash(SECUINTER_SHA1_ALGORITHM, strBase64));

}

/*********************************************************************************/
/***********   6.2 读写文件工具类 2012.04.08 luhanmin@cnca.net modify  ***********/
/*********************************************************************************/


/** 6.2.1 读文件 
* 输入：string 文件名（含路径）
* 输出：二进制文件内容
*/

function readFile(sFilePath) {

    var fileProcessObj = new ActiveXObject("LittleUtils.BinaryFile");
    return fileProcessObj.Read(sFilePath);

}
/** 6.2.2 写文件 
* 输入：sFilePath：string 文件名（含路径）
*       bContent：二进制文件内容
*/
function writeFile(sFilePath, bContent) {
    if (sFilePath == "") {
        alert("文件路径为空");
        return;
    }
    var fileProcessObj;
    try {
        fileProcessObj = new ActiveXObject("LittleUtils.BinaryFile"); ;
    }
    catch (e) {
        alert("安装不成功!");
        return;
    }
    return fileProcessObj.Write(sFilePath, bContent);
}
/**
* 解析x509证书 解析原则： 关键是找到符合条件的字符起始、截止位。 缺点:,会截断字符
* 1.找到需要解析的字符，如"CN"，取整个字符在"CN"后面的字符
* 2.判断后面的字符是否有"=",并且等号很近（C,O特例，否则必须在1到2个字符间） 3.取等号后面的字符，取"," 4.找到=和,之间的字符
* 5.上述条件不满足，就循环找下一个满足条件的。
*/
function parseDN(dn, name) {

    var superName = name.toUpperCase();
    var superDn = dn.toUpperCase();
    var beginDot = 0; // 临时开始点
    var endDot = 0; // 结束点
    //alert("DN::::::3"+dn+"   name"+name);

    while (true) {
        var begin = superDn.indexOf(superName); // 开始点
        if (begin < 0)
            return ""; // 找不到

        superDn = superDn.substring(begin + superName.length, superDn.length); // 取后面的串；

        var begin2 = superDn.indexOf("=");
        if (begin2 < 0)
            return ""; // 后面没等号
        else if (begin2 > 1) {
            beginDot = beginDot + begin + superName.length;
            continue; // 后面=号过远
        }
        else if ((superName == "C" || superName == "O")
					&& begin2 == 1) { // 区别C和CN
            beginDot = beginDot + begin + superName.length();
            continue; // 后面=号过远
        }
        superDn = superDn.substring(begin2 + "=".length, superDn.length); // 取后面的串；
        var end = superDn.indexOf(",");
        beginDot = beginDot + begin + superName.length + begin2
					+ "=".length;
        if (end < 0) { // 后面没等号
            endDot = beginDot + superDn.length;
            return dn.substring(beginDot, endDot);
        } else { // 后面=号过远
            endDot = beginDot + end;
            return dn.substring(beginDot, endDot);
        }

    }

}

function getCertByValue(key) {
    return getX509CertificateByValue(SECUINTER_CURRENT_USER_STORE, SECUINTER_MY_STORE, SECUINTER_CERTTYPE_SIGN, SECUINTER_NETCA_YES, 9, key);
}

function getCerts() {
    return getX509Certificates(SECUINTER_CURRENT_USER_STORE, SECUINTER_MY_STORE, SECUINTER_CERTTYPE_SIGN, SECUINTER_NETCA_YES);
}
