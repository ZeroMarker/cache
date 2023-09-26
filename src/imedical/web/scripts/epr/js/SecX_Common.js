/////const //////////////////////////
var CERT_SRC_BASE64	=					1;		//֤������Base64�ַ���
var CERT_SRC_UNIQUEID =					2;		//֤������Ψһ��ʾ
var CERT_SRC_FILE =						3;		//֤������der�ļ�
var CERT_SRC_CONTAINER_UCA = 			4;		//֤������UCA����֤������
var CERT_SRC_CONTAINER_SIGN	=			5;		//֤������������ǩ��֤��
var CERT_SRC_CONTAINER_ENC =			6;		//֤�����������¼���֤��
var CERT_SRC_CONTAINER_BOTH	=			7;		//֤������������ǩ������֤��
var CERT_SRC_PKCS12	=					8;		//֤������PKCS12�ļ�

var CERT_DST_BASE64	=					1;		//����֤��ΪBase64�ַ���
var CERT_DST_DERFILE =					2;		//����֤��Ϊder�ļ�
var CERT_DST_P12 =						3;		//����֤��ΪPKCS12�ļ�

var CERT_XML_SUBJECT =					1;		//��XML�����ļ�ȡ�û���
var CERT_XML_UNIQUEID =					2;		//��XML�����ļ�ȡ�û�Ψһ��ʶ
var CERT_XML_DEPT =						3;		//��XML�����ļ�ȡ�û������߲���
var CERT_XML_ISSUE =					4;		//��XML�����ļ�ȡ�û�֤��䷢��
var CERT_XML_STATE =					5;		//��XML�����ļ�ȡ�û�֤��ʹ��״̬
var CERT_XML_TRADETYPE =				6;		//��XML�����ļ�ȡ�û�֤��Ӧ������
var CERT_XML_PASSWORD =					7;		//��XML�����ļ�ȡ�û�֤��˽Կ��������
var CERT_XML_DEVICETYPE =				8;		//��XML�����ļ�ȡ�û�֤���������
var CERT_XML_CATYPE	 =					9;		//��XML�����ļ�ȡ�û�֤��CA����
var CERT_XML_KEYTYPE =					10;		//��XML�����ļ�ȡ�û�֤����Կ����
var CERT_XML_SIGNSN	=					11;		//��XML�����ļ�ȡ�û�ǩ��֤�����к�
var CERT_XML_EXCHSN	=					12;		//��XML�����ļ�ȡ�û�����֤�����к�
var CERT_XML_DEVICENAME =				13;		//��XML�����ļ�ȡ�û�֤���������
var CERT_XML_DEVICEPROVIDER =			14;		//��XML�����ļ�ȡ�û�֤������ṩ��
var CERT_XML_DEVICEAFFIX =				15;		//��XML�����ļ�ȡ�û�֤����ʸ��ӿ�
var CERT_XML_SIGNPATH =					16;		//��XML�����ļ�ȡ�û�ǩ��֤��·��
var CERT_XML_EXCHPATH =					17;		//��XML�����ļ�ȡ�û�����֤��·��
var CERT_XML_SIGNPFXPATH =				18;		//��XML�����ļ�ȡ�û�ǩ��P12֤��·��
var CERT_XML_EXCHPFXPATH =				19;		//��XML�����ļ�ȡ�û�����P12֤��·��
var CERT_XML_CHAINPATH =				20;		//��XML�����ļ�ȡ�û�֤����·��
var CERT_XML_CRLPATH =					21;		//��XML�����ļ�ȡ�û�֤�������б�·��
var CERT_XML_UNIQUEIDOID =				22;		//��XML�����ļ�ȡ�û�֤��UniqueID��OID
var CERT_XML_VERIFYTYPE	=				23;		//��XML�����ļ�ȡ�û�֤����֤����
var CERT_XML_CACOUNTS =					24;		//��XML�����ļ�ȡ�û�֤���֤�����
var CERT_XML_CANUMTYPE =				25;		//��XML�����ļ�ȡ�û�֤���֤������

var CRYPT_CFGTYPE_UNSET =				0;		//�û�Ӧ������δ����
var CRYPT_CFGTYPE_CSP =					1;		//�û�Ӧ������CSP
var CRYPT_CFGTYPE_P11 =					2;		//�û�Ӧ������P11
var CRYPT_CFGTYPE_P12 =					3;		//�û�Ӧ���������㷨

var ENVELOP_ENC =						1;		//����P7�����ŷ�
var ENVELOP_DEC =						0;		//����P7�����ŷ�
var CRYPT_ALG_HASH =					1;		//Hash��־λ
var CRYPT_ALG_SYMM =					2;		//�Գ��㷨��־λ
var CRYPT_ALG_MODE =					3;		//�Գ��㷨ģʽ

////CUSTOM CERT OID////////////////////////////////
var CERT_OID_VERSION =					1;		//֤��汾��
var CERT_OID_SN =					2;		//֤�����к�
var CERT_OID_SIGNALG =					3;		//֤��ǩ���㷨
var CERT_OID_ISSUERNAME =				4;		//֤��䷢��
var CERT_OID_NOTBEFORE =				5;		//֤����Ч����
var CERT_OID_NOTAFTER =					6;		//֤���������
var CERT_OID_PUBLICKEY =				7;		//֤�鹫Կ
var CERT_OID_UNIQUEID =					8;		//֤��Ψһ��ʶ

var g_xmluserlist;
//g_versionFlag��ʾ�汾��Ϣ��0ΪBJCASecCOM 3.0�汾��1ΪBJCASecCOM 2.4�汾
var g_versionFlag = 0 ;

var g_objXML = new CXMLSignRule();

/////define object  /////////////////////////////////
try
{
		//	var oTest = new ActiveXObject("BJCASecCOM.BJCASecCOMV2");//��һ�д��벻��ʡ�ԣ�������û��try�Ĵ�����Ϣ�����ܽ���catch��
    	//document.writeln("<OBJECT classid=\"clsid:FCAA4851-9E71-4BFE-8E55-212B5373F040\" height=1 id=bjcactrl  style=\"HEIGHT: 1px; LEFT: 10px; TOP: 28px; WIDTH: 1px\" width=1 VIEWASTEXT>");
    	//document.writeln("</OBJECT>");
    	//BJCASecCOM 3.0�汾
    	//g_versionFlag = 0;
		throw new Error("��ʹ��secx2.4�汾");
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
		//BJCASecCOM 2.4�汾
		g_versionFlag = 1;
	}
	catch(ee)
	{
		alert("û����ȷ��װ֤��Ӧ�û�������֤��Ӧ�û����Ѿ��𻵣�"+ee.message);
	}
}


/////����ӿ�ת��Ϊ�ű��ӿ�////////////////////////

/////�ɰ汾SecX���躯��////////////////////////////

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
	// alert("֤�黹δ��Ч!");
	//return false;
	}
	
	if (parseInt(ret) <= 60 && parseInt(ret) > 0) {
		alert("����֤�黹��" + ValidDay + "����ڣ�\n�������쵽��������֤����֤���İ���֤�����������\n�����Ӱ����������ʹ�ã���ɲ���Ҫ���鷳����ʧ��\n֤���û�ע��鿴��֪�����������������¼:\nhttp://www.bjca.org.cn����ѯ�绰��82031677-8686��");
	}
	
	if(parseInt(ret) <= -45)
	{
		alert("����֤���ѹ��� "+ -parseInt(ret) +" �죬���������ʹ�����ޣ�\n�뵽��������֤����֤���İ���֤�����������\n\n֤���û�ע��鿴��֪�����������������¼:\nhttp://www.bjca.org.cn����ѯ�绰��82031677-8686��");
		return false;
	}
		
	if(parseInt(ret) <= 0){
		alert("����֤���ѹ��� "+ -parseInt(ret) +" �죬\n�뾡�쵽��������֤����֤���İ���֤�����������\n�����Ӱ����������ʹ�ã���ɲ���Ҫ���鷳����ʧ��\n֤���û�ע��鿴��֪�����������������¼:\nhttp://www.bjca.org.cn����ѯ�绰��82031677-8686��");
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
	}//��֤��
	else if (KeyType == 2) {
		//˫֤��
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


/////�°汾SecX���躯��/////////////////////////////
function GetUserInfo(sContainerName, TypeID)
{
	return bjcactrl.GetUserInfo(sContainerName, TypeID);
}

/////���ݺ������Ծɽӿڷ�ʽ����/////////////////////////////
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
//GetCertBasicinfo���÷�Χֻ��1��19��22����Ի�ȡ֤��Ψһ��ʶ����
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

/////����Ϊ���ݷ�ʽ����/////////////////////////////
//�õ��û��б�
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

//�õ��û���Ϣ
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

//��¼
function Login(strFormName,strContainerName,strPin) {
		var ret;
		var objForm = eval(strFormName);
	
		if (objForm == null) {
			alert("Form Error");
			return false;
		}
		if (strPin == null || strPin == "") {
			alert("������Key�ı�������");
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
			//P12���㷨
			if (KeyType == 1) {
				//��֤��
				strP12Path = getUserInfoByContainer(strContainerName, CERT_XML_EXCHPFXPATH);
			}
			else if (KeyType == 2) {
				//˫֤��
				strP12Path = getUserInfoByContainer(strContainerName, CERT_XML_SIGNPFXPATH);
			}
			else {
				alert("�����ļ�����6");
				return false;
			}
			
			if (importCert(strP12Path, CERT_SRC_PKCS12, strPin) != 0) {
				alert("�������");
				return false;
			}
			setUserCfg(CRYPT_CFGTYPE_P12, strP12Path, strPin, "");
			var strClientSignedData = SignedData(strServerRan);
		 
		}
		else if (strDeviceType == "BJCSP0001"){
			//��CSP
			var strDevType = getUserInfoByContainer(strContainerName, CERT_XML_DEVICETYPE);
			var strCSPName = getUserInfoByContainer(strDevType, CERT_XML_DEVICEPROVIDER);
	
			if (KeyType == 1) {
				//��֤��
				strP12Path = getUserInfoByContainer(strContainerName, CERT_XML_EXCHPFXPATH);
			}
			else if (KeyType == 2) {
				//˫֤��
				strP12Path = getUserInfoByContainer(strContainerName, CERT_XML_SIGNPFXPATH);
			}
			else {
				alert("�����ļ�����7");
				return false;
			}
			
			if (importCert(strP12Path, CERT_SRC_PKCS12, strPin) != 0) {
				alert("�������");
				return false;
			}
			
			var strExtLib = strContainerName;
				
			setUserCfg(CRYPT_CFGTYPE_CSP, strCSPName, strExtLib, strPin);
			var strClientSignedData = SignedData(strServerRan, strContainerName);
	
		}
		else {
			//���ܿ�
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
						alert("δ��ȷ�������ܿ�");
						return false;
						break;
					case -1011:
						alert("���ܿ�����ʧ��");
						return false;
						break;
					default:
						alert("�������,���Ի�ʣ��"+retryNum+"��");
						return false;
						break;
				}
			}
			
			if (KeyType == 1) {
				//��֤��
				if(importCert(strContainerName, CERT_SRC_CONTAINER_ENC, strCSPName) != 0){
					alert("��������δ��ȷ�������ܿ�");
					return false;
				}
			}
			else if (KeyType == 2) {
				//˫֤��
				if(importCert(strContainerName, CERT_SRC_CONTAINER_SIGN, strCSPName)!= 0){
					alert("��������δ��ȷ�������ܿ�");
					return false;
				}
			}
			else {
				alert("�����ļ�����8");
				return false;
			}
			setUserCfg(CRYPT_CFGTYPE_CSP, strCSPName, strExtLib, strPin);
		//	var strClientSignedData = SignedData(strServerRan, strContainerName); //t
		}
		
		if(!VerifySignedData(strServerCert,strServerRan,strServerSignedData))
		{
			alert("��֤��������֤��Ϣ����!");
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
		alert("��½ʧ��,���������Ƿ���ȷ����!");
	        return false;
	}
	    
	strClientSignedData = SignedData(strServerRan,strContainerName);
	alert("strServerCert:"+strServerCert+"\n\nstrServerRan:"+strServerRan+"\n\nstrServerSignedData:"+strServerSignedData);
	if(!VerifySignedData(strServerCert,strServerRan,strServerSignedData))
	{
	        
	        alert("��֤����������Ϣʧ��!");
	        return false;
	}
	    
	objForm.UserSignedData.value = strClientSignedData;
	var varCert =  GetSignCert(strContainerName);
	objForm.UserCert.value =  varCert;
	objForm.ContainerName.value = strContainerName;
	    
	return true;
    
}

//����֤��Ωһ��ʶ����ȡBase64�����֤���ַ�����ָ����ȡ���ܣ�������֤�顣
function GetExchCert(strContainerName)
{  
	if(g_versionFlag == 1)
	{
		var strDeviceType = getUserInfoByContainer(strContainerName, CERT_XML_DEVICETYPE);
		var KeyType = getUserInfoByContainer(strContainerName, CERT_XML_KEYTYPE);
		if (strDeviceType == "BJSOFT") {
			//P12���㷨
			var Cert = getUserInfoByContainer(strContainerName,CERT_XML_EXCHPATH);
			importCert(Cert,CERT_SRC_FILE);
		}
		else if (strDeviceType == "BJCSP0001"){
			//��CSP
			var Cert = getUserInfoByContainer(strContainerName,CERT_XML_EXCHPATH);
			importCert(Cert,CERT_SRC_FILE);
		}
		else {
			//���ܿ�
			var strCSPName = getUserInfoByContainer_pnp(strContainerName, CERT_XML_DEVICEPROVIDER);
			importCert(strContainerName, CERT_SRC_CONTAINER_ENC, strCSPName);
		}
		var UserCert = exportCert(CERT_DST_BASE64);
		return UserCert;
	}
	
	var UserCert = bjcactrl.ExportExChangeUserCert(strContainerName);
	return UserCert;
}

//ǩ��֤��
function GetSignCert(strContainerName)
{  
	if(g_versionFlag ==1)
	{
		var strDeviceType = getUserInfoByContainer(strContainerName, CERT_XML_DEVICETYPE);
		var KeyType = getUserInfoByContainer(strContainerName, CERT_XML_KEYTYPE);
		 
		if (strDeviceType == "BJSOFT") {
			//P12���㷨
			if (KeyType == 1) {
				//��֤��
			   var Cert = getUserInfoByContainer(strContainerName,CERT_XML_EXCHPATH);
			   importCert(Cert,CERT_SRC_FILE);
			}
			else if (KeyType == 2) {
				//˫֤��
			   var Cert = getUserInfoByContainer(strContainerName,CERT_XML_SIGNPATH);
			   importCert(Cert,CERT_SRC_FILE);
			}
			else {
				alert("�����ļ�����1");
				return false;
			}
		}
		else if (strDeviceType == "BJCSP0001"){
			//��CSP
			if (KeyType == 1) {
				//��֤��
			   var Cert = getUserInfoByContainer(strContainerName,CERT_XML_EXCHPATH);
			   importCert(Cert,CERT_SRC_FILE);
			}
			else if (KeyType == 2) {
				//˫֤��
			   var Cert = getUserInfoByContainer(strContainerName,CERT_XML_SIGNPATH);
			   importCert(Cert,CERT_SRC_FILE);
			}
			else {
				alert("�����ļ�����2");
				return false;
			}
	
		}
		else {
			//���ܿ�
			 
			var strCSPName = getUserInfoByContainer_pnp(strContainerName, CERT_XML_DEVICEPROVIDER);
			KeyType = getUserInfoByContainer_pnp(strContainerName, CERT_XML_KEYTYPE);
			 
			if (KeyType == 1) {
				//��֤��
				importCert(strContainerName, CERT_SRC_CONTAINER_ENC, strCSPName);
			}
			else if (KeyType == 2) {
				//˫֤��
				importCert(strContainerName, CERT_SRC_CONTAINER_SIGN, strCSPName);
			}
			else {
				alert("�����ļ�����3,KeyType="+KeyType+"strContainerName="+strContainerName);
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


//�ļ�ǩ�� ����ǩ������
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

//�޸�����
function ChangeUserPassword(strContainerName,oldPwd,newPwd)
{	
	if(g_versionFlag == 1)
	{
		var strP12Path = null;
		var rv = 0;
		var strDeviceType = getUserInfoByContainer(strContainerName, CERT_XML_DEVICETYPE);
		var KeyType = getUserInfoByContainer(strContainerName, CERT_XML_KEYTYPE);
		
		if (strDeviceType == "BJSOFT") {
			//P12���㷨
			if (KeyType == 1) {
				//��֤��
				strP12Path = getUserInfoByContainer(strContainerName, CERT_XML_EXCHPFXPATH);
				rv = modifyPFXPwd(strP12Path, oldPwd, newPwd);
			}
			else if (KeyType == 2) {
				//˫֤��
				strP12Path = getUserInfoByContainer(strContainerName, CERT_XML_SIGNPFXPATH);
				var strExchPath = getUserInfoByContainer(strContainerName, CERT_XML_EXCHPFXPATH);
				var rvtmp = modifyPFXPwd(strP12Path, oldPwd, newPwd);
				rv = modifyPFXPwd(strExchPath, oldPwd, newPwd);
	
			}
			else {
				alert("�����ļ�����4");
				return -1;
			}
			setUserCfg(CRYPT_CFGTYPE_P12, strP12Path, newPwd, "");
		}
		else if (strDeviceType == "BJCSP0001"){
			//��CSP
			var strDevType = getUserInfoByContainer(strContainerName, CERT_XML_DEVICETYPE);
			var strCSPName = getUserInfoByContainer(strDevType, CERT_XML_DEVICEPROVIDER);
	
			if (KeyType == 1) {
				//��֤��
				strP12Path = getUserInfoByContainer(strContainerName, CERT_XML_EXCHPFXPATH);
				rv = modifyPFXPwd(strP12Path, oldPwd, newPwd);
			}
			else if (KeyType == 2) {
				//˫֤��
				strP12Path = getUserInfoByContainer(strContainerName, CERT_XML_SIGNPFXPATH);
				var strExchPath = getUserInfoByContainer(strContainerName, CERT_XML_EXCHPFXPATH);
				var rvtmp = modifyPFXPwd(strP12Path, oldPwd, newPwd);
				rv = modifyPFXPwd(strExchPath, oldPwd, newPwd);
			}
			else {
				alert("�����ļ�����5");
				return -1;
			}
			var strExtLib = strContainerName;
				
			setUserCfg(CRYPT_CFGTYPE_CSP, strCSPName, strExtLib, newPwd);
		}
		else {
			//���ܿ�
			
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

//xmlǩ��
function SignedDataXML(signdata,ContainerName)
{
	if(g_versionFlag == 1)
	{
		return oCrypto.signedDataXML(signdata,ContainerName);
	}
	return bjcactrl.SignDataXML(ContainerName,signdata);
}

//xml��֤ǩ��
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

//p7ǩ��
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

//��֤p7ǩ��
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

//p7�����ŷ����
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

//p7�����ŷ����
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

//�������
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

//�������
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

