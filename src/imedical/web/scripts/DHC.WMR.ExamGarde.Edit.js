/* =========================================================================
/By ZF 2007-09-05
============================================================================ */
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_Up="^";
var CHR_Tilted="/";

function BodyLoadHandler()
{
	document.getElementById("cmdUpdate").onclick=Update_onclick;
	Inform();
}
function Inform()
{
	var GardeRowid="";
	var objGarde=document.getElementById("GardeRowid");
	if (objGarde)
	{
		GardeRowid=objGarde.value;
		if (GardeRowid==""){return;}
		var strMethod = document.getElementById("MethodGetGarde").value;
		var ret = cspRunServerMethod(strMethod,GardeRowid);
		if (ret!==""){
			var tmpList=ret.split("^");
			document.getElementById("GardeRowid").value=tmpList[0];
			document.getElementById("txtTitle").value=tmpList[1];
			document.getElementById("txtMinScore").value=tmpList[2];
			if (tmpList[3]=="Yes"){document.getElementById("chkIsActive").checked=true;}
			else{document.getElementById("chkIsActive").checked=false;}
			document.getElementById("txtResume").value=tmpList[4];
			document.getElementById("txtMoney").value=tmpList[5];
		}
	}
}

function Update_onclick()
{
	var cRuleRowid="",cGardeSub="",cTitle="",cMinScore="",cMoney="",cIsActive="",cResume="";
	var objRule=document.getElementById("RuleRowid");
	if (objRule){cRuleRowid=Trim(objRule.value);}
	var objGarde=document.getElementById("GardeRowid");
	if (objGarde){
		var tmpRowid=Trim(objGarde.value);
		if (tmpRowid!==""){
			var tmpList=tmpRowid.split("||");
			cRuleRowid=tmpList[0];
			cGardeSub=tmpList[1];
		}
	}
	
	if (cRuleRowid==""){
		alert(t['Link Error']);
		return;
	}
	
	var objTitle=document.getElementById("txtTitle");
	if (objTitle){
		cTitle=Trim(objTitle.value);
		if (cTitle==""){
			alert(t['Title']);
			objTitle.focus;
			return;
		}
	}
	
	var objMinScore=document.getElementById("txtMinScore");
	if (objMinScore){
		cMinScore=Trim(objMinScore.value);
		if (cMinScore==""){
			alert(t['MinScore']);
			objMinScore.focus;
			return;
		}
	}
	
	var objMoney=document.getElementById("txtMoney");
	if (objMoney){
		cMoney=Trim(objMoney.value);
		if (cMoney==""){
			alert(t['Money']);
			objMoney.focus;
			return;
		}
	}
	
	var objIsActive=document.getElementById("chkIsActive");
	if (objIsActive){
		if (objIsActive.checked==true){cIsActive="Y"}
		else{cIsActive="N"}
	}
	var objResume=document.getElementById("txtResume");
	if (objResume){cResume=Trim(objResume.value);}
	
	var InString=cRuleRowid+"^"+cGardeSub+"^"+cTitle+"^"+cMinScore+"^"+cIsActive+"^"+cResume+"^"+cMoney;
	var strMethod = document.getElementById("MethodUpdateGarde").value;
	var ret = cspRunServerMethod(strMethod,InString);
	if (ret<0){
		alert(t['UpdateFalse']);
		return;
	}else{
		alert(t['UpdateTrue']);
		window.close();
		//window.opener.location.reload();
		//parent.location.reload();
	}
}

document.body.onload = BodyLoadHandler;

	function LTrim(str){
		var i;
		for(i=0;i < str.length; i ++)
		{
			 if(str.charAt(i)!=" "&&str.charAt(i)!=" ") 
				break;
		}
		str = str.substring(i,str.length);
		return str;
	}
	
	function RTrim(str){
		var i;
		for(i = str.length - 1; i>=0; i--)
		{
			if(str.charAt(i)!=" "&&str.charAt(i)!=" ") 
				break;
		}
		str = str.substring(0,i+1);
		return str;
	}
	
	function Trim(str){
		return LTrim(RTrim(str));
	} 