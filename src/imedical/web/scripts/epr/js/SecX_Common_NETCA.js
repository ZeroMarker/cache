/***************************************************/
/***********  以下为东华接口      ***********/
/***************************************************/
var certPwd;
// 1.function GetUserList() 返回当前插入的UsbKey中用户列表,格式 Name||key&&& Name||key
// 注:Name是用于登录,选择UsbKey时,显示的名称,
// Key为证书号或者用以取UsbKey相关数据的信息
function GetUserList() {
    var rt = "";

    var MyCerts = getCerts();
    for (i = 0; i < MyCerts.Count; i++) {
        var oCert = MyCerts.Item(i);
        if (i == 0) {
            rt = rt + getX509CertificateInfo(oCert, 11) + "||" + getX509CertificateInfo(oCert, 9);
        }
        else {
            rt = rt + "&&&" + getX509CertificateInfo(oCert, 11) + "||" + getX509CertificateInfo(oCert, 9);
        }
    }
    return rt;
}

// 2. function HashData(InData) 对传入的数据生成Hash值
function HashData(InData) {
    return hash(InData);
}

// 3. function SignedData(content, key) 对传入的数据进行签名, key 参见function 1
function SignedData(content, key) {
    if ("" == content)
        return "";

    var oCert = getCertByValue(key);
    //return signPKCS7ByCert(content, oCert, false, certPwd); //带源文pkcs7签名
    try{

            return signPKCS7ByCert(content,oCert,false,certPwd);//带源文pkcs7签名

   }

catch (e){

            alert("签名错误，请检查是否插入KEY，或者KEY的密码是否正确");

            return "";

   }

}

// 4. function GetSignCert(key) 获取证书pem字符串, key参见function 1
function GetSignCert(key) {
    var oCert = getCertByValue(key);
    var certPem = getX509CertificateInfo(oCert, 0);
    return certPem;
}

// 5. function GetUniqueID(cert) 获取证书唯一编码,参数为证书
function GetUniqueID(cert) // 如果cert是数字证书的Base64编码,则我们可以实现
{
    var oCert = getX509CertificateByString(cert);
    return getX509CertificateInfo(oCert, 9);
}

// 6. function GetCertNo(key) 获取证书编号
function GetCertNo(key) {
    var oCert = getCertByValue(key);
    return getX509CertificateInfo(oCert, 2);
}

// 7.获取UsbKey中的信息
function getUsrSignatureInfo(key) {
    var oCert = getCertByValue(key);
    //oCert.Display();
    var usrSignatureInfo = new Array();
    usrSignatureInfo["identityID"] = ""; // 身份证号;
    usrSignatureInfo["certificate"] = GetSignCert(key); // 证书; GetSignCert(key)

    usrSignatureInfo["certificateNo"] = getX509CertificateInfo(oCert, 9); // 证书号;
    usrSignatureInfo["CertificateSN"] = getX509CertificateInfo(oCert, 2); // 证书序列号;

    usrSignatureInfo["uKeyNo"] = ""; // 我们壳子上面没有Key的编号,有客户的名字是否可以?
    usrSignatureInfo["signImage"] = ""; // sealArry[0]; // 签名图是否指的是电子印章/或手写签名图片?
    usrSignatureInfo["UsrCertCode"] = GetUniqueID(usrSignatureInfo["certificate"]); // 证书唯一编码,由于CA公司不同,所以此处为可区别证书的编码(可为uKeyNo或CertificateNo等等)
    usrSignatureInfo["CertName"] = getX509CertificateInfo(oCert, 11); // 证书中文名;

    //try{
    //	var certPem= getX509CertificateInfo(oCert,0);
    //	var oCertTmp=getX509CertificateByString(certPem);
    //	var UniqueID= getX509CertificateInfo(oCertTmp,9);
    //	alert("UniqueID:"+UniqueID);
    //}
    //catch (e)
    //{   
    //	alert("e=!"+e.description);
    //}
    return usrSignatureInfo;
}

function Login(form, key, pwd) {
    if (certPwd == "") {
        alert("请输入密码");
        return "";
    }
    certPwd = pwd;
    //alert("key="+key+";certPwd="+certPwd);

    //以下三个已经赋值
    //strServerRan  随机数
    //strServerSignedData 服务器对随机数的签名 
    //strServerCert 服务器证书
    return true;
}