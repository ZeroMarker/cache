/// /// 对应组件DHCPEHighRiskFind 高危数据查询
var CurrentSel=0
var SelectedRow=-1
var TFORM="tDHCPEHighRiskFind"
var obj;
function BodyLoadHandler()
{	
	var obj;
	
	obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;

	//登记号
	obj=document.getElementById('RegNo');
	if (obj) {
	obj.onkeydown=RegNo_keydown; }
	//姓名
	obj=document.getElementById('Name');
	if (obj) { //obj.onchange = NameChange;
	obj.onkeydown=Name_keydown; }
	
	obj=document.getElementById("Group");
	if (obj) { obj.onchange=Group_Change; }
	
	obj=document.getElementById("Team");
	if (obj) { obj.onchange=Team_Change; }
	
	obj=document.getElementById("HighDiagnosis");
	if (obj) { obj.onchange=HighDiagnosis_Change; }
	
	obj=document.getElementById("Station");
	if (obj) { obj.onchange=Station_Change; }
	
	obj=document.getElementById("Detail");
	if (obj) { obj.onchange=Detail_Change; }
	
	Muilt_LookUp('Group'+'^'+'Team'+'^'+'HighDiagnosis');

}
function Group_Change()
{
	var obj=document.getElementById("GroupDR");
	if (obj) { obj.value=""; }
}
function Team_Change()
{
	var obj=document.getElementById("TeamID");
	if (obj) { obj.value=""; }
}

function HighDiagnosis_Change()
{
	var obj=document.getElementById("HighDiagnosisID");
	if (obj) { obj.value=""; }
}

function Station_Change()
{
	var obj=document.getElementById("StationRowId");
	if (obj) { obj.value=""; }
}
function Detail_Change()
{
	var obj=document.getElementById("OrderDetailRowId");
	if (obj) { obj.value=""; }
}

function RegNo_keydown(e) {
	var key=websys_getKey(e);
	if ( 13==key) {
		BFind_Click();
	}
}

function Name_keydown(e) {
	var key=websys_getKey(e);
	if ( 13==key) {
		BFind_Click();
	}
}

function GetOrderDetailRowId(value)	
{
    
	var OrderDetail=value.split("^");
	var obj=document.getElementById('OrderDetailRowId');
	obj.value=OrderDetail[9];		
}
function GetGroupID(value)
{
	if ("^^"==value) { return false; }
	var aiList=value.split("^");
    obj=document.getElementById("GroupDR");
	if (obj) { obj.value=aiList[0]; }
	
	obj=document.getElementById("Group");
	if (obj) { obj.value=aiList[1]; }
	
}
function AfterTeamSelected(value)
{
	if (""==value){return false}
	
	var aiList=value.split("^");
	obj=document.getElementById("TeamID");
	if (obj) { obj.value=aiList[1]; }
	
	obj=document.getElementById("Team");
	if (obj) { obj.value=aiList[0]; }	
}


function GetStationRowId(value)	
{

	var Station=value.split("^");
	var obj=document.getElementById('StationRowId');
	obj.value=Station[1];

}


function AddDiagnosis(value)	
{
   
	var Diagnosis=value.split("^");
	obj=document.getElementById("HighDiagnosisID");
	if (obj) { obj.value=Diagnosis[0]; }
	
	obj=document.getElementById("HighDiagnosis");
	if (obj) { obj.value=Diagnosis[1]; }	

}
function BFind_Click() {
	
	var obj;
	var iRegNo="",iName="",iPEDateFrom="",iPEDateTo="",iGroup="",iGroupDR="",iTeam="", iTeamID="";
    var iStation="",iStationRowId="",iDetail="",iOrderDetailRowId="",iHighDiagnosisID="";
	

	obj=document.getElementById("RegNo");
	if (obj){ 
		iRegNo=obj.value;
	    if (iRegNo!=""){iRegNo=RegNoMask(iRegNo); }
	}

	obj=document.getElementById("Name");
	if (obj){ iName=obj.value; }

	obj=document.getElementById("DateBegin");
	if (obj){ iPEDateFrom=obj.value; }

	obj=document.getElementById("DateEnd");
	if (obj){ iPEDateTo=obj.value; }	

	obj=document.getElementById("GroupDR");
	if (obj) {iGroupDR=obj.value;}
	obj=document.getElementById("Group");
	if (obj) {iGroup=obj.value;}
	obj=document.getElementById("TeamID");
	if (obj) {iTeamID=obj.value;}
	obj=document.getElementById("Team");
	if (obj) {iTeam=obj.value;}
	obj=document.getElementById("Station");
	if (obj) iStation=obj.value;
	obj=document.getElementById("StationRowId");
	if (obj) {iStationRowId=obj.value;}
	obj=document.getElementById("Detail");
	if (obj) {iDetail=obj.value;}
	obj=document.getElementById("OrderDetailRowId");
	if (obj) {iOrderDetailRowId=obj.value;}
	obj=document.getElementById("HighDiagnosisID");
	if (obj) {iHighDiagnosisID=obj.value;}
	
	obj=document.getElementById("HighDiagnosis");
	if (obj) {iHighDiagnosis=obj.value;}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEHighRiskFind"
			+"&RegNo="+iRegNo
			+"&Name="+iName
			+"&DateBegin="+iPEDateFrom
			+"&DateEnd="+iPEDateTo
			+"&GroupDR="+iGroupDR
			+"&TeamID="+iTeamID
			+"&StationRowId="+iStationRowId
			+"&OrderDetailRowId="+iOrderDetailRowId
			+"&HighDiagnosisID="+iHighDiagnosisID
			+"&Group="+iGroup
			+"&Team="+iTeam
			+"&Station="+iStation
			+"&Detail="+iDetail
			+"&HighDiagnosis="+iHighDiagnosis;

	location.href=lnk;
}
document.body.onload = BodyLoadHandler;