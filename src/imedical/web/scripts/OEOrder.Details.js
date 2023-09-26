// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


function LookUpSubCatSelect(txt) {
	
	//ANA 26.03.02 Function to Return the SubCategory ID 

	var adata=txt.split("^");
	var subCatDesc=adata[0];
	var subCatID=adata[1];	
	var subCatCode=adata[2];
	var subcatobj=document.getElementById("subCatID");
	if (subcatobj) subcatobj.value=subCatID;
	var iobj=document.getElementById("Item");
	iobj.value="";
}

function UpdateClickHandler() {
	var par_win = window.opener;
	if (par_win) {
		//alert(par_win.name);
		//par_win.refreshParent()
	}
	Update_click();
	return (0);
}

function OrderItemLookupSelect(txt) {
		
	var adata=txt.split("^");
	var ItmDesc=adata[0];
	var ItmId=adata[1];	
	var iobj=document.getElementById("arcim");
	if (iobj) iobj.value=ItmId;
}

var uobj=document.getElementById("Update");
//if (uobj) uobj.onclick=UpdateClickHandler;