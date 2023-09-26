// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var df=document.forms;
var tbl=document.getElementById("t"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
var frm=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));

if ((frm)&&(tbl)) {
	for (var i=1;i<tbl.rows.length;i++) {
		var ObjRes=document.getElementById("RESFileNamez"+i);
		if (ObjRes){
			ObjRes.onclick=ResultsLinkHander;
		}
	}
}

function ResultsLinkHander(e) {
 	var DisplayWordFormat=frm.elements["DisplayWordFormat"].value;
	var ChartID=frm.elements["ChartID"].value;
	var PatientID=frm.elements["PatientID"].value;
	var EpisodeID=frm.elements["EpisodeID"].value;
	var ItemID=frm.elements["ItemID"].value;
	var Type=frm.elements["Type"].value;
	var OrderID=frm.elements["OrderID"].value;
	var ResultDetails=frm.elements["ResultDetails"].value;
	var dicomArry=frm.elements["DicomBuffer"].value.split("^");
	var pathArry=frm.elements["UNCPath"].value.split("^");
	var mradm=frm.elements["mradm"].value;
	var eSrc=websys_getSrcElement(e);
	var eSrcAry=eSrc.id.split("z");
	var row=eSrcAry[eSrcAry.length-1];
	var ResultID=document.getElementById("RESRowIdz"+row).value;
	var objID=document.getElementById("RESFileNamez"+row);
	var NSRobj=document.getElementById("RESNSRDRz"+row);
	var RESRowId=document.getElementById("RESRowIdz"+row).value;
	if (objID) {
		var FileName=objID.innerText;
		// rebuild the 'ResultDetails' variable..
		//var aryResultDetails = ResultDetails.split("*");
		//var aryDocumentDetails = aryResultDetails[2].split("~");
		//aryDocumentDetails[3] = FileName;
		//aryResultDetails[2] = aryDocumentDetails.join("~");
		//aryResultDetails[0] = RESRowId;
		//ResultDetails = aryResultDetails.join("*");
	}

	if ((NSRobj) && (NSRobj.value=="")) {
		if (DisplayWordFormat!=1) {
			// Log 50701 YC - Added MRAdm to URL
			url="oeorditem.tabularresultsemr.csp?Counter=&OrderID="+OrderID+"&EpisodeID="+EpisodeID+"&FileName="+FileName+"&ResultDetails="+ResultDetails+"&PatientBanner=1&PatientID="+PatientID+"&ChartID="+ChartID+"&ResultID="+ResultID+"&ItemID="+ItemID+"&Type="+Type+"&ResultType="+Type+"&ReadOnly=1"+"&Context=&mradm="+mradm;
			if (dicomArry[0]=="J") {
					var urlExt="&DicomResult="+dicomArry[0]+"&OrderID="+dicomArry[1]+"&mradm="+dicomArry[3]+"&catgsID="+dicomArry[4]+"&dfrom="+dicomArry[5]+"&dto="+dicomArry[6]+"&EpisodesAll="+dicomArry[7];
					url=url+urlExt;
			}
			// see log 55486 - causes URL error on site
			//url=escape(url);
			websys_createWindow(url, 'PreviousLabTabularResults', 'top=50,left=100,width=800,height=600,scrollbars=yes,resizable=yes');
			return false;
		} else {
			var Path=pathArry[0]+FileName;
			var re=/\\/g;
			Path=Path.replace(re,"/");
			if (Path.charAt(0)!="/") Path=Path+"/";
                        //Log 59598 - BC - 30-06-2006 : Change statusbar variable (status=) to display the status bar (=yes).
			window.open(Path,'new','scrollbars=yes,resizable=yes,toolbar=no,width=750,height=600,location=no,directories=no,status=yes,menubar=no,fullscreen=no');
			return false;
		}
	}
	else if ((NSRobj) && (NSRobj.value!="")){
		var IDObj=document.getElementById("RESRowIdz"+row);
		if(IDObj && IDObj.value!="")	{
			var ID=IDObj.value;
			var path="websys.default.csp?WEBSYS.TCOMPONENT=OEOrdItem.NSRTxtResult&ID="+ID;
                        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
			websys_createWindow(path,"","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
		}

	}
	return false;

}