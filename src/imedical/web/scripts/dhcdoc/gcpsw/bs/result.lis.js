/**
 * result.lis.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-17
 * 
 * 
 */
$(function() {
	Init();
	InitEvent();
})


function Init(){
	InitHtml()
}
function InitEvent () {
	$("#OK").click(OK_Handle)
	$("#Reset").click(Reset_Handle)
}

function InitHtml (reset) {
	reset = reset||"";
	var IsVal=1
	if (ServerObj.Lis!="") IsVal=0
	if (reset==1) IsVal=1
	$m({
		ClassName:"DHCDoc.GCPSW.BS.Lis",
		MethodName:"GetItemHTML",
		ITID:ServerObj.ITID,
		PKID:ServerObj.PKID,
		IsVal:IsVal
	}, function(result){
		_$dom = $(result);
		$("#l-ul").empty();
		$("#l-ul").append(_$dom);
		
		if ((ServerObj.Lis!="")&&(reset!=1)) {
			var TempArr=ServerObj.Lis.split("!");
			for (i=0; i<TempArr.length; i++) {
				var CArr=TempArr[i].split("^");
				$("#"+CArr[0]).val(CArr[1]);
			}
				
		} else {
			//todo
		}
		if (ServerObj.code=="OutLis") {
			$("input").attr("disabled","disabled")
		}
	
	});	
	
	
	

}

function OK_Handle() {
	var PArr=[]
	$("#l-ul input").each(function(index,element) {
		var cid=$(element).attr("id")
		var val=$.trim($(element).val());
		var rule=$(element).attr("rule")
		var record = cid + "^" + val + "^" + rule;
		if (val!="") {
			PArr.push(record)
		}
	})
	var PLis = PArr.join("!")
	parent.websys_showModal("hide");
	parent.websys_showModal('options').CallBackFunc(PLis,ServerObj.ITID);
	parent.websys_showModal("close");	
}

function Reset_Handle() {
	InitHtml(1)
}