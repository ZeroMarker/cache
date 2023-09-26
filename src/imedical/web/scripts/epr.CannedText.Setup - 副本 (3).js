// Copyright (c) 2006 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


function GetDesc(type) {
	var desc="";
	var objreftype=document.getElementById('ReferenceType');
	var objrefid=document.getElementById('ReferenceID');
	switch (type) {
		case 'User.SSGroup' :  //fall thru to 'G'
		case 'G' : desc = local['LOGON.GROUPDESC'];
					objreftype.value='User.SSGroup';
					objrefid.value=session['LOGON.GROUPID']
			break;
		case 'User.CTHospital' :  //fall thru to 'H'
		case 'H' : desc = local['LOGON.HOSPDESC'];
					objreftype.value='User.CTHospital';
					objrefid.value=local['LOGON.HOSPID']
			break;
		case 'User.PACTrust' :  //fall thru to 'R'
		case 'R' : desc = local['LOGON.TRUSTDESC'];
					objreftype.value='User.PACTrust';
					objrefid.value=local['LOGON.TRUSTID']
			break;
		case 'SITE' :  //fall thru to 'T'
		case 'T' : desc = local['LOGON.SITECODE'];
					objreftype.value='SITE';
					objrefid.value=session['LOGON.SITECODE']
			break;
		case 'User.SSUser' :  //fall thru
		case 'U' : //fall thru to default
		default : desc = local['LOGON.USERCODE'];
					objreftype.value='User.SSUser';
					objrefid.value=session['LOGON.USERID']
			break;
	}
	return desc;
}
function SetSaveAs(type) {
	var obj=document.getElementById('SaveAs');
	if (obj) obj.innerText=GetDesc(type);
}
SetSaveAs(document.getElementById('ReferenceType').value);
function epr_CannedText_Setup_SelectRowHandler(evt) {
	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	if (eSrc.tagName=="A") {
		if (eSrc.id.indexOf('tbliTextz')==0) {
			eSrc.href+="&ReferenceType="+document.getElementById('ReferenceType').value+"&ReferenceID="+document.getElementById('ReferenceID').value;
			return true;
		}
	}
}
var tbl=document.getElementById('tepr_CannedText_Setup');
if (tbl) {
	tbl.tCompName="epr_CannedText_Setup";
	tbl.onclick=epr_CannedText_Setup_SelectRowHandler
}