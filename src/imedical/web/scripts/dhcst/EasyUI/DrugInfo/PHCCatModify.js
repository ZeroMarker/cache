/**
 * 模块:		药库
 * 子模块:		药学分类维护
 * createdate:	2017-06-21
 * creator:		yunhaibao
 */
 
$(function(){
	if (urlPhcCatRowId==""){
		urlPhcCatRowId=0;
	}
	InitContent();
	$("#btnClear").on("click",ClearContent);
	$("#btnSave").on("click",SaveContent);
	document.onkeypress = DHCSTEASYUI.BanBackspace;
	document.onkeydown = DHCSTEASYUI.BanBackspace;
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
		$.messager.alert("提示","请输入药学分类代码!","warning");
		return;
	}
	var phcCatDesc=$("#txtPhcCatDesc").val().trim();
	if (phcCatDesc==""){
		$.messager.alert("提示","请输入药学分类描述!","warning");
		return;
	}
	if (urlActionType=="A"){
		var insertRet=tkMakeServerCall("web.DHCST.PHCCATMAINTAIN","SaveCat",urlPhcCatRowId,phcCatCode,phcCatDesc)
		if(insertRet==0){
			$.messager.alert("成功提示","保存成功!","info");
			parent.ReloadPhcCatTreeById();
			parent.DrugMainTainEditClose();
		}else{
			if (insertRet==-11){
				$.messager.alert("提示","药学分类代码已存在!","warning");
			}else if (insertRet=-12){
				$.messager.alert("提示","药学分类描述已存在!","warning");
			}else{
				$.messager.alert("错误提示","保存失败,错误代码:"+insertRet,"error");
			}
		}
	}
	if (urlActionType=="U"){
		var updateRet=tkMakeServerCall("web.DHCST.PHCCATMAINTAIN","UpdCat",urlPhcCatRowId,phcCatCode,phcCatDesc)
		if(updateRet==0){
			$.messager.alert("成功提示","保存成功!","info");
			parent.ReloadPhcCatTreeById(urlPhcCatRowId);
			parent.DrugMainTainEditClose();
		}else{
			if (updateRet==-11){
				$.messager.alert("提示","药学分类代码已存在!","warning");
			}else if (updateRet=-12){
				$.messager.alert("提示","药学分类描述已存在!","warning");
			}else{
				$.messager.alert("错误提示","保存失败,错误代码:"+updateRet,"error");
			}
		}
	}
}