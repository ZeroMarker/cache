// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function getTable(eSrc) {
	if ((eSrc)&&(eSrc.tagName)) while(eSrc.tagName != "TABLE") {eSrc=websys_getParentElement(eSrc);}
	return eSrc;
}


function Qty_changehandler(enc, e)  {
	var objStatus=document.getElementById('Status');
	if (objStatus && (objStatus.value=="C")) return false;

	var obj=websys_getSrcElement(e);
	var tbl=getTable(obj);
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var eSrcAry=obj.id.split("z");
	var RowID=f.elements["RowIDz"+eSrcAry[1]].value;

	var RunMeth = cspRunServerMethod(enc,'','',obj.value, RowID);
	if (RunMeth=='0') {
		// failed
		obj.className='clsInvalid';
		obj.focus();
		return websys_cancel();
	} else if (RunMeth=='1') {
		// successful change - refresh page
		window.treload('websys.csp');
	} else if (RunMeth=='') {
		// no change - go to next prompt
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

function BatchLookUp(val) {
	//46298 - check BatchID field to allow deletion of all batches for this item
	var objBatch=document.getElementById("Batch");
	var objBatchID=document.getElementById("BatchID");
	var objAvail=document.getElementById("Avail");

	var txt = val.split("^");
	if (objBatchID) {
		objBatchID.value = txt[0];
	}
	if (objBatch) {
		objBatch.value = txt[1]+": "+txt[3];
	}
	if (objAvail) {
		objAvail.value = txt[3];
	}

}

function AddClickHandler () {
	var objAvail=document.getElementById("Avail");
	var objQuantity=document.getElementById("Quantity");
	var objBatch=document.getElementById("Batch");
	if (objAvail && objQuantity && objBatch) {
		if (objQuantity.value=="") {
			alert(t['NO_QUANT']);
			return false;
		}
		if (objBatch.value=="") {
			alert(t['NO_BATCH']);
			return false;
		}

		if (parseInt(objAvail.value) < parseInt(objQuantity.value)) {
			alert(t['INSUFF_QUANT']);
			return false;
		}
		Add_click();
	}
}

function AddAllClickHandler () {
	var objRefreshRecipe=document.getElementById('RefreshRecipe');
	if (objRefreshRecipe ) {
		objRefreshRecipe.value=="1";
	}

	AddAll_click();
}

function BodyLoadHandler() {
	var objAdd=document.getElementById("Add");
	if (objAdd) {
		objAdd.onclick=AddClickHandler;
	}
	var objAdd=document.getElementById("AddAll");
	if (objAdd) {
		objAdd.onclick=AddAllClickHandler;
	}
	var ManufactureID="";
	var objID=document.getElementById('ManufactureID');
	if (objID) ManufactureID=objID.value;
	var Status="";
	var objStatus=document.getElementById('Status');
	if (objStatus) Status=objStatus.value;
	if (objID && objStatus) {
		if ((objID.value=="") || (objStatus.value=="C") || (objStatus.value=="A")) {
			DisableLinks();
		}
	}
	var RecItmID="";
	var objRecItmID=document.getElementById('RecItmID');
	if (objRecItmID) RecItmID=objRecItmID.value;
	if (objRecItmID && objRecItmID.value=="") DisableBatch();
	// refresh the items screen...
	var objRefreshRecipe=document.getElementById('RefreshRecipe');
	if (objRefreshRecipe && objRefreshRecipe.value=="1") {
		// Log 54370 YC - refreshes ManufactureRecipe (left frame) then disables the batch fields
		//top.frames["TRAK_main"].frames["ManufactureRecipe"].treload();
		//websys_createWindow("websys.reloadthis.csp","ManufactureRecipe");
		//log 62097 BoC don't use reload. it only picks up old url, and causes endless loop.
		top.frames["TRAK_main"].frames["ManufactureRecipe"].document.location.href='websys.default.csp?WEBSYS.TCOMPONENT=InManufacture.RecipeItems.List&RecItmID='+RecItmID+'&ManufactureID='+ManufactureID+'&Status='+Status;
		DisableBatch();
	}
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

function TableDisable(evt) {
	return false;
}

function DisableBatch() {
	var obj=document.getElementById('Batch');
	if (obj) {
		obj.readOnly=true;
		obj.className = "disabledField";
	}
	var obj=document.getElementById('ld1983iBatch');
	if (obj) {
		obj.disabled=true;
	}
	var obj=document.getElementById('Quantity');
	if (obj) {
		obj.readOnly=true;
		obj.className = "disabledField";
	}
	var obj=document.getElementById('ld1983iQuantity');
	if (obj) {
		obj.disabled=true;
	}

}
function DisableLinks() {

	DisableBatch();
	var obj=document.getElementById('Add');
	if (obj) {
		obj.disabled=true;
		obj.onclick = LinkDisable;
	}
	var obj=document.getElementById('AddAll');
	if (obj) {
		obj.disabled=true;
		obj.onclick = LinkDisable;
	}
	var tbl = document.getElementById("tInManufacture_RecItm_Batch");
	if (tbl) {
		tbl.onclick=TableDisable;
		for (var i=0;i<tbl.rows.length;i++) {
			var obj=document.getElementById("Qtyz"+i);
			if (obj) obj.disabled = true;
		}
	}

}

document.body.onload = BodyLoadHandler;
