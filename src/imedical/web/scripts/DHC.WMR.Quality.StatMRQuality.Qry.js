function BodyLoadHandler()
{
	var obj=document.getElementById("btnFind");
	if (obj){obj.onclick=btnFind_onclick;}
	var obj=document.getElementById("txtLocDesc");
	if (obj){obj.onchange=txtLocDesc_onchange;}
	var obj=document.getElementById("txtWardDesc");
	if (obj){obj.onchange=txtWardDesc_onchange;}
	var obj=document.getElementById("txtDocDesc");
	if (obj){obj.onchange=txtDocDesc_onchange;}
	var obj=document.getElementById("txtExamRuleDesc");
	if (obj){obj.onchange=txtExamRuleDesc_onchange;}
	//DisplayLoc();
}

function DisplayLoc()
{
	var LocRowid = session['LOGON.CTLOCID'];
	var strMethod = document.getElementById("MethodGetLoc").value;
	var ret = cspRunServerMethod(strMethod,LocRowid);
	var tmpList=ret.split("^");
	if (tmpList.length>=2)
	{
		document.getElementById("txtLocId").value=tmpList[0];
		document.getElementById("txtLocDesc").value=tmpList[2];
	}
}

function btnFind_onclick()
{
	var ExamRule="",Loc="",Ward="",Doc="",DateFrom="",DateTo="",IsDisch="";
	
	//var ExamRule=GetParam(window,"ExamRuleStr");
	var obj=document.getElementById("txtExamRuleId");
	if (obj){ExamRule=obj.value;}
	
	var obj=document.getElementById("txtFromDate");
	if (obj){DateFrom=obj.value;}
	
	var obj=document.getElementById("txtToDate");
	if (obj){DateTo=obj.value;}
	
	var obj=document.getElementById("txtLocId");
	if(obj) {Loc=obj.value;}
	
	var obj=document.getElementById("txtWardId");
	if(obj) {Ward=obj.value;}
	
	var obj=document.getElementById("txtDocId");
	if(obj) {Doc=obj.value;}
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.Quality.StatMRQuality.List" + "&ExamRule=" +  ExamRule + "&AdmLoc=" + Loc + "&AdmWard=" + Ward + "&AdmDoc=" + Doc + "&DateFrom=" + DateFrom + "&DateTo=" + DateTo;
	parent.RPbottom.location.href=lnk;
}


function txtLocDesc_onchange()
{
	if (document.getElementById("txtLocDesc").value=="")
	{
		document.getElementById("txtLocId").value="";
	}
}

function txtWardDesc_onchange()
{
	if (document.getElementById("txtWardDesc").value=="")
	{
		document.getElementById("txtWardId").value="";
	}
}

function txtDocDesc_onchange()
{
	if (document.getElementById("txtDocDesc").value=="")
	{
		document.getElementById("txtDocId").value="";
	}
}

function txtExamRuleDesc_onchange()
{
	if (document.getElementById("txtExamRuleDesc").value=="")
	{
		document.getElementById("txtExamRuleId").value="";
	}
}

function LookUpLocDesc(str)
{
	var tmpList=str.split("^");
	document.getElementById("txtLocId").value=tmpList[0];
	document.getElementById("txtLocDesc").value=tmpList[1];
}

function LookUpWardDesc(str)
{
	var tmpList=str.split("^");
	document.getElementById("txtWardId").value=tmpList[0];
	document.getElementById("txtWardDesc").value=tmpList[1];
}

function LookUpDocDesc(str)
{
	var tmpList=str.split("^");
	document.getElementById("txtDocId").value=tmpList[0];
	document.getElementById("txtDocDesc").value=tmpList[2];
}

function LookUpExamRuleDesc(str)
{
	var tmpList=str.split("^");
	document.getElementById("txtExamRuleId").value=tmpList[0];
	document.getElementById("txtExamRuleDesc").value=tmpList[2];
}
document.body.onload=BodyLoadHandler;