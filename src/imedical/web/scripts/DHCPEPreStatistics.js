/// 
//名称	DHCPEPreStatistics.js
//功能	体检预约信息统计
//组件	DHCPEPreStatistics	
//创建	2010.06.18


var TFORM="";
function BodyLoadHandler() {
	var obj;

	obj=document.getElementById("LocDesc");
	if (obj) {
		obj.onchange=LocDesc_change;
		obj.onblur=LocDesc_blur;
	}
	
	obj=document.getElementById("ItemDesc");
	if (obj) {
		obj.onchange=ItemDesc_change;
		obj.onblur=ItemDesc_blur;
	}
	obj=document.getElementById("SetDesc");
	if (obj) {
		obj.onchange=SetDesc_change;
		obj.onblur=SetDesc_blur;
	}

	obj=document.getElementById("BFind");
	if (obj) { obj.onclick=BFind_Click; }
	
	//iniForm();
	Muilt_LookUp('LocDesc'+'^'+'ItemDesc'+'^'+'SetDesc');
}



function GetOEItem(value){
	var aiList=value.split("^");
	if (""==value){return false;}

	obj=document.getElementById("ItemDesc");
	if (obj) { obj.value=aiList[1]; }
	
	obj=document.getElementById("ItemDR");
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
function GetIOrdSets(value){

	var aiList=value.split("^");
	if (""==value){return false;}

	obj=document.getElementById("SetDesc");
	if (obj) { obj.value=aiList[1]; }
	
	obj=document.getElementById("SetDR");
	if (obj) { obj.value=aiList[0]; }
	alert(obj.value)
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
function ItemDesc_blur() {
	return
	var obj;
	obj=document.getElementById('ItemDesc');
	if (obj && ""==obj.value) {
		obj=document.getElementById('ItemDR');
		if (obj) { obj.value=""; }
	}
	else { return false; }
}

function ItemDesc_change() {
		var obj;
		obj=document.getElementById('ItemDR');
		if (obj) { obj.value=""; }
}
function SetDesc_blur() {
	return
	var obj;
	obj=document.getElementById('SetDesc');
	if (obj && ""==obj.value) {
		obj=document.getElementById('SetDR');
		if (obj) { obj.value=""; }
	}
	else { return false; }
}

function SetDesc_change() {
		var obj;
		obj=document.getElementById('SetDR');
		if (obj) { obj.value=""; }
}

function BFind_Click(){
	var iLocDR='',iItemDR='',iDateBegin='',iDateEnd='',iSetDR="";
	var obj;
	obj=document.getElementById('LocDR');
	if (obj) { iLocDR=obj.value; }

	obj=document.getElementById('ItemDR');
	if (obj) { iItemDR=obj.value; }
	
	obj=document.getElementById('SetDR');
	if (obj) { iDateEnd=obj.value; }
	
	obj=document.getElementById('DateBegin');
	if (obj) { iDateBegin=obj.value; }
	
	obj=document.getElementById('DateEnd');
	if (obj) { iDateEnd=obj.value; }
	/*
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT='+'DHCPEPreStatistics'
			+"&DateBegin="+iDateBegin
			+"&DateEnd="+iDateEnd
		    +"&ItemDR="+iItemDR
		    +"&SetDR="+iSetDR
		    +"&LocDR="+iLocDR	
	//location.href=lnk;
	*/
	BFind_click();		
}

document.body.onload = BodyLoadHandler;