// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function getTable(eSrc) {
	if ((eSrc)&&(eSrc.tagName)) while(eSrc.tagName != "TABLE") {eSrc=websys_getParentElement(eSrc);}
	return eSrc;
}

function Batch_changehandler(enc, e)  {
	var obj=websys_getSrcElement(e);
	var ArcimDR= "";
	var objArcimDR=document.getElementById("ArcimDR");
	if (objArcimDR) ArcimDR= objArcimDR.value;
	var Batch = "";
	var objBatch =document.getElementById("Batch");
	if (objBatch) Batch = objBatch.value;
	var val = cspRunServerMethod(enc,'','', ArcimDR, Batch);
	if (val=='') {
		// failed
		obj.className='clsInvalid';
		obj.focus();
		return websys_cancel();
	} else {
		BatchLookUp(val) 
	}
}


function taken_changehandler(enc, e)  {

	var qty = "";
	var obj=websys_getSrcElement(e);
	if (obj) qty = obj.value;
	var tbl=getTable(obj);
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var OrderID = "";
	var objOrderID=document.getElementById("OrderID");
	if (objOrderID) OrderID = objOrderID.value;
	var SessionId = "";
	var objSessionId=document.getElementById("SessionId");
	if (objSessionId) SessionId = objSessionId.value;

	var eSrcAry=obj.id.split("z");
	var RowID=f.elements["RowIDz"+eSrcAry[1]].value;
	var negOK=f.elements["negOKz"+eSrcAry[1]].value;
	var avail=f.elements["HIDDENavailz"+eSrcAry[1]].value;
	if ((negOK!="1") && (parseFloat(avail) < parseFloat(qty))) {
		alert(t['INSUFF_QUANT']);
		obj.className='clsInvalid';
		obj.focus();
		return websys_cancel();
	}
	var RunMeth = cspRunServerMethod(enc,'','', SessionId, OrderID, RowID, qty);
	if (RunMeth=='0') {
		// failed
		obj.className='clsInvalid';
		obj.focus();
		return websys_cancel();
	} else if (RunMeth=='1') {
		// successful change - refresh page
		// 63101
		DisableParentLink();
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
	var objBatch=document.getElementById("Batch");
	var objBatchID=document.getElementById("BatchID");
	var objAvail=document.getElementById("Avail");
	var objNegOK=document.getElementById("HIDDENNegOK");
	var objHIDDENQuant=document.getElementById("HIDDENQuant");
	var objQuant=document.getElementById("Quantity");

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
	if (objNegOK) {
		objNegOK.value = txt[4];
	}
	if (objHIDDENQuant && objQuant) {
		objQuant.value = objHIDDENQuant.value;
	}

}

function AddClickHandler () {
	var objAvail=document.getElementById("Avail");
	var objQuantity=document.getElementById("Quantity");
	var objBatch=document.getElementById("Batch");
	var objNegOK=document.getElementById("HIDDENNegOK");

	if (objAvail && objQuantity && objBatch) {
		if ((objQuantity.value=="")||(objQuantity.value<=0)) {
			alert(t['NO_QUANT']);
			return false;
		}
		if (objBatch.value=="") {
			alert(t['NO_BATCH']);
			return false;
		}

		if ((objNegOK.value!="1") && (parseFloat(objAvail.value) < parseFloat(objQuantity.value))) {
			alert(t['INSUFF_QUANT']);
			return false;
		}
		// 63101
		DisableParentLink();
		return Add_click();
	}
}

function BodyLoadHandler() {
	// 63101
	var obj=document.getElementById("DeletedFlag");
	if (obj && obj.value=="1") {
		DisableParentLink();
	}
	var objAdd=document.getElementById("Add");
	if (objAdd) {
		objAdd.onclick=AddClickHandler;
	}
	var objUpd=document.getElementById("Update");
	if (objUpd) {
		objUpd.onclick=UpdateClickHandler;
	}
	/*
	if (window.opener) {
		var objExecIDs=document.getElementById("ExecIDs");
		var TableRow = "";
		var objTableRow=document.getElementById("TableRow");
		if (objTableRow) TableRow = objTableRow.value;
		var objParentExecIDs=window.opener.document.getElementById("OEORIExecz"+TableRow);
		if (objParentExecIDs && objExecIDs) {
			objExecIDs.value = objParentExecIDs.value;
		}
	}
	*/
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

function UpdateClickHandler() {
	var overpack=document.getElementById("AllowOverPack");

	//if (overpack && overpack.value!=1) {
		var totals=0;
		var qty=document.getElementById("HIDDENQtyReq");
		var tbl=document.getElementById("tpharmacy_presc_modifybatch");

		if (tbl) {
			for (var i=1;i<tbl.rows.length;i++) {
				var tkn=document.getElementById("takenz"+i);
				var avl=document.getElementById("HIDDENavailz"+i);
				if (tkn && avl && (parseFloat(avl.value)<parseFloat(tkn.value)) ) {
					var zbatch="";
					if ((document.getElementById("batchnumz"+i)) && (document.getElementById("batchnumz"+i).innerText!="")) { zbatch=": " + document.getElementById("batchnumz"+i).innerText; }
					alert(t['INSUFF_QUANT'] + zbatch);
					tkn.className="clsInvalid";
					return;
				}
				if (tkn) totals=parseFloat(totals)+parseFloat(tkn.value);
			}
		}
	if (overpack && overpack.value!=1) {
		if (qty && (parseFloat(qty.value)<parseFloat(totals))) {
			alert(t['NOOVERPACK']);
			return;
		}
	}
	
	return Update_click();
}
// 63101
function DisableParentLink() {
	var par_win = window.opener;
	if (par_win && (par_win.name="PharmacyEdit")) {
		par_win.DisableAllAction();
	}
}

document.body.onload = BodyLoadHandler;
