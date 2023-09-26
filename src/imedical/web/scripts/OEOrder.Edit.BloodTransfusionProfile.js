// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

f=document.fOEOrder_Edit_BloodTransfusionProfile;
//create a global array (arrTestItems) matching testcodes with their descriptions, eg: arrTestItems['A010']='Full Blood Count';
//this avoids multiple looping for matches.
var arrLocItems=new Array();
var arrtempval=alllocval.split(',');
var arrtemptxt=allloctxt.split('^');
for (var i=0;i<arrtempval.length;i++) {
	arrLocItems[arrtempval[i]]=arrtemptxt[i];
}
var arrBloodItems=new Array();
var arrtempval2=allbloodprodval.split(',');
var arrtemptxt2=allbloodprodtxt.split('^');
for (var i=0;i<arrtempval2.length;i++) {
	arrBloodItems[arrtempval2[i]]=arrtemptxt2[i];
}
var arrStatItems=new Array();
var arrtempval3=allstatval.split(',');
var arrtemptxt3=allstattxt.split('^');
for (var i=0;i<arrtempval3.length;i++) {
	arrStatItems[arrtempval3[i]]=arrtemptxt3[i];
}

function UpdateClickHandler(e) {
	setParameters()
	return update1_click()
}
function setParameters() {
	var Stat_ary="";
	var Loc_ary="";
	var BloodProd_ary="";
	
	var obj = f.StatusSelected;
	if (obj) {
		Stat_ary=returnValues(obj);
		if (Stat_ary!="") Stat_ary=Stat_ary.join(",");
	}
	var obj = f.LocationSelected;
	if (obj) {
		Loc_ary=returnValues(obj);
		if (Loc_ary!="") Loc_ary=Loc_ary.join(",");
	}
	// Log 27755 - AI - 22-10-2002 : Add functionality for Blood Product.
	var obj = f.BloodProductSelected;
	if (obj) {
		BloodProd_ary=returnValues(obj);
		if (BloodProd_ary!="") BloodProd_ary=BloodProd_ary.join(",");
	}
	f.PPParameters.value=Stat_ary+"|"+Loc_ary+"|"+BloodProd_ary;
}
var frm=document.forms['fOEOrder_Edit_BloodTransfusionProfile'];

function LookUpBloodProfileName(val) {
	var ary=val.split("^");
	frm.elements['ID'].value=ary[1];
	//fire broker to fetch params from selected profile id
	//frm.elements['xfetchparams'].change();
	//NB: may not work with N6
	var evt = document.createEventObject();
	frm.elements['xfetchparams'].fireEvent("onchange",evt);
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
	str=arr[0];
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
	str=arr[1];
	if (str) {
		lst=frm.elements['LocationSelected'];
		if (lst) {
			ClearAllList(lst);
			var arrParams=str.split(',');
			var code='';
			for (var i=0; i<arrParams.length; i++) {
				code=arrParams[i];
				lst.options[lst.options.length] = new Option(arrLocItems[code],code);
			}
		}
	}
	str=arr[2];
	if (str) {
		lst=frm.elements['BloodProductSelected'];
		if (lst) {
			ClearAllList(lst);
			var arrParams=str.split(',');
			var code='';
			for (var i=0; i<arrParams.length; i++) {
				code=arrParams[i];
				lst.options[lst.options.length] = new Option(arrBloodItems[code],code);
			}
		}
	}
}