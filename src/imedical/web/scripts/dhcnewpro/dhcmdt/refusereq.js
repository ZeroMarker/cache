//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2020-08-04
// ����:	   ���ؽ���
//===========================================================================================
var DisGrpID = ""; /// ����ID
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
/// ҳ���ʼ������
function initPageDefault(){
	
	/// ��ʼ�����ز��˾���ID
	InitPatEpisodeID();
	
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	EpisodeID = getParam("EpisodeID");   /// ����ID
	DisGrpID = getParam("DisGrpID");     /// ����ID
	mdtID = getParam("ID");
}

/// ����
function saveRefuses(){
	
	var refReason = $("#refreason").val();  /// ��������
	if (trim(refReason) == ""){
		$.messager.alert("��ʾ:","�������ɲ���Ϊ�գ�","warning");
		return;
	}
	var str=0
	runClassMethod("web.DHCMDTConsult","InsRefReason",{"mdtID":mdtID,"refReason":refReason,"userID":LgUserID},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�������ɱ���ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			str = jsonString;
			$.messager.alert("��ʾ:","����ɹ���","info",function(){
				//window.parent.QryPatList();
				window.parent.TakClsWin();
			});
		}
	},'',false)
}

/// �ر�
function closewin(){
	parent.$(".panel-tool-close").click();
	//commonParentCloseWin();
	//window.parent.TakClsWin();
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })