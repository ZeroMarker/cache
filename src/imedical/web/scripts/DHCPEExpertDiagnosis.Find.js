/// /// 对应组件 诊断条件 
var CurrentSel=0
var SelectedRow=-1
var UserId=session['LOGON.USERID']
function BodyLoadHandler()
{	
	var obj;
	obj=document.getElementById("Find");
	if (obj) obj.onclick=BFind_Click;
	
}

function SetStationID(value)
{
	if (value=="") return false;
	var DataArry=value.split("^");
	var obj=document.getElementById("StationID");
	if (obj) obj.value=DataArry[1];
}
function BFind_Click()
{
	var obj;
	obj=document.getElementById("Code");
	if (obj) var Code=obj.value;
	obj=document.getElementById("DiagnoseConclusion");
	if (obj) var DiagnoseConclusion=obj.value;
	obj=document.getElementById("StationID");
	if (obj) var StationID=obj.value;
	obj=document.getElementById("StationName");
	if (obj) var StationName=obj.value;

	obj=document.getElementById("Alias");
	if (obj) var Alias=obj.value;
	var HighRisk=""
	obj=document.getElementById("HighRisk");
	if (obj&&obj.checked) HighRisk="Y";
	var ActiveFlag=0;
	obj=document.getElementById("ActiveFlag");
	if (obj&&obj.checked) ActiveFlag="1";
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEExpertDiagnosis.Find"
			+"&Code="+Code+"&DiagnoseConclusion="+DiagnoseConclusion+"&StationID="+StationID+"&Alias="+Alias+"&HighRisk="+HighRisk+"&ActiveFlag="+ActiveFlag+"&StationName="+StationName;
	window.location.href=lnk;
}
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	if (CurrentSel==selectrow) return false;
	CurrentSel=selectrow;
	var obj=document.getElementById("ED_RowIdz"+selectrow);
	if (obj){
		var ParRef=obj.value;
		
		if (parent.frames["right"]){
			lnk="dhcpeexpertdiagnosis.lnk.csp?ParrefRowId="+ParRef;
			parent.frames["right"].location.href=lnk;
		}

		/*if (parent.frames("right")){
			lnk="dhcpeexpertdiagnosis.lnk.csp?ParrefRowId="+ParRef;
			parent.frames("right").location.href=lnk;
		}*/
	}

}
document.body.onload = BodyLoadHandler;