/// 
//名称	DHCPELocWorkStatisticByPAADM.js
//功能	北京中医院科室检查人次统计


var TFORM="";
function BodyLoadHandler() {
	var obj;

	obj=document.getElementById("LocDesc");
	if (obj) {
		obj.onchange=LocDesc_change;
		obj.onblur=LocDesc_blur;
	}
		
	obj=document.getElementById("DateType_A");
	if (obj) { obj.onclick=DateType_click; }
	
	obj=document.getElementById("DateType_E");
	if (obj) { obj.onclick=DateType_click; }
	
	iniForm();
	Muilt_LookUp('LocDesc'+'^'+'OEItemDesc');
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

function GetLoc(value){
	var aiList=value.split("^");
	if (""==value){return false;}

	obj=document.getElementById("LocDesc");
	if (obj) { obj.value=aiList[1]; }
	
	obj=document.getElementById("LocDR");
	if (obj) { obj.value=aiList[2]; }
}



function LocDesc_blur() {
		return;
		var obj;
		//obj=document.getElementById('LocDesc_change');
		//if (obj && ""==obj.value) {
			obj=document.getElementById('LocDR');
			if (obj) { obj.value=""; alert("aaa")}
		//}
		//else { return false; }
}

function LocDesc_change() {

	var obj;

	obj=document.getElementById('LocDR');
	if (obj) { obj.value="";}
}


document.body.onload = BodyLoadHandler;