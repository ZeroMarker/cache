/// ҳ���ʼ������
function initPageDefault(){
}

/// ��ȡ�ļ�
function read(){
	
	var files=$("input[name=file9]").val();                           
	runClassMethod("web.DHCCKBRuleUpdCompare","ImportGlobal",{"Global":"TMPExportDrugRule",FilePath:files,"loginInfo":LoginInfo},function(jsonString){
		if (jsonString[0].sqlCode == 0){
			$.messager.alert("��ʾ:","����ɹ���","info");
			$("input[name=file9]").val("");
		    $("#ALL label").text(jsonString[0].ALL);
			$("#DIFF label").text(jsonString[0].DIFF);
			$("#ADD label").text(jsonString[0].ADD);
		}else{
			$.messager.alert("��ʾ:","����ʧ�ܣ�","");
		}
	
	},'json',false)
}



/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })