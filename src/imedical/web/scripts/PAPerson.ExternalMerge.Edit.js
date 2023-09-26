// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var fieldarray= new Array("PAPERForeignAddress","PAPERAddress2","CTCITDesc","CTZIPCode","PROVDesc");
var obj="";

function DocumentLoadHandler() {
	
	setclicks();
	
	obj=document.getElementById('ALL');
	if (obj) {
		obj.onclick=clickall;
		obj.click();
	}
	
	obj = document.getElementById('update1')
	obj.onclick = UpdateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
}

// go through all the checkboxes and set the click handlers
function setclicks() {
	var fld=document.getElementsByTagName('INPUT');
	for (var j=0; j<fld.length; j++) {
		if (fld[j].type=="checkbox") {
			obj=document.getElementById(fld[j].id);
			if ((obj) && (obj.id!="ALL")) obj.onclick=setbold;
		}
	}
}

// checkbox clich handler to make the textboxes bold/normal when ticked/unticked
function setbold(evt) {
	var obj=""; var obj2="";
	var eSrc=websys_getSrcElement(evt);
	var check=eSrc.id;
	var field=check.slice(1);
	
	obj=document.getElementById(check);
	if (obj) {
		if (obj.checked) {
			obj=document.getElementById("External"+field);
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById(field);
			if (obj) obj.style.fontWeight="normal";
			
			if ((obj) && (obj.id=="PAPERStNameLine1")) {
			for (var i=0;i<fieldarray.length;i++) {
					obj2=document.getElementById("External"+fieldarray[i]);
					if ((obj2)&&(obj2.value!="")) obj2.style.fontWeight="bold";
					obj2=document.getElementById(fieldarray[i]);
					if (obj2) obj2.style.fontWeight="normal";
				}
			}
		} else {	
			obj=document.getElementById("External"+field);
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById(field);
			if ((obj)&&(obj.value!=""))  obj.style.fontWeight="bold";
			
			if ((obj) && (obj.id=="PAPERStNameLine1")) {
				for (var i=0;i<fieldarray.length;i++) {
					obj2=document.getElementById(fieldarray[i]);
				if ((obj2)&&(obj2.value!=""))  obj2.style.fontWeight="bold";
					obj2=document.getElementById("External"+fieldarray[i]);
					if (obj2) obj2.style.fontWeight="normal";
				}
			}
		}
	}
}

function clickall() {
	obj=document.getElementById('ALL');
	if ((obj) && (obj.checked==true)) {
		var fld=document.getElementsByTagName('INPUT');
		for (var j=0; j<fld.length; j++) {
			if (fld[j].type=="checkbox") {
				obj=document.getElementById(fld[j].id);
				if ((obj) && (obj.id!="ALL")) {
					obj.checked=false;
					obj.click();
				}
			}
		}
	}
	if ((obj) && (obj.checked==false)) {
		var fld=document.getElementsByTagName('INPUT');
		for (var j=0; j<fld.length; j++) {
			if (fld[j].type=="checkbox") {
				obj=document.getElementById(fld[j].id);
				if ((obj) && (obj.id!="ALL")) {
					obj.checked=true;
					obj.click();
				}
			}
		}
	}	
}

function UpdateClickHandler(e) {
	
	obj=document.getElementById('update1');
	EnableAllFields()
	return update1_click();
	
}

document.body.onload = DocumentLoadHandler;
