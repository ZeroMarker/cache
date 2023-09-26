// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Log 44852 - AI - 14-07-2004 : New file created for new component.
function BodyLoadHandler() {
	// Log 45037 - AI - 05-10-2004 : Add the new fields ...
	var obj=document.getElementById('HL7PRSavePermAddPrevPerm'); if (obj) obj.onclick=HL7PRSavePermAddPrevPermClickHandler;
	var obj=document.getElementById('HL7PROverseasAddPermAdd'); if (obj) obj.onclick=HL7PROverseasAddPermAddClickHandler;

	// Log 45037 - AI - 05-10-2004 : Populate the empty HL7PRTempAddEndDelete List with the 3 options.
	var obj=document.getElementById('HL7PRTempAddEndDelete');
	if (obj) {
		obj.multiple=false;
		obj[0]= new Option("");
		obj[1]= new Option(t['EndDate']);
		obj[2]= new Option(t['Delete']);
		var obj1=document.getElementById('TempAddEndDelete');
		// mark the selected option as selected (if applicable).
		if (obj1) {
			if (obj1.value=="E") {
				obj[1].selected=true;
			} else if (obj1.value=="D") {
				obj[2].selected=true;
			} else {
				obj[0].selected=true;
			}
		}
	}
	
	// Log 45037 - AI - 05-10-2004 : If any of the new checkboxes are checked, mark applicable fields as mandatory.
	HL7PRSavePermAddPrevPermClickHandler();
	HL7PROverseasAddPermAddClickHandler();
	// end Log 45037
	
	// Log 47308 - AI - 26-11-2004 : Populate the empty HL7PRUpdateDateTime List with the 3 options.
	var obj=document.getElementById('HL7PRUpdateDateTime');
	if (obj) {
		var objLabel=document.getElementById('cHL7PRUpdateDateTime');
		if (objLabel) objLabel.className="clsRequired";
		obj.multiple=false;
		obj[0]= new Option(t['EVN2']);
		obj[1]= new Option(t['EVN6']);
		obj[2]= new Option(t['CDT']);
		var obj1=document.getElementById('UpdateDateTime');
		// mark the selected option as selected (if applicable).
		if (obj1) {
			if (obj1.value=="EVN2") {
				obj[0].selected=true;
			} else if (obj1.value=="EVN6") {
				obj[1].selected=true;
			} else if (obj1.value=="CDT") {
				obj[2].selected=true;
			}
		}
	}
	// end Log 47308
	
	// Log 50619 - AI - 01-03-2005 : Populate the empty HL7PRTempAddFromDate List with the 3 options.
	var obj=document.getElementById('HL7PRTempAddFromDate');
	if (obj) {
		var objLabel=document.getElementById('cHL7PRTempAddFromDate');
		obj.multiple=false;
		obj[0]= new Option(t['EVN2']);
		obj[1]= new Option(t['EVN6']);
		obj[2]= new Option(t['CDT']);
		var obj1=document.getElementById('TempAddFromDate');
		// mark the selected option as selected (if applicable).
		if (obj1) {
			if (obj1.value=="EVN2") {
				obj[0].selected=true;
			} else if (obj1.value=="EVN6") {
				obj[1].selected=true;
			} else if (obj1.value=="CDT") {
				obj[2].selected=true;
			}
		}
	}
	// end Log 50619

	var obj=document.getElementById('update1'); if (obj) obj.onclick=UpdateClickHandler;
}

// Log 45037 - AI - 05-10-2004 : When checked, make the next field mandatory.
function HL7PRSavePermAddPrevPermClickHandler() {
	var obj1=document.getElementById('HL7PRSavePermAddPrevPerm');
	var obj2=document.getElementById('cHL7PRPreviousPermAddType');
	var obj3=document.getElementById('HL7PROverseasAddPermAdd');
	if ((obj1)&&(obj1.checked)) {
		if (obj2) obj2.className="clsRequired";
	} else {
		if ((obj2)&&((obj3)&&(obj3.checked==false))) obj2.className="";
		if ((obj2)&&(!(obj3))) obj2.className="";
	}
}

// Log 45037 - AI - 05-10-2004 : When checked, make the previous and next fields mandatory.
function HL7PROverseasAddPermAddClickHandler() {
	var obj1=document.getElementById('HL7PROverseasAddPermAdd');
	var obj2=document.getElementById('cHL7PRPreviousPermAddType');
	var obj3=document.getElementById('cHL7PROverseasAddType');
	var obj4=document.getElementById('HL7PRSavePermAddPrevPerm');
	if ((obj1)&&(obj1.checked)) {
		if (obj2) obj2.className="clsRequired";
		if (obj3) obj3.className="clsRequired";
	} else {
		if ((obj2)&&((obj4)&&(obj4.checked==false))) obj2.className="";
		if ((obj2)&&(!(obj4))) obj2.className="";
		if (obj3) obj3.className="";
	}
}
// end Log 45037

function SetSelectedDisSum() {
	var dissums="";
	var lst = document.getElementById('HL7PRDischSumNotRequired');
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			if (lst.options[j].selected) {
				var selected="Y";
			}
			else {
				var selected="N";
			}
			if (dissums!="") dissums = dissums + "|" + lst.options[j].value + "*" + selected;
			if (dissums=="") dissums = lst.options[j].value + "*" + selected;
		}
		var objSelDisSum = document.getElementById('selectedDisSum');
		if (objSelDisSum) {
			objSelDisSum.value=dissums;
		}
	}
}

function UpdateClickHandler() {
	// Log 45037 - AI - 05-10-2004 : Check that any mandatory fields have values.
	var msg="";
	var obj1=document.getElementById('cHL7PRPreviousPermAddType');
	var obj2=document.getElementById('HL7PRPreviousPermAddType');
	var obj3=document.getElementById('cHL7PROverseasAddType');
	var obj4=document.getElementById('HL7PROverseasAddType');
	if ((obj1)&&(obj1.className=="clsRequired")&&(obj2)&&(obj2.value=="")) {
		msg=("'" + t['HL7PRPreviousPermAddType'] + "' " + t['IsRequired']);
		obj2.className="clsInvalid";
	} else if (obj2) {
		obj2.className="";
	}
	if ((obj3)&&(obj3.className=="clsRequired")&&(obj4)&&(obj4.value=="")) {
		if (msg!="") msg=(msg + "\n'" + t['HL7PROverseasAddType'] + "' " + t['IsRequired']);
		if (msg=="") msg=("'" + t['HL7PROverseasAddType'] + "' " + t['IsRequired']);
		obj4.className="clsInvalid";
	} else if (obj4) {
		obj4.className="";
	}
	
	// Log 47308 - AI - 26-11-2004 : Ensure new field UpdateDateTime is selected as well.
	var obj5=document.getElementById('HL7PRUpdateDateTime');
	if ((obj5)&&(!(obj5[0].selected))&&(!(obj5[1].selected))&&(!(obj5[2].selected))) {
		if (msg!="") msg=(msg + "\n'" + t['HL7PRUpdateDateTime'] + "' " + t['IsRequired']);
		if (msg=="") msg=("'" + t['HL7PRUpdateDateTime'] + "' " + t['IsRequired']);
		obj5.className="clsInvalid";
	} else if (obj5) {
		obj5.className="";
	}
	// end Log 47308
	
	if (msg!="") {
		alert(msg);
		return false;
	}
	// end Log 45037

	SetSelectedDisSum();

	// Log 45037 - AI - 05-10-2004 : Save the selection from the List.
	var obj=document.getElementById('HL7PRTempAddEndDelete');
	if (obj) {
		var obj1=document.getElementById('TempAddEndDelete');
		if (obj1) {
			if (obj[1].selected) {
				obj1.value="E";
			} else if (obj[2].selected) {
				obj1.value="D";
			} else {
				obj1.value="";
			}
		}
	}
	// end Log 45037
	
	// Log 47308 - AI - 26-11-2004 : Save the selection from the List.
	var obj=document.getElementById('HL7PRUpdateDateTime');
	if (obj) {
		var obj1=document.getElementById('UpdateDateTime');
		if (obj1) {
			if (obj[0].selected) {
				obj1.value="EVN2";
			} else if (obj[1].selected) {
				obj1.value="EVN6";
			} else if (obj[2].selected) {
				obj1.value="CDT";
			}
		}
	}
	// end Log 47308

	// Log 50619 - AI - 01-03-2005 : Save the selection from the List.
	var obj=document.getElementById('HL7PRTempAddFromDate');
	if (obj) {
		var obj1=document.getElementById('TempAddFromDate');
		if (obj1) {
			if (obj[0].selected) {
				obj1.value="EVN2";
			} else if (obj[1].selected) {
				obj1.value="EVN6";
			} else if (obj[2].selected) {
				obj1.value="CDT";
			}
		}
	}
	// end Log 50619

	return update1_click();
}

document.body.onload=BodyLoadHandler;
