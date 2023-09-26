/// DHCEQBusinessForEvaluate.js
function BodyLoadHandler()
{		
	InitPage();
}

function InitPage()
{
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	KeyUp("Provider");
	Muilt_LookUp("Provider");
}
function BFind_Click()
{
	var	val="&ProviderDR="+GetElementValue("ProviderDR");
	val=val+"&Provider="+GetElementValue("Provider");
	val=val+"&CurRole="+GetElementValue("CurRole");
	val=val+"&EvaluateGroup="+GetElementValue("EvaluateGroup");
	val=val+"&ChkFlag=";
	if (GetChkElementValue("ChkFlag")==true)
	{
		val=val+"on";
	}
	
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBusinessForEvaluate"+val;
}
function GetProviderID(value)
{
	GetLookUpID("ProviderDR",value);
}

document.body.onload = BodyLoadHandler;