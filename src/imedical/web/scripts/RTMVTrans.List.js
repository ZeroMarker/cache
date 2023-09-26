// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyLoadHandler() {
	if (self==top) websys_reSizeT();
	var tbl=document.getElementById("tRTMVTrans_List");
	//alert(tbl.rows.length);
	if (tbl) {
		if (tbl.rows.length>0) {
			var voldesc="";
			var mrtype="";
			var tvobj=document.getElementById("RTMAVVolDescz1");
			if (tvobj) voldesc=tvobj.value;
			var tmobj=document.getElementById("TYPDescz1");
			if (tmobj) mrtype=tmobj.value;
			var vobj=document.getElementById("Volume");
			if (vobj && voldesc!="") vobj.innerText=voldesc;
			var tobj=document.getElementById("MRType");
			if (tobj && mrtype!="") tobj.innerText=mrtype;
		}

	}

}
document.body.onload=BodyLoadHandler;
