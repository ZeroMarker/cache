// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var Header = top.frames['RBDiaryHeader'];

function DocumentLoadHandler() {
	var pageCnt = 0;
	var arrSMALL=document.getElementsByTagName("SMALL");
	if (arrSMALL.length>0) pageCnt=arrSMALL[0].innerHTML;
	if (parseInt(pageCnt)>1) Header.incr=1;
	assignChkHandler();
	if (Header.histCnt && Header.incr==1) Header.histCnt=parseInt(Header.histCnt)+1;
}

function assignChkHandler() {
	var SessType=""
	var Load=""
	var Price=""
	var key=document.getElementById("key").value;
	
	var tbl=document.getElementById("tRBAppointment_DiaryView_List");
	for (var i=1;i<tbl.rows.length+1;i++) {
		var obj=document.getElementById("Selectz"+i)
		if (obj) obj.onclick = checkhandler;
		var objSessType=document.getElementById("SessionTypez"+i)
		if (objSessType) SessType=objSessType.value;
		if (SessType=="") SessType=t['Blank'];
		var objLoad=document.getElementById("Loadz"+i);
		if (objLoad) Load=objLoad.value;
		var objPrice=document.getElementById("Pricez"+i);
		if (objPrice) Price=objPrice.value;
		var obj=document.getElementById("StartTimez"+i);
		if (obj) obj.title=t['SessType']+": "+SessType+"; "+t['Load']+": "+Load+"; "+t['Price']+": "+Price;
	}
	return;
}

function checkhandler(e) {
	var obj=websys_getSrcElement(e);
	var rowid=obj.id
	var rowcnt=$p(rowid,"z",1)
	
	var schedID = document.getElementById("IDz"+rowcnt).value
	var servID = document.getElementById("ServIdz"+rowcnt).value
	var duration = document.getElementById("Durationz"+rowcnt).value
	var price = document.getElementById("Pricez"+rowcnt).value
	
	var obj = document.getElementById(rowid)

	var ApptStr=tkMakeServerCall("web.RBApptSchedule","GetServiceRowStr",obj.checked,schedID,servID,duration+"^"+price);
	top.window.opener.top.frames["TRAK_main"].frames["RBServList"].Refresh("Update","","",ApptStr)
}

function $p(s1,sep,n) {
    //Split the array with the passed delimeter
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
}

document.body.onload = DocumentLoadHandler;