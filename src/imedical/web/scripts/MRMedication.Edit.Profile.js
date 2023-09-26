// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var f=document.fMRMedication_Edit_Profile;
//create a global array (arrTestItems) matching testcodes with their descriptions, eg: arrTestItems['A010']='Full Blood Count';
//this avoids multiple looping for matches.
var arrCatItems=new Array();
var arrtempval=allcatval.split(',');
var arrtemptxt=allcattxt.split('^');
for (var i=0;i<arrtempval.length;i++) {
	arrCatItems[arrtempval[i]]=arrtemptxt[i];
}
var arrOrdPrioItems=new Array();
var arrtempval2=allordprioval.split(',');
var arrtemptxt2=allordpriotxt.split('^');
for (var i=0;i<arrtempval2.length;i++) {
	arrOrdPrioItems[arrtempval2[i]]=arrtemptxt2[i];
}
var arrStatItems=new Array();
var arrtempval3=allstatval.split(',');
var arrtemptxt3=allstattxt.split('^');
for (var i=0;i<arrtempval3.length;i++) {
	arrStatItems[arrtempval3[i]]=arrtemptxt3[i];
}


// Log 43983 - AI - 28-06-2004 : If the ExcludeCurrentEpisode checkbox is checked, make sure the EpisodesAll checkbox is also checked.
var obj=f.ExcludeCurrentEpisode; if (obj) obj.onclick=ExcludeCurrentEpisodeClickHandler;

function UpdateClickHandler(e)
{
	setParameters()
	return update1_click()
}

function setParameters()
{
	// Include Current Medications checkbox
	if (f.IncludeCurrentMRMedications)
	{
		if (f.IncludeCurrentMRMedications.checked==true) {var inclCurrMed=1} else {var inclCurrMed=0;}
	} else {
		var inclCurrMed=0;
	}

	// Include Ceased Medications checkbox
	if (f.IncludeCeasedMRMedications)
	{
		if (f.IncludeCeasedMRMedications.checked==true) {var inclCeasedMed=1} else {var inclCeasedMed=0;}
	} else {
		var inclCeasedMed=0;
	}

	// Row Colour
	var colour="";
	var obj=f.RowColour;
	if (obj) colour=obj.value;

	// Order Categories
	var obj=f.CategorySelected;
	var ary1="";
	if (obj) {
		ary1=returnValues(obj);
		ary1=ary1.join(",");
	}

	// Order Subcategories - special way of selection (selsubcat ... variables)
	// Log 41352 - AI - 29-01-2004 : Add the selected Subcategories.
	var selsubcatdata=selsubcattxt+"*"+selsubcatval+"*"+selsubcatcode;

	// Order Priorities
	var obj = f.OrderPrioritySelected;
	var ary2="";
	if (obj) {
		ary2=returnValues(obj);
		ary2=ary2.join(",");
	}

	// Include All Episodes checkbox
	if (f.IncludeAllEpisodes)
	{
		if (f.IncludeAllEpisodes.checked==true) {var eAll=1} else {var eAll=0;}
	} else {
		var eAll=0;
	}

	// Only Show Entries Marked For DS checkbox
	// Log 55973 - PJC - 20-12-2005 : Add the "Only show entries marked for DS Report" checkbox.
	if (f.OnlyShowEntriesMarkedForDS)
	{
		if (f.OnlyShowEntriesMarkedForDS.checked==true) {var OnlyDSReport=1} else {var OnlyDSReport=0;}
	} else {
		var OnlyDSReport=0;
	}

	// Order Status
	// Log 59620 - AI - 16-06-2006 : Add the selected Order Status.
	var obj = f.StatusSelected;
	var ary3="";
	if (obj) {
		ary3=returnValues(obj);
		ary3=ary3.join(",");
	}

	// Non Current Orders checkbox
	// Log 59620 - AI - 16-06-2006 : Add the "Non Current Orders" checkbox.
	if (f.NonCurrentOrders)
	{
		if (f.NonCurrentOrders.checked==true) {var NonCurrentOrders=1} else {var NonCurrentOrders=0;}
	} else {
		var NonCurrentOrders=0;
	}

	f.PPParameters.value=inclCurrMed+"|"+inclCeasedMed+"|"+colour+"|"+ary1+"|"+selsubcatdata+"|"+ary2+"|"+eAll+"|"+OnlyDSReport+"|"+ary3+"|"+NonCurrentOrders;
}

var frm=document.forms['fMRMedication_Edit_Profile'];

function LookUpMedicationProfileName(val)
{
	var ary=val.split("^");
	frm.elements['ID'].value=ary[1];
	//fire broker to fetch params from selected profile id
	//frm.elements['xfetchparams'].change();
	//NB: may not work with N6
	var evt = document.createEventObject();
	frm.elements['xfetchparams'].fireEvent("onchange",evt);
}

//wrapper to call broker on hidden field to fetch params
function xfetchparams_changehandler(encmeth)
{
	if (cspRunServerMethod(encmeth,'AddParams',frm.elements['ID'].value))
	{
	}
}

function completeForm(str,graph)
{
	AddParams(str.join('|'));
}

function AddParams(str)
{
	var arr=str.split('|');

	if (arr[0]&&(f.IncludeCurrentMRMedications))
	{
		if (arr[0]==1) {f.IncludeCurrentMRMedications.checked=true;} else {f.IncludeCurrentMRMedications.checked=false}
	} else {
		if (f.IncludeCurrentMRMedications)
		{
			f.IncludeCurrentMRMedications.checked=false;
		}
	}
	if (arr[1]&&(f.IncludeCeasedMRMedications))
	{
		if (arr[1]==1) {f.IncludeCeasedMRMedications.checked=true;} else {f.IncludeCeasedMRMedications.checked=false}
	} else {
		if (f.IncludeCeasedMRMedications)
		{
			f.IncludeCeasedMRMedications.checked=false;
		}
	}
	str=arr[2];
	if (str)
	{
		obj=f.RowColour;
		if ( obj )
		{
			f.RowColour.value=str;
			ColourThePanel("RowColourPanel","RowColour");
		}
	}
	str=arr[3];
	if (str)
	{
		lst=frm.elements['CategorySelected'];
		if (lst) {
			ClearAllList(lst);
			var arrParams=str.split(',');
			var code='';
			for (var i=0; i<arrParams.length; i++)
			{
				code=arrParams[i];
				lst.options[lst.options.length] = new Option(arrCatItems[code],code);
			}
		}
	}
	// Log 41352 - AI - 29-01-2004 : Add the selected Subcategories.
	lst=frm.elements['SubcategorySelected'];
	if (lst)
	{
		ClearAllList(lst);
		str=arr[4];
		// str is saved as "" + "*" + "" + "*" + "" (**) if a blank list is saved.
		if ((str)&&(str!="**"))
		{
			var selsubcatdata=str.split("*");
			selsubcattxt=selsubcatdata[0];
			selsubcatval=selsubcatdata[1];
			selsubcatcode=selsubcatdata[2];
			var seltxtAry=selsubcattxt.split(",");
			var selvalAry=selsubcatval.split(",");
			var selcodeAry=selsubcatcode.split(",");

			for (var i=0; i<selvalAry.length; i++)
			{
				id=selvalAry[i];
				desc=seltxtAry[i];
				lst.options[lst.options.length]=new Option(desc,id);
			}
		}
	}
	// end Log 41352
	str=arr[5];
	if (str)
	{
		lst=frm.elements['OrderPrioritySelected'];
		if (lst) {
			ClearAllList(lst);
			var arrParams=str.split(',');
			var code='';
			for (var i=0; i<arrParams.length; i++)
			{
				code=arrParams[i];
				lst.options[lst.options.length] = new Option(arrOrdPrioItems[code],code);
			}
		}
	}
	if (arr[6]&&(f.IncludeAllEpisodes))
	{
		if (arr[6]==1) {f.IncludeAllEpisodes.checked=true;} else {f.IncludeAllEpisodes.checked=false}
	} else {
		if (f.IncludeAllEpisodes)
		{
			f.IncludeAllEpisodes.checked=false;
		}
	}
	// Log 55973 - PJC - 20-12-2005 : Add the "Only show entries marked for DS Report" checkbox.
	if (arr[7]&&(f.OnlyShowEntriesMarkedForDS))
	{
		if (arr[7]==1) {f.OnlyShowEntriesMarkedForDS.checked=true;} else {f.OnlyShowEntriesMarkedForDS.checked=false}
	} else {
		if (f.OnlyShowEntriesMarkedForDS)
		{
			f.OnlyShowEntriesMarkedForDS.checked=false;
		}
	}
	// end Log 55973

	// Log 59620 - AI - 16-06-2006 : Add the selected order Status.
	str=arr[8];
	if (str) {
		lst=frm.elements['StatusSelected'];
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
	// end Log 59620

	// Log 59620 - AI - 16-06-2006 : Add the "Non Current Orders" checkbox.
	if (arr[9]&&(f.NonCurrentOrders))
	{
		if (arr[9]==1) {f.NonCurrentOrders.checked=true;} else {f.NonCurrentOrders.checked=false}
	} else {
		if (f.NonCurrentOrders)
		{
			f.NonCurrentOrders.checked=false;
		}
	}
	// end Log 59620

}

// colour the panels
var obj=document.getElementById("RowPallette");
if (obj) obj.onclick=OpenPalette;
var obj=document.getElementById("RowColour");
if (obj)
{
	obj.onkeydown=Colorlookuphandler;
  obj.onblur=ColorBlur;
}

function Colorlookuphandler(e)
{
	// this checks for F6…
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='keydown')&&(key==117))
	{
  	OpenPalette()
    return websys_cancel();
	}
}

function ColourThePanel(whichpanel,whichcolour)
{
 	var Objcolourpanel= document.getElementById(whichpanel);
  var Objcolour= document.getElementById(whichcolour);
  if (Objcolourpanel && Objcolour)
	{
  	try
		{
			if (Objcolour.value!="")
			{
      	Objcolourpanel.style.background=Objcolour.value;
      } else {
      	Objcolourpanel.style.background="#ffffff";
      }
      Objcolourpanel.disabled = true;
    } catch(e) { }
  }
}

function ColorBlur()
{
	// on exit – this colours the panel the correct colour
  ColourThePanel("RowColourPanel","RowColour");
}

function OpenPalette()
{
  	var url = "websys.colorpalette.csp?SimplePallette=1";
    //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
    websys_createWindow(url,"Palette","top=70,left=440,width=150,height=350,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
    return false;
}

function ColourPanel(WhichColourPicker) {
	var objcolour = "";
	var Objcolourpanel="";

	if (WhichColourPicker=='RowColour') {
		var objcolour = document.getElementById("RowColour");
		var Objcolourpanel= document.getElementById("RowColourPanel");
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

function ColorPicker(color)
{
	var colourarr = color.split(",")
	var objcolour = document.getElementById("RowColour");
 	var objcolourpanel = document.getElementById("RowColourPanel");
	if (objcolour) objcolour.value=colourarr[1];
	if (objcolourpanel) ColourPanel("RowColour");
}
