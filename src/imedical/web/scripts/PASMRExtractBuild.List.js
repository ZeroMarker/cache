// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function Init() {
	var tbl=document.getElementById("tPASMRExtractBuild_List");
	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			var HEobj=document.getElementById("HasErrorz"+i);
			var Eobj=document.getElementById("Errorsz"+i);
			if ((HEobj)&&(HEobj.value!="")) {
				if(Eobj) Eobj.style.fontWeight="bold";
			}
		}
	}
}

document.body.onload=Init;