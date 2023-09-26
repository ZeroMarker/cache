// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var group=document.getElementById("StkTakeGroup");
var cat=document.getElementById("StkTakeCat");
var item=document.getElementById("item");
var all=document.getElementById("showall");
var add=document.getElementById("add");

if (group) group.onblur=LookUpOnBlur;
if (cat) cat.onblur=LookUpOnBlur;
if (item) item.onblur=LookUpOnBlur;
if (all) all.onchange=ShowAll;
if (add) add.onclick=AddHandler;

function itemLookUpHandler(str) {
	var id=document.getElementById("itemID");
	if (id) id.value=mPiece(str,"^",1);
}
	
function StockTakeGroupLookUpHandler(str) {
	var id=document.getElementById("StkTakeGroupID");
	if (id) id.value=mPiece(str,"^",1);
}

function StockTakeCatLookUpHandler(str) {
	var id=document.getElementById("StkTakeCatID");
	if (id) id.value=mPiece(str,"^",1);
}

function LookUpOnBlur() {
	if (this.value=="") {
		var id=document.getElementById(this.id+"ID");
		if (id) id.value="";
	}
}

function ShowAll() {
	var all=document.getElementById("all");
	if(all) {
		if(this.checked) all.value=1;
		else all.value=0;
	}
}

function AddHandler() {
	var data = "";
	
	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			var qty=document.getElementById("INRQIReqQtyz"+i);
			var uomLst=document.getElementById("INRQICTUOMDRz"+i);
			var rowid=document.getElementById("rowidz"+i);
			if(rowid&&qty&&uomLst) data+=qty.value+"*"+uomLst.selectedIndex+"*"+rowid.value+"^";
			//mPiece(uomLst.value,String.fromCharCode(1),0)
		}
	}
	var itemData=document.getElementById("InputVal");
	if (itemData) itemData.value=data;
	
	add_click();
}