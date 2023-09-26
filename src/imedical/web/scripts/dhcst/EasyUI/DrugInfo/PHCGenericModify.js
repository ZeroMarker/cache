/**
 * 模块:		药库
 * 子模块:		处方通用名维护
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
    /// 剂型
	var options={
		ClassName:"web.DHCST.Util.DrugUtilQuery",
		QueryName:"GetPhcForm",
		StrParams:"",
		mode:"remote"
    }
    $("#cmbForm").dhcstcomboeu(options);
    /// 化学通用名
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
				alert("获取数据失败!");
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
		$.messager.alert("提示","请输入处方通用名代码!","warning");
		return;
	}
	var genericDesc=$("#txtGenericDesc").val().trim();
	if (genericDesc==""){
		$.messager.alert("提示","请输入处方通用名描述!","warning");
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
			$.messager.alert("提示","获取处方通用名ID失败,请重新打开编辑!","warning");
			return;
		}
	}
	var strParams=chemicalId+"^"+genericCode+"^"+genericDesc+"^"+geneStDate+"^"+geneEdDate+"^"+stkCatId+"^"+formId;
	var saveRet=tkMakeServerCall("web.DHCST.PHCGeneric","Save",urlGenericId,strParams)
	if(saveRet>0){
		$.messager.alert("成功提示","保存成功!","info");
		//parent.$('#maintainWin').window('close')
		parent.QueryPHCGenericGrid();
		parent.DrugMainTainEditClose();
	}else{
		var saveArr=saveRet.split("^");
		$.messager.alert("错误提示",saveArr[1],"error");
	}
}