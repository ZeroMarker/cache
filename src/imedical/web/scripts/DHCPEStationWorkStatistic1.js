/// 
//名称	DHCPEStationWorkStatistic.js
//功能	科室(每月)统计
//组件	
//对象	
//创建	2007.07.03
//最后修改时间	
//最后修改人	
//完成

var TFORM="";
function BodyLoadHandler() {
	var obj;

	obj=document.getElementById("LocDesc");
	if (obj) {
		obj.onchange=LocDesc_change;
		obj.onblur=LocDesc_blur;
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

function GetLoc(value){
	var aiList=value.split("^");
	if (""==value){return false;}

	obj=document.getElementById("LocDesc");
	if (obj) { obj.value=aiList[1]; }
	
	obj=document.getElementById("LocDR");
	if (obj) { obj.value=aiList[2]; }
}

//登记号
function RegNo_keydown(e) {

	var key=websys_getKey(e);
	if ( 13==key) {
		RegNoOnChange();
	}
}

function LocDesc_blur() {
		return;
		var obj;
		//obj=document.getElementById('LocDesc_change');
		//if (obj && ""==obj.value) {
			obj=document.getElementById('LocDR');
			if (obj) { obj.value=""; }
		//}
		//else { return false; }
}

function LocDesc_change() {

	var obj;

	obj=document.getElementById('LocDR');
	if (obj) { obj.value="";}
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
	var iLocDR='',iOEItemDR=''
		,iDateBegin='',iDateEnd=''
		,iDType=''
		;
	var obj;
	obj=document.getElementById('LocDR');
	if (obj) { iLocDR=obj.value; }
	
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
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT='+'DHCPEStationWorkStatistic'
			+"&LocDR="+iLocDR
			+"&OEItemDR="+iOEItemDR
			+"&DateBegin="+iDateBegin
			+"&DateEnd="+iDateEnd
			+"&DType="+iDType
			;
	location.href=lnk;				
}

document.body.onload = BodyLoadHandler;