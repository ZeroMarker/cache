// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Log 43334 - AI - 11-05-2004 : File created for new Profile.

var f=document.fOEOrder_Edit_QuestionnaireEditProfile;
var frm=document.forms['fOEOrder_Edit_QuestionnaireEditProfile'];

// 'quesid' is the ID of the Questionnaire Profile associated to the current/selected Questionnaire Edit Profile.
var quesid="";

function UpdateClickHandler(e) {
	// Log 54917 YC - if broker lookup function for questionnaire hasn't been activated, 
	// we want to use the previously saved value.
	var objQProfile=frm.elements['Questionnaire'];
	if (objQProfile) {
		if(quesid=="" && objQProfile.value!="") quesid=f.PPParameters.value;
	}
	f.PPParameters.value=quesid;
	return update1_click();
}

function completeForm(str,graph) {
	AddParams(str.join('|'));
}

function AddParams(str) {
	var arr=str.split('|');

	var objQProfile=frm.elements['Questionnaire'];
	if (objQProfile) {
		if (arr[0]) {
			objQProfile.value="";
			var valAry=allquesprofval.split("^");
			var txtAry=allquesproftxt.split("^");
			for (var i=0; i<valAry.length; i++) {
				if (valAry[i]==arr[0]) {
					objQProfile.value=txtAry[i];
				}
			}
		} else {
			objQProfile.value="";
		}
	}
}

function LookUpQuestionnaireEditProfileName(val) {
	var ary=val.split("^");
	frm.elements['ID'].value=ary[1];
	//fire broker to fetch params from selected profile id
	//frm.elements['xfetchparams'].change();
	//NB: may not work with N6
	var evt = document.createEventObject();
	frm.elements['xfetchparams'].fireEvent("onchange",evt);
}

function LookUpQuestionnaire(val) {
	var ary=val.split("^");
	quesid=ary[1];
}

//wrapper to call broker on hidden field to fetch params
function xfetchparams_changehandler(encmeth) {
	if (cspRunServerMethod(encmeth,'AddParams',frm.elements['ID'].value)) {
	}
}

