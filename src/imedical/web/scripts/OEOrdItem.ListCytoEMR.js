// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.	
// ab 20.04.06 

function getObsCyto(PatientID,mradm,EpisodeID,ObsGroup,ObsDate,ObsTime,ReadOnly,oeordexecid,studentchart) {
	//alert(PatientID+"^"+mradm+"^"+EpisodeID+"^"+ObsGroup+"^"+ObsTime+"^"+ObsDate+"^"+oeordexecid+"^"+studentchart);
	var url="mrobservations.entry.csp?PatientID="+PatientID+"&PatientBanner=1&EpisodeID="+EpisodeID+"&mradm="+mradm+"&ObsGrpID="+ObsGroup+"&ObsDate="+ObsDate+"&ObsTime="+ObsTime+"&ReadOnly="+ReadOnly+"&ID="+ObsDate+"||"+ObsTime+"||"+ObsGroup+"&oeordexecid="+oeordexecid+"&studentchart="+studentchart;
        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
	var features="top=30,left=10,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes";
	if ((ObsDate!="")&&(ObsTime!="")) {
		websys_createWindow(url, 'Observation', features);

	}
}

function getResult(id,EpisodeID,ChartID,ChartItemID,Type,OrderID,TestItem) {
	//alert(id+"^"+EpisodeID+"^"+ChartID+"^"+ChartItemID+"^"+Type+"^"+OrderID+"^"+TestItem);
	if (id.substring(2,id.length)!="") {
		//LOG 37476 RC 19/08/03 This link now links to a combined csp which incorporates both the LabResult and the
		//SSAuditList components. The old link was left here in case of an emergency.
		//var url="websys.default.csp?WEBSYS.TCOMPONENT=OEOrdItem.LabResult&PatientBanner=1&EpisodeID="+EpisodeID+"&ResultID="+id.substring(2,id.length)+"&PatientID="+PatientID+"&ChartID="+ChartID+"&ItemID="+ItemID+"&Type="+Type+"&OrderID="+OrderID;
		var url="oelabres.ssauditlist.csp?&PatientBanner=1&EpisodeID="+EpisodeID+"&ResultID="+id.substring(2,id.length)+"&PatientID="+PatientID+"&ChartID="+ChartID+"&ItemID="+ChartItemID+"&Type="+Type+"&OrderID="+OrderID+"&TestItem="+TestItem;
		websys_createWindow(url, 'LabResult', 'top=30,left=30,width=500,height=600,scrollbars=yes,resizable=yes');
	}
}

function CytoScrolling(PatientID,EpisodeID,ChartID,Context,Start,Columns,mradm,LabItem,ObsGroup,HideHeadings,DaysFrom,DaysTo,OrderCategory,OrderSubCategory,OrderItem,LastDate1,ShowLab,ShowOrderItem,ShowOrderCat,ShowOrderSubcat,ClinPath,ShowClinPath) {
		//alert(PatientID+"^"+EpisodeID+"^"+ChartID+"^"+Context+"^"+Start+"^"+Columns+"^"+mradm+"^"+LabItem+"^"+ObsGroup+"^"+HideHeadings+"^"+DaysTo);
		var url="epr.cytotoxic.csp?PatientID="+PatientID+"&PatientBanner=1&EpisodeID="+EpisodeID+"&ChartID="+ChartID+"&CONTEXT="+Context+"&mradm="+mradm+"&Observation="+ObsGroup+"&Start="+Start+"&Columns="+Columns+"&LabItem="+LabItem+"&HideHeadings="+HideHeadings+"&DaysFrom="+websys_escape(DaysFrom)+"&DaysTo="+websys_escape(DaysTo)+"&OrderCategory="+OrderCategory+"&OrderSubCategory="+OrderSubCategory+"&OrderItem="+OrderItem+"&LastDate1="+LastDate1+"&ShowLab="+ShowLab+"&ShowOrderItem="+ShowOrderItem+"&ShowOrderCat="+ShowOrderCat+"&ShowOrderSubcat="+ShowOrderSubcat+"&ClinPath="+ClinPath+"&ShowClinPath="+ShowClinPath;
		// are we:
		//  closing the first page,
		//  opening a new page, or
		//  just refreshing ourselves?
		// Log 37905 - AI - 02-09-2003 : Check for ItemID (if Null, we are coming from Cum. if not Null, we are coming from Tab and want to display when Start=1)
		// alert(window.opener + '\n'+OrderItemID+'\n'+Start+'\n'+url);
		if ((Start<1)&&(window.opener)) {
			window.opener=null;
   			window.close();
		} else if ((window.opener)&&(Start==0)) {
			window.opener=null;
 			window.close();
		} else if (window.opener) {
			window.location = url;
		} else {
			websys_createWindow(url, 'CytoScrolling', 'scrollbars=yes,toolbar=no,width=400,height=600,top=100,left=100,resizable=yes,status=yes');
		} 
}