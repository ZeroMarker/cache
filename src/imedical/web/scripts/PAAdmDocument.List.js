// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function PAAdmDocumentList_FileHander(e) {
	var eSrcAry=window.event.srcElement.id.split("z");
	if (eSrcAry.length>0) {
		if (eSrcAry[0]=="File") {
			var tbl=getTableName(window.event.srcElement);
			var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
			vdir=f.elements["VirtualDirectoryz"+eSrcAry[1]].value;
			var file=f.elements["DOC_Filez"+eSrcAry[1]].value;
			if (vdir=="") {alert(t['VIRTUAL_DIR_BLANK']); return false}
			websys_createWindow(vdir+file, 'new', 'scrollbars=yes,toolbar=no,width=700,height=450,top=20,left=20')
		}
	}
	//return false
}

if (document.getElementById('tPAAdmDocument_List')) document.getElementById('tPAAdmDocument_List').onclick=PAAdmDocumentList_FileHander;
