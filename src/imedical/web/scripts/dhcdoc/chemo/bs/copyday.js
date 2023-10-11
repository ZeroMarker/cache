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
	InitDate()
}

function InitEvent () {
	$("#Copy").click(Copy_Handle)
}

function InitDate() {
	
	var result = $cm({
		ClassName:"DHCDoc.Chemo.BS.Ext.Copy",
		MethodName:"GetEnableSeclectDay",
		PSID:ServerObj.PSID,
		dataType:"text"
	},false);
	
	var dateFormate="Y-m-d"
    if (ServerObj.defaultDataCache==4){
        dateFormate="d/m/Y"
    }
    
	$("#SelectDate").flatpickr({
    	//enableTime: true,
		//mode: "multiple",
    	//enableSeconds:true,
    	dateFormat: dateFormate,
    	time_24hr: true,
		conjunction: ",",
    	onOpen:function(pa1,ap2){
	    	
	    },
		enable: result.split(",")
    })
    
	
}


function Copy_Handle () {
	var SelectDate = $("#SelectDate").val();
	if (SelectDate == "") {
		$.messager.alert("提示", "请选择日期！", "info");
		return false;
	}
	
	$cm({
			ClassName: "DHCDoc.Chemo.BS.Ext.Copy",
			MethodName: "CopyDay",
			PSID: ServerObj.PSID,
			CopyDate: ServerObj.CopyDate,
			SeclectDate:SelectDate,
			dataType:"text"
		},function(result){
			if(result==1){
				$.messager.alert("提示", "复制成功！", "info", function () {
					websys_showModal("hide");
					websys_showModal('options').CallBackFunc();
					websys_showModal("close");	
				});
			} else {
				$.messager.alert("提示","复制失败！"+result,"warning");
				return false;
			}
		})
		
}
