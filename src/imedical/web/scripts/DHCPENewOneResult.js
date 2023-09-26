
function ShowAllResult(e)
{
	var EpisodeID="";
	var obj=document.getElementById("EpisodeID");
    	if (obj){
		EpisodeID=obj.value
	}
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewDiagnosis"
			+"&EpisodeID="+EpisodeID
			+"&ChartID="
			+"&OnlyRead=Y";
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes';

	window.open(lnk,"_blank",nwin)
	return true;
}