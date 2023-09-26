/* =========================================================================
/By ZF 2007-09-13
============================================================================ */
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_Up="^";
var CHR_Tilted="/";

function BodyLoadHandler()
{
	document.getElementById("cmdQuery").onclick=Query_onclick;
	document.getElementById("cboDicRule").onchange=DicRule_onchange;
	//document.getElementById("cboRule").onmousedown=Rule_onmousedown;
	Inform();
}
function Inform()
{
	var obj=document.getElementById("cboMrType");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.selectedIndex=0;
	}
	var obj=document.getElementById("cboDicRule");
	if (obj){
		obj.size=1;
		obj.multiple=false;
	}
	var obj=document.getElementById("cboRule");
	if (obj){
		obj.size=1;
		obj.multiple=false;
	}
	var obj=document.getElementById("cboDateType");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.selectedIndex=1;
	}	
}

function DicRule_onchange()
{
	var cDicRuleRowid="",cIsActive="";
	var objDicRule=document.getElementById("cboDicRule");
	if (objDicRule){
		var Idx=objDicRule.options.selectedIndex;
		if (Idx>-1){cDicRuleRowid=objDicRule.options[Idx].value;}
		if (cDicRuleRowid=="")return;
		var strMethod = document.getElementById("MethodGetRuleByDic").value;
		var ret = cspRunServerMethod(strMethod,cDicRuleRowid,cIsActive);
		if (ret!==""){
			var tmpList=ret.split(CHR_1);
			var objRule=document.getElementById("cboRule");
			if (objRule){
				objRule.length=0;
				for (var i=0;i<tmpList.length;i++)
				{
					tmpSubList=tmpList[i].split(CHR_2);
					if (tmpSubList[0]){
						tmpChlList=tmpSubList[0].split("^");
						var oOption = document.createElement("OPTION");
				        oOption.text=tmpChlList[9];
				        oOption.value=tmpChlList[0];
				        objRule.add(oOption);
					}
				}
				objRule.selectedIndex=0;
			}
		}
	}
}

function Query_onclick()
{
	var cRuleDicRowid="",cExamRuleRowid="",cMrType="",cDateType="";
	var cFromDate="",cToDate="",cCtloc="",cCtlocRowid="";
	
	var obj=document.getElementById("cboDicRule");
	if (obj){
		var Idx=obj.selectedIndex;
		if (Idx>-1){cRuleDicRowid=obj.options[Idx].value;}
		if (cRuleDicRowid==""){
			alert(t['DicRule']);
			return;
		}
	}
	
	var obj=document.getElementById("cboRule");
	if (obj){
		var Idx=obj.selectedIndex;
		if (Idx>-1){cExamRuleRowid=obj.options[Idx].value;}
	}
	
	var obj=document.getElementById("cboMrType");
	if (obj){
		var Idx=obj.selectedIndex;
		if (Idx>-1){cMrType=obj.options[Idx].value;}
		if (cMrType==""){
			alert(t['MrType']);
			return;
		}
	}
	
	var obj=document.getElementById("cboDateType");
	if (obj){
		var Idx=obj.selectedIndex;
		if (Idx!==-1){cDateType=obj.options[Idx].value;}
		if (cDateType==""){
			alert(t['DateType']);
			return;
		}
	}
	//cDateType="1";  //AdimtDate(PAADM_Date)
	//cDateType="2";  //DischangeDate
	//cDateType="3";  //ExamDate
	
	var obj=document.getElementById("txtFromDate");
	if (obj){cFromDate=obj.value;}
	var obj=document.getElementById("txtToDate");
	if (obj){cToDate=obj.value;}
	if ((cFromDate=="")||(cToDate=="")){
		alert(t['Date']);
		return;
	}
	
	var obj=document.getElementById("txtCtloc");
	if (obj){cCtlocDesc=obj.value;}
	var obj=document.getElementById("txtCtlocRowid");
	if (obj){cCtloc=obj.value;}
	if (cCtlocDesc==""){cCtloc="";}
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.ExamRst.List"+"&RuleDicRowid="+cRuleDicRowid+"&ExamRuleRowid="+cExamRuleRowid+"&MrType="+cMrType+"&DateType="+cDateType+"&FromDate="+cFromDate+"&ToDate="+cToDate+"&Ctloc="+cCtloc;
	parent.RPbottom.location.href=lnk;
}

function LookUpCtloc(str)
{
	var objCtlocRowid=document.getElementById('txtCtlocRowid');
	var objCtloc=document.getElementById('txtCtloc');
	var tmpList=str.split("^");
	objCtlocRowid.value=tmpList[0];
	objCtloc.value=tmpList[1];
	if (tmpList[1]){
		var tmpSubList=tmpList[1].split("-");
		if (tmpSubList[1]){objCtloc.value=tmpSubList[1];}
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