// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function FindClickHandler(e) {
	var Summary=""; var ClosedProblems=""; var AcrossEpisodes="";
	var eSrc=websys_getSrcElement(e);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var SummaryObj=document.getElementById("SummaryView");
	if (SummaryObj&&SummaryObj.checked) Summary="on";
	var CPObj=document.getElementById("ClosedProblems")
	if (CPObj&&CPObj.checked) ClosedProblems="on";
	var AEObj=document.getElementById("AcrossEpisodes")
	if (AEObj&&AEObj.checked) AcrossEpisodes="on";
	var url=eSrc.href;
	if (url&&SummaryObj&&CPObj&&AEObj) eSrc.href=url+"&SummaryView="+Summary+"&ClosedProblems="+ClosedProblems+"&AcrossEpisodes="+AcrossEpisodes;
}

function BodyLoadHandler() {
	var findObj=document.getElementById("Find");
	if (findObj) findObj.onclick=FindClickHandler;
}
function DeleteClickHandler(){
}
document.body.onload=BodyLoadHandler;