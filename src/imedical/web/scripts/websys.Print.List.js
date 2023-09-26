// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ab 7.03.06 58392

OrigLinks = new Array();

function BodyLoadHandler() {
	var tbl=document.getElementById("twebsys_Print_List");
	if (tbl) {
		for (var i=1;i<tbl.rows.length;i++) {
			var obj=document.getElementById("IPz"+i);
			if (obj) {
				// first set the original link URL's into an array, which we can call on in the OpenEditWindow method
				OrigLinks[obj.id]=obj.onclick.toString().split("'")[1];
				obj.onclick=OpenEditWindow;
			}
		}
	}
}

function OpenEditWindow(e) {
	var eSrc=websys_getSrcElement(e);
	if (eSrc.id=="") eSrc=websys_getParentElement(eSrc);
	websys_lu(OrigLinks[eSrc.id],"edit",'width=700,height=500,left=100,top=100');
	return false;
}

document.body.onload=BodyLoadHandler;
