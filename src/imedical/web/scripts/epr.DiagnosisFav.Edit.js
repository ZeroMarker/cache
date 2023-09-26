// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 17.07.06 59776

function BodyLoadHandler() {
	LoadParams();
	ColourDiagRows();

	var obj=document.getElementById("RemDiag");
	if (obj) obj.onclick=RemoveItems;
	
	var obj=document.getElementById("ShiftUp");
	if (obj) obj.onclick=ShiftUp;
	var obj=document.getElementById("ShiftDown");
	if (obj) obj.onclick=ShiftDown;
	var obj=document.getElementById("ShiftLeft");
	if (obj) obj.onclick=ShiftLeft;
	var obj=document.getElementById("ShiftRight");
	if (obj) obj.onclick=ShiftRight;
	var obj=document.getElementById("SaveLvl");
	if ((obj)&&(obj.value=="")) SetSaveAs("U");
	
	var obj=document.getElementById("update1");
	if (obj) {
		obj.onclick=UpdateHandler;
		if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateHandler;
	}
	
	var obj=document.getElementById("AddOrder");
	if (obj) obj.onclick=AddOrderClickHandler;
	
	// only able to select items from one listboxes at a time
	var obj=document.getElementById("DiagList1");
	if (obj) obj.onclick=Diag1ClickHandler;
	
	var obj=document.getElementById("DiagList2");
	if (obj) obj.onclick=Diag2ClickHandler;
}

// highlight rows with order items/sets defined
function ColourDiagRows() {
	var lists = new Array("DiagList1","DiagList2");
	for (var j=0;j<lists.length; j++) {
		var obj=document.getElementById(lists[j]);
		for (var i=0; i<obj.length; i++) {
			if (obj.options[i].OrderString!="") {
				obj.options[i].className="clsDiagOrd";
			} else {
				obj.options[i].className="";
			}
		}
	}
}

function Diag1ClickHandler() {
	var obj=document.getElementById("DiagList2");
	if (obj) selectOptions(obj,"");
}

function Diag2ClickHandler() {
	var obj=document.getElementById("DiagList1");
	if (obj) selectOptions(obj,"");
}

function LoadParams() {
	// load params from websys.preferences into fields
	// diagnosis lists are populated through lookup
	var OrderCodes1="";
	var OrderCodes2="";
	var param=document.getElementById("Params");
	if (param) param=param.value;
	
	if (param!="") {
		param=param.split(String.fromCharCode(1));
		//alert(param);
		
		var obj=document.getElementById("ListLabel1");
		if (obj) obj.value=param[0];
		var obj=document.getElementById("ListLabel2");
		if (obj) obj.value=param[1];
		var obj=document.getElementById("DiagCodes1");
		if (obj) obj.value=param[2];
		var obj=document.getElementById("DiagCodes2");
		if (obj) obj.value=param[3];
		var obj=document.getElementById("OrderCodes1");
		if (obj) {
			obj.value=param[4];
			OrderCodes1=param[4].split("^");
		}
		var obj=document.getElementById("OrderCodes2");
		if (obj) {
			obj.value=param[5];
			OrderCodes2=param[5].split("^");
		}
		
		// add OrderString to each diagnosis in list
		var obj=document.getElementById("DiagList1");
		if (obj) {
			for (var j=0;j<obj.length; j++) {
				obj.options[j].OrderString=OrderCodes1[j];
			}
		}
		var obj=document.getElementById("DiagList2");
		if (obj) {
			for (var j=0;j<obj.length; j++) {
				obj.options[j].OrderString=OrderCodes2[j];
			}
		}
		
	}
	
	var obj=document.getElementById("ObjectType");
	if (obj) {
		if (obj.value=="User.SSUser") SetSaveAs("U");
		if (obj.value=="User.CTLoc") SetSaveAs("L");
		if (obj.value=="User.SSGroup") SetSaveAs("G");
		if (obj.value=="SITE") SetSaveAs("T");
	}
}

function UpdateHandler() {
	SetCodes();
	
	return update1_click();
}

function SetCodes() {
	// set hidden strings to save in preferences
	
	var lists = new Array("DiagList1","DiagList2");
	for (var j=0;j<lists.length; j++) {
		var obj=document.getElementById(lists[j]);
		var DiagCodes="";
		var OrderCodes="";
		for (var i=0; i<obj.length; i++) {
			//obj.options[i].OrderString=str;
			if (i>0) DiagCodes=DiagCodes+"^";
			DiagCodes=DiagCodes+obj.options[i].value;
			if (i>0) OrderCodes=OrderCodes+"^";
			if (obj.options[i].OrderString) OrderCodes=OrderCodes+obj.options[i].OrderString;
		}
		if (lists[j]=="DiagList1") var objdiag=document.getElementById("DiagCodes1");
		if (lists[j]=="DiagList2") var objdiag=document.getElementById("DiagCodes2");
		if (objdiag) objdiag.value=DiagCodes;
		if (lists[j]=="DiagList1") var objord=document.getElementById("OrderCodes1");
		if (lists[j]=="DiagList2") var objord=document.getElementById("OrderCodes2");
		if (objord) objord.value=OrderCodes;
	}
}

function SetOrder(str) {
	// takes string of order items/sets from epr.DiagnosisFavOrder.Edit, and assigns to all selected diagnosis
	
	var lists = new Array("DiagList1","DiagList2");
	for (var j=0;j<lists.length; j++) {
		var obj=document.getElementById(lists[j]);
		for (var i=0; i<obj.length; i++) {
			if (obj.options[i].selected==true) {
				obj.options[i].OrderString=str;
				//if (str!="") obj.options[i].style.fontWeight="bold";
			}
		}
	}
	ColourDiagRows();
}

function AddOrderClickHandler() {
	// check at least one item selected
	var AllowAdd=false;
	var lists = new Array("DiagList1","DiagList2");
	for (var j=0;j<lists.length; j++) {
		var obj=document.getElementById(lists[j]);
		for (var i=0; i<obj.length; i++) {
			if (obj.options[i].selected==true) AllowAdd=true;
		}
	}
	if (!AllowAdd) {
		alert(t["SelectDiag"]);
		return false;
	}
	
	// send all order items/sets for selected items
	var OrderString="";
	var lists = new Array("DiagList1","DiagList2");
	for (var j=0;j<lists.length; j++) {
		var obj=document.getElementById(lists[j]);
		for (var i=0; i<obj.length; i++) {
			if (obj.options[i].selected==true) {
				if (obj.options[i].OrderString) {
					//don't add to string if it is already in there
					if (("*"+OrderString+"*").indexOf("*"+obj.options[i].OrderString+"*")==-1) {
						if (OrderString!="") OrderString=OrderString+"*";
						OrderString=OrderString+obj.options[i].OrderString;
					}
				}
			}
		}
	}
	var ID=document.getElementById("ID");
	if (ID) ID=ID.value;
	var SaveLvl=document.getElementById("SaveLvl");
	if (SaveLvl) SaveLvl=SaveLvl.value;

	websys_lu("websys.default.csp?WEBSYS.TCOMPONENT=epr.DiagnosisFavOrder.Edit&OrderString="+OrderString+"&ID="+ID+"&SaveLvl="+SaveLvl);
}

function SetSaveAs(level) {
	var obj=document.getElementById("SaveLvl");
	if (obj) obj.value=level;
	var obj=document.getElementById("SaveLevel");
	var obj2=document.getElementById("Save"+level);
	if (obj) {
		obj.innerText=t["Save"+level];
		if (obj2) obj.innerText=obj.innerText+" ("+obj2.value+")";
	}
}

function DiagnosisLookup(str) {
	var lu=str.split("^");
	if (lu[2]!="") {
		var obj=document.getElementById("DiagList1");
		if (obj) {
			AddItemSingle(obj,lu[2],lu[0]);
			obj.options[obj.options.length-1].OrderString=lu[3];
		}
		var obj=document.getElementById("Diagnosis");
		if (obj) {
			obj.value="";
			websys_setfocus("Diagnosis");
		}
		
	}
	ColourDiagRows();
}

function RemoveItems() {
	var obj=document.getElementById("DiagList1");
	ClearSelectedList(obj);
	var obj=document.getElementById("DiagList2");
	ClearSelectedList(obj);
}

function ShiftUp() {
	var obj=document.getElementById("DiagList1");
	if (obj) UpClick2(obj);
	var obj=document.getElementById("DiagList2");
	if (obj) UpClick2(obj);
}

function ShiftDown() {
	var obj=document.getElementById("DiagList1");
	if (obj) DownClick2(obj);
	var obj=document.getElementById("DiagList2");
	if (obj) DownClick2(obj);
}

function ShiftLeft() {
	var obj1=document.getElementById("DiagList2");
	var obj2=document.getElementById("DiagList1");
	if ((obj1)&&(obj2)) SwapToList2(obj1,obj2,1);
}

function ShiftRight() {
	var obj1=document.getElementById("DiagList1");
	var obj2=document.getElementById("DiagList2");
	if ((obj1)&&(obj2)) SwapToList2(obj1,obj2,1);
}

//copied from websys.ListBoxes.js for modifiecation
function SwapToList2(lstFrom,lstTo,highlightSelected) {
	for (var j=0; j<lstFrom.options.length; j++) {
		var opt = lstFrom.options[j];
		if (opt.selected) {
			orders=opt.OrderString;
			AddItemSingle(lstTo,opt.value,opt.text);
			lstTo.options[lstTo.options.length-1].OrderString=orders;
			if (highlightSelected) lstTo.options[lstTo.options.length-1].selected = true;
		}
	}
	ClearSelectedList(lstFrom);
	ColourDiagRows();
}

function UpClick2(obj) { 
	var i=obj.selectedIndex;
	var len=obj.length;
	if ((len>1)&&(i>0)) Swap2(obj,i,i-1)
	return false; 
}

function DownClick2(obj) { 
	var i=obj.selectedIndex; 
	var len=obj.length; 
	if ((len>1)&&(i>=0)&&(i<(len-1))) Swap2(obj,i,i+1);
	return false;
}

function Swap2(lst,a,b) { //Swap position and style of two options
	var opta=lst.options[a];
	var optb=lst.options[b];
	lst.options[a] = new Option(optb.text,optb.value);
	lst.options[b] = new Option(opta.text,opta.value);
	lst.options[a].selected = optb.selected;
	lst.options[b].selected = opta.selected;
	lst.options[a].OrderString = optb.OrderString;
	lst.options[b].OrderString = opta.OrderString;
	ColourDiagRows();
}

document.body.onload = BodyLoadHandler;