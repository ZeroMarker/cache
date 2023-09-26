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
	
	iniForm();
	Muilt_LookUp('GAdmList');	
}

function iniForm(){

	var Status=getValueById("Status");
	if (""!=Status){ SetStatus(Status); }	
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
	var iRegNo='', iName='', iGAdmListDR='', iAdmDate='', iStatus='', iGAdmList='';
	
	iRegNo=getValueById("RegNo");
	if (iRegNo.length<8&&iRegNo.length>0) { iRegNo=RegNoMask(iRegNo);}	
	
	iName=getValueById("Name");
	
	iGAdmListDR=getValueById("GAdmListDR");
	
	iGAdmList=getValueById("GAdmList");
	
	iAdmDate=getValueById("AdmDate");

	iStatus=GetStatus()
	var lnk='websys.default.hisui.csp?WEBSYS.TCOMPONENT='+'DHCPEAdmOEStatus'
			+"&RegNo="+iRegNo
			+"&Name="+iName
			+"&GAdmListDR="+iGAdmListDR
			+"&GAdmList="+iGAdmList
			+"&AdmDate="+iAdmDate
			+"&Status="+iStatus
			;
			//messageShow("","","",lnk)
	location.href=lnk;			
}

function GetStatus() {
	var iStatus='';
	Status=getValueById("AOS_Audit");
	if(Status!="") { iStatus=iStatus+'^'+'已总检'+'^';} 
	
	Status=getValueById("AOS_Completed");
	if(Status!="") { iStatus=iStatus+'^'+'需补检'+'^';} 
	
	Status=getValueById("AOS_NoCompleted");
	if(Status!="") { iStatus=iStatus+'^'+'未检'+'^';} 
	
	Status=getValueById("AOS_NoAudit");
	if(Status!="") { iStatus=iStatus+'^'+'未总检'+'^';} 
	
	return iStatus;
}

function SetStatus(value) {
	var iStatus=value;

	if (iStatus.indexOf("^已总检^")>-1) {SetChkElement("AOS_Audit",1);}
	
	if (iStatus.indexOf("^需补检^")>-1) {SetChkElement("AOS_Completed",1);}
	
	if (iStatus.indexOf("^未检^")>-1) {SetChkElement("AOS_NoCompleted",1);}
	
	if (iStatus.indexOf("^未总检^")>-1) {SetChkElement("AOS_NoAudit",1);}
   
	
}


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
		
		    var obj;
			obj=document.getElementById('GAdmList');
			if (obj) { obj.value=""; }
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


document.body.onload = BodyLoadHandler;