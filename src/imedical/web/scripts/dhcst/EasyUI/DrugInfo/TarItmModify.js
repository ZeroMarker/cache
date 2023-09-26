/**
 * 模块:		药库
 * 子模块:		药学分类维护
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
		$.messager.alert("提示","请输入药学分类代码!");
		return;
	}
	var phcCatDesc=$("#txtPhcCatDesc").val().trim();
	if (phcCatDesc==""){
		$.messager.alert("提示","请输入药学分类描述!");
		return;
	}
	if (urlActionType=="A"){
		var insertRet=tkMakeServerCall("web.DHCST.PHCCATMAINTAIN","SaveCat",urlPhcCatRowId,phcCatCode,phcCatDesc)
		if(insertRet==0){
			$.messager.alert("提示","保存成功!");
		}else{
			if (insertRet==-11){
				$.messager.alert("提示","药学分类代码已存在!");
			}else if (insertRet=-12){
				$.messager.alert("提示","药学分类描述已存在!");
			}else{
				$.messager.alert("错误","保存失败,错误代码:"+insertRet);
			}
		}
	}
	if (urlActionType=="U"){
		var updateRet=tkMakeServerCall("web.DHCST.PHCCATMAINTAIN","UpdCat",urlPhcCatRowId,phcCatCode,phcCatDesc)
		if(updateRet==0){
			$.messager.alert("提示","保存成功!");
		}else{
			if (updateRet==-11){
				$.messager.alert("提示","药学分类代码已存在!");
			}else if (updateRet=-12){
				$.messager.alert("提示","药学分类描述已存在!");
			}else{
				$.messager.alert("错误","保存失败,错误代码:"+updateRet);
			}
		}
	}
}