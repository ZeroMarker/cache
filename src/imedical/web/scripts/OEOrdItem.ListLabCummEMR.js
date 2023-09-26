// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function getResult(id,EpisodeID,ChartID,ChartItemID,Type,OrderID,TestItem) {
	if (id.substring(2,id.length)!="") {
		//LOG 37476 RC 19/08/03 This link now links to a combined csp which incorporates both the LabResult and the
		//SSAuditList components. The old link was left here in case of an emergency.
		//var url="websys.default.csp?WEBSYS.TCOMPONENT=OEOrdItem.LabResult&PatientBanner=1&EpisodeID="+EpisodeID+"&ResultID="+id.substring(2,id.length)+"&PatientID="+PatientID+"&ChartID="+ChartID+"&ItemID="+ItemID+"&Type="+Type+"&OrderID="+OrderID;
		var url="oelabres.ssauditlist.csp?&PatientBanner=1&EpisodeID="+EpisodeID+"&ResultID="+id.substring(2,id.length)+"&PatientID="+PatientID+"&ChartID="+ChartID+"&ItemID="+ChartItemID+"&Type="+Type+"&OrderID="+OrderID+"&TestItem="+TestItem;
		websys_createWindow(url, 'LabResult', 'top=30,left=30,width=500,height=600,scrollbars=yes,resizable=yes');
	}
}

function CumulativeScrollingResult(PatientID,EpisodeID,EpisodesAll,ChartID,Context,OrderItemID,Start,Columns,CumulativeItemIDs,IncludeRPrefix,RefRangePosition,CanRead,mradm,ChartItemID,ColumnWidth,CumOrderIDs,OrderID,ResultJustification) {
		var url="epr.cumulative.csp?PatientID="+PatientID+"&PatientBanner=1&EpisodeID="+EpisodeID+"&EpisodesAll="+EpisodesAll+"&ChartID="+ChartID+"&Context="+Context+"&mradm="+mradm+"&OrderItemID="+OrderItemID+"&Start="+Start+"&Columns="+Columns+"&CumulativeItemIDs="+CumulativeItemIDs+"&IncludeRPrefix="+IncludeRPrefix+"&RefRangePosition="+RefRangePosition+"&CanRead="+CanRead+"&ChartItemID="+ChartItemID+"&ColumnWidth="+ColumnWidth+"&CumOrderIDs="+CumOrderIDs+"&OrderID="+OrderID+"&ResultJustification="+ResultJustification;
		// are we:
		//  closing the first page,
		//  opening a new page, or
		//  just refreshing ourselves?
		// Log 37905 - AI - 02-09-2003 : Check for ItemID (if Null, we are coming from Cum. if not Null, we are coming from Tab and want to display when Start=1)
		// alert(window.opener + '\n'+OrderItemID+'\n'+Start+'\n'+url);
		if ((OrderItemID=="")&&(Start<1)&&(window.opener)) {
			window.opener=null;
   			window.close();
		} else if ((window.opener)&&(Start==0)) {
			window.opener=null;
 			window.close();
		} else if (window.opener) {
			window.location = url;
		} else {
			websys_createWindow(url, 'CumulativeResults', 'scrollbars=yes,toolbar=no,width=screen.width,height=screen.height,top=0,left=0,resizable=yes');
		} 
}
