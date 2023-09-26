// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var mergedlink = "-> ";

//workflow item constructor
var TableItems = new Array();
function TableItem(list,column,title,width,show,delim,enablesort) {
	this.column=column;
	this.width=width;
	this.enablesort=enablesort;
	if (!delim) delim="";
	this.delim=delim;
	if (delim!="") title=mergedlink+delim+title;
	//and add to list... (with pointer to the array of items)
	var opt = new Option(title,list.length);
	opt.value=TableItems.length;
	if (show==true) {
		opt.style.color='black';
		opt.style.backgroundColor='LightGrey';
	} else {
		opt.style.color='darkgray';
		opt.style.backgroundColor='';
	}
	list[list.length] = opt;
	return this;
}
function DisableLink() {
	return false;
}
function Init() {
	// ab 14.05.07 63514 - to fix bug with IE6, 'onClick' always returns -1, so use onChange
	lstItems.onchange=ItemsClickHandler;
	var obj=document.getElementById('Update');
	if (obj) obj.onclick=UpdateClickHandler;
	var obj=document.getElementById('Delete');
	if (obj) obj.onclick=DeleteClickHandler;
	var obj=document.getElementById('Up');
	if (obj) obj.onclick=UpClickHandler;
	var obj=document.getElementById('Top');
	if (obj) obj.onclick=TopClickHandler;
	var obj=document.getElementById('Bottom');
	if (obj) obj.onclick=BottomClickHandler;
	var obj=document.getElementById('Down');
	if (obj) obj.onclick=DownClickHandler;
	var obj=document.getElementById('HideShow');
	if (obj) obj.onclick=HideShowClickHandler;

	el=document.getElementById('Width'); if (el) el.onchange=WidthChangeHandler;
	el=document.getElementById('EnableSort'); if (el) el.onchange=EnableSortChangeHandler;
	if (isnested) {
		el=document.getElementById('Print'); if (el) {el.checked=false; el.disabled=true;}
		el=document.getElementById('Rows'); if (el) {el.className='disabledField'; el.disabled=true;}
	}

	//lstItems.multiple=false;

	InitList();

	if (txtMerge) txtMerge.onchange=MergeChangeHandler;
	if (document.getElementById('PREFID').value!="") {
		document.getElementById('Delete').disabled=true;
		document.getElementById('Delete').onclick=DisableLink;
	}
	if (cbxUseContext) SetCheckbox(cbxUseContext,arrContext[0]);
	if (cbxUseContext2) SetCheckbox(cbxUseContext2,arrContext[1]);
	if (cbxUseContext3) SetCheckbox(cbxUseContext3,arrContext[2]);

	//disable those items which aren't (yet?) implemented for lookup lists
	//this gets set in the component method
	if (compdisplaytype=='K') {
		var objs=new Array("Width","EnableSort","Merge","Wrap","FixedWidth","ExpandTree","Rows","Print","SortColumnDefault","SortOrderDefault","ld5iSortColumnDefault","ld5iSortOrderDefault","SortColumn2","ld5iSortColumn2","SortOrder2","ld5iSortOrder2");
		for (var j=0;j<16;j++) {
			var obj=document.getElementById(objs[j]);
			if (obj) {
				obj.disabled=true;
				obj.className='disabledField';
			}
		}
	}
	if (compdisplaytype=='KLU') {
		var objs=new Array("Top","Up","Down","Bottom","EnableSort","Merge","Wrap","FixedWidth","ExpandTree","Print","SortColumnDefault","SortOrderDefault","ld5iSortColumnDefault","ld5iSortOrderDefault","SortColumn2","ld5iSortColumn2","SortOrder2","ld5iSortOrder2");
		for (var j=0;j<objs.length;j++) {
			var obj=document.getElementById(objs[j]);
			if(obj){
				if(obj.tagName=="A"){
					obj.setAttribute("disabled",true);
		            obj.removeAttribute('href');
		            obj.style.color="gray";
		            obj.onclick = emptyFun;
				}else{
					obj.disabled=true;
					obj.className='disabledField';
				}
			}
		}
	}
	if (compdisplaytype=='KG') {
		//"EnableSort",
		var objs=new Array("Merge","Wrap","FixedWidth","ExpandTree","Print","SortColumnDefault","SortOrderDefault","ld5iSortColumnDefault","ld5iSortOrderDefault","SortColumn2","ld5iSortColumn2","SortOrder2","ld5iSortOrder2","FontSize");
		for (var j=0;j<objs.length;j++) {
			var obj=document.getElementById(objs[j]);
			if(obj){
				if(obj.tagName=="A"){
					obj.setAttribute("disabled",true);
		            obj.removeAttribute('href');
		            obj.style.color="gray";
		            obj.onclick = emptyFun;
				}else{
					obj.disabled=true;
					obj.className='disabledField';
				}
			}
		}
	}
}
function emptyFun(event){return false;}
//this needs to be called after the captions are dumped
function BodyLoadHandler() {
	if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;
	if (tsc['Delete']) websys_sckeys[tsc['Delete']]=DeleteClickHandler;
	document.getElementById('SaveAs').innerText="";
}
function InitList() {
	// Get the data from the hidden fields into the list
	//TN:moved line below out for global use
	//var aCaptions=document.getElementById('HCAPTIONS').value.split(',');
	var sColumns=',' + document.getElementById('HCOLUMNS').value + ',';
	var aColumns=document.getElementById('HCOLUMNS').value.split(',');
	var aWidths=document.getElementById('HWIDTHS').value.split(',');
	var aDelims=document.getElementById('HDELIMS').value.split('^');
	var aEnableSort=document.getElementById('HENABLESORT').value.split(',');

	// Columns to show (in sequence)
	for (var j=0;j<aColumns.length-1;j++) {
		if (aColumns[j]!='') {
			TableItems[TableItems.length]=new TableItem(lstItems,aColumns[j],aCaptions[aColumns[j]-1],aWidths[j],true,aDelims[aColumns[j]-1],aEnableSort[j]);
		}
	}
	//Columns to hide (i.e. all columns that are not in the column to show
	for (var j=0;j<aCaptions.length;j++) {
		if (aCaptions[j]!='') {
			if (sColumns.indexOf(','+(j+1)+',')==-1) {
				TableItems[TableItems.length]=new TableItem(lstItems,j+1,aCaptions[j],aWidths[j],false,"",0);
			}
		}
	}
}
function UpClickHandler() {
	var i=lstItems.selectedIndex;
	var len=lstItems.length;

	if ((len>1)&&(i>0)) {
		//Swap(i,i-1)
		Shift(i-1);
	}
	window.event.returnValue = false;
	return false;
}

function TopClickHandler() {
	var i=lstItems.selectedIndex;
	var len=lstItems.length;

	if ((len>1)&&(i!=-1)) {
		//Swap(i,0)
		Shift(0)
	}
	window.event.returnValue = false;
	return false;
}
function BottomClickHandler() {
	var i=lstItems.selectedIndex;
	var len=lstItems.length;

	if ((len>1)&&(i!=-1)) {
		//Swap(i,len-1)
		Shift(len-1);
	}
	window.event.returnValue = false;
	return false;
}

function DownClickHandler() {
	var i=lstItems.selectedIndex;
	var len=lstItems.length;
	if ((len>1)&&(i<(len-1))) {
		//Swap(i,i+1)
		Shift(i+1);
	 }
	 window.event.returnValue = false;
	 return false;
}

// ab 6.04.04 - moves all selected rows to position 'a'
function Shift(a) {
	//first build an array of all selected rows, then remove them
	var SelRows=new Array();
	var k=0;
	for (var i=0;i<lstItems.length;i++) {
		if (lstItems[i].selected) {
			SelRows[k]=lstItems[i];
			k++;
		}
	}
	for (var i=0;i<lstItems.length;i++) {
		if (lstItems[i].selected) {
			lstItems.remove(i);
			i--;
		}
	}
	if (a>lstItems.length) a=lstItems.length;
	
	// add new rows
	for (var j=0;j<SelRows.length;j++) {
		var CurrRow=SelRows[j];
		var elOptNew=new Option(CurrRow.text,CurrRow.value);
		
		elOptNew.column=CurrRow.column;
		elOptNew.width=CurrRow.width;
		elOptNew.enablesort=CurrRow.enablesort;
		elOptNew.delim=CurrRow.delim;
		elOptNew.style.color=CurrRow.style.color;
		elOptNew.style.backgroundColor=CurrRow.style.backgroundColor;
		
		try {
		      lstItems.add(elOptNew, lstItems[a]); // standards compliant; doesn't work in IE
		}
		catch(ex) {
			lstItems.add(elOptNew,a); // IE only
		}
		
		// select the new rows
		if (lstItems[a]) {
			lstItems[a].selected=true;
		}
		a++;
	}
}

function Swap(a,b) {
	//Swap position and style of two options
	//We used to just remove then add - but this didn't work in NS6
	var opta=lstItems[a];
	var optb=lstItems[b];
	lstItems[a]= new Option(optb.text,optb.value);
	lstItems[a].style.color=optb.style.color;
	lstItems[a].style.backgroundColor=optb.style.backgroundColor;
	lstItems[b]= new Option(opta.text,opta.value);
	lstItems[b].style.color=opta.style.color;
	lstItems[b].style.backgroundColor=opta.style.backgroundColor;
	lstItems.selectedIndex=b;
}

function ItemsClickHandler() {
	var i=lstItems.selectedIndex;
	var len=lstItems.options.length;
	
	if ((len>0)&&(i>-1)) {
		//pointer to collection
		
		var ptr=lstItems.options[i].value;
		var ob=TableItems[ptr];
		//alert(ptr+"^"+TableItems[ptr].width+"^"+txtWidth.value);
		txtWidth.value=TableItems[ptr].width;
		if (txtEnableSort) {
			if (TableItems[ptr].enablesort==1) {
				txtEnableSort.checked=true;
			} else {
				txtEnableSort.checked=false;
			}
		}
		if (txtMerge) txtMerge.value=TableItems[ptr].delim;
	}
}

function GetSelectedRows() {
	var SelRows=new Array();
	for (var i=0;i<lstItems.length;i++) {
		if (lstItems[i].selected) SelRows.push(i);
	}
	return SelRows;
}

function HideShowClickHandler() {
	var i=lstItems.selectedIndex;
	var len=lstItems.length;
	
	var SelRows=GetSelectedRows();
	
	if ((len>1)&&(i>-1)) {
		for (var j=0;j<SelRows.length;j++) {
			i=SelRows[j];
			//by wanghc 20151012 在chrome下darkgray变成rb(169,169,169),不是字符串 
			var colr=lstItems[i].style.backgroundColor;	//color -->backgroundColor;
			if (colr=="") {	//colr=='darkgray' -> colr==""
				lstItems[i].style.color='black';
				lstItems[i].style.backgroundColor='LightGrey';
			} else {
				lstItems[i].style.color='darkgray';
				lstItems[i].style.backgroundColor='';
				lstItems.selectedIndex=-1;
			}
		}
	}
	window.event.returnValue = false;
	return false;
}
function UpdateClickHandler() {
	var type=document.getElementById('HSAVEAS').value;
	var SaveAsVal=document.getElementById('SaveAs').innerText;
	if (SaveAsVal==""){
		alert("请点击保存菜单,选择类型!");
		window.event.returnValue = false;
		return false;
	}
	/// GetDesc(type)
	if (confirm(t['UpdateApplied'] + ' ' + SaveAsVal)) {
		var t1='';
		var t2='';
		var t3='';
		var t4='';
		var ptr;

		var resetMerge=0; arrt3=new Array();
		for (j=0; j<lstItems.length; j++) {
			ptr=lstItems[j].value;
			if (lstItems[j].style.color=='black') {
				t1 += TableItems[ptr].column + ",";
				t2 += TableItems[ptr].width + ",";
				//t3 += TableItems[ptr].delim + "^";
				arrt3[(TableItems[ptr].column)-1]=TableItems[ptr].delim;
				t4 += TableItems[ptr].enablesort + ",";
			} else {
				arrt3[(TableItems[ptr].column)-1]="";
			}
		}
		t3 = arrt3.join("^");

		frm.HCOLUMNS.value=t1;
		frm.HWIDTHS.value=t2;
		frm.HDELIMS.value=t3;
		frm.HENABLESORT.value=t4;
		frm.target='_self';
		return Update_click();
	} else {
		window.event.returnValue = false;
		return false;
	}
}
function DeleteClickHandler() {
	var type=document.getElementById('HSAVEAS').value;
	if (confirm(t['DeleteApplied'] + ' ' + GetDesc(type))) {
		var t1='';
		var t2='';
		var t4='';
		frm.HCOLUMNS.value=t1;
		frm.HWIDTHS.value=t2;
		frm.target='_self';
		frm.HENABLESORT.value=t4;
		return Delete_click();
	} else {
		window.event.returnValue = false;
		return false;
	}
}
function WidthChangeHandler() {
	var i=lstItems.selectedIndex;
	var len=lstItems.options.length;
	if ((len>0)&&(i>-1)) {
		//pointer to collection
		var ptr=lstItems.options[i].value;
		TableItems[ptr].width=txtWidth.value;
	}
}
function EnableSortChangeHandler() {
	var i=lstItems.selectedIndex;
	var len=lstItems.options.length;
	if ((len>0)&&(i>-1)) {
		//pointer to collection
		var ptr=lstItems.options[i].value;
		if (txtEnableSort.checked==true) {
			TableItems[ptr].enablesort=1
		} else {
			TableItems[ptr].enablesort=0
		}
	}
}
function MergeChangeHandler() {
	var i=lstItems.selectedIndex;
	var len=lstItems.options.length;
	var delim=txtMerge.value;
	if (delim.indexOf("^")>=0) {
		alert(t['Merge'] + " " + t['XINVALID']);
		txtMerge.value="";
		return false;
	}
	if ((len>1)&&(i>-1)) {
		//pointer to collection
		var ptr=lstItems.options[i].value;
		TableItems[ptr].delim=delim;
		if (delim=="") {lstItems.options[i].text=aCaptions[TableItems[ptr].column-1];}
		else {lstItems.options[i].text=mergedlink+delim+aCaptions[TableItems[ptr].column-1];}
	}
}
function UseContextChangeHandler(evt) {
	var cbx=websys_getSrcElement(evt);
	if ((cbxSelected)&&(cbxSelected!=cbx)) cbxSelected.checked=false; 
	cbxSelected=cbx;
	document.getElementById('SaveAs').innerText=GetDesc(frm.HSAVEAS.value);
	var contx=document.getElementById('HCONTEXT');
	if ((cbxSelected)&&(cbxSelected.checked)) {
		switch (cbxSelected.id) {
			case "UseContext":
				contx.value=arrContext[0];
				break;
			case "UseContext2":
				contx.value=arrContext[1];
				break;
			case "UseContext3":
				contx.value=arrContext[2];
				break;
			default:
				break;
		}
	} else {
		contx.value="";
	}
}

function SetSaveAs(type) {
	document.getElementById('SaveAs').innerText = GetDesc(type);
	frm.HSAVEAS.value=type;
}
function GetDesc(type) {
	var desc="";
	switch (type) {
		case 'G' : desc = local['LOGON.GROUPDESC'];
			break;
		case 'H' : desc = local['LOGON.HOSPDESC'];
			break;
		case 'R' : desc = local['LOGON.TRUSTDESC'];
			break;
		case 'T' : desc = local['LOGON.SITECODE'];
			break;
		case 'N' : desc = local['LOGON.REGION'];
			break;
		case 'S' : desc = local['SYSTEM'];
			break;
		default : desc = local['LOGON.USERCODE'];
			break;
	}
	//if ((cbxUseContext)&&(cbxUseContext.checked)) desc += " " + session['CONTEXT'];
	if ((cbxUseContext)&&(cbxUseContext.checked)) desc += " " + arrContext[0];
	else if ((cbxUseContext2)&&(cbxUseContext2.checked)) desc += " " + arrContext[1];
	else if ((cbxUseContext3)&&(cbxUseContext3.checked)) desc += " " + arrContext[2];
	return desc;
}
function SetCheckbox(cbx,val) {
	cbx.onclick=UseContextChangeHandler;
	if (document.getElementById('PREFID').value!="") cbx.disabled=true;
	//if (session['CONTEXT']=="") cbx.disabled=true;
	if ((val)&&(val!="")) {
		var lblContx=document.createElement("LABEL");
		lblContx.innerHTML = "&nbsp;&nbsp;"+val;
		cbx.insertAdjacentElement("afterEnd",lblContx);
	} else cbx.disabled=true;
	if (cbx.checked) {cbxSelected=cbx; document.getElementById('HCONTEXT').value=val;}

}
var frm=document.getElementById('fwebsys_Component_CustomiseLayout');
var lstItems=document.getElementById('Columns');
var txtWidth=document.getElementById('Width');
var txtEnableSort=document.getElementById('EnableSort');
var aCaptions=document.getElementById('HCAPTIONS').value.split('^');
var txtMerge=document.getElementById('Merge');
var cbxUseContext=document.getElementById('UseContext');
var cbxUseContext2=document.getElementById('UseContext2');
var cbxUseContext3=document.getElementById('UseContext3');
var cbxSelected=null;
var arrContext=session['CONTEXT'].split(",");
Init();
document.body.onload=BodyLoadHandler;