// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

f=document.fOEOrder_Edit_TabularProfile;
//create a global array (arrTestItems) matching testcodes with their descriptions, eg: arrTestItems['A010']='FBC';//this avoids multiple looping for matches.
var arrCatItems=new Array();
var arrtempval=allcatval.split(',');
var arrtemptxt=allcattxt.split('^');
for (var i=0;i<arrtempval.length;i++) {
	arrCatItems[arrtempval[i]]=arrtemptxt[i];
}
var arrHospItems=new Array();
var arrtempval2=allhospval.split(',');
var arrtemptxt2=allhosptxt.split('^');
for (var i=0;i<arrtempval2.length;i++) {
	arrHospItems[arrtempval2[i]]=arrtemptxt2[i];
}

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
	if(f.ld388iCategory)
		f.ld388iCategory.disabled=disabled;
	if(f.CategorySelected) {
		f.CategorySelected.disabled=disabled;
		f.CategorySelected.className=classname;
	}
	// doesn't need to be disabled since cats can't be selected anyway
	// deleteCat
}

function UpdateClickHandler(e) {
	var Cat_ary="";
	var Hosp_ary="";
	var stat_ary="";

	// Log 30556 - AI - 16-12-2002 : Add functionality for Hospital (Location) selection.
	var obj = f.CategorySelected;
	// following function returnValues located in websys.ListBoxes.js
	if (obj) {
		Cat_ary=returnValues(obj);
		// Log 59477 YC - Do join here instead of when setting f.PPParameters.value
		if(Cat_ary!="") Cat_ary=Cat_ary.join(",");
	}
	var obj = f.HospitalSelected;
	if (obj) {
		Hosp_ary=returnValues(obj);
		if(Hosp_ary!="") Hosp_ary=Hosp_ary.join(",");
	}
	var eAll=0;
	if (f.EpisodesAll) {
		if (f.EpisodesAll.checked==true) { eAll=1; }
	}
	var UnVer=0;
	if (f.DisplayUnverifiedResults) {
		if (f.DisplayUnverifiedResults.checked==true) { UnVer=1; }
	}
	var tRes=0;
	if (f.TagResultsOnly) {
		if (f.TagResultsOnly.checked==true) { tRes=1; }
	}
	var UnRead=0;
	if (f.OnlyUnreadResults) {
		if (f.OnlyUnreadResults.checked==true) { UnRead=1; }
	}
	var vIcon=0;
	if (f.ShowVIcon) {
		if (f.ShowVIcon.checked==true) { vIcon=1; }
	}
	// Log 30564 - AI - 06-02-2003 : Add "Hide Time in Link" checkbox.
	var vHideTime=0;
	if (f.HideTimeInLink) {
		if (f.HideTimeInLink.checked==true) { vHideTime=1; }
	}
	// Log 30558 - AI - 13-03-2003 : Add "Include 'r' Prefix in front of date" checkbox.
	var rPrefix=0;
	if (f.IncludeRPrefix) {
		if (f.IncludeRPrefix.checked==true) { rPrefix=1; }
	}

	// Log 41352 - AI - 02-02-2004 : Add the selected Subcategories.
	var selsubcatdata=selsubcattxt+"*"+selsubcatval+"*"+selsubcatcode;

	// Log 55973 - PJC - 20-12-2005 : Add the "Only show entries marked for DS Report" checkbox.
	var OnlyDSReport=0;
	if (f.OnlyMarkedForDSReport) {
			if (f.OnlyMarkedForDSReport.checked==true) { OnlyDSReport=1; }
	}

	// Log 60704 YC - no cats checkbox
	var noCats=0;
	if (f.noCats) {
			if (f.noCats.checked==true) { noCats=1 }
	}

	//Log 60604 - PJC - Add Statuses
	var obj=f.ResultStatusSelected
	if (obj) {
		stat_ary=returnValues(obj);
		if (stat_ary!="") stat_ary=stat_ary.join(",");
	}

	f.PPParameters.value=Cat_ary+"|"+eAll+"|"+Hosp_ary+"|"+UnVer+"|"+tRes+"|"+UnRead+"|"+vIcon+"|"+vHideTime+"|"+rPrefix+"|"+selsubcatdata+"|"+OnlyDSReport+"|"+noCats+"|"+stat_ary;
	// end Logs 30558, 30564, 30556, 41352, 55973

	return update1_click();
}

var frm=document.forms['fOEOrder_Edit_TabularProfile'];

function LookUpTabProfileName(val) {
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
		// Log 59477 YC - Check that lst exists first!
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
	var objEpisAll=frm.elements['EpisodesAll'];
	if (arr[1]&&(objEpisAll)) {
		if (arr[1]==1) {objEpisAll.checked=true;} else {objEpisAll.checked=false;}
	} else {
		if (objEpisAll) {
			objEpisAll.checked=false;
		}
	}
	str=arr[2];
	if (str) {
		lst=frm.elements['HospitalSelected'];
		// Log 59477 YC - Check that lst exists first!
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
	if (arr[3]&&(f.DisplayUnverifiedResults)) {
		if (arr[3]==1) {f.DisplayUnverifiedResults.checked=true;} else {f.DisplayUnverifiedResults.checked=false}
	} else {
		if (f.DisplayUnverifiedResults) {
			f.DisplayUnverifiedResults.checked=false
		}
	}
	if (arr[4]&&(f.TagResultsOnly)) {
		if (arr[4]==1) {f.TagResultsOnly.checked=true;} else {f.TagResultsOnly.checked=false}
	} else {
		if (f.TagResultsOnly) {
			f.TagResultsOnly.checked=false
		}
	}
	if (arr[5]&&(f.OnlyUnreadResults)) {
		if (arr[5]==1) {f.OnlyUnreadResults.checked=true;} else {f.OnlyUnreadResults.checked=false}
	} else {
		if (f.OnlyUnreadResults) {
			f.OnlyUnreadResults.checked=false
		}
	}
	if (arr[6]&&(f.ShowVIcon)) {
		if (arr[6]==1) {f.ShowVIcon.checked=true;} else {f.ShowVIcon.checked=false}
	} else {
		if (f.ShowVIcon) {
			f.ShowVIcon.checked=false
		}
	}
	// Log 30564 - AI - 06-02-2003 : Add "Hide Time in Link" checkbox.
	if (arr[7]&&(f.HideTimeInLink)) {
		if (arr[7]==1) {f.HideTimeInLink.checked=true;} else {f.HideTimeInLink.checked=false}
	} else {
		if (f.HideTimeInLink) {
			f.HideTimeInLink.checked=false
		}
	}
	// Log 30558 - AI - 13-03-2003 : Add "Include 'r' Prefix in front of date" checkbox.
	if (arr[8]&&(f.IncludeRPrefix)) {
		if (arr[8]==1) {f.IncludeRPrefix.checked=true;} else {f.IncludeRPrefix.checked=false}
	} else {
		if (f.IncludeRPrefix) {
			f.IncludeRPrefix.checked=false
		}
	}

	// Log 41352 - AI - 02-02-2004 : Add the selected Subcategories.
	lst=frm.elements['SubcategorySelected'];
	if (lst) {
		ClearAllList(lst);
		str=arr[9];
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

	// Log 55973 - PJC - 20-12-2005 : Add the "Only show entries marked for DS Report" checkbox.
	if (arr[10]&&(f.OnlyMarkedForDSReport)) {
		if (arr[10]==1) {f.OnlyMarkedForDSReport.checked=true;} else {f.OnlyMarkedForDSReport.checked=false}
	} else {
		if (f.OnlyMarkedForDSReport) {
			f.OnlyMarkedForDSReport.checked=false;
		}
	}
	// end Log 55973

	// Log 60704 YC - no cats checkbox
	if(f.noCats) {
		f.noCats.checked=false;
		if(arr[11]&&arr[11]==1) f.noCats.checked=true;
		noCatsClickHandler();
	}

	//Log 60604 - PJC - Adding Result Statuses list box
	var obj=f.ResultStatusSelected;
	if (arr[12] && obj) {
		ostatstxt=loopArrayForMatches(allresstatval,allresstattxt,arr[12].split(","));
		ClearAllList(obj);
		callAddItemToListCD(obj,ostatstxt.join("^"),arr[12],'0');
	}
}
