// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


function Init() {
	var obj=document.getElementById('delete1'); //The entire workflow
	if (obj) obj.onclick=delete1ClickHandler;
	
	CheckTrakOptions();
}

function delete1ClickHandler() {
	//check before deleting entire workflow
	if (confirm(t["DELETE"])) {return delete1_click()} else {return false;}
}

// ab 8.03.07 62951 - disable all fields on screen for TRAK workflows if "Enable Trak Options" is not checked
function CheckTrakOptions() {
	var objid=document.getElementById("ID");
	var obj=document.getElementById("EnableTrakOptions");
	if ((obj)&&(obj.value!=1)&&(objid)&&(objid.value!="")&&(objid.value<50000)) {
		DisableAllFields(0,",update1,CycleSelection,JumpToList,Loop,",0)
		
		var obj=document.getElementById("CycleSelection");
		if (obj) obj.onclick=DisableCheck;
		var obj=document.getElementById("JumpToList");
		if (obj) obj.onclick=DisableCheck;
		var obj=document.getElementById("Loop");
		if (obj) obj.onclick=DisableCheck;
	}
}

document.body.onload=Init;
//Init();  