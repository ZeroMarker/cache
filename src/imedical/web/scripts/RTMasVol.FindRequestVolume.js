// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//alert(document.getElementById("UserCode").value);
function CheckGroupSecurity(){
	var Allow="";
	var AllowObj=document.getElementById("AllowToCreateMRTypeConfig");
	if (AllowObj) Allow=AllowObj.value;
	if (Allow=="N") {
		var nObj=document.getElementById("New1");
		if (nObj) {
			nObj.disabled=true;
			nObj.onclick="";
		}
	}

}

function RTMasVolFindRequestVolume_SelectOnlyRow(e) {
	//var tbl=document.getElementById("tRTMasVol_FindRequestVolume");
	//var FirstRowAddVolCheck=document.getElementById("AddVolz1");
	//var SecondRowAddVolCheck=document.getElementById("AddVolz2");
	////if ((FirstRowAddVolCheck)&&(!SecondRowAddVolCheck)) FirstRowAddVolCheck.checked=true;
	//var def="";
	//var vobj=document.getElementById("ReqIds");
	//if (vobj) def=vobj.value;
	//if (def!="") {
	//	if (vobj.value!="") SelectVolumes(vobj.value);
	//}
	//else {
	//	if (FirstRowAddVolCheck) FirstRowAddVolCheck.checked=true;
	//}
	var def="";
	var vobj=document.getElementById("ReqIds");
	if ((vobj)&&(vobj.value!="")) def=vobj.value;
	var SPRobj=document.getElementById("SinglePatReqIds");
	if ((SPRobj)&&(SPRobj.value!="")) def=SPRobj.value;
	//alert(def);
	if (def!="") {
		SelectVolumes(def);
	} else {
		//alert("Here Diff");
		//ANA 29-APR-02 for demo. selects records if current location is same as logon location.
		var locFlag=true;
		var length=1;
		var locDesc="";
		var locObj=document.getElementById("logLoc");
		if (locObj) locDesc=locObj.value;
		//alert("locDesc" + locDesc);
		/*
		var tbl=document.getElementById("tRTMasVol_FindRequestVolume");
		if (tbl) {
			for(var i=length;i<tbl.rows.length;i++) {
				var volObj=document.getElementById("RTMAVCurLocDescz"+i);
				var sobj=document.getElementById("AddVolz"+i);
				if ((volObj) && (volObj.innerText==locDesc) && (sobj)) {
					sobj.checked=true;
					locFlag=false;
					//break;
				}
			}
			if (locFlag) {
				var slobj=document.getElementById("AddVolz"+1);
				if (slobj) slobj.checked=true;
				//break;
			}
		}
		*/
		var tbl=document.getElementById("tRTMasVol_FindRequestVolume");
	if (tbl) {
			for(var i=1;i<tbl.rows.length;i++) {
				var currType="";
				var maxVolume=0;
				CTObj=document.getElementById("hidRTMAVTYPDescz"+i);
				if((CTObj)&&(CTObj.value!="")) currType=CTObj.value;
				//alert(currType+","+maxVolume);

				for(var j=1;j<tbl.rows.length;j++) {
					var currMRType=""
					var currVolume=0;

					var CMRobj=document.getElementById("hidRTMAVTYPDescz"+j);
					if((CMRobj)&&(CMRobj.value!="")) currMRType=CMRobj.value;

					var CVObj=document.getElementById("HidMasVolCreDatTimz"+j);
					if((CVObj)&&(CVObj.value!=""))	currVolume=parseInt(CVObj.value);
					//alert(currMRType+","+currType+","+currVolume+","+maxVolume);

					if((currMRType==currType)&&(currVolume>maxVolume)) maxVolume=currVolume;
				}

				for(var k=1;k<tbl.rows.length;k++) {
					var slobj=document.getElementById("AddVolz"+k);
					var CMRobj=document.getElementById("hidRTMAVTYPDescz"+k);
					var CVObj=document.getElementById("HidMasVolCreDatTimz"+k);
					var HospMRObj=document.getElementById("MainHospMRType");
					if((CMRobj)&&(CMRobj.value==currType)&&(CVObj)&&(parseInt(CVObj.value)==maxVolume)&&(slobj)) {
						if((CMRobj.value==HospMRObj.value)||(!HospMRObj.value)) {
							slobj.checked=true;
						}
					}
				}

			}

		}

	}
}



function RecipHospClickHandler() {
	var RecObj=document.getElementById("ReciprocalHosp");
	if ((RecObj)&&(RecObj.href!="")) {
		var twkfli="";
		var arr=RecObj.href.split("?");
		var twObj=document.getElementById("TWKFLI");
		if (twObj) twkfli=twObj.value-1;
		RecObj.href=arr[0]+"?TWKFLI="+twkfli+"&"+arr[1];
		window.location=RecObj.href;
	}
	return false;
}

/* Commented out for log 30207 - this function has been replaced by 'PrintSelectedRowsHandler'
function PrintBarcodeLabelHandler(lnk,newwin) {
	var found=0;
	var eSrc=websys_getSrcElement();
	var tbl=getTableName(eSrc);
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"AddVolz");
	var MasVolIDs="";
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		for (i in aryfound) {
			var row=aryfound[i];
			if (!f.elements["IDz"+row]) continue;
			if (f.elements["IDz"+row].value!="") {
				MasVolIDs=MasVolIDs+f.elements["IDz"+row].value+",";

			}
		}
		lnk=lnk+"&rtmav="+MasVolIDs;
		if (newwin=="TRAK_hidden") {
			//alert(lnk);
			websys_createWindow(lnk,"TRAK_hidden");
		} else {
			websys_lu(lnk,false,"width="+screen.availWidth+",height="+screen.availHeight);
		}
	}
	//alert(MasVolIDs);
}
*/

//log 30207 - added PrintSelectedRowsHandler
//Log 31568 - Modified PrintSelectedRowsHandler
function PrintSelectedRowsHandler(tblname,lnk,newwin) {
	var found=0;
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"AddVolz");
	//Log 19666 - HitCount var required to force Crystal Web Server to rerun query - see KnowledgeBase Article c2002771
	var HitCount=Math.round(Math.random() * 1000)
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		if (newwin=="TRAK_hidden") {
			var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
				document.writeln('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="rtmav">');
				// for each row selected
				for (i in aryfound) {
					var row=aryfound[i];
					//alert(row);
					// check for specific values - these values must be hidden in the component
					if (!f.elements["IDz"+row]) continue;
					if (f.elements["IDz"+row].value!="") {
						document.writeln('<INPUT NAME="rtmav" VALUE="' + f.elements["IDz"+row].value + '">');
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
				if (!f.elements["IDz"+row]) continue;
				if (f.elements["IDz"+row].value!="") {
					// when the report is crystal and will be previewed pass these parameters so they can
					// be converted to prompt(n) variables.
					PassReportParametersForPreview(lnk,newwin,f.elements["IDz"+row].value);
				}
			}
		}
	}
}


function SelectRow(e) {
	var eSrc=websys_getSrcElement(e);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var arry=eSrc.id.split("z");
	rowsel=arry[arry.length-1];
	var vobj=document.getElementById("hidRTMAVVolDescz"+rowsel);
	//if ((eSrc.id=="RTMAVVolDescz"+rowsel)||(eSrc.id=="Movez"+rowsel)||(eSrc.id=="Receivedz"+rowsel)||(eSrc.id=="hidRTMAVVolDescz"+rowsel)) {
	if ((eSrc.id=="Movez"+rowsel)||(eSrc.id=="Receivedz"+rowsel)) {
		return checkVolume(vobj,eSrc);
	}
}

function checkVolume(vobj,lnkobj) {
		if ((vobj)&&(vobj.value=="")) {
			if (lnkobj.id=="Receivedz"+rowsel) alert(t['Rec_VolCheck']);
			if (lnkobj.id=="Movez"+rowsel) alert(t['Volume_Check']);
			//alert(t['Volume_Check']);
		} else {
			var url=lnkobj.href;
			//removes the workflow form the link
			var arrURL=url.split("&");
			for (var i=0; i<arrURL.length; i++) {
				if (arrURL[i].indexOf("TWKFL=")==0) arrURL[i]="TWKFL="
				if (arrURL[i].indexOf("TWKFLI=")==0) arrURL[i]="TWKFLI="
			}
			url=arrURL.join("&");
			//alert(url)
			// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
			websys_createWindow(url,"MOVE","height=250,width=500,left=250,top=200,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
		}
		return false;
}

function SelectVolumes(volids) {
	var tbl=document.getElementById("tRTMasVol_FindRequestVolume");

	var volArray=volids.split(",");
	//alert(volArray[0]);
	//alert(tbl);
	if (tbl) {
		for (var j=0; j<volArray.length; j++) {
			//alert(volArray[0]);
			for (var i=1; i<tbl.rows.length; i++)  {
				var vidobj=document.getElementById("IDz"+i);
				//alert(volObj.innerText);
				if (vidobj) {
					if (volArray[j]==vidobj.value) {
						//alert(volArray[j]+"^"+vidobj.value);
						var sobj=document.getElementById("AddVolz"+i);
						//alert(sobj.checked+"^"+i);
						if (sobj) sobj.checked=true;
					}
				}
			}

		}
	}
}

function RefreshAfterNewVolume(){
	window.treload("websys.reload.csp");
}

function refresh(e){
	window.location.reload(true);
}

function mPiece(s1,sep,n) {
	//Getting wanted piece, passing (string,separator,piece number)
	//First piece starts from 0
	//Split the array with the passed delimeter
	delimArray = s1.split(sep);
	//If out of range, return a blank string
	if ((n <= delimArray.length-1) && (n >= 0)) return delimArray[n];
}

function ReceiveHandler() {
	var CONTEXT=session['CONTEXT'];
	var PatientIDs="";
	var RTMasVolIDs="";
	var VolumeDescs="";

	var tbl=document.getElementById("tRTMasVol_FindRequestVolume");
	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			var sobj=document.getElementById("AddVolz"+i);
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
	if((PatientIDs!="")&&(RTMasVolIDs!="")&&(VolumeDescs!="")) websys_lu(url,false,"");
	return false;
}

//document.body.onload=BodyLoadHandler;
var ivobj=document.getElementById("InactiveVolumes");
var iobj=document.getElementById("HasInactive");
if ((iobj)&&(iobj.value=="Y")&&(ivobj)) ivobj.style.fontWeight="bold";
document.onclick=SelectRow;
var RecObj=document.getElementById("ReciprocalHosp");
try { RTMasVolFindRequestVolume_SelectOnlyRowCustom(); } catch(e) { RTMasVolFindRequestVolume_SelectOnlyRow(); }
CheckGroupSecurity();
if (RecObj) RecObj.onclick=RecipHospClickHandler;
RTMasVolFindRequestVolume_SelectOnlyRow();
