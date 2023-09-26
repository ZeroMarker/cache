// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
//
function AddItems() {
	var tbl=document.getElementById("twebsys_DSSView_LookupList");
	var par_win=window.opener; 

	if (tbl) {
		for (var i=1; i<tbl.rows.length; i++)  {		
			var itm=document.getElementById("Selectz"+i);
			if (itm) {
				if (itm.checked) {
					var itmx=document.getElementById("HIDDENFieldNamez"+i);
					if (itmx) {
						//are the last 2 chars '->'
						if (itmx.value.sub(-2,2)=='->') {
							par_win.AddItem(itmx.value.slice(0,-2));
						} else {
							par_win.AddItem(itmx.value);
						}
					}
				}
			}
		}
	}

	window.close(); 

}
function BodyLoad() {
	var obj=document.getElementById('update1');
	if (obj) obj.onclick=AddItems;
	
	var tbl=document.getElementById("twebsys_DSSView_LookupList");
	if (tbl) {
		for (var i=1; i<tbl.rows.length; i++)  {		
			var itmx=document.getElementById("FieldNamez"+i);
			var selectx=document.getElementById("Selectz"+i);
			if (itmx) {
				var inner = itmx.innerText;
				//are the last 2 chars '->'?  if not - remove the link
				if (inner.substring((inner.length),(inner.length-2))!='->') {
					var objParent = websys_getParentElement(itmx);
					if (objParent) objParent.innerHTML = itmx.innerHTML;
				} else {
					if (selectx) {
						selectx.disabled = true;
					}
				}
			}
		}
	}
	websys_reSizeT();
}

document.body.onload = BodyLoad;