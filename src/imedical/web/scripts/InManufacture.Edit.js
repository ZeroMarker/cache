// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function BodyLoadHandler() {

	var obj=document.getElementById('ID');
	var objStat=document.getElementById('HidStatus');

	var objUpdate=document.getElementById('update1');
	if (objUpdate) objUpdate.onclick = UpdateClick;
	//Log 57246 PeterC 06/01/06
	var objTNo=document.getElementById('INMANNo');
	if ((objTNo)&&(objTNo.value=="NEW")) objTNo.value=t['NEW'];

	var objInstr=document.getElementById("Instructions");
	if (objInstr) objInstr.readOnly=true;

	//Log 55195 Boc 01-09-2006: pass Sterile
	var objSterile=document.getElementById('sterile');
	if (objSterile) var sterile=objSterile.value

	var Status = "";
	if (objStat) { Status=objStat.value; }

	if (Status=="C") {
		var objFROM=document.getElementById('FROM');
		if (objFROM && objFROM.value=="Pharmacy.Presc.Edit") {
			websys_createWindow("websys.Reload.csp","ManufactureHeader");
		}
	}

	var TheID="";
	if (obj && obj.value!="") {
 	  DisableLinks(Status);
 	  TheID = obj.value;
	}

	//disable INMAN_Amount if linked to order entry addmixture
	var obj=document.getElementById("OEORI_ID");
	var obj2=document.getElementById("INMANAmount");
	if (obj && obj.value!="" && obj2) {
		obj2.disabled=true;
		obj2.className = "disabledField";
	}

	// 50310
	//top.frames["TRAK_main"].frames["ManufactureRecipe"].document.location.href='websys.default.csp?WEBSYS.TCOMPONENT=InManufacture.RecipeItems.List&ManufactureID='+TheID+'&Status='+Status+'&sterile='+sterile;
	//top.frames["TRAK_main"].frames["ManufactureItemBatch"].document.location.href='websys.default.csp?WEBSYS.TCOMPONENT=InManufacture.RecItm.Batch&RecItmID=&ManufactureID='+TheID+'&Status='+Status+'&sterile='+sterile;

	var url1='websys.default.csp?WEBSYS.TCOMPONENT=InManufacture.RecipeItems.List&ManufactureID='+TheID+'&Status='+Status+'&sterile='+sterile;
	var url2='websys.default.csp?WEBSYS.TCOMPONENT=InManufacture.RecItm.Batch&RecItmID=&ManufactureID='+TheID+'&Status='+Status+'&sterile='+sterile;
	websys_createWindow(url1,"ManufactureRecipe");
	websys_createWindow(url2,"ManufactureItemBatch");
}

function UpdateClick(e) {
	var Status = "";
	var ID= "";
	var objStat=document.getElementById('OrigQuantity');
	if (objStat) Status=objStat.value;
	var obj=document.getElementById('ID');
	if (obj) ID=obj.value;

	// can't complete an order without adding batches...
	if ((Status=="C") && (ID=="")) {
		alert(t['PREM_COMP']);
		return false;
	}

	var OrigQuantity = "";
	var objOrigQuantity=document.getElementById('OrigQuantity');
	if (objOrigQuantity) OrigQuantity=parseInt(objOrigQuantity.value);
	var RecQuantity = "";
	var objRecQuantity=document.getElementById('RecQty');
	if (objRecQuantity) RecQuantity=parseInt(objRecQuantity.value);
	var Quantity = "";
	var objQuantity=document.getElementById('INMANQty');
	if (objQuantity) Quantity=parseInt(objQuantity.value);
	var CanUpdate = true;
	// quantity changed and not a multiple of the recipe quantity..
	if ((Quantity!=OrigQuantity) && ((Quantity%RecQuantity)!=0)) {
		CanUpdate = confirm(t['QUANT_OK']);
	}
	if (CanUpdate) {
		return update1_click();
	} else {
		return false;
	}

}


function LinkDisable(e) {
	var el = websys_getSrcElement(e);
	if (el.disabled) {
		return false;
	}
	return true;
}

function DisableLinks(stat) {

	var obj=document.getElementById('StockItem');
	if (obj) {
		obj.readOnly=true;
		obj.className = "disabledField";
	}
	var obj=document.getElementById('ld1976iINMANUOMDR');
	if (obj) {
		obj.disabled=true;
	}
	var obj=document.getElementById('INMANNo');
	if (obj) {
		obj.readOnly=true;
		obj.className = "disabledField";
	}
	var obj=document.getElementById('INMANUOMDR');
	if (obj) {
		obj.readOnly=true;
		obj.className = "disabledField";
	}
	var obj=document.getElementById('INMANDate');
	if (obj) {
		obj.readOnly=true;
		obj.className = "disabledField";
	}
	var obj=document.getElementById('ld1976iINMANDate');
	if (obj) {
		obj.disabled=true;
	}
	var obj=document.getElementById('INMANCTLOCDR');
	if (obj) {
		obj.readOnly=true;
		obj.className = "disabledField";
	}

	var obj=document.getElementById('ld1976iINMANCTLOCDR');
	if (obj) {
		obj.disabled=true;
	}

	// if complete - disable even more....
	if ((stat=="C")|| (stat=="A")) {

		// 50310 - moved batch and expiry into status conditional to allow change value.
		var obj=document.getElementById('INMANBatchNo');
		if (obj) {
			obj.readOnly=true;
			obj.className = "disabledField";
		}

		var obj=document.getElementById('INMANExpireDate');
		if (obj) {
			obj.readOnly=true;
			obj.className = "disabledField";
		}
		var obj=document.getElementById('ld1976iINMANExpireDate');
		if (obj) {
			obj.disabled=true;
		}
		// 50310

		var obj=document.getElementById('INMANStatus');
		if (obj) {
			obj.readOnly=true;
			obj.className = "disabledField";
		}
		var obj=document.getElementById('ld1976iINMANStatus');
		if (obj) {
			obj.disabled=true;
		}
		var obj=document.getElementById('INMANQty');
		if (obj) {
			obj.readOnly=true;
			obj.className = "disabledField";
		}


		var obj=document.getElementById('INMANQty');
		if (obj) {
			obj.readOnly=true;
			obj.className = "disabledField";
		}
		var obj=document.getElementById('ld1976iINMANUserDR');
		if (obj) {
			obj.disabled=true;
		}
		var obj=document.getElementById('INMANUserDR');
		if (obj) {
			obj.readOnly=true;
			obj.className = "disabledField";
		}

		var obj=document.getElementById('INMANRemarks');
		if (obj) {
			obj.readOnly=true;
			obj.className = "disabledField";
		}
		var obj=document.getElementById('INMANAmount');
		if (obj) {
			obj.readOnly=true;
			obj.className = "disabledField";
		}
		var objUpdate=document.getElementById('update1');
		if (objUpdate) {
			objUpdate.onclick = LinkDisable;
			objUpdate.disabled=true;
		}

	}

}

function LookUpUser(txt) {
	var adata=txt.split("^");
	var User=adata[1];
	var objUser=document.getElementById('INMANUserDR');
	if (objUser) objUser.value = User;
}


document.body.onload = BodyLoadHandler;
