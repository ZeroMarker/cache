// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var selectedRowObj=new Object();
selectedRowObj.rowIndex="";


function Qty_changehandler(enc, e)  {
	var objStatus=document.getElementById('Status');
	if (objStatus && (objStatus.value=="C")) return false;

	var obj=websys_getSrcElement(e);
	var tbl=getTableName(obj);
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var eSrcAry=obj.id.split("z");
	var RowID=f.elements["RowIDz"+eSrcAry[1]].value;

	if (cspRunServerMethod(enc,'','',obj.value, RowID)=='0') {
		obj.className='clsInvalid';
		obj.focus();
		return websys_cancel();
	} else {
		obj.className='';
		var index=obj.sourceIndex;
		for (var j=index+1;j<document.all.length;j++) {
			if ( ((document.all(j).tagName=="INPUT")||(document.all(j).tagName=="TEXTAREA"))
			&& (document.all(j).type!="hidden") && (!document.all(j).disabled) ) {
				websys_setfocus(document.all(j).name);
				break;
			}
		}
	}
}
function BodyLoadHandler() {

	var tbl = document.getElementById("tInManufacture_RecipeItems_List");
	if (tbl) tbl.onclick=SelectRecItem;
	var ManufactureID="";
	var objID=document.getElementById('ManufactureID');
	if (objID) ManufactureID=objID.value;
	var Status="";
	var objStatus=document.getElementById('Status');
	if (objStatus) Status=objStatus.value;
	// disable ALL the recipe screen
	if (objID && objStatus) {
		if ((objID.value=="") || (objStatus.value=="C")  || (objStatus.value=="A")) {
			DisableLinks(true);
		}
	}
	// disable the add/delete, but allow table row to be selected
	var objModify=document.getElementById('CanModify');
	if (objModify) {
		if (objModify.value!="Y") {
			DisableLinks(false);
		}
	}
	// refresh the batches screen...
	//46298 - ONLY refresh screen if we have NOT just deleted an item - or we loop forever...
	var objRefreshBatches=document.getElementById('RefreshBatches');
	if (objRefreshBatches && objRefreshBatches.value=="1") {
		//top.frames["TRAK_main"].frames["ManufactureItemBatch"].treload();
		//websys_createWindow("websys.reloadthis.csp","ManufactureItemBatch");
		//log 62097 BoC don't use reload. it only picks up old url, and causes endless loop.
		top.frames["TRAK_main"].frames["ManufactureItemBatch"].document.location.href='websys.default.csp?WEBSYS.TCOMPONENT=InManufacture.RecItm.Batch&RecItmID=&ManufactureID='+ManufactureID+'&Status='+Status;;
	}

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


function DisableLinks(DisableALLTable) {
	var obj=document.getElementById('StockItem');
	if (obj) {
		obj.readOnly=true;
		obj.className = "disabledField";
	}
	var obj=document.getElementById('ld1981iStockItem');
	if (obj) {
		obj.disabled=true;
	}
	var obj=document.getElementById('Quantity');
	if (obj) {
		obj.readOnly=true;
		obj.className = "disabledField";
	}
	var obj=document.getElementById('ld1981iQuantity');
	if (obj) {
		obj.disabled=true;
	}
	var obj=document.getElementById('Add');
	if (obj) {
		obj.disabled=true;
		obj.onclick = LinkDisable;
	}
	var tbl = document.getElementById("tInManufacture_RecipeItems_List");
	if (tbl) {
		if (DisableALLTable) tbl.onclick=TableDisable;
		for (var i=0;i<tbl.rows.length;i++) {
			var obj=document.getElementById("Qtyz"+i);
			if (obj) obj.disabled = true;
		}
	}

}
function SelectRecItem(evt) {

	var lastSelectedRow=selectedRowObj;
	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var tblObj=getTable(eSrc);
	var f=document.getElementById("f"+tblObj.id.substring(1,tblObj.id.length));
	var ManufactureID=f.elements["ManufactureID"].value;
	var Status=f.elements["Status"].value;
	if (Status == "C") return false;

	var eSrcAry=eSrc.id.split("z");
	if (eSrcAry[0]=='AllPicked') return false;
	var objModify=document.getElementById('CanModify');
	if (objModify) {
		if ((objModify.value!="Y") && (eSrcAry[0]=='Delete')) return false;
	}
	var rowObj=eSrc;
	// getRow
	while(rowObj.tagName != "TR") {
		if (rowObj.tagName == "TH") break;
		rowObj=websys_getParentElement(rowObj);
	}

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
}

function getTable(eSrc) {
	if ((eSrc)&&(eSrc.tagName)) while(eSrc.tagName != "TABLE") {eSrc=websys_getParentElement(eSrc);}
	return eSrc;
}

document.body.onload = BodyLoadHandler;

