// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function BodyLoadHandler(){
	var objFind=document.getElementById('find1');
	if (objFind) objFind.onclick=FindClickHandler;
	if (tsc['find1']) websys_sckeys[tsc['find1']]=FindClickHandler;
}

function SetSelectedPeriodStatus() {
	var arrItems = new Array();
	var selStatus= "";
	var lst = document.getElementById("Status");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			if (lst.options[j].selected)
				selStatus = selStatus+ lst.options[j].value + "|"
		}
		selStatus = selStatus.substring(0,(selStatus.length-1));

		var objSelStat = document.getElementById("SelectedStatus");
		if (objSelStat ) objSelStat .value = selStatus;
	}
}

function FindClickHandler(){
	SetSelectedPeriodStatus();
	return find1_click();
}

function AcctPeriodLookUp(value) {
	var arrvalue = value.split("^");
	var obj=document.getElementById('AcctPeriod');
	if (obj) {
		obj.value=unescape(arrvalue[0]);
		obj.className='';
	}
}
document.body.onload=BodyLoadHandler;
