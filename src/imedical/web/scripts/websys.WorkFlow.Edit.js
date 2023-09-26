// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var frm;
var lstItems;
var WorkflowItems=new Array();

//workflow item constructor
function WorkflowItem(list,page,expression,condition) {
	this.page=page;
	this.expression=expression;
	this.condition=condition;
	//and add to list... (with pointer to the array of items)
	list.options[list.length] = new Option(page,WorkflowItems.length);
	return this;
}

function ItemLookupSelect(txt) {
	var adata=txt.split("^");
	document.getElementById('WorkFlowItem').value="";
	WorkflowItems[WorkflowItems.length]=new WorkflowItem(lstItems,adata[0],'','');
}

function Init() {

	var obj=document.getElementById('Items');
	if (obj) obj.onclick=ItemsClickHandler;
	var obj=document.getElementById('Up');
	if (obj) obj.onclick=UpClickHandler;
	var obj=document.getElementById('Down');
	if (obj) obj.onclick=DownClickHandler;
	var obj=document.getElementById('Delete'); //item in a workflow
	if (obj) obj.onclick=DeleteClickHandler; 
	var obj=document.getElementById('delete1'); //The entire workflow
	if (obj) obj.onclick=delete1ClickHandler;
	var obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateClickHandler;
	var obj=document.getElementById('TransitionExpression');
	if (obj) obj.onchange=ExpressionChangeHandler;
	var obj=document.getElementById('ConditionalExpression');
	if (obj) obj.onchange=ExpressionChangeHandler;
	var obj=document.getElementById('Loop');
	if (obj) obj.onclick=LoopingClickHandler;
	var obj=document.getElementById('CycleSelection');
	if (obj) obj.onclick=LoopingClickHandler;
	var obj=document.getElementById('JumpToList');
	if (obj) obj.onclick=LoopingClickHandler;
	
	lstItems.multiple=false;

	//InitList();
	var t1=document.getElementById('HPageList').value;
	var t2=document.getElementById('HExpressionList').value;
	var t3=document.getElementById('HConditionalList').value;
	var t1a=t1.split('|');
	var t2a=t2.split('|');
	var t3a=t3.split('|');
	if (t1!="") {
		for (var j=0; j<t1a.length; j++) {
			WorkflowItems[WorkflowItems.length]=new WorkflowItem(lstItems,t1a[j],t2a[j],t3a[j]);
		}
	}
	
	CheckTrakOptions();
}

function ItemsClickHandler() {
	//pointer to collection
	if ((lstItems.options.length>=1)&&(lstItems.selectedIndex!=-1)) {
		var ptr=lstItems.options[lstItems.selectedIndex].value;
		document.getElementById('TransitionExpression').value=WorkflowItems[ptr].expression;
		document.getElementById('ConditionalExpression').value=WorkflowItems[ptr].condition;
	}
}

function ExpressionChangeHandler() {
	//pointer to collection
	if (lstItems.options.length>=1) {
		var ptr=lstItems.options[lstItems.selectedIndex].value;
		WorkflowItems[ptr].expression=document.getElementById('TransitionExpression').value;
		WorkflowItems[ptr].condition=document.getElementById('ConditionalExpression').value;
	}
}

function UpClickHandler() {
	var i=lstItems.selectedIndex;
	if (lstItems.options.length>1) {
		if (i>0) {
			var opt=lstItems.options[i];
			lstItems.options.remove(i);
			lstItems.options.add(opt, i-1);
		}
	}
	return false;
}

function DownClickHandler() {
	var i=lstItems.selectedIndex;
	var len=lstItems.options.length;
	if (len>1) { 
		if (i<(len-1)) {
			var opt=lstItems.options[i+1];
			lstItems.options.remove(i+1);
			lstItems.options.add(opt, i);
		}
	}
	return false;
}

function DeleteClickHandler() {
	//to keep the index pointers correct we do not delete from WorkflowItems
	//GR 28/3/03
	if (confirm(t["DELETE"])) {
		var i=lstItems.selectedIndex;
		if (i>-1) {
			lstItems.options.remove(i);
			var obj=document.getElementById('TransitionExpression');
			if (obj) obj.value="";
			var obj=document.getElementById('ConditionalExpression');
			if (obj) obj.value="";
		}
	}
	return false;
}
function UpdateClickHandler() {
	var t1='';
	var t2='';
	var t3='';
	var ptr;
	for (j=0; j<lstItems.options.length; j++) {
		ptr=lstItems.options[j].value;
		t1 += WorkflowItems[ptr].page + "|";
		t2 += WorkflowItems[ptr].expression + "|";
		t3 += WorkflowItems[ptr].condition + "|";
	}
	document.getElementById('HPageList').value=t1;
	document.getElementById('HExpressionList').value=t2;
	document.getElementById('HConditionalList').value=t3;
	return update1_click();
}

function delete1ClickHandler() {
	//check before deleting entire workflow
	if (confirm(t["DELETEALL"])) {return delete1_click()} else {return false;}
}

function LoopingClickHandler(e) {
	//if LoopinBackToStart, cannot CycleSelection nor JumpToList at the same time.
	//you can JumpToList and CycleSelection at the same time
	var eSrc=websys_getSrcElement(e);
	if (eSrc.id=="Loop") {
		var obj=document.getElementById('CycleSelection');
		if (obj) obj.checked=false;
		var obj=document.getElementById('JumpToList');
		if (obj) obj.checked=false;
	}
	if (eSrc.id=="CycleSelection") {
		var obj=document.getElementById('Loop');
		if (obj) obj.checked=false;
	}
	if (eSrc.id=="JumpToList") {
		var obj=document.getElementById('Loop');
		if (obj) obj.checked=false;
	}
}

// ab 8.03.07 62951 - disable all fields on screen for TRAK workflows if "Enable Trak Options" is not checked
function CheckTrakOptions() {
	var objid=document.getElementById("ID");
	var obj=document.getElementById("EnableTrakOptions");
	if ((obj)&&(obj.value!=1)&&(objid)&&(objid.value!="")&&(objid.value<50000)) {
		DisableAllFields(0,",update1,CycleSelection,JumpToList,Loop,",0)
		
		var obj=document.getElementById("CycleSelection");
		if (obj) obj.onclick=DisableCheck;
		var obj=document.getElementById("JumpToList");
		if (obj) obj.onclick=DisableCheck;
		var obj=document.getElementById("Loop");
		if (obj) obj.onclick=DisableCheck;
	}
}

function DisableCheck() {
	return false;
}

frm=document.fwebsys_WorkFlow_Edit;
lstItems=frm.Items;

document.body.onload=Init; 