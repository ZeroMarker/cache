function DocumentLoadHandler() {
	var addobj=document.getElementById("AddOrder");
	if(addobj) addobj.onclick=AddOrderClickHandler;

	// log 59876 YC - Different style for prev consult rows (default is italic rows)
	var tbl=document.getElementById("tepr_SOAPPlanning");
	for (var i=1;i<tbl.rows.length;i++) {
		var objPrevCons=document.getElementById("isPrevConsz"+i)
		if (objPrevCons) {
			if (objPrevCons.value==1 && objPrevCons.parentElement) {
				if (objPrevCons.parentElement.parentElement && objPrevCons.parentElement.parentElement.tagName=="TR") {
					if(objPrevCons.parentElement.parentElement.className=="RowEven")
						objPrevCons.parentElement.parentElement.className="PreviousConsultRowEven";
					if(objPrevCons.parentElement.parentElement.className=="RowOdd")
						objPrevCons.parentElement.parentElement.className="PreviousConsultRowOdd";
				}
			}
		}
	}

	// Log 59694 - BC - 11-07-2006: add three HTML files.
	var HTML1=document.getElementById("HTML1");
	var HTML2=document.getElementById("HTML2");
	var HTML3=document.getElementById("HTML3");
	var HTMLFile1=document.getElementById("HTMLFile1");
	var HTMLFile2=document.getElementById("HTMLFile2");
	var HTMLFile3=document.getElementById("HTMLFile3");

	if ((HTML1)&&(HTMLFile1)) {
		if (HTML1.value=="") {
			HTMLFile1.disabled=true;
			HTMLFile1.onclick=NoLink;
		} else {
			HTMLFile1.onclick=OpenWindow1;
		}
	}
	if ((HTML2)&&(HTMLFile2)) {
		if (HTML2.value=="") {
			HTMLFile2.disabled=true;
			HTMLFile2.onclick=NoLink;
		} else {
			HTMLFile2.onclick=OpenWindow2;
		}
	}
	if ((HTML3)&&(HTMLFile3)) {
		if (HTML3.value=="") {
			HTMLFile3.disabled=true;
			HTMLFile3.onclick=NoLink;
		} else {
			HTMLFile3.onclick=OpenWindow3;
		}
	}
	// end Log 59694

	var epId=document.getElementById("EpisodeID");
	var conEpId=document.getElementById("ConsultEpisodeID");
	if(epId && conEpId && conEpId.value!="" && conEpId.value!=epId.value){
		if(addobj){
			addobj.disabled=true;
			addobj.onclick=LinkDisable;
		}
	}
}

function AddOrderClickHandler() {
	var objAssess=document.getElementById("AssessFavourites");
	var objTreat=document.getElementById("TreatFavourites");
	var objEpis=document.getElementById("EpisodeID");
	var objConsult=document.getElementById("ConsultID");
	var ordlist="";

	if(objAssess) {
		for(i=0;i<objAssess.length;i++) {
			if (objAssess[i].selected) {
				if (ordlist!="") ordlist = ordlist + "*";
				ordlist = ordlist + objAssess[i].value;
			}
		}
	}

	if(objTreat) {
		for(i=0;i<objTreat.length;i++) {
			if (objTreat[i].selected) {
				if (ordlist!="") ordlist = ordlist + "*";
				ordlist = ordlist + objTreat[i].value;
			}
		}
	}

	var WorkFlowObj=document.getElementById("WorkFlowID");
	var PatIDObj=document.getElementById("PatientID");
	var mradmObj=document.getElementById("mradm");

	// log 59876 YC - Add selected rows to ordlist
	var tbl=document.getElementById("tepr_SOAPPlanning");
	for (var i=1;i<tbl.rows.length;i++) {
		var objSel=document.getElementById("Selectz"+i)
		if (objSel && objSel.checked) {
			var arcimobj=document.getElementById("OEItemMstIDz"+i);
			if (arcimobj) {
				if (arcimobj.value!="") {
					if (ordlist!="") ordlist = ordlist + "*";
					ordlist = ordlist + arcimobj.value;
				}
			}
		}
	}

	var url="";
	// Log 59742 YC - Allow orders screen to open even if there are no selected orders
	if(objEpis && objConsult) { //&& ordlist!="") {
		if(objEpis.value!="" && objConsult!="") {
			if(WorkFlowObj)
				if(WorkFlowObj.value!="")
					url = "websys.csp?TWKFL="+WorkFlowObj.value+"&EpisodeID="+objEpis.value+"&PatientID="+PatIDObj.value+"&mradm="+mradmObj.value+"&ConsultID="+objConsult.value+"&SOAPordlist="+ordlist;
			if(url=="")
					url = "oeorder.entry.frames.csp?WEBSYS.TCOMPONENT=OEOrder.Custom&EpisodeID="+objEpis.value+"&PatientID="+PatIDObj.value+"&mradm="+mradmObj.value+"&ConsultID="+objConsult.value+"&SOAPordlist="+ordlist;

			//alert(url);
			var win=websys_createWindow(url,"","top=0,left=0");
			if(win) win.resizeTo(screen.availWidth,screen.availHeight);
		}
	}

	return false;
}

// Log 59694 - BC - 11-07-2006: Functions related to the 3 HTML Files (logic above).
function NoLink() {
	return false;
}

function OpenWindow1() {
	var HTML1=document.getElementById("HTML1");
	var HTMLFile1=document.getElementById("HTMLFile1");
	var www=/www/gi; var http=/http/gi; var htm=/htm/gi; var dir=/\\/gi;

	if ((HTML1)&&(HTML1.value!="")) {
		var url=HTML1.value;
		if ((url.search(http) == -1)&&(url.search(www) != -1)) url="http://"+url
		if ((url.search(www) ==-1)&&(url.search(htm) != -1)&&(url.search(dir) == -1)) url="..\\Help\\"+url
		websys_createWindow(url, 'HTMLFile1', 'top=50,left=100,width=600,height=550,scrollbars=yes,resizable=yes');
	}
	return false;
}

function OpenWindow2() {
	var HTML2=document.getElementById("HTML2");
	var HTMLFile2=document.getElementById("HTMLFile2");
	var www=/www/gi; var http=/http/gi; var htm=/htm/gi; var dir=/\\/gi;

	if ((HTML2)&&(HTML2.value!="")) {
		var url=HTML2.value;
		if ((url.search(http) == -1)&&(url.search(www) != -1)) url="http://"+url
		if ((url.search(www) ==-1)&&(url.search(htm) != -1)&&(url.search(dir) == -1)) url="..\\Help\\"+url
		websys_createWindow(url, 'HTMLFile2', 'top=50,left=100,width=600,height=550,scrollbars=yes,resizable=yes');
	}
	return false;
}

function OpenWindow3() {
	var HTML3=document.getElementById("HTML3");
	var HTMLFile3=document.getElementById("HTMLFile3");
	var www=/www/gi; var http=/http/gi; var htm=/htm/gi; var dir=/\\/gi;

	if ((HTML3)&&(HTML3.value!="")) {
		var url=HTML3.value;
		if ((url.search(http) == -1)&&(url.search(www) != -1)) url="http://"+url
		if ((url.search(www) ==-1)&&(url.search(htm) != -1)&&(url.search(dir) == -1)) url="..\\Help\\"+url
		websys_createWindow(url, 'HTMLFile3', 'top=50,left=100,width=600,height=550,scrollbars=yes,resizable=yes');
	}
	return false;
}
// end Log 59694

document.body.onload = DocumentLoadHandler;
