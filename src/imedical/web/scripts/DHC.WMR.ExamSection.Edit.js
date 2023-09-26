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
	document.getElementById("txtPos").onblur=txtPos_onblur;
	Inform();
}
function Inform()
{
	var SectionRowid="";
	var objSection=document.getElementById("SectionRowid");
	if (objSection)
	{
		SectionRowid=objSection.value;
		if (SectionRowid==""){return;}
		var strMethod = document.getElementById("MethodGetSectionById").value;
		var ret = cspRunServerMethod(strMethod,SectionRowid);
		if (ret==""){return;
		}else{
			var tmpList=ret.split(CHR_2);
			var tmpSubList1=tmpList[0].split("^");
			var tmpSubList2=tmpList[1].split("^");
			document.getElementById("SectionRowid").value=tmpSubList1[0];
			document.getElementById("txtDicSectionRowid").value=tmpSubList1[1];
			document.getElementById("txtDicSection").value=tmpSubList2[2];
			document.getElementById("txtScore").value=tmpSubList1[2];
			document.getElementById("txtPos").value=tmpSubList1[3];
			if (tmpSubList1[4]=="Yes"){
				document.getElementById("chkIsActive").checked=true;
			}else{
				document.getElementById("chkIsActive").checked=false;
			}
			document.getElementById("txtResume").value=tmpSubList1[5];
		}
	}
}

function txtPos_onblur()
{
	var cPos="",cRuleRowid="",cSectionSub="";

	var objRule=document.getElementById("RuleRowid");
	if (objRule){cRuleRowid=Trim(objRule.value);}
	var objSection=document.getElementById("SectionRowid");
	if (objSection){
		var tmpRowid=Trim(objSection.value);
		if (tmpRowid!==""){
			var tmpList=tmpRowid.split("||");
			cRuleRowid=tmpList[0];
			cSectionSub=tmpList[1];
		}
	}
	
	var objPos=document.getElementById("txtPos");
	if (objPos){cPos=Trim(objPos.value);}
	
	if ((cRuleRowid=="")||(cPos=="")) return;
	var InString=cRuleRowid+"^"+cSectionSub+"^"+cPos;
	var strMethod = document.getElementById("MethodCheckSecPos").value;
	var ret = cspRunServerMethod(strMethod,InString);
	if (ret<0){
		alert(t["Pos"]);
		return;
	}
}

function Update_onclick()
{
	var cRuleRowid="",cSectionSub="",cDicSection="",cScore="",cPos="",cIsActive="",cResume="";
	
	var objRuleRowid=document.getElementById("RuleRowid");
	if (objRuleRowid){cRuleRowid=Trim(objRuleRowid.value);}
	var objSectionRowid=document.getElementById("SectionRowid");
	if (objSectionRowid){
		var cSectionRowid=Trim(objSectionRowid.value);
		if (cSectionRowid==""){
			//
		}else{
			var tmpList=cSectionRowid.split("||");
			cRuleRowid=tmpList[0];
			cSectionSub=tmpList[1];
		}
	}
	if (cRuleRowid==""){
		alert(t['RuleRowidNull']);
		return;
	}
	
	var objDicSecRowid=document.getElementById("txtDicSectionRowid");
	var objDicSec=document.getElementById("txtDicSection");
	if (objDicSecRowid){
		cDicSection=Trim(objDicSecRowid.value);
		if (cDicSection==""){
			objDicSec.value="";
			objDicSecRowid.value="";
			alert(t['Section']);
			objDicSec.focus;
			return;
		}
	}
	var objScore=document.getElementById("txtScore");
	if (objScore){
		cScore=Trim(objScore.value);
		if (cScore==""){
			alert(t['Score']);
			objScore.focus;
			return;
		}
	}
	var objPos=document.getElementById("txtPos");
	if (objPos){
		cPos=Trim(objPos.value);
		if (cPos==""){
			alert(t['Pos']);
			objPos.focus;
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
	
	var InString=cRuleRowid+"^"+cSectionSub+"^"+cDicSection+"^"+cScore+"^"+cPos+"^"+cIsActive+"^"+cResume;
	var strMethod = document.getElementById("MethodUpdateSection").value;
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

function LookUpSection(str)
{
	var tmpList=str.split("^");
	var objSecRowid=document.getElementById('txtDicSectionRowid');
	if (objSecRowid){objSecRowid.value=tmpList[0];}
	var objSecTitle=document.getElementById('txtDicSection');
	if (objSecTitle){objSecTitle.value=tmpList[1];}
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