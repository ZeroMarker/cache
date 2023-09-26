// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

/*Procedure for allowing multiple profiles on the same page is to dynamically change the id of a
  profiles form, table menu and table list to be unique.  The unique id is obtained from
  adding the document.forms.length property on to the end of their existing names.*/
var df=document.forms;
var ltbl=document.getElementById("t"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
if (ltbl) {ltbl.id=ltbl.id+df.length,ltbl.Name=ltbl.id;}
var mtbl=document.getElementById("m"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
if (mtbl) {mtbl.id=mtbl.id+df.length,mtbl.Name=mtbl.id;}
df[df.length-1].id=df[df.length-1].id+df.length;df[df.length-1].name=df[df.length-1].name+df.length;

// Log 42221 - AI - 10-02-2004 : Add studentchart to the passed variables.
function getObs(PatientID,mradm,EpisodeID,ObsGroup,ObsDate,ObsTime,ReadOnly,oeordexecid,studentchart,node,revorder) {
	//alert(PatientID+"^"+mradm+"^"+EpisodeID+"^"+ObsGroup+"^"+ObsTime+"^"+ObsDate+"^"+oeordexecid+"^"+studentchart);
	var url="mrobservations.entry.csp?PatientID="+PatientID+"&PatientBanner=1&EpisodeID="+EpisodeID+"&mradm="+mradm+"&ObsGrpID="+ObsGroup+"&ObsDate="+ObsDate+"&ObsTime="+ObsTime+"&ReadOnly="+ReadOnly+"&ID="+ObsDate+"||"+ObsTime+"||"+ObsGroup+"&oeordexecid="+oeordexecid+"&studentchart="+studentchart+"&node="+node+"&ReverseDateOrder="+revorder;
	//Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
        var features="top=30,left=10,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes";
	if ((ObsDate!="")&&(ObsTime!="")) {
		websys_createWindow(url, 'new', features);

	}
}

// Log 29736 - AI - 12-01-2004 : Add ObservationGroup,CurrentPregnancy and ReverseDateOrder. EpisodesAll already done.
// Log 56124 YC - Added stdate,sttime,enddate,endtime - also escaped Obsitm (why do we need to pass in graph descriptions anyway?!)
function ObservationScrollingResult(PatientID,EpisodeID,EpisodesAll,mradm,Obsitmparams,Obsitm,ChartID,Context,Start,Columns,ObservationGroup,CurrentPregnancy,ReverseDateOrder,StudentChart,stdate,sttime,enddate,endtime,DisplayComments,DisplayLastUpdate) {
		var url="epr.observations.csp?PatientID="+PatientID+"&PatientBanner=1&EpisodeID="+EpisodeID+"&EpisodesAll="+EpisodesAll+"&ChartID="+ChartID+"&Context="+Context+"&mradm="+mradm+"&Start="+Start+"&Columns="+Columns+"&Obsitmparams="+Obsitmparams+"&Obsitm="+escape(Obsitm)+"&ObservationGroup="+ObservationGroup+"&CurrentPregnancy="+CurrentPregnancy+"&ReverseDateOrder="+ReverseDateOrder+"&studentchart="+StudentChart+"&stdate="+stdate+"&sttime="+sttime+"&enddate="+enddate+"&endtime="+endtime+"&DisplayComments="+DisplayComments+"&DisplayLastUpdate="+DisplayLastUpdate;
		// are we opening a new page, or just refreshing ourselves?
		// are we:
		//  closing the first page,
		//  opening a new page, or
		//  just refreshing ourselves?
		if ((Start==0)&&(window.opener)) {
			window.opener=null;
   			window.close();
   		} else
		if (window.opener) {
			window.location = url;
		} else {
		
			websys_createWindow(url, 'Observations', 'scrollbars=yes,toolbar=no,width=screen.width,height=screen.height,top=0,left=0,resizable=yes');
		}
}

