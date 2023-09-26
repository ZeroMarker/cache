/// 
//名称	DHCPEStationWorkStatisticYY.js
//组件	
//对象	
//创建	2008.07.22


var TFORM="";
function BodyLoadHandler() {
	var obj;

	obj=document.getElementById("STDesc");
	if (obj) {
		obj.onchange=STDesc_change;
		obj.onblur=STDesc_blur;
	}
	
	obj=document.getElementById("OEItemDesc");
	if (obj) {
		obj.onchange=OEItemDesc_change;
		obj.onblur=OEItemDesc_blur;
	}
	
	obj=document.getElementById("DateType_A");
	if (obj) { obj.onclick=DateType_click; }
	
	obj=document.getElementById("DateType_E");
	if (obj) { obj.onclick=DateType_click; }
	
	//obj=document.getElementById("BFind");
	//if (obj) { obj.onclick=Query_Click; }
	
	iniForm();
	
	obj=document.getElementById('STDesc');
	if (obj && ""==obj.value) { 
		obj=document.getElementById('STDR');
		if (obj) { obj.value="";   }
	}
}

function iniForm(){
	var obj
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


function GetOEItem(value){
	var aiList=value.split("^");
	if (""==value){return false;}

	obj=document.getElementById("OEItemDesc");
	if (obj) { obj.value=aiList[1]; }
	
	obj=document.getElementById("OEItemDR");
	if (obj) { obj.value=aiList[2]; }
}

function GetStation(value){
	var aiList=value.split("^");
	if (""==value){return false;}

	obj=document.getElementById("STDesc");
	if (obj) { obj.value=aiList[0]; }
	
	obj=document.getElementById("STDR");
	if (obj) { obj.value=aiList[1]; }
}

//登记号
function RegNo_keydown(e) {

	var key=websys_getKey(e);
	if ( 13==key) {
		RegNoOnChange();
	}
}

function STDesc_blur() {
	
	var obj;
	obj=document.getElementById('STDesc');
	if (obj && ""==obj.value) { 
		obj=document.getElementById('STDR');
		if (obj) { obj.value="";   }
	}
	else { return false; }
}
	
function STDesc_change() {
   
	var obj;
	obj=document.getElementById('STDesc');
	if (obj && ""==obj.value) { 
		obj=document.getElementById('STDR');
		if (obj) { obj.value="";   }
	}
	else { return false; }
}


function OEItemDesc_blur() {
	return
	var obj;
	obj=document.getElementById('OEItemDesc');
	if (obj && ""==obj.value) {
		obj=document.getElementById('OEItemDR');
		if (obj) { obj.value=""; }
	}
	else { return false; }
}

function OEItemDesc_change() {
		var obj;
		obj=document.getElementById('OEItemDR');
		if (obj) { obj.value=""; }
}

function DateType_click() {
	
	var src=window.event.srcElement;
	obj=document.getElementById('DateType_A');
	if (obj && obj.id!=src.id) { obj.checked=false; }
	obj=document.getElementById('DateType_E');
	if (obj && obj.id!=src.id) { obj.checked=false; }
	
	var srcId=src.id.split('_');
	obj=document.getElementById('DType');
	if (obj) { obj.value=srcId[1]; }
}
function Query_Click(){
	var iSTDR='',iOEItemDR=''
		,iDateBegin='',iDateEnd=''
		,iDType=''
		;
	var obj;
	obj=document.getElementById('STDR');
	if (obj) { iSTDR=obj.value; }
	
	obj=document.getElementById('OEItemDR');
	if (obj) { iOEItemDR=obj.value; }
	
	obj=document.getElementById('DateBegin');
	if (obj) { iDateBegin=obj.value; }
	
	obj=document.getElementById('DateEnd');
	if (obj) { iDateEnd=obj.value; }
	
	obj=document.getElementById('DType');
	if (obj) { iDType=obj.value; }
	if ((''==iDateEnd)||(''==iDateBegin)) {
		alert(t['Err 01']);
		return false;
	}
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT='+'DHCPEStationWorkStatisticYY'
			+"&STDR="+iSTDR
			+"&OEItemDR="+iOEItemDR
			+"&DateBegin="+iDateBegin
			+"&DateEnd="+iDateEnd
			+"&DType="+iDType
			;
	location.href=lnk;				
}

document.body.onload = BodyLoadHandler;