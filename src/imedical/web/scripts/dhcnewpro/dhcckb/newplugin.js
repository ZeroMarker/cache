//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2020-12-28
// ����:	   ֪ʶ����ҳ��JS
//===========================================================================================

var ID = "";
/// ҳ���ʼ������
function initPageDefault(){
	
	/// ��ʼ��ҳ�����
	InitPageParams();
}

/// ��ʼ��ҳ�����
function InitPageParams(){
	
	ID = getParam("ID");   /// ����ID
	if (ID != ""){
		// ��ʼ�����ر����������
		LoadPluginTemp();
	}
}

/// ��ʼ�����ر����������
function LoadPluginTemp(){
	
	runClassMethod("web.DHCCKBRevPlugin","GetRevPlugin",{"ID":ID},function(jsonObj){
		if (jsonObj != ""){
			$("#Code").val(jsonObj.Code);   /// ������
			$("#Desc").val(jsonObj.Desc);   /// ������
		}
	},'json',false)
}

/// ����
function Save(){
	
	var Code = $("#Code").val();  /// ����
	var Desc = $("#Desc").val();  /// ����
	if (Code == ""){
		$.messager.alert("��ʾ:","�����벻��Ϊ�գ�","warning");
		return;
	}
	if (Desc == ""){
		$.messager.alert("��ʾ:","�����Ʋ���Ϊ�գ�","warning");
		return;
	}
	
	runClassMethod("web.DHCCKBRevPlugin","SaveOrUpdate",{"ID":ID, "Code":Code, "Desc":Desc},function(jsonString){

		if (jsonString < 0){
			if(jsonString=="-1"){
				$.messager.alert("��ʾ:","���벻���ظ���","warning");
			}else if(jsonString=="-2"){
				$.messager.alert("��ʾ:","���Ʋ����ظ���","warning");
			}else{
				$.messager.alert("��ʾ:","����ʧ�ܣ�","warning");
			}
		}else{
			//$.messager.alert("��ʾ:","����ɹ���","success");
			CloseWin();    /// �رշ���
			window.parent.refresh(jsonString);
		}
	},'',false)
}

/// �رշ���
function CloseWin(){
	
	commonParentCloseWin();
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })