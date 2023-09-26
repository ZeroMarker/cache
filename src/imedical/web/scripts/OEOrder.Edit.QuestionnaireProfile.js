// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

f=document.fOEOrder_Edit_QuestionnaireProfile;
//create a global array (arrTestItems) matching testcodes with their descriptions, eg: arrTestItems['A010']='Full Blood Count';
//this avoids multiple looping for matches.
var arrQuestItems=new Array();
var arrtempval=allquesval.split('^');
var arrtemptxt=allquestxt.split('^');
for (var i=0;i<arrtempval.length;i++) {
	arrQuestItems[arrtempval[i]]=arrtemptxt[i];
}

function UpdateClickHandler(e) {
	var obj = f.QuestionnaireSelected;
	var ary="";
	if (obj) {
		ary=returnValues(obj);
		ary=ary.join(",");
	}
	if (f.EpisodesAll) {
		if (f.EpisodesAll.checked==true) {var eAll=1} else {var eAll=0;}
	} else {
		var eAll=0;
	}
	if (f.ThisPregnancy) {
		if (f.ThisPregnancy.checked==true) {var eThisPreg=1} else {var eThisPreg=0;}
	} else {
		var eThisPreg=0;
	}
	f.PPParameters.value=ary+"|"+eAll+"|"+eThisPreg;
	return update1_click()
}

var frm=document.forms['fOEOrder_Edit_QuestionnaireProfile'];

function LookUpQuestionProfileName(val) {
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
		lst=frm.elements['QuestionnaireSelected'];
		if (lst) {
			ClearAllList(lst);
			var arrParams=str.split(',');
			var code='';
			for (var i=0; i<arrParams.length; i++) {
				code=arrParams[i];
				lst.options[lst.options.length] = new Option(arrQuestItems[code],code);
			}
		}
	}
	if (arr[1]&&(f.EpisodesAll)) {
		if (arr[1]==1) {f.EpisodesAll.checked=true;} else {f.EpisodesAll.checked=false}
	} else {
		if (f.objEpisAll) {
			f.EpisodesAll.checked=false
		}	
	}
	if (arr[2]&&(f.ThisPregnancy)) {
		if (arr[2]==1) {f.ThisPregnancy.checked=true;} else {f.ThisPregnancy.checked=false}
	} else {
		if (f.ThisPregnancy) {
			f.ThisPregnancy.checked=false
		}
	}

}
