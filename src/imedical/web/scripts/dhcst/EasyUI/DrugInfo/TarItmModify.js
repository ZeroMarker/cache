/**
 * ģ��:		ҩ��
 * ��ģ��:		ҩѧ����ά��
 * createdate:	2017-06-21
 * creator:		yunhaibao
 */
 
$(function(){
	return
	$("input[type=text]").dhcstcomboeu({})
	//InitContent();
});

function InitContent(){
	if ((urlActionType=="U")&&(urlPhcCatRowId!="")){
		var phcCatStr=tkMakeServerCall("web.DHCST.PHCCATMAINTAIN","GetPhcCatInfoByRowId",urlPhcCatRowId);
		if (phcCatStr!=""){
			var phcCatArr=phcCatStr.split("^");
			$("#txtPhcCatCode").val(phcCatArr[0]).validatebox('validate');
			$("#txtPhcCatDesc").val(phcCatArr[1]).validatebox('validate');
		}
	}
}

function ClearContent(){
	$(".dhcst-win-content input").val("")
}

function SaveContent(){
	var phcCatCode=$("#txtPhcCatCode").val().trim();
	if (phcCatCode==""){
		$.messager.alert("��ʾ","������ҩѧ�������!");
		return;
	}
	var phcCatDesc=$("#txtPhcCatDesc").val().trim();
	if (phcCatDesc==""){
		$.messager.alert("��ʾ","������ҩѧ��������!");
		return;
	}
	if (urlActionType=="A"){
		var insertRet=tkMakeServerCall("web.DHCST.PHCCATMAINTAIN","SaveCat",urlPhcCatRowId,phcCatCode,phcCatDesc)
		if(insertRet==0){
			$.messager.alert("��ʾ","����ɹ�!");
		}else{
			if (insertRet==-11){
				$.messager.alert("��ʾ","ҩѧ��������Ѵ���!");
			}else if (insertRet=-12){
				$.messager.alert("��ʾ","ҩѧ���������Ѵ���!");
			}else{
				$.messager.alert("����","����ʧ��,�������:"+insertRet);
			}
		}
	}
	if (urlActionType=="U"){
		var updateRet=tkMakeServerCall("web.DHCST.PHCCATMAINTAIN","UpdCat",urlPhcCatRowId,phcCatCode,phcCatDesc)
		if(updateRet==0){
			$.messager.alert("��ʾ","����ɹ�!");
		}else{
			if (updateRet==-11){
				$.messager.alert("��ʾ","ҩѧ��������Ѵ���!");
			}else if (updateRet=-12){
				$.messager.alert("��ʾ","ҩѧ���������Ѵ���!");
			}else{
				$.messager.alert("����","����ʧ��,�������:"+updateRet);
			}
		}
	}
}