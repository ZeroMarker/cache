// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var objSelectAll=document.getElementById("SelectAll");

function CheckBoxClick() {
	// SA 31.1.03 - log 32317: Created "Select/Deselect All" checkbox
	// Checking/Unchecking of all will no longer rely on first checkbox. 
	// It will now rely on the "SelectAll" checkbox

	var tbl=document.getElementById("twebsys_Menu_CopyHeaders");

	for (var i=1; i<tbl.rows.length; i++) {
		var objSelectHeaders=document.getElementById("SelectHeaderz"+i);
		if (objSelectHeaders) {
			objSelectHeaders.checked=objSelectAll.checked;
		}	
	}
}

//function CheckBoxClick(evt) {
//	var eSrc=websys_getSrcElement(evt);
//	if ((eSrc.tagName=="INPUT")&&(eSrc.type=="checkbox")&&(eSrc.id.indexOf("SelectHeaderz")==0)) {
//		var row=eSrc.id.substring(13,eSrc.id.length);
//		var frm=document.forms[row-1];
//		if (frm) {
//			if (eSrc.checked) {
//				for (var i=0; i<frm.elements.length; i++) {
//					var obj=frm.elements[i];
//					if (obj.type=="checkbox") obj.checked=true;
//				}
//			} else {
//				for (var i=0; i<frm.elements.length; i++) {
//					var obj=frm.elements[i];
//					if (obj.type=="checkbox") obj.checked=false;
//				}
//			}
//		}
//	}
//}

function ValidateUpdate(evt) {
	//warn if new code starts with "z" or "trak"
	var obj=document.getElementById("NewCode");
	if (obj) {
		var val=obj.value.toUpperCase();
		if ((val.indexOf("Z")==0)||(val.indexOf("TRAK")==0)) {
			alert("\'" + t['NewCode'] + "\' " + t['XINVALID'] + "\n" + t['InvalidCode']);
			websys_cancel();
			return false;
		}
	}
	update1_click();
}

// SA 31.1.03 - log 32317: Created "Select/Deselect All" checkbox
// Checking/Unchecking of all will no longer rely on first checkbox. 
if (objSelectAll) objSelectAll.onclick=CheckBoxClick;
//document.onclick=CheckBoxClick;

var obj=document.getElementById("update1");
if (obj) obj.onclick = ValidateUpdate;
