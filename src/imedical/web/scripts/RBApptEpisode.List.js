// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


function SelectRowHandler() {
}

/*****
function SelectRowHandler() {
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");

	if (eSrcAry.length>0)
	{
		if (eSrcAry[0]=="Order") {
			//oeorder.custom.csp
			//"&EpisodeID="_%request.Get("EpisodeID")_"&PatientID="_%request.Get("PatientID")_"&ApptID="_rs.GetDataByName("apptid")_"&PatientBanner=1"
			//height=720,width=800,top=5,left=5
			var PatID=document.getElementById("PatientIDz"+eSrcAry[1]).value;
			var EpID=document.getElementById("EpisodeIDz"+eSrcAry[1]).value;
			var mr=document.getElementById("mradmz"+eSrcAry[1]).value;
			var twkfl=document.getElementById("TWKFL").value;
			var twkfli=document.getElementById("TWKFLI").value;
			var statusObj=document.getElementById("APPT_Statusz"+eSrcAry[1]);
			if ((statusObj)&&(statusObj.value!="X")) {
				var proceed=confirm(t['Cancelled'])
				if (!proceed) return false;
			}
			var currentlink=eSrc.href.split("?");
			var temp1=currentlink[1].split("&TWKFL");
			var url = "oeorder.custom.csp?" + temp1[0] + "&TWKFL=" + twkfl + "&TWKFLI=" + twkfli + "&PatientID=" + PatID + "&EpisodeID=" + EpID + "&mradm=" + mr + "&PatientBanner=1";
			websys_lu(url,false,"width=800,height=720,top=5,left=5");
			return false;
		}
		
	}
}
********/