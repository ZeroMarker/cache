// Copyright (c) 2005 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

/****************************************/
/******* highlight toolbar item *********/
/****************************************/
var tlbar = "";
var tlbarbtn = "";
var tlbarprev = "";
var arrAccessKey = new Array();
function ReleaseFieldFocus(win) {
	if (win.frames.length) {
		for (var i=0; i<win.frames.length; i++) {
			ReleaseFieldFocus(win.frames[i]);
		}
	} else {
		if (win.document.selection) win.document.selection.empty(); //removes the text cursor that is in an editable field
	}
}
function SelectToolbar(idbar) {
	var menuBar = document.getElementById(idbar);
	var btn = idbar.split("i");
	var id = btn[0] + btn[1];
	var menu = document.getElementById(id);
	var el;
	if ((tlbar != "") && (tlbar != idbar)) {
		el=document.getElementById(tlbar);
		if (el) el.style.visibility = "hidden";
		el=document.getElementById(tlbarbtn);
		if (el) el.style.border = "";
		tlbarprev = tlbar;
	}
	if (menuBar) {
		if (menuBar.style.visibility == "hidden") {
			menuBar.style.visibility = "visible";
			menuBar.style.display = "";
			tlbar = idbar;
			tlbarbtn = id;
			menu.style.borderTop = "2px solid buttonhighlight";
			menu.style.borderRight = "2px solid buttonshadow";
			menu.style.borderBottom = "2px solid buttonshadow";
			menu.style.borderLeft = "2px solid buttonhighlight";
		}
	}
	parent.document.body.rows="30,*,0";
	ReleaseFieldFocus(top.frames[1]);
}
function SelectWorkflow(wflid) {
	//highlight the menu linked to a workflow
	if (wflid!="") {
		var mnulnk=document.getElementById("twkfl"+wflid);
		if (mnulnk) {
			var mnubtnid="tbi"+websys_getParentElement(mnulnk).id.split("tb")[1];
			SelectToolbar(mnubtnid);
		}
	}
}
function SetShortcutKeys() {
	//store array of links that has accesskey
	for (var i=0; i<document.links.length; i++) {
		var lnk=document.links[i];
		if ((lnk.accessKey) && (lnk.accessKey!="")) {
			arrAccessKey[lnk.accessKey.toLowerCase()]=lnk;
		}
	}
}


/****************************************/
/******* scrollbutton detection *********/
/****************************************/
function AdjustScrollNext() {
	if (document.body.scrollLeft + wdtscreen < tblmenu.scrollWidth) {
		divnext.style.posLeft = document.body.scrollLeft + wdtscreen - divnext.offsetWidth;
		divnext.style.visibility = 'visible';
	} else {
		divnext.style.visibility = 'hidden';
		divnext.style.posLeft = 0;
	}
}
function AdjustScrollPrev() {
	if (document.body.scrollLeft > 0) {
		divprev.style.posLeft = document.body.scrollLeft;
		divprev.style.visibility = 'visible';
	} else {
		divprev.style.visibility = 'hidden';
		divprev.style.posLeft = 0;
	}
}
function AdjustScrollButtons() {
	AdjustScrollNext();
	AdjustScrollPrev();
}
function ScrollItemNext(evt) {
	var el=null;
	var pos=document.body.scrollLeft+divprev.offsetWidth;
	var itms=tblmenu.tBodies[0].rows[0].cells;
	for (var i=0; i<itms.length; i++) {
		el=itms[i];
		if (itms[i].offsetLeft > pos) break;
	}
	if (el) pos = el.offsetLeft-divprev.offsetWidth;
	window.scrollTo(pos,0);
	AdjustScrollButtons();
}
function ScrollItemPrev(evt) {
	var el=null;
	var pos=document.body.scrollLeft-divprev.offsetWidth;
	var itms=tblmenu.tBodies[0].rows[0].cells;
	for (var i=0; i<itms.length; i++) {
		if (itms[i].offsetLeft > pos) break;
		el=itms[i];
	}
	if (el) pos = el.offsetLeft-divprev.offsetWidth;
	window.scrollTo(pos,0);
	AdjustScrollButtons();
}
function ScrollPageNext(evt) {
	window.scrollBy(wdtscreen,0);
	AdjustScrollButtons();
}
function ScrollPagePrev(evt) {
	window.scrollBy(-wdtscreen,0);
	AdjustScrollButtons();
}
function BodyResizeHandler() {
	wdtscreen=document.body.clientWidth;
	AdjustScrollButtons();
}
/****************************************/
/******* page load setup ****************/
/****************************************/
function BodyLoadHandler() {
	var winf = null;
	if (window.parent != window.self) winf = window.parent;
	if (winf) winf.isMenuLoaded = 1;
	SetShortcutKeys();
	if ((typeof swf!='undefined')&&(swf!='')) SelectWorkflow(swf); //'swf' defined in epr.menu.csp
	if (usemenuscroll) AdjustScrollButtons(); //'usemenuscroll' defined in epr.menu.csp
}
var wdtscreen=document.body.clientWidth;
var tblmenu=document.getElementById('tablemenu');
var divnext=document.getElementById('menunext');
var divprev=document.getElementById('menuprev');
var imgnext=document.getElementById('imgnextp');
var imgnexti=document.getElementById('imgnexti');
var imgprev=document.getElementById('imgprevp');
var imgprevi=document.getElementById('imgprevi');
if (usemenuscroll) {
	document.body.onscroll=AdjustScrollButtons;
	document.body.onresize=BodyResizeHandler;
	imgnext.onclick=ScrollPageNext;
	imgnexti.onclick=ScrollItemNext;
	imgprev.onclick=ScrollPagePrev;
	imgprevi.onclick=ScrollItemPrev;
}
document.body.onload=BodyLoadHandler;
//window.onload=BodyLoadHandler;