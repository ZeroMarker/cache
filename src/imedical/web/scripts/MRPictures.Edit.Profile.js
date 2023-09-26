// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var f=document.fMRPictures_Edit_Profile;
var frm=document.forms['fMRPictures_Edit_Profile'];

//create a global array (arrTestItems) matching testcodes with their descriptions, eg: arrTestItems['A010']='Full Blood Count';
//this avoids multiple looping for matches.
var arrPicTypeItems=new Array();
var arrtempval=alldoctypesval.split(',');
var arrtemptxt=alldoctypestxt.split('^');
for (var i=0;i<arrtempval.length;i++) {
	arrPicTypeItems[arrtempval[i]]=arrtemptxt[i];
}

function LookUpPictureProfileName(val) {
	var ary=val.split("^");
	frm.elements['ID'].value=ary[1];
	//fire broker to fetch params from selected profile id
	//frm.elements['xfetchparams'].change();
	//NB: may not work with N6
  AddParams(ary[3]);
}

function LookUpPictType(val) {
	f.PictType.value="";
	if(f.PictTypeSelected) TransferToList(f.PictTypeSelected,val);
}

function UpdateClickHandler(e) {
	var doc_ary="";
	var obj=f.PictTypeSelected;
	if (obj) {
		doc_ary=returnValues(obj);
		if(doc_ary!="") {doc_ary=doc_ary.join(",");}
	}
	var eAll=0;
	if (f.EpisodesAll) {
		if (f.EpisodesAll.checked==true) { eAll=1; }
	}
	f.PPParameters.value=doc_ary+"|"+eAll;

	return update1_click();
}

function completeForm(str,graph) {
	AddParams(str.join('|'));
}

function AddParams(str) {
	var arr=str.split('|');
	str=arr[0];
	if (str) {
		lst=frm.elements['PictTypeSelected'];
		if (lst) {
			ClearAllList(lst);
			var arrParams=str.split(',');
			var code='';
			for (var i=0; i<arrParams.length; i++) {
				code=arrParams[i];
				lst.options[lst.options.length] = new Option(arrPicTypeItems[code],code);
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
}