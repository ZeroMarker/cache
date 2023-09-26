// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// Log 56894 BoC 7/12/2006

obj=document.getElementById('CPWDateFrom');
if (obj) obj.onchange=DateFromChangeHandler;

obj=document.getElementById('CPWDateTo');
if (obj) obj.onchange=DateToChangeHandler;

function DateToChangeHandler(e) {
		CPWDateTo_changehandler(e) 
		var from=document.getElementById('CPWDateFrom')
		var to=document.getElementById('CPWDateTo')
		var fromdt=DateStringToArray(from.value)
		var todt=DateStringToArray(to.value)
		var dtto=new Date(todt["yr"], todt["mn"]-1, todt["dy"]);
		var dtfrom=new Date(fromdt["yr"], fromdt["mn"]-1, fromdt["dy"]);
		if ((to)&&(from)) {
			if (dtto< dtfrom) {
			alert("\'" + t['CPWDateTo'] + "\' " + t['XINVALID'] + "\n");
			to.value=""
			}
		}
}

function DateFromChangeHandler(e) {
		CPWDateFrom_changehandler(e)
		var to=document.getElementById('CPWDateTo')
		var from=document.getElementById('CPWDateFrom')
		var fromdt=DateStringToArray(from.value)
		var todt=DateStringToArray(to.value)
		var dtto=new Date(todt["yr"], todt["mn"]-1, todt["dy"]);
		var dtfrom=new Date(fromdt["yr"], fromdt["mn"]-1, fromdt["dy"]);
		if ((to)&&(from)) {
			if (dtto< dtfrom) {
			alert("\'" + t['CPWDateFrom'] + "\' " + t['XINVALID'] + "\n");
			from.value=""
			}
		}
}

function IntegerPositive_changehandler() {
	var p1="";
	var eSrc=document.getElementById("CPWNumberOfCycle");
	var isValid=0;
	if (IsValidNumber(eSrc)) {
		isValid=1;
		if (!IsValidInteger(eSrc)) isValid=0;
		if (!IsPositiveNumber(eSrc)) isValid=0;
	}
	if (!isValid) {
		eSrc.className='clsInvalid';
		websys_setfocus(eSrc.name);
		return  websys_cancel();
	} else {
		eSrc.className=""
	}
}

var NumberOfCycle=document.getElementById("CPWNumberOfCycle");
if (NumberOfCycle) NumberOfCycle.onchange=IntegerPositive_changehandler;