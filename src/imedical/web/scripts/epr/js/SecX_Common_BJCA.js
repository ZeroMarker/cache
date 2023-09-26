// ////// ���� //////////////

// ��������㷨��ʶ
var SGD_SM1_ECB = 0x00000101; // SM1�㷨ECB����ģʽ
var SGD_SM1_CBC = 0x00000102; // SM1�㷨CBC����ģʽ
var SGD_SSF33_ECB = 0x00000201; // SSF33�㷨ECB����ģʽ
var SGD_SSF33_CBC = 0x00000202; // SSF33�㷨CBC����ģʽ
var SGD_SMS4_ECB = 0x00000401; // SMS4�㷨ECB����ģʽ
var SGD_SMS4_CBC = 0x00000402; // SMS4�㷨CBC����ģʽ
var SGD_3DES_ECB = 0x00002001; // 3DES�㷨ECB����ģʽ
var SGD_3DES_CBC = 0x00002002; // 3DES�㷨CBC����ģʽ

// ǩ���㷨��ʶ
var SGD_SM3_RSA = 0x00010001; // ����SM3�㷨��RSA�㷨��ǩ��
var SGD_SHA1_RSA = 0x00010002; // ����SHA_1�㷨��RSA�㷨��ǩ��
var SGD_SHA256_RSA = 0x00010004; // ����SHA_256�㷨��RSA�㷨��ǩ��
var SGD_SM3_SM2 = 0x00020101; // ����SM2�㷨��SM3�㷨��ǩ��

// �����Ӵ��㷨��ʶ
var SGD_SM3 = 0x00000001; // SM3�Ӵ��㷨
var SGD_SHA1 = 0x00000002; // SHA_1�Ӵ��㷨
var SGD_SHA256 = 0x00000004; // SHA_256�Ӵ��㷨

// ֤�����Կ���ͱ�ʶ
var KEY_SIGNOREXCHANGE = 0; // ǩ������� �Ȼ�ȡǩ�� ���ɹ��ٻ�ȡ����
var KEY_SIGNATURE = 1; // ǩ��λ��
var KEY_KEYEXCHANGE = 2; // ����λ��

// ������Կ��ʱ����Կ��ʶ
var KEY_TYPE_RSA1024 = 1; // RSA1024λ
var KEY_TYPE_RSA2048 = 2; // RSA2048λ
var KEY_TYPE_SM2_256 = 3; // SM2 256λ

// ��ȡ�豸��Ϣ
var DEVICE_TYPE_LABEL = 1; // �豸��ǩ
var DEVICE_TYPE_FREESPACE = 2; // ʣ��ռ�
var DEVICE_TYPE_SERIALNUM = 3; // Ӳ���豸���к�
var DEVICE_TYPE_TYPE = 4; // Ӳ������ ���� RSA �� SM2
var DEVICE_TYPE_KEY_TYPE = 115; // SM2�豸����20 RSA�豸����10
var DEVICE_TYPE_VID_PID = 116; // �豸��VID PID

// ��ȡ��֤����Ϣ����
var CERT_VERSION = 1; // ֤��汾 ����V1 V2 V3
var CERT_SERIAL = 2; // ֤�����к�
var CERT_SIGN_METHOD = 3; // ��ȡ֤������ ���� rsa��sm2
var CERT_ISSUER_C = 4; // ֤�鷢���߹����� ���֮����&&&����
var CERT_ISSUER_O = 5; // ֤�鷢������֯��
var CERT_ISSUER_OU = 6; // ֤�鷢���߲�����
var CERT_ISSUER_ST = 7; // ֤�鷢����ʡ����
var CERT_ISSUER_CN = 8; // ֤�鷢����ͨ����
var CERT_ISSUER_L = 9; // ֤�鷢���߳�����
var CERT_ISSUER_E = 10; // ֤�鷢����EMAIL��ַ
var CERT_NOT_BEFORE = 11; // ֤����Ч����ʼ ��ʽYYYYMMDDHHMMSS
var CERT_NOT_AFTER = 12; // ֤����Ч�ڽ�ֹ ��ʽYYYYMMDDHHMMSS
var CERT_SUBJECT_C = 13; // �û�������
var CERT_SUBJECT_O = 14; // �û���֯��
var CERT_SUBJECT_OU = 15; // �û�������
var CERT_SUBJECT_ST = 16; // �û�ʡ����
var CERT_SUBJECT_CN = 17; // �û�ͨ����
var CERT_SUBJECT_L = 18; // �û�������
var CERT_SUBJECT_E = 19; // �û�EMAIL��ַ
var CERT_PUBKEY = 20; // ֤�鹫Կ
var CERT_SUBJECT_DN = 33; // �û�DN
var CERT_ISSUER_DN = 34; // �䷢��DN
var CERT_UNIQUEID = 35; // Ψһʵ��ID

try {
	if (window.ActiveXObject) {
		document
				.writeln("<OBJECT classid=\"CLSID:3F367B74-92D9-4C5E-AB93-234F8A91D5E6\" height=1 id=XTXAPP  style=\"HEIGHT: 1px; LEFT: 10px; TOP: 28px; WIDTH: 1px\" width=1 VIEWASTEXT>");
		document.writeln("</OBJECT>");
		document
				.writeln("<OBJECT classid=\"CLSID:3BC3C868-95B5-47ED-8686-E0E3E94EF366\" height=1 id=picobj  style=\"HEIGHT: 1px; LEFT: 10px; TOP: 28px; WIDTH: 1px\" width=1 VIEWASTEXT>");
		document.writeln("</OBJECT>");
		XTXAPP.SOF_GetVersion();
	} else {
		document
				.writeln("<embed id=XTXAPP0 type=application/x-xtx-axhost clsid={3F367B74-92D9-4C5E-AB93-234F8A91D5E6} event_OnUsbkeyChange=OnUsbKeyChange width=1 height=1 />");
		XTXAPP = document.getElementById("XTXAPP0");
		XTXAPP.SOF_GetVersion();
	}
} catch (e) {
	//alert("����֤��Ӧ�û����Ƿ���ȷ��װ!");
}

// ��ȡ�û��б� ����䵽֤���б�
function GetUserList(strListID) {
	var objListID = eval(strListID);
	var strUserList = SOF_GetUserList();
	// alert(strUserList);
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
// ���֤���б�
function RemoveUserList(strListID) {
	var objListID = eval(strListID);
	var i;
	var n = objListID.length;
	for (i = 0; i < n; i++) {
		objListID.remove(0);
	}
}
// ��������û��б�
function ChangeUserList(strListID) {
	RemoveUserList(strListID);
	GetUserList(strListID);
}

// ��IE��������õ��ĺ���
function OnUsbKeyChange() {
	// alert("OnUsbKeyChange called!");
	ChangeUserList("LoginForm.UserList");
}

// ���ü����㷨
function SOF_SetEncryptMethod(encMethod) {
	return XTXAPP.SOF_SetEncryptMethod(encMethod);
}

// ����ǩ���㷨
function SOF_SetSignMethod(signMethod) {
	return XTXAPP.SOF_SetSignMethod(signMethod);
}

// ��ȡ�û��б�
function SOF_GetUserList() {
	return XTXAPP.SOF_GetUserList();
}

// �����û�֤��
function SOF_ExportUserCert(CertID, certType) {
	if (certType == KEY_SIGNOREXCHANGE) {
		return XTXAPP.SOF_ExportUserCert(CertID);
	} else if (certType == KEY_SIGNATURE) {
		var signCert = XTXAPP.SOF_ExportUserCert(CertID);
		var encCert = XTXAPP.SOF_ExportExChangeUserCert(CertID);
		if (signCert != encCert) {
			return signCert;
		} else { /* ������ǩ��֤�� */
			return "";
		}
	} else if (certType == KEY_KEYEXCHANGE) {
		return XTXAPP.SOF_ExportExChangeUserCert(CertID);
	} else {
		return "";
	}
}

// У���û�����
function SOF_Login(CertID, passwd) {
	var ret = XTXAPP.SOF_Login(CertID, passwd);
	if (ret) {
		return true;
	} else {
		return false;
	}
}

// ��ȡ�������Դ���
function SOF_GetPinRetryCount(CertID) {
	return XTXAPP.SOF_GetPinRetryCount(CertID);
}

// �޸�֤������
function SOF_ChangePassWd(CertID, OldPassWd, NewPassWd) {
	var ret = XTXAPP.SOF_ChangePassWd(CertID, OldPassWd, NewPassWd);
	if (ret) {
		return true;
	} else {
		return false;
	}
}

// ��ȡ֤����Ϣ
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

// ����ǩ��
function SOF_SignData(CertID, inData) {
	return XTXAPP.SOF_SignData(CertID, inData);
}

// ������ǩ
function SOF_VerifySignedData(sCert, inData, signValue) {
	var ret = XTXAPP.SOF_VerifySignedData(sCert, inData, signValue);
	if (ret) {
		return true;
	} else {
		return false;
	}
}

// �ļ�ǩ��
function SOF_SignFile(CertID, inFile) {
	return XTXAPP.SOF_SignFile(CertID, inFile);
}

// �ļ���ǩ
function SOF_VerifySignedFile(sCert, InFile, SignValue) {
	var ret = XTXAPP.SOF_VerifySignedFile(sCert, InFile, SignValue);
	if (ret) {
		return true;
	} else {
		return false;
	}
}

// P7�����ŷ���� ��CSP��ͨ
function SOF_EncryptData(sCert, Indata) {
	return XTXAPP.SOF_EncryptData(sCert, Indata);
}

// P7�����ŷ���� ��SVS BCA_ALL��ͨ
function SOF_EncryptDataEx(sCert, Indata) {
	return XTXAPP.SOF_EncryptDataEx(sCert, Indata);
}

// P7�����ŷ����
function SOF_DecryptData(CertID, Indata) {
	return XTXAPP.SOF_DecryptData(CertID, Indata);
}

// P7ǩ��
function SOF_SignMessage(dwFlag, CertID, InData) {
	return XTXAPP.SOF_SignMessage(dwFlag, CertID, InData);
}

// P7��ǩ
function SOF_VerifySignedMessage(MessageData, InData) {
	var ret = XTXAPP.SOF_VerifySignedMessage(MessageData, InData);
	if (ret) {
		return true;
	} else {
		return false;
	}
}

// �ԳƼ���
function SOF_SymEncryptData(sKey, InData) {
	return XTXAPP.SOF_SymEncryptData(sKey, InData);
}

// �Գƽ���
function SOF_SymDecryptData(sKey, InData) {
	return XTXAPP.SOF_SymDecryptData(sKey, InData);
}

// �ļ��ԳƼ���
function SOF_SymEncryptFile(sKey, InFile, OutFile) {
	var ret = XTXAPP.SOF_SymEncryptFile(sKey, InFile, OutFile);
	if (ret) {
		return true;
	} else {
		return false;
	}
}

// �ļ��Գƽ���
function SOF_SymDecryptFile(sKey, InFile, OutFile) {
	var ret = XTXAPP.SOF_SymDecryptFile(sKey, InFile, OutFile);
	if (ret) {
		return true;
	} else {
		return false;
	}
}

// ��Կ����
function SOF_PubKeyEncrypt(Cert, InData) {
	return XTXAPP.SOF_PubKeyEncrypt(Cert, InData);
}

// ˽Կ����
function SOF_PriKeyDecrypt(CertID, InData) {
	return XTXAPP.SOF_PriKeyDecrypt(CertID, InData);
}

// �ļ�ժҪ
function SOF_HashFile(hashAlg, InFile) {
	return XTXAPP.SOF_HashFile(hashAlg, InFile);
}

function SOF_GetLastError() {
	return XTXAPP.SOF_GetLastError();
}

function SOF_GetLastErrorMsg() {
	var code = XTXAPP.SOF_GetLastError();
	var msg = XTXAPP.SOF_GetLastErrMsg();

	return "������[" + code + "] ��������[" + msg + "]"
}

function CheckValid(userCert) {return true;
	// ���֤����Ч��
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
		alert("����֤����δ��Ч!������Ч���ڻ�ʣ" + days + "��!");
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
		alert("����֤���ѹ��� " + -days + " �죬���������ʹ�����ޣ�\n�뵽��������֤����֤���İ���֤�����������");
		return false;
	}

	if (days >= 0 && days <= 60) {
		alert("����֤�黹��" + days + "����ڣ�\n�������쵽��������֤����֤���İ���֤�����������");
		return true;
	}

	if (days < 0) {
		alert("����֤���ѹ��� " + -days + " �죬\n�뾡�쵽��������֤����֤���İ���֤�����������");
	}

	return true;
}

// �û���¼
function Login(strFormName, strCertID, strPin) {
	var objForm = eval(strFormName);
	if (objForm == null) {
		alert("������");
		return false;
	}
	if (strCertID == null || strCertID == "") {
		alert("��ȡ�û���Ϣʧ��");
		return false;
	}
	if (strPin == null || strPin == "") {
		alert("������֤������");
		return false;
	}
	if (strPin.length < 6 || strPin.length > 16) {
		alert("���볤��Ӧ����4-16λ֮��");
		return false;
	}

	// У������
	var ret = SOF_Login(strCertID, strPin);
	if (!ret) {
		var retryCount = SOF_GetPinRetryCount(strCertID);
		if (retryCount > 0) {
			alert("У��֤������ʧ��!������" + retryCount + "�λ�������!");
			return false;
		} else if (retryCount == 0) {
			alert("����֤�������ѱ�����,����ϵBJCA���н���!");
			return false;
		} else {
			alert("��¼ʧ��!");
			return false;
		}
	}

	// �����ͻ���֤��
	var userCert = SOF_ExportUserCert(strCertID, KEY_SIGNOREXCHANGE);
	if (userCert == null || userCert == "") {
		alert("�����û�֤��ʧ��!");
		return false;
	}

	// ���֤����Ч��
	if (!CheckValid(userCert)) {
		return false;
	}

	// ��֤�����ǩ��
	ret = SOF_VerifySignedData(strServerCert, strServerRan, strServerSignedData)
	if (!ret) {
		alert("��֤����������Ϣʧ��!");
		return false;
	}

	// ���������ǩ��
	var strClientSignedData = SOF_SignData(strCertID, strServerRan);
	if (strClientSignedData == null || strClientSignedData == "") {
		alert("�ͻ���ǩ��ʧ��!");
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

// /////////////////����ӿ�

function GetUserList() {
	var strUserList;
	try {
		strUserList = SOF_GetUserList();
		return strUserList;
	} catch (e) {

		return "";
	}
}
/**
 * function Loginxx(document.caAuditForm, key, pwd) { return null; }
 */
function getUserList_pnp() {
	var strUserList;
	try {
		strUserList = SOF_GetUserList();
		return strUserList;
	} catch (e) {

		return "";
	}
}
function SignedData(content, key) {
	return SOF_SignData(key, content);

}
function SignedOrdData(content, key) {
	return SOF_SignData(key, content);

}
// ��ȡ���֤��
function GetIdentityID(key) {
	var oid = "2.16.840.1.113732.2"; // RSA key
	// var oid = "1.2.156.112562.2.1.1.1";//SM2 key
	var cert;
	cert = SOF_ExportUserCert(key, KEY_SIGNATURE);
	var sf_id = XTXAPP.SOF_GetCertInfoByOid(cert, oid);
	return sf_id;
}

function GetSignCert(key) {

	return SOF_ExportUserCert(key, KEY_SIGNATURE);
}

function GetCertSN(cert) {
	return XTXAPP_GetCertDetail(cert, CERT_SERIAL);

}

function GetKeySN(key) {
	if (key != "") {
		var strs = new Array(); // ����һ����
		strs = key.split("/"); // �ַ��ָ�
		var keysn = strs[1];
		return keysn;

	} else {
		return null;
	}
}

function GetPicBase64Data(key) {

	return picobj.GetPic();

}
function HashData(InData) {

	return picobj.Hash(InData);

}

// ֤���ʶ������������֤��,�����û�֤��Ψһ��ʶ
function GetUniqueID(cert) {
	// var oid = "1.2.156.112562.2.1.4.1"; // SM2 key
	var oid = "1.2.156.112562.2.1.1.4"; // SM2 key
	var uniqueID = XTXAPP.SOF_GetCertInfoByOid(cert, oid);
	return uniqueID;
}

function GetCertCNName(cert) {
	return XTXAPP_GetCertDetail(cert, CERT_SUBJECT_CN);
}

function getKeySN(key) {
    if (key != "") {
        var strs = new Array(); // ����һ����
        strs = key.split("/"); // �ַ��ָ�
        var keysn = strs[1];
        return keysn;

    } else {
        return null;
    }
}

function GetGetPicBase64(key) {
	// ����ca�����⣬������hash������ȡ��ͼƬ,2012��8�·��Ժ�����Ŀ���Բ��Ӹ���䡣
	HashData("test");
	return GetPicBase64Data(key);
}

function GetCertNo(key) {
	var par = key.split('/');
	return par[0];
}

function getUsrSignatureInfo(key) {
    var usrSignatureInfo = new Array();
    usrSignatureInfo["identityID"] = GetIdentityID(key);
    var cert = GetSignCert(key);
    usrSignatureInfo["certificate"] = GetSignCert(key);
    usrSignatureInfo["certificateNo"] = key;
    usrSignatureInfo["CertificateSN"] = GetCertSN(cert);
    usrSignatureInfo["uKeyNo"] = getKeySN(key);
    //����ca�����⣬������hash������ȡ��ͼƬ,2012��8�·��Ժ�����Ŀ���Բ��Ӹ���䡣
    //HashData("test");  
    usrSignatureInfo["signImage"] = GetPicBase64Data(key);
    usrSignatureInfo["UsrCertCode"] = GetUniqueID(cert);
    usrSignatureInfo["CertName"] = GetCertCNName(cert);
    return usrSignatureInfo;
}
