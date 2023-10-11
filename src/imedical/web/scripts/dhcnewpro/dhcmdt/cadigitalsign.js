//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-07-19
// 描述:	   数字签名
//===========================================================================================
var rtn = "";
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID']; /// 安全组ID
/// 调用数字签名 北京协和  2019-07-19
function InvDigSign(mdtID){

	runClassMethod("web.DHCMDTSignVerify","GetCAServiceStatus",{"LocID":LgLocID,"UserID":LgUserID},function(data){
		if (data != ""){
		CAInit = data;
		}
	},'',false)
	if (CAInit == 0) return;   /// 签名是否开启
	if (mdtID == ""){
		$.messager.alert("提示:","mdt会诊申请ID不能为空！","warning");
		return;
	}
	var ret=0; /// 是否有权限签名
	if(ret == 0){
		if (isTakeDigSign()) TakeDigSign(mdtID); /// 数字签名 开申请调用
	}else{
		$.messager.alert("提示","已经签名!");
	}
}

/// 数字签名 开申请调用
function TakeDigSign(mdtID){
	runClassMethod("web.DHCMDTConsultQuery","JsGetMdtObj",{"ID":mdtID},function(jsonString){
		if (jsonString != ""){
			
			InsDigitalSign(jsonString, mdtID);  /// 调用数字签名
			
		}
	},'json',false)
}

/// CA数字签名认证函数
function InsDigitalSign(itmValData, mdtID){	
	var ContainerName=rtn.ContainerName;  /// 证书容器名
	
	var varCertCode=rtn.CAUserCertCode;   /// 证书用户唯一标识
	
	var CertNo=GetCertNo(ContainerName);   /// 证书唯一标识
	
	if (ContainerName!=""){
		var itmHashData = rtn.ca_key.HashData(1,itmValData); /// Hash值
		
		var itmSignData = rtn.ca_key.SignedData(itmHashData,ContainerName); /// 签名数据
		
		/// 保存签名信息记录
		var ret = InsBatchSign(itmValData, LgUserID, itmHashData, varCertCode, itmSignData, ContainerName,mdtID,CertNo);
		if (ret != "0") $.messager.alert("警告", "签名失败！","warning");
		else $.messager.alert("警告", "签名成功！","warning");
	      
	}
}

/// 保存签名
function InsBatchSign(itmValData,LgUserID, itmHashData, varCertCode, itmSignData, ContainerName,mdtID,CertNo){
	
	var retFlag = "";
	runClassMethod("web.DHCMDTSignVerify","InsertBatchSign",{"ContentHash":itmHashData,"CertCode":varCertCode,"Cert":ContainerName,"SignedData":itmSignData,"LgUserID":LgUserID,"mdtID":mdtID,"EmrCode":"MDT","CertNo":CertNo},function(jsonString){
		retFlag = jsonString;     
	},'',false)
	return retFlag;
}

/// 数字签名检查
function isTakeDigSign(){
	
	try{
		rtn = dhcsys_getcacert();
		if (!rtn.IsSucc) {
			alert("证书未登录,请重新登录证书!");
			return false;
		}
		var ContainerName=rtn.ContainerName;  //证书容器名
		if (ContainerName!=""){
			return true;
		}else{
			alert("证书为空!");
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

//专家是否已经签过名了
function IsgetsignmdtSIGNID(ItmID)
{  
    var IsCASign = "";
	runClassMethod("web.DHCMDTSignVerify","IsgetsignmdtSIGNID",{"mdtID":ItmID},function(jsonString){
		IsCASign = jsonString;     
	},'',false)
	return IsCASign;
	
}
