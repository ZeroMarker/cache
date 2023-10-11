/**
 * copyday.js
 * 
 * Copyright (c) 2021-2022 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2021-03-11
 * 
 * 
 */
PLObject = {

}
$(function() {
	Init();
	InitEvent();
})


function Init(){
	InitData();
}

function InitEvent () {
	$("#Save").click(Save_Handle)
}

function InitData() {
	var result = $cm({
		ClassName:"DHCDoc.Chemo.BS.Apply",
		MethodName:"GetMainDrug",
		PSID:ServerObj.PSID,
		InType:ServerObj.InType,
		isEdit:1,
		dataType:"text"
	},false);
	
	$("#MainDrugInfo").val(result)
}


function Save_Handle () {
	var MainDrugInfo = $.trim($("#MainDrugInfo").val())
	if (MainDrugInfo == "") {
		$.messager.alert("提示", "请填写主药信息！", "info");
		return false;
	}
	
	$cm({
			ClassName: "DHCDoc.Chemo.BS.Apply",
			MethodName: "UpdateMainDrugInfo",
			PSID: ServerObj.PSID,
			MainDrugInfo: MainDrugInfo,
			dataType:"text"
		},function(result){
			if(result==0){
				$.messager.alert("提示", "保存成功！", "info", function () {
					websys_showModal("hide");
					websys_showModal('options').CallBackFunc();
					websys_showModal("close");	
				});
			} else {
				$.messager.alert("提示","保存失败！"+result,"warning");
				return false;
			}
		})
		
}
