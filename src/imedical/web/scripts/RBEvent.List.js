// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


function RBEvent_CreateCopy() {
	
	var lnk = "rbevent.createcopy.csp?EventID="+document.getElementById("ID").value;
	//top.frames["TRAK_hidden"].location=lnk;
	websys_createWindow(lnk,"TRAK_hidden");
	
}


function SelectRowHandler() {
	var row=selectedRowObj.rowIndex;
	var id=document.getElementById("ID")
	var obj=document.getElementById("EV_RowIdz"+row)
	if (obj && id) id.value=obj.value
}