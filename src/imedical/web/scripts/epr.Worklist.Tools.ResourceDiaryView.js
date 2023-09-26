// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var topFrame;
function DocumentLoadHandler()
{
	topFrame=parent.frames["TRAK_main"].frames["work_top"];
}

function GetSelectedOrders(DiaryType)
{
	var nRows=0;
	var obj=parent.frames["TRAK_main"].frames["work_bottom"];
	if ((DiaryType=="R")||(DiaryType=="")) var table = obj.document.getElementById("tOEOrdItem_RadiologyWorkBench");
	if (DiaryType=="OT") {
		 var table = obj.frames[1].document.getElementById("tRBOperatingRoom_List");
	}
	if(table) {nRows = table.rows.length;}

	var idARR=new Array();
	var count=0;
	if (nRows>0)
		for(var i=1; i<nRows; i++)
		{
			if ((DiaryType=="R")||(DiaryType=="")) var selectObj=obj.document.getElementById("selectz"+i);
			if (DiaryType=="OT") var selectObj=obj.frames[1].document.getElementById("selectz"+i);
			if (selectObj.checked==true)
			{
				if ((DiaryType=="R")||(DiaryType=="")) {var idObj=obj.document.getElementById("OEOrdItemIDz"+i);}
				if (DiaryType=="OT") {var idObj=obj.frames[1].document.getElementById("OperRoomIDz"+i);}
				if(idObj)
				{
					idARR[count++]=idObj.value;
				}
			}
		}
		return idARR;
}

document.body.onload = DocumentLoadHandler;


