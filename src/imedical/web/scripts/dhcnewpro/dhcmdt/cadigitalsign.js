//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-07-19
// ����:	   ����ǩ��
//===========================================================================================
var rtn = "";
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID']; /// ��ȫ��ID
/// ��������ǩ�� ����Э��  2019-07-19
function InvDigSign(mdtID){

	runClassMethod("web.DHCMDTSignVerify","GetCAServiceStatus",{"LocID":LgLocID,"UserID":LgUserID},function(data){
		if (data != ""){
		CAInit = data;
		}
	},'',false)
	if (CAInit == 0) return;   /// ǩ���Ƿ���
	if (mdtID == ""){
		$.messager.alert("��ʾ:","mdt��������ID����Ϊ�գ�","warning");
		return;
	}
	var ret=0; /// �Ƿ���Ȩ��ǩ��
	if(ret == 0){
		if (isTakeDigSign()) TakeDigSign(mdtID); /// ����ǩ�� ���������
	}else{
		$.messager.alert("��ʾ","�Ѿ�ǩ��!");
	}
}

/// ����ǩ�� ���������
function TakeDigSign(mdtID){
	runClassMethod("web.DHCMDTConsultQuery","JsGetMdtObj",{"ID":mdtID},function(jsonString){
		if (jsonString != ""){
			
			InsDigitalSign(jsonString, mdtID);  /// ��������ǩ��
			
		}
	},'json',false)
}

/// CA����ǩ����֤����
function InsDigitalSign(itmValData, mdtID){	
	var ContainerName=rtn.ContainerName;  /// ֤��������
	
	var varCertCode=rtn.CAUserCertCode;   /// ֤���û�Ψһ��ʶ
	
	var CertNo=GetCertNo(ContainerName);   /// ֤��Ψһ��ʶ
	
	if (ContainerName!=""){
		var itmHashData = rtn.ca_key.HashData(1,itmValData); /// Hashֵ
		
		var itmSignData = rtn.ca_key.SignedData(itmHashData,ContainerName); /// ǩ������
		
		/// ����ǩ����Ϣ��¼
		var ret = InsBatchSign(itmValData, LgUserID, itmHashData, varCertCode, itmSignData, ContainerName,mdtID,CertNo);
		if (ret != "0") $.messager.alert("����", "ǩ��ʧ�ܣ�","warning");
		else $.messager.alert("����", "ǩ���ɹ���","warning");
	      
	}
}

/// ����ǩ��
function InsBatchSign(itmValData,LgUserID, itmHashData, varCertCode, itmSignData, ContainerName,mdtID,CertNo){
	
	var retFlag = "";
	runClassMethod("web.DHCMDTSignVerify","InsertBatchSign",{"ContentHash":itmHashData,"CertCode":varCertCode,"Cert":ContainerName,"SignedData":itmSignData,"LgUserID":LgUserID,"mdtID":mdtID,"EmrCode":"MDT","CertNo":CertNo},function(jsonString){
		retFlag = jsonString;     
	},'',false)
	return retFlag;
}

/// ����ǩ�����
function isTakeDigSign(){
	
	try{
		rtn = dhcsys_getcacert();
		if (!rtn.IsSucc) {
			alert("֤��δ��¼,�����µ�¼֤��!");
			return false;
		}
		var ContainerName=rtn.ContainerName;  //֤��������
		if (ContainerName!=""){
			return true;
		}else{
			alert("֤��Ϊ��!");
			return false;	
		}
	
	}catch(e){
		alert(e.message); 
		return false;
	}
    return true;
}

function GetCertNo(key){
	var par=key.split('/');
	return par[0];
}

//ר���Ƿ��Ѿ�ǩ������
function IsgetsignmdtSIGNID(ItmID)
{  
    var IsCASign = "";
	runClassMethod("web.DHCMDTSignVerify","IsgetsignmdtSIGNID",{"mdtID":ItmID},function(jsonString){
		IsCASign = jsonString;     
	},'',false)
	return IsCASign;
	
}
