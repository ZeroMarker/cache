// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

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
	SpecimenDetailsOpen(labepno,sBuffer,0,allorderids,allorders,alltestids,epid,"")
}

function SpecimenDetailsOpen(labepisodeno,SpecBuffer,Position,allorderids,allorders,alltestids,epid,SpecSite) {
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

	//var url="epvisitspecimen.labspecimendetails.csp?labepisodeno="+labepisodeno+"&specimenbuffer="+SpecBuffer+"&position="+Position+"&PatientBanner=1"+"&allorderids="+allorderids+"&allorders="+allorders+"&alltestids="+alltestids+"&module=C&episodeid="+epid;
	//alert("url="+url);
	websys_lu(url,false);
}

function ClickHandler(e) {
	var sBuffer="";

	var src=websys_getSrcElement(e);
	if (src.tagName=="IMG") src=websys_getParentElement(src);
	if (src.id.substring(0,7)=="Deletez")	{
		var arry=src.id.split("z");
		rowsel=arry[arry.length-1];
		var obj1=document.getElementById("Deletez"+rowsel);
		var obj2=document.getElementById("SpecsBuffer");
		//var obj4=document.getElementById("type");
		var obj5=document.getElementById("PatientID");
		var obj6=document.getElementById("LocID");
		var obj7=document.getElementById("EpisodeID");
		if ((obj2)&&(obj5)&&(obj6)&&(obj7)) {
			obj1.href=obj1.href+"&SpecsBuffer="+obj2.value+"&loc="+obj6.value+"&PatientID="+obj5.value+"&PatientBanner=1&ID="+obj7.value;
			//alert(obj1.href);
		return true;
		}
	}
	var src=websys_getSrcElement(e);
	if (src.id.substring(0,9)=="Specimenz") {
		var arry=src.id.split("z");
		var sBuffer="";
		var labepno="";
		var allorderids="";
		var alltestids="";
		var allorders="";
		var epid="";
		rowsel=arry[arry.length-1];
		var Received=document.getElementById("PreviouslyReceivedz"+rowsel)
		if ((Received)&&(Received.value=="YD")) {
			alert(t['SpecimenReceived']);
			return false;
		}
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
		var SpecSite = "";
		var site=document.getElementById("specsitez"+rowsel);
		if (site) {
			SpecSite=site.value;
		}
		SpecimenDetailsOpen(labepno,sBuffer,rowsel,allorderids,allorders,alltestids,epid,SpecSite);
		return false;
	}
}

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


function BodyLoadHandler() {

	SetMenuParameters();

	document.onclick=ClickHandler;

	var obj=document.getElementById("Add")
	if (obj) obj.onclick = AddClickHandler;

	var obj=document.getElementById('LabEpisNoz1');
	if (!obj) {
 	  LinksHandler();
	}
	var objCDate=document.getElementById('CollectionDate');
	var objCTime=document.getElementById('CollectionTime');
	var objAutoColl=document.getElementById('AutoCollect');
	if (((objCDate)&&(objCTime))&&((objCDate.value=="")&&(objCTime.value==""))) {
		if(objAutoColl) {
		  if (objAutoColl.value!="on")
				LinksHandler();
		}
		else
			LinksHandler();
	}

	var sBuffer="",oBuffer="",iBuffer="",tBuffer="";
	var specs,ords,ordids,tcids,rec;
	var DisableUpdate=1;
	
	// use one of the hidden fields for the "for" statement
	var ords=document.getElementById("orderidsz1");
	for (var i=1; ords; i++) {
		
		// specimens
		specs=document.getElementById("SpecBufferz"+i);
		if (specs) {
			if (sBuffer!="") sBuffer=sBuffer+"^";
			sBuffer=sBuffer+specs.value;
		}
		
		// orders
		ords=document.getElementById("HiddenOrderListz"+i);
		if (ords) {
			if (sBuffer!="") oBuffer=oBuffer+"^";
			oBuffer=oBuffer+ords.value;
		}

		// order ids
		ordids=document.getElementById("orderidsz"+i);
		if (ordids) {
			var orderids2=ordids.value.replace(",","^");
			if (iBuffer!="") iBuffer=iBuffer+"^";
			iBuffer=iBuffer+orderids2;
		}

		// test code ids
		tcids=document.getElementById("TestSetCodesz"+i);
		if (tcids) {
			var tcids2=tcids.value.replace(",","^");
			if (tBuffer!="") tBuffer=tBuffer+"^";
			tBuffer=tBuffer+tcids2;
		}
		
		// Log 64751 YC - disable update if we can't collect anything (no tickboxes are tickable)
		if (DisableUpdate==1) rec=document.getElementById("Receivedz"+i);
		if (rec) {
			if (rec.disabled==false) DisableUpdate=0;
		}
	}

	var obj=document.getElementById("SpecsBuffer");
	obj.value=sBuffer;
	var obj=document.getElementById("allorders");
	obj.value=oBuffer;
	var obj=document.getElementById("allorderids");
	obj.value=iBuffer;
	var obj=document.getElementById("alltestids");
	obj.value=tBuffer;
	// Log 64751 YC - disable update if we can't collect anything (no tickboxes are tickable)
	if (DisableUpdate==1) LinksHandler();

	var obj=document.getElementById('Update');
  if ((obj)&&(obj.disabled!=true)) {
		obj.onclick=ReceivedDateTimeChk;
	}
}

function LinkDisable(e) {
	var el = websys_getSrcElement(e);
	if (el.disabled) {
		return false;
	}
	return true;
}

function LinksHandler() {
	var obj=document.getElementById('CollectionDate');
	if (obj) {
		obj.readOnly=true;
		obj.className = "disabledField";
	}
	var obj=document.getElementById('CollectionTime');
	if (obj) {
		obj.readOnly=true;
		obj.className = "disabledField";
	}
	var obj=document.getElementById('ReceivedDate');
		if (obj) {
			obj.readOnly=true;
			obj.className = "disabledField";
		}
	var obj=document.getElementById('ReceivedTime');
	if (obj) {
		obj.readOnly=true;
		obj.className = "disabledField";
	}
	var obj=document.getElementById('Add');
	if (obj) {
		obj.disabled=true;
		obj.onclick=LinkDisable;
	}
	var obj=document.getElementById('Update');
	if (obj) {
		obj.disabled=true;
		obj.onclick=LinkDisable;
	}
	var obj=document.all.tags("IMG");
	if (obj) {
		for (i=0; i<obj.length;	i++)	{
			if (obj.src=="../images/websys/update.gif") {
			  obj.disabled=true;
			  obj.onclick=LinkDisable;
	    }
	  }
	 }
}
function ReceivedDateTimeChk() {
	var flag=1;
	var objRDate=document.getElementById('ReceivedDate');
	var objCDate=document.getElementById('CollectionDate');
	var objRTime=document.getElementById('ReceivedTime');
	var objCTime=document.getElementById('CollectionTime');
	if ((objRDate)&&(objRTime)&&(objCDate)&&(objCTime)) {
		var RDate=objRDate.value; 
		var CDate=objCDate.value; 
		var RTime=objRTime.value;
		var CTime=objCTime.value;
		if (DateStringCompare(CDate,RDate)==1) {
			alert(t['ReceivedDateInvalid']);
			flag=0;
		}
		if (((DateStringCompare(CDate,RDate))==0)&&(TimeStringCompare(CTime,RTime)==1)) {
			alert(t['ReceivedTimeInvalid']);
			flag=0;
		}
	}
	if (flag==1) Update_click();
}

function EPR_getTopWindow() {
	var winf = null;
	if (window.top != window.self) winf = window.top;
	return winf;
}

function SetMenuParameters() {
	var EpisodeID="";
	var PatientID="";
	var mradm="";

	var obj=document.getElementById("EpisodeID");
	if (obj) {EpisodeID=obj.value;}
	var obj=document.getElementById("PatientID");
	if (obj) {PatientID=obj.value;}
	var obj=document.getElementById("mradm");
	if (obj) {mradm=obj.value;}
	var winf=EPR_getTopWindow();
	if(winf) winf.SetEpisodeDetails(PatientID,EpisodeID,mradm)
}

document.body.onload = BodyLoadHandler;
// Log 32949 - AI - 13-02-2003 : Make sure the first field in the Tab Order has the focus.
websys_firstfocus();
// end Log 32949
