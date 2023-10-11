$(document).ready(function(){
	
})
$(function(){
	InitEvent();
	PageHandle();
});
function InitEvent(){
	if ($("#Find").length>0){
		$("#Find").click(FindClick);
	}
}
function FindClick(){
	FindConstList();
	FindApplyList();
}

function PageHandle(){
	if (ServerObj.PageShowFromWay=="ListEntryOld"){
		KSSApplyObj.InitData(ServerObj.ApplyId);
		KSSApplyObj.InitCombobox();
		KSSApplyObj.InitDataGrid();
	}
	if (ServerObj.PageShowFromWay=="ListEntry"){	
		var ShowTabStr = "Apply";
		if (ServerObj.Process.indexOf("H")>=0 ) {
			ShowTabStr = "Apply,Consult"
		}
		var src = "dhcant.kss.business.findapply.csp?ShowTabStr="+ShowTabStr+"&PAADMRowid="+ServerObj.EpisodeID+"&ArcimRowid="+ServerObj.ArcimId+"&OrderPoisonCode="+ServerObj.PoisonCode+"&PAAdmType="+ServerObj.PAAdmType+"&OrderAntibApplyRowid="+ServerObj.ApplyId;
		var frame='<iframe id="findapply" name="findapply" src='+src+' width="100%" min-height="500px" height="100%" frameborder="0"></iframe>'
		$('#APanel').empty().append(frame);
	}
	if (ServerObj.PageShowFromWay=="Apply"){
		$HUI.datebox("#StartDate").setValue(ServerObj.PreDate);
		$HUI.datebox("#EndDate").setValue(ServerObj.CuDate);
		HistoryConsultObj.InitCombobox(ServerObj);
		HistoryConsultObj.InitDataGrid(ServerObj);
		HistoryApplyObj.InitDataGrid();
	}	
	FindClick();
}

/// 会诊列表
function FindConstList(){
	var StartDate = $HUI.datebox("#StartDate").getValue(); 
	var EndDate = $HUI.datebox("#EndDate").getValue();     
	var RLocID = "";	//会诊科室
	var CstType = "";	//会诊类型
	var params = StartDate +"^"+ EndDate +"^"+ RLocID +"^"+ CstType +"^"+ ServerObj.PatientID +"^"+ ServerObj.EpisodeID;
	$("#bmDetList").datagrid("load",{"Params":params}); 
}

/// 抗菌药物申请列表
function FindApplyList(){
	var StartDate = $HUI.datebox("#StartDate").getValue(); 
	var EndDate = $HUI.datebox("#EndDate").getValue(); 
	var Session = GetSession();
	var Obj={
		EpisodeID:ServerObj.EpisodeID, 
		StDate:StartDate,
		EndDate:EndDate,
		SessionStr:Session, 
		Flag:"ALL"
	}  
	$("#i-audit-list-grid").datagrid("load",Obj); 
}

function GetSession(){
	var UserID = session['LOGON.USERID'];
    var LocID = session['LOGON.CTLOCID'];
    var GroupID = session['LOGON.GROUPID'];
    var HospID = session['LOGON.HOSPID'];
    var Str = UserID+"^"+LocID+"^"+GroupID+"^"+HospID;
    return Str;
}