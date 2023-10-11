/**
 * sae.refuse.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-02
 * 
 * 
 */
var PageLogicObj = {
}

$(function() {
	Init();
	InitEvent();
	PageHandle();
})


function Init(){
	
}

function InitEvent () {
	$("#Save").click(SaveHandler)
}
function PageHandle() {
	$("#Note").focus();
}
function SaveHandler() {
	var Note = $.trim($("#Note").val());
	if (Note=="") {
		$.messager.alert('提示',"拒绝原因不能为空！","warning",function () {
			$("#Note").focus();
		});
		return false;
	}
	
	$m({
		ClassName:"DHCDoc.GCP.SAE.BS",
		MethodName:"ChangeApply",
		MID:ServerObj.MID,
		InPara:ServerObj.InPara,
		Note:Note
	}, function(result){
		if (result == 0) {
			$.messager.alert("提示", "保存成功！", "info", function () {
				websys_showModal("hide");
				websys_showModal('options').CallBackFunc();
				websys_showModal("close");	
			});
		} else {
			$.messager.alert("提示", "保存失败：" + result , "info");
			return false;
		}
	});
				
	
}

