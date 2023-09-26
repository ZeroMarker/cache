// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var topFrame; var bottomFrame;

function FrameDocumentLoadHandler() {
	var Cframe="";
	if(parent.name=='TRAK_main') {
		topFrame=parent.frames['work_top'];
		bottomFrame=parent.frames['work_bottom'];
		if (typeof parent.RADFRAMECLICK!="undefined") Cframe=parent.RADFRAMECLICK;
	} else {
		topFrame=parent.frames['TRAK_main'].frames['work_top'];
		bottomFrame=parent.frames['TRAK_main'].frames['work_bottom'];
		if (typeof parent.frames['TRAK_main'].RADFRAMECLICK!="undefined") Cframe=parent.frames['TRAK_main'].RADFRAMECLICK;
	}

	if(topFrame) {
		if (Cframe!="") {
			if (Cframe=="work_top") FrameStatusSelectHandler(topFrame);
		} else {
			FrameStatusSelectHandler(topFrame);
		}
		var obj=topFrame.document.getElementById("find1");
		if (obj) obj.onclick=FrameFindClickHandler;
	}
	if(bottomFrame) {
		if (Cframe!="") {
			if (Cframe=="work_bottom") FrameStatusSelectHandler(bottomFrame);
		} else {
			FrameStatusSelectHandler(bottomFrame);
		}
		var obj=bottomFrame.document.getElementById("find1");
		if (obj) obj.onclick=FrameFindClickHandler;
	}
}

function FrameFindClickHandler(evt) {
	var ary=window.frames;
	for (var i=0;i<ary.length;i++) {if (ary[i].event) {var frameName=ary[i].name}}
	if (frameName=="work_top") {var frame=topFrame} else {var frame=bottomFrame}

	var RESCDesc,RecLoc,Status,EpType,PatReg,RadNo,Radiologist,Lock,DateFrom,DateTo,AccessionNo,RoomDesc,ATTENDDesc,OrdItemDesc,DiaryType="";
	var obj=frame.document.getElementById("WorkID");
		if (obj)
		var WorkID=obj.value;
	var obj=frame.document.getElementById("RESCDesc");
	if (obj)
		RESCDesc=obj.value;
	var obj=frame.document.getElementById("CTLOCDesc");
	if (obj)
		RecLoc=obj.value;
	var obj=frame.document.getElementById("OSTATDesc");
	if (obj) {
		Status=obj.value;
	} else {
		Status=FrameStatusListBuilder(frame);
	}
	var obj=frame.document.getElementById("EpisodeType");
	if (obj)
		EpType=obj.value;
	var obj=frame.document.getElementById("RegistrationNo");
	if (obj)
		PatReg=obj.value;
	var obj=frame.document.getElementById("TestEpisodeNo");
	if (obj)
		RadNo=obj.value;
	var obj=frame.document.getElementById("ConsCTPCPDesc");
	if (obj)
		Radiologist=obj.value;
	var obj=frame.document.getElementById("RetainFieldValue");
	if (obj) {
		Lock=obj.value;
		// RC 14/03/03 the lock doesn't save when you unclick it and press find, so just to make sure I had to put this in.
		if (obj.checked==false) Lock=""; obj.value=Lock;
	}
	var obj=frame.document.getElementById("DateFrom");
	if (obj)
		DateFrom=obj.value;
	var obj=frame.document.getElementById("DateTo");
	if (obj)
		DateTo=obj.value;
	var obj=frame.document.getElementById("OEORIAccessionNumber");
	if (obj)
		AccessionNo=obj.value;
	var obj=frame.document.getElementById("APPTRoomDesc");
	if (obj)
		RoomDesc=obj.value;
	var obj=frame.document.getElementById("ATTENDDesc");
	if (obj)
		ATTENDDesc=obj.value;
	var obj=frame.document.getElementById("OrdItemDesc");
	if (obj)
		OrdItemDesc=obj.value;
	var obj=frame.document.getElementById("DiaryType");
		if (obj)
		DiaryType=obj.value;

	if(parent.name=='TRAK_main') {
		parent.RADFRAMECLICK=frame.name;
	} else {
		parent.frames['TRAK_main'].RADFRAMECLICK=frame.name;
	}

	if (frame.name=="work_top") {
		frame.location.href="epr.worklist.frame.csp?WorkID="+WorkID+"&frame=T&WkLst=Rad&RESCDesc="+RESCDesc+"&CTLOCDesc="+RecLoc+"&hiddenOSTATDesc="+Status+"&OSTATDesc="+Status+"&EpisodeType="+EpType+"&RegistrationNo="+PatReg+"&TestEpisodeNo="+RadNo+"&ConsCTPCPDesc="+Radiologist+"&RetainFieldValue="+Lock+"&DateFrom="+DateFrom+"&DateTo="+DateTo+"&OEORIAccessionNumber="+AccessionNo+"&APPTRoomDesc="+RoomDesc+"&ATTENDDesc="+ATTENDDesc+"&OrdItemDesc="+OrdItemDesc+"&DiaryType="+DiaryType;
	} else if (frame.name=="work_bottom") {
		frame.location.href="epr.worklist.frame.csp?WorkID="+WorkID+"&frame=B&WkLst=Rad&RESCDesc="+RESCDesc+"&CTLOCDesc="+RecLoc+"&hiddenOSTATDesc="+Status+"&OSTATDesc="+Status+"&EpisodeType="+EpType+"&RegistrationNo="+PatReg+"&TestEpisodeNo="+RadNo+"&ConsCTPCPDesc="+Radiologist+"&RetainFieldValue="+Lock+"&DateFrom="+DateFrom+"&DateTo="+DateTo+"&OEORIAccessionNumber="+AccessionNo+"&APPTRoomDesc="+RoomDesc+"&ATTENDDesc="+ATTENDDesc+"&OrdItemDesc="+OrdItemDesc+"&DiaryType="+DiaryType;
	}
}

function FrameStatusListBuilder(frame) {
	var OSTATString="";
	var objOSTATList=frame.document.getElementById("OSTATList")

	if (objOSTATList) {
		for (var i=0; i<objOSTATList.length; i++) {
			if (objOSTATList.options[i].selected) {
				OSTATString=OSTATString+objOSTATList.options[i].value+"|";
			}
		}
	}
	frame.document.getElementById("hiddenOSTATDesc").value=OSTATString
	return OSTATString;
}

function FrameStatusSelectHandler(frame) {
	var hiddenOSTATDesc=frame.document.getElementById("hiddenOSTATDesc").value
	var objOSTATList=frame.document.getElementById("OSTATList");
	var stat="";

	if (objOSTATList) {
		for (var j=0;;j++) {
			stat=mPiece(hiddenOSTATDesc,"|",j)
			if (stat=="") break;
			for (var i=0; i<objOSTATList.length; i++) {
				if (stat==objOSTATList.options[i].value) {
					objOSTATList.options[i].selected=true; break;
				}
			}
		}
	}
}

function mPiece(s1,sep,n) {
    //Split the array with the passed delimeter
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
}