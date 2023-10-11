$("#Loading").hide();
$(function() {
	hospComp = GenHospComp("Nur_IP_AppointManageSet",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		hospID=d.HOSPRowId;   
		loadConfig();
	}
	loadConfig();
})
function loadConfig(){
	$.cm({
		ClassName:"Nur.InService.AppointManageSet",
		MethodName:"getAppointManageSet",
		hospId:hospID
	},function(data){
		$("#StartDate").val(data.StartDate);
		$("#EndDate").val(data.EndDate);
		$("#UnAppointNotAllowExecOrd").switchbox("setValue",data.UnAppointNotAllowExecOrd=="Y"?true:false);
		$("#UnAllocateNotAllowExecOrd").switchbox("setValue",data.UnAllocateNotAllowExecOrd=="Y"?true:false);
	})
}
function saveConfig(){
	var reg = /^-?\d+$/;
	var StartDate=$.trim($("#StartDate").val());
	if ((StartDate!="")&&(!reg.test(StartDate))) {
		$.messager.popover({ msg: "开始日期请输入整数!", type:'error' });
		return false;
	}
	var EndDate=$.trim($("#EndDate").val());
	if ((EndDate!="")&&(!reg.test(EndDate))) {
		$.messager.popover({ msg: "结束日期请输入整数!", type:'error' });
		return false;
	}
	var UnAppointNotAllowExecOrd=$("#UnAppointNotAllowExecOrd").switchbox("getValue")?"Y":"N";
	var UnAllocateNotAllowExecOrd=$("#UnAllocateNotAllowExecOrd").switchbox("getValue")?"Y":"N";
	$.cm({
		ClassName:"Nur.InService.AppointManageSet",
		MethodName:"saveAppointManageSet",
		StartDate:StartDate,
		EndDate:EndDate,
		UnAppointNotAllowExecOrd:UnAppointNotAllowExecOrd,
		UnAllocateNotAllowExecOrd:UnAllocateNotAllowExecOrd,
		hospId:hospID
	},function(rtn){
		if(rtn==0){
			$.messager.popover({ msg: "保存成功！", type:'success' });	
		}else{
			$.messager.popover({ msg: "保存失败！", type:'error' });			
		}
	})
}