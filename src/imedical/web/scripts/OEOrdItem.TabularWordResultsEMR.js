// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// this will be done on the load - we will open our own document
document.body.onload = BodyLoadHandler;

function BodyLoadHandler() {

	var fso, f, ts, s;
	var ForReading = 1;
	var TristateUseDefault = -2;
	var FileDir="";

	var objArry=document.getElementById("UNCPath").value.split("^");
	var obj=document.getElementById("FileName");
	if ((objArry)&&(obj)) FileDir=objArry[1]+obj.value;

	if (FileDir!="") {
		var str1=FileDir;
		var re =/(\/)/g;
		var FilePath=str1.replace(re,"\\");

		fso = new ActiveXObject("Scripting.FileSystemObject");
		if (fso.FileExists(FilePath)) {
			f = fso.GetFile(FilePath);
			s = "";
			ts = f.OpenAsTextStream(ForReading, TristateUseDefault);
			while (!ts.AtEndOfStream ) {
				s = s + ts.ReadLine()+ String.fromCharCode(13,10);
			}
			ts.Close();
		}

		var obj=document.getElementById("RESText");
		if ((obj)) {
			obj.readOnly=true;
		  if(s) {
				obj.value=s;
			// Now done in the layout editor
			// obj.wrap="on";
			}
		}
	}

	if (FileDir="") {
		var obj=document.getElementById("RESText");
		var aobj=document.getElementById("AlternateReport");

		if ((obj)&&(aobj)&&(aobj.value!=""))
		{
			obj.value=aobj.value;
		}
	}


	/*
	var obj=document.getElementById("ResultRead");
	if ((obj)&&(obj.value=="")) {
		obj=document.getElementById("Unread");
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
	}
	*/

	var obj=document.getElementById("RESSTCode");
	if ((obj)&&(obj.value!="A")) { disableReadUnread(); }

	var obj=document.getElementById("ReadOnly");
	if ((obj)&&(obj.value==1)) {
			disableReadUnread();
			disableFieldsLinks();
	}

	var objBold=document.getElementById('BoldLinks');
	if (objBold) {
		var BoldLink = objBold.value.split("^");
		var obj=document.getElementById('EscalationHistory');
		if ((obj) && (BoldLink[0]=="1")) obj.style.fontWeight="bold";
	}

	var obj=document.getElementById("CanReadItems");
	if ((obj)&&(obj.value!=1)) {
		var obj=document.getElementById("UpdateAndNext");
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		obj=document.getElementById("Unread");
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var MarkAsReadobj=document.getElementById('MarkAsRead');
		if (MarkAsReadobj) {
			MarkAsReadobj.disabled = true;
		}


	}

	// Log 53689 YC - Rerun first focus to ensure that it runs after fields are made read only
	websys_firstfocus();
	UpdateBodyLoadHandler();
	
	

}

function disableReadUnread() {
	obj=document.getElementById("UpdateAndNext");
	if (obj) {
		obj.disabled=true;
		obj.onclick=LinkDisable;
	}
	var MarkAsReadobj=document.getElementById('MarkAsRead');
	if (MarkAsReadobj) {
		MarkAsReadobj.disabled = true;
	}
	obj=document.getElementById("Unread");
	if (obj) {
		obj.disabled=true;
		obj.onclick=LinkDisable;
	}
}

function TagResults() {	
}

function disableFieldsLinks() {

	obj=document.getElementById("Next");
	if (obj) {
		obj.disabled=true;
		obj.onclick=LinkDisable;
	}
	obj=document.getElementById("Prev");
	if (obj) {
		obj.disabled=true;
		obj.onclick=LinkDisable;
	}
	obj=document.getElementById("ViewedBy");
	if (obj) {
		obj.disabled=true;
		obj.onclick=LinkDisable;
	}
	obj=document.getElementById("ReadBy");
	if (obj) {
		obj.disabled=true;
		obj.onclick=LinkDisable;
	}
	obj=document.getElementById("ViewHistory");
	if (obj) {
		obj.disabled=true;
		obj.onclick=LinkDisable;
	}
	obj=document.getElementById("DateRead");
	if (obj) {
		obj.readOnly=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById("TimeRead");
	if (obj) {
		obj.readOnly=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById("UserCode");
	if (obj) {
		obj.readOnly=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById("PIN");
	if (obj) {
		obj.readOnly=true;
		obj.className = "disabledField";
	}
}
