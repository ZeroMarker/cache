// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

f=document.fOEOrdResult_Edit_Profile
var frm=document.forms['fOEOrdResult_Edit_Profile'];

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

function completeForm(ovals,graph) {
	obj=f.CategorySelected;
	// Log 59477 YC - If Category Selected is not on the page, we don't do this
	if (obj) {
		ocatgstxt=loopArrayForMatches(allcatval,allcattxt,ovals[0].split(","));
		ClearAllList(obj);
		callAddItemToListCD(obj,ocatgstxt.join("^"),ovals[0],'0');
	}
	var obj=document.getElementById('PPGraphDefinitionDR')
	if (obj) obj.value=graph;
	if (ovals[1]&&(f.EpisodesAll)) {
		if (ovals[1]==1) {f.EpisodesAll.checked=true;} else {f.EpisodesAll.checked=false}
	} else {
		if (f.EpisodesAll) {
			f.EpisodesAll.checked=false
		}
	}
	if (ovals[2]&&(f.DisplayAtomic)) {
		if (ovals[2]==1) {f.DisplayAtomic.checked=true;} else {f.DisplayAtomic.checked=false}
	} else {
		if (f.DisplayAtomic) {
			f.DisplayAtomic.checked=false
		}
	}
	if (ovals[3]&&(f.DisplayDicom)) {
		if (ovals[3]==1) {f.DisplayDicom.checked=true;} else {f.DisplayDicom.checked=false}
	} else {
		if (f.DisplayDicom) {
			f.DisplayDicom.checked=false
		}
	}
	if (ovals[4]&&(f.DisplayImage)) {
		if (ovals[4]==1) {f.DisplayImage.checked=true;} else {f.DisplayImage.checked=false}
	} else {
		if (f.DisplayImage) {
			f.DisplayImage.checked=false
		}
	}
	if (ovals[5]&&(f.DisplayText)) {
		if (ovals[5]==1) {f.DisplayText.checked=true;} else {f.DisplayText.checked=false}
	} else {
		if (f.DisplayText) {
			f.DisplayText.checked=false
		}
	}
	if (ovals[6]&&(f.DisplayWord)) {
		if (ovals[6]==1) {f.DisplayWord.checked=true;} else {f.DisplayWord.checked=false}
	} else {
		if (f.DisplayWord) {
			f.DisplayWord.checked=false
		}
	}

	// Log 41352 - AI - 02-02-2004 : Add the selected Subcategories.
	lst=frm.elements['SubcategorySelected'];
	if (lst) {
		ClearAllList(lst);
		str=ovals[7];
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
	if (ovals[8]&&(f.OnlyMarkedForDSReport)) {
		if (ovals[8]==1) {f.OnlyMarkedForDSReport.checked=true;} else {f.OnlyMarkedForDSReport.checked=false}
	} else {
		if (f.OnlyMarkedForDSReport) {
			f.OnlyMarkedForDSReport.checked=false
		}
	}
	// end Log 55973

	// Log 60704 YC - no cats checkbox
	if(f.noCats) {
		f.noCats.checked=false;
		if(ovals[9]&&ovals[9]==1) f.noCats.checked=true;
		noCatsClickHandler();
	}

	// Log 60604 - PJC - Adding Result Statuses list box
	var obj=f.ResultStatusSelected;
	if (ovals[10] && obj) {
		ostatstxt=loopArrayForMatches(allresstatval,allresstattxt,ovals[10].split(","));
		ClearAllList(obj);
		callAddItemToListCD(obj,ostatstxt.join("^"),ovals[10],'0');
	}

}

function UpdateClickHandler(e) {
	var ary="";
	var ary1="";
	var obj = f.CategorySelected;
	if (obj) {
		ary=returnValues(obj);
		// Log 59477 YC - Do join here rather than when setting f.PPParameters.value
		if (ary!="") ary=ary.join(",");
	}
	var eAll=0;
	if (f.EpisodesAll) {
		if (f.EpisodesAll.checked==true) { eAll=1; }
	}
	var DAtomic=0;
	if (f.DisplayAtomic) {
		if (f.DisplayAtomic.checked==true) { DAtomic=1; }
	}
	var DDicom=0;
	if (f.DisplayDicom) {
		if (f.DisplayDicom.checked==true) { DDicom=1; }
	}
	var DImage=0;
	if (f.DisplayImage) {
		if (f.DisplayImage.checked==true) { DImage=1; }
	}
	var DText=0;
	if (f.DisplayText) {
		if (f.DisplayText.checked==true) { DText=1; }
	}
	var DWord=0;
	if (f.DisplayWord) {
		if (f.DisplayWord.checked==true) { DWord=1; }
	}
	// Log 41352 - AI - 02-02-2004 : Add the selected Subcategories.
	var selsubcatdata=selsubcattxt+"*"+selsubcatval+"*"+selsubcatcode;

	// Log 55973 - PJC - 20-12-2005 : Add the "Only show entries marked for DS Report" checkbox.
	var OnlyDSReport=0;
	if (f.OnlyMarkedForDSReport) {
		if (f.OnlyMarkedForDSReport.checked==true) { OnlyDSReport=1; }
	}

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
		ary1=returnValues(obj);
		if (ary1!="") ary1=ary1.join(",");
	}

	f.PPParameters.value=ary+"|"+eAll+"|"+DAtomic+"|"+DDicom+"|"+DImage+"|"+DText+"|"+DWord+"|"+selsubcatdata+"|"+OnlyDSReport+"|"+noCats+"|"+ary1;
	// end Logs 41352, 55973

	return update1_click()
}
