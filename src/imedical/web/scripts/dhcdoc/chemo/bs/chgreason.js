/**
 *chgreason.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */

$(function() {
	Init();
	InitEvent();
})

function Init(){
	InitCombox();
	
}

function InitEvent () {
	$("#Save").click(Save_Handler)
	
}

function InitCombox() {
	//var TPID = ServerObj.TPGID.split("||")[0];
	PLObject.m_ChgReason = $HUI.combobox("#chgreason", {
		url:$URL+"?ClassName=DHCDoc.Chemo.CFG.ChgReason&QueryName=QryReason&InActive=Y&TplDR="+ServerObj.TPID+"&InHosp="+session['LOGON.HOSPID']+"&InFlag=1&ResultSetType=array",
		valueField:'id',
		textField:'reason',
		blurValidValue:true
	});
}

function Save_Handler () {
	
	var PRAry = [];
	var ID = ""
	var PGID = ServerObj.PGID;
	var PIID = "";
	var Action = ServerObj.Action;
	var PatientID = ServerObj.PatientID;
	var EpisodeID = ServerObj.EpisodeID;
	var Arcim = ServerObj.ArcimDR;
	var Reason = PLObject.m_ChgReason.getValue()||"";
	var User = session['LOGON.USERID'];
	var Loc = session['LOGON.CTLOCID'];
	var PSID= ServerObj.PSID;
	if (Reason=="") {
		$.messager.alert("提示", "请填写变更原因！", "info");
		return false;
	}
	PRAry.push(ID,PGID,PIID,Action,PatientID,EpisodeID,Arcim,Reason,User,Loc,PSID)
	
	$m({
		ClassName:"DHCDoc.Chemo.BS.Ext.PlanReason",
		MethodName:"Save",
		PRAry:PRAry
	}, function(result){
		if (result >= 0) {
			//$.messager.alert("提示", "保存成功！", "info", function () {
				websys_showModal("hide");
				//websys_showModal('options').CallBackFunc();
				websys_showModal("close");	
			//});
		} else {
			$.messager.alert("提示", "保存失败：" + result , "info");
			return false;
		}
	});
}
