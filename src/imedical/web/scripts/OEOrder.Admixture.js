// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function LookUpItemHandler(str) {
	//alert(str);
	var lu = str.split("^");	
	var obj=document.getElementById("OEORIItmMastDR");
	if(obj) obj.value=lu[1];
	var obj=document.getElementById("ARCIMPHCDFDR");
	if(obj) obj.value=lu[18];
	var obj=document.getElementById("Dosage");
	if(obj) obj.value=lu[19];
	var obj=document.getElementById("UOM");
	if(obj) obj.value=lu[20];
}

function UOMLookUpHandler(str) {
	var lu = str.split("^");	
	var obj=document.getElementById("Dosage");
	if(obj) obj.value=lu[2];
}

function DelayAddItem() {
	setTimeout("AddItemClickHandler()",600);
}


function AddItemClickHandler() {
	var iobj=document.getElementById("Item");
	var dobj=document.getElementById("Dosage");
	var uobj=document.getElementById("UOM");

	if((!iobj)||(!dobj)||(!uobj)) {
		alert(t["Item"]+", "+t["Dosage"]+", "+t["UOM"]+": "+ t['XMISSING']);
		return false;
	}
	else if((iobj.value=="")||(iobj.className=="clsInvalid")||(dobj.value=="")||(dobj.className=="clsInvalid")||(uobj.value=="")||(uobj.className=="clsInvalid")) {
		alert(t["Item"]+", "+t["Dosage"]+", "+t["UOM"]+": "+ t['XINVALID']);
		return false;
	}
	return AddItem_click();
}

function RunCalcVolQty() {
	var OrdDetFrame=top.frames["OrdDetFrame"];
	if(OrdDetFrame) {
	try{	
		OrdDetFrame.CalcVolQty();
	}catch(e){}
	}
}

function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	var fldlab = document.getElementById("c"+fldName);
	var icN = document.getElementById("ld2184i"+fldName);

	if (fld) {
		fld.style.visibility = "hidden";
	}

	if (fldlab) {
		fldlab .style.visibility = "hidden";
	}

	if (icN) {
		icN.style.visibility = "hidden";
	}

}

function DisableLinks(DisableALLTable) {

	DisableField("Item");
	DisableField("Dosage");
	DisableField("UOM");
	DisableField("AddItem");

	var tbl = document.getElementById("tOEOrder_Admixture");
	if (tbl) {
		for (var i=0;i<tbl.rows.length;i++) {
			var obj=document.getElementById("Removez"+i);
			if (obj) obj.onclick = TableDisable;
		}
	}

}

function TableDisable() {
	return false;
}

function RunCalcBills() {
	var totals=0;
	var tbl=document.getElementById("tOEOrder_Admixture");

	if (tbl) {
		for (var i=1;i<tbl.rows.length;i++) {
			var cost=document.getElementById("Costz"+i);
			if (cost) totals=parseFloat(totals)+parseFloat(cost.value);
		}
	}

	var OrdDetFrame=top.frames["OrdDetFrame"];
	if(OrdDetFrame) {
	try{	
		OrdDetFrame.CalcBills(totals);
	}catch(e){}
	}
	return;
}

//document.body.onload = BodyLoadHandler;

//function BodyLoadHandler() {
	setTimeout("RunCalcVolQty()",1000);
	var obj=document.getElementById("AddItem");
	if(obj)obj.onclick=DelayAddItem;
	var obj=document.getElementById("DisplayOnlyMixture");
	if((obj)&&(obj.value=="Y")) DisableLinks();

	// 56083
	setTimeout("RunCalcBills()",1200);
//}

var tbl=document.getElementById("tOEOrder_Admixture");
if (tbl) {
	for (var i=1;i<tbl.rows.length;i++) {
		var obj=document.getElementById("Removez"+i);
		if (obj) obj.onclick=CheckLastRow;
	}
}

function CheckLastRow() {
	var tbl=document.getElementById("tOEOrder_Admixture");
	if ((tbl)&&(tbl.rows.length <= 2)) {
		alert(t["LAST_ROW"]);
		return false;
	}
	return;
}

//log 60201, 18-08-2006, Bo: add cat and sub-cat lookup
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
	var iobj=document.getElementById("Item");
	if (iobj) iobj.value="";
	var dobj=document.getElementById("Dosage");
	if (dobj) dobj.value="";
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

function SubCatChangeHandler() {
	if ((scobj) && (scobj.value=="")) {
		var subcatobj=document.getElementById("subCatID");
		if (subcatobj) subcatobj.value="";
	}
}
function checkBlank(){
	var catobj=document.getElementById("catID");
	var subcatobj=document.getElementById("subCatID");
	if (cobj.value=="") {
		catobj.value="";
		cobj.value="";
		scobj.value="";
		subcatobj.value="";
	}
	if(scobj.value=="") {
		scobj.value="";
		subcatobj.value=""
	}
}
// end of log 60201

//Log 62554 PeterC 13/04/07
var frm=document.fOEOrder_Admixture;
var mobj=document.getElementById("Mode");
if((mobj)&&((mobj.value=="READONLY")||(mobj.value=="PARTIALREAD"))) DisableAllButTwo(frm,"READONLY");

function BlankClickHandler() {
	return false;
}

function DisableAllButTwo(eForm,mode){
	var aobj=document.getElementById("AddItem");
	if(aobj) {
 		aobj.onclick=BlankClickHandler;
		aobj.disabled=true;
	}
	var tbl=document.getElementById("tOEOrder_Admixture");
	if (tbl) {
		for(var i=length;i<tbl.rows.length;i++) {
			var Obj=document.getElementById("Removez"+i);
			if(Obj) Obj.onclick=BlankClickHandler;
		}
	}
	
    var iNumElems = eForm.elements.length;     //for only form elements.
    	var enabledfldnames="";
	var readonlyfldnames="";
    	for (var i=0; i<iNumElems; i++)  {
        var eElem = eForm.elements[i];
        if ((enabledfldnames.indexOf(","+eElem.name+",")==-1)&&(eElem.type!="hidden")&&(readonlyfldnames.indexOf(","+eElem.name+",")==-1)&&(eElem.readOnly==false)) {
		if (("hidden" != eElem.type)&&("INPUT" == eElem.tagName) || ("TEXTAREA" == eElem.tagName)) {
                eElem.disabled = true;
                var img=document.getElementById("ld2184i"+eElem.id); //to hid the images for the brokers.
                //if (img) img.onclick="";
                if (img) { img.style.visibility="hidden"; }
            } else if ("SELECT" == eElem.tagName) {
                var cOpts = eElem.options;
                var iNumOpts = cOpts.length;
                for (var j=0; j<iNumOpts; j++) {
                    var eOpt = cOpts[j];
                    eOpt.disabled = true;
                }
            }
	}
    }
}
