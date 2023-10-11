$(function(){
	InitSeachs();
	InitEvent();
})
function InitSeachs(){
	var EpisodeID=GetMenuPara("EpisodeID");
	if (EpisodeID !="") {
		InitPatInfo(EpisodeID);
	}
	$HUI.datebox('#SearchSttDate,#SearchEndDate').setValue(ServerObj.NowDate);
	$("#CardNo").focus();
}
function InitEvent(){
	$("#BFind").click(LoadOrdListDataGrid);
	if (ServerObj.ParaType!="SideMenu"){
		$("#BClear").click(ClearClickHandler);
		$("#ReadCard").click(ReadCardClickHandler);
		}
	$(document.body).bind("keydown",BodykeydownHandler);
	$("#BInfoSave").click(InfoSaveClickHandler);
}
function InitPatInfo(EpisodeID){
	$.m({
	    ClassName:"web.UDHCPrescriptQueryCM",
	    MethodName:"getname",
	    EpisodeID:EpisodeID
	},function(PatInfo){ 
		if (PatInfo!="") {
			var PatInfoAry=PatInfo.split("^");
			//加入病案号
			var MdeNo=PatInfoAry[18];
			$("#Patmed").val(MdeNo);
			var PatientNo=PatInfoAry[1];
			SetPatientInfo(PatientNo,"");
		}
	});
}
function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	if (keyCode==13) {
		if ((SrcObj.tagName=="A")||(SrcObj.tagName=="INPUT")) {
			if (SrcObj.id=="CardNo"){
				CardNoKeydownHandler(e);
				return false;
			}else if(SrcObj.id=="PatNo"){
				PatNoKeydownHandler(e);
				return false;
			}else if(SrcObj.id=="Patmed"){
				PatMedKeydownHandler(e);
				return false;
			}
			return true;
		}
	}
}
function CardNoKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		 var CardNo=$("#CardNo").val();
		 if (CardNo=="") return;
		 var myrtn=DHCACC_GetAccInfo("",CardNo,"","PatInfo",CardTypeCallBack);
	}
}
function PatNoKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		var CardNo=$("#CardNo").val();
		var PatientNo=$("#PatientNo").val(); 
		if(PatientNo!=""){
			PatientNo=FormatPatNo();
			$.m({
			    ClassName:"web.DHCOPCashierIF",
			    MethodName:"GetPAPMIByNo",
			    PAPMINo:PatientNo,
			    ExpStr:""
			},function(PatientID){ 
				if (PatientID=="") {
					$.messager.alert("提示","此患者ID不存在!","info",function(){
						$("#PatNo").val("").focus();
					})
				}
				SetPatientInfo(PatientNo,"");
			});
		}
	}
}
function PatMedKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		var CardNo=$("#CardNo").val();
		var PatientNo=$("#PatNo").val(); 
		var PatMed=$("#Patmed").val();
		if(PatMed!=""){
			var Ret = $.cm({
				ClassName:"web.DHCDocOrderEntryCM",
				MethodName:"GetPatIDByInMedNo",
				PatMed:PatMed,
				dataType:"text"
			},false);
			if(Ret==""){
				$.messager.alert("提示","病案号【"+PatMed+ "】对应患者不存在!","info",function(){
					$("#Patmed").focus();
				});
			}else{
			 	$("#PatNo").val(Ret.split("^")[1]);
				SetPatientInfo(PatientNo,CardNo);
			}
		}
	}
}
function FormatPatNo(){
	var PatNo=$("#PatNo").val();
	if (PatNo!='') {
		if ((PatNo.length<10)) {
			for (var i=(10-CardNo.length-1); i>=0; i--) {
				PatNo="0"+PatNo;
			}
		}
	}
	return PatNo
}
function CardTypeCallBack(myrtn){
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0": //卡有效有帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").val(CardNo);
			SetPatientInfo(PatientNo,CardNo);
			event.keyCode=13;			
			break;
		case "-200": //卡无效
			$.messager.alert("提示","卡无效!","info",function(){
				$("#CardNo").focus();
			})
			break;
		case "-201": //卡有效无帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").val(CardNo);
			SetPatientInfo(PatientNo,CardNo);
			event.keyCode=13;
			break;
		default:
	}
}
function SetPatientInfo(PatientNo,CardNo){
	$("#CardNo").val(CardNo);
	if (PatientNo!=""){
		$.m({
		    ClassName:"web.DHCDocOrderEntry",
		    MethodName:"GetPatientByNo",
		    PapmiNo:PatientNo
		},function(PatInfo){ 
			if (PatInfo!="") {
				var tempArr=PatInfo.split("^");
				var PatName=tempArr[2];
				var PatSex=tempArr[3];
				var PatNo=tempArr[1];
				$("#PatName").val(PatName);
				$("#PatSex").val(PatSex);
				$("#PatNo").val(PatNo);
				$("#PatAge").val(tempArr[4]);
				LoadOrdListDataGrid();
			}
		});
	}
}
function ReadCardClickHandler(){
	var myrtn=DHCACC_GetAccInfo7(CardTypeCallBack);
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
/* 得到菜单参数 */
function GetMenuPara(ParaName) {
    var myrtn = "";
    var frm = dhcsys_getmenuform();
    if (frm) {
	    if (eval("frm." + ParaName)){
        	myrtn = eval("frm." + ParaName + ".value");
        }
    }
    return myrtn;
}
function ClearClickHandler(){
	$(".textbox").val('');
	$("#SearchSttDate,#SearchEndDate").datebox('setValue',ServerObj.NowDate);
	$('#tabOrdList').treegrid('loadData', {});
	$("#AllUnPrint").checkbox('check');
	$("#Dept").combobox('select','');
	$("#Ward").combobox('select','');
	SetDefaultWard();
	$("#CardNo").focus();
}
