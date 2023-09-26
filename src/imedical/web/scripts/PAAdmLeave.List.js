//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//

function LeaveBodyLoadHandler() {
	// if we are in the movement frames, set the target to load in the parent
	//var obj=document.getElementById("update1");
	//var frm=document.forms["fPAAdmLeave_List"];
	//if ((window.top)&&(window.top.frames["TRAK_main"])&&(window.top.frames["TRAK_main"].frames["MovmntList"])&&(frm)) frm.target="_parent";

	var obj=document.getElementById("New1");
	if (obj) {
		leave=obj.onclick;
		obj.onclick=validateAction;
	}
	
}

function getRow(eSrc) {
	while(eSrc.tagName != "TR") {
		if (eSrc.tagName == "TH") break;
		eSrc=eSrc.parentElement;
	}
	return eSrc;
}

function setRowClass(rowObj) {
	if (rowObj.rowIndex!=selectedRowObj.rowIndex) {
		rowObj.className='clsRowSelected';
		if ((selectedRowObj.rowIndex%2==0)&&(selectedRowObj.rowIndex>0)) {cName="RowEven";} else {cName="RowOdd";}
		selectedRowObj.className=cName;
		selectedRowObj=rowObj;
	}
}

function validateAction() {
	var eSrc=websys_getSrcElement(window.event.srcElement);
	if (eSrc.tagName=="IMG") var eSrc=websys_getParentElement(eSrc);
	if (eSrc.id=="New1") {var origcode=leave;} 
	if (document.getElementById("PAADMVisitStatus").value=="A") {
		if (typeof origcode!="function") origcode=new Function(origcode);
		if(origcode()==false) return false;
		return false;
	} else {
		
		alert(t['NotCurrentAdm'])
		return false;
	}
	return true;
}




//var frm=document.forms["fPAAdmLeave_List"];
//var tbl=document.getElementById("tPAAdmLeave_List");
//var f3=document.getElementById("fPAAdmLeave_List");

//try {if (tbl) tbl.onclick=SelectRowLeave;} catch(e) {}
//try {if (tbl) tbl.onKeyPress=SelectRowAdm;} catch(e) {}

//document.body.onload=BodyLoadHandler;


