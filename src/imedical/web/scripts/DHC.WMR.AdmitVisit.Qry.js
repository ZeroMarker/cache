var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_3=String.fromCharCode(3);
var CHR_Up="^";
var CHR_Tilted="/";

var tmpChinese;
function GetChinese(MethodName,Ind)
{
	var strMethod = document.getElementById(MethodName).value;
	var ret = cspRunServerMethod(strMethod,Ind);
	var tmp=ret.split("^");
	return tmp;
}
tmpChinese=GetChinese("MethodGetChinese","DHC.WMR.AdmitVisit.Qry");
//alert(tmpChinese[0]+tmpChinese[1]);

function initForm()
{
	var obj=document.getElementById("DateType");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		
		obj.length=0;
		var objItm=document.createElement("OPTION");
		obj.options.add(objItm);
		objItm.innerText =tmpChinese[0];
		objItm.value = 1;
		var objItm=document.createElement("OPTION");
		obj.options.add(objItm);
		objItm.innerText =tmpChinese[1];
		objItm.value = 2;
		
		obj.selectedIndex=0;
	}
}

function LookUpDep(str)
{
	var objRowid=document.getElementById('AdmDepRowid');
	var objDesc=document.getElementById('AdmDep');
	objRowid.value="";
	objDesc.value="";
	if (str!==""){
		var tem=str.split("^");
		objRowid.value=tem[0];
		objDesc.value=tem[1];
	}
}

function LookUpWard(str)
{
	var objRowid=document.getElementById('AdmWardRowid');
	var objDesc=document.getElementById('AdmWard');
	objRowid.value="";
	objDesc.value="";
	if (str!==""){
		var tem=str.split("^");
		objRowid.value=tem[0];
		objDesc.value=tem[1];
	}
}

function Query_onclick()
{
	var cDateFrom="",cDateTo="",cDateType="",cRegNo="",cPatName="",cDep="",cDepRowid="",cWard="",cWardRowid="";
	cDateFrom=document.getElementById("DateFrom").value;
	cDateTo=document.getElementById("DateTo").value;
	var obj=document.getElementById("DateType");
	if (obj) {
		if (obj.selectedIndex<0){return;}
		cDateType=obj.options[obj.selectedIndex].value;
		if (cDateType==""){return;}
	}
	cRegNo=Trim(document.getElementById("RegNo").value);
	cPatName=Trim(document.getElementById("PatName").value);
	cDepRowid=Trim(document.getElementById("AdmDepRowid").value);
	cDep=Trim(document.getElementById("AdmDep").value);
	if (cDep==""){cDepRowid=""}
	cWardRowid=Trim(document.getElementById("AdmWardRowid").value);
	cWard=Trim(document.getElementById("AdmWard").value);
	if (cWard==""){cWardRowid=""}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.AdmitVisit.List" + "&DateFrom=" +cDateFrom+"&DateTo="+cDateTo+"&DateType="+cDateType+"&RegNo="+cRegNo+"&PatName="+cPatName+"&Dep="+cDepRowid+"&Ward="+cWardRowid;
    parent.frames[1].location.href=lnk;
}

function initEvent()
{
	document.getElementById("cmdQuery").onclick=Query_onclick;
	document.getElementById("RegNo").onkeydown=Query_onkeydown;
	document.getElementById("PatName").onkeydown=Query_onkeydown;
	initForm();
}

function Query_onkeydown()
{
	if (window.event.keyCode!==13){return;}
	Query_onclick();
}

initEvent();

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