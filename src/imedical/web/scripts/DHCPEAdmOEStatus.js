//名称	DHCPEAdmOEStatus.js
//
//功能	
//组件	
//对象	
//创建	2007.07.30
//最后修改时间	
//最后修改人	
//完成
var ComponentRows=0;
var TFORM="";
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("GAdmList");
	if (obj) {
		obj.onchange=GAdmList_change;
		obj.onblur=GAdmList_blur;
	}
	obj=document.getElementById("Find")
	if (obj) { obj.onclick=Find_click; }
	
	var obj=document.getElementById("RegNo");
	if (obj) obj.onkeydown=KeyDown_Find;
	
	ComponentRows=GetCompoentRows("DHCPEAdmOEStatus");
	SetSort("tDHCPEAdmOEStatus","AOQ_Sort",ComponentRows)
	iniForm();
	Muilt_LookUp('GAdmList');	
}

function iniForm(){
	var obj
	obj=document.getElementById("AOS_Status");
	if (obj && ''!=obj.value){ SetStatus(obj.value); }
	
	return;
	obj=document.getElementById("DateBegin");
	if (obj){
		obj.value='t';
		DateBegin_lookupSelect();
	}
	
	obj=document.getElementById("DateEnd");
	if (obj){
		obj.value='t';
		DateEnd_lookuphandler();
	}

		
	
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];

}

function KeyDown_Find(e)
{
	var Key=websys_getKey(e);
	if ((9==Key)||(13==Key)) {
		Find_click();
	}
}
function Find_click(){
	var obj;
	var iRegNo='', iName='', iGAdmListDR='', iAdmDate='', iStatus=''
		, iGAdmList=''
		;
	obj=document.getElementById("RegNo");
	if (obj) { 
				iRegNo=obj.value;
				if (iRegNo.length<8 && iRegNo.length>0) { iRegNo=RegNoMask(iRegNo);}
	 
	 }
	obj=document.getElementById("Name");
	if (obj) { iName=obj.value; }
	obj=document.getElementById("GAdmListDR");
	if (obj) { iGAdmListDR=obj.value; }	
	obj=document.getElementById("GAdmList");
	if (obj) { iGAdmList=obj.value; }	
	obj=document.getElementById("AdmDate");
	if (obj) { iAdmDate=obj.value; }
	iStatus=GetStatus()
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT='+'DHCPEAdmOEStatus'
			+"&RegNo="+iRegNo
			+"&Name="+iName
			+"&GAdmListDR="+iGAdmListDR
			+"&GAdmList="+iGAdmList
			+"&AdmDate="+iAdmDate
			+"&Status="+iStatus
			;
	location.href=lnk;			
}
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
function GetStatus() {
	var iStatus='';
	obj=document.getElementById("AOS_Audit");
	if (obj && obj.checked) { iStatus=iStatus+'已总检'+'^'; }
	obj=document.getElementById("AOS_Completed");
	if (obj && obj.checked) { iStatus=iStatus+'需补检'+'^'; }
	obj=document.getElementById("AOS_NoCompleted");
	if (obj && obj.checked) { iStatus=iStatus+'未检'+'^'; }
	obj=document.getElementById("AOS_NoAudit");
	if (obj && obj.checked) { iStatus=iStatus+'未总检'+'^'; }	
	if (""!=iStatus) { iStatus='^'+iStatus; }
	return iStatus;
}

function SetStatus(value) {
	var iStatus=value;
	//条件 已总检
	var obj=document.getElementById("AOS_Audit");
	if (obj && iStatus.indexOf("^已总检^")>-1) { obj.checked=true; }
	else{ obj.checked=false; }
	
	//条件 需补检
	obj=document.getElementById("AOS_Completed");
	if (obj && iStatus.indexOf("^需补检^")>-1) { obj.checked=true; }
	else{ obj.checked=false; }

	//条件 未检
 	obj=document.getElementById("AOS_NoCompleted");
	if (obj && iStatus.indexOf("^未检^")>-1) { obj.checked=true; }
	else{ obj.checked=false; }
	
	//条件 未总检
 	obj=document.getElementById("AOS_NoAudit");
	if (obj && iStatus.indexOf("^未总检^")>-1) { obj.checked=true; }
	else{ obj.checked=false; }
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////

function GetGTAdmList(value){
	var aiList=value.split("^");
	if (""==value){return false;}

	var obj;
	obj=document.getElementById("GTAdmList");
	if (obj) { obj.value=aiList[4]; }
	
	obj=document.getElementById("GTAdmListDR");
	if (obj) { obj.value=aiList[1]; }
}


function GAdmList_blur() {
		return;
		var obj;
		//obj=document.getElementById('LocDesc_change');
		//if (obj && ""==obj.value) {
			obj=document.getElementById('GAdmList');
			if (obj) { obj.value=""; }
		//}
		//else { return false; }
}

function GAdmList_change() {

	var obj;

	obj=document.getElementById('GAdmListDR');
	if (obj) { obj.value="";}
}

function GTAdmList_blur() {
	return;
	var obj;
	obj=document.getElementById('GTAdmList');
	if (obj && ""==obj.value) {
		obj=document.getElementById('GTAdmListDR');
		if (obj) { obj.value=""; }
	}
	else { return false; }
}

function GTAdmList_change() {
		var obj;
		obj=document.getElementById('GTAdmListDR');
		if (obj) { obj.value=""; }
}

function GetGAdmList(value){
	var aiList=value.split("^");
	if (""==value){return false;}

	obj=document.getElementById("GAdmList");
	if (obj) { obj.value=aiList[1]; }
	
	obj=document.getElementById("GAdmListDR");
	if (obj) { obj.value=aiList[0]; }
}

function SetSort(TableName,ElementName,RowsOfPages)
{  
	var obj=document.getElementsByTagName("SMALL");
	var Page=1
	if(obj[0]) Page=obj[0].innerText;
	var AddRows=(+Page-1)*RowsOfPages
	//var obj=document.getElementById("GetInd")
	// if (obj){var encmeth=obj.value;}
	//else{return 0;}
	//var ind=cspRunServerMethod(encmeth)
	var obj=document.getElementById(TableName);	
	if (obj) { var rows=obj.rows.length; }
	var obj=document.getElementById("GetRow")
	if (obj){var encmethobj=obj.value;}
	else{return 0;}
	var row=cspRunServerMethod(encmethobj)
	for(var i=1;i<=Page;i++)
	{       
		if (i==1)
		{
			var ROW=parseInt(row)+1
			for (var j=ROW;j<=rows;j++)
			{  
				var obj=document.getElementById(ElementName+"z"+j)
				if (obj) obj.innerText=AddRows+(j-ROW+1)
	   		}
	  	}
		if (i>1) 
		{
	  		for (var j=1;j<=rows;j++)
			{  
  				var obj=document.getElementById(ElementName+"z"+j)
				if (obj) obj.innerText=(AddRows-ROW+1)+(+j)
			}
		}
	}	
}
function GetCompoentRows(ComponentName)
{
	var obj=document.getElementById("GetRowsClass");
		
	if (obj)
	{
		var encmeth=obj.value;
	}
	else
	{
		return 0;
	}
	var ComponentRows=cspRunServerMethod(encmeth,session['CONTEXT'],ComponentName)
	if (ComponentRows=="") ComponentRows=25;
	
	return ComponentRows
}
document.body.onload = BodyLoadHandler;