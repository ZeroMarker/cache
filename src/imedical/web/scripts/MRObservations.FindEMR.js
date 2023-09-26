// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function FindHandler () {
	var objstdate=document.getElementById('stdate');
	var objsttime=document.getElementById('sttime');
	var objenddate=document.getElementById('enddate');
	var objendtime=document.getElementById('endtime');
	if ((objstdate.value=="")&&(objsttime.value!="")) {
		alert(t['START_DATE_REQUIRED']);
		return false;
	}
	if ((objstdate.value=="")&&(objendtime.value!="")) {
		alert(t['END_DATE_REQUIRED']);
		return false;
	}
return find1_click();
}

var objFind=document.getElementById('find1');
objFind.onclick=FindHandler;