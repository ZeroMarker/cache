function DocumentLoadHandler(e) {
	//document.getElementById("tPATrafficAccident_List").onclick=deleteLinkHandler;
	var objTable=document.getElementById("tPATrafficAccident_List");
	var objTraffic=document.getElementById("trafficID");
	var eSrc;
	//alert(objTraffic.value);
	var newlink=document.getElementById("New1");
	if (newlink) newlink.onclick=NewClickHander;

	document.getElementById("tPATrafficAccident_List").onclick=TrafficAccidentClickHandler;

	if (objTable)
	{
		var numRows=objTable.rows.length;
		var currentRow;
		var currentIdObj,currentLink;

		for (i=1;i<numRows;i++)
		{
			currentRow=objTable.rows[i];
			currentIdObj=document.getElementById("TRFIDz"+i);
			currentLink=document.getElementById("TRFAccidentDatez"+i);
			if (currentIdObj&&objTraffic&&(currentIdObj.value==objTraffic.value))
			{
				//alert(currentIdObj.value);
				currentLink.click();
			}
		}

	} //Row Highlight
}

/* function TrafficAccidentClickHandler(e) {
	var EpiID=document.getElementById("EpisodeID")
	var PatID=document.getElementById("PatientID")
	var pay=document.getElementById("payCategory")
	var lastRow;
	//alert("pay"+pay.value)

	var eSrc = websys_getSrcElement(e);
	if (parent.frames["lower"]) {
		if (eSrc.tagName=="IMG") {
			eSrc=websys_getParentElement(eSrc)
		}
		if (eSrc.tagName=="A") {
			if (eSrc.id.indexOf("TRFAccidentDatez")==0) {
				eSrc.target = "lower";
				//alert(eSrc.href)
				var currentlink=eSrc.href.split("?");
				eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=PATrafficAccident.Edit&" + currentlink[1];

				eSrc=websys_getParentElement(eSrc);
				if (selectedRowObj!=eSrc) SelectRow();
			}
		
			if (eSrc.id.indexOf("delete1z")==0) {
				eSrc.target="_parent"
				var currentlink=eSrc.href.split("?");
				alert(currentlink)
				var url="patrafficaccidentframe.csp?"+currentlink[0]+"&payCategory=" + pay.value+"&EpisodeID=" + EpiID.value+"&PatientID=" + PatID.value;
				//var lnk=currentlink[0]+"&payCategory=" + pay.value+"&EpisodeID=" + EpiID.value+"&PatientID=" + PatID.value;
				//alert("lnk"+lnk)
				eSrc.href=url
			} 
		}
	}
} */

function TrafficAccidentClickHandler(e) {
	var EpiID="",PatID="",pay="",paycode="",TWKFLI="",TWKFL="";
	var EpiID=document.getElementById("EpisodeID")
	if (EpiID) EpiID=EpiID.value;
	var PatID=document.getElementById("PatientID")
	if (PatID) PatID=PatID.value;
	var pay=document.getElementById("payCategory")
	if (pay) pay=pay.value;
	var paycode=document.getElementById("InsurPayor")
	if (paycode) paycode=paycode.value;
	var TWKFL=document.getElementById("TWKFL")
	if (TWKFL) TWKFL=TWKFL.value;
	var TWKFLI=document.getElementById("TWKFLI")
	if (TWKFLI) TWKFLI=TWKFLI.value;

	var lastRow;
	
	var eSrc = websys_getSrcElement(e);
	if (parent.frames["lower"]) {
		if (eSrc.tagName=="IMG") {
			eSrc=websys_getParentElement(eSrc)
		}
		if (eSrc.tagName=="A") {
			
			if (eSrc.id.indexOf("TRFAccidentDatez")==0) {
				//alert("date")
				eSrc.target = "lower";
				var currentlink=eSrc.href.split("?");
				eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=PATrafficAccident.Edit&" + currentlink[1];
				if (paycode) eSrc.href+=+"&payCode=" + paycode.value;

				eSrc=websys_getParentElement(eSrc);
					if (selectedRowObj!=eSrc) SelectRow();
			}
			//
			if (eSrc.id.indexOf("delete1z")==0) {
				eSrc.target="_parent"
				if  (TWKFLI.value=="") { 
					var currentlink=eSrc.href.split("?"); 
					//var lnk="trafficaccidentframe.csp?"+currentlink[1]+"&payCategory=" + pay.value+"&EpisodeID=" + EpiID.value+"&PatientID=" + PatID.value;
					//var lnk=eSrc.href+"&payCategory=" + pay.value+"&EpisodeID=" + EpiID.value+"&PatientID=" + PatID.value;
					var lnk="patrafficaccidentframe.csp?payCategory="+pay+"&EpisodeID="+EpiID+"&PatientID="+PatID;
					alert("if: "+lnk)
				} else { 
					var currentlink=eSrc.href.split("&TWKFLI=");
					var twkfli=currentlink[1].split("&ID=")
					//var temp=twkfli[0]
					//twkfli[0]=temp-1
					//var lnk=currentlink[0]+"&TWKFLI="+twkfli[0]+"&ID="+twkfli[1]+"&payCategory=" + pay.value+"&EpisodeID=" + EpiID.value+"&PatientID=" + PatID.value;
					//alert(PatID);
					lnk=currentlink[0]+"&ID="+twkfli[1]+"&payCategory="+pay+"&EpisodeID="+EpiID+"&PatientID="+PatID+"&TWKFLI="+(TWKFLI-1);
					//alert("else: "+lnk)
				}
				//alert(lnk)
				eSrc.href=lnk
			}
		}
	}
}

function NewClickHander() {
	var eSrc = websys_getSrcElement(e);
	var currentlink=eSrc.href.split("?"); 
	if ((parent)&&(parent.frames)&&(parent.frames["lower"])) {
	
	var EpiID="",PatID="",pay="",paycode="",TWKFLI="",TWKFL="";
	var EpiID=document.getElementById("EpisodeID")
	if (EpiID) EpiID=EpiID.value;
	var PatID=document.getElementById("PatientID")
	if (PatID) PatID=PatID.value;
	var pay=document.getElementById("payCategory")
	if (pay) pay=pay.value;
	var paycode=document.getElementById("InsurPayor")
	if (paycode) paycode=paycode.value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=PATrafficAccident.Edit&" +"&payCategory="+pay+"&EpisodeID="+EpiID+"&PatientID="+PatID
	websys_createWindow(lnk,"lower",""); 

	return false;
	}
}

function clearFormHandler() {
	var obj=document.getElementById("trafficID")
	obj.value=""
	var obj=document.getElementById("ID")
	obj.value=""
	var el=document.forms["fPATrafficAccident_Edit"].elements;
	//var el=frm.elements
		for (var i=0;i<el.length;i++) {
		if ((el[i].type!="hidden")&&(!el[i].disabled)) {
			el[i].value=""					
		}	
	}	
	
	return false
}

document.body.onload = DocumentLoadHandler;

