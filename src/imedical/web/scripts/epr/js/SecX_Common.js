/////const //////////////////////////
var CERT_SRC_BASE64	=					1;		//证书来自Base64字符串
var CERT_SRC_UNIQUEID =					2;		//证书来自唯一表示
var CERT_SRC_FILE =						3;		//证书来自der文件
var CERT_SRC_CONTAINER_UCA = 			4;		//证书来自UCA类型证书容器
var CERT_SRC_CONTAINER_SIGN	=			5;		//证书来自容器下签名证书
var CERT_SRC_CONTAINER_ENC =			6;		//证书来自容器下加密证书
var CERT_SRC_CONTAINER_BOTH	=			7;		//证书来自容器下签名加密证书
var CERT_SRC_PKCS12	=					8;		//证书来自PKCS12文件

var CERT_DST_BASE64	=					1;		//导出证书为Base64字符串
var CERT_DST_DERFILE =					2;		//导出证书为der文件
var CERT_DST_P12 =						3;		//到出证书为PKCS12文件

var CERT_XML_SUBJECT =					1;		//从XML配置文件取用户名
var CERT_XML_UNIQUEID =					2;		//从XML配置文件取用户唯一表识
var CERT_XML_DEPT =						3;		//从XML配置文件取用户所有者部门
var CERT_XML_ISSUE =					4;		//从XML配置文件取用户证书颁发者
var CERT_XML_STATE =					5;		//从XML配置文件取用户证书使用状态
var CERT_XML_TRADETYPE =				6;		//从XML配置文件取用户证书应用类型
var CERT_XML_PASSWORD =					7;		//从XML配置文件取用户证书私钥保护口令
var CERT_XML_DEVICETYPE =				8;		//从XML配置文件取用户证书介质类型
var CERT_XML_CATYPE	 =					9;		//从XML配置文件取用户证书CA类型
var CERT_XML_KEYTYPE =					10;		//从XML配置文件取用户证书密钥类型
var CERT_XML_SIGNSN	=					11;		//从XML配置文件取用户签名证书序列号
var CERT_XML_EXCHSN	=					12;		//从XML配置文件取用户加密证书序列号
var CERT_XML_DEVICENAME =				13;		//从XML配置文件取用户证书介质名称
var CERT_XML_DEVICEPROVIDER =			14;		//从XML配置文件取用户证书介质提供者
var CERT_XML_DEVICEAFFIX =				15;		//从XML配置文件取用户证书介质附加库
var CERT_XML_SIGNPATH =					16;		//从XML配置文件取用户签名证书路径
var CERT_XML_EXCHPATH =					17;		//从XML配置文件取用户加密证书路径
var CERT_XML_SIGNPFXPATH =				18;		//从XML配置文件取用户签名P12证书路径
var CERT_XML_EXCHPFXPATH =				19;		//从XML配置文件取用户加密P12证书路径
var CERT_XML_CHAINPATH =				20;		//从XML配置文件取用户证书链路径
var CERT_XML_CRLPATH =					21;		//从XML配置文件取用户证书作废列表路径
var CERT_XML_UNIQUEIDOID =				22;		//从XML配置文件取用户证书UniqueID的OID
var CERT_XML_VERIFYTYPE	=				23;		//从XML配置文件取用户证书验证类型
var CERT_XML_CACOUNTS =					24;		//从XML配置文件取用户证书根证书个数
var CERT_XML_CANUMTYPE =				25;		//从XML配置文件取用户证书跟证书类型

var CRYPT_CFGTYPE_UNSET =				0;		//用户应用类型未定义
var CRYPT_CFGTYPE_CSP =					1;		//用户应用类型CSP
var CRYPT_CFGTYPE_P11 =					2;		//用户应用类型P11
var CRYPT_CFGTYPE_P12 =					3;		//用户应用类型软算法

var ENVELOP_ENC =						1;		//加密P7数字信封
var ENVELOP_DEC =						0;		//解密P7数字信封
var CRYPT_ALG_HASH =					1;		//Hash标志位
var CRYPT_ALG_SYMM =					2;		//对称算法标志位
var CRYPT_ALG_MODE =					3;		//对称算法模式

////CUSTOM CERT OID////////////////////////////////
var CERT_OID_VERSION =					1;		//证书版本号
var CERT_OID_SN =					2;		//证书序列号
var CERT_OID_SIGNALG =					3;		//证书签名算法
var CERT_OID_ISSUERNAME =				4;		//证书颁发者
var CERT_OID_NOTBEFORE =				5;		//证书生效日期
var CERT_OID_NOTAFTER =					6;		//证书过期日期
var CERT_OID_PUBLICKEY =				7;		//证书公钥
var CERT_OID_UNIQUEID =					8;		//证书唯一标识

var g_xmluserlist;
//g_versionFlag表示版本信息，0为BJCASecCOM 3.0版本，1为BJCASecCOM 2.4版本
var g_versionFlag = 0 ;

var g_objXML = new CXMLSignRule();

/////define object  /////////////////////////////////
try
{
		//	var oTest = new ActiveXObject("BJCASecCOM.BJCASecCOMV2");//这一行代码不能省略，否则在没有try的错误消息，不能进入catch中
    	//document.writeln("<OBJECT classid=\"clsid:FCAA4851-9E71-4BFE-8E55-212B5373F040\" height=1 id=bjcactrl  style=\"HEIGHT: 1px; LEFT: 10px; TOP: 28px; WIDTH: 1px\" width=1 VIEWASTEXT>");
    	//document.writeln("</OBJECT>");
    	//BJCASecCOM 3.0版本
    	//g_versionFlag = 0;
		throw new Error("仅使用secx2.4版本");
}
catch(e)
{
	try
	{
		var oCert = new ActiveXObject("BJCASecCOM.Certificate");
		var oCrypto = new ActiveXObject("BJCASecCOM.Crypto");
		var oDevice = new ActiveXObject("BJCASecCOM.DeviceMgr");
		var oUtil = new ActiveXObject("BJCASecCOM.Util");
		
		document.writeln("<OBJECT classid=\"clsid:0CF5259B-A812-4B6E-9746-ACF7279FEF74\" height=1 id=USBKEY  style=\"HEIGHT: 1px; LEFT: 10px; TOP: 28px; WIDTH: 1px\" width=1 VIEWASTEXT>");
		document.writeln("</OBJECT>");
		document.writeln("<OBJECT classid=\"CLSID:3BC3C868-95B5-47ED-8686-E0E3E94EF366\" height=1 id=picobj  style=\"HEIGHT: 1px; LEFT: 10px; TOP: 28px; WIDTH: 1px\" width=1 VIEWASTEXT>");
		document.writeln("</OBJECT>");
		
		USBKEY.getUserList();
		//BJCASecCOM 2.4版本
		g_versionFlag = 1;
	}
	catch(ee)
	{
		alert("没有正确安装证书应用环境或者证书应用环境已经损坏！"+ee.message);
	}
}


/////组件接口转换为脚本接口////////////////////////

/////旧版本SecX所需函数////////////////////////////

function CXMLSignRule()
{
	 
	this.XMLHeader = "<?xml version=\"1.0\" encoding=\"GB2312\"?> ";
	this.XMLDoc = new ActiveXObject("Microsoft.XMLDOM");
	this.XMLDoc.async = false;
	this.XMLDoc.loadXML("<SecXMSG></SecXMSG>");
}
function gFuncURLEncode(str)
{
	//return str;
	var str1 = str;
	var i, c;
	var ret = ""
	var strSpecial = "!\"#$%&'()*+,/:;<=>?@[\]^`{|}~%";
	for(i = 0; i < str1.length ;i++ ){
			c=str1.charAt(i);
			if(c==" ")
				str1=str1.replace(" ","+");
			else if(strSpecial.indexOf(c)!=-1)
			{
				var temp = "%"+str1.charCodeAt(i).toString(16);
				str1 =str1.replace(c,temp);
				i=i+temp.length - 1;
			}

	}
	return str1;
}
function gFuncFormItem2XML(strTag, strType, strValue)
{
	if (strTag == "")
	{
		 return false;
	}
	
	strTag = gFuncURLEncode(strTag);
	var strPath = "/SecXMSG";
	var objNode = g_objXML.XMLDoc.selectSingleNode(strPath);

	var objTemp = g_objXML.XMLDoc.createElement(strTag);

	objNode.appendChild(objTemp);

	objTemp.setAttribute("Type", strType);
	
	var objNode = g_objXML.XMLDoc.selectSingleNode("/SecXMSG/"+ strTag);
	objNode.text = strValue;
	
	//var objCDATA = g_objXML.XMLDoc.createCDATASection(strValue);
	//objTemp.appendChild(objCDATA);
	return true;
}
 
 
 
function importCert(sCertSrc, SrcType, sPwd) {

	if (sPwd != null)
		return oCert.importCert(sCertSrc, SrcType, sPwd);
	else
		return oCert.importCert(sCertSrc, SrcType);
}

function exportCert(DstType, sCertPath){

	if (sCertPath != null)
		return oCert.exportCert(DstType, sCertPath);
	else
		return oCert.exportCert(DstType);
}

function getUserInfoByContainer(sContainerName, TypeID) {
	
	return oUtil.getUserInfoByContainer(sContainerName, TypeID);
}

function checkValidaty(sDate) {

	if (sDate != null)
		return oCert.checkValidaty(sDate);
	else
		return oCert.checkValidaty();
}

function alertValidDay(ret)
{
 	var ValidDay;
	ValidDay = parseInt(ret);
	if(parseInt(ret) > 365){
	// alert("证书还未生效!");
	//return false;
	}
	
	if (parseInt(ret) <= 60 && parseInt(ret) > 0) {
		alert("您的证书还有" + ValidDay + "天过期，\n请您尽快到北京数字证书认证中心办理证书更新手续，\n否则会影响您的正常使用，造成不必要的麻烦和损失。\n证书用户注意查看告知事项，具体更新手续请登录:\nhttp://www.bjca.org.cn；咨询电话：82031677-8686。");
	}
	
	if(parseInt(ret) <= -45)
	{
		alert("您的证书已过期 "+ -parseInt(ret) +" 天，超过了最后使用期限！\n请到北京数字证书认证中心办理证书更新手续！\n\n证书用户注意查看告知事项，具体更新手续请登录:\nhttp://www.bjca.org.cn；咨询电话：82031677-8686。");
		return false;
	}
		
	if(parseInt(ret) <= 0){
		alert("您的证书已过期 "+ -parseInt(ret) +" 天，\n请尽快到北京数字证书认证中心办理证书更新手续，\n否则会影响您的正常使用，造成不必要的麻烦和损失。\n证书用户注意查看告知事项，具体更新手续请登录:\nhttp://www.bjca.org.cn；咨询电话：82031677-8686。");
	}
	return true;
}
 
function ReadPfxToBca(sContainerName, KeyUsage, sPassword, sPfxFile) {

	return oCrypto.ReadPfxToBca(sContainerName, KeyUsage, sPassword, sPfxFile)
}

function importpfxtobca(sContainerName, KeyType, sPassword) {

	if (KeyType == 1) {
		var sPfxFile = getUserInfoByContainer(sContainerName, CERT_XML_EXCHPFXPATH);
		var ret = ReadPfxToBca(sContainerName, 1, sPassword, sPfxFile);
		return ret;
	}//单证书
	else if (KeyType == 2) {
		//双证书
		var sPfxFile = getUserInfoByContainer(sContainerName, CERT_XML_EXCHPFXPATH);
		var ret = ReadPfxToBca(sContainerName, 1, sPassword, sPfxFile);
		if(ret != 0)
			return ret;
		sPfxFile = getUserInfoByContainer(sContainerName, CERT_XML_SIGNPFXPATH);
		return ret = ReadPfxToBca(sContainerName, 2, sPassword, sPfxFile);
	}
}

function setUserCfg(CfgFlag, sCfgValue, sExt1CfgValue, sExt2CfgValue) {

	return oCrypto.setUserCfg(CfgFlag, sCfgValue, sExt1CfgValue, sExt2CfgValue);
}

function setAlgFlag() {

	return oCrypto.setAlgFlag(AlgType, AlgFlag);
}

function userLogin(sCSPName, sUserPin) {

	return oDevice.userLogin(sCSPName, sUserPin);
}

function getCertBasicInfov1(sCert, OID) {

	oCert.importCert(sCert, CERT_SRC_BASE64);
	return oCert.getBasicCertInfoByOID(OID);	
}

function modifyPFXPwd(sPFXPath, sOldPwd, sNewPwd) {

	return oCert.modifyPFXPwd(sPFXPath, sOldPwd, sNewPwd);
}

function changeUserPin(sCSPName, sExtLib, sOldPin, sNewPin) {

	return oDevice.changeUserPin(sCSPName, sExtLib, sOldPin, sNewPin);
}


 function GetSavedPass(strContainerName)
{
	var strUserName = getUserInfoByContainer_pnp(strContainerName,CERT_XML_SUBJECT);
	var pass = USBKEY.GetSavedPass(strUserName);
	return pass;
}
 function SaveUSKKeyPass(strContainerName,strPass)
{
	var strUserName = getUserInfoByContainer_pnp(strContainerName,CERT_XML_SUBJECT);
	return USBKEY.SaveUserPass(strUserName,strPass);
}

function EnumUsbKey()
{
	try
	{
		USBKEY.EnumUsbKey();
	}
	catch(e)
	{
		  
	}
}
function getUserList_pnp() {
	var list;
	try
	{
		list = USBKEY.getUserList();
		return list;
	}
	catch(e)
	{
		 
		return "";
	}
}

function getUserInfoByContainer_pnp(sContainerName, TypeID) {
	
 	return USBKEY.getUserInfoByContainer(sContainerName, TypeID);
}
function SetLoginState(sContainerName, sUserName) {
	
 	return USBKEY.SetLoginState(sContainerName, sUserName);
}


/////新版本SecX所需函数/////////////////////////////
function GetUserInfo(sContainerName, TypeID)
{
	return bjcactrl.GetUserInfo(sContainerName, TypeID);
}

/////兼容函数，以旧接口方式命名/////////////////////////////
function getKeySN(strContainerName) 
{
	var strExtLib;
	if(g_versionFlag == 1)
	{
		//var strDevType = getUserInfoByContainer(strContainerName, CERT_XML_DEVICETYPE);
		strExtLib = getUserInfoByContainer_pnp(strContainerName, CERT_XML_DEVICEAFFIX);
		return oDevice.getKeySN(strExtLib);
	}
	strExtLib = GetUserInfo(strContainerName, 15);
	return bjcactrl.GetBjcaKeyParam(strExtLib, 3);
}
//GetCertBasicinfo适用范围只有1－19，22仅针对获取证书唯一标识适用
function getCertDetail(sContainerName, TypeID)
{
	var strCert = GetSignCert(sContainerName);
	if(TypeID == 22)
	{
		return GetExtCertInfoByOID(strCert, "2.16.840.1.113732.2");
	}
	return GetCertBasicinfo(strCert, TypeID);
}

function getKeyRetrys(sExtLib) {
	if(g_versionFlag == 1)
	{
		return oDevice.getKeyRetrys(sExtLib);
	}
	return bjcactrl.GetBjcaKeyParam(strExtLib, 8);
}

/////下面为兼容方式存在/////////////////////////////
//得到用户列表
function GetUserList() {
	if(g_versionFlag == 1)
	{
		try
		{
			EnumUsbKey();
			g_xmluserlist = getUserList_pnp();
			var strTemp = oUtil.getUserList();
			while (1) {
			var i=strTemp.indexOf("&&&");
			if (i <= 0) {
				break;
			}
			var strOption = strTemp.substring(0,i);
			var strName = strOption.substring(0, strOption.indexOf("||"));
			var strUniqueID = strOption.substring(strOption.indexOf("||") + 2, strOption.length);
			var strDeviceType = getUserInfoByContainer(strUniqueID, CERT_XML_DEVICETYPE);
			if (strDeviceType == "BJSOFT")
			{
				  g_xmluserlist = g_xmluserlist +strName +"||";
				  g_xmluserlist = g_xmluserlist +strUniqueID +"&&&"; 
			}
			var len = strTemp.length;
	    strTemp = strTemp.substring(i+3,len);
			}
		}
		catch(e)
		{
			g_xmluserlist="";
		}
	}
	else
	{
		try
		{
			g_xmluserlist = bjcactrl.GetUserList();
		}
		catch(e)
		{
			g_xmluserlist="";
		}
	}  
	
	return g_xmluserlist;
}

//得到用户信息
function GetCertBasicinfo(Cert, Type) 
{
	if(g_versionFlag == 1)
	{
		switch(Type)
		{
		case 0:
			return Cert;
			break;
		case 8:
			return getCertBasicInfov1(Cert,4);
			break;
		case 11:
			return getCertBasicInfov1(Cert,5);
			break;
		case 12:
			return getCertBasicInfov1(Cert,6);
			break;
		case 13:
			return getCertBasicInfov1(Cert,42);
			break;
		case 14:
			return getCertBasicInfov1(Cert,45);
			break;
		case 15:
			return getCertBasicInfov1(Cert,46);
			break;
		case 16:
			return getCertBasicInfov1(Cert,44);
			break;
		case 17:
			return getCertBasicInfov1(Cert,41);
			break;
		case 18:
			return getCertBasicInfov1(Cert,43);
			break;
		case 20:
			return getCertBasicInfov1(Cert,7);
			break;
		case 22:
			return oCert.getExtCertInfoByOID("2.16.840.1.113732.2");
			break;
		case 23:
			return checkValidaty();
			break;
		default:
			return getCertBasicInfov1(Cert,Type);
			break;
		}
	}

	return bjcactrl.GetCertInfo(Cert,Type);
	
}

function GetExtCertInfoByOID(Cert, oid) 
{
   	if(g_versionFlag == 1)
    	{
		return oCert.getExtCertInfoByOID(oid);
	}
	return bjcactrl.GetCertInfoByOid(Cert,oid);
}

//登录
function Login(strFormName,strContainerName,strPin) {
		var ret;
		var objForm = eval(strFormName);
	
		if (objForm == null) {
			alert("Form Error");
			return false;
		}
		if (strPin == null || strPin == "") {
			alert("请输入Key的保护口令");
			return false;
		}
		/**t
		//Add a hidden item ...
		var strSignItem = "<input type=\"hidden\" name=\"UserSignedData\" value=\"\">";
		if (objForm.UserSignedData == null) {
			//objForm.insertAdjacentHTML("BeforeEnd",strSignItem);
		}
		var strCertItem = "<input type=\"hidden\" name=\"UserCert\" value=\"\">";
		if (objForm.UserCert == null) {
			//objForm.insertAdjacentHTML("BeforeEnd",strCertItem);
		}
		var strContainerItem = "<input type=\"hidden\" name=\"ContainerName\" value=\"\">";
		if (objForm.ContainerName == null) {
			//objForm.insertAdjacentHTML("BeforeEnd",strContainerItem);
		}
		t*/
	if(g_versionFlag == 1)
	{
		var strP12Path = null;
		
		var strDeviceType = getUserInfoByContainer(strContainerName, CERT_XML_DEVICETYPE);
		var KeyType = getUserInfoByContainer(strContainerName, CERT_XML_KEYTYPE);
	  	var strCAType = getUserInfoByContainer(strContainerName, CERT_XML_CATYPE);
	 
		
		if (strDeviceType == "BJSOFT") {
			//P12软算法
			if (KeyType == 1) {
				//单证书
				strP12Path = getUserInfoByContainer(strContainerName, CERT_XML_EXCHPFXPATH);
			}
			else if (KeyType == 2) {
				//双证书
				strP12Path = getUserInfoByContainer(strContainerName, CERT_XML_SIGNPFXPATH);
			}
			else {
				alert("配置文件错误6");
				return false;
			}
			
			if (importCert(strP12Path, CERT_SRC_PKCS12, strPin) != 0) {
				alert("口令错误");
				return false;
			}
			setUserCfg(CRYPT_CFGTYPE_P12, strP12Path, strPin, "");
			var strClientSignedData = SignedData(strServerRan);
		 
		}
		else if (strDeviceType == "BJCSP0001"){
			//软CSP
			var strDevType = getUserInfoByContainer(strContainerName, CERT_XML_DEVICETYPE);
			var strCSPName = getUserInfoByContainer(strDevType, CERT_XML_DEVICEPROVIDER);
	
			if (KeyType == 1) {
				//单证书
				strP12Path = getUserInfoByContainer(strContainerName, CERT_XML_EXCHPFXPATH);
			}
			else if (KeyType == 2) {
				//双证书
				strP12Path = getUserInfoByContainer(strContainerName, CERT_XML_SIGNPFXPATH);
			}
			else {
				alert("配置文件错误7");
				return false;
			}
			
			if (importCert(strP12Path, CERT_SRC_PKCS12, strPin) != 0) {
				alert("口令错误");
				return false;
			}
			
			var strExtLib = strContainerName;
				
			setUserCfg(CRYPT_CFGTYPE_CSP, strCSPName, strExtLib, strPin);
			var strClientSignedData = SignedData(strServerRan, strContainerName);
	
		}
		else {
			//智能卡
			var strCSPName = getUserInfoByContainer_pnp(strContainerName, CERT_XML_DEVICEPROVIDER);
			var strExtLib = getUserInfoByContainer_pnp(strContainerName, CERT_XML_DEVICEAFFIX);
			var strUserName = getUserInfoByContainer_pnp(strContainerName, CERT_XML_SUBJECT);
		 	KeyType = getUserInfoByContainer_pnp(strContainerName, CERT_XML_KEYTYPE);
			if (strExtLib == null)
				strExtLib = "Temp";
			ret = userLogin(strCSPName, strPin);
			if (ret != 0 ){
				var retryNum = getKeyRetrys(strExtLib);
				switch (retryNum) {
					case -1010:
						alert("未正确插入智能卡");
						return false;
						break;
					case -1011:
						alert("智能卡操作失败");
						return false;
						break;
					default:
						alert("口令错误,重试还剩下"+retryNum+"次");
						return false;
						break;
				}
			}
			
			if (KeyType == 1) {
				//单证书
				if(importCert(strContainerName, CERT_SRC_CONTAINER_ENC, strCSPName) != 0){
					alert("口令错误或未正确插入智能卡");
					return false;
				}
			}
			else if (KeyType == 2) {
				//双证书
				if(importCert(strContainerName, CERT_SRC_CONTAINER_SIGN, strCSPName)!= 0){
					alert("口令错误或未正确插入智能卡");
					return false;
				}
			}
			else {
				alert("配置文件错误8");
				return false;
			}
			setUserCfg(CRYPT_CFGTYPE_CSP, strCSPName, strExtLib, strPin);
		//	var strClientSignedData = SignedData(strServerRan, strContainerName); //t
		}
		
		if(!VerifySignedData(strServerCert,strServerRan,strServerSignedData))
		{
			alert("验证服务器认证信息错误!");
		return false;
	}
		//objForm.UserSignedData.value = strClientSignedData;
		//objForm.UserCert.value = exportCert(CERT_DST_BASE64);
		//objForm.ContainerName.value = strContainerName;
		SetLoginState(strContainerName,strUserName);
		var rv = checkValidaty();
		return alertValidDay(rv);
	}
	if(!bjcactrl.UserLogin(strContainerName,strPin))
	{
		alert("登陆失败,请检查密码是否正确处理!");
	        return false;
	}
	    
	strClientSignedData = SignedData(strServerRan,strContainerName);
	alert("strServerCert:"+strServerCert+"\n\nstrServerRan:"+strServerRan+"\n\nstrServerSignedData:"+strServerSignedData);
	if(!VerifySignedData(strServerCert,strServerRan,strServerSignedData))
	{
	        
	        alert("验证服务器端信息失败!");
	        return false;
	}
	    
	objForm.UserSignedData.value = strClientSignedData;
	var varCert =  GetSignCert(strContainerName);
	objForm.UserCert.value =  varCert;
	objForm.ContainerName.value = strContainerName;
	    
	return true;
    
}

//根据证书惟一标识，获取Base64编码的证书字符串。指定获取加密（交换）证书。
function GetExchCert(strContainerName)
{  
	if(g_versionFlag == 1)
	{
		var strDeviceType = getUserInfoByContainer(strContainerName, CERT_XML_DEVICETYPE);
		var KeyType = getUserInfoByContainer(strContainerName, CERT_XML_KEYTYPE);
		if (strDeviceType == "BJSOFT") {
			//P12软算法
			var Cert = getUserInfoByContainer(strContainerName,CERT_XML_EXCHPATH);
			importCert(Cert,CERT_SRC_FILE);
		}
		else if (strDeviceType == "BJCSP0001"){
			//软CSP
			var Cert = getUserInfoByContainer(strContainerName,CERT_XML_EXCHPATH);
			importCert(Cert,CERT_SRC_FILE);
		}
		else {
			//智能卡
			var strCSPName = getUserInfoByContainer_pnp(strContainerName, CERT_XML_DEVICEPROVIDER);
			importCert(strContainerName, CERT_SRC_CONTAINER_ENC, strCSPName);
		}
		var UserCert = exportCert(CERT_DST_BASE64);
		return UserCert;
	}
	
	var UserCert = bjcactrl.ExportExChangeUserCert(strContainerName);
	return UserCert;
}

//签名证书
function GetSignCert(strContainerName)
{  
	if(g_versionFlag ==1)
	{
		var strDeviceType = getUserInfoByContainer(strContainerName, CERT_XML_DEVICETYPE);
		var KeyType = getUserInfoByContainer(strContainerName, CERT_XML_KEYTYPE);
		 
		if (strDeviceType == "BJSOFT") {
			//P12软算法
			if (KeyType == 1) {
				//单证书
			   var Cert = getUserInfoByContainer(strContainerName,CERT_XML_EXCHPATH);
			   importCert(Cert,CERT_SRC_FILE);
			}
			else if (KeyType == 2) {
				//双证书
			   var Cert = getUserInfoByContainer(strContainerName,CERT_XML_SIGNPATH);
			   importCert(Cert,CERT_SRC_FILE);
			}
			else {
				alert("配置文件错误1");
				return false;
			}
		}
		else if (strDeviceType == "BJCSP0001"){
			//软CSP
			if (KeyType == 1) {
				//单证书
			   var Cert = getUserInfoByContainer(strContainerName,CERT_XML_EXCHPATH);
			   importCert(Cert,CERT_SRC_FILE);
			}
			else if (KeyType == 2) {
				//双证书
			   var Cert = getUserInfoByContainer(strContainerName,CERT_XML_SIGNPATH);
			   importCert(Cert,CERT_SRC_FILE);
			}
			else {
				alert("配置文件错误2");
				return false;
			}
	
		}
		else {
			//智能卡
			 
			var strCSPName = getUserInfoByContainer_pnp(strContainerName, CERT_XML_DEVICEPROVIDER);
			KeyType = getUserInfoByContainer_pnp(strContainerName, CERT_XML_KEYTYPE);
			 
			if (KeyType == 1) {
				//单证书
				importCert(strContainerName, CERT_SRC_CONTAINER_ENC, strCSPName);
			}
			else if (KeyType == 2) {
				//双证书
				importCert(strContainerName, CERT_SRC_CONTAINER_SIGN, strCSPName);
			}
			else {
				alert("配置文件错误3,KeyType="+KeyType+"strContainerName="+strContainerName);
				return false;
			}
		}
		
		var UserCert = exportCert(CERT_DST_BASE64);
		return UserCert;
	}
	var UserCert = bjcactrl.ExportUserCert(strContainerName);
	
	return UserCert;
}

function SignedData(sInData,sContainerName) 
{
	if(g_versionFlag == 1)
	{
		if (sContainerName != null)
			return oCrypto.signedData(sInData, sContainerName);
		else
			return oCrypto.signedData(sInData);
	}
	if (sContainerName != null)
		return bjcactrl.SignData(sContainerName,sInData);
	else
		return "";
}


function VerifySignedData(cert,indata,signvalue)
{
	if(g_versionFlag == 1)
	{
		if(0 != oCrypto.verifySignedData(signvalue, cert, indata))
			return false;
		else
			return true;	
	}
  return bjcactrl.VerifySignedData(cert,indata,signvalue);
}


function PubKeyEncrypt(exchCert,inData)
{
	try
	{
		var ret = bjcactrl.PubKeyEncrypt(exchCert,inData);
		return ret;
	}
    	catch(e)
    	{
    	 
    	}
}


function PriKeyDecrypt(sContainerName,inData)
{
	try
	{
		var ret = bjcactrl.PriKeyDecrypt(sContainerName,inData);
		return ret;
	}
	catch(e)
	{
	 
	}
}


function EncryptData(sKey,inData)
{
	try
	{
		var ret = bjcactrl.EncryptData(sKey,inData);
		return ret;
	}
	catch(e)
	{
		 
	}
}


function DecryptData(sKey,inData)
{
	try
	{
		var ret = bjcactrl.DecryptData(sKey,inData);
		return ret;
	}
	catch(e)
	{
	 
	}
}

function GenerateRandom(RandomLen) 
{
	if(g_versionFlag == 1)
	{
		return oCrypto.generateRandom(RandomLen);
	}
	return bjcactrl.GenRandom(RandomLen);
}


//文件签名 返回签名数据
function SignFile(sFileName,sContainerName)
{
	if(g_versionFlag ==1)
	{
		return oCrypto.signFile(sFileName,sContainerName);
	}
	return bjcactrl.SignFile(sContainerName,sFileName)
}

function VerifySignFile(sFileName,sCert,SignData)
{
	if(g_versionFlag == 1)
	{
		if(0 != oCrypto.verifySignFile(sFileName,sCert,SignData))
			return false;
		else
			return true;	
	}
	return bjcactrl.VerifySignedFile(sCert,sFileName,SignData);
}

//修改密码
function ChangeUserPassword(strContainerName,oldPwd,newPwd)
{	
	if(g_versionFlag == 1)
	{
		var strP12Path = null;
		var rv = 0;
		var strDeviceType = getUserInfoByContainer(strContainerName, CERT_XML_DEVICETYPE);
		var KeyType = getUserInfoByContainer(strContainerName, CERT_XML_KEYTYPE);
		
		if (strDeviceType == "BJSOFT") {
			//P12软算法
			if (KeyType == 1) {
				//单证书
				strP12Path = getUserInfoByContainer(strContainerName, CERT_XML_EXCHPFXPATH);
				rv = modifyPFXPwd(strP12Path, oldPwd, newPwd);
			}
			else if (KeyType == 2) {
				//双证书
				strP12Path = getUserInfoByContainer(strContainerName, CERT_XML_SIGNPFXPATH);
				var strExchPath = getUserInfoByContainer(strContainerName, CERT_XML_EXCHPFXPATH);
				var rvtmp = modifyPFXPwd(strP12Path, oldPwd, newPwd);
				rv = modifyPFXPwd(strExchPath, oldPwd, newPwd);
	
			}
			else {
				alert("配置文件错误4");
				return -1;
			}
			setUserCfg(CRYPT_CFGTYPE_P12, strP12Path, newPwd, "");
		}
		else if (strDeviceType == "BJCSP0001"){
			//软CSP
			var strDevType = getUserInfoByContainer(strContainerName, CERT_XML_DEVICETYPE);
			var strCSPName = getUserInfoByContainer(strDevType, CERT_XML_DEVICEPROVIDER);
	
			if (KeyType == 1) {
				//单证书
				strP12Path = getUserInfoByContainer(strContainerName, CERT_XML_EXCHPFXPATH);
				rv = modifyPFXPwd(strP12Path, oldPwd, newPwd);
			}
			else if (KeyType == 2) {
				//双证书
				strP12Path = getUserInfoByContainer(strContainerName, CERT_XML_SIGNPFXPATH);
				var strExchPath = getUserInfoByContainer(strContainerName, CERT_XML_EXCHPFXPATH);
				var rvtmp = modifyPFXPwd(strP12Path, oldPwd, newPwd);
				rv = modifyPFXPwd(strExchPath, oldPwd, newPwd);
			}
			else {
				alert("配置文件错误5");
				return -1;
			}
			var strExtLib = strContainerName;
				
			setUserCfg(CRYPT_CFGTYPE_CSP, strCSPName, strExtLib, newPwd);
		}
		else {
			//智能卡
			
			var strCSPName = getUserInfoByContainer_pnp(strContainerName, CERT_XML_DEVICEPROVIDER);
			var strExtLib = getUserInfoByContainer_pnp(strContainerName, CERT_XML_DEVICEAFFIX);
		
			if (strExtLib == null)
				strExtLib = "Temp";
			rv = changeUserPin(strCSPName, strExtLib, oldPwd,newPwd);	
			setUserCfg(CRYPT_CFGTYPE_CSP, strCSPName, strExtLib, newPwd);
		}
		if(rv != 0)
			return false;
		else
			return true;
	}
	return bjcactrl.ChangePasswd(strContainerName,oldPwd,newPwd);
}

//xml签名
function SignedDataXML(signdata,ContainerName)
{
	if(g_versionFlag == 1)
	{
		return oCrypto.signedDataXML(signdata,ContainerName);
	}
	return bjcactrl.SignDataXML(ContainerName,signdata);
}

//xml验证签名
function VerifySignXML(signxml)
{
	if(g_versionFlag == 1)
	{
		if(0 != oCrypto.verifySignedDataXML(signxml))
			return false;
		else
			return true;	
	}
	return bjcactrl.verifySignedDataXML(signxml);
}

//p7签名
function SignByP7(InData,CertID)
{
	if(g_versionFlag == 1)
	{
		if (CertID != null)
			return oCrypto.signedDataByP7(InData, CertID);
		else
			return oCrypto.signedDataByP7(InData);
	}
    	return bjcactrl.SignDataByP7(CertID,InData);
}

//验证p7签名
function VerifyDatabyP7(P7Data)
{
	if(g_versionFlag == 1)
	{
		if(0 != oCrypto.verifySignedDataByP7(P7Data))
			return false;
		else
			return true;	
	}
    	return bjcactrl.VerifySignedDatabyP7(P7Data);
}

//p7数字信封加密
function EncodeP7Enveloped(InData,Cert)
{
	if(g_versionFlag == 1)
	{
		if (Cert != null)
			return oCrypto.envelopedData(InData, ENVELOP_ENC, Cert);
		else
			return oCrypto.envelopedData(InData, ENVELOP_ENC);
	}
   	return bjcactrl.EncodeP7EnvelopedData(Cert,InData);
}

//p7数字信封解密
function DecodeP7Enveloped(InData,CertID)
{ 
	if(g_versionFlag == 1)
	{
		if (CertID != null)
			return oCrypto.envelopedData(InData, ENVELOP_DEC, CertID);
		else
			return oCrypto.envelopedData(InData, ENVELOP_DEC);
	}
	return bjcactrl.DecodeP7EnvelopedData(CertID,InData);
}

//东华软件
function User_Login(strContainerName, strPin)
{
    debugger;
	var strCSPName = getUserInfoByContainer_pnp(strContainerName, CERT_XML_DEVICEPROVIDER);
	var ret = userLogin(strCSPName, strPin);
	if (ret != 0)
	{
		return true;
	}
	return false;
}

//东华软件
function GetExtLib(strContainerName)
{
	var strExtLib = getUserInfoByContainer_pnp(strContainerName, CERT_XML_DEVICEAFFIX);
	if (strExtLib == null)
	{
		strExtLib = "Temp";
	}
	return strExtLib;
	
}

function HashData(InData)
{
	if(g_versionFlag == 1)
	{
		return picobj.Hash(InData);
	}
	return bjcactrl.Hash(InData);
}

function GetPicBase64Data(strContainerName)
{
	return picobj.GetPicBase64Data(strContainerName);
}

