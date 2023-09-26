
// Log 59925 - ML - 05-07-2006 ; split rejection messages into notifications and rejections
function RejectionTypeChangeHandler(str) {
	var lu = str.split("^") ;
	var obj = document.getElementById("HL7RejectionType");
	if (obj) {
		obj.value=lu[2] ;
	}
}

/*
//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Log 26322 - AI - 31-07-2002: Created this js file because of the checkbox "ViewAckRejections".
//			The checkbox needs to be converted for the SQL to work.	For this conversion to be done, 
//			use the hidden field "ViewUnAck" (view unacknowledged only). If NULL, ViewUnAck is "Yes".

function BodyLoadHandler() {
	var obj=document.getElementById('ViewAckRejections');
	if (obj) obj.onchange=ViewAckChangeHandler;

	// Log 45047 - AI - 13-09-2004 : Set up the new SearchString functionality.
	var obj=document.getElementById('SearchString');
	if (obj) {
		obj.onblur=SearchStringBlurHandler;
	}

	// Log 45047 - AI - 13-09-2004 : Add a Find Click Handler, to check validation before continuing.
	var obj=document.getElementById('find1');
	if (obj) {
		obj.onclick=FindClickHandler;
	}
}

// chkobj is the checkbox, txtobj is the textbox.
// also note the chk is "ViewAck" and txt is "ViewUnAck", so reverse the values found.
function ViewAckChangeHandler() {
	var chkobj=document.getElementById("ViewAckRejections");
	var txtobj=document.getElementById("ViewUnAck");
	if ((chkobj) && (txtobj)) {
		if (chkobj.checked) {
			txtobj.value="N";
		}
		else {
			txtobj.value="Y";
		}
	}
}

// Log 45047 - AI - 13-09-2004 : Set up the new SearchString functionality.
function SearchStringBlurHandler() {
	var obj=document.getElementById('SearchString');
	if (obj) {
		if (obj.value!="") {
			var obj2=document.getElementById('cDateRecFrom');
			if (obj2) obj2.className="clsRequired";
			var obj3=document.getElementById('cDateRecTo');
			if (obj3) obj3.className="clsRequired";
		} else {
			var obj2=document.getElementById('cDateRecFrom');
			if (obj2) obj2.className="";
			var obj3=document.getElementById('cDateRecTo');
			if (obj3) obj3.className="";
		}
	}
}

// Log 45047 - AI - 13-09-2004 : Add a Find Click Handler, to check validation before continuing.
function FindClickHandler() {
	// Log 45047 - AI - 13-09-2004 : If Search String exists, ONLY continue IF Search Date From and Search Date To have values.
	var searchstr="";
	var obj=document.getElementById("SearchString");
	if (obj) searchstr=obj.value;
	var errmsg="";
	var obj2=document.getElementById('cDateRecFrom');
	var objval2=document.getElementById('DateRecFrom');
	if ((obj2)&&(obj2.className=="clsRequired")&&(objval2.value=="")&&(searchstr!="")) {
		if (errmsg!="") errmsg=errmsg+"\n"+t['DateFromReq'];
		if (errmsg=="") errmsg=t['DateFromReq'];
		if (objval2) objval2.className="clsInvalid";
	} else {
		if (objval2) objval2.className="";
	}
	var obj3=document.getElementById('cDateRecTo');
	var objval3=document.getElementById('DateRecTo');
	if ((obj3)&&(obj3.className=="clsRequired")&&(objval3.value=="")&&(searchstr!="")) {
		if (errmsg!="") errmsg=errmsg+"\n"+t['DateToReq'];
		if (errmsg=="") errmsg=t['DateToReq'];
		if (objval3) objval3.className="clsInvalid";
	} else {
		if (objval3) objval3.className="";
	}

	var obj4=document.getElementById('cHL7RejectionTypeDesc');
	var objval4=document.getElementById('HL7RejectionTypeDesc');
	if ((obj4)&&(obj4.className=="clsRequired")&&(objval4.value=="")) {
		if (errmsg!="") errmsg=errmsg+"\n"+t['RejectionTypeReq'];
		if (errmsg=="") errmsg=t['RejectionTypeReq'];
		if (objval4) objval4.className="clsInvalid";
	} else {
		if (objval4) objval4.className="";
	}

	if (errmsg!="") {
		alert(errmsg);
		return false;
	}

	return find1_click();
}


document.body.onload=BodyLoadHandler;
*/