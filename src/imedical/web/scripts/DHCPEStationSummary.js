/// FileName:	DHCPhyExamStationSummary.JS 
/// Description: add function PermissonSetting
/// -------------------

function InitMe()	{
	var SummaryForm=document.forms['fDHCPEStationSummary'];
	if (SummaryForm) {
		var Update=SummaryForm.all['Update'];
		var Create=SummaryForm.all['Create'];
		var Audit=SummaryForm.all['Audit'];
		if (Update) {Update.onclick=Update_Click;}
		if (Create) {Create.onclick=Create_Click;}
		if (Audit) {Audit.onclick=Audit_Click;}
	}
	var permision=PermissonSetting();
	if (permision=="W"){
		MsgDietInfo();
	}
	
}
function Update_Click()	{
	var UpdateMothod=document.getElementById("SetStationSummary");
	var Summary=document.getElementById("Summary");
	var EpisodeIDobj=document.getElementById("EpisodeID");
	if (EpisodeIDobj) var EpisodeID=EpisodeIDobj.value;
	var ChartIDobj=document.getElementById("ChartID");
	if (ChartIDobj) var ChartID=ChartIDobj.value;
	if (UpdateMothod) {var encmeth=UpdateMothod.value} else {var encmeth=''}
	var UpdateCode=cspRunServerMethod(encmeth,EpisodeID,ChartID,Summary.value);
	if (UpdateCode=='0') {alert(t['UpdateFailure']);}
	else if(UpdateCode=="GeneralAdviceAudited")
	{
		alert(t[UpdateCode]);
	}
	else {alert(t['UpdateSuccessful']);}
	return false;
}
function Create_Click()	{
	var GenMothod=document.getElementById("GenStationSummary");
	var Summary=document.getElementById("Summary");
	var EpisodeIDobj=document.getElementById("EpisodeID");
	if (EpisodeIDobj) var EpisodeID=EpisodeIDobj.value;
	var ChartIDobj=document.getElementById("ChartID");
	if (ChartIDobj) var ChartID=ChartIDobj.value;
	if (GenMothod) {var encmeth=GenMothod.value} else {var encmeth=''}
	var GenMothodStr=cspRunServerMethod(encmeth,EpisodeID,ChartID);
	if (GenMothodStr==0) //没有检查项目
	{
		alert(t["NoItem"]);
		return false;
	}
	if (GenMothodStr==2) //还有未执行项目
	{
		alert(t["NoApp"]);
		return false;
	}
	if (GenMothodStr.length==0) {
		alert(t['NoSummary']);
		return false;
	}
	if (GenMothodStr=="未见异常") {
		//alert(t['NoSummary']);
		Summary.value=GenMothodStr;
		return false;
	}
	var ArrSummaryStr=GenMothodStr.split('\001');
	for (var i=0; i<ArrSummaryStr.length; i++) {
		var SummaryStr=ArrSummaryStr[i].split("^");
		ArrSummaryStr[i]=SummaryStr[1];
	}
	var SummaryStr=ArrSummaryStr.join('\015\012');
	if (Summary) {Summary.value=SummaryStr;}
	return false;
}

//return: "R"-Read, "W"-write.
function PermissonSetting(){
	var UserId, PAAdmId, ChartId, SvrMethod
	
	var TblObj=document.getElementById('tDHCPhysicalExam_Station');	
	if (!(TblObj)) DAlert("ERRor: control tDHCPhysicalExam.Station is not exist");
		
	if (TblObj.rows.length<=1) {
		DisabledCtls("a",true);
		return "R";
	}
	
	UserId=session['LOGON.USERID'];
	PAAdmId=GetCtlValueById("EpisodeID", 1)
	ChartId=GetCtlValueById("ChartID", 1)
	SvrMethod=GetCtlValueById("methodResultPermission", 1)
	
	var MyPermission=cspRunServerMethod(SvrMethod,UserId, PAAdmId, 0, ChartId)
	if ((MyPermission=="R")||(MyPermission=="")){
		DisabledCtls("A",true);
		DisabledCtls("input",true);
		DisabledCtls("select",true);
		return "R";
	}
	return "W";
	
}

function MsgDietInfo(){
	var myWarnings="";
	var oneWarning="";
	var TblObj=document.getElementById('tDHCPhysicalExam_Station');	
	for(var j=1;j<(TblObj.rows.length-1);j++){
		oneWarning=GetCtlValueById('DietWarningz'+j);
		if (oneWarning!=""){
			myWarnings=myWarnings + '\n'+ oneWarning;
		}
	}
	if (myWarnings!=""){
		alert(myWarnings);
	}
}

function Audit_Click()	{
	DAlert("ented Audit_Click!");
	PAAdmId=GetCtlValueById("EpisodeID", 1)
	ChartId=GetCtlValueById("ChartID", 1)
	SvrMethod=GetCtlValueById("methodAudit", 1)

	var UpdateCode=cspRunServerMethod(SvrMethod,PAAdmId,ChartId);
	if (UpdateCode=='0') {alert(t['AuditFailure']);}
	else  {alert(t['AuditSuccessful']);}
	location.reload();
	//return false;
}
 

function MyOnLoad(){
	DAlert("myONLoad");
	 PermissonSetting();
}

document.body.onload = MyOnLoad;