// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

//The following functions are generic functions for manipulating Data in List Boxes (SELECT)

//This function removes ALL the options from a listbox(obj)
function ClearAllList(obj) {
	for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
}
//This function removes all the SELECTED options from a listbox(obj)
function ClearSelectedList(obj) {
	for (var i=obj.options.length-1; i>=0; i--) {
		if (obj.options[i].selected) obj.options[i] = null;
	}
}
//This function converts delimited strings to an array in preperation for sending to AddItemToList method.
function callAddItemToList(obj,txtstr,valstr,fcs,delim,descdelim) {
    if ((!delim)||(delim=="")) delim=",";
    if ((!descdelim)||(descdelim=="")) descdelim=",";
	var arytxt=txtstr.split(descdelim); 
	var aryval=valstr.split(delim);
	var arytxtNew = new Array();
	var aryvalNew = new Array();
	var k=0; var match=0;
	//KM 13-Jul-2002: check for duplicates
	//alert(aryval.length);
	for (j=0;j<aryval.length;j++) {
		match=0;
		for (i=0;i<obj.length;i++) {
			if (obj.options[i].value==aryval[j]) {match=1;break}
		}
		if (match==0) {aryvalNew[k]=aryval[j];arytxtNew[k]=arytxt[j];k++}
	}
	AddItemToList(obj,arytxtNew,aryvalNew);
	//if (fcs!="0") fcs.focus();
}
//This function receives one array for the listbox values (aryval) and another for its text (arytxt).  It then adds these to the required listbox (obj)
function AddItemToList(obj,arytxt,aryval) {
	if (arytxt.length>0) {
		if (arytxt[0]!="") {
			var lstlen=obj.length;
			for (var i=0;i<arytxt.length;i++) {obj.options[lstlen] = new Option(arytxt[i],aryval[i]); lstlen++;}
		}
	}
}
//This function is a simple AddItemToList for one item, not an array of items
function AddItemSingle(lst,val,txt) {
	lst.options[lst.options.length] = new Option(txt,val);
}

//This function takes the returned value from a LookUp and formats it for processing by the AddItemToList function
function TransferToList(obj,val,delim) {
    if ((!delim)||(delim=="")) delim=",";
	var found=0
	ary=val.split("^");
	arytxt=ary[0].split(delim);
	aryval=ary[1].split(delim);
	for (var i=0;i<obj.length;i++) {if (obj.options[i].value==ary[1]) found=1;}
	if (found==0) AddItemToList(obj,arytxt,aryval);
}

//Returns an ary of option values in a select box.
function returnValues(obj) {
	var ary=new Array();
	for (var i=0; i<obj.length; i++) ary[i]=obj.options[i].value;
	return ary;
}
//highlights options in a select box (obj) according to the contents of a linear array (arysel);
function selectOptions(obj,arysel) {
	for (var i=0;i<obj.length;i++) {
		if (arysel[i]=="false") arysel[i]=false;
		if (arysel[i]=="true") arysel[i]=true;
		obj.options[i].selected=arysel[i];
	}
}
//The next three functions control the movement of a selected options up and down a list box (obj)
function UpClick(obj) { 
	var i=obj.selectedIndex;
	var len=obj.length;
	if ((len>1)&&(i>0)) Swap(obj,i,i-1)
	return false; 
} 
function DownClick(obj) { 
	var i=obj.selectedIndex; 
	var len=obj.length; 
	if ((len>1)&&(i>=0)&&(i<(len-1))) Swap(obj,i,i+1) 	
	return false;
}
function Swap(lst,a,b) { //Swap position and style of two options
	var opta=lst.options[a];
	var optb=lst.options[b];
	lst.options[a] = new Option(optb.text,optb.value);
	lst.options[b] = new Option(opta.text,opta.value);
	lst.options[a].selected = optb.selected;
	lst.options[b].selected = opta.selected;
}

function SwapToList(lstFrom,lstTo,highlightSelected) {
	for (var j=0; j<lstFrom.options.length; j++) {
		var opt = lstFrom.options[j];
		if (opt.selected) {
			AddItemSingle(lstTo,opt.value,opt.text);
			if (highlightSelected) lstTo.options[lstTo.options.length-1].selected = true;
		}
	}
	ClearSelectedList(lstFrom);
}


//Actually this function is a general array utilitiy and does not really belong in this
//javascript file but I will sort this out later (KM 8-Feb-2001)
//sends in an array (aryval) and searches another array (aryallval) for matches and returns array of corrisponding text values
function loopArrayForMatches(aryallval,aryalltxt,aryval) {
	var arytxt=new Array();
	var count=0
	for (var i=0;i<aryallval.length;i++) {
		for (var j=0;j<aryval.length;j++) {
			if (aryallval[i]==aryval[j]) {arytxt[count]=aryalltxt[i];count++}
		}
	}
	return arytxt;
}

//Chandana 23/8/04
//This function removes the passed item (rmId) from the list
function RemoveItemSingle(list, rmId){
	for (var i=0; i<list.options.length; i++) {
		if (list.options[i].value == rmId){
			 list.options[i] = null;
			return;
		}
	}
}
