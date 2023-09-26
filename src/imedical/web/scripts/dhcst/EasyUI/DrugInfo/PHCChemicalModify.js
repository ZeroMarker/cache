/**
 * 模块:		药库
 * 子模块:		化学通用名维护
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
				alert("获取数据失败!");
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
		$.messager.alert("提示","请输入化学通用名代码!","warning");
		return;
	}
	var chemicalDesc=$("#txtChemicalDesc").val().trim();
	if (chemicalDesc==""){
		$.messager.alert("提示","请输入化学通用名描述!","warning");
		return;
	}
	if (urlActionType=="A"){
		urlChemicalId="";
	}else if (urlActionType=="U"){
		if (urlChemicalId==""){
			$.messager.alert("提示","获取化学通用名ID失败,请重新打开编辑!","warning");
			return;
		}
	}
	var strParams=urlPhcCatRowId+"^"+chemicalCode+"^"+chemicalDesc;
	var saveRet=tkMakeServerCall("web.DHCST.PHCChemical","Save",urlChemicalId,strParams)
	if(saveRet>0){
		$.messager.alert("成功提示","保存成功!","info");
		//parent.$('#maintainWin').window('close')
		parent.QueryPHCChemicalGrid();
		parent.DrugMainTainEditClose();
	}else{
		var saveArr=saveRet.split("^");
		$.messager.alert("错误提示",saveArr[1],"error");
	}
}