// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

f=document.fOEOrder_Edit_LabCummProfile;

//var obsgrpid="";

//create a global array (arrTestItems) matching testcodes with their descriptions, eg: arrTestItems['A010']='Full Blood Count';
//this avoids multiple looping for matches.
// Log 49041 - AI - 09-02-2005 : Change the way arrTestItems is built, because alltestsval and allteststxt have been broken up in epr.ctprofileparams.edit.csp.
var arrTestItems=new Array();
var arrTestDesc=new Array();
var arrtempval=new Array();
var arrtemptxt=new Array();
for (var i=1;i<testslen+1;i++) {
	arrtempval[i]=alltestsval[i].split('^');
	arrtemptxt[i]=allteststxt[i].split('^');
	for (var j=0;j<arrtempval[i].length;j++) {
		arrTestItems[arrtempval[i][j]]=arrtemptxt[i][j];
		arrTestDesc[arrtemptxt[i][j]]=arrtempval[i][j];
	}
}

var ParamDelim = String.fromCharCode(1);

function SortByCode() {
	return SortBy("CODE");
}
function SortByDesc() {
	return SortBy("DESC");
}

function ListBoxObject(value,text)
{
	this.value=value;
	this.text=text;
}
function ListBoxCompareCode(a,b)
{
	a = a.value;
	b = b.value;
	if (a < b) return -1;
	if (a > b) return 1;
	return 0;
}
function ListBoxCompareDesc(a,b)
{
	a = a.text;
	b = b.text;
	if (a < b) return -1;
	if (a > b) return 1;
	return 0;
}
function SortBy(SortType) {
	// Log 59477 YC - lstItems may not exist on the layout
	if (lstItems) {
		var ArrSort = new Array();

		for (var l=0; l<lstItems.length; l++) {
			// get code OR description from the 'value' field of option - as we display code:description in text field
			var ValText = lstItems[l].value.split(ParamDelim);
			ArrSort[l] = new ListBoxObject(ValText[0],ValText[1]);
		}

		ClearAllList(lstItems);

		if (SortType=="CODE")
			ArrSort.sort(ListBoxCompareCode);
		else
			ArrSort.sort(ListBoxCompareDesc);

		for (var l=0; l<ArrSort.length; l++) {
			var val = ArrSort[l].value;
			var desc = ArrSort[l].text;
			// put code AND description in the 'value' field of options - so we can take it apart on update...
			lstItems.options[lstItems.options.length] = new Option(val+': '+desc,val + ParamDelim + desc);
		}
	}
	return false;
}

function UpdateClickHandler(e) {

/*
for (var i=0; i<lstItems.length; i++) {
	alert(lstItems.options[i].value+'\n'+lstItems.options[i].text);
}
*/

	// don't call returnValues from websys.listboxes.js
	// we want to strip the value and description from the option.value field...
	//ary=returnValues(f.TestItemSelected);
	// Log 59477 YC - do join here instead of when building f.PPParameters.value
	var ary = new Array();
	var ValText = "";
	if (f.TestItemSelected) {
		for (var i=0; i<f.TestItemSelected.length; i++) {
			ValText = f.TestItemSelected.options[i].value.split(ParamDelim);
			ary[i]=ValText[0];
		}
		if (ary.length>0) ary=ary.join("^")
	}

	if (f.EpisodesAll) {
		if (f.EpisodesAll.checked==true) {var eAll=1} else {var eAll=0;}
	} else {
		var eAll=0;
	}
	// Log 30558 - AI - 13-03-2003 : Add "Include 'r' Prefix in front of date" checkbox.
	if (f.IncludeRPrefix) {
		if (f.IncludeRPrefix.checked==true) {var rPrefix=1} else {var rPrefix=0;}
	} else {
		var rPrefix=0;
	}
	// Log 30600 - AI - 14-05-2003 : Add "Reference Range Position" Lookup Textbox.
	if (f.RefRangePosition) {
		var refRange=f.RefRangePosition.value;
	} else {
		var refRange="";
	}
	if (f.TestDisplay) {
		var TestDisplay=f.TestDisplay.value;
	} else {
		var TestDisplay="";
	}
	// Log 51472 - AI - 23-09-2005 : Add "Result Justification" Lookup Textbox.
	if (f.ResultJustification) {
		var ResJust=f.ResultJustification.value;
	} else {
		var ResJust="";
	}
	
	/*
	var ObsGroup=""
	var obj=document.getElementById("ObservationGroup");
	if ((obj)&&(obj.value!="")) {
		ObsGroup=obsgrpid;
	}
	*/
	
	f.PPParameters.value=ary+"|"+eAll+"|"+rPrefix+"|"+refRange+"|"+TestDisplay+"|"+ResJust;
	// end Logs 30558, 30600, and 51472

	/*  allow no test items - we will display all...
	if ((f.PPDesc.value!="")&&(ary=="")) {
		DisableUpdate();
	}
	*/

	if ((f.PPDesc.value=="")&&(ary=="")) {
		return update1_click();
	}
	if (f.PPDesc.value!="") {
		EnableUpdate();
		return update1_click();
	}
}

function LookUpTestItem(val) {
	f.TestItem.value="";
	var aryVals = val.split("^");
	var strOption = aryVals[1] + ": "+ aryVals[0] + "^" + aryVals[1] + ParamDelim + aryVals[0];
	if (f.TestItemSelected) TransferToList(f.TestItemSelected,strOption);
	EnableUpdate();
}

// Log 59477 YC - This function is not used. Delete is handled in epr.CTProfileParams.Edit.js
/* 
function DeleteTestItemsClickHandler(e) {
	ClearSelectedList(f.TestItemSelected);
	return false;
}
*/

function LookUpCumProfileName(val) {
	//ary=val.split("^");
	//var vals="PPType="+ary[2]+"&PPDesc="+ary[0]+"&ID="+ary[1];
	//websys_createWindow('epr.ctprofileparams.edit.csp?'+vals,'Profiles','top=0,left=0,width=500,height=450');
	//window.open('epr.ctprofileparams.edit.csp?'+vals,'Profiles','top=0,left=0,width=500,height=450');
	//completeForm(f.PPParameters.value.split("|"),graph);
	var ary=val.split("^");
	frm.elements['ID'].value=ary[1];
	/***
	for (i=4; i<ary.length-1; i++) { ary[3]=ary[3]+"^"+ary[i]; }
	completeForm(ary[3].split("|"));
	**/
	//fire broker to fetch params from selected profile id
	//frm.elements['xfetchparams'].change();
	//NB: may not work with N6
	var evt = document.createEventObject();
	frm.elements['xfetchparams'].fireEvent("onchange",evt);
}


var TableItems = new Array();

function TableItem(list,column,title,width,show) {
	this.column=column;
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

function Init() {
	// Log 59477 YC - lstItems may not exist on the layout
	if (lstItems) {
		lstItems.onclick=ItemsClickHandler;
		lstItems.multiple=true;
	}
	var obj = document.getElementById('Up');
	if (obj) obj.onclick=UpClickHandler;
	var obj = document.getElementById('Down');
	if (obj) obj.onclick=DownClickHandler;
	var obj = document.getElementById('SortByDesc');
	if (obj) obj.onclick=SortByDesc;
	var obj = document.getElementById('SortByCode');
	if (obj) obj.onclick=SortByCode;

	DisableUpdate();
}

function ItemsClickHandler() {
	// Log 59477 YC - lstItems may not exist on the layout
	if (lstItems) {
		var i=lstItems.selectedIndex;
		var len=lstItems.options.length;
		if ((len>1)&&(i>-1)) {
			//pointer to collection
			var ptr=lstItems.options[i].value;
			var ob=TableItems[ptr];
		}
	}
}

function UpClickHandler() {
	// Log 59477 YC - lstItems may not exist on the layout
	if (lstItems) {                                       	
		var i=lstItems.selectedIndex;
		var len=lstItems.length;

		if ((len>1)&&(i>0)) {
			SwapItem(i,i-1)
		}
	}
	return false;
}

function DownClickHandler() {
	// Log 59477 YC - lstItems may not exist on the layout
	if (lstItems) {                                       
		var i=lstItems.selectedIndex;
		var len=lstItems.length;
		// check if i is -1 which means none are selected
		if ((len>1)&&(i<(len-1))&&(i!=-1)) {
			SwapItem(i,i+1)
		}
	}
	return false;
}

function SwapItem(a,b) {
	//Swap position and style of two options
	//We used to just remove then add - but this didn't work in NS6
	// Log 59477 YC - lstItems may not exist on the layout
	if (lstItems) {                                       
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
}

function LinkDisable(e) {
	var el = websys_getSrcElement(e);
	if (el.disabled) {
		return false;
	}
	return true;
}

function DisableUpdate() {
	var obj=document.getElementById('update1');
	if (obj) {
		obj.disabled=true;
		obj.onclick=LinkDisable;
	}
	var obj=document.all.tags("IMG");
	if (obj) {
		for (i=0; i<obj.length;	i++)	{
			if (obj.src=="../images/websys/update.gif") {
			  obj.disabled=true;
			  obj.onclick=LinkDisable;
	  	}
		}
	}
}

function EnableUpdate(e) {
	var obj=document.getElementById('update1');
	if (obj) {
		obj.disabled=false;
		obj.onclick=UpdateClickHandler;
	}
}

var frm=document.getElementById('fOEOrder_Edit_LabCummProfile');
var lstItems=document.getElementById('TestItemSelected');
Init();

//wrapper to call broker on hidden field to fetch params
function xfetchparams_changehandler(encmeth) {
	if (cspRunServerMethod(encmeth,'AddParams',frm.elements['ID'].value)) {
	}
}

function completeForm(str,graph) {
	AddParams(str.join('|'));
}

/*
function LookUpObsGroup(val) {
	var ary=val.split("^");
	obsgrpid=ary[1]+"^"+ary[0];
}
*/

function AddParams(str) {
	var arr=str.split('|');
	str=arr[0];
	if (str) {
		lst=frm.elements['TestItemSelected'];    
		// Log 59477 YC - Check if lst exists first!
		if (lst) {
			ClearAllList(lst);
			var arrParams=str.split('^');
			var code='';
			for (var i=0; i<arrParams.length; i++) {
				code=arrParams[i];
				lst.options[lst.options.length] = new Option(code+': '+arrTestItems[code],code + ParamDelim + arrTestItems[code]);
			}
		}
	}
	var objEpisAll=frm.elements['EpisodesAll'];
	if (objEpisAll) {
		if (arr[1]==1) {
			objEpisAll.checked=true;
		} else {
			objEpisAll.checked=false;
		}
	}
	// Log 30558 - AI - 13-03-2003 : Add "Include 'r' Prefix in front of date" checkbox.
	if (f.IncludeRPrefix) {
		if (arr[2]==1) {
			f.IncludeRPrefix.checked=true;
		} else {
			f.IncludeRPrefix.checked=false
		}
	}
	// end Log 30558
	// Log 30600 - AI - 14-05-2003 : Add "Reference Range Position" Lookup Textbox.
	if (f.RefRangePosition) {
		if (arr[3]) {
			f.RefRangePosition.value=arr[3];
		} else {
			f.RefRangePosition.value="";
		}
	}
	// end Log 30600
	if (f.TestDisplay) {
		if (arr[4]) {
			f.TestDisplay.value=arr[4];
		} else {
			f.TestDisplay.value="";
		}
	}
	// Log 51472 - AI - 22-09-2005 : Add "Result Justification" Lookup Textbox.
	if (f.ResultJustification) {
		if (arr[5]) {
			f.ResultJustification.value=arr[5];
		} else {
			f.ResultJustification.value="";
		}
	}
	// end Log 51472
	
	/*
	var objObsGroup=frm.elements['ObservationGroup'];
	if (objObsGroup) {
		if (arr[6]) {
			objObsGroup.value="";
			obsgrpid=arr[6];
			objObsGroup.value=arr[6].split("^")[1];
		} else {
			objObsGroup.value="";
			obsgrpid="";
		}
	}
	*/
	
	EnableUpdate();
}
