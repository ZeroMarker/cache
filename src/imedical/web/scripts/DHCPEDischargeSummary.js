
function InitMe()	{
	var SummaryForm=document.forms['fDHCPEDischargeSummary'];
	if (SummaryForm) {
		var Update=SummaryForm.all['Update'];
		var GeneSummary=SummaryForm.all['GeneSummary'];
		var GeneRecomm=SummaryForm.all['GeneRecomm'];
		var GeneralAudit=SummaryForm.all['GeneralAudit'];
		if (Update) {Update.onclick=Update_Click;}
		if (GeneSummary) {GeneSummary.onclick=GeneSummary_Click;}
		if (GeneRecomm) {GeneRecomm.onclick=GeneRecomm_Click;}
		if (GeneralAudit) {GeneralAudit.onclick=GeneralAudit_Click;}
	}
	PermissonSetting();
}

function Update_Click()	{
	var SaveAdmGeneralSummary=document.getElementById("SaveAdmGeneralSummary");
	var SaveAdmGeneralRecommend=document.getElementById("SaveAdmGeneralRecommend");
	var Summary=document.getElementById("Summary");
	var Recommendation=document.getElementById("Recommendation");
	var EpisodeIDobj=document.getElementById("EpisodeID");
	if (EpisodeIDobj) var EpisodeID=EpisodeIDobj.value;
	//
	if (SaveAdmGeneralSummary) {var encmeth=SaveAdmGeneralSummary.value} else {var encmeth=''}
	var SummaryCode=cspRunServerMethod(encmeth,EpisodeID,Summary.value);
	if (SummaryCode=='0') {alert(t['Summary']+t['UpdateFailure']);}
	else if (SummaryCode=="GeneralAdviceAudited")
	{
		alert(t[SummaryCode]);
		return false;
	}
	else  {alert(t['Summary']+t['UpdateSuccessful']);}
	//
	if (SaveAdmGeneralRecommend) {var encmeth=SaveAdmGeneralRecommend.value} else {var encmeth=''}
	var RecommCode=cspRunServerMethod(encmeth,EpisodeID,Recommendation.value);
	if (RecommCode=='0') {alert(t['Recommendation']+t['UpdateFailure']);}
	else  {alert(t['Recommendation']+t['UpdateSuccessful']);}
	//
	return false;
}

function GeneSummary_Click()	{
	var GenMothod=document.getElementById("GenAdmGeneralSummary");
	var Summary=document.getElementById("Summary");
	var EpisodeIDobj=document.getElementById("EpisodeID");
	if (EpisodeIDobj) var EpisodeID=EpisodeIDobj.value;
	if (GenMothod) {var encmeth=GenMothod.value} else {var encmeth=''}
	var GenMothodStr=cspRunServerMethod(encmeth,EpisodeID);
	if (GenMothodStr.length==0) {
		alert(t['NoSummary']);
		return false;
	}
	var ArrSummaryStr=GenMothodStr.split('\001');
	for (var i=0; i<ArrSummaryStr.length; i++) {		
		var SummaryStr=ArrSummaryStr[i].split("^");
		ArrSummaryStr[i]='('+(i+1)+') '+SummaryStr[1];
	}
	var SummaryStr=ArrSummaryStr.join('\015\012');
	if (Summary) {Summary.value=SummaryStr};
	return false;
}

function GeneRecomm_Click()	{
	var GenMothod=document.getElementById("GenAdmGeneralRecomm");
	var Recommendation=document.getElementById("Recommendation");
	var EpisodeIDobj=document.getElementById("EpisodeID");
	if (EpisodeIDobj) var EpisodeID=EpisodeIDobj.value;
	if (GenMothod) {var encmeth=GenMothod.value} else {var encmeth=''}
	var GenMothodStr=cspRunServerMethod(encmeth,EpisodeID);
	if (GenMothodStr.length==0) {
		alert(t['NoRecommendation']);
		return false;
	}
	//alert(GenMothodStr);
	
	var ArrRecommStr=GenMothodStr.split('\001');	
	for (var i=0; i<ArrRecommStr.length; i++) {		
		var RecommStr=ArrRecommStr[i].split("^");
		ArrRecommStr[i]='('+(i+1)+') '+RecommStr[0]+'\015\012';
		ArrRecommStr[i]=ArrRecommStr[i]+'       '+RecommStr[1]
	}
	var RecommendationStr=ArrRecommStr.join('\015\012');
	if (Recommendation) {Recommendation.value=RecommendationStr};
	return false;
}

function GeneralAudit_Click()	{
	var GeneralAudit=document.getElementById("GeneralAuditBox");
	var EpisodeIDobj=document.getElementById("EpisodeID");
	if (EpisodeIDobj) var EpisodeID=EpisodeIDobj.value;
	//
	//alert("EpisodeID:"+EpisodeID);
	
	//return false
	if (GeneralAudit) {var encmeth=GeneralAudit.value} else {var encmeth=''}
	//alert("encmeth:"+encmeth);
	//return false;
	var GeneralAuditCode=cspRunServerMethod(encmeth,EpisodeID);
	//alert(GeneralAuditCode);
	if (GeneralAuditCode=='0') {
		//alert(t['GeneralAuditSuccessful']);
		alert("审核成功!");
		}
	else if (GeneralAuditCode=='2') {
		
		//alert(t['GeneralAuditFailure']);
		alert("还有未完成的检查项目!");
		}
	else if (GeneralAuditCode=='1') {
		
		//alert(t['GeneralAuditFailure']);
		alert("没有检查项目!");
		}
	else{
		alert("审核不成功!");}
	
	return false;
}

function PermissonSetting(){
	var UserId, PAAdmId, ChartId, SvrMethod
	DAlert("ented PermissonSetting");
	
	UserId=session['LOGON.USERID'];
	PAAdmId=GetCtlValueById("EpisodeID", 1)
	ChartId=GetCtlValueById("ChartID", 1)
	SvrMethod=GetCtlValueById("methodResultPermission", 1)
	
	var MyPermission=cspRunServerMethod(SvrMethod,UserId, PAAdmId, 1, ChartId)
	//if ((MyPermission=="R")||(MyPermission=="")){   //Modified by MLH 0720有bug暂时注释?需要修改
	//	DisabledCtls("a",true);
	//}
	MyError();	
	var i=0;
}
