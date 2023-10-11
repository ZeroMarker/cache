$(function(){
    LoadPatListInfo();
    InitEvent();
});
function InitEvent()
{
    $('#InPatListBtn').click(function(){
        ComplateAdm();
        parent.showPatListWin();
    });
    $('#InEMRBtn').click(function(){
        ComplateAdm();
        parent.switchTabByEMR('门诊病历');
    });
    $('#InCurPageBtn').click(function(){
        parent.$('#menuStep').marystep('selectLastStep');
    });
    $('#callPatient').click(function(){
        ComplateAdm();
        parent.showPatListWin();
        parent.frames["PatListFrm"].callPatientHandler();
    });
    $('#reCallPatient').click(function(){
        parent.showPatListWin();
        parent.frames["PatListFrm"].reCallPatientHandler();
    });
    $('#skipAndCallPatient').click(function(){
        $.cm({ 
			ClassName:"web.DHCDocOutPatientList",
			MethodName:"SetSkipStatus",
			Adm:ServerObj.EpisodeID,
            DocDr:ServerObj.DoctorID,
            dataType:'text'
		},function(stat){
			if (stat!='1'){
				$.messager.alert("提示",'过号失败!');
				return false;
			}
            parent.showPatListWin();
			parent.frames["PatListFrm"].callPatientHandler();
		});
    });
    $('#ReceiveNextPat').click(function(){
        var rtn=ComplateAdm();
        if (rtn!="0"){
            $.messager.alert("提示",rtn.split("^")[1]);
            return false;
        }else{
            parent.frames["PatListFrm"].LoadOutPatientDataGrid();
            $.cm({
                ClassName:"web.DHCDocOutPatientList",
                MethodName:"GetNextPatMethod",
                LocId:session['LOGON.CTLOCID'],
                UserId:session['LOGON.USERID'],
                dataType:"text"
            },function(NextCallPat){
                if (NextCallPat==""){
                    $.messager.confirm('确认对话框',"没有正在等待就诊的患者,是否返回门诊患者列表?",function(r){
                        if (r){
                            parent.showPatListWin();
                        }
                    });
                }else{
                    var NextCallPatArr=NextCallPat.split("^");
                    parent.switchPatient(NextCallPatArr[1],NextCallPatArr[0],NextCallPatArr[2]);
                }
            });
        }
    })
}
function LoadPatListInfo(){
	$.cm({
	    ClassName : "DHCDoc.OPDoc.PatientList",
	    MethodName : "OutPatientListCatCount",
	    LocID: session['LOGON.CTLOCID'],
	    UserID: session['LOGON.USERID'],
	    IPAddress: "",
	    AllPatient: "",
	    PatientNo: "",
	    SurName: "",
	    StartDate: "",
	    EndDate: "",
	    ArrivedQue: "",
	    RegQue: "",
	    Consultation: "",
	    MarkID:"",
	    CheckName:""
	},function(data){
		for(var pro in data){
			$("#"+pro).text(data[pro]);
		}
	}); 
}
function ComplateAdm(){
	var rtn=$.cm({
		ClassName:"web.DHCDocOutPatientList",
		MethodName:"SetComplate",
		Adm:ServerObj.EpisodeID,
		LocId:session['LOGON.CTLOCID'],
		UserId:session['LOGON.USERID'],
		dataType:"text"
	},false);
	return rtn;
}
function xhrRefresh(refreshArgs)
{
    $.extend(ServerObj, { EpisodeID:refreshArgs.EpisodeID});
    LoadPatListInfo();
}