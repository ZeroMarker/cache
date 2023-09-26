//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var selectedcontainer=null;
var dragEnabled=0;
var orig_x="";
var orig_y="";
var winP=window.parent;
var cnt=0
var mymodalwin;
var winHIDDEN = window.open('','TRAK_hidden');
var displayOnly=""
var isEmLoc=""
/*
	Please see comments in epr.floorplan.csp as to how the floorplan procedure works.
*/

function TrakIt_onmousedown(evt) {
	if ((displayOnly.value=="Y")&&(isEmLoc.value=="1")) return; //Log 63302
	websys_cancel();
	//TN:BROWSERS COMPATIBILITY:
	//if (window.event.button!=1) return;
	if (websys_getButton(evt)!="L") return;
	//get selected room
	eSrc = getSelectedRoom(websys_getSrcElement(evt));
	
	// quit if not selectable (set in CTIconAssociation.BookingRoomShow)
	if (eSrc.getAttribute('selectEnabled')==0) {
		if (eSrc.getAttribute('showemeralert')==1) alert(t['SelectEmergency']);
		return;
	}
	//quit if selected room does not contain a patient.
	if (eSrc.getAttribute('selected')==null) return;
	//clear and quit if element is already selected.
	if (eSrc.getAttribute('selected')==1) {clearSelectedPatient(eSrc);return;}
	//clear any objects before resetting the selectedcontainer.
	if (selectedcontainer) clearSelectedPatient(selectedcontainer);
	
	var p=websys_getParentElement(eSrc);  //ypz 080626
	if (p.className.indexOf("clsRowPre")>0) return;  //ypz 080626

	eSrc.setAttribute('selected',1);
	selectedcontainer=eSrc;
	var arrIDs=eSrc.id.split("^");

	try {
		winP.SetEpisodeDetails(arrIDs[1],arrIDs[0],arrIDs[2],arrIDs[3],"","","","","","","","","","","","","","","","","",arrIDs[21]);
		if (winf.frames["eprmenu"]) {
			winf.frames["eprmenu"].MENU_TRELOADPAGE=window.TRELOADPAGE;
			winf.frames["eprmenu"].MENU_TRELOADID=window.TRELOADID;
		}
	} catch(err) {}
	//Set the selectedcontainers parent <div> element to the appropriate selected class.
	//ypz rem 080626//var p=websys_getParentElement(selectedcontainer);
	if (p.className=="bedNorm") {
	p.className = "bedNormSel";
	/*//if (p.className=="bedNorm") {
	if (p.className.split(" ")[0]=="bedNorm") {
		//p.className = "bedNormSel "+p.className.split(" ")[1];
		newClassName="bedNormSel";
		if (p.className.split(" ")[1]!="undefined") newClassName=newClassName+" "+p.className.split(" ")[1]+"Sel";
		p.className=newClassName;*/

		/* to make cubicles draggable, enable this code and add moveEnabled=1 to the TABLE tag in epr.floorplan.csp
		dragEnabled=1;
		p.style.zIndex=websys_putontop();
		orig_y=p.style.top;
		orig_x=p.style.left;
		p.x=event.offsetX;
		p.y=event.offsetY;
		*/
	}
	if (p.className=="waitingPat") {
		p.className = "waitingPatSel";
		/*if (selectedcontainer) {
			selectedcontainer.prevClass=selectedcontainer.className;
			selectedcontainer.prevColor=selectedcontainer.style.backgroundColor;
			selectedcontainer.className="waitingPatSel";
			selectedcontainer.style.backgroundColor="";
			selectedcontainer.style.border="";
		}*/
		dragEnabled=1;
		p.style.zIndex=websys_putontop();
		orig_y=p.style.top;
		orig_x=p.style.left;
		//TN:BROWSERS COMPATIBILITY
		//p.x=event.offsetX;
		//p.y=event.offsetY;
		var evtOffsets = websys_getOffsets(evt);
		p.setAttribute("x",evtOffsets.offsetX);
		p.setAttribute("y",evtOffsets.offsetY);
	}
}

function TrakIt_onmousemove(evt) {
	if ((displayOnly.value=="Y")&&(isEmLoc.value=="1")) return false; //Log 63302
	if (!selectedcontainer) return false;
	if (selectedcontainer.getAttribute("moveEnabled")==1&&dragEnabled>0) {
		//TN:BROWSERS COMPATIBILITY
		//if (window.event.button!=1) {SnapBack(selectedcontainer);return false}
		//var newPosY=event.clientY+document.body.scrollTop;
		//var newPosX=event.clientX+document.body.scrollLeft;
		
		//do we need to check button click with mousemove???
		if (websys_getButton(evt)!="L") {SnapBack(selectedcontainer,evt);return false;}
		if ((!evt)&&(window.event)) evt=window.event;
		var newPosY=evt.clientY+document.body.scrollTop;
		var newPosX=evt.clientX+document.body.scrollLeft;
		var intLessTop=0;var intLessLeft=0;
		var elDrag=websys_getParentElement(selectedcontainer).offsetParent;
		while (elDrag.offsetParent!=null) {
			intLessTop+=elDrag.offsetTop;
			intLessLeft+=elDrag.offsetLeft;
			elDrag=elDrag.offsetParent;
		}
		//selectedcontainer.parentElement.style.pixelTop=eval(newPosY-intLessTop-selectedcontainer.parentElement.y);  //selectedcontainer.y)
		//selectedcontainer.parentElement.style.pixelLeft=eval(newPosX-intLessLeft-selectedcontainer.parentElement.x);  //selectedcontainer.y)
		websys_getParentElement(selectedcontainer).style.top=eval(newPosY-intLessTop-websys_getParentElement(selectedcontainer).getAttribute("y"))+"px";
		websys_getParentElement(selectedcontainer).style.left=eval(newPosX-intLessLeft-websys_getParentElement(selectedcontainer).getAttribute("x"))+"px";
	}
	return false;
}

//NB: TN: in N6 on mouseover with a dragged item points to the dragged item instead of the intended object
function TrakIt_onmouseup(evt) {
	if ((displayOnly.value=="Y")&&(isEmLoc.value=="1")) return; //Log 63302
	if (!selectedcontainer) return;
	//TN:BROWSERS COMPATIBILITY
	//if (window.event.button!=1) return;
	if (websys_getButton(evt)!="L") return;
	var eSrc = getSelectedRoom(websys_getSrcElement(evt))
	if (eSrc.id.substring(0,1)=="x") {
		alert(t['BedInactive']);
		return;
	}
	if (selectedcontainer.getAttribute("moveEnabled")) {SnapBack(selectedcontainer,evt);return;}
	if ((eSrc.className=="room")||(eSrc.className.split(" ")[0]=="bedNorm")||(eSrc.className=="clsRoomLink")) OpenPACBedAdmWindow(eSrc);
}

function clearSelectedPatient(eSrc) {
	var elPar=websys_getParentElement(eSrc);
	if (!elPar) return;
	var clsName=elPar.className.substring(0,7)
	if (clsName=="waiting") elPar.className = "waitingPat";
	if (clsName=="bedNorm") elPar.className = "bedNorm";

	/*if (clsName=="waiting") {
		elPar.className = "waitingPat";
		eSrc.className=eSrc.prevClass;
		eSrc.style.backgroundColor=eSrc.prevColor;
	}
	//if (clsName=="bedNorm") elPar.className = "bedNorm";
	if (clsName=="bedNorm") {
		elPar.className = "bedNorm "+elPar.className.split(" ")[1];
		elPar.className = elPar.className.split("Sel")[0];
	}*/
	eSrc.setAttribute('selected',0);
	winP.MainClearEpisodeDetails();
	selectedcontainer=null;
}
function getSelectedRoom(eSrc) {
	if (eSrc.className=="room") return eSrc;
	// ab 10.03.03 - drag patients into linked locations rooms
	var objRoom=websys_getParentElement(eSrc);
	if ((objRoom)&&(objRoom.className=="clsRoomLink")) {
		return objRoom;
	}
	objRoom=eSrc;

	while (objRoom.getAttribute('selectEnabled')!=1) {
		if (websys_getParentElement(objRoom)==null) break;
		//check epr.floorplan div instead? if (websys_getParentElement(objRoom)==document.getElementById('epr.floorplan')) break;
		if (websys_getParentElement(objRoom)==document.body) break;
		objRoom=websys_getParentElement(objRoom);
	}
	if (objRoom.getAttribute('selectEnabled')) {
		var arrDivsInBed = objRoom.getElementsByTagName("TABLE");
		if (arrDivsInBed.length>0) objRoom=arrDivsInBed[0];
	}
	return objRoom;
}

function SnapBack(selectedcontainer,evt) {
	if (!selectedcontainer) return;
	if (!websys_getParentElement(selectedcontainer)) return;
	websys_getParentElement(selectedcontainer).style.left = orig_x;
	if (orig_y!="") websys_getParentElement(selectedcontainer).style.top = orig_y;
	orig_x="";orig_y="";
	dragEnabled=0;
	//TN:need to convert browser compatible for elementFromPoint
	var bed=document.elementFromPoint(window.event.clientX,window.event.clientY);
	if (bed) {
		// ab 6.02.04 - 42253 - also show inactive message when dragging from waiting area
		if (bed.id.substring(0,1)=="x") { alert(t['BedInactive']); return; }
		// ab 7.03.03 - cant move patients into the same room
		if ((websys_getParentElement(websys_getParentElement(selectedcontainer)))&&(websys_getParentElement(websys_getParentElement(selectedcontainer)).id==getSelectedRoom(bed).id)) return;
		// ab 28.02.03 - also show movement window on multi patient rooms and holding/waiting areas
		if ((getSelectedRoom(bed).className.split(" ")[0]=="bedNorm")||(getSelectedRoom(bed).id.substr(0,2)=="mr")||(getSelectedRoom(bed).id.substr(0,2)=="rm")) OpenPACBedAdmWindow(bed);
	}
}

function OpenPACBedAdmWindow(eSrc) {
	//Log 28454: Emergency Patients in Booked Area can not be moved by drag and drop, or click-click, from floorplan.
	//alert(selectedcontainer.showemeralert)
	//alert(eSrc.tagName+"^"+eSrc.className+"^"+eSrc.id)
	
	if ((websys_getParentElement(eSrc))&&(websys_getParentElement(eSrc).className=="clsRoomLink")) eSrc=websys_getParentElement(eSrc);
	if (selectedcontainer.getAttribute("moveEnabled")==0) {
		if (selectedcontainer.getAttribute("showemeralert")==1) {alert(t['SelectEmergency']);return;}
		alert(t['MoveDisabled']);return;
	}
	var arrIDs=selectedcontainer.id.split("^");
	if ((eSrc.className=="room")||(eSrc.className=="clsRoomLink")) {
		var RoomID=eSrc.id.substring(2,eSrc.id.length)
		var LinkWardID=WardID;
		if ((RoomID!="")&&(eSrc.className=="clsRoomLink")) LinkWardID=RoomID.split("||")[0];
		
		var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PAAdmTransaction.Edit&PatientBanner=1&ID="+arrIDs[0]+"&PARREF="+arrIDs[0]+"&EpisodeID="+arrIDs[0]+"&PatientID="+arrIDs[1]+"&RoomID="+RoomID+"&PAADMType="+admtype+"&roomQuery=WA&WardID="+LinkWardID;
		myShowModal(lnk,"BEDADM","width=500,height=400,left=50,top=50,scrollbars=yes,resizable=yes,status=yes");
	}
	if (eSrc.className.split(" ")[0]=="bedNorm") {
		// ab 9.03.04 42771
		var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PAAdmTransaction.Edit&PatientBanner=1&ID="+arrIDs[0]+"&EpisodeID="+arrIDs[0]+"&PatientID="+arrIDs[1] + "&roomQuery=&PAADMType="+admtype+"&WardID="+eSrc.id.split("||")[0]+"&BedID="+eSrc.id;
		//var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PACBedAdm.Edit&EpisodeID="+arrIDs[0]+"&PARREF="+eSrc.id+"&PatientID="+arrIDs[1] + "&roomQuery=&PAADMType="+admtype;
		myShowModal(lnk,"BEDADM","width=400,height=400,left=50,top=50,scrollbars=yes,resizable=yes,status=yes");
	}
}

function SelectBed(eSrc) {
	var arrDiv = eSrc.getElementsByTagName("DIV");
	if (arrDiv.length > 1) {
		if (eSrc.className != "bedSel") {
			var arrIDs = arrDiv[1].id.split("^");
			eSrc.className = "bedSel";
			if (!websys_isIE) {
				eSrc.style.width = parseInt(el.style.width) - 5;
				eSrc.style.height = parseInt(el.style.height) - 5;
			}
		}
	}
}

function GotoShortcutMenu(evt) {
	if ((displayOnly.value=="Y")&&(isEmLoc.value=="1")) return;
	if (selectedcontainer==null) return;
	var keycode;
	try {keycode=websys_getKey(evt);} catch(evt) {keycode=websys_getKey();}
	var key=String.fromCharCode(keycode);
	if ((winP)&&(winP.frames['eprmenu'])&&(winP.document.isMenuLoaded)) {
		var menu = winP.frames['eprmenu'].arrAccessKey[key];
		if (menu) menu.click();
	}
}

function ViewBedStatus(bedid) {
	//websys_createWindow("pacbedstatuschange.list.csp?PARREF="+bedid,"BEDSTAT");
	if ((displayOnly.value=="Y")&&(isEmLoc.value=="1")) return; //Log 63302
	var url="pacbedstatuschange.list.csp?PARREF="+bedid;
	myShowModal(url,"BEDSTAT","width=500,height=400,scrollbars=yes,resizable=yes,status=yes");
}

function BodyOnloadHandler() {
	isEmLoc=document.getElementById("isEMLoc");
	displayOnly=document.getElementById("FPDisplayOnly");
	//alert(" displayOnly: " + displayOnly.value + " isEmLoc: " + isEmLoc.value);
	var winf = null;
	if (window.parent != window.self) winf = window.parent;
	var obj=document.getElementById("TotalCount");
	if (obj) obj.innerText=TotalCount
	//reset last selected patient
	if ((winf)&&(winf.frames['eprmenu'])) {
		//moved to epr.floorplan.csp in <HEAD> tags so don't have to wait till everything loads first
		//winf.MainClearEpisodeDetails();
		winf.document.isMainLoaded = 1;
	}
	if ((winHIDDEN)&&(winHIDDEN.floorplanmodalwin)) {
		mymodalwin = winHIDDEN.floorplanmodalwin;
		window.onfocus = checkModal;		
	}
	//
	//DHC Su
	var arrDiv = document.getElementsByTagName("DIV");
	for (var i=0; i<arrDiv.length; i++) {
		if (arrDiv[i].className == "room") {
			var WaitingRoom=arrDiv[i];
			WaitingRoom.style.background="LightBlue";
			var arrWaitPat = WaitingRoom.getElementsByTagName("TABLE");
			var row=arrWaitPat.length;
			for (var j=0;j<row;j++) {
				var WaitDIV=websys_getParentElement(arrWaitPat[j]);
				if (WaitDIV.className=='waitingPat')	{
						WaitDIV.style.top=j*30+15;
						WaitDIV.style.height='30px';
				}
			}
		}
	}
}

function myShowModal(url,name,params) {
    mymodalwin=window.open(url,name,params);
    	if (winHIDDEN) winHIDDEN.floorplanmodalwin = mymodalwin;
    window.onfocus = checkModal;
}

function checkModal() {
	//if ((mymodalwin)&&(!mymodalwin.closed)) {
	try {
		if ((mymodalwin)&&(!mymodalwin.closed)&&(mymodalwin.websys_firstfocus)) {
			mymodalwin.focus();
			mymodalwin.websys_firstfocus();
		}
	} catch(e) {
	}
}

document.body.onload=BodyOnloadHandler;