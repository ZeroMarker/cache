// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyLoadHandler() {
	var obj=document.getElementById("EVName");
	if (obj) obj.onchange=EVenuChangeHandler;
	
	// Log 36634 BC Moved to ReasonSelectHandler so broker still works 
	//var obj=document.getElementById("RNAVDesc");
	//if (obj) obj.onchange=ReasonChangeHandler;
	
	// Log 36634 BC Enable Broker on the reason
	var obj=document.getElementById("RNAVDesc");
	if (obj) obj.onblur=CheckReason;

	var obj=document.getElementById("update1");
	if (obj) obj.onclick=UpdateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;

	MandatoryFields();
	
	CheckForVacant();
	SetUpOnLoad();
	
	MandatoryFields();
	
	var obj=document.getElementById("NAVacantFrDate");
	if (obj) obj.onblur=CheckVacantSdate;
	var obj=document.getElementById("NAVacantToDate");
	if (obj) obj.onblur=CheckVacantSdate;
	var obj=document.getElementById("NAVacant");
	if (obj) obj.onclick=CheckForVacant;
	var needtoreview=""
	var objrevprocess=document.getElementById("reviewprogress");
	if (objrevprocess) needtoreview=objrevprocess.value;
	//alert("needtoreview="+needtoreview);
	var REVObj=document.getElementById("ReviewConf");
	if (REVObj) 
	{
	 if (needtoreview==2)
		 { 
			REVObj.disabled=false;
			REVObj.onclick=LaunchNewNAscreen;
		 }
		 else 
		  {
			REVObj.disabled=true;
			try {REVObj.onclick=LinkDisable;} catch(e) {REVObj.onclick=FalseLink;}
			//SNAPObj.onclick=LinkDisable;
		  } 
	//return false;
	}

}

function FalseLink(evt) {
	var el = websys_getSrcElement(evt);
	//if (el.id=="ViewableBy") VIEWABLE=el;
	if (el.disabled) {
		return false;
	}
	return true;
}

function EVenuChangeHandler() {
	MandatoryFields();	
}

function ReasonChangeHandler() {
	var objRes=document.getElementById("RNAVDesc");
	var objEVFields = document.getElementById('EventFields')
	if (objEVFields) objEVFields.value=""
	MandatoryFields();
}
// Log 36634 BC Enable Broker on the reason 
function CheckReason() {
	var objRes=document.getElementById("RNAVDesc");
	if ((objRes)&&(objRes.value!="")) {
		var objEVFields = document.getElementById('EventFields')
		if (objEVFields) objEVFields.value=""
		MandatoryFields();
	} else {
		enableField('EVName','ld1655iEVName')
		enableField('RNAVDesc','ld1655iRNAVDesc')
		enableField('NARSVP','')
		enableField('NAArrived','')
	}
}

function MandatoryFields() {
	var objEvent=document.getElementById("EVName");
	var objcReason=document.getElementById("cRNAVDesc");
	var obj=document.getElementById("NAVacant");
	var objcReason2=document.getElementById("cNAVacantReason");
	var objnarea=document.getElementById("RNAVDesc");
	if ((obj)&&(obj.checked)&&(objcReason2)) {
	objcReason2.className = "clsRequired";
	}
	else {
	if (objEvent && objEvent.value!="") {
		objcReason.className = "";
	} else {
		objcReason.className = "clsRequired";
	}
	DisableFields();
	}
	
}

function UpdateClickHandler() {
	var obj1=document.getElementById("NAVacantFrDate");
	var obj2=document.getElementById("NAVacantToDate");
	var needtoreview=1
	var objrevprocess=document.getElementById("reviewprogress");
	if (objrevprocess) needtoreview=objrevprocess.value;
	
	if ((obj1)&&(obj2)) {
	if (obj2.value!=obj1.value) {
	alert(t['NSameDayV']);
	websys_setfocus('NAVacantToDate')
	return false;
	}
	}
	SetUpOnUpdate();
	//if (CheckMandatoryFields() && CheckEventDates() && CheckValidDateTime()) return update1_click();
	if (!CheckMandatoryFields()) return false;
	if (!CheckEventDates()) return false;
	if (!CheckValidDateTime()) return false;
	//md in DEV smbstf
	if (needtoreview==1) {
	if (confirm(t['ReviewConfilcts'])) {
	LaunchNewNAscreen();
	return false;
	}//else return false;
	//md
	}
	if (objrevprocess) objrevprocess.value=2;
	update1_click();
}

function LaunchNewNAscreen()
{
	var ResID=""
	var StartDate=""
	var StartTime=""
	var EndDate=""
	var EndTime=""
	var NotAvailID=""
	var objhnafrd=document.getElementById("HNAFrDate");
	var objhnafrt=document.getElementById("HNAFrTime");
	var objhnatod=document.getElementById("HNAToDate");
	var objhnatot=document.getElementById("HNAToTime");
	var objRES=document.getElementById("ResID");
	var objNA=document.getElementById("ID");
	if (objRES) ResID=objRES.value;
	if (objhnafrd) StartDate=objhnafrd.value;
	if (objhnafrt) StartTime=objhnafrt.value;
	if (objhnatod) EndDate=objhnatod.value;
	if (objhnatot) EndTime=objhnatot.value;
	if (objNA)     NotAvailID=objNA.value;
	websys_lu('websys.default.csp?WEBSYS.TCOMPONENT=RBNotAvail.List&&ResID='+ResID+'&dateFROM='+StartDate+'&timeFROM='+StartTime+'&dateTO='+EndDate+'&timeTO='+EndTime+'&notavailid='+NotAvailID,1);			
	return false;
 }

function CheckEventDates() {
	//alert("heckEventDates");
	var msg=""
	var obj=document.getElementById("EventFields")
	if (obj && obj.value!="") {
		var lu = obj.value.split("|");
		var dt=lu[0];
		var ft=lu[1];
		var tt=lu[2];
	
		var DateFrom=getDate("NAFrDate","NAFrTime")
		var DateTo=getDate("NAToDate","NAToTime")
		var evDateFrom=getDate2(dt,ft)
		var evDateTo=getDate2(dt,tt)

		if ((DateFrom.getDate()!=evDateFrom.getDate()) || DateFrom.getMonth()!=evDateFrom.getMonth()) msg += "\'" + t['NAFrDate'] + "\' " + t['NoMatch'] + "\n";
		if ((DateTo.getDate()!=evDateFrom.getDate()) || DateTo.getMonth()!=evDateFrom.getMonth()) msg += "\'" + t['NAToDate'] + "\' " + t['NoMatch'] + "\n";
		if (DateFrom.getTime()>DateTo.getTime()) msg += "\'" + t['TimeRange'] + "\' " + t['Invalid'] + "\n";
		if (DateFrom.getTime()<evDateFrom.getTime() || DateTo.getTime()>evDateTo.getTime()) msg += "\'" + t['TimeRange'] + "\' " + t['OutsideEvent'] + "\n";

		if (msg=="") {
			return true;
		} else {
			alert(msg)
			return false;
		}
	} else {
		return true;
	}
	//alert("CheckEventDates");
}

function CheckMandatoryFields() {
	//alert("CheckMandatoryFields");
	var msg=""
	var obj = document.getElementById('RNAVDesc');
	var cobj= document.getElementById('cRNAVDesc');
	if ((obj)&&(obj.value=="")&&(cobj.className=="clsRequired")) {
			msg += "\'" + t['RNAVDesc'] + "\' " + t['XMISSING'] + "\n";
	}
	if ((obj)&&(!CheckValidEntry(obj))) { msg += "\'" + t['NAVacantReason'] + "\' " + t['XINVALID'] + "\n"; }
	//
	var obj = document.getElementById('NAVacantReason');
	var cobj= document.getElementById('cNAVacantReason');
	if ((obj)&&(obj.value=="")&&(cobj.className=="clsRequired")) {
			msg += "\'" + t['NAVacantReason'] + "\' " + t['XMISSING'] + "\n";
	}
	if ((obj)&&(!CheckValidEntry(obj))) { msg += "\'" + t['NAVacantReason'] + "\' " + t['XINVALID'] + "\n"; }
	//
	//alert("CheckMandatoryFields2");
	if (msg=="") {
		return true;
	} else {
		alert(msg)
		return false;
	}
	//alert("CheckMandatoryFields3");
}

function CheckValidDateTime() {
	//var (ValidDate,NAFrDate,NAFrTime,NAToDate,NAToTime)=""
	//alert("CheckValidDateTime");
	var msg=""
	
	//var obj=document.getElementById("NAFrDate")
	var obj=document.getElementById("HNAFrDate")
	if (obj) NAFrDate=obj.value
	//var obj=document.getElementById("NAToDate")
	var obj=document.getElementById("HNAToDate")
	if (obj) NAToDate=obj.value
	//var obj=document.getElementById("NAFrTime")
	var obj=document.getElementById("HNAFrTime")
	if (obj) NAFrTime=obj.value
	//var obj=document.getElementById("NAToTime")
	var obj=document.getElementById("HNAToTime")
	if (obj) NAToTime=obj.value
	
	if (NAFrDate,NAFrTime,NAToDate,NAToTime!="") {
		//0=they are equal, -1=valid, 1=invalid
		if (DateTimeStringCompare(NAFrDate,NAFrTime,NAToDate,NAToTime)!=-1) msg=t['InvalidDateTime']
		
	}
	//alert("CheckValidDateTime2");
	if (msg=="") {
		return true;
	} else {
		alert(msg)
		return false;
	}	
	//alert("CheckValidDateTime3");
}
function EventSelectHandler(str) {
	var lu = str.split("^");
	var obj=document.getElementById("NAFrDate")
	if (obj) obj.value=lu[1]
	var obj=document.getElementById("NAToDate")
	if (obj) obj.value=lu[1]
	var obj=document.getElementById("NAFrTime")
	if (obj) obj.value=lu[2]
	var obj=document.getElementById("NAToTime")
	if (obj) obj.value=lu[3]
	var obj=document.getElementById("EventFields")
	if (obj) obj.value=lu[1]+"|"+lu[2]+"|"+lu[3]
	MandatoryFields();
}

function ReasonSelectHandler(str) {
	var objEVFields = document.getElementById('EventFields')
	if (objEVFields) objEVFields.value=""
	// Log 36634 BC Enable Broker on the reason
	ReasonChangeHandler();
	//MandatoryFields();
}

function DisableFields() {
	var objEvent = document.getElementById('EVName')
	var objReason = document.getElementById('RNAVDesc')
	enableField('EVName','ld1655iEVName')
	enableField('RNAVDesc','ld1655iRNAVDesc')
	enableField('NARSVP','')
	enableField('NAArrived','')
	if (objEvent && objEvent.value!="") {
		disableField('RNAVDesc','ld1655iRNAVDesc')	
	} else if (objReason && objReason.value!="") {
		disableField('EVName','ld1655iEVName')
		disableField('NARSVP','')
		disableField('NAArrived','')
	}
}

function disableField(itm,lookupId) {
	var obj = document.getElementById(itm)
	if (obj) {
		obj.disabled=true
		obj.className = "disabledField";
	}
	var obj = document.getElementById("c"+itm)
	if (obj) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	var obj = document.getElementById(lookupId)
	if (obj) {
		obj.disabled=true
	}
}

function enableField(itm,lookupId) {
	var obj = document.getElementById(itm)
	if (obj) {
		obj.disabled=false
		obj.className = "";
	}
	var obj = document.getElementById("c"+itm)
	if (obj) {
		obj.disabled=false
	}
	var obj = document.getElementById(lookupId)
	if (obj) {
		obj.disabled=false
	}
}

function getDate(sDate,sTime) {
	var objDate=document.getElementById(sDate)
	var objTime=document.getElementById(sTime)
	if (objDate && objTime) {
		fdate=SplitDateStr(objDate.value,objTime.value)
		var fdt = new Date(fdate["yr"], fdate["mn"]-1, fdate["dy"], fdate["hr"], fdate["min"]);
	}
	return fdt;
}

function getDate2(sDate,sTime) {
	fdate=SplitDateStr(sDate,sTime)
	var fdt = new Date(fdate["yr"], fdate["mn"]-1, fdate["dy"], fdate["hr"], fdate["min"]);
	return fdt;
}

function SplitDateStr(strDate,strTime) {
 	var arrDateComponents = new Array(3);
 	var arrDate = "";
	if (dtseparator) arrDate=strDate.split(dtseparator);
	if (tmseparator) arrTime=strTime.split(tmseparator);
 	switch (dtformat) {
  		case "YMD":
   			arrDateComponents["yr"] = arrDate[0];
   			arrDateComponents["mn"] = arrDate[1];
   			arrDateComponents["dy"] = arrDate[2];
   			break;
  		case "MDY":
   			arrDateComponents["yr"] = arrDate[2];
   			arrDateComponents["mn"] = arrDate[0];
   			arrDateComponents["dy"] = arrDate[1];
   			break;
  		default:
   			arrDateComponents["yr"] = arrDate[2];
   			arrDateComponents["mn"] = arrDate[1];
   			arrDateComponents["dy"] = arrDate[0];
   			break;
 	}
	arrDateComponents["hr"] = arrTime[0];
	arrDateComponents["min"] = arrTime[1];
	return arrDateComponents;
}
function SERDescLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('SERDesc');
	if (obj) obj.value=lu[1];
}

function CheckForVacant() {
	var obj=document.getElementById("NAVacant");
	var objnafd=document.getElementById("NAFrDate");
	var objnaft=document.getElementById("NAFrTime");
	var objnatd=document.getElementById("NAToDate");
	var objnatt=document.getElementById("NAToTime");
	var objvacfd=document.getElementById("NAVacantFrDate");
	var objvacft=document.getElementById("NAVacantFrTime");
	var objvactd=document.getElementById("NAVacantToDate");
	var objvactt=document.getElementById("NAVacantToTime");
	var objnarea=document.getElementById("RNAVDesc");
	var objvacrea=document.getElementById("NAVacantReason");
	if ((obj)&&(obj.checked)) {
		if (objnafd) disableField(objnafd.id);
		if (objnaft) disableField(objnaft.id);
		if (objnatd) disableField(objnatd.id);
		if (objnatt) disableField(objnatt.id);
		if (objvacfd) enableField(objvacfd.id);
		if (objvacft) enableField(objvacft.id);
		if (objvactd) enableField(objvactd.id);
		if (objvactt) enableField(objvactt.id);
		var cobj= document.getElementById('cRNAVDesc');
		if (objnarea) disableField('RNAVDesc','ld1655iRNAVDesc');
		if (objnafd) enableField('NAVacantReason','ld1655iRNAVDesc');
		}
		else {
		if (objnafd) enableField(objnafd.id);
		if (objnaft) enableField(objnaft.id);
		if (objnatd) enableField(objnatd.id);
		if (objnatt) enableField(objnatt.id);
		if (objvacfd) disableField(objvacfd.id);
		if (objvacft) disableField(objvacft.id);
		if (objvactd) disableField(objvactd.id);
		if (objvactt) disableField(objvactt.id);
		if (objnarea) enableField('RNAVDesc','ld1655iRNAVDesc');
		if (objnafd) disableField('NAVacantReason','ld1655iRNAVDesc');	
		}
		
	MandatoryFields() ;
}

function SetUpOnUpdate() {
	var obj=document.getElementById("NAVacant");
	var objnafd=document.getElementById("NAFrDate");
	var objnaft=document.getElementById("NAFrTime");
	var objnatd=document.getElementById("NAToDate");
	var objnatt=document.getElementById("NAToTime");
	var objvacfd=document.getElementById("NAVacantFrDate");
	var objvacft=document.getElementById("NAVacantFrTime");
	var objvactd=document.getElementById("NAVacantToDate");
	var objvactt=document.getElementById("NAVacantToTime");
	var objnarea=document.getElementById("RNAVDesc");
	var objvacrea=document.getElementById("NAVacantReason");
	var objhnafrd=document.getElementById("HNAFrDate");
	var objhnafrt=document.getElementById("HNAFrTime");
	var objhnatod=document.getElementById("HNAToDate");
	var objhnatot=document.getElementById("HNAToTime");
	var objhnares=document.getElementById("HNAReasonDR");
	if ((obj)&&(obj.checked)) {
		if ((objvacfd)&&(objhnafrd)&&(objvacfd.value!="")) { objhnafrd.value=objvacfd.value;}
		if ((objvacft)&&(objvacft.value!="")&&(objhnafrt)) { objhnafrt.value=objvacft.value;}
		if ((objvactd)&&(objhnatod)&&(objvactd.value!="")) { objhnatod.value=objvactd.value;}
		if ((objvactt)&&(objvactt.value!="")&&(objhnatot)) { objhnatot.value=objvactt.value; }
		if ((objvacrea)&&(objvacrea.value!="")&&(objhnares)) { objhnares.value=objvacrea.value; }
		}
		else {
		if ((objnafd)&&(objhnafrd)&&(objnafd.value!="")) { objhnafrd.value=objnafd.value;}
		if ((objnaft)&&(objnaft.value!="")&&(objhnafrt)) { objhnafrt.value=objnaft.value;}
		if ((objnatd)&&(objhnatod)&&(objnatd.value!="")) { objhnatod.value=objnatd.value;}
		if ((objnatt)&&(objnatt.value!="")&&(objhnatot)) { objhnatot.value=objnatt.value; }
		if ((objnarea)&&(objnarea.value!="")&&(objhnares)) { objhnares.value=objnarea.value; }
		}
	
}



function SetUpOnLoad() {

	var obj=document.getElementById("NAVacant");
	var objnafd=document.getElementById("NAFrDate");
	var objnaft=document.getElementById("NAFrTime");
	var objnatd=document.getElementById("NAToDate");
	var objnatt=document.getElementById("NAToTime");
	var objvacfd=document.getElementById("NAVacantFrDate");
	var objvacft=document.getElementById("NAVacantFrTime");
	var objvactd=document.getElementById("NAVacantToDate");
	var objvactt=document.getElementById("NAVacantToTime");
	var objnarea=document.getElementById("RNAVDesc");
	var objvacrea=document.getElementById("NAVacantReason");
	var objhnafrd=document.getElementById("HNAFrDate");
	var objhnafrt=document.getElementById("HNAFrTime");
	var objhnatod=document.getElementById("HNAToDate");
	var objhnatot=document.getElementById("HNAToTime");
	var objhnares=document.getElementById("HNAReasonDR");
		
	
	if ((obj)&&(obj.checked)) {
		if ((objvacfd)&&(objhnafrd)) { objvacfd.value=objhnafrd.value;}
		if ((objvacft)&&(objhnafrt)) { objvacft.value=objhnafrt.value;}
		if ((objvactd)&&(objhnatod)) { objvactd.value=objhnatod.value;}
		if ((objvactt)&&(objhnatot)) { objvactt.value=objhnatot.value;}
		if ((objhnares)&&(objvacrea)) { objvacrea.value=objhnares.value;}
		}
		else {
		if ((objnafd)&&(objhnafrd)) { objnafd.value=objhnafrd.value;}
		if ((objnaft)&&(objhnafrt)) { objnaft.value=objhnafrt.value;}
		if ((objnatd)&&(objhnatod)) { objnatd.value=objhnatod.value;}
		if ((objnatt)&&(objhnatot)) { objnatt.value=objhnatot.value; }
		if ((objhnares)&&(objnarea)) { objnarea.value=objhnares.value;}
		}
	
}

function CheckVacantSdate(e) {
	var eSrc = websys_getSrcElement(e);
	var option=2;
	if (eSrc.id=="NAVacantFrDate") { option=1 }
	
	var obj1=document.getElementById("NAVacantFrDate");
	var obj2=document.getElementById("NAVacantToDate");
	if ((obj1)&&(obj2)) {
	if (option==1) obj2.value=obj1.value;
	if ((option==2)&&(obj2.value!="")&&(obj2.value!=obj1.value)) {
	alert(t['NSameDayV']);
	websys_setfocus(eSrc.id)
	return false;
	}
	}

}

function CheckValidEntry(obj) {
	if ((obj)&&(obj.className=="clsInvalid")) {
		return false
	} else {
		return true
	}
}
//alert("outside lh");
document.body.onload = BodyLoadHandler;