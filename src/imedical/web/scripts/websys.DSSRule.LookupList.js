// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
//
function AddItems() {
	var par_win=window.opener; 
	var tbl=document.getElementById("twebsys_DSSRule_LookupList");

	if (tbl) {
		for (var i=1; i<tbl.rows.length; i++)  {		
			var itm=document.getElementById("Selectz"+i);
			if (itm) {
				if (itm.checked) {
					//var itmx=document.getElementById("FieldNamez"+i);
					var itmx=document.getElementById("HIDDENFieldNamez"+i);
					
					var itmy=document.getElementById("FriendlyNamez"+i);
					var itmz=document.getElementById("Classz"+i);
					if (itmx) {
						var itmxx=itmx.value;
						//are the last 2 chars '->'
						if (itmxx.substring((itmxx.length),(itmxx.length-2))=='->') {
							var itmxy=(itmy.innerText)+"^"+(itmxx.slice(0,-2));
						} else {
							var itmxy=(itmy.innerText)+"^"+(itmxx);
						}
						var itmxyz=itmxy+"^"+(itmz.value);
						
						//alert(itmxy);
						par_win.AddItem(itmxyz);
						window.close(); 
					}
				}
			}
		}
	}

	

}

function BodyLoad() {
	var tbl=document.getElementById("twebsys_DSSRule_LookupList");
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

function LinkDisable(e) {
	return false;
}

document.onclick=AddItems;
document.body.onload = BodyLoad;