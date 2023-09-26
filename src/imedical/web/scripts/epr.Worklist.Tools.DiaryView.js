// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var topFrame; var bottomFrame

function FrameDocumentLoadHandler() {
	if(parent.name=='TRAK_main') {
		topFrame=parent.frames['work_top'];
		bottomFrame=parent.frames['work_bottom'];
	} else {
		topFrame=parent.frames['TRAK_main'].frames['work_top'];
		bottomFrame=parent.frames['TRAK_main'].frames['work_bottom'];
	}

	if (bottomFrame) {
		if (bottomFrame.document.getElementById("OSTATList")) FrameStatusSelectHandler(bottomFrame);
		var obj=bottomFrame.document.getElementById("find1");
		if (obj) obj.onclick=FrameFindClickHandler
		//if (tsc['find1']) websys_sckeys[tsc['find1']]=FrameFindClickHandler;
	}
}


function FrameFindClickHandler() {
	//alert("test");
	var RESCDesc,RecLoc,Status,EpType,PatReg,RadNo,Radiologist,Lock,DateFrom,DateTo,AccessionNo,RoomDesc,ATTENDDesc,OrdItemDesc,DiaryType="";
	var obj=bottomFrame.document.getElementById("WorkID");
		if (obj)
		var WorkID=obj.value;
	var obj=bottomFrame.document.getElementById("RESCDesc");
	if (obj)
		RESCDesc=obj.value;
	var obj=bottomFrame.document.getElementById("CTLOCDesc");
	if (obj)
		RecLoc=obj.value;
	var obj=bottomFrame.document.getElementById("OSTATDesc");
	if (obj) {
		Status=obj.value;
	} else {
		Status=FrameStatusListBuilder(bottomFrame);
	}
	var obj=bottomFrame.document.getElementById("EpisodeType");
	if (obj)
		EpType=obj.value;
	var obj=bottomFrame.document.getElementById("RegistrationNo");
	if (obj)
		PatReg=obj.value;
	var obj=bottomFrame.document.getElementById("TestEpisodeNo");
	if (obj)
		RadNo=obj.value;
	var obj=bottomFrame.document.getElementById("ConsCTPCPDesc");
	if (obj)
		Radiologist=obj.value;
	var obj=bottomFrame.document.getElementById("RetainFieldValue");
	if (obj) {
		Lock=obj.value;
		// RC 14/03/03 the lock doesn't save when you unclick it and press find, so just to make sure I had to put this in.
		if (obj.checked==false) Lock=""; obj.value=Lock;
	}
	var obj=bottomFrame.document.getElementById("DateFrom");
	if (obj)
		DateFrom=obj.value;
	var obj=bottomFrame.document.getElementById("DateTo");
	if (obj)
		DateTo=obj.value;
	var obj=bottomFrame.document.getElementById("OEORIAccessionNumber");
	if (obj)
		AccessionNo=obj.value;
	var obj=bottomFrame.document.getElementById("APPTRoomDesc");
	if (obj)
		RoomDesc=obj.value;
	var obj=bottomFrame.document.getElementById("ATTENDDesc");
	if (obj)
		ATTENDDesc=obj.value;
	var obj=bottomFrame.document.getElementById("OrdItemDesc");
	if (obj)
		OrdItemDesc=obj.value;
	var obj=bottomFrame.document.getElementById("DiaryType");
		if (obj)
		DiaryType=obj.value;

	bottomFrame.location.href="epr.worklist.frame.csp?WorkID="+WorkID+"&frame=B&WkLst=Rad&RESCDesc="+RESCDesc+"&CTLOCDesc="+RecLoc+"&OSTATDesc="+Status+"&EpisodeType="+EpType+"&RegistrationNo="+PatReg+"&TestEpisodeNo="+RadNo+"&ConsCTPCPDesc="+Radiologist+"&RetainFieldValue="+Lock+"&DateFrom="+DateFrom+"&DateTo="+DateTo+"&OEORIAccessionNumber="+AccessionNo+"&APPTRoomDesc="+RoomDesc+"&ATTENDDesc="+ATTENDDesc+"&OrdItemDesc="+OrdItemDesc+"&DiaryType="+DiaryType;
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

function GetSelectedOrders(DiaryType)
{
	var nRows=0;
	var obj=parent.frames["TRAK_main"].frames["work_bottom"];
	if ((DiaryType=="R")||(DiaryType=="O")||(DiaryType=="")) {
		//var table = obj.document.getElementById("tOEOrdItem_RadiologyWorkBench");
		var table = obj.tbl;
	}
	if (DiaryType=="OT") {
		 var table = obj.frames[1].document.getElementById("tRBOperatingRoom_List");
	}
	//var table = obj.tbl;
	if (table) nRows = table.rows.length;

	var idARR=new Array();
	var count=0;
	if (nRows>0) {
		for(var i=1; i<nRows; i++)
		{
			if ((DiaryType=="R")||(DiaryType=="")) var selectObj=obj.document.getElementById("selectz"+i);
			if (DiaryType=="OT") var selectObj=obj.frames[1].document.getElementById("selectz"+i);
			if ((selectObj)&&(selectObj.checked==true))
			{
				if ((DiaryType=="R")||(DiaryType=="")) {var idObj=obj.document.getElementById("OEOrdItemIDz"+i);}
				if (DiaryType=="OT") {var idObj=obj.frames[1].document.getElementById("OperRoomIDz"+i);}
				if(idObj)
				{
					idARR[count++]=idObj.value;
				}
			}
			if (DiaryType=="O") {
				if (table.rows[i].className=="clsRowSelected") {
					var idObj=obj.document.getElementById("PatientIDz"+i);
					var idObj1=obj.document.getElementById("EpisodeIDz"+i);
					var idObj2=obj.document.getElementById("attendIDz"+i);
					if ((idObj)&&(idObj1)&&(idObj2)) {
						idARR[count++]=idObj.value+"&"+idObj1.value+"&"+idObj2.value;
					}
				}
			}
		}
	}
	return idARR;
}

function GetOTDetails(OTID)
{
	/*var obj=parent.frames["TRAK_main"].frames["work_bottom"];
	if (DiaryType=="OT") {
		 var table = obj.frames[1].document.getElementById("tRBOperatingRoom_List");
		 if(table) {nRows = table.rows.length;}
	}
	return ret;*/
}

function GetOTStatus(OTID)
{
	var nRows=0;
	var ret="";
	var obj=parent.frames["TRAK_main"].frames["work_bottom"];
	var table = obj.frames[1].document.getElementById("tRBOperatingRoom_List");

	if(table) {nRows = table.rows.length;}
	if (nRows>0)
	{
		for(var i=1; i<nRows; i++)
		{
			var selectObj=obj.frames[1].document.getElementById("selectz"+i);
			//alert(selectObj)
			var OperRoomID=obj.frames[1].document.getElementById("OperRoomIDz"+i);
			//alert(OperRoomID.value)
			if ((selectObj)&&(selectObj.checked==true)&&(OperRoomID.value==OTID))
			{
				ret=obj.frames[1].document.getElementById("statz"+i).value;
				return ret;
			}
		}
	}
	return "";
}

function mPiece(s1,sep,n) {
    //Split the array with the passed delimeter
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
}