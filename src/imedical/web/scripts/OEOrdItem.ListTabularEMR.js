// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// called from TabularResultsShow in epr.LabGraphTestSets
function getTabularResult(counter,id,resultid,orderid,episodeid,labepisodeno,resulttype,dateread,patientid,otherrowid,ChartID,ItemID,Type,ResultStatus,HL7ResultType,DisplayWordFormat,EpisodesAll,mradm,catgsID,DicomResult,Context,ColumnID,DischEpisodes,MaxRes,ResultStatusList) {
	/*var res = document.getElementById("ResultList");
	var ResultList = "";
	if (res) ResultList = res.value;

	if (ResultList!="") {
		var aryResultPiece = ResultList.split("*");
		var ResultType = aryResultPiece[1];
		if ((ResultType=="W") && (ResultStatus=="E")) {
			alert(t['ResultIsEntered']);
		}
		var ResDetails = ResultList;
		HL7ResultType=aryResultPiece[2];
		var arrpath = HL7ResultType.split("~");
		var path = "";
		if (arrpath.length>3) path = arrpath[3];
		var TheTitle = GetTheTitle(ResultType,HL7ResultType);
		var FileName=""
		if (aryResultPiece[4]!=1) {
			FileName=arrpath[3];
		}
		// see of our filename is a valid type - if not - call the non-standard report page...
		var re=/(\.rtf)/gi;
		var re1=/(\.txt)/gi;
		var re2=/(\.doc)/gi;
		if ((path.search(re) == -1) && (path.search(re1) == -1) && (path.search(re2) == -1) && (ResultType == "W")) {
			var ID=aryResultPiece[0];
			var url="websys.default.csp?WEBSYS.TCOMPONENT=OEOrdItem.NSRTxtResult&ID="+ID;
                        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
			websys_createWindow(url,"","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");

		} else {
		*/
			//var url="oeorditem.tabularresultsemr.csp?Counter="+counter+"&OrderID="+orderid+"&ResultDetails="+ResDetails+"&PatientBanner=1&PatientID="+patientid+"&mradm="+mradm+"&ChartID="+ChartID+"&ItemID="+ItemID+"&ResultType="+Type+"&Type="+Type+"&EpisodeID="+EpisodeID+"&EpisodesAll="+EpisodesAll+"&ResultID="+resultid+"&catgsID="+catgsID+"&DicomResult="+DicomResult+"&CONTEXT="+Context+"&ColumnID="+ColumnID+"&DischEpisodes="+DischEpisodes;
			var TheTitle = GetTheTitle(resulttype,HL7ResultType);
			var url="oeorditem.tabularresultsemr.csp?Counter="+counter+"&OrderID="+orderid+"&ResultDetails=&PatientBanner=1&PatientID="+patientid+"&mradm="+mradm+"&ChartID="+ChartID+"&ItemID="+ItemID+"&ResultType="+Type+"&Type="+Type+"&EpisodeID="+EpisodeID+"&EpisodesAll="+EpisodesAll+"&ResultID="+resultid+"&catgsID="+catgsID+"&DicomResult="+DicomResult+"&CONTEXT="+Context+"&ColumnID="+ColumnID+"&DischEpisodes="+DischEpisodes+"&ResultStatusList="+ResultStatusList;
			websys_createWindow(url, TheTitle, 'top=50,left=100,width=800,height=600,scrollbars=yes,resizable=yes');
		/*}

	} else {
		var url="oeorditem.tabularresultsemr.csp?Counter="+counter;
		websys_createWindow(url, TheTitle, 'top=50,left=100,width=800,height=600,scrollbars=yes,resizable=yes');

	}
	*/
}






function GetTheTitle(ResultType,HL7ResultType)  {

	var TheTitle = "";
	if ((ResultType=="T")||((ResultType=="L")&&(HL7ResultType=="IM"))) {
		TheTitle = 'TextResults';
	} else if (ResultType=="L") {
		TheTitle = 'AtomicResults';
	} else if (ResultType=="RTFLAB") {
		TheTitle = 'RTFResults';
	} else if ((ResultType=="W")||(ResultType=="WLAB")) {
		TheTitle = 'WordResults';
	}
	return TheTitle;
}

// Log 37905 - AI - 04-09-2003 : add mradm to the list of parameters.
function getCumulativeResult(PatientID,EpisodeID,EpisodesAll,ChartID,Context,OrderItemID,IncludeRPrefix,CanRead,mradm,ChartItemID,OrderIDs,DischEpisodes,ResultStatusList) {
		var url="epr.cumulative.csp?PatientID="+PatientID+"&PatientBanner=1&EpisodeID="+EpisodeID+"&EpisodesAll="+EpisodesAll+"&ChartID="+ChartID+"&Context="+Context+"&OrderItemID="+OrderItemID+"&IncludeRPrefix="+IncludeRPrefix+"&mradm="+mradm+"&CanRead="+CanRead+"&ChartItemID="+ChartItemID+"&CumOrderIDs="+OrderIDs+"&DischEpisodes="+DischEpisodes+"&ResultStatusList="+ResultStatusList;
		websys_createWindow(url, 'CumulativeResults', 'scrollbars=yes,toolbar=no,width=screen.width,height=screen.height,top=0,left=0,resizable=yes');
}

function TabularScrollingResult(PatientID,EpisodeID,EpisodesAll,mradm,Tabularitmparams,Tabularitm,ChartID,ItemID,Type,Context,Start,Columns,CanRead,ChartItemID,DischEpisodes,PageNumber) {

		var url="epr.tabular.csp?PatientID="+PatientID+"&PatientBanner=1&EpisodeID="+EpisodeID+"&EpisodesAll="+EpisodesAll+"&ChartID="+ChartID+"&ItemID="+ItemID+"&Type="+Type+"&Context="+Context+"&mradm="+mradm+"&Start="+Start+"&Columns="+Columns+"&Tabularitmparams="+Tabularitmparams+"&Tabularitm="+escape(Tabularitm)+"&CanRead="+CanRead+"&ChartItemID="+ChartItemID+"&DischEpisodes="+DischEpisodes+"&PageNumber="+PageNumber;
		// are we:
		//  closing the first page,
		//  opening a new page, or
		//  just refreshing ourselves?
		//alert(Start + "^" +Columns);
		if ((Start<2)&&(window.opener)) {
			window.opener=null;
   			window.close();
   		} else if (window.opener) {
			window.location = url;
		} else {
			websys_createWindow(url, 'TabularResults', 'scrollbars=yes,toolbar=no,width=screen.width,height=screen.height,top=0,left=0,resizable=yes');
		}
}

function getDicomResult(OrderID,PatientID,mradm,catgsID,dfrom,dto,EpisodesAll,ResultID) {
		//alert("params"+":"+OrderID+":"+PatientID+":"+mradm+":"+catgsID+":"+dfrom+":"+dto+":"+EpisodesAll+":"+ResultID);
		var url="webtrak.annotate.csp?WEBSYS.TCOMPONENT=Dicom.Viewer&OrderID="+OrderID+"&PatientID="+PatientID+"&mradm="+mradm+"&catgsID="+catgsID+"&dfrom="+dfrom+"&dto="+dto+"&EpisodesAll="+EpisodesAll+"&ResultID="+ResultID;
		websys_createWindow(url, 'LabTabularResults', 'scrollbars=yes,toolbar=no,width=screen.width,height=screen.height,top=0,left=0,resizable=yes');
}

function verifyDicomResult(ResultID,patientid,OrderID) {
		//alert("params"+"="+OrderID+"="+PatientID+"="+mradm+"="+catgsID+"="+dfrom+"="+dto+"="+EpisodesAll+"="+ResultID);
		var url="websys.default.csp?WEBSYS.TCOMPONENT=OEOrdResult.ImageVerification&ID="+ResultID+"&PatientBanner=1&PatientID="+patientid+"&OrderID="+OrderID;
		websys_createWindow(url, 'LabTabularResults', 'top=50,left=100,width=300,height=300,scrollbars=yes,resizable=yes');
}

