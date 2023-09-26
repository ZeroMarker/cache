// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var flag=0;
var chstring="";

function UpdateClickHandler() {
	flag=1;

	// Log 43788 - AI - 04-08-2004 : Check that the Result Available Date entered is valid before continuing.
	if (!ResultAvailableDateBlurHandler()) return false;

	return Update_click();
}

function AddClickHandler() {
	var sBuffer="";
	var labepno="";
	var allorderids="";
	var allorders="";
	var alltestids="";
	var epid="";

	var SpecsBuffer=document.getElementById("SpecsBuffer");
	if (SpecsBuffer) {
		sBuffer=SpecsBuffer.value;
	}
	var labepisodeno=document.getElementById("LabEpisodeNo");
	if (labepisodeno) {
		labepno=labepisodeno.value;
	}
	var episodeid=document.getElementById("EpisodeID");
	if (episodeid) {
		epid=episodeid.value;
	}
	var orders=document.getElementById("orderids");
	if (orders) {
		orderids=orders.value;
	}
	var orderids=document.getElementById("allorderids");
	if (orderids) {
		allorderids=orderids.value;
	}
	var testids=document.getElementById("alltestids");
	if (testids) {
		alltestids=testids.value;
	}
	var orders=document.getElementById("allorders");
	if (orders) {
		allorders=orders.value;
	}
	SpecimenDetailsOpen(labepno,sBuffer,0,allorderids,allorders,alltestids,epid,"");
}

function ClickHandler(e) {
	var src=websys_getSrcElement(e);
	var table=document.getElementById("tEPVisitSpecimen_LabSpecimenCollection")
	if (src.tagName=="IMG") src=websys_getParentElement(src);
	if (src.id.substring(0,7)=="Deletez")	{
		var arry=src.id.split("z");
		rowsel=arry[arry.length-1];
		var obj1=document.getElementById("Deletez"+rowsel);
		var obj2=document.getElementById("SpecsBuffer");
		var obj3=document.getElementById("LabEpisodeNo");
		var obj4=document.getElementById("type");
		var obj5=document.getElementById("PatientID");
		var obj6=document.getElementById("loc");
		var obj7=document.getElementById("EpisodeID");
	        var obj8=document.getElementById("orderidsz"+rowsel);
		// Check to see if the order has other copies if not then cannot delete it
		var found=false
		// if there is a 'LabEpisodeNo' it's Labtrak - so allow deletion
		// if not - check there is at least ONE specimen left for this order ID.

		if (obj3.value=="") {
			var arrdeletespecs = obj8.value.split(",");
			for (var delspecix = 0; delspecix < arrdeletespecs.length; delspecix++) {
				var found = false;
				for (var i=1; i<=table.rows.length; i++) {
			        var obj9=document.getElementById("orderidsz"+i);
					if (obj9 && (i!=rowsel)) {
						var arrcheckspec = obj9.value.split(",");
						for (var checkspecix = 0; checkspecix < arrcheckspec.length; checkspecix++) {
							//alert("row " + i + " checking deleting order number " + delspecix + " ("+arrdeletespecs[delspecix] +") against number "+ checkspecix +" ("+ arrcheckspec[checkspecix]+")");
							if (arrdeletespecs[delspecix] == arrcheckspec[checkspecix]) {
								found = true;
							}
						}
					}
				}
				if (!found) {
					alert(t["LastSpecimenForOrder"]);
					return false;
				}
			}
		} else {
			found=true
		}
		if (found) {
			if ((obj2)&&(obj3)&&(obj4)&&(obj5)&&(obj6)&&(obj7)) {
				obj1.href=obj1.href+"&SpecsBuffer="+obj2.value+"&LabEpisodeID="+obj3.value+"&loc="+obj6.value+"&type="+obj4.value+"&PatientID="+obj5.value+"&PatientBanner=1&ID="+obj7.value;
				//alert(obj1.href);
				return true;
				//return false;
			}
		} else {
			alert(t["LastSpecimenForOrder"])
			return false
		}
	}
	if (src.id.substring(0,9)=="Specimenz") {
		var arry=src.id.split("z");
		rowsel=arry[arry.length-1];
		var sBuffer="";
		var labepno="";
		var allorderids="";
		var alltestids="";
		var allorders="";
		var epid="";
		var Received=document.getElementById("PreviouslyReceivedz"+rowsel)
		if ((Received)&&(Received.value=="YD")) {
			alert(t['SpecimenReceived']);
			return false;
		}
		var SpecsBuffer=document.getElementById("SpecsBuffer");
		if (SpecsBuffer) {
			sBuffer=SpecsBuffer.value;
		}
		// try to get the lab episode from the row, else from the hidden field
		var labepisodeno = "";
		labepisodeno = document.getElementById("LabEpisNoHiddenz"+rowsel);
		if ((labepisodeno)&&(labepisodeno.value!="")) {
			//
		} else {
			labepisodeno = document.getElementById("LabEpisodeNo");
		}
		if (labepisodeno) {
				labepno=labepisodeno.value;
		}
		var episodeid=document.getElementById("EpisodeID");
		if (episodeid) {
			epid=episodeid.value;
		}
		var orders=document.getElementById("orderids");
		if (orders) {
			orderids=orders.value;
		}
		var orderids=document.getElementById("allorderids");
		if (orderids) {
			allorderids=orderids.value;
		}
		var testids=document.getElementById("alltestids");
		if (testids) {
			alltestids=testids.value;
		}
		var orders=document.getElementById("allorders");
		if (orders) {
			allorders=orders.value;
		}
		var SpecSite = "";
		var site=document.getElementById("specsitesz"+rowsel);
		if (site) {
			SpecSite=site.value;
		}
		SpecimenDetailsOpen(labepno,sBuffer,rowsel,allorderids,allorders,alltestids,epid,SpecSite);
		return false;
	}
}

// Log 27900 - AI - 25-10-2002 : Created function to accept each character and evaluate accordingly.
function BarcodeKeyPressHandler(key) {
	// char 13 = carriage return
	if (websys_getKey(key)==13) {
		GetLabEpisodeNumberFromBarcode();
		ResetString();
	}
	else {
		chstring=chstring+String.fromCharCode(websys_getKey(key));
	}
}
// end Log 27900

// Log 27900 - AI - 25-10-2002 : Created function to reset the character string.
function ResetString() {
	chstring="";
}
// end Log 27900

// Log 27900 - AI - 17-10-2002 : Added function to get the Lab Episode Number from the scanned-in Barcode.
function GetLabEpisodeNumberFromBarcode() {
	var bcode="";
	var barcode=document.getElementById("Barcode");
	if (chstring!="") {
		bcode=chstring+"|";
	}
	// we want the 2nd piece, delimited by "REQID=". Counting starts at 0.
	if (bcode!="") {
		var labepnostr=Cache_mPiece(bcode,"REQID=",2);
		// then we want the 1st piece, delimited by "|". Counting starts at 0.
		if (labepnostr!="") {
			var labepno=Cache_mPiece(labepnostr,"|",1);
			if (labepno!="") {
				barcode.value=labepno;
			}
		}
	}
}
// end Log 27900.

function Cache_mPiece(s1,sep,n) {
	n = n - 1;
	//Split the array with the passed delimeter
	delimArray = s1.split(sep);
	//If out of range, return a blank string
	if ((n <= delimArray.length-1) && (n >= 0)) {
		return delimArray[n];
	} else {
		return "";
	}
}

function SpecimenDetailsOpen(labepisodeno,SpecBuffer,Position,allorderids,allorders,alltestids,epid,SpecSite) {
	//var url="epvisitspecimen.labspecimendetails.csp?labepisodeno="+labepisodeno+"&specimenbuffer="+SpecBuffer+"&position="+Position+"&PatientBanner=1"+"&allorderids="+allorderids+"&allorders="+allorders+"&alltestids="+alltestids+"&module=C&episodeid="+epid;
	//var url="epvisitspecimen.labspecimendetails.csp?labepisodeno="+escape(labepisodeno)+"&position="+escape(Position)+"&PatientBanner=1"+"&module=C&episodeid="+escape(epid)+"&allorderids="+escape(allorderids)+"&allorders="+escape(allorders)+"&alltestids="+escape(alltestids);
 	var buffer = "";
	if (Position!=0) {
 		buffer=Cache_mPiece(SpecBuffer,"^",Position);
	}
	var ID = Cache_mPiece(Cache_mPiece(buffer,String.fromCharCode(28),1),String.fromCharCode(1),1);
 	var specimen = Cache_mPiece(Cache_mPiece(buffer,String.fromCharCode(28),1),String.fromCharCode(1),2);
	var orderid = Cache_mPiece(buffer,String.fromCharCode(28),2);
	var container = Cache_mPiece(Cache_mPiece(buffer,String.fromCharCode(28),3),String.fromCharCode(1),2);
 	var containerno = Cache_mPiece(buffer,String.fromCharCode(28),4);
	var volumecol = Cache_mPiece(buffer,String.fromCharCode(28),5);
	var volumecur = Cache_mPiece(buffer,String.fromCharCode(28),6);
	if (Cache_mPiece(buffer,String.fromCharCode(28),19)!="") {
		var orderids=Cache_mPiece(buffer,String.fromCharCode(28),19);
		var oeidsaved="N";
	}
	if ((Cache_mPiece(buffer,String.fromCharCode(28),19)=="")||(Cache_mPiece(buffer,String.fromCharCode(28),10)!="")) {
		var orderids=Cache_mPiece(buffer,String.fromCharCode(28),10);
		var oeidsaved="Y";
	}

	var url="epvisitspecimen.labspecimendetails.csp?SpecSite="+escape(SpecSite)+"&volumecol="+volumecol+"&volumecur="+volumecur+"&orderids="+orderids+"&oeidsaved="+oeidsaved+"&container="+escape(container)+"&containerno="+containerno+"&ID="+escape(ID)+"&specimen="+escape(specimen)+"&orderid="+escape(orderid)+"&labepisodeno="+escape(labepisodeno)+"&position="+escape(Position)+"&PatientBanner=1"+"&module=C&episodeid="+escape(epid)+"&allorderids="+escape(allorderids)+"&allorders="+escape(allorders)+"&alltestids="+escape(alltestids);
	//alert("url="+url);
	websys_lu(url,false);
}

// Log 43788 - AI - 04-08-2004 : Set up OnChange event for the Result Available Date.
function ResultAvailableDateBlurHandler() {
	// invalidflg : 0 if not invalid; 1 if invalid

	var objResAvailDate=document.getElementById("ResultAvailableDate");
	if (!objResAvailDate) return true;

	var invalidflg="";
	invalidflg=IsValidResAvailDate();

	if (invalidflg==1) {
		alert(t['InvalidResAvailDate']);
	}

	if (invalidflg!=0) {
		objResAvailDate.className="clsInvalid";
		websys_setfocus('ResultAvailableDate');
		return false;
	}

	objResAvailDate.className="";
	return true;
}

function IsValidResAvailDate() {
	// invalidflg : 0 if not invalid; 1 if invalid
	var objDate="";
	var ResAvailDateHval="";
	var DateHval="";
	var invalidflg=0;
	var yeardate="";
	var objResAvailDate=document.getElementById("ResultAvailableDate");
	if ((objResAvailDate)&&(objResAvailDate.value!="")) {
		// convert value to a date
		objDate=document.getElementById("Date");
		if ((objDate)&&(objDate.value!="")) {
			ResAvailDateHval=DateStringTo$H(objResAvailDate.value);
			DateHval=DateStringTo$H(objDate.value);
			// check that it is greater than or equal to Execution/Collection Date.
			if (ResAvailDateHval<DateHval) {
				invalidflg=1;
			}
			// check that it is less than or equal to (Execution/Collection Date + 365)
			yeardate=DateHval+365;
			if (ResAvailDateHval>yeardate) {
				invalidflg=1;
			}
		}
	}
	return invalidflg;
}

// Log 43788 - AI - 04-08-2004 : Each time the Date or Time is changed, update the ResultAvailableDate via csp.
function DateBlurHandler() {
	var dateval="";
	var timeval="";
	var objtoday=document.getElementById("today");
	var objnow=document.getElementById("now");

	var objDate=document.getElementById("Date");
	if (objDate) dateval=objDate.value;
	if (!objDate) dateval=objtoday.value;
	var objTime=document.getElementById("Time");
	if (objTime) timeval=objTime.value;
	if (!objDate) dateval=objnow.value;

	var objOrderList=document.getElementById("allorderids");

	var lnk="epvisitspecimen.labspecimencollection.csp?date="+dateval+"&time="+timeval+"&orderlist="+objOrderList.value+"&WinName="+window.name;
	websys_createWindow(lnk,"TRAK_hidden");
}
// end Log 43788

function BodyLoadHandler() {
	document.onclick=ClickHandler;

	var obj=document.getElementById("Add");
	if (obj) obj.onclick = AddClickHandler;

	var obj=document.getElementById("Update");
	if (obj) obj.onclick = UpdateClickHandler;

	// Log 27900 - AI - 17-10-2002 : Set up an OnKeyPress event for the Barcode field.
	var obj=document.getElementById("Barcode");
	if (obj) obj.onkeypress = BarcodeKeyPressHandler;

	// Log 43788 - AI - 04-08-2004 : Set up OnBlur event for the Result Available Date.
	var obj=document.getElementById("ResultAvailableDate");
	if (obj) obj.onblur = ResultAvailableDateBlurHandler;

	// Log 43788 - AI - 04-08-2004 : Set up one OnBlur event for both of the Execution/Collection Date and Time fields.
	var obj=document.getElementById("Date");
	if (obj) obj.onblur = DateBlurHandler;

	var obj=document.getElementById("Time");
	if (obj) obj.onblur = DateBlurHandler;
	// end Log 43788.

	var sBuffer="";
	var SpecBuffer=document.getElementById("SpecBufferz1");
	for (var i=1; SpecBuffer; i++) {
		SpecBuffer=document.getElementById("SpecBufferz"+i);
		if (SpecBuffer) {
			if (sBuffer=="") {
				sBuffer=SpecBuffer.value;
			} else {
				sBuffer=sBuffer+"^"+SpecBuffer.value;
			}
			// we need to retick and disable all previously received specimens them for when the user enters an incorrect password and the screen refreshes
			// this is because we have no way of determining the difference between unticked and disabled and ticked
			var PrevReceived=document.getElementById("PreviouslyReceivedz"+i);
			if (PrevReceived.value=="YD") {
				var Received=document.getElementById("Receivedz"+i);
				if (Received) {
					Received.checked=true
					Received.disabled=true
				}
			}
		}
	}
	var SpecsBuffer=document.getElementById("SpecsBuffer");
	SpecsBuffer.value=sBuffer;

//alert(sBuffer);

	sBuffer="";
	var OrderBuffer=document.getElementById("OrderListz1");
	for (var i=1; OrderBuffer; i++) {
		OrderBuffer=document.getElementById("OrderListz"+i);
		if (OrderBuffer) {
			if (sBuffer=="") {
				sBuffer=OrderBuffer.value;
			} else {
				sBuffer=sBuffer+"^"+OrderBuffer.value;
			}
		}
	}
	var OrdersBuffer=document.getElementById("allorders");
	OrdersBuffer.value=sBuffer;

	sBuffer="";
	var OrderIDBuffer=document.getElementById("orderidsz1");
	for (var i=1; OrderIDBuffer; i++) {
		OrderIDBuffer=document.getElementById("orderidsz"+i);
		if (OrderIDBuffer) {
			var sOrderID=OrderIDBuffer.value;
			var arrOrderID=sOrderID.split(",");
			sOrderID=arrOrderID.join("^");
			if (sBuffer=="") {
				sBuffer=sOrderID;
			} else {
				sBuffer=sBuffer+"^"+sOrderID;
			}
		}
	}

	var OrderIDsBuffer=document.getElementById("allorderids");
	OrderIDsBuffer.value=sBuffer;

	sBuffer="";
	var OrderIDBuffer=document.getElementById("TestSetCodesz1");
	for (var i=1; OrderIDBuffer; i++) {
		OrderIDBuffer=document.getElementById("TestSetCodesz"+i);
		if (OrderIDBuffer) {
			var sOrderID=OrderIDBuffer.value;
			var arrOrderID=sOrderID.split(",");
			sOrderID=arrOrderID.join("^");
			if (sBuffer=="") {
				sBuffer=sOrderID;
			} else {
				sBuffer=sBuffer+"^"+sOrderID;
			}
		}
	}
	//alert("sbuffer "+sBuffer);
	var OrderIDsBuffer=document.getElementById("alltestids");
	OrderIDsBuffer.value=sBuffer;

	//Error handling for the loading of the specimens screen
	var errormsg=document.getElementById("errormsgz1");
	for (var i=1; errormsg; i++) {
		errormsg=document.getElementById("errormsgz"+i);
		if (errormsg) {
			if (errormsg.value!="") {
				alert(t[errormsg.value]);
			}
		}
	}
}

function BodyUnloadHandler() {
	var objParentWindow=window.opener;

	if ((flag==1)&&(objParentWindow)) {
		//objParentWindow.location.reload();
		objParentWindow.treload('websys.csp');
	}
}

//document.body.onunload=BodyUnloadHandler;
document.body.onload = BodyLoadHandler;