// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function MRPicturesListEPR_FileHander(e) {
	var eSrcAry=window.event.srcElement.parentElement.id.split("z");
	if (eSrcAry.length>0) {
		if (eSrcAry[0]=="File") {
			var tbl=getTableName(window.event.srcElement);
			var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
			var vdir=f.elements["VirtualDirectoryz"+eSrcAry[1]].value;
			var type=f.elements["PIC_Typez"+eSrcAry[1]].value;
			//var file=f.elements["PIC_Pathz"+eSrcAry[1]].value;
			var file=document.getElementById("PIC_Pathz"+eSrcAry[1]).innerText;
			if (type=="P") {alert(t['ANNOTATION']); return false}
			if (vdir=="") {alert(t['VIRTUAL_DIR_BLANK']); return false}
			websys_createWindow(vdir+file, 'new', 'scrollbars=yes,toolbar=no,width=700,height=450,top=20,left=20')
		}
	}
	//return false;
}

if (document.getElementById('tMRPictures_ListEPR')) document.getElementById('tMRPictures_ListEPR').onclick=MRPicturesListEPR_FileHander;
