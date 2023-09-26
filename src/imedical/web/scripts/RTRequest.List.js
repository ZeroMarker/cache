// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function RTListBodyOnLoadHandler() {

	if (document.getElementById(tRTRequest_List.id)) document.getElementById(tRTRequest_List.id).onclick=SelectRow;
	var SelAllObj=document.getElementById("SelectAll");
	if (SelAllObj) SelAllObj.onclick=SelectAll;
}

function SelectAll() {
	var tbl=document.getElementById("tRTRequest_List");
	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			var sobj=document.getElementById("Selectz"+i);
			if (sobj) sobj.checked=true;
		}
	}

}

function SelectRow() {
	var eSrcAry=window.event.srcElement.id.split("z");
	if (eSrcAry.length>0) {
		if (eSrcAry[0]=="VolDesc") {
			var tbl=getTableName(window.event.srcElement);
			var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
			var ParRef=f.elements["RTMAVRowIdz"+eSrcAry[1]].value;	

			var PatID=f.elements["RTMASPatNoDRz"+eSrcAry[1]].value;
			var obj=document.getElementById("VolDescz"+eSrcAry[1]);
		}	
	}

}


document.body.onload = RTListBodyOnLoadHandler;










