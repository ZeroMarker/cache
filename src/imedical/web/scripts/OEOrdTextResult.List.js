// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function formatText() {
	f=document.fOEOrdTextResult_List;
	tbl=document.getElementById('tOEOrdTextResult_List');
	for (var i=1;i<tbl.rows.length;i++) {
		var fsize=f.elements["SEC_FontSizez"+i].value;
		var fname=f.elements["SEC_FontNamez"+i].value;
		tbl.rows[i].style.cssText="font-size:"+fsize+"pt;font-family:"+fname;
	}
}
function docHandler() {
	formatText();
	//websys_reSizeT();
}

window.onload=docHandler;