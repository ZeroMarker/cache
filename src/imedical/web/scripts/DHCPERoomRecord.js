document.body.onload=LoadHandler1;
function LoadHandler1()
{
	var tbl=document.getElementById("tDHCPERoomRecord");
	if(tbl) tbl.ondblclick=DHC_SelectPat;
}
function DHC_SelectPat()
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow !=0) {
		var PatientID="";
		var EpisodeID="";
		var mradm=""
		var PatientObj=document.getElementById("PatientIDz"+selectrow);
		var EpisodeObj=document.getElementById("EpisodeIDz"+selectrow);
		
			if (PatientObj) PatientID=PatientObj.value;
			if (EpisodeObj) EpisodeID=EpisodeObj.value;
			//if (mradmObj) mradm=mradmObj.value ;  
			
			
			var lnk = "dhcpe.epr.chartbook.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
			//var lnk="websys.csp?a=a&TMENU=133%BuildIndices·½·¨2&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
	
			window.location=lnk;
			return true;
			var wwidth=screen.width-10;
			var wheight=screen.height-10;
			var xposition = (screen.width - wwidth) / 2;
			var yposition = (screen.height - wheight) / 2;
			var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,titlebar=yes,'
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
			var cwin=window.open(lnk,"_blank",nwin)	
			return true;
		//}
	}
}