// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var tbl=document.getElementById("tRTVolume_List");

var hiddenTelNo=""

var defSelect=""

function SelectAll(evt) {
	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			var sobj=document.getElementById("Selectz"+i);
			var vobj=document.getElementById("RTMAVVolDescz"+i);
			if ((sobj) && (sobj.disabled==false) ) {
				if ((vobj)&&(vobj.innerText!="")) sobj.checked=true;
			}
		}
	}
	return false;
}

//if (parent.frames["FindMRRequestList"])	document.forms['fRTVolume_List'].target="_parent";
function UpdateHandler(evt) {
   //SB 1/7/05 (53617): Use timer to allow brokers to validate before update is triggered.
   if (evtTimer) {
	window.setTimeout("UpdateHandler()",websys_brokerTime+20);
   } else {
	var Rtnobj=document.getElementById("ReturnDate");
	if ((Rtnobj)&&(Rtnobj.value!="")) {
		if (DateStringCompareToday(Rtnobj.value)<0) {
			alert(t['INVALID_RTNDATE']);
			return false;
		}
	}

	//check that records with no requests requires the MRLocation field to be filled
	var obj=document.getElementById("MRLocation");
	var tbl=document.getElementById("tRTVolume_List");
	if (obj.className=="clsInvalid") {
		alert("Location: "+obj.value+" is invalid");
		return false;
	}
	var alertmsg="";
	if ((!obj) || ((obj)&&(obj.value==""))) {
		if (tbl) {
			for (i=1; i<tbl.rows.length; i++) {
				var obj=document.getElementById("Selectz"+i);
				if ((obj)&&(obj.checked)&&(document.getElementById("ReqVolIDz"+i).value=="")) {
						alert(t['RequiredLocation']);
						return false;
				}
			}
		}
	}
	var cobj=document.getElementById("CreateReqConfig");
	//alert(cobj.value);
	if (cobj) {
		if (cobj.value=="Y") {
			var check=CheckRequest(obj,tbl);
			if (!check) return false;
		} else {
			var alertmsg="";
			for (i=1; i<tbl.rows.length; i++) {
				var obj=document.getElementById("Selectz"+i);
				var loc=document.getElementById("CTLOCDescz"+i);
				var vol=document.getElementById("HidRTMAVVolDescz"+i);
				var typ=document.getElementById("HidTYPDescz"+i);
				var patient=t['PATVOL']+" "+vol.value+" "+t['RECTYPE']+" "+typ.value+"\n"
				var errors="";
				if ((obj)&&(obj.checked)) {
					// LOG 39624 RC 17/10/03 This was modified so that it would alert if the current location was the
					// same as the going to location.
					if (loc.innerHTML==document.getElementById("MRLocation").value) {
						errors=errors+t['SAMELOC']+"\n";
					}
				}
				if (errors!="") alertmsg=alertmsg+patient+errors+"\n"
			}
			if ((alertmsg!="")&&(!confirm(alertmsg+t['DoContinue']))) return false;
		}
	}
	return update1_click();
   }
}

function CheckRequest(obj,tbl) {
	var volids="";
	var check=false;
	var MRLocID="";
	var MRLocDesc="";
	var alertmsg="";
	var MRDate="";

	if (obj) {
		var mridobj=document.getElementById("MRLocationID");
		var mrdescobj=document.getElementById("MRLocation");
		if (mridobj) MRLocID=mridobj.value;
		if (mrdescobj) MRLocDesc=mrdescobj.value;
		for (i=1; i<tbl.rows.length; i++) {
			var obj=document.getElementById("Selectz"+i);
			var loc=document.getElementById("CTLOCDescz"+i);
			var vol=document.getElementById("HidRTMAVVolDescz"+i);
			var typ=document.getElementById("HidTYPDescz"+i);
			var patient=t['PATVOL']+" "+vol.text+" "+t['RECTYPE']+" "+typ.value+"\n"
			var errors="";
			if ((obj)&&(obj.checked)) {
				if (document.getElementById("ReqVolIDz"+i)) {
					// LOG 39624 RC 17/10/03 This was modified so that it would alert if the current location was the
					// same as the going to location.
					//if (loc.innerHTML==MRLocDesc) {
					//	errors=errors+t['SAMELOC']+"\n";
					//}
					// BM Log 34845
					// RC Modified for 39624
					if (MRLocDesc==document.getElementById("HomeLocDRz"+i).value&&document.getElementById("TempHomeLocDRz"+i).value!="") {
						//if (!confirm(t['TempHomeLocExists']+document.getElementById("RTMAVVolDescz"+i).innerText+" of type "+document.getElementById("TYPDescz"+i).innerText+" \r\n"+t['DoContinue'])) {
						//	return false;
						//}
						errors=errors+t['TempHomeLocExists']+"\n";
					}
					if ((document.getElementById("ReqVolIDz"+i).value!="") && (document.getElementById("RTMAVRequestDRz"+i).value==null) && (MRLocID!="")) {
						//log 31686
						//if (document.getElementById("RTREQReqLocDRz"+i).value!=MRLocID) {
							if (document.getElementById("HiddenCurLocCodez"+i)) var comp=document.getElementById("HiddenCurLocCodez"+i).value;
							if (comp && comp!=MRLocID) volids=volids+document.getElementById("RTMAVRowIdz"+i).value+",";
						//}
					}
					else {
						if (document.getElementById("ReqVolIDz"+i).value=="") {
							if (document.getElementById("RTMAVRequestDRz"+i).value==null) {
								if (document.getElementById("HiddenCurLocCodez"+i)) var temp=document.getElementById("HiddenCurLocCodez"+i).value;
								if (temp && temp!=MRLocID) volids=volids+document.getElementById("RTMAVRowIdz"+i).value+",";
							}
						}
					}
				}
			}
			if (errors!="") alertmsg=alertmsg+patient+errors+"\n"
		}
		if ((alertmsg!="")&&(!confirm(alertmsg+t['DoContinue']))) return false;
		var patid="";
		var reqid="";
		var ReqLoc="";
		var HospID="";
		var pobj=document.getElementById("PatientID");
		if (pobj) patid=pobj.value;
		var robj=document.getElementById("MRLocation");
		if (robj) ReqLoc=escape(robj.value);
		var hobj=document.getElementById("CurrHospID");
		if (hobj) HospID=hobj.value;
		var MRDobj=document.getElementById("ReturnDate");
		if (MRDobj) MRDate=MRDobj.value;

		var url="rtvolume.createrequest.csp?VolumeIDs="+volids+"&PatientID="+patid+"&ReqLoc="+ReqLoc+"&hiddenTelNo="+hiddenTelNo+"&CreateTransactions=Y"+"&Page=rtvolume.list.csp"+"&NewTransFlag=1"+"&CurrHospitalDR="+HospID+"&MRReturnDate="+MRDate;
		//alert(url);
		//alert(volids);
		if (top.frames[2]) {
			if (top.frames[2].name=="TRAK_hidden") {
				//alert(url);
				top.frames["TRAK_hidden"].location.href=url;
			}
		}
		if (top.frames[1]) {
			//alert(url);
			if (top.frames[1].name=="FindMRRequestList") {
				top.frames["FindMRRequestList"].location.href=url;
			}
		}
		check=true;
		//alert("updating from hidden");
	}
	return check;
}

function docLoaded() {
	if (document.getElementById("Bookedz1")) {
		var valToBecome="<IMG SRC='../images/websys/update.gif' id='Booked' title='' border=0>";
		//alert(document.getElementById("Bookedz1"));
		//changeColContent(tbl,'Booked','BookedHidden','Y',valToBecome);
	}
	var obj=document.getElementById("update1");
	if (obj) obj.onclick=UpdateHandler;


	//ANA 29-APR-02 for demo. selects records if current location is same as logon location.
	var length=1;
	var MRDesc="";
	var locFlag=true;
	var locObj=document.getElementById("logLoc");
	var MRType=document.getElementById("MRTYPDesc");
	if (MRType && MRType.value!="") MRDesc=MRType.value;

	if (locObj) locDesc=locObj.value;
	var tbl=document.getElementById("tRTVolume_List");
	if (tbl) {
		//Log 31262 10/12/02 PeterC
		/*
		for(var i=length;i<tbl.rows.length;i++) {
			var volObj=document.getElementById("CTLOCDescz"+i);
			var sobj=document.getElementById("Selectz"+i);
			if ((volObj) && (volObj.innerText==locDesc) && (sobj)) {
				sobj.checked=true;
				locFlag=false;
			}
		}

		if (locFlag) {
			var slobj=document.getElementById("Selectz"+1);
			if (slobj) slobj.checked=true;
		}
		*/
		var ticked="N";
		for(var i=length;i<tbl.rows.length;i++) {
			var MRObj=document.getElementById("TYPDescz"+i);
			var sobj=document.getElementById("Selectz"+i);
			var robj=document.getElementById("GetReqIDz"+i);
			var irobj=document.getElementById("IsReceivedz"+i);

			if((irobj)&&(irobj.value=="R")) disableReceived(i);
			if ((MRObj) && (MRObj.innerText==MRDesc) && (sobj) && (ticked=="N")&& (defSelect=="")) {
				sobj.checked=true;
				ticked="Y";
			}
			/*
			if ((robj) && (robj.value!="")){
					sobj.checked=true;
					continue;
			}
			*/
		}
		//SB 12/05/03 (34568): Need to pass patient id to menu when seaching for new patient
		var objID = document.getElementById("PatientID")
		if (objID) {
			var PatientID=objID.value;
			var winf = null;
			if (window.parent != window.self) winf = top
			if ((winf)&&(winf.frames['eprmenu'])) {winf.SetSingleField("PatientID",PatientID); }
		}
	}

	//var sobj=document.getElementById("Selectz"+1);
	//if (sobj) sobj.checked=true;
	//if (parent.frames[0]) {
	//	var obj=parent.frames[0].document.getElementById("UR");
	//	if (obj) obj.select();
	//}
	//document.onclick=VolumeCheck;

	//DL: log 31572: 23/12/02
	var obj=parent.frames[0].document.getElementById("UR");
	if (obj) {
		URsetfocus("UR");
	}
	if (tsc['update1']) {
		websys_sckeys[tsc['update1']]=UpdateHandler;
	}
	document.onclick=SelectRow1;

}

function disableReceived(str) {

	var robj=document.getElementById("Receivedz"+str);
	if(robj) {
 		robj.onclick=BlankClickHandler;
	}

}

function BlankClickHandler() {
	alert(t['VOLREC']);
	return false;
}

function SetFocusToUR(str) {
	//alert(str)
	var obj=""
	if (parent&&parent.frames[0]) obj=parent.frames[0].document.getElementById("UR");
	if (obj) obj.select();
	// Log:27870 PeterC 02/09/2002 Need to extract the telephone ext. number for various location.
	//alert("The Telephone No. is " +lu[1]);
	if (str) {
		var lu=str.split("^");
		hiddenTelNo=lu[8];
		var mrobj=document.getElementById("MRLocationID");
		if (mrobj) mrobj.value=lu[1];
	}
}



function HospitalInfo(str) {  // HOSP_Desc, HOSP_RowId, HOSP_Code *****  Log# 28782; AmiN ; 21/Nov/2002 add hospital field and restrict Going to Location*****
	var mrlocobj=document.getElementById("MRLocation");
	if (mrlocobj) mrlocobj.value="";
	var descobj=document.getElementById("HOSPDesc");
	var codeobj=document.getElementById("CurrHospID");  //CTLOC_Hospital_DR=:hospID
	var lu=str.split("^");

	if (descobj){
		descobj.value=lu[1];
		if (codeobj){ codeobj.value=lu[0]; }
	}else{
		//alert ("else");
		if (codeobj) { codeobj.value=""; }
	}

	//alert(lu[0]+"^"+lu[1]+"^"+lu[2]);
}

/*
// Commented out for log 30207 - this function has been replaced by 'PrintSelectedRowsHandler'
// reversal of commented out above ... because PrintSelectedRowsHandler is not correct for
// a Cache report.
function PrintBarcodeLabelHandler(tblname,lnk,newwin) {
	var found=0;
	//var eSrc=websys_getSrcElement();
	//var tbl=getTableName(eSrc);
	var tbl=document.getElementById(tblname);
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
	//HitCount var required to force Crystal Web Server to rerun query - see KnowledgeBase Article c2002771
	//Log 19666
	//var HitCount=Math.round(Math.random() * 1000)
	var MasVolIDs="";
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		for (i in aryfound) {
			var row=aryfound[i];
			if (!f.elements["RTMAVRowIdz"+row]) continue;
			if (f.elements["RTMAVRowIdz"+row].value!="") {
				MasVolIDs=MasVolIDs+f.elements["RTMAVRowIdz"+row].value+",";
				//lnk=arrParam[0] + "&EpisodeID="+EpisodeID + "&PatientID="+PatientID +"&prompt0=";

			}
		}
		lnk=lnk+"&rtmav="+MasVolIDs;
		if (newwin=="TRAK_hidden") {
			//alert(lnk);
			websys_createWindow(lnk,"TRAK_hidden");
		} else {
			//alert("2: "+lnk);
			websys_lu(lnk,false,"width="+screen.availWidth+",height="+screen.availHeight);
		}
	}

}


function PrintSelectedRowsHandler(lnk,newwin) {
	var found=0;
	var eSrc=websys_getSrcElement();
	var tbl=getTableName(eSrc);
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
	//HitCount var required to force Crystal Web Server to rerun query - see KnowledgeBase Article c2002771
	//Log 19666
	var HitCount=Math.round(Math.random() * 1000)
	var MasVolIDs=""
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		for (i in aryfound) {
			var row=aryfound[i];
			if (!f.elements["RTMAVRowIdz"+row]) continue;
			if (f.elements["RTMAVRowIdz"+row].value!="") {

				var arrParam=lnk.split("&prompt0=");
				lnk=arrParam[0];
				PassReportParameters(lnk,newwin,f.elements["RTMAVRowIdz"+row].value,HitCount);
			}
		}
	}
}
*/

// Commented out for log 30207 - this function has been replaced by 'PrintSelectedRowsHandler'
// Uncommented for log 30629 ... PrintSelectedRowsHandler does not work with Cache Reports
function PrintBarcodeLabelHandler(tblname,lnk,newwin) {
	var found=0;
	//var eSrc=websys_getSrcElement();
	//var tbl=getTableName(eSrc);
	//var tbl=document.getElementById(tblname);
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
	//HitCount var required to force Crystal Web Server to rerun query - see KnowledgeBase Article c2002771
	//Log 19666
	//var HitCount=Math.round(Math.random() * 1000)
	var MasVolIDs="";
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		for (i in aryfound) {
			var row=aryfound[i];
			if (!f.elements["RTMAVRowIdz"+row]) continue;
			if (f.elements["RTMAVRowIdz"+row].value!="") {
				MasVolIDs=MasVolIDs+f.elements["RTMAVRowIdz"+row].value+",";
				//lnk=arrParam[0] + "&EpisodeID="+EpisodeID + "&PatientID="+PatientID +"&prompt0=";

			}
		}
		lnk=lnk+"&rtmav="+MasVolIDs;
		if (newwin=="TRAK_hidden") {
			//alert(lnk);
			websys_createWindow(lnk,"TRAK_hidden");
		} else {
			//alert("2: "+lnk);
			websys_lu(lnk,false,"width="+screen.availWidth+",height="+screen.availHeight);
		}
	}
	//alert("Test Print");
	var obj=parent.frames[0].document.getElementById("UR");
	if (obj) {
		//alert("RESET");
		obj.select();
		obj.focus();
	}
}

function PrintSelectedRowsHandler(tblname,lnk,newwin) {
	var found=0;
	//var eSrc=websys_getSrcElement();
	//var tbl=getTableName(eSrc);
	//var tbl=document.getElementById(tblname);
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
	//HitCount var required to force Crystal Web Server to rerun query - see KnowledgeBase Article c2002771
	//Log 19666
	var HitCount=Math.round(Math.random() * 1000)
	var MasVolIDs=""
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		if (newwin=="TRAK_hidden") {
			var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
				document.writeln('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				//KK 8/7/03 Log 37210 - Passing PatientID also
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="PatientID,rtmav">');
				// for each row selected
				for (i in aryfound) {
					var row=aryfound[i];
					//alert(row);
					// check for specific values - these values must be hidden in the component
					if (!f.elements["RTMAVRowIdz"+row]) continue;
					if (f.elements["RTMAVRowIdz"+row].value!="") {
						document.writeln('<INPUT NAME="rtmav" VALUE="' + f.elements["RTMAVRowIdz"+row].value + '">');
						document.writeln('<INPUT NAME="PatientID" VALUE="' + f.elements["PatientID"].value + '">');
					}
				}
				/*
				document.writeln('</FORM><SCR'+'IPT>');
				document.writeln('window.HFORM.submit();');
				document.writeln('</SCR'+'IPT></BODY></HTML>');
				document.close();
				*/
				//Log 63760 PeterC 28/05/07
				document.writeln('</FORM></BODY></HTML>');
				document.close();
				document.HFORM.submit();
			}
		} else {
			// for each row selected
			for (i in aryfound) {
				var row=aryfound[i];
				// check for specific values - these values must be hidden in the component
				if (!f.elements["RTMAVRowIdz"+row]) continue;
				if (f.elements["RTMAVRowIdz"+row].value!="") {
					// when the report is crystal and will be previewed pass these parameters so they can
					// be converted to prompt(n) variables.
					PassReportParametersForPreview(lnk,newwin,f.elements["RTMAVRowIdz"+row].value,f.elements["PatientID"].value);
				}
			}
		}
	}
	//alert("Test Print");
	var obj=parent.frames[0].document.getElementById("UR");
	if (obj) {
		//alert("RESET");
		obj.select();
		obj.focus();
	}
}


function SelectRow1(e) {
	//alert("here0");
	var eSrc=websys_getSrcElement(e);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var arry=eSrc.id.split("z");
	//alert(arry);
	rowsel=arry[arry.length-1];
	//alert(rowsel);
	var vobj=document.getElementById("RTMAVVolDescz"+rowsel);
	var irobj=document.getElementById("IsReceivedz"+rowsel);
	//alert(eSrc.id);
	//if ((eSrc.id=="Receivedz"+rowsel)||(eSrc.id=="RTMAVVolDescz"+rowsel)) { return checkVolume(vobj,eSrc);}
	if ((eSrc.id=="Receivedz"+rowsel)&&(irobj.value!="R")) {return checkVolume(vobj,eSrc);}
	else if ((eSrc.id=="Selectz"+rowsel)) {
		VolumeCheck();
		SetFocusToUR();
	}
	//if ((eSrc.id!="MRLocation")&&(eSrc.id!="RequestID")) SetFocusToUR();
}

function checkVolume(vobj,lnkobj) {
		//var text=""; //vobj.innerText;
		//var pattern=new RegExp(text,"i");
		if ((vobj)&&(vobj.innerText=="CreateVolume")) {
			if (lnkobj.id=="Receivedz"+rowsel) alert(t['Rec_VolCheck']);
			if (lnkobj.id=="RTMAVVolDescz"+rowsel) alert(t['Volume_Check']);
		} else {
			var url=lnkobj.href;
			// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
			websys_createWindow(url,"MOVE","height=250,width=400,left=250,top=200,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
		}
		return false;
}
function VolumeCheck(e){
	//alert("Volumecheck");
	var src=websys_getSrcElement(e);
	var arry=src.id.split("z");
	rowsel=arry[arry.length-1];
	//alert(rowsel);
	var vobj=document.getElementById("RTMAVVolDescz"+rowsel);
	if ((vobj)&&(vobj.innerText=="")){
		var sobj=document.getElementById("Selectz"+rowsel);
		if ((sobj)&&(sobj.checked)) {
			alert(t['Volume_Check']);
			//alert("Volume is blank, please create volume before update.");
			sobj.checked=false;
		}
	}

}



//AmiN log 28782 Clear out hospital information erased as to not restrict Going to Location field.
function ClearField() {
	//alert("clearing");
	var HOSPDescObj=document.getElementById("HOSPDesc");
	var HospIDObj=document.getElementById("CurrHospID");
	//alert("hosp : "+HOSPDescObj.value);
	//HOSPDescObj.value="";
	//alert("obj: "+HOSPDescObj);
	if (HOSPDescObj) {
		//alert("obj and blank");

		if ((HospIDObj) && (HOSPDescObj.value=="")) HospIDObj.value="";
	} else {
		//alert("null obj");
		if (HospIDObj) HospIDObj.value="";
	}
	//alert("hidden: "+HospIDObj.value);

}


var HOSPDescObj=document.getElementById("HOSPDesc");
if (HOSPDescObj){
	//alert("obj exist");
	 HOSPDescObj.onblur=ClearField;
}
/*	Log 38559 PeterC cannot clear out the HospID when the page loads initially
else{
	//alert("In else");
	ClearField();
}
*/
// log 28782 end


function EnterKey(e) {
	//Log 31868
	var key = websys_getKey(e);
	var locobj=document.getElementById("MRLocation");
	if ((locobj)&&(key==13)) {
		locobj.blur();
		var upobj=document.getElementById("update1");
		if (upobj) upobj.focus();

		//return false;
	}
}

function refreshParent() {
	//var win=window.opener.parent.frames[1];
try{
if (window.parent.opener.parent.frames[1]){
	//alert("In here");
	var win=window.parent.opener.parent.frames[1];
	if (win) {
		var formRad=win.document.forms['fRTRequest_FindMRRequest'];
		if (formRad) {
			// ANA Using the URl looses workflow.
			win.treload('websys.csp');
		}
	} else if (window.opener) {
		//should be from epr chart csp page
		window.opener.history.go(0);
	}
}
}catch(e){}
}

function URsetfocus(objName) {
	setTimeout('URsetfocus2(\''+objName+'\')',200);
}
function URsetfocus2(objName) {
	var obj=parent.frames[0].document.getElementById(objName);
	if (obj) {
		try {
			obj.focus();
			obj.select();
		} catch(e) {}
	}
}

function ReceiveHandler() {
	var CONTEXT=session['CONTEXT'];
	var PatientIDs="";
	var RTMasVolIDs="";
	var VolumeDescs="";

	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			var sobj=document.getElementById("Selectz"+i);
			var IRObj=document.getElementById("IsReceivedz"+i);
			if ((sobj)&&(!sobj.disabled)&&(sobj.checked)&&(IRObj)&&(IRObj.value=="Y")) {

				var HVDObj=document.getElementById("hidRTMAVVolDescz"+i);
				var PIDObj=document.getElementById("RTMASPatNoDRz"+i);
				var VIDObj=document.getElementById("RTMAVRowIdz"+i);
				if((HVDObj)&&(HVDObj.value=="")) {
					alert(t['VOL_BLANK']);
					return false;
				}
				PatientIDs=PatientIDs+PIDObj.value+"^";
				RTMasVolIDs=RTMasVolIDs+VIDObj.value+"^";
				VolumeDescs=VolumeDescs+HVDObj.value+"^";
			}
		}
	}
	var url="websys.default.csp?WEBSYS.TCOMPONENT=RTMVTrans.Received&PARREF="+RTMasVolIDs+"&PatientIDs="+PatientIDs+"&VolumeDesc="+VolumeDescs+"&Receive=Y";
	url += "&CONTEXT="+CONTEXT;
	//alert(url);
	if((PatientIDs!="")&&(RTMasVolIDs!="")&&(VolumeDescs!="")) websys_lu(url,false,"");

	return false;
}

//log49730 TedT
function returnHandler(){
	if (tbl) {
		var home="";
		var ack="";
		var cnt=0;
		for (i=1; i<tbl.rows.length; i++) {
			var sobj=document.getElementById("Selectz"+i);
			if ((sobj)&&(!sobj.disabled)&&(sobj.checked)) {
				var IRObj=document.getElementById("IsReceivedz"+i);
				var type=document.getElementById("HidTYPDescz"+i);
				if(IRObj && IRObj.value!="R")
					ack+=type.value+"\n";
				home+=homeCheck(i);
				cnt++;
			}
		}
		if(cnt==0) {
			alert(t["NO_ITEM"]);
			return false;
		}
		
		if(home!="") {
			alert(t["HOME"]+"\n"+home);
			return false;
		}
		if(ack!="") {
			alert(t["NOT_ACK"]+"\n"+ack);
			return false;
		}
		return_click();
	}
}

//document.body.onunload=refreshParent;
document.body.onkeydown=EnterKey;
var obj=document.getElementById("SelectAll");
if (obj) obj.onclick=SelectAll;
document.body.onload=docLoaded;
//document.onclick=SelectRow;