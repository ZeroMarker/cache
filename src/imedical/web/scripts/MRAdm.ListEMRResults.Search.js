// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function BodyLoadHandler(){
	var objFind=document.getElementById('btnSearch');
	if (objFind) objFind.onclick=FindClickHandler;
}

function FindClickHandler(){
	var objC=document.getElementById('catgID');
	if (objC) {catgID=objC.value} else {catgID=""};
	var objDF=document.getElementById('dfrom');
	if (objDF) {dfrom=objDF.value} else {dfrom=""};
	var objDT=document.getElementById('dto');
	if (objDT) {dto=objDT.value} else {dto=""};
	var objO=document.getElementById('orderitem');
	if (objO) {orderitem=objO.value} else {orderitem=""};
	var objS=document.getElementById('resultstatus');
	if (objS) {resultstatus=objS.value} else {resultstatus=""};
	var objP=document.getElementById('priority');
	if (objP) {priority=objP.value} else {priority=""};
	var objW=document.getElementById('Ward');
	if (objW) {Ward=objW.value} else {Ward=""};
	var objL=document.getElementById('EpisodeLocation');
	if (objL) {EpisodeLocation=objL.value} else {EpisodeLocation=""};
	var obj=document.getElementById('SearchCriteria');
	obj.value=catgID+"^"+dfrom+"^"+dto+"^"+orderitem+"^"+resultstatus+"^"+priority+"^"+Ward+"^"+EpisodeLocation
	return btnSearch_click();
}

document.body.onload=BodyLoadHandler;