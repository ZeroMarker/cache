/// DHCPEItemNoCheck.js

///查询未检的项目

function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("CSelectAll");
	if (obj) { obj.onclick=SelectAll; }
	
	
	obj=document.getElementById("BQuery");
	if (obj) { obj.onclick=Find_click;; }
	
	 obj=document.getElementById("RegNo");
	 if (obj){ obj.onkeydown=RegNo_KeyDown;}
	 
	 obj=document.getElementById("PatName");
	 if (obj){ obj.onkeydown=RegNo_KeyDown;}
}

function SelectAll() {
	var Src=window.event.srcElement;
	var obj;
	
	obj=document.getElementById("TFORM");
	if (obj) { var TForm=obj.value; }
	
	objtbl=document.getElementById("t"+TForm);
	if (objtbl) {}
	else { return false; }
	
	for (iLoop=1;iLoop<=objtbl.rows.length;iLoop++) {
		obj=document.getElementById("TCheck"+"z"+iLoop);
		if (obj) { obj.checked=Src.checked; }
	}
	
}


function RegNo_KeyDown(e){
	
	var Key=websys_getKey(e);
	if ((13==Key)) {
		Find_click();
	}
}

function Find_click() {
	var iRegNo='',iPatName='',iGID='',iDateFrom='',iDateTo='',iOEStatus='',iOEList='';
	var obj;
	obj=document.getElementById("RegNo")
	if (obj) { iRegNo=obj.value; }
	
	obj=document.getElementById("PatName")
	if (obj) { iPatName=obj.value; }
	
	obj=document.getElementById("GName")
	if (obj && ""!=obj.value) { 
		obj=document.getElementById("GID")
		if (obj) { iGID=obj.value; }
	}
	
	obj=document.getElementById("DateFrom")
	if (obj) { iDateFrom=obj.value; }
	
	obj=document.getElementById("DateTo")
	if (obj) { iDateTo=obj.value; }
	
	obj=document.getElementById("OEStatus")
	if (obj) { iOEStatus=obj.value; }

	iOEList=GetOEList();
	
	/*obj=document.getElementById("TFORM");
	if (obj) { var TForm=obj.value; }*/
	
	//var lnk='websys.default.csp?WEBSYS.TCOMPONENT='+TForm
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT='+'DHCPEItemNoCheck'
			+'&RegNo='+iRegNo
			+'&PatName='+iPatName
			+'&GID='+iGID
			+'&DateFrom='+iDateFrom
			+'&DateTo='+iDateTo
			+'&OEStatus='+iOEStatus
			+'&OEList='+iOEList
			;
	
	location.href=lnk;
}

function GetOEList() {
	var OEList='';
	var Frame=parent.frames['DHCPEItemNoCheck.List'];
	OEList=Frame.GetOEList();
	return OEList;
}
function GetGroupID(value) {
	var obj;
	var vars=value.split("^");
	if (vars[2]) {
		obj=document.getElementById("GID")
		if (obj) { obj.value=vars[2]; }
	}

	if (vars[0]) {
		obj=document.getElementById("GName")
		if (obj) { obj.value=vars[0]; }
	}
}
document.body.onload=BodyLoadHandler;