/**
 * ģ��:		ҩ��
 * ��ģ��:		��ѧͨ����ά��
 * createdate:	2017-06-21
 * creator:		yunhaibao
 */
 
$(function(){
	GetChemicalValues();
	$("#btnClear").on("click",ClearContent);
	$("#btnSave").on("click",SaveContent);
	document.onkeypress = DHCSTEASYUI.BanBackspace;
	document.onkeydown = DHCSTEASYUI.BanBackspace;
});

function GetChemicalValues(){
	if (urlChemicalId!=""){
		$.ajax({
			type:"POST",
			data:"json",
			url:"DHCST.QUERY.JSON.csp?&Plugin=EasyUI.ComboBox"+
			"&ClassName=web.DHCST.PHCChemical"+
			"&QueryName=QueryByRowId"+
			"&StrParams="+urlChemicalId,
			error:function(){        
				alert("��ȡ����ʧ��!");
			},
			success:function(retData){
				SetChemicalValues(retData)
			}
		})	
	}
}
function SetChemicalValues(retData){
	var jsonData=JSON.parse(retData)[0];
	$("#txtChemicalCode").val(jsonData.txtChemicalCode||"");
	$("#txtChemicalDesc").val(jsonData.txtChemicalDesc||"");
}

function ClearContent(){
	$(".dhcst-win-content input").val("")
}

function SaveContent(){
	var chemicalCode=$("#txtChemicalCode").val().trim();
	if (chemicalCode==""){
		$.messager.alert("��ʾ","�����뻯ѧͨ��������!","warning");
		return;
	}
	var chemicalDesc=$("#txtChemicalDesc").val().trim();
	if (chemicalDesc==""){
		$.messager.alert("��ʾ","�����뻯ѧͨ��������!","warning");
		return;
	}
	if (urlActionType=="A"){
		urlChemicalId="";
	}else if (urlActionType=="U"){
		if (urlChemicalId==""){
			$.messager.alert("��ʾ","��ȡ��ѧͨ����IDʧ��,�����´򿪱༭!","warning");
			return;
		}
	}
	var strParams=urlPhcCatRowId+"^"+chemicalCode+"^"+chemicalDesc;
	var saveRet=tkMakeServerCall("web.DHCST.PHCChemical","Save",urlChemicalId,strParams)
	if(saveRet>0){
		$.messager.alert("�ɹ���ʾ","����ɹ�!","info");
		//parent.$('#maintainWin').window('close')
		parent.QueryPHCChemicalGrid();
		parent.DrugMainTainEditClose();
	}else{
		var saveArr=saveRet.split("^");
		$.messager.alert("������ʾ",saveArr[1],"error");
	}
}