// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var f=document.fOEOrder_Edit_Profile;
//create a global array (arrTestItems) matching testcodes with their descriptions, eg: arrTestItems['A010']='Full Blood Count';
//this avoids multiple looping for matches.
var arrCatItems=new Array();
var arrtempval=allcatval.split(',');
var arrtemptxt=allcattxt.split('^');
for (var i=0;i<arrtempval.length;i++) {
	arrCatItems[arrtempval[i]]=arrtemptxt[i];
}
var arrStatItems=new Array();
var arrtempval2=allstatval.split(',');
var arrtemptxt2=allstattxt.split('^');
for (var i=0;i<arrtempval2.length;i++) {
	arrStatItems[arrtempval2[i]]=arrtemptxt2[i];
}
var arrHospItems=new Array();
var arrtempval3=allhospval.split(',');
var arrtemptxt3=allhosptxt.split('^');
for (var i=0;i<arrtempval3.length;i++) {
	arrHospItems[arrtempval3[i]]=arrtemptxt3[i];
}
var arrOrdPrioItems=new Array();
var arrtempval4=allordprioval.split(',');
var arrtemptxt4=allordpriotxt.split('^');
for (var i=0;i<arrtempval4.length;i++) {
	arrOrdPrioItems[arrtempval4[i]]=arrtemptxt4[i];
}

// Log 43983 - AI - 28-06-2004 : If the ExcludeCurrentEpisode checkbox is checked, make sure the EpisodesAll checkbox is also checked.
var obj=f.ExcludeCurrentEpisode; if (obj) obj.onclick=ExcludeCurrentEpisodeClickHandler;

var obj=f.noCats; 
if (obj) obj.onclick=noCatsClickHandler;

function noCatsClickHandler() {
	var disabled=false;
	var classname="";
	if(f.noCats.checked) {
		disabled=true;
		classname="disabledField";
	}
	if(f.Category) {
		f.Category.disabled=disabled;
		f.Category.className=classname;
	}
	if(f.ld275iCategory) 
		f.ld275iCategory.disabled=disabled;
	if(f.CategorySelected) {
		f.CategorySelected.disabled=disabled;
		f.CategorySelected.className=classname;
	}
	// doesn't need to be disabled since cats can't be selected anyway
	// deleteCat
}

function UpdateClickHandler(e) {
	setParameters()
	return update1_click()
}

function setParameters() {
	var ary1="";
	var ary2="";
	var ary3="";
	var ary4="";
	var obj=f.CategorySelected;
	if (obj) {
		ary1=returnValues(obj);
		if (ary1!="") ary1=ary1.join(",");
	}
	var obj = f.StatusSelected;
	if (obj) {
		ary2=returnValues(obj);
		if (ary2!="") ary2=ary2.join(",");
	}
	var obj = f.HospitalSelected;
	if (obj) {
		ary3=returnValues(obj);
		if (ary3!="") ary3=ary3.join(",");
	}
	var obj = f.OrderPrioritySelected;
	if (obj) {
		ary4=returnValues(obj);
		if (ary4!="") ary4=ary4.join(",");
	}
	var eAll=0;
	if (f.EpisodesAll) {
			if (f.EpisodesAll.checked==true) { eAll=1 }
	}
	// Log 41352 - AI - 29-01-2004 : Add the selected Subcategories.
	var selsubcatdata=selsubcattxt+"*"+selsubcatval+"*"+selsubcatcode;

	// Log 43983 - AI - 22-06-2004 : Add the "Exclude Orders from current Episode" checkbox.
	var ExclCurrEp=0;
	if (f.ExcludeCurrentEpisode) {
			if (f.ExcludeCurrentEpisode.checked==true) { ExclCurrEp=1 }
	}

	// Log 55973 - PJC - 20-12-2005 : Add the "Only show entries marked for DS Report" checkbox.
	var OnlyDSReport=0;
	if (f.OnlyMarkedForDSReport) {
			if (f.OnlyMarkedForDSReport.checked==true) { OnlyDSReport=1 }
	}

	var CurrentOrdersOnly=0;
	if (f.CurrentOrdersOnly) {
			if (f.CurrentOrdersOnly.checked==true) { CurrentOrdersOnly=1 }
	}
	
	// Log 60704 YC - no cats checkbox
	var noCats=0;
	if (f.noCats) {
			if (f.noCats.checked==true) { noCats=1 }
	} 
	
	f.PPParameters.value=ary1+"|"+ary2+"|"+ary3+"|"+eAll+"|"+selsubcatdata+"|"+ExclCurrEp+"|"+OnlyDSReport+"|"+ary4+"|"+CurrentOrdersOnly+"|"+noCats;
	// end Logs 41352, 43983, 55973
}

var frm=document.forms['fOEOrder_Edit_Profile'];

// YC - Don't need cspRunServerMethod. Just get it from original broker
function LookUpOrderProfileName(val) {
	var ary=val.split("^");
	frm.elements['ID'].value=ary[1];
	AddParams(ary[3]);
	//fire broker to fetch params from selected profile id
	//frm.elements['xfetchparams'].change();
	//NB: may not work with N6
	//var evt = document.createEventObject();
	//frm.elements['xfetchparams'].fireEvent("onchange",evt);
}
//wrapper to call broker on hidden field to fetch params
/*
function xfetchparams_changehandler(encmeth) {
	if (cspRunServerMethod(encmeth,'AddParams',frm.elements['ID'].value)) {
	}
}
*/
function completeForm(str,graph) {
	AddParams(str.join('|'));
}

function AddParams(str) {
	var arr=str.split('|');
	str=arr[0];
	if (str) {
		lst=frm.elements['CategorySelected'];
		// Log 59477 YC - Check if lst exists first!
		if (lst) {
			ClearAllList(lst);
			var arrParams=str.split(',');
			var code='';
			for (var i=0; i<arrParams.length; i++) {
				code=arrParams[i];
				lst.options[lst.options.length] = new Option(arrCatItems[code],code);
			}
		}
	}
	str=arr[1];
	if (str) {
		lst=frm.elements['StatusSelected'];
		// Log 59477 YC - Check if lst exists first!
		if (lst) {
			ClearAllList(lst);
			var arrParams=str.split(',');
			var code='';
			for (var i=0; i<arrParams.length; i++) {
				code=arrParams[i];
				lst.options[lst.options.length] = new Option(arrStatItems[code],code);
			}
		}
	}
	str=arr[2];
	if (str) {
		lst=frm.elements['HospitalSelected'];
		// Log 59477 YC - Check if lst exists first!
		if (lst) {
			ClearAllList(lst);
			var arrParams=str.split(',');
			var code='';
			for (var i=0; i<arrParams.length; i++) {
				code=arrParams[i];
				lst.options[lst.options.length] = new Option(arrHospItems[code],code);
			}
		}
	}
	if (arr[3]&&(f.EpisodesAll)) {
		if (arr[3]==1) {f.EpisodesAll.checked=true;} else {f.EpisodesAll.checked=false}
	} else {
		if (f.EpisodesAll) {
			f.EpisodesAll.checked=false;
		}
	}
	// Log 41352 - AI - 29-01-2004 : Add the selected Subcategories.
	lst=frm.elements['SubcategorySelected'];
	if (lst) {
		ClearAllList(lst);
		str=arr[4];
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
	// end Log 41352
	// Log 43983 - AI - 22-06-2004 : Add the "Exclude Orders from current Episode" checkbox.
	if (arr[5]&&(f.ExcludeCurrentEpisode)) {
		if (arr[5]==1) {f.ExcludeCurrentEpisode.checked=true;} else {f.ExcludeCurrentEpisode.checked=false}
	} else {
		if (f.ExcludeCurrentEpisode) {
			f.ExcludeCurrentEpisode.checked=false;
		}
	}
	// end Log 43983
	// Log 55973 - PJC - 20-12-2005 : Add the "Only show entries marked for DS Report" checkbox.
	if (arr[6]&&(f.OnlyMarkedForDSReport)) {
		if (arr[6]==1) {f.OnlyMarkedForDSReport.checked=true;} else {f.OnlyMarkedForDSReport.checked=false}
	} else {
		if (f.OnlyMarkedForDSReport) {
			f.OnlyMarkedForDSReport.checked=false;
		}
	}
	// end Log 55973
	// Log 52540 YC - Order Priority
	str=arr[7];
	if (str) {
		lst=frm.elements['OrderPrioritySelected'];
		ClearAllList(lst);
		var arrParams=str.split(',');
		var code='';
		for (var i=0; i<arrParams.length; i++) {
			code=arrParams[i];
			lst.options[lst.options.length] = new Option(arrOrdPrioItems[code],code);
		}
	}
	// END log 52540
	if (arr[8]&&(f.CurrentOrdersOnly)) {
		if (arr[8]==1) {f.CurrentOrdersOnly.checked=true;} else {f.CurrentOrdersOnly.checked=false}
	} else {
		if (f.CurrentOrdersOnly) {
			f.CurrentOrdersOnly.checked=false;
		}
	}
	
	// Log 60704 YC - no cats checkbox
	if(f.noCats) {
		f.noCats.checked=false;
		if(arr[9]&&arr[9]==1) f.noCats.checked=true;
		noCatsClickHandler();
	} 
}

// Log 43983 - AI - 28-06-2004 : If the ExcludeCurrentEpisode checkbox is checked, make sure the EpisodesAll checkbox is also checked.
function ExcludeCurrentEpisodeClickHandler() {
	var obj1=f.ExcludeCurrentEpisode;
	var obj2=f.EpisodesAll;
	if ((obj1)&&(obj1.checked==true)&&(obj2)&&(obj2.checked==false)) {
		obj2.checked=true;
	}
}

