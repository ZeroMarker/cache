// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function LookUpCat(txt) {
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
}

function LookUpSubCat(txt) {
	//ANA 06.03.2002 Function to Return the SubCategory ID
	var adata=txt.split("^");
	var subCatDesc=adata[0];
	var subCatID=adata[1];
	var subCatCode=adata[2];
	var subcatobj=document.getElementById("subCatID");
	if (subcatobj) subcatobj.value=subCatID;
}

var cobj=document.getElementById("Category");
if (cobj) cobj.onchange=checkBlank;

//LOG 30799 02/12/02 PeterC: Commented out to prevent the Subcategory field from reseting
var scobj=document.getElementById("SubCategory");
if (scobj) scobj.onchange=SubCatChangeHandler;

var scobj=document.getElementById("update1");
if (scobj) scobj.onclick=UpdateRadWorkBench

function SubCatChangeHandler() {
	if ((scobj) && (scobj.value=="")) {
		var subcatobj=document.getElementById("subCatID");
		if (subcatobj) subcatobj.value="";
	}
}
function checkBlank() {
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

function OrderItemLookup(txt) {
	var adata=txt.split("^");
	var iobj=document.getElementById("Item");
	if (iobj) iobj.value=adata[0];
	var iIDobj=document.getElementById("arcimID");
	if (iIDobj) iIDobj.value=adata[1];
}

function UpdateRadWorkBench() {
	var iobj=document.getElementById("Item");
	var iIDobj=document.getElementById("arcimID");

	if ((iobj)&&(iIDobj)) {
		var obj=window.opener.document.getElementById("OrdItemDesc");
		if (obj) obj.value=iobj.value;
		var obj=window.opener.document.getElementById("OrdItemID");
		if (obj) obj.value=iIDobj.value;
	}

	return update1_click();
}