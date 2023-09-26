// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var selectedRowObj=new Object();
selectedRowObj.rowIndex="";

function BodyLoadHandler() {

	var tbl = document.getElementById("tPARecallSched_List");
	if (tbl) tbl.onclick=SelectItem;

	/*
	if (objID && objStatus) {
		if ((objID.value=="") || (objStatus.value=="C")  || (objStatus.value=="A")) {
			DisableLinks(true);
		}
	}
	*/
}

function TableDisable(evt) {
	return false;
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

function LookUpHosp(val) {
	var txt = val.split("^");

	var obj=document.getElementById("HospitalID");
	if (obj) {
		obj.value=txt[1];
	}
}

function LookUpLoc(val) {
	var txt = val.split("^");
	var obj=document.getElementById("Location");
	if (obj) {
		obj.value=txt[0];
	}
	var obj=document.getElementById("LocationIDs");
	if (obj) {
		obj.value=txt[0];
	}
}

function DisableLinks(DisableALLTable) {
	/*
	var obj=document.getElementById('');
	if (obj) {
		obj.readOnly=true;
		obj.className = "disabledField";
	}
	*/

}
function SelectItem(evt) {

	var lastSelectedRow=selectedRowObj;
	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var tblObj=getTable(eSrc);
	var f=document.getElementById("f"+tblObj.id.substring(1,tblObj.id.length));
	var PatientID=f.elements["PatientID"].value;

	var eSrcAry=eSrc.id.split("z");
	if (eSrcAry[0]=='Status') return false;

	var rowObj=eSrc;
	// getRow
	while(rowObj.tagName != "TR") {
		if (rowObj.tagName == "TH") break;
		rowObj=websys_getParentElement(rowObj);
	}

	/*
	// don't select the row if a header, or if we're deleting it....
	if ((rowObj.tagName != "TH") && (eSrcAry[0]!='Delete') && (rowObj.rowIndex!=0) ) {
		if ((lastSelectedRow.rowIndex==rowObj.rowIndex)&&(tblObj.id==getTable(lastSelectedRow).id)) {
			rowObj.className=lastSelectedRow.PrevClassName;
			selectedRowObj=new Object();
			selectedRowObj.rowIndex="";
			//top.frames["TRAK_main"].frames["ManufactureItemBatch"].document.location.href='websys.default.csp?WEBSYS.TCOMPONENT=InManufacture.RecItm.Batch&RecItmID=&ManufactureID='+ManufactureID+'&Status='+Status;
			var url='websys.default.csp?WEBSYS.TCOMPONENT=InManufacture.RecItm.Batch&RecItmID=&ManufactureID='+ManufactureID+'&Status='+Status;
			websys_createWindow(url,"ManufactureItemBatch");
		} else {
			if ((rowObj.className!='clsRowDisabled')&&(rowObj.selectenabled!=0)) {
				rowObj.PrevClassName=rowObj.className;
				rowObj.className='clsRowSelected';
				lastSelectedRow.className=lastSelectedRow.PrevClassName;
				selectedRowObj=rowObj;
				var RowID=f.elements["RowIDz"+rowObj.rowIndex].value;
				//top.frames["TRAK_main"].frames["ManufactureItemBatch"].document.location.href='websys.default.csp?WEBSYS.TCOMPONENT=InManufacture.RecItm.Batch&RecItmID='+RowID+'&ManufactureID='+ManufactureID+'&Status='+Status;
				var url='websys.default.csp?WEBSYS.TCOMPONENT=InManufacture.RecItm.Batch&RecItmID='+RowID+'&ManufactureID='+ManufactureID+'&Status='+Status;
				websys_createWindow(url,"ManufactureItemBatch");
			}
		}
	}
	*/
	
}

function getTable(eSrc) {
	if ((eSrc)&&(eSrc.tagName)) while(eSrc.tagName != "TABLE") {eSrc=websys_getParentElement(eSrc);}
	return eSrc;
}

document.body.onload = BodyLoadHandler;

