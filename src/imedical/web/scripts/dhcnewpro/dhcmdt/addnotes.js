//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-07-10
// ����:	   mdtѡ�����ģ�����
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
	
	/// ��ȡ��ע
	GetNotes();
	
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	EpisodeID = getParam("EpisodeID");   /// ����ID
	DisGrpID = getParam("DisGrpID");   /// ����ID
	mdtID = getParam("ID");
}

/// ��ע
function saveNotes(){
	
	var mdtnote = $("#mdtnote").val();     /// ��ע
	if (trim(mdtnote) == ""){
		$.messager.alert("��ʾ:","��ע���ݲ���Ϊ�գ�","warning");
		return;
	}
	var str=0
	runClassMethod("web.DHCMDTConsult","InsConNotes",{"mdtID":mdtID,"mData":mdtnote},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�������뱣��ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			str = jsonString;
			$.messager.alert("��ʾ:","����ɹ���","info",function(){
				window.parent.QryPatList();
				closewin();  /// �ر�
			});
		}
	},'',false)
}

/// ��ȡ��ע
function GetNotes(){
	
	runClassMethod("web.DHCMDTConsult","GetConNotes",{"mdtID":mdtID},function(jsonString){

		$("#mdtnote").val(jsonString);     /// ��ע
	},'',false)
}

/// �ر�
function closewin(){
	
	commonParentCloseWin();
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })