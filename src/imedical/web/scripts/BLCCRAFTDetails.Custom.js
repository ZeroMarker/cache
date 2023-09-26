// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function DocumentLoadHandler() {
	var objSameDayWeight=document.getElementById("SameDayWeight");
	var objShortStayWeight=document.getElementById("ShortStayWeight");
	var objSameDay=document.getElementById("SameDay");
	var objLOS=document.getElementById("LOS");
	var objLIB=document.getElementById("LowInlierBoundary");
	var objHIB=document.getElementById("HighInlierBoundary");
	var objLowOutlierPerDiem=document.getElementById("LowOutlierPerDiem");
	var objInlierWeight=document.getElementById("InlierWeight");
	var objHighOutlierPerDiem=document.getElementById("HighOutlierPerDiem");
	var objHighOutlierDays=document.getElementById("HighOutlierDays");
	var objStayStatus=document.getElementById("CRAFTStayStatus");

	var sdw = new Number(objSameDayWeight.value);
	var ssw = new Number(objShortStayWeight.value);
	var los = new Number(objLOS.value);
	var lib = new Number(objLIB.value);
	var hib = new Number(objHIB.value);

	if (objSameDay) {
		if ((objSameDay.value!="on")&&(objSameDay.value!="SameDay")) {
			if (objSameDayWeight) objSameDayWeight.value="";
			if ((objShortStayWeight)&&( los > 3 )) objShortStayWeight.value="";
		} else {
			if (objShortStayWeight) objShortStayWeight.value="";
		}
	}

	//if (!( (los > 3) && (los < lib) )) {
	//	if (objLowOutlierPerDiem) objLowOutlierPerDiem.value="";
	//}
	
	//if (!( (los > (lib - 1)) && (los < (hib + 1)) )) {
	//	if (objInlierWeight) objInlierWeight.value="";
	//}

	if (!(los > hib)) {
		if (objHighOutlierPerDiem) objHighOutlierPerDiem.value="";
	}

	if (los > hib) {
		if (objHighOutlierDays)	objHighOutlierDays.value = los - hib;
	} else {
		if (objHighOutlierDays) objHighOutlierDays.value="";
	}

	if ((objStayStatus)&&(objStayStatus.value!="")) {
		if (objStayStatus.value!="LOW OUTLIER") {
			if (objLowOutlierPerDiem) objLowOutlierPerDiem.value="";
		}
		if ((objStayStatus.value!="INLIER")&&(objStayStatus.value!="HIGH OUTLIER")) {
			if (objInlierWeight) objInlierWeight.value="";
		}
	}
}

document.body.onload=DocumentLoadHandler;
