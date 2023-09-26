// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

/*Procedure for allowing multiple profiles on the same page is to dynamically change the id of a
  profiles form, table menu and table list to be unique.  The unique id is obtained from
  adding the document.forms.length property on to the end of their existing names.*/

var df=document.forms;
var ltbl=document.getElementById("t"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
if (ltbl) {ltbl.id=ltbl.id+df.length,ltbl.Name=ltbl.id;ltbl.tCompName=df[df.length-1].id.substring(1,df[df.length-1].id.length);}
var mtbl=document.getElementById("m"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
if (mtbl) {mtbl.id=mtbl.id+df.length,mtbl.Name=mtbl.id;}
df[df.length-1].id=df[df.length-1].id+df.length;df[df.length-1].name=df[df.length-1].name+df.length;

//var objViewDicom=document.getElementById('ViewDicom');
//if (objViewDicom) objViewDicom.onclick=ViewDicom;

var frm=""
if (ltbl) frm=document.getElementById("f"+ltbl.id.substring(1,ltbl.id.length));

/*******
//KK 30/Sep/2002 Define click handlers for "Results" link
var tbl=document.getElementById(ltbl.id);
if ((frm)&&(tbl)) {
	for (var i=1;i<tbl.rows.length;i++) {
		var ObjRes=document.getElementById("ResultsLinkz"+i);
		if (ObjRes){
			//alert("Set Click handler");
			ObjRes.onclick=ResultsLinkHander;
		}
	}
}******/

function MRAdm_ListEMRResults_SelectRowHandler(evt) {
	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");
	if (eSrcAry[0]=="ResultsLink") {
		//ResultsLinkHander(evt);
		return false;
	}
	if (eSrcAry[0]=="PreviousResult") {
		PreviousResultLinkHander(evt);
		return false;
	}
	if (eSrcAry[0]=="Dicom") {
		ViewDicom(evt,eSrcAry[1]);
		return false;
	}
}

function PreviousResultLinkHander(e) {
	var eSrcAry=window.event.srcElement.id.split("z");
	if (eSrcAry.length>0) {
		var tbl=getTableName(window.event.srcElement);
		var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
		if (eSrcAry[0]=="PreviousResult") {
			var ChartID=f.elements["ChartID"].value;
			var ItemID=f.elements["ItemID"].value;
			var PatientID=f.elements["PatientID"].value;
			var Type=f.elements["Type"].value;
			var EpisodeID=f.elements["EpisodeIDz"+eSrcAry[1]].value;
			var OrderID=f.elements["OrderIDz"+eSrcAry[1]].value;
			var OtherRowID=f.elements["TRRowidz"+eSrcAry[1]].value;
			var ResType=f.elements["ResTypez"+eSrcAry[1]].value;
			var ResultID=f.elements["ResultIDz"+eSrcAry[1]].value;
			var DicomBuffer=f.elements["dicombufferz"+eSrcAry[1]].value;
			var typeAry=f.elements["ResTypez"+eSrcAry[1]].value.split("^");
			var HL7ResultType=f.elements["ARCICHL7ResultTypez"+eSrcAry[1]].value;
			var ResultType=typeAry[0];
			if (ResultType=="W") {
				var re = /\^/g;
				var ResType = ResType.replace(re,"~");
				var url="websys.default.csp?WEBSYS.TCOMPONENT=OEOrdItem.PreviousResult&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&OrderID="+OrderID+"&ChartID="+ChartID+"&ItemID="+ItemID+"&Type="+Type+"&ResultDetails="+ResultID+"*"+ResultType+"*"+ResType+"&ResultID="+ResultID+"&DicomBuffer="+DicomBuffer;
				websys_createWindow(url, 'LabTabularResults', 'top=50,left=100,width=250,height=300,scrollbars=yes,resizable=yes');
			}
			if (ResultType=="T" || (ResultType=="L" && HL7ResultType=="IM")) {
				var url="websys.default.csp?WEBSYS.TCOMPONENT=OETextResult.ListHistory&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&ParRef="+OtherRowID+"&OEOrdItemID="+OrderID+"&PatientBanner=1";
				websys_createWindow(url, 'LabTabularResults', 'scrollbars=yes,resizable=yes');
			}
		}
	}
}

/*
function ResultsLinkHander(e) {
	var eSrcAry=window.event.srcElement.id.split("z");
	//alert("ResultsLinkHander - eSrcAry = " + eSrcAry); // exampleDicom,1
	if (eSrcAry.length>0) {
		var tbl=getTableName(window.event.srcElement);
		var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
		var ChartID=f.elements["ChartID"].value;
		var ItemID=f.elements["ItemID"].value;
		var Type=f.elements["Type"].value;
		if (eSrcAry[0]=="ResultsLink") {
			var restype=f.elements["ResTypez"+eSrcAry[1]].value;
			var typeAry=restype.split("^");
			var ResultType=typeAry[0];
			//alert(ResultType);
			if (ResultType=="") {
					alert(t['RESULT_TYPE_BLANK']);
				return false;
			}
			if (ResultType=="D") {
					alert(t['RES_DICOM']);
				return false;
			}
			if (ResultType=="V") {
					alert(t['RES_VOICE']);
				return false;
			}
			var ResName=f.elements["ResNameHiddenz"+eSrcAry[1]].value;
			var ResultStatus=f.elements["StatusCodez"+eSrcAry[1]].value;
			var otherrowid=f.elements["TRRowidz"+eSrcAry[1]].value;
			var orderid=f.elements["OrderIDz"+eSrcAry[1]].value;
			var resultid=f.elements["ResultIDz"+eSrcAry[1]].value;
			var dateread=f.elements["DateReadz"+eSrcAry[1]].value;
			var patientid=f.elements["PatientID"].value;
			var episodeid=f.elements["EpisodeIDz"+eSrcAry[1]].value;
			var labepisodeno=f.elements["LabEpisodeNoz"+eSrcAry[1]].value;
			var HL7ResultType=f.elements["ARCICHL7ResultTypez"+eSrcAry[1]].value;
			var DisplayWordFormat=f.elements["DisplayWordFormatz"+eSrcAry[1]].value;
			var TaggedRowIDs=f.elements["TaggedRowIDsz"+eSrcAry[1]].value;
			var UnTaggedRowIDs=f.elements["UnTaggedRowIDsz"+eSrcAry[1]].value;
			var MarkedAsSignificant=f.elements["MarkedAsSignificantz"+eSrcAry[1]].value;
			var OrderCode=f.elements["Descz"+eSrcAry[1]].value;
			var Context=f.elements["CONTEXT"].value;
			var dicomAry=f.elements["dicombufferz"+eSrcAry[1]].value.split("^");
			var DicomResult="",mradm="",catgsID="",dfrom="",dto="",EpisodesAll="";
			if (dicomAry[0]=="J") DicomResult=dicomAry[0],orderid=dicomAry[1],mradm=dicomAry[3],catgsID=dicomAry[4],dfrom=dicomAry[5],dto=dicomAry[6],EpisodesAll=dicomAry[7];
			//LOG 34490 RC 30/04/03 The AlternateReport if needed and the file path of the word doc.
			var altRes=f.elements["AlternateReportz"+eSrcAry[1]].value;
			var path=mPiece(f.elements["ResTypez"+eSrcAry[1]].value,"^",3);

			//LOG 34490 RC 30/04/03 Need these to search if there is a file to open or not.
			var re=/(\.rtf)/gi;
			var re1=/(\.txt)/gi;
			var re2=/(\.doc)/gi;

			if (OrderCode=="Discharge Letter") {DisplayWordFormat=1};

			var FileName=typeAry[3];

			if (ResultType=="W") {
				var restypearray=restype.split("^");
				HL7ResultType=restypearray.join("~")
			}
			var resdets = resultid+"*"+ResultType+"*"+HL7ResultType+"*0*"+DisplayWordFormat+"*"+OrderCode;
			if (dateread=="") {
				resdets = resdets + "*0*0*";
			} else {
				resdets = resdets + "*1*1*";
			}
			resdets = escape(resdets + TaggedRowIDs+"*"+UnTaggedRowIDs+"*"+MarkedAsSignificant);
			// ResultID  *
			// Type (W, L, T, RTFLAB, WORDLAB) *
			// HL7Type (IM, or document details if type=W) *
			// viewed (we will only read/unread these results...) *
			// display in word Format *
			// order description *
			// MarkedForReading (from the tickbox on each page) *
			// AlreadyRead (for checking if to unread or not...) *
			// TagResult1~TagResult2~... *
			// UnTaggedResult1~UnTaggedresult2~.... *
			// order item is significant
			url="oeorditem.tabularresultsemr.csp?Counter=&MaxRes=1"+"&EpisodeID="+episodeid+"&ResultDetails="+resdets+"&PatientBanner=1&PatientID="+patientid+"&ChartID="+ChartID+"&ResultID="+resultid+"&ItemID="+ItemID+"&Type="+Type+"&ResultType="+Type+"&CONTEXT="+Context;
			if ((ResultType=="T")||((ResultType=="L")&&(HL7ResultType=="IM"))) {
				var resultlist=otherrowid+"*"+ResultType+"*"+HL7ResultType+";0";
				websys_createWindow(url, 'TextResults', 'top=50,left=100,width=800,height=600,scrollbars=yes,resizable=yes');
			} else if (ResultType=="L") {
				var resultlist=resultid+"*"+ResultType+"*"+HL7ResultType+";0";
				websys_createWindow(url, 'AtomicResults', 'top=50,left=100,width=800,height=600,scrollbars=yes,resizable=yes');
			} else  if (typeAry[0]=="WLAB") {
				if (DisplayWordFormat!=0) {
					if (window.UseCustomLabResultsLinkHander) {
						// open whatever they define
						CustomLabResultsLinkHander(typeAry[2],typeAry[3]);
					} else {
						// open in word
						window.open(typeAry[2]+typeAry[3],'new','scrollbars=yes,resizable=yes,toolbar=no,width=750,height=600,location=no,directories=no,status=no,menubar=no,fullscreen=no');
					}
				} else {
					url="oeorditem.tabularlabwordresults.csp?EpisodeID="+episodeid+"&OrderID="+resultid+"&ItemID="+ItemID+"&Type="+Type+"&ResultType="+Type+"&CONTEXT="+Context;
					websys_createWindow(url, 'TextResults', 'top=50,left=100,width=800,height=600,scrollbars=yes,resizable=yes');
				}
			} else  if (typeAry[0]=="RTFLAB") {
				url="oeorditem.tabularlabwordresults.csp?EpisodeID="+episodeid+"&OrderID="+resultid+"&ItemID="+ItemID+"&Type="+Type+"&ResultType="+Type+"&CONTEXT="+Context;
				websys_createWindow(url, 'TextResults', 'top=50,left=100,width=800,height=600,scrollbars=yes,resizable=yes');
			} else  if (typeAry[0]=="W") {
				if (ResultStatus=="E") alert(t['ResultIsEntered']);
				//if (dateread=="") top.frames["TRAK_hidden"].location="oeordresults.update.csp?ResultID="+resultid+"&ResType="+typeAry[0];
				if (typeAry[1].substring(0,1)=="/") typeAry[1]=typeAry[1].substring(1,typeAry[1].length);
				//LOG 34490 RC 30/04/03 Testing to see if there is a word doc available.
				if ((path.search(re) != -1) || (path.search(re1) != -1) || (path.search(re2) != -1)) {
					//alert(DisplayWordFormat);
					if (DisplayWordFormat!=0) {
						// open in word
						if (window.UseCustomResultsLinkHander) {
							// open whatever they define
							CustomResultsLinkHander(typeAry[2],typeAry[3]);
						} else {
							window.open("/"+typeAry[1]+typeAry[3],'new','scrollbars=yes,resizable=yes,toolbar=no,width=750,height=600,location=no,directories=no,status=no,menubar=no,fullscreen=no');
						}
					} else {
						// open in component
						// swap ^ for ~, as this is what Tabular sends to tabularresultsemr.csp
						var re = /\^/g;
						restype = restype.replace(re,"~");
						var resultlist=resultid+"*"+ResultType+"*"+restype+";0";
						url="oeorditem.tabularresultsemr.csp?Counter=&MaxRes=1&EpisodeID="+episodeid+"&FileName="+FileName+"&ResultDetails="+resdets+"&PatientBanner=1&PatientID="+patientid+"&ChartID="+ChartID+"&ResultID="+resultid+"&ItemID="+ItemID+"&Type="+Type+"&ResultType="+Type+"&CONTEXT="+Context+"&DicomResult="+DicomResult+"&OrderID="+orderid+"&mradm="+mradm+"&catgsID="+catgsID+"&dfrom="+dfrom+"&dto="+dto+"&EpisodesAll="+EpisodesAll;
						//url = "websys.default.csp"
						websys_createWindow(url, 'TextResults', 'top=50,left=100,width=800,height=600,scrollbars=yes,resizable=yes');
						//websys_createWindow(url, 'Word Results', 'top=50,left=100,width=800,height=600,scrollbars=yes,resizable=yes');
						//alert('url after: ' + url );
					}
				} else {
					var IDObj=document.getElementById("ResultIDz"+eSrcAry[1]);
					if(IDObj && IDObj.value!="") {
						var ID=IDObj.value;
						var path="websys.default.csp?WEBSYS.TCOMPONENT=OEOrdItem.NSRTxtResult&ID="+ID;
						websys_createWindow(path,"","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes")
					}
				}

			}
*/
			/********* This function is not performed.
			if (typeAry[0]=="D") {
				//ResType contains delimited list of "J",PatientID,mradm,catgsID,dfrom,dto,EpisodesAll
				//alert("a");
				var typeAry=f.elements["dicombufferz"+eSrcAry[1]].value.split("^");
				var OrderID=typeAry[1];
				var PatientID=typeAry[2];
				var mradm=typeAry[3];
				var catgsID=typeAry[4];
				var dfrom=typeAry[5];
				var dto=typeAry[6];
				var EpisodesAll=typeAry[7];
				//alert('WebTrakViewer.csp?OrderID='+OrderID+'&PatientID='+PatientID+'&mradm='+mradm+'&catgsID='+catgsID+'&dfrom='+dfrom+'&dto='+dto+'&EpisodesAll='+EpisodesAll);
				websys_createWindow('webtrakviewer.csp?OrderID='+OrderID+'&PatientID='+PatientID+'&mradm='+mradm+'&catgsID='+catgsID+'&dfrom='+dfrom+'&dto='+dto+'&EpisodesAll='+EpisodesAll, 'dicom', 'scrollbars=auto,toolbar=no,width='+screen.width+',height='+screen.height+',top=0,left=0,resizable=yes')
			}
*********/
		//}
/********* This function is not performed.
		//JAVA DICOM
		if (eSrcAry[0]=="Dicom") {
			//ResType contains delimited list of "J",PatientID,mradm,catgsID,dfrom,dto,EpisodesAll
			//alert("b");
			var typeAry=f.elements["dicombufferz"+eSrcAry[1]].value.split("^");
			var OrderID=typeAry[1];
			var PatientID=typeAry[2];
			var mradm=typeAry[3];
			var catgsID=typeAry[4];
			var dfrom=typeAry[5];
			var dto=typeAry[6];
			var EpisodesAll=typeAry[7];
			//alert('WebTrakViewer.csp?OrderID='+OrderID+'&PatientID='+PatientID+'&mradm='+mradm+'&catgsID='+catgsID+'&dfrom='+dfrom+'&dto='+dto+'&EpisodesAll='+EpisodesAll);
			websys_createWindow('webtrakviewer.csp?OrderID='+OrderID+'&PatientID='+PatientID+'&mradm='+mradm+'&catgsID='+catgsID+'&dfrom='+dfrom+'&dto='+dto+'&EpisodesAll='+EpisodesAll, 'dicom', 'scrollbars=auto,toolbar=no,width='+screen.width+',height='+screen.height+',top=0,left=0,resizable=yes')
			return false;
		}
*********/
/*
	}
	return false;
}
*/

function activateDicom(OEItemID,FilePath,ResName,ResultID) {
	try {
		var websys_dicom=new ActiveXObject("tkMTDicom.clsDicomPrint");
		websys_dicom.InitDICOMforWeb("");
		websys_dicom.Caption="PatientName";
		websys_dicom.OrderItemRowid=OEItemID;
		websys_dicom.AddImage(ResultID,ResName,FilePath);
		websys_dicom.Show(0);
	}
	catch (e) {
		if (confirm(e + '\nTRAK Web SDK not installed or not functioning !\n\n Please check that you have installed the TRAK Web SDK.\n Please check that your browser settings allow you to script activeX controls.')) {
			//alert('OK. !!!');
		}
	}
}

function ViewDicom(e,row) {
	//alert("in viewdicom");
	//var tbl=document.getElementById(ltbl.id);
	var tbl=getTableName(window.event.srcElement);
	var frm=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));

	//if (!(tbl)) alert("no tbl");
	//if (!(frm)) alert("no form");

	if ((frm)&&(tbl)) {
		//var aryfound=checkedCheckBoxes(frm,tbl,"Selectz");
		var n=0;var check=0;
		var aryOrderID=new Array(); var aryPatientID=new Array();
		var arymradm=new Array(); var arycatgsID=new Array();
		var arydfrom=new Array(); var arydto=new Array();
		var aryEpisodesAll=new Array(); var arydto=new Array();
		var bInvRow=false; var sErrMsg="";

		var PatientID="";
		var mradm="";
		var catgsID="";

		/*
		for (var j=1;j<tbl.rows.length;j++) {
			if ((frm.elements["Selectz"+j])&&(!frm.elements["Selectz"+j].checked)&&(j==row)) check=j;
		}
		*/
		//alert(check);

		// Log 60515 YC - if select box is not on page, open up clicked image.
		if(row!="") {
			if (((frm.elements["Selectz"+row])&&(!frm.elements["Selectz"+row].checked))||(typeof(frm.elements["Selectz"+row])=="undefined")) check=row;
		}

		for (var i=1;i<tbl.rows.length;i++) {
			if (check>0) {
				var typeAry=frm.elements["dicombufferz"+check].value.split("^");
				//alert("1: "+typeAry);
				if (typeAry[0]=="J") {
					aryOrderID[n]=typeAry[1];
					PatientID=typeAry[2];
					mradm=typeAry[3];
					catgsID=typeAry[4];
					arydfrom[n]=typeAry[5];
					arydto[n]=typeAry[6];
					aryEpisodesAll[n]=typeAry[7];
					n++;
				}
				break;
			} else {
				if ((frm.elements["Selectz"+i])&&(frm.elements["Selectz"+i].checked)) {
					var typeAry=frm.elements["dicombufferz"+i].value.split("^");
					//alert("2: "+typeAry);

					if (typeAry[0]=="J") {
						aryOrderID[n]=typeAry[1];
						// Assumption is that all records in list will have the same:
						// PatientID, mradm, catgsID
						// No array will be reqd for these vars
						PatientID=typeAry[2];
						mradm=typeAry[3];
						catgsID=typeAry[4];
						//aryPatientID[n]=typeAry[2];
						//arymradm[n]=typeAry[3];
						//arycatgsID[n]=typeAry[4];

						arydfrom[n]=typeAry[5];
						arydto[n]=typeAry[6];
						aryEpisodesAll[n]=typeAry[7];
						n++;
					} else {
						//tagName,innerText
						//alert("restype"+frm.elements["dicombufferz"+i].value);
						//alert(frm.elements["OEORILabEpisodeNoz"+i].value);
						//alert(frm.elements["Descriptionz"+i].value);
						//return false;
						//sErrMsg += t['RES_ITEM'] + frm.elements["Descriptionz"+i].value + t['NOT_DICOM'] + "\n";
						bInvRow=true;
					}
				}
			}
		}

		//alert(bInvRow+"+"+n);
		if (bInvRow) {
			if (n==0) {
				alert(t['NO_VALID_DICOM_SEL']);
				//msg "No valid Dicom result has been selected."
				return false;
			} else {
				var bContinue=1;
				bContinue=confirm(t['NON_DICOM_SEL']);
				//msg "Non-Dicom result(s) have been selected and will not be displayed.
				//Do you want to continue?"
				if (!bContinue) {
					return false;
				}
			}
			//alert(sErrMsg);
			//return false;
		} else if (n==0) {
			alert(t['NO_SEL']);
			return false;
		}
		var sLink="webtrak.annotate.csp?";
		sLink += "OrderID=" + aryOrderID.join("^");

		sLink += "&PatientID=" + PatientID;
		sLink += "&mradm=" + mradm;
		sLink += "&catgsID=" + catgsID;

		//sLink += "&PatientID=" + aryPatientID.join("^");
		//sLink += "&mradm=" + arymradm.join("^");
		//sLink += "&catgsID=" + arycatgsID.join("^");

		sLink += "&dfrom=" + arydfrom.join("^");
		sLink += "&dto=" + arydto.join("^");
		sLink += "&EpisodesAll=" + aryEpisodesAll.join("^");
		sLink += "&PatienBanner=1";
		//alert(sLink);
		//return false;
		websys_createWindow(sLink,'dicom','scrollbars=auto,toolbar=no,width='+screen.width+',height='+screen.height+',top=0,left=0,resizable=yes');
	}
}

RemoveDicomLinks();

function RemoveDicomLinks() {
	//alert("!");
	/*
	/var tbl=document.getElementById(ltbl.id);
	var frm=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));

	if ((frm)&&(tbl)) {
		for (var i=0;i<tbl.rows.length;i++) {
			var obj=document.getElementById("Dicomz"+i);
			if (obj) {
				//alert("Removing Dicom Links"+i);
				// SA 19.9.02 - The Dicom field is currently an image. It is a system-wide problem (SP knows)
				// that images can NOT be disabled. I've left this code here for when this problem is fixed.
				// At the moment, the link still activates (to a blank page). Ash has asked that the
				// image remain as link (for demo) with the disabling ignored for now.
				//obj.disabled=true;
				//obj.onclick=LinkDisable;
			}
		}
	}
	*/
	return false;
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

var objClicked=document.getElementById('Clicked');
if (objClicked.value>=1) {
	  var searchobj=document.getElementById('SearchPar');
	  searchobj.disabled=true;
	  searchobj.onclick=LinkDisable;
}

if ((EpisodeID==null) && (frm)) {
	var EpisodeID=frm.elements['EpisodeID'].value;
}
if (ltbl && frm) {
	for (var i=1;i<ltbl.rows.length;i++) {
		var eSrc=frm.elements['EpisodeIDz'+i];
		if (eSrc) {
			//alert(i+" "+eSrc);
			var obj=getRow(eSrc);
			var epid=frm.elements['EpisodeIDz'+i].value;
			var abnrml=frm.elements['Abnormalz'+i].value;
			if (epid!=EpisodeID) {
				if ((i%2)==1) {
					obj.className="EMROtherEpsOdd";
				} else {
					obj.className="EMROtherEpsEven";
				}
				if ((abnrml=="Y")&&((i%2)==1)) {
					obj.className="AbnrmlEMROtherEpsOdd";
				} else if (abnrml=="Y") {
					obj.className="AbnrmlEMROtherEpsEven";
				}
			} else if (abnrml=="Y") {
				if ((i%2)==1) {
					obj.className="AbnrmlResOdd";
				} else {
					obj.className="AbnrmlResEven";
				}
			}
		}
	}  // for
}  // if (ltbl)

function getRow(eSrc) {
	while(eSrc.tagName != "TR") {if (eSrc.tagName == "TH") break;eSrc=eSrc.parentElement;}
	return eSrc;
}

function mPiece(s1,sep,n) {
	//Split the array with the passed delimeter
    var delimArray ="";
	delimArray = s1.split(sep);
	  //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
	} else {
	  return ""
    }
}

// Log 55973 - PC - 19-12-2005 : New functions to Select All rows for use by the 'Reports' menu.
function OEORIDSReportFlagLinkDisable(evt) {
	return false;
}

function DisableLink(fld) {
	if (fld) {
		fld.value = "";
		fld.disabled = true;
		fld.onclick=OEORIDSReportFlagLinkDisable
		fld.className = "disabledLink";
	}
}

//
//This function is no longer in use
//Log 65388
//
function DisableReportFlagLinks() {
	if (ltbl) {
		var ary=ltbl.getElementsByTagName("A")
		for (var curr_fld=0; curr_fld<ary.length; curr_fld++) {
			var obj=ary[curr_fld];
			if (obj) {
				if (obj.id.substring(0,24) == "OEORIResultDSReportFlagz") {
					DisableLink(obj);
				}
			}
		}
	}
	return false;
}

//DisableReportFlagLinks();


if (frm) {
	var objSelectAll = frm.elements["SelectAll"];
	if (objSelectAll) objSelectAll.onclick=SelectAllClickHandler;
}


function SelectAllClickHandler(evt) {
	var ifrm,itbl;

	var el=window.event.srcElement
	// Get the form that contains the element that initiated the event.
	if (el) ifrm=getFormName(el);
	// Get the table of the same name as the form.
	if (ifrm) itbl=document.getElementById("t"+ifrm.id.substring(1,ifrm.id.length));
	// Set each "SelectItem" checkboxes to the same value as the "SelectAll" checkbox.
	if (itbl) {
		for (var curr_row=1; curr_row<itbl.rows.length; curr_row++) {
			var objSelectItem=ifrm.elements["SelectItemz" + curr_row];
			if (!objSelectItem) objSelectItem=ifrm.elements["Selectz" + curr_row];
			if (objSelectItem) objSelectItem.checked=el.checked;
		}
	}

	return true;
}
// Function called from the Component Menus.
function MRAdmListEMRResults_PassSelected(lnk,newwin) {
	var f,aryfound;
	var tbl=getTableName(window.event.srcElement);

	if (tbl) f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));

	if (f) aryfound=checkedCheckBoxes(f,tbl,"Selectz");

	if (aryfound.length==0) {
		alert(t['NONE_SELECTED']);
		return;
	} else {
		var AryItems=new Array();
		var RowIDs="";
		for (var i=0;i<aryfound.length;i++) {
			var count=aryfound[i];
			var RowID=f.elements["ResultIDz"+count].value;
			if (RowIDs=="") {
				RowIDs=RowID;
			} else {
				RowIDs=RowIDs+"^"+RowID;
			}
		}

		lnk+= "&RowIDs=" + RowIDs;
	}

	//alert(lnk);
	window.location = lnk;
}

// end Log 55973

// YC Comment to test W650 logtrak patching for log 60515
