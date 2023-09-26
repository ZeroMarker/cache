// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function InManufacture_List_SelectRowHandler(evt) {
	var tbl=document.getElementById("tInManufacture_List");
	var f=document.getElementById("fInManufacture_List");
	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	//var MedicationID=document.getElementById("MedicationID");
	//if (MedicationID) { MedicationID = MedicationID.value;}
	if (eSrcAry[0]=="INMANCompleted") {
		return false;
	}
	// get the selected manufature RowID & set hidden field - this will prevent recipe selection item displaying
	/*if (eSrcAry[0]=="Modify") {
		var hidfld=document.getElementById("HIDManufacID");
		var RowID = f.elements["INMANRowIdz"+eSrcAry[1]].value;
		if (hidfld && RowID) {
			hidfld.value = RowID;
		} else {
			return false;
		}
	}*/


}


function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

function NewOnclick(evt) {
	var hidfld=document.getElementById("HIDManufacID");
	if (hidfld) {
		hidfld.value = "";
	}
	return New_click();
}

function StockOnchange(evt) {
	var Stock = document.getElementById("StockItem");
	var btnnew = document.getElementById("New");
	if (btnnew && Stock) {
		if ((Stock.value != "") && (Stock.className!='clsInvalid' )) {
			btnnew.onclick = NewOnclick;
			btnnew.disabled = false;
		} else {
			btnnew.onclick = LinkDisable;
			btnnew.disabled = true;
		}
	}
	return true;
}

function StockLookUp(str) {
	var retArr = str.split("^");
	var obj=document.getElementById('StockItem');
	if (obj) {
		if (retArr.length > 0) {
			try {
				obj.value=unescape(retArr[0]);
				obj.className='';
				websys_nextfocus(obj.sourceIndex);
			} catch(e) {};
		} else {
			obj.className='clsInvalid';
		}

	}
	StockOnchange();
}

//log 59832 BoC
function LookUpLocHandler(txt) {
	var adata=txt.split("^");
	var locID=adata[1];
	var locIDobj=document.getElementById("locID");
	if (locIDobj) locIDobj.value=locID;
}
var lobj=document.getElementById("Location");
if (lobj) lobj.onblur=locChangeHandler;
function locChangeHandler() {
	if ((lobj) && (lobj.value=="")) {
		var locIDobj=document.getElementById("locID");
		if (locIDobj) locIDobj.value="";
	}
}
//end of log 59832 Boc

//log 56579, 18-08-2006, Bo: add cat and sub-cat lookup
function LookUpCatSelect(txt) {
	//ANA 06.03.2002 Function to Return the Category ID
	var adata=txt.split("^");
	var catDesc=adata[0];
	var catID=adata[1];
	var catCode=adata[2];
	var cobj=document.getElementById("catID");
	if (cobj) cobj.value=catID;
	var scobj=document.getElementById("SubCategory");
	if (scobj) scobj.value="";
	var iobj=document.getElementById("StockItem");
	if (iobj) iobj.value="";
	var uobj=document.getElementById("UOM");
	if (uobj) uobj.value="";
}

function LookUpSubCatSelect(txt) {
	//ANA 06.03.2002 Function to Return the SubCategory ID
	var adata=txt.split("^");
	var subCatDesc=adata[0];
	var subCatID=adata[1];
	var subCatCode=adata[2];
	var subcatobj=document.getElementById("subCatID");
	if (subcatobj) subcatobj.value=subCatID;

}

// JPD Log 52240
// changed onchange to onblur as they over-ride calls to brokers. 
var cobj=document.getElementById("Category");
if (cobj) cobj.onblur=checkBlank;

//LOG 30799 02/12/02 PeterC: Commented out to prevent the Subcategory field from reseting
var scobj=document.getElementById("SubCategory");
if (scobj) scobj.onblur=SubCatChangeHandler;

var oiobj=document.getElementById("OrderItem");
if (oiobj) oiobj.onblur=checkItemBlank;

function SubCatChangeHandler() {
	if ((scobj) && (scobj.value=="")) {
		var subcatobj=document.getElementById("subCatID");
		if (subcatobj) subcatobj.value="";
	}
}

function checkItemBlank() {
	if ((oiobj) && (oiobj.value=="")) {
		var orditmobj=document.getElementById("OEORIItmMastDR");
		if (orditmobj) orditmobj.value="";
	}
}

function checkBlank(){
	var catobj=document.getElementById("catID");
	var subcatobj=document.getElementById("subCatID");
	var orditmobj=document.getElementById("OEORIItmMastDR");
	if (cobj.value=="") {
		catobj.value="";
		cobj.value="";
		scobj.value="";
		subcatobj.value="";
	}
	if(scobj.value=="") {
		scobj.value="";
		subcatobj.value="";
	}
	if(oiobj.value=="") {
		orditmobj.value="";
	}
}

function LookUpItemHandler(str) {
	//alert(str);
	var lu = str.split("^");	
	var obj=document.getElementById("OEORIItmMastDR");
	if(obj) obj.value=lu[1];
	//var obj=document.getElementById("UOM");
	//if(obj) obj.value=lu[20];
}
// end of log 56579

var frm=document.forms["fInManufacture_List"];
var tbl=document.getElementById("tInManufacture_List");
if (tbl) {
	tbl.tCompName=frm.id.substring(1,frm.id.length);
	tbl.onclick = InManufacture_List_SelectRowHandler
}



var stock = document.getElementById("StockItem");
if (stock) {
	//stock.onchange = StockOnchange;
}

//Log 61361 PeterC 03/11/06
var obj=document.getElementById("WardManuf");
if(obj) obj.onclick=WardManufHandler;

function WardManufHandler() {
	var wmobj=document.getElementById("WardManuf");
	var ltobj=document.getElementById("LocType");

	if((wmobj)&&(wmobj.checked)&&(ltobj)) ltobj.value="W";
	if((wmobj)&&(!wmobj.checked)&&(ltobj)) ltobj.value="";
}


StockOnchange();


