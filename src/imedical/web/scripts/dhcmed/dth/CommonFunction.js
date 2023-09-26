function DeathReportLookUpHeader(ReportID,EpisodeID){
	var t=new Date();
	t=t.getTime();
    var url="dhcmed.dth.report.csp?EpisodeID=" + EpisodeID + "&ReportID=" + ReportID + "&t=" + t;
    var newwindow=window.open(url,'deathreport11','height=635,width=1030,top=5,left=150,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no,status=no')
}