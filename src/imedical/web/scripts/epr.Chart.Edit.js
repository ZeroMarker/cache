// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var f=document.all.fepr_Chart_Edit;
var tbl=document.getElementById("tepr_Chart_Edit");

// Profiles needed to be disabled when it is a history page.
// - when adding new profiles ensure that related fields (lookups, desc) follow the
// same naming convention and add it to this list
var profilelist = "OP,LP,LG,LC,LT,CT,BT,BP,TP,QE,TL,MC,DI,PI";
var profileary = profilelist.split(",");

var aryEvent=noprofiles.split(",")
for (var i=0; i<aryEvent.length; i++) {
	if (document.getElementById(aryEvent[i])) {
		document.getElementById(aryEvent[i]).parentElement.innerHTML=""
	}
}

var aryEvent=profiles.split(",")
for (var i=0; i<aryEvent.length; i++) {
	if (document.getElementById(aryEvent[i])) {
		document.getElementById(aryEvent[i]).onclick=EditProfile;
	}
}

function LookUpProfile(val) {
	ary=val.split("^");
	f.elements[ary[2]+"_ID"].value=ary[1];
	/*
	alert("ele:"+ary[2]+"_ID");
	var obj=document.getElementById(ary[2]+"_ID");
	if (obj){
		alert("got it");
		obj.value=ary[1];
	}*/
	//checkForDuplicates(ary[2])
}

function checkForDuplicates(val) {
	if (!val) var val=this.name;
	var found=0;
	var ary=val.split("_");
	for (var i=1;i<tbl.rows.length;i++) {
		if (document.getElementById('ItemTypez'+i).innerText==ary[0]) found=1
	}
	if (found==1) {
		if (f.elements[ary[0]+"_Desc"].value!="") alert(t['DUPLICATE']);
		document.getElementById(ary[0]+'_Desc').innerText="";f.elements[ary[0]+"_ID"].value;
	}
}

function EditProfile() {

	var vals="PPType="+this.name+"&PPDesc="+f.elements[this.name+"_Desc"].value;
	if (f.elements[this.name+"_Desc"].value!="") vals=vals+"&ID="+f.elements[this.name+"_ID"].value;
	if (f.elements[this.name+"_Desc"].value=="") vals=vals+"&ID=";
	// Log 30556 - AI - 29-01-2003 : Added resizable and scrollbars to the createWindow call.
	//alert('epr.ctprofileparams.edit.csp?'+vals);
	websys_createWindow('epr.ctprofileparams.edit.csp?'+vals,'Profiles','top=0,left=0,width=550,height=550,scrollbars=yes,resizable=yes');
	return false;
}

function UpdateRow (evnt) {
	// will update the 'Row' prompt, as this is the one saved on the DB.

	var obj=websys_getSrcElement(evnt);
	var aryID=obj.name.split("Itemsz");
	if (aryID.length!=0) {
		var row = document.getElementById('Rowsz'+aryID[1]);
		if (row) {
			row.value = obj.value;
		}
	}

}

function UpdateItem (evnt) {
	// will update the 'Row' prompt, as this is the one saved on the DB.
	var obj=websys_getSrcElement(evnt);
	var aryID=obj.name.split("Rowsz");
	if (aryID.length!=0) {
		var item = document.getElementById('Itemsz'+aryID[1]);
		if (item) {
			item.value = obj.value;
		}
	}
}

// Function to skip this field if focus is given to it. To get around Row and Column logic.
// Another way around this would be to only set the value of the component item if type... and only save if type ...
function SkipFocus(evt) {
	var eSrc=websys_getSrcElement(evt);
	//websys_nextfocus(eSrc.sourceIndex);
	eSrc.blur();
	var index=eSrc.sourceIndex;
	for (var j=index+1;j<document.all.length;j++) {
		if ( ((document.all(j).tagName=="INPUT")||(document.all(j).tagName=="TEXTAREA"))
		&& (document.all(j).type!="hidden") && (!document.all(j).disabled) ) {
			websys_setfocus(document.all(j).name);
			break;
		}
	}
}

function DisableLink(field) {
	var obj=document.getElementById(field);
	if (obj) {
		obj.disabled=true;
		obj.onclick = LinkDisable;
	}
}

// sets the onclick of the link to the passed in clickfnc
function EnableLink(field,clickfnc) {
	var obj=document.getElementById(field);
	if (obj) {
		obj.disabled=false;
		obj.onclick = eval(clickfnc);
	}
}

// disables or enables any element
// when enabling a link, pass in the clickfnc which the link is supposed to call
function DisableEnableElem(field,lnk,lookup,clickfnc,enable) {
	if (enable==true) {
		if (field!="") EnableField(field);
		if (lnk!="",clickfnc!="") EnableLink(lnk,clickfnc);
		if (lookup!="") EnableLookup(lookup);
	}
	else {
		if (field!="") DisableField(field);
		if (lnk!="") DisableLink(lnk);
		if (lookup!="") DisableLookup(lookup);
	}
}

// pass in profile code and whether enable is true/false, and it will enable/disable the related field, link and lookup
function DisableEnableProfile(profile,enable) {
	if(profile!="") {
		var field = profile+"_Desc";
		var lookup = "ld218i"+profile+"_Desc";
		DisableEnableElem(field,profile,lookup,"EditProfile",enable);
	}
}

// when history checkbox is selected/unselected, disable/undisable required profiles
function HistClickHandler() {
	var enable;
	var histobj=document.getElementById('IsHistoryPage');
	if(histobj && histobj.checked==true) enable=false;
	else enable=true;

	DisableEnableElem("student","","","",enable);
	for (i=0;i<profileary.length;i++) {
		DisableEnableProfile(profileary[i],enable);
	}
}

function BodyLoadHandler() {
	// Log 60568 YC - rewrote disabling/enabling of profiles.
	//   - if you want a profile disabled when the history checkbox is triggered,
	//   - add it to the "profiles" list at the top of this file
	//
	HistClickHandler();

	// if 'Is History Page' - we can ONLY add EPR pages...
	var objIsHist=document.getElementById('IsHistoryPage');
	//var IsHistoryPage = false;
  /*
	if (objIsHist && objIsHist.checked) {

		//IsHistoryPage = true;
		DisableField("OP_Desc");
		DisableLink("OP");
		DisableLookup("ld218iOP_Desc");
		// Log 59743 YC - Allow RP in SOAP
		//DisableField("RP_Desc");
		//DisableLink("RP");
		//DisableLookup("ld218iRP_Desc");
		DisableField("LP_Desc");
		DisableLink("LP");
		DisableLookup("ld218iLP_Desc");
		DisableField("LG_Desc");
		DisableLink("LG");
		DisableLookup("ld218iLG_Desc");
		DisableField("LC_Desc");
		DisableLink("LC");
		DisableLookup("ld218iLC_Desc");
		DisableField("LT_Desc");
		DisableLink("LT");
		DisableLookup("ld218iLT_Desc");
		DisableField("CT_Desc");
		DisableLink("CT");
		DisableLookup("ld218iCT_Desc");
		DisableField("BT_Desc");
		DisableLink("BT");
		DisableLookup("ld218iBT_Desc");
		DisableField("BP_Desc");
		DisableLink("BP");
		DisableLookup("ld218iBP_Desc");
		DisableField("TP_Desc");
		DisableLink("TP");
		DisableLookup("ld218iTP_Desc");
		DisableField("QE_Desc");
		DisableLink("QE");
		DisableLookup("ld218iQE_Desc");
		// Log 57774 - 31/03/2006 - PJC - Allow Questionnaire Profile  to be added to History Page
		//DisableField("QP_Desc");
		//DisableLink("QP");
		//DisableLookup("ld218iQP_Desc");
		DisableField("TL_Desc");
		DisableLink("TL");
		DisableLookup("ld218iTL_Desc");
		DisableField("MC_Desc");
		DisableLink("MC");
		DisableLookup("ld218iMC_Desc");
		DisableField("DI_Desc");
		DisableLink("DI");
		DisableLookup("ld218iDI_Desc");
		DisableField("PI_Desc");
		DisableLink("PI");
		DisableLookup("ld218iPI_Desc");
	}
	*/

	// Log 60568 YC - Don't allow change of checkbox if there are items in the chart
	if(objIsHist) {
		if (tbl.rows.length>1) {
			objIsHist.className = "disabledField";
			objIsHist.disabled = true;
		}
		else objIsHist.onclick=HistClickHandler;
	}

	var objUpd = document.getElementById("AddSection");
	if (objUpd) objUpd.onclick=UpdateClickHandler;

	// if Tabular or Cumulative - disable the 'Rows' prompt, otherwise, disable the 'Items' prompt
	for (var i=1;i<tbl.rows.length;i++) {
		var row = document.getElementById('Rowsz'+i);
		var item = document.getElementById('Itemsz'+i);
		var itemtype = document.getElementById('ItemTypez'+i).innerText;
		var coll = document.getElementById('Collapsez'+i);
		//if (coll) { coll.onclick = CollClick;}
		if (row&&item&&itemtype) {
			//alert('table: ' + i + ' = ' + itemtype);
			// Log 29736 - AI - 08-01-2004 : Observation Profile (BP) the same as Observation Group layout.
			if ((itemtype=="BP")||(itemtype=="BG")||(itemtype=="LT")||(itemtype=="LC")||(itemtype=="CT")) {
				row.disabled = true;
				// hide the row completely
				row.className = "disabledField";
				row.onfocus = SkipFocus;
				//item.onblur = UpdateRow;
			} else {
				item.disabled = true;
				item.className = "disabledField"
				item.onfocus = SkipFocus;
				//row.onblur = UpdateItem;
			}
		}
		// Log 39287 - AI - 02-10-2003: ColumnWidth is available only for LC and LT types.
		var columnwidth=document.getElementById('ColumnWidthz'+i);
		if (itemtype&&columnwidth) {
			if ((itemtype=="LT")||(itemtype=="LC")||(itemtype=="BP")) {
				columnwidth.disabled=false;
				columnwidth.className="";
			} else {
				columnwidth.disabled=true;
				columnwidth.className="disabledField";
			}
		}
		// PJC - Disable 'OnlyMarkedForDSReport'
		var dsRepObj=document.getElementById('OnlyMarkedForDSReportz'+i);
		if(itemtype&&dsRepObj){
			if( objIsHist && objIsHist.checked==true ){
				dsRepObj.checked=false;
				dsRepObj.disabled=true;
			}
		}

	}
	tbl.onclick=SectionLinkHandler;
	//if no rows or the details column is not displaying, don't have to do anything
	var colDetails=document.getElementById("ChartItemDescz1");
	if (colDetails) {
		for (var i=1; i<tbl.rows.length; i++) {
			var Criteria=document.getElementById("ChartItemTypez"+i).value;
			var ItemDesc=document.getElementById("ChartItemDescz"+i).value;
			//alert("Criteria="+Criteria);
			if (ItemDesc!="") {
				var lnkDetails=document.getElementById("ItemDescz"+i);
				// Log 43334 - AI - 11-05-2004 : Questionnaire Edit Profile (QE) the same as Questionnaire Profile layout.
				if ((Criteria=="OP")||(Criteria=="RP")||(Criteria=="QP")||(Criteria=="LP")||(Criteria=="LC")||(Criteria=="LG")||(Criteria=="LT")||(Criteria=="BT")||(Criteria=="TP")||(Criteria=="BP")||(Criteria=="QE")||(Criteria=="MC")||(Criteria=="CT")||(Criteria=="PI")||(Criteria=="DI")||(Criteria=="PP")) {
					lnkDetails.innerHTML = ItemDesc;
				} else {
					var cell=websys_getParentElement(lnkDetails);
					cell.innerHTML = ItemDesc;
				}
			}
		}
	}
	// colour the panels
	var obj=document.getElementById("colourpallette");
	if (obj) obj.onclick=OpenChartColorPalette;
	var obj=document.getElementById("textcolourpallette");
	if (obj) obj.onclick=OpenTextColorPalette;
	var obj=document.getElementById("SELcolourpallette");
	if (obj) obj.onclick=OpenSELChartColorPalette;
	var obj=document.getElementById("SELtextcolourpallette");
	if (obj) obj.onclick=OpenSELTextColorPalette;

	ColourPanel('ChartColour');
	ColourPanel('TextColour');
	ColourPanel('SELChartColour');
	ColourPanel('SELTextColour');

	// manually enter a HEX colour value - colour the corresponding panel on blur
	var obj=document.getElementById("ChartColour");
	if (obj) {
		obj.onkeydown=ChartColorlookuphandler;
		obj.onblur=ChartColorBlur;
	}
	var obj=document.getElementById("TextColour");
	if (obj) {
		obj.onkeydown=TextColorlookuphandler;
		obj.onblur=TextColorBlur;
	}
	var obj=document.getElementById("SELChartColour");
	if (obj) {
		obj.onkeydown=SELChartColorlookuphandler;
		obj.onblur=SELChartColorBlur;
	}
	var obj=document.getElementById("SELTextColour");
	if (obj) {
		obj.onkeydown=SELTextColorlookuphandler;
		obj.onblur=SELTextColorBlur;
	}

	var obj=document.getElementById("ChartID")
	var objcopy=document.getElementById("CopyChart")
	if ((obj)&&(obj.value=="")&&(objcopy)) DisableLink("CopyChart");


}

function UpdateClickHandler() {
	var obj=document.getElementById("IsHistoryPage");
	if (obj) obj.disabled=false;

	return AddSection_click();
}

function ChartColorlookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='keydown')&&(key==117)) {
		OpenChartColorPalette()
		return websys_cancel();
	}
}
function TextColorlookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='keydown')&&(key==117)) {
		OpenTextColorPalette()
		return websys_cancel();
	}
}
function SELChartColorlookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='keydown')&&(key==117)) {
		OpenSELChartColorPalette()
		return websys_cancel();
	}
}
function SELTextColorlookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='keydown')&&(key==117)) {
		OpenSELTextColorPalette()
		return websys_cancel();
	}
}

function ColourThePanel(whichpanel,whichcolour) {
	var Objcolourpanel= document.getElementById(whichpanel);
	var Objcolour= document.getElementById(whichcolour);
	if (Objcolourpanel && Objcolour) {
		try {
			if (Objcolour.value!="") {
				Objcolourpanel.style.background=Objcolour.value;
			} else {
				Objcolourpanel.style.background="#ffffff";
			}
			Objcolourpanel.disabled = true;
		} catch(e) { }
	}

}
function ChartColorBlur() {
	ColourThePanel("colourpanel","ChartColour");
}
function TextColorBlur() {
	ColourThePanel("textcolourpanel","TextColour");
}
function SELChartColorBlur() {
	ColourThePanel("SELcolourpanel","SELChartColour");
}
function SELTextColorBlur() {
	ColourThePanel("SELtextcolourpanel","SELTextColour");
}
function ColourPanel(WhichColourPicker) {
	var objcolour = "";
	var Objcolourpanel="";

	if (WhichColourPicker=='ChartColour') {
		var objcolour = document.getElementById("ChartColour");
		var Objcolourpanel= document.getElementById("colourpanel");
	} else if (WhichColourPicker=='TextColour') {
		var objcolour = document.getElementById("TextColour");
		var Objcolourpanel= document.getElementById("textcolourpanel");
	} else if (WhichColourPicker=='SELChartColour') {
		var objcolour = document.getElementById("SELChartColour");
		var Objcolourpanel= document.getElementById("SELcolourpanel");
	} else if (WhichColourPicker=='SELTextColour') {
		var objcolour = document.getElementById("SELTextColour");
		var Objcolourpanel= document.getElementById("SELtextcolourpanel");
	}
	if (Objcolourpanel) {
		if (objcolour && objcolour.value!="") {
			try {
				Objcolourpanel.style.background=objcolour.value;
				Objcolourpanel.disabled = true;
			} catch(e) { }
		}
	}
}
function OpenChartColorPalette() {
	WhichColourPicker = 'ChartColour';
	OpenPalette();
}
function OpenTextColorPalette() {
	WhichColourPicker = 'TextColour';
	OpenPalette();
}
function OpenSELChartColorPalette() {
	WhichColourPicker = 'SELChartColour';
	OpenPalette();
}
function OpenSELTextColorPalette() {
	WhichColourPicker = 'SELTextColour';
	OpenPalette();
}
function OpenPalette() {
	var url = "websys.colorpalette.csp?SimplePallette=1";
	// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,"Palette","top=70,left=440,width=150,height=350,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
	return false;
}
function ColorPicker(color) {
	var colourarr = color.split(",")
	if (WhichColourPicker=='ChartColour') {
		var objcolour = document.getElementById("ChartColour");
		var objcolourpanel = document.getElementById("colourpanel");
	} else if (WhichColourPicker=='TextColour') {
		var objcolour = document.getElementById("TextColour");
		var objcolourpanel = document.getElementById("textcolourpanel");
	} else if (WhichColourPicker=='SELChartColour') {
		var objcolour = document.getElementById("SELChartColour");
		var objcolourpanel = document.getElementById("SELcolourpanel");
	} else if (WhichColourPicker=='SELTextColour') {
		var objcolour = document.getElementById("SELTextColour");
		var objcolourpanel = document.getElementById("SELtextcolourpanel");
	}
	if (objcolour) {
		if (colourarr[0]!="") {
			objcolour.value=colourarr[1];
			if (objcolourpanel) ColourPanel(WhichColourPicker);
		}
	}
}

function SectionLinkHandler(e) {
	var eSrcAry=window.event.srcElement.id.split("z");
	if (eSrcAry.length>0) {
		if (eSrcAry[0]=="ItemDesc") {
			var ChartItemType=f.elements["ChartItemTypez"+eSrcAry[1]].value;
			//alert("ChartITemType="+ChartItemType);
			// Log 43334 - AI - 11-05-2004 : Questionnaire Edit Profile (QE) the same as Questionnaire Profile layout.
			if ((ChartItemType=="OP")||(ChartItemType=="RP")||(ChartItemType=="QP")||(ChartItemType=="LP")||(ChartItemType=="LC")||(ChartItemType=="LG")||(ChartItemType=="LT")||(ChartItemType=="BT")||(ChartItemType=="TP")||(ChartItemType=="BP")||(ChartItemType=="QE")||(ChartItemType=="MC")||(ChartItemType=="CT")||(ChartItemType=="DI")||(ChartItemType=="PI")||(ChartItemType=="PP")) {
				var ChartSection=f.elements["ChartItemDescz"+eSrcAry[1]].value;
				//alert(ChartSection);
				var ChartSectionID=f.elements["ItemIDz"+eSrcAry[1]].value;
				//alert(ChartSectionID);
				if ((ChartSectionID!="")&&(ChartSection!="")) {
					var vals="PPType="+ChartItemType+"&PPDesc="+websys_escape(ChartSection)+"&ID="+ChartSectionID;
					websys_createWindow('epr.ctprofileparams.edit.csp?'+vals,'Profiles','top=0,left=0,width=550,height=550,scrollbars=yes,resizable=yes');
					return false;
				}
			}
		}
	}
	return true;
}
var WhichColourPicker  = "";
document.body.onload = BodyLoadHandler;
