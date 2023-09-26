// Copyright (c) 2000 TRAK Systems Pty. ALL RIGHTS RESERVED.
var histCnt=0
var incr=0;

function DocumentLoadHandler() {
	var pgcnt=document.getElementById("pgcnt").value
	var more=document.getElementById("more").value

	var obj=document.getElementById("Update")
	if (obj) obj.onclick = UpdateClickHandler;
	
	var obj=document.getElementById("Next")
	if (obj) {
		obj.onclick = NextClickHandler;
		if (more=="N") obj.style.visibility = "hidden"
	}
		
	var obj=document.getElementById("Previous")
	if (obj) {
		obj.onclick = PrevClickHandler;
		if ((pgcnt==1)||(pgcnt=="")) obj.style.visibility = "hidden"
	}
	histCnt=1
}

function NextClickHandler() {
	var pgcnt=document.getElementById("pgcnt").value
	var pNext=document.getElementById("pNext").value;
	pNext=pNext.replace(/\$/g,"&");
	pgcnt=parseInt(pgcnt)+1
	top.window.location="rbappointment.diaryview.csp?pPrev=0&pgcnt="+pgcnt+pNext;
	return false;
}

function PrevClickHandler() {
	//var pPrev=document.getElementById("pPrev").value;
	//pPrev=pPrev.replace(/\$/g,"&");
	//top.window.location="rbappointment.diaryview.csp?pPrev=1"+pPrev;
	//return false;
	//history.back()
	
	//histCnt remembers how many times each frame has moved forward/back a page. We then need to skip that in the history.
	histCnt=0-histCnt
	history.go(histCnt)
}

function UpdateClickHandler() {
	//var ret=tkMakeServerCall("web.RBApptSchedule","KillSessVars")
	return true;
}

document.body.onload = DocumentLoadHandler;