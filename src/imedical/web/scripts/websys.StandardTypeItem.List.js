// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

//if system does not enable TrakOptins (site only), then make value field readonly.
var obj=document.getElementById("EnableTrakOption");
if (obj.value!="1") {
	var tbl=document.getElementById("twebsys_StandardTypeItem_List");
	if (tbl) {
		for (var i=0; i<tbl.rows.length; i++) {
			var fld=document.getElementById("Valuez"+i);
			if (fld) { fld.readOnly=1; fld.className="disabledField";}
		}
	}
}