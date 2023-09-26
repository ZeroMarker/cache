/**
 * ģ��:		ҩ��
 * ��ģ��:		����ͨ����ά��
 * createdate:	2017-06-23
 * creator:		yunhaibao
 */
var LoadTimes=0
$(function(){
	InitDict();
    GetGenericValues();
	$("#btnClear").on("click",ClearContent);
	$("#btnSave").on("click",SaveContent);
	document.onkeypress = DHCSTEASYUI.BanBackspace;
	document.onkeydown = DHCSTEASYUI.BanBackspace;
});
function InitDict(){
    /// ����
	var options={
		ClassName:"web.DHCST.Util.DrugUtilQuery",
		QueryName:"GetPhcForm",
		StrParams:"",
		mode:"remote"
    }
    $("#cmbForm").dhcstcomboeu(options);
    /// ��ѧͨ����
	var options={
		ClassName:"web.DHCST.Util.DrugUtilQuery",
		QueryName:"GetChemical",
		StrParams:"|@|"+urlChemicalId,
		mode:"remote",
		onLoadSuccess:function(data) {
			LoadTimes=LoadTimes+1;
			if ((LoadTimes==1)&&(urlChemicalId!="")){
				$("#cmbChemical").combobox("setValue",urlChemicalId)
			}
		}
    }
    $("#cmbChemical").dhcstcomboeu(options);
    $("#dtStartDate").datebox({});
    $("#dtEndDate").datebox({});
}
function GetGenericValues(){
	if (urlGenericId!=""){
		$.ajax({
			type:"POST",
			data:"json",
			url:"DHCST.QUERY.JSON.csp?&Plugin=EasyUI.ComboBox"+
			"&ClassName=web.DHCST.PHCGeneric"+
			"&QueryName=QueryByRowId"+
			"&StrParams="+urlGenericId,
			error:function(){        
				alert("��ȡ����ʧ��!");
			},
			success:function(retData){
				SetGenericValues(retData)
			}
		})	
	}
}
function SetGenericValues(retData){
	var jsonData=JSON.parse(retData)[0];
	$("#cmbForm").combobox("setValue",jsonData.cmbForm||"");
	$("#txtGenericCode").val(jsonData.txtGenericCode||"");
	$("#txtGenericDesc").val(jsonData.txtGenericDesc||"");
	$("#dtStartDate").datebox("setValue",jsonData.dtStartDate||"");
	$("#dtEndDate").datebox("setValue",jsonData.dtEndDate||"");
}

function ClearContent(){
	$(".dhcst-win-content input").val("")
}

function SaveContent(){
	var genericCode=$("#txtGenericCode").val().trim();
	if (genericCode==""){
		$.messager.alert("��ʾ","�����봦��ͨ��������!","warning");
		return;
	}
	var genericDesc=$("#txtGenericDesc").val().trim();
	if (genericDesc==""){
		$.messager.alert("��ʾ","�����봦��ͨ��������!","warning");
		return;
	}
	var stkCatId="";
	var geneStDate=$("#dtStartDate").datebox('getValue');
	var geneEdDate=$("#dtEndDate").datebox('getValue');
	var formId=$("#cmbForm").dhcstcomboeu('getValue');
	var chemicalId=$("#cmbChemical").dhcstcomboeu('getValue');
	if (urlActionType=="A"){
		urlGenericId="";
	}else if (urlActionType=="U"){
		if (urlGenericId==""){
			$.messager.alert("��ʾ","��ȡ����ͨ����IDʧ��,�����´򿪱༭!","warning");
			return;
		}
	}
	var strParams=chemicalId+"^"+genericCode+"^"+genericDesc+"^"+geneStDate+"^"+geneEdDate+"^"+stkCatId+"^"+formId;
	var saveRet=tkMakeServerCall("web.DHCST.PHCGeneric","Save",urlGenericId,strParams)
	if(saveRet>0){
		$.messager.alert("�ɹ���ʾ","����ɹ�!","info");
		//parent.$('#maintainWin').window('close')
		parent.QueryPHCGenericGrid();
		parent.DrugMainTainEditClose();
	}else{
		var saveArr=saveRet.split("^");
		$.messager.alert("������ʾ",saveArr[1],"error");
	}
}