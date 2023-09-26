// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 21.03.06 56897

f=document.fOEOrder_Edit_CytoProfile;
var frm=document.forms['fOEOrder_Edit_CytoProfile'];

var obsgrpid="";

var arrCatItems=new Array();
var arrtempval=allcatval.split(',');
var arrtemptxt=allcattxt.split('^');
for (var i=0;i<arrtempval.length;i++) {
	arrCatItems[arrtempval[i]]=arrtemptxt[i];
}

// Log 59443 YC - If "show" checkboxes are unchecked or not on page, don't disable, otherwise disable
var obj=document.getElementById("ShowOrderItem");
if (obj) {
	EnableDisable(obj,"OrderItem","OrderItemSelected","deleteOrderItem","DeleteOrdItemClickHandler");
	obj.onclick=CheckClickHandler;
}

var obj=document.getElementById("ShowOrderCat");
if (obj) {
	EnableDisable(obj,"Category","CategorySelected","deleteCat","DeleteCategClickHandler");
	obj.onclick=CheckClickHandler;
}

var obj=document.getElementById("ShowOrderSubcat");
if (obj) {
	EnableDisable(obj,"Subcategory","SubcategorySelected","deleteSubcat","DeleteSubcategClickHandler");
	obj.onclick=CheckClickHandler;
}

var obj=document.getElementById("ShowLab");
if (obj) {
	EnableDisable(obj,"TestItem","TestItemSelected","deleteTestItems","DeleteTestItemsClickHandler");
	obj.onclick=CheckClickHandler;
}

var obj=document.getElementById("ShowClinPath");
if (obj) {
	EnableDisable(obj,"ClinPath","ClinPathSelected","deleteClinPath","DeleteClinPathClickHandler");
	obj.onclick=CheckClickHandler;
}

function CheckClickHandler(e) {
	var eSrc = websys_getSrcElement(e);
	if (eSrc) {
		if (eSrc.id == "ShowOrderItem") EnableDisable(eSrc,"OrderItem","OrderItemSelected","deleteOrderItem","DeleteOrdItemClickHandler");
		if (eSrc.id == "ShowOrderCat") EnableDisable(eSrc,"Category","CategorySelected","deleteCat","DeleteCategClickHandler");
		if (eSrc.id == "ShowOrderSubcat") EnableDisable(eSrc,"Subcategory","SubcategorySelected","deleteSubcat","DeleteSubcategClickHandler");
		if (eSrc.id == "ShowLab") EnableDisable(eSrc,"TestItem","TestItemSelected","deleteTestItems","DeleteTestItemsClickHandler");
		if (eSrc.id == "ShowClinPath") EnableDisable(eSrc,"ClinPath","ClinPathSelected","deleteClinPath","DeleteClinPathClickHandler");
	}
}

function EnableDisable(obj,lookup,listbox,delbtn,delclk) {
	if (!obj.checked) {
		var fld=document.getElementById(lookup);
		if (fld) {
			fld.disabled=true;
			fld.className="disabledField";
		}
		var fld=document.getElementById("ld2172i"+lookup);
		if (fld) fld.disabled=true;
		var fld=document.getElementById(listbox);
		if (fld) { fld.disabled=true; fld.className="disabledField"; }
		var fld=document.getElementById(delbtn);
		if (fld) { fld.disabled=true; fld.onClick=""; }
	}
	else {
		var fld=document.getElementById(lookup);
		if (fld) {
			fld.disabled=false;
			fld.className="";
		}
		var fld=document.getElementById("ld2172i"+lookup);
		if (fld) fld.disabled=false;
		var fld=document.getElementById(listbox);
		if (fld) { fld.disabled=false; fld.className=""; }
		var fld=document.getElementById(delbtn);
		if (fld) { fld.disabled=false; fld.onClick=delclk; }
	}
}
// END Log 59443

function LookUpTabProfileName(val) {
	var ary=val.split("^");
	
	var PPType="";
	var obj=document.getElementById("PPTypeDR");
	if (obj) PPType=obj.value;
	var PPDesc="";
	var obj=document.getElementById("PPDesc");
	if (obj) PPDesc=obj.value;
	
	var vals="ID="+ary[1]+"&PPType="+PPType+"&PPDesc="+websys_escape(PPDesc);
	
	// reload screen with new profile params
	window.location="epr.ctprofileparams.edit.csp?"+vals;
}

function LookUpTestItem(val) {
	f.TestItem.value="";
	if (f.TestItemSelected) TransferToList(f.TestItemSelected,val)
}

function LookUpClinPath(val) {
	f.ClinPath.value="";
	if (f.ClinPathSelected) TransferToList(f.ClinPathSelected,val)
}

// YC - commented - not used
/*
function LookUpObsItem(val) {
	f.ObsItem.value="";
	TransferToList(f.ObsItemSelected,val)
}
*/

function LookUpObsGroup(val) {
	var ary=val.split("^");
	obsgrpid=ary[1];
}

//wrapper to call broker on hidden field to fetch params
function xfetchparams_changehandler(encmeth) {
	if (cspRunServerMethod(encmeth,'AddParams',frm.elements['ID'].value)) {
	}
}

function completeForm(str,graph) {
	AddParams(str.join('|'));
}

function AddParams(str) {
	var arr=str.split('|');
	
	lst=frm.elements['CategorySelected'];
	str=arr[0];
	if (lst) {
		ClearAllList(lst);
		var arrParams=str.split(',');
		var code='';
		for (var i=0; i<arrParams.length; i++) {
			code=arrParams[i];
			if (code!="") lst.options[lst.options.length] = new Option(arrCatItems[code],code);
		}
	}

	lst=frm.elements['SubcategorySelected'];
	if (lst) {
		ClearAllList(lst);
		str=arr[1];
		// str is saved as "" + "*" + "" + "*" + "" (**) if a blank list is saved.
		if ((str)&&(str!="**")) {
			var selsubcatdata=str.split("*");
			selsubcattxt=selsubcatdata[0];
			selsubcatval=selsubcatdata[1];
			selsubcatcode=selsubcatdata[2];
			var seltxtAry=selsubcattxt.split(",");
			var selvalAry=selsubcatval.split(",");
			var selcodeAry=selsubcatcode.split(",");

			for (var i=0; i<selvalAry.length; i++) {
				id=selvalAry[i];
				desc=seltxtAry[i];
				lst.options[lst.options.length]=new Option(desc,id);
			}
		}
	}
	
	var obj=document.getElementById("DaysFrom");
	if (obj) obj.value=arr[3];
	var obj=document.getElementById("DaysTo");
	if (obj) obj.value=arr[4];
	
	obsgrpid=arr[6];
	var obj=document.getElementById("DoseDelimiter");
	if (obj&& arr.length>7) obj.value=unescape(arr[7]);
	
}


function UpdateClickHandler(e) {
	var obj = f.CategorySelected;
	var Cat_ary="";
	// following function returnValues located in websys.ListBoxes.js
	if (obj) {
		Cat_ary=returnValues(obj);
		if (Cat_ary!="") Cat_ary=Cat_ary.join(",");
	}

	var selsubcatdata=selsubcattxt+"*"+selsubcatval+"*"+selsubcatcode;
	
	var obj = f.OrderItemSelected;
	var Ord_ary="";
	if (obj) Ord_ary=returnValues(obj);
	if (Ord_ary!="") {
		for (var i=0;i<Ord_ary.length;i++) {
			// replace bars with underscores
			re=/\|/g;
			Ord_ary[i]=Ord_ary[i].replace(re,"_");
			//alert(Ord_ary[i]);
		}
		Ord_ary=Ord_ary.join(",");
	}
	
	var daysfrom="";
	var daysto="";
	var obj=document.getElementById("DaysFrom");
	if (obj) daysfrom=obj.value;
	var obj=document.getElementById("DaysTo");
	if (obj) daysto=obj.value;
	
	var obj = f.TestItemSelected;
	var Lab_ary="";
	if (obj) {
		Lab_ary=returnValues(obj);
		if (Lab_ary!="") Lab_ary=Lab_ary.join(",");
	}
	
	var obj = f.ClinPathSelected;
	var ClinAry="";
	if (obj) {
		ClinAry=returnValues(obj);
		if (ClinAry!="") ClinAry=ClinAry.join(",");
	}

	// YC - commented - there is no listbox for Obs so this is not used
	//var obj = f.ObsItemSelected;       
	//if (obj) Obs_ary=returnValues(obj);
	
	var obj=document.getElementById("ObsGroup");
	if ((obj)&&(obj.value=="")) obsgrpid="";

	var DoseDelimiter = "";
	if (f.DoseDelimiter) DoseDelimiter = escape(f.DoseDelimiter.value);
	
	var epsall=0;
	var obj=document.getElementById("EpisodesAll");
	if (obj) {
		if (obj.checked) {
			epsall=1;
		}
	}
	
	// Log 59443 YC - Add "show" checkboxes to saved params
	var ShowLab="";
	var obj=document.getElementById("ShowLab");
	if (obj) {
		if (obj.checked) ShowLab="Y";
		else ShowLab="N";
	}
	
	var ShowClinPath="";
	var obj=document.getElementById("ShowClinPath");
	if (obj) {
		if (obj.checked) ShowClinPath="Y";
		else ShowClinPath="N";
	}

	var ShowOrderItem="";
	var obj=document.getElementById("ShowOrderItem");
	if (obj) {
		if (obj.checked) ShowOrderItem="Y";
		else ShowOrderItem="N";
	}
	
	var ShowOrderCat="";
	var obj=document.getElementById("ShowOrderCat");
	if (obj) {
		if (obj.checked) ShowOrderCat="Y";
		else ShowOrderCat="N";
	}
	
	var ShowOrderSubcat="";
	var obj=document.getElementById("ShowOrderSubcat");
	if (obj) {
		if (obj.checked) ShowOrderSubcat="Y";
		else ShowOrderSubcat="N";
	}
	// END Log 59443

	f.PPParameters.value=Cat_ary+"|"+selsubcatdata+"|"+Ord_ary+"|"+daysfrom+"|"+daysto+"|"+Lab_ary+"|"+obsgrpid+"|"+DoseDelimiter+"|"+epsall+"|"+ShowLab+"|"+ShowOrderItem+"|"+ShowOrderCat+"|"+ShowOrderSubcat+"|"+ClinAry+"|"+ShowClinPath;

	return update1_click();
}
