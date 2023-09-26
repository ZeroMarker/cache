// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Log 29736 - AI - 18-12-2003 : File created for new Profile.

var f=document.fOEOrder_Edit_ObservationProfile;
var frm=document.forms['fOEOrder_Edit_ObservationProfile'];

// 'obsgrpid' is the ID of the Observation Group associated to the current/selected Observation Profile.
var obsgrpid="";

Init();

// To handle the fact that MAXIMUM ONE of "EpisodesAll" and "CurrentPregnancy" can be checked.
function Init() {
	f.EpisodesAll.onclick=EpisodesAllClickHandler;
	f.CurrentPregnancy.onclick=CurrentPregnancyClickHandler;
}

// If the "EpisodesAll" checkbox is checked, uncheck the "CurrentPregnancy" checkbox if it is checked.
function EpisodesAllClickHandler() {
	if ((f.CurrentPregnancy) && (f.CurrentPregnancy.checked==true)) f.CurrentPregnancy.checked=false;
}

// If the "CurrentPregnancy" checkbox is checked, uncheck the "EpisodesAll" checkbox if it is checked.
function CurrentPregnancyClickHandler() {
	if ((f.EpisodesAll) && (f.EpisodesAll.checked==true)) f.EpisodesAll.checked=false;
}

function UpdateClickHandler(e) {
	var ObsGroup=""
	if (f.ObservationGroup) {
		ObsGroup=obsgrpid;
	} 
	// Log 52797 YC - If we did not click on the lookup, we still want to keep the observation group value
	if (ObsGroup=="") {
		var objObsGroup=frm.elements['ObservationGroup'];
		if (objObsGroup) {
			var valAry=allobsgrpval.split("^");
			var txtAry=allobsgrptxt.split("^");
			for (var i=0; i<valAry.length; i++) {
				if (txtAry[i]==objObsGroup.value)					
					ObsGroup = valAry[i];
			}
		}
	}

	var eAll=0;
	if ((f.EpisodesAll) && (f.EpisodesAll.checked==true)) eAll=1;

	var currPreg=0;
	if ((f.CurrentPregnancy) && (f.CurrentPregnancy.checked==true)) currPreg=1;

	var revDate=0;
	if ((f.ReverseDateOrder) && (f.ReverseDateOrder.checked==true)) revDate=1;

	// ab 30.10.06 55575
	var DisplayComments=0;
	if ((f.DisplayComments) && (f.DisplayComments.checked==true)) DisplayComments=1;

	var DisplayLastUpdate=0;
	if ((f.DisplayLastUpdate) && (f.DisplayLastUpdate.checked==true)) DisplayLastUpdate=1;

	f.PPParameters.value=ObsGroup+"|"+eAll+"|"+currPreg+"|"+revDate+"|"+DisplayComments+"|"+DisplayLastUpdate;

	return update1_click();
}

function completeForm(str,graph) {
	AddParams(str.join('|'));
}

function AddParams(str) {
	var arr=str.split('|');
	
	var objObsGroup=frm.elements['ObservationGroup'];
	if (objObsGroup) {
		if (arr[0]) {
			// Log 43911 - AI - 03-06-2004 : Storing the ID but display the Description from the ID.
			//objObsGroup.value=arr[0];
			objObsGroup.value="";
			var valAry=allobsgrpval.split("^");
			var txtAry=allobsgrptxt.split("^");
			for (var i=0; i<valAry.length; i++) {
				if (valAry[i]==arr[0]) {
					objObsGroup.value=txtAry[i];
				}
			}
		} else {
			objObsGroup.value="";
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

	var objCurrPreg=frm.elements['CurrentPregnancy'];
	if (objCurrPreg) {
		if (arr[2]==1) {
			objCurrPreg.checked=true;
		} else {
			objCurrPreg.checked=false;
		}
	}

	var objReverseDate=frm.elements['ReverseDateOrder'];
	if (objReverseDate) {
		if (arr[3]==1) {
			objReverseDate.checked=true;
		} else {
			objReverseDate.checked=false;
		}
	}
	
	var objReverseDate=frm.elements['DisplayComments'];
	if (objReverseDate) {
		if (arr[4]==1) {
			objReverseDate.checked=true;
		} else {
			objReverseDate.checked=false;
		}
	}
	
	var objReverseDate=frm.elements['DisplayLastUpdate'];
	if (objReverseDate) {
		if (arr[5]==1) {
			objReverseDate.checked=true;
		} else {
			objReverseDate.checked=false;
		}
	}
}

function LookUpObservationProfileName(val) {
	var ary=val.split("^");
	frm.elements['ID'].value=ary[1];
	//fire broker to fetch params from selected profile id
	//frm.elements['xfetchparams'].change();
	//NB: may not work with N6
	var evt = document.createEventObject();
	frm.elements['xfetchparams'].fireEvent("onchange",evt);
}

function LookUpObsGroup(val) {
	var ary=val.split("^");
	obsgrpid=ary[1];
}

//wrapper to call broker on hidden field to fetch params
function xfetchparams_changehandler(encmeth) {
	if (cspRunServerMethod(encmeth,'AddParams',frm.elements['ID'].value)) {
	}
}


