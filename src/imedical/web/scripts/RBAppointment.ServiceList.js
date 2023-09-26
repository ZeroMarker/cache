// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var delim="*"; //SB: Had problems with the following deliminators: %, #, & (can't use "|" as is used in schedrowid)
var RBEditWindow;
var debug="N"  //"Y" = alerts and stuff, "N" = alert free


function DocumentLoadHandler() {
	var obj=document.getElementById("doFind")
	if (obj) doFind = obj.value;
	assignClickHandler();
	//LOG 31208 BC 4-2-2003
	CareProviderLinkBuilder();
	if (doFind==1) parent.frames["RBApptFind"].FindClickHandler("");
	parent.ServReady=1
	// SB 10/09/02 (28158): Setting TAB order
	var obj=top.frames["TRAK_main"].frames["RBApptFind"].document.getElementById("PIN")
	//if (obj) obj.focus()
}

function assignClickHandler() {
	//debugger;
	var tbl=document.getElementById("tRBAppointment_ServiceList");
	for (var i=1;i<tbl.rows.length;i++) {
		var obj=document.getElementById("deletez"+i)
		if (obj) obj.onclick = DeleteClickHandler;
		var obj=document.getElementById("editz"+i)
		if (obj) obj.onclick = EditClickHandler;
		var obj=document.getElementById("mainz"+i)
		if (obj) obj.onclick = EditClickHandler;
		//LOG 43413 RC 23/07/04
		var obj=document.getElementById("AddPatientz"+i)
		if (obj) obj.onclick = AddPatientClickHandler;
		var obj=document.getElementById("chkIncapacityz"+i)
		if (obj) {
			obj.onclick = IncapacityClickHandler;
			obj.disabled=true;
			var objDuration = document.getElementById("Durationz"+i)
			if (objDuration && objDuration.innerText!=" " && objDuration.innerText!="") obj.disabled=false;
			//Log 43100: Debug causes error if duration isn't on form
			//Debug("assignClickHandle","Duration","'"+objDuration.innerText+"'")
		}
	}
	return;
}

function IncapacityClickHandler(e) {
	//SB 01/06/04 (41522):Changing appointment duration for incapacity patients
	var duration=""
	var perIncrDur=document.getElementById("PercentIncrDur").value
	if (perIncrDur=="") return;
	var increase=parseInt(perIncrDur)/100
	var obj=websys_getSrcElement(e);
	if (obj.tagName=="IMG") obj=websys_getParentElement(obj);
	var rowid=obj.id
	var rowAry=rowid.split("z");
	var objDurId=document.getElementById("durationIDz"+rowAry[1])
	var objDurOver=document.getElementById("OverDurationz" + rowAry[1])
	var objDur = document.getElementById("Durationz"+rowAry[1])
	if (objDur) duration=parseInt(objDur.innerText)
	var objIncap=document.getElementById("chkIncapacityz"+rowAry[1])
	if (duration!="") {
		if (objIncap && objIncap.checked) {
			var percentIncr=duration*increase;
			var NewDur=percentIncr+duration;
			if (objDur) objDur.innerText=NewDur
			if (objDurId) objDurId.value=NewDur
			if (objDurOver) objDurOver.value=NewDur
		} else {
			var revPercent = duration/(increase+1)
			if (objDur) objDur.innerText=revPercent
			if (objDurId) objDurId.value=revPercent
			if (objDurOver) objDurOver.value=revPercent
		}
	}
}

function EditClickHandler(e) {
	var obj=websys_getSrcElement(e);
	if (obj.tagName=="IMG") obj=websys_getParentElement(obj);
	var rowid=obj.id
	var rowAry=rowid.split("z");

	var locId = document.getElementById("locIdz"+rowAry[1]).value
	var resId = document.getElementById("resIdz"+rowAry[1]).value
	var payId = document.getElementById("payIdz"+rowAry[1]).value
	var planId = document.getElementById("planIdz"+rowAry[1]).value
	var payor=""; var obj = document.getElementById("payDescz"+rowAry[1])
	if (obj) payor = obj.innerHTML
	var plan = ""; var obj = document.getElementById("planDescz"+rowAry[1])
	if (obj) plan = obj.innerHTML
	var obreason = document.getElementById("obreasonz"+rowAry[1]).value
	var main = mPiece(document.getElementById("serIdz"+rowAry[1]).value,"|",1)
	var nodays = mPiece(document.getElementById("serIdz"+rowAry[1]).value,"|",2)
	var urgent = document.getElementById("urgentIDz"+rowAry[1]).value
	var duration = document.getElementById("durationIDz"+rowAry[1]).value
	//Log 31104 RC 22/01/03
	var obj = document.getElementById("Transportz"+rowAry[1])
	if (obj) var transport=obj.innerHTML
	var obj = document.getElementById("Interpreterz"+rowAry[1])
	if (obj) var interpreter=obj.innerHTML
	var obj = document.getElementById("TransReqz"+rowAry[1])
	if (obj) var trareq=obj.value
	var obj = document.getElementById("IntReqz"+rowAry[1])
	if (obj) var intreq=obj.value
	var obj=document.getElementById("datez"+rowAry[1])
	if (obj) var date=obj.innerHTML
	var obj=document.getElementById("timez"+rowAry[1])
	if (obj) var time=obj.innerHTML
	var stype=document.getElementById("sesstypez"+rowAry[1]).value
	var disint=document.getElementById("disIntz"+rowAry[1]).value
	var distrans=document.getElementById("disTransz"+rowAry[1]).value
	//BR 22/08 37903 - Need to pass PatientID so we can show patient banner
	var Finddoc=top.frames["TRAK_main"].frames["RBApptFind"].document
	var objpatId=Finddoc.getElementById("PatientID");
	if (objpatId) var patId=objpatId.value
	//alert("i="+intreq+" +di="+disint+" +t="+trareq+" +dt="+distrans);
	// Log 37518 BC 9-9-2003 Add HCA and Hospitals to Edit Service List
	var HCARowID=""; var HCADesc=""; var HOSPDesc=""; var HospIDs=""; var ApptMeth=""; var ApptLang=""; var ORICred="";
	var ConsultCateg=""
	var objHCARowID=document.getElementById("HCARowIDz"+rowAry[1]);
	if (objHCARowID) HCARowID=objHCARowID.value;
	var objHCADesc=document.getElementById("HCADescz"+rowAry[1]);
	if (objHCADesc) HCADesc=objHCADesc.innerHTML;
	var objHOSPDesc=document.getElementById("HOSPDescz"+rowAry[1]);
	if (objHOSPDesc) HOSPDesc=objHOSPDesc.innerHTML;
	var objHospIDs=document.getElementById("HospIDsz"+rowAry[1]);
	if (objHospIDs) HospIDs=objHospIDs.value;
	var objApptMeth=document.getElementById("ApptMethodz"+rowAry[1]);
	if (objApptMeth) ApptMeth=objApptMeth.innerText;
	var objApptLang=document.getElementById("ApptLanguagez"+rowAry[1]);
	if (objApptLang) ApptLang=objApptLang.value;
	var objConsultCateg=document.getElementById("ConsultCategz"+rowAry[1]);
	if (objConsultCateg) ConsultCateg=objConsultCateg.value;
	var objORICred=document.getElementById("OEORIItemGroupz"+rowAry[1]);
	if (objORICred) ORICred=objORICred.innerHTML;
	var Incapasity=""
	var objIncapasity=document.getElementById("chkIncapacityz"+rowAry[1]);
	if (objIncapasity) Incapasity=objIncapasity.value;
	var RegNo="";
	var objRegNo=document.getElementById("RegistrationNoz"+rowAry[1]);
	if (objRegNo) RegNo=objRegNo.innerHTML;
	var sessid="";
	var objsessid=document.getElementById("sessionidz"+rowAry[1]);
	if (objsessid) sessid=objsessid.value
	//if (objApptLang) ApptLang=objApptLang.innerText;
	//End Log 31104
	//var ssessdesc = document.getElementById("ssessdescz"+rowAry[1]).value
	EditRow(rowAry[1],locId,resId,payId,planId,payor,plan,obreason,main,nodays,urgent,duration,transport,interpreter,date,time,stype,trareq,intreq,disint,distrans,patId,HCADesc,HCARowID,HOSPDesc,HospIDs,ApptMeth,ApptLang,Incapasity,RegNo,ORICred,ConsultCateg,sessid);
	return false;
}

function DeleteClickHandler(e) {
	var obj=websys_getSrcElement(e);
	if (obj.tagName=="IMG") obj=websys_getParentElement(obj);
	var rowid=obj.id
	var rowAry=rowid.split("z");
	var cont=true;
	if (document.getElementById("addStrz"+rowAry[1]).value!="") cont=confirm(t["deleterow"])
	if (cont==true) {
		UpdateGlobal(rowAry[1],"0");
		parent.frames["RBServList"].Refresh("Delete","",rowAry[1],"")
	}
	//DeleteRow(rowAry[1]);
}

function UpdateGlobal(row,chk) {
	var servID = mPiece(document.getElementById("serIdz"+row).value,"|",0)
	var schedID = document.getElementById("schedlistz"+row).value

	if (!schedID) return;
	var ret=tkMakeServerCall("web.RBApptSchedule","GetServiceRowStr",chk,schedID,servID,"^");

	if (document.getElementById("addStrz"+row)) {
		for (var ii=0; mPiece(document.getElementById("addStrz"+row).value,"@",ii)!=""; ii++) {
			var addstr=mPiece(document.getElementById("addStrz"+row).value,"@",ii)
			var ret=tkMakeServerCall("web.RBApptSchedule","GetServiceRowStr",chk,mPiece(addstr,"*",0),servID,"^");
		}
	}
}

function EditRow(rowId,locId,resId,payId,planId,payor,plan,obreason,main,nodays,urgent,duration,transport,interpreter,date,time,stype,trareq,intreq,disint,distrans,patId,HCADesc,HCARowID,HOSPDesc,HospIDs,ApptMeth,ApptLang,Incapasity,RegNo,ORICred,ConsultCateg,sessid) {
	//alert(rowId+","+locId+","+resId+","+payId+","+planId+","+obreason+","+main+","+nodays+","+urgent+","+duration+","+transport+","+interpreter+","+date+","+time+","+stype)
	//BR 22/08 37903 - Added patient banner to EditServiceList
	// Log 37518 BC 9-9-2003 Add HCA and Hospitals to Edit Service List
	var obj= document.getElementById("CONTEXT")
	if (obj) context=obj.value;
	if (sessid!="") {
		var sessidx=sessid.replace("?", "||")
		sessid=sessidx.replace("?", "||")
	}

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.EditServiceList&RowID="+rowId+"&LocID="+locId+"&ResID="+resId+"&PayID="+payId+"&PlanID="+planId+"&InsurPayor="+payor+"&InsurPlan="+plan+"&OBReason="+obreason+"&Main="+main+"&NoDays="+nodays+"&Urgent="+urgent+"&Duration="+duration+"&Transport="+transport+"&Interpreter="+interpreter+"&SessType="+stype+"&TransReq="+trareq+"&IntReq="+intreq+"&disInt="+disint+"&disTrans="+distrans+"&PatientID="+patId+"&PatientBanner=1&HCARowID="+HCARowID+"&HCADesc="+HCADesc+"&HospIDs="+HospIDs+"&HOSPDesc="+HOSPDesc
	lnk+="&ApptMethod="+ApptMeth+"&ApptLanguage="+ApptLang+"&OrderCredential="+ORICred+"&ConsultCateg="+ConsultCateg+"&Incapasity="+Incapasity+"&RegistrationNo="+RegNo+"&SessId="+sessid+"&CONTEXT="+context;
	//alert(lnk);
	RBEditWindow=websys_createWindow(lnk,"frmEditServiceList","resizable=yes,scrollbars=yes")
}

function SetSessType(str) {
	var strAry=str.split("^");
	//alert(strAry);
	var win=RBEditWindow.document
	var sess=win.getElementById("SessType")
	var sesscode=win.getElementById("SessTypeCode")
	//alert(sess.value);
	var sessLU=win.getElementById("ld621iSessType")
  	if (strAry[0]!="0") {
		if (strAry[0]!="M") {
	  		if ((sess)&&(sesscode)) {
				if ((strAry[7]<2)||(strAry[3]!="")) {
					sess.value=strAry[0];
					sesscode.value=strAry[5];
					sess.disabled=true;
					sessLU.disabled=true;
					if (strAry[3] && strAry[3]!="" && strAry[0]=="") {
						sess.value=t["NoSTDef"]
						//sess.value="No Session Type Defined";
						sess.disabled=true;
						sessLU.disabled=true;
					}
					if (strAry[3]=="" && strAry[0]=="") {
						sess.value=t["NoSTDef"]
						//sess.value="No Session Type Defined";
					}
					if (str=="") {
						sess.value="";
					}
				} else {
					sess.value="";
					sesscode.value="";
					sess.disabled=false;
					sessLU.disabled=false;
				}
			}
		  	var sessRowId=win.getElementById("SessionId")
		  	if (sessRowId && strAry[3] && strAry[3]!="" && strAry[7] && strAry[7]<2) {
				var sessStr=strAry[3]
				sessStrx=sessStr.replace("||", "?")
				sessStr=sessStrx.replace("||", "?")
				sessRowId.value=sessStr
		  	}
		} else {
			var sessMessage=win.getElementById("sessMessage")
			if (sessMessage) sessMessage.value=strAry[4];
			if ((sesscode)&&(sesscode.value=="")) sesscode.value=strAry[5];
			var objDOW=win.getElementById("DOW")
			if (objDOW) objDOW.value=strAry[6];
		}
	}
}

function Refresh(Mode,objRow,Row,NewRowStr,doFind) {
//////////////////////////////////////////////- ServiceList Refresh -////////////////////////////////////////////////////////
// Created: 	15 Feb 2002
// By:		Simon Bachell
// Usage:	Controls all updates made to the middle (ServiceList) table
// Parameters:
// 		Mode 	    - Add, Delete, Update, Edit
//			    (Note: Update is used to update the bottom table into the middle table, where edit
//			       is used to update the middle grid with the info from the EditServiceList form.)
// 		objRow      - (optional) Object of the Row to Update
// 		Row 	    - (optional) Row number to be Deleted or Updated
// 		NewRowStr   - (optional) String to be Added or Updated
// 		doFind      - (optional) When set to 1 will automatically call the Add when Find is clicked.
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   var str=""; var addstr="";
   //Log 30495 To allow for multiple careproviders- need to add a new line if another CP is chosen
   var fser="";
   var fpayid="";
   var fplanid="";
   var fpay="";
   var fplan="";
   var fireq="";
   var ftreq="";
   var ftrans="";
   var finte="";
   var found=false; var addfound=false; var mainremove=false;
   //alert("start\n\n'"+NewRowStr+"'");
   var ServListFrame=top.frames["TRAK_main"].frames["RBServList"];
   if (ServListFrame) {
	// 0=hidden, 1=display
	// SB: Don't forget to update ListOfServicesFetch with newly add fields.
	var FieldList="schedlist,0;serDesc,1;locDesc,1;resDesc,1;Day,1;date,1;time,1;payDesc,1;planDesc,1;serId,0;locId,0;resId,0;payId,0;planId,0;obreason,0;comment,0;main,1;nodays,1;Duration,1;urgentID,0;sessionid,0;interpreter,1;transport,1;sesstype,0;intreq,0;transreq,0;disInt,0;disTrans,0;sessdesc,1;HCADesc,1;HCARowID,0;HOSPDesc,1;HospIDs,0;ApptMethod,1;ApptLanguage,0;chkIncapacity,1;RegistrationNo,1;QLDOutChk,0;Price,1;OEORIItemGroup,1;OEOrdItemID,0;multiSelCnt,0;ConsultCateg,0;0,0;0,0;"
	var FieldAry=FieldList.split(";")

	var tblServList=document.getElementById("tRBAppointment_ServiceList");
	//SB 15/01/07 (61303): All references to Apptdoc have been removed. This script now needs to work
	// for both normal multi bookings and with the Appt Diary.
	//var Apptdoc=top.frames["TRAK_main"].frames["RBApptList"].document;

	var rowLen=tblServList.rows.length;
	//alert("rowLen=\n\n"+rowLen);

	if (Mode=="Update" || Mode=="Edit") {
		var ApptAry=NewRowStr.split("^");
	} else {
		var ApptStr=""
		var ApptAry=ApptStr.split("^");
	}

	for (var i=1; i<rowLen; i++) {
		condition="F"
		condition2="F"
		var addstr=""; var addrow=""; var tmpstr=""; var mulSelLst="";
		if (Mode=="Delete") {
			if (i==Row) condition="T"
		}
		if (Mode=="Edit") {
			if (i==Row) {
				condition="T"
				condition2="T"
			}
		}
		//RC A lot of this Updating has been changed for LOG 49241. If it gets changed back to the old way, the whole
		//'else' under the CompareStrings isn't needed anymore.
		if (Mode=="Update") {
			//var NoSelectMultiRow=Apptdoc.getElementById("NoSelectMultiRow");
			var NoSelectMultiRow=""; NoSelectMultiRow=ApptAry[43];
			//Log 35272 BC 29-4-2003 Allowing for linked resource appointments
			var linkedCP=false;
			if (ApptAry[0]==" ") ApptAry[0]="";
			var mulSelLst="";
			if (ApptAry[0].indexOf("z")!=-1) {
				var mulSelArr=ApptAry[0].split("z")
				ApptAry[0]=mulSelArr[0]
				for (var msl=1; msl<mulSelArr.length; msl++) {
					if (mulSelArr[msl]!="") mulSelLst=mulSelLst+mulSelArr[msl]+"z"
				}
			}
			//ApptAry[0]+delim+ApptAry[4]+delim+ApptAry[5]+delim+ApptAry[6]+delim+ApptAry[18]+delim+ApptAry[19]+delim+ApptAry[20]+delim+ApptAry[28]+delim+ApptAry[38]+delim+ApptAry[40]
			var schID=document.getElementById("schedlistz"+i)
			if (schID) {
				if (schID.value==ApptAry[0]) {
					var addstr=document.getElementById("addStrz"+i).value
					if (addstr!="") {
						mainremove=true;
						addary=addstr.split("@");
						addstr=addary[0].split("*");
						//Copy the Data from the first additional appointment into the main row
						ApptAry[0]=addstr[0]; ApptAry[4]=addstr[1]; ApptAry[5]=addstr[2]; ApptAry[6]=addstr[3];
						//change additional string to only contain the appointments after the first additional (as that has been copied to the main)
						for (var k=1; k<addary.length; k++) {
							if (addary[k]!="") tmpstr=tmpstr+addary[k]+"@"
						}
						document.getElementById("addStrz"+i).value=tmpstr
					}
				}
			}
			//Log 30495 To allow for multiple careproviders- need to add a new line if another CP is chosen
			/*if (document.getElementById("servListz"+i)&&document.getElementById("serIdz"+i)&&document.getElementById("resIdz"+i)) {
				if ((document.getElementById("servListz"+i).checked==true)&&(mPiece(document.getElementById("serIdz"+i).value,"|",0)==mPiece(Apptdoc.getElementById("HIDDENz"+Row).value,"^",1) && (linkedCP||(mPiece(document.getElementById("resIdz"+i).value,"|",0)==mPiece(mPiece(Apptdoc.getElementById("HIDDENz"+Row).value,"^",0),"||",0) || mPiece(document.getElementById("resIdz"+i).value,"|",0)=="")))) {
					if (Apptdoc.getElementById("chkz"+Row).checked==true) {
						if (document.getElementById("schedlistz"+i).value==" ") document.getElementById("schedlistz"+i).value=""
						var additem=true;
						for (var l=0;mPiece(ApptAry[0],"z",l)!="";l++) {
							if (additem==false) break;
							var Aschid=mPiece(ApptAry[0],"z",l)
							for (var m=0;mPiece(document.getElementById("schedlistz"+i).value,"z",l)!="";m++) {
								var Sschid=mPiece(document.getElementById("schedlistz"+i).value,"z",m)
								if (Aschid==Sschid) additem=false; break;
							}
						}
						if (additem==true) ApptAry[0]=document.getElementById("schedlistz"+i).value+ApptAry[0]
					} else {
						var schidlst="";
						if (document.getElementById("schedlistz"+i).value==" ") document.getElementById("schedlistz"+i).value="";
						if (document.getElementById("schedlistz"+i).value!="") {
							//if (schid=="") break;
							for (var k=0;mPiece(document.getElementById("schedlistz"+i).value,"z",k)!="";k++) {
								var schid=mPiece(document.getElementById("schedlistz"+i).value,"z",k)
								//if (schid!="") schid=schid+"z";
								if (ApptAry[0]==" ") {
									schid="";
								} else {
									for (var kk=0;mPiece(ApptAry[0],"z",kk)!="";kk++) {
										var Apptschid=mPiece(ApptAry[0],"z",kk)
										if (schid==Apptschid) {
											schid="";
										}
									}
								}
								if (schid!="") schidlst=schidlst+schid+"z";
							}
						}
						ApptAry[0]=schidlst;
						if (schidlst=="") ApptAry[0]=" ";
					}
				}
			}*/
			if ((document.getElementById("serDescz"+i))&&(CompareStrings(document.getElementById("serDescz"+i).innerText,mPiece(NewRowStr,"^",1)))) {
				if (document.getElementById("serIdz"+i)) fser=document.getElementById("serIdz"+i).value;
				if (document.getElementById("payIdz"+i)) fpayid=document.getElementById("payIdz"+i).value;
				if (document.getElementById("planIdz"+i)) fplanid=document.getElementById("planIdz"+i).value;
				if (document.getElementById("payDescz"+i)) fpay=document.getElementById("payDescz"+i).innerText;
				if (document.getElementById("planDescz"+i)) fplan=document.getElementById("planDescz"+i).innerText;
				if (document.getElementById("IntReqz"+i)) fireq=document.getElementById("IntReqz"+i).value;
				if (document.getElementById("TransReqz"+i)) ftreq=document.getElementById("TransReqz"+i).value;
				if (document.getElementById("Transportz"+i)) ftrans=document.getElementById("Transportz"+i).innerText;
				if (document.getElementById("Interpreterz"+i)) finte=document.getElementById("Interpreterz"+i).innerText;
			}
			if (top.frames["TRAK_main"].frames["RBApptFind"].document.getElementById("LinkFlag")) linkedCP=top.frames["TRAK_main"].frames["RBApptFind"].document.getElementById("LinkFlag").checked;
			//BR 31940. Added extra check to IF statement so that it checks Resource is the same as well as service.
			if (document.getElementById("servListz"+i)&&document.getElementById("serIdz"+i)&&document.getElementById("resIdz"+i)) {
				//alert(mPiece(Apptdoc.getElementById("HIDDENz"+Row).value,"^",1)+" - "+mPiece(mPiece(Apptdoc.getElementById("HIDDENz"+Row).value,"^",0),"||",0))
				//alert(ApptAry)
				//if (mPiece(document.getElementById("serIdz"+i).value,"|",0)==mPiece(Apptdoc.getElementById("HIDDENz"+Row).value,"^",1) && (linkedCP||(mPiece(document.getElementById("resIdz"+i).value,"|",0)==mPiece(mPiece(Apptdoc.getElementById("HIDDENz"+Row).value,"^",0),"||",0) || mPiece(document.getElementById("resIdz"+i).value,"|",0)==""))) {
				if (mPiece(document.getElementById("serIdz"+i).value,"|",0)==ApptAry[42] && (linkedCP||(mPiece(document.getElementById("resIdz"+i).value,"|",0)==mPiece(ApptAry[11],"||",0) || mPiece(document.getElementById("resIdz"+i).value,"|",0)==""))) {
					//RC 61041 Added extra IF statement to check location. Could've added it to top IF, but that's just getting WAY too convoluted.
					//if ((document.getElementById("locIdz"+i).value=="")||(document.getElementById("locIdz"+i).value==Apptdoc.getElementById("LocIdz"+Row).value)) {
					if ((document.getElementById("locIdz"+i).value=="")||(document.getElementById("locIdz"+i).value==ApptAry[10])) {
						condition="T"
						found=true;
					}
				}
			}
			if (NoSelectMultiRow==1) {
				//RC LOG 47855 20/12/04 only check if the service is the same, because the resource will be changing for SAMS
				//if (mPiece(document.getElementById("serIdz"+i).value,"|",0)==mPiece(Apptdoc.getElementById("HIDDENz"+Row).value,"^",1)) {
				if (mPiece(document.getElementById("serIdz"+i).value,"|",0)==ApptAry[42]) {
					condition="T"
					found=true;
				}
			}
			condition2="T";
		}
		if (Mode=="Add") {
			//SB 22/10/04 (45330): Error in create multiple appt. with same service, same doctor
			servstr=mPiece(mPiece(NewRowStr,"*",9),"|",0);
			locstr=mPiece(NewRowStr,"*",10);
			resstr=mPiece(NewRowStr,"*",11);
			if (document.getElementById("serIdz"+i)) rec_serv=mPiece(document.getElementById("serIdz"+i).value,"|",0);
			if (document.getElementById("resIdz"+i)) rec_resId=document.getElementById("resIdz"+i).value;
			if (document.getElementById("locIdz"+i)) rec_locId=document.getElementById("locIdz"+i).value;
			//LOG 49241 RC 23/02/05 SAMS want to be able to add multiple services.
			var patid=top.frames["TRAK_main"].frames["RBApptFind"].document.getElementById("PatientID")
			serdesc=""
			if ((document.getElementById("serDescz"+i))&&(document.getElementById("serDescz"+i).innerText)) serdesc=document.getElementById("serDescz"+i).innerText
			var resflag=0
			if (resstr!=""&&rec_resId!=""&&resstr!=rec_resId) resflag=1
			if ((servstr==rec_serv)&&(resflag!=1)&&(patid.value!="")){
				alert(t['ServiceAlreadyAdded']+": "+serdesc)
				return;
			}
		}
		if (condition=="T") {
			if (condition2=="T") {
				if (document.getElementById("servListz"+i)) {
					if (document.getElementById("servListz"+i).checked==true) {
						if ((document.getElementById("schedlistz"+i).value!="")&&(document.getElementById("schedlistz"+i).value!=" ")&&(ApptAry[0]!="")&&(mainremove==false)) {
							for (var j=0; j<FieldAry.length; j++) {
								str=getFieldVal(FieldAry,j,i,str);
							}
							var addstr=document.getElementById("addStrz"+i).value
							if (addstr!="") {
								for (var a=0; mPiece(addstr,"@",a)!=""; a++) {
									addrow=mPiece(addstr,"@",a)
									if (mPiece(addrow,"*",0)==ApptAry[0]) {addrow=""; addfound=true;}
									if ((tmpstr!="")&&(addrow!="")) tmpstr=tmpstr+addrow+"@"
									if ((tmpstr=="")&&(addrow!="")) tmpstr=addrow+"@"
								}
								if (tmpstr!="") {
									if (addfound==true) {addstr=tmpstr} else {addstr=tmpstr+ApptAry[0]+delim+ApptAry[4]+delim+ApptAry[5]+delim+ApptAry[6]+delim+ApptAry[18]+delim+ApptAry[19]+delim+ApptAry[20]+delim+ApptAry[28]+delim+ApptAry[38]+delim+ApptAry[40]+"@";}
								}
								if (tmpstr=="") {
									if (addfound==true) {addstr=tmpstr} else {addstr=tmpstr+ApptAry[0]+delim+ApptAry[4]+delim+ApptAry[5]+delim+ApptAry[6]+delim+ApptAry[18]+delim+ApptAry[19]+delim+ApptAry[20]+delim+ApptAry[28]+delim+ApptAry[38]+delim+ApptAry[40]+"@";}
								}
							}
							if ((addstr=="")&&(addfound==false)) addstr=ApptAry[0]+delim+ApptAry[4]+delim+ApptAry[5]+delim+ApptAry[6]+delim+ApptAry[18]+delim+ApptAry[19]+delim+ApptAry[20]+delim+ApptAry[28]+delim+ApptAry[38]+delim+ApptAry[40]+"@";
						} else {
							if (ApptAry[0]=="") ApptAry[0]=" ";
							//alert(FieldAry.length+"^"+ApptAry.length)
							for (var j=0; j<FieldAry.length; j++) {
								if ((ApptAry.length-1>=j) && (ApptAry[j]!="")) {
									if (ApptAry[j].indexOf("&")!=-1) ApptAry[j]=ApptAry[j].replace("&","|||amp|||"); //log 65146 issue with ampersand & in service description
									//if (ApptAry[j].indexOf("&")!=-1) ApptAry[j]=encodeURIComponent(ApptAry[j]);
									str=str + ApptAry[j] + delim;
								} else {
									str=getFieldVal(FieldAry,j,i,str);
								}
							//	alert (str)
							}
							var addstr=document.getElementById("addStrz"+i).value;
							if (mulSelLst!="") {
								for (var a=0; mPiece(mulSelLst,"z",a)!=""; a++) {
									tmpstr=tmpstr+mPiece(mulSelLst,"z",a)+delim+""+delim+""+delim+""+delim+ApptAry[18]+delim+ApptAry[19]+delim+""+delim+""+delim+ApptAry[38]+delim+ApptAry[40]+"@";
								}
								addstr=tmpstr;
							}
						}
					} else {
						for (var j=0; j<FieldAry.length; j++) {
							str=getFieldVal(FieldAry,j,i,str);
						}
						var addstr=document.getElementById("addStrz"+i).value;
					}
					str=str+document.getElementById("servListz"+i).checked+"$$"+addstr+"^"
				}
			}
		} else {
			if (document.getElementById("servListz"+i)) {
				for (var j=0; j<FieldAry.length; j++) {
					str=getFieldVal(FieldAry,j,i,str);
				}
				var addstr=document.getElementById("addStrz"+i).value;
				str=str+document.getElementById("servListz"+i).checked+"$$"+addstr+"^"
			}
		}
	}
	//Log 30495 To allow for multiple careproviders- need to add a new line if another CP is chosen
    if ((Mode=="Update")&&(!found)) {
		ApptAry[9]=fser;
    	ApptAry[12]=fpayid;
    	ApptAry[13]=fplanid;
    	ApptAry[7]=websys_escape(fpay);
    	ApptAry[8]=websys_escape(fplan);
    	ApptAry[21]=finte;
    	ApptAry[22]=ftrans;
    	ApptAry[24]=fireq;
    	ApptAry[25]=ftreq;
    	var AddRowStr=ApptAry.join(delim);
    	str=str+ AddRowStr;
    }
	if (Mode=="Add") str=str + NewRowStr;
	//alert(NewRowStr);
	if (str!="") {
		var stripstr=str.split('"');
		str=stripstr.join("___");
	}
	var obj= document.getElementById("CONTEXT")
	if (obj) context=obj.value;
	//alert(str);
	//var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.ServiceList&tblStr=" + escape(str) + "&doFind=" + doFind;
	//do not escape str because it has problems with thai, need to break up pieces and escape where control characters are and websys_escape where desc are passed
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.ServiceList&tblStr=" + str + "&doFind=" + doFind +"&CONTEXT="+context;
    top.frames["TRAK_main"].frames["RBServList"].location=lnk;

	if (Mode=="Delete") {
		//Clear Appointment List Table
		parent.frames["RBApptList"].location="websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.ApptList&TWKFL=&TWKFLI=";
	}
   }
}

function getFieldVal(FieldAry,j,i,str) {
	var Field=mPiece(FieldAry[j],",",0)
	var val=mPiece(FieldAry[j],",",1)
	var FieldVal=""
	if ((document.getElementById(Field+"z"+i))) {
		if (val==0) {
			//alert(document.getElementById(Field+"z"+i).value);
            if (Field=="comment") {
				str=str + websys_escape(document.getElementById(Field+"z"+i).value) + delim;
			} else {
				str=str + document.getElementById(Field+"z"+i).value + delim;
			}
            		//alert(str+"+"+1);
		} else {
			if (document.getElementById(Field+"z"+i).type=="checkbox") {
				FieldVal="0"
				if (document.getElementById(Field+"z"+i).checked) FieldVal="1"
			} else {
				FieldVal=document.getElementById(Field+"z"+i).innerText
			}
			if (Field=="locDesc") {
				if (FieldVal.indexOf("&")!=-1) FieldVal=FieldVal.replace("&","|||amp|||");
			}
			if ((Field=="payDesc")||(Field=="planDesc")||(Field=="serDesc")) {
				FieldVal=websys_escape(FieldVal);
			}
			if (Field=="Price") {
				FieldVal=document.getElementById("itemPricez"+i).value;
			}
			//alert(document.getElementById(Field+"z"+i).innerText);
            str=str + FieldVal + delim;
		}
	} else {
		str=str + delim;
		//alert(str+"+"+3);
	}
	return str;
}

function mPiece(s1,sep,n) {
    //Split the array with the passed delimeter
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
}

function Debug(fName,vName,Str) {
// fName - Function Name
// vName - Variable Name
// Str   - Dump Str
	if (debug=="Y") {
		top.frames["TRAK_hidden"].document.writeln("<BR>")
		top.frames["TRAK_hidden"].document.writeln(fName+": "+vName+" - "+Str)
	}
}

//LOG 31208 BC 4-2-2003 Change to the overbooking workflow.  Need to pass all the parameter.  NB. mush add new parameters
// to the end of the link and then process them in RBAppointment.EditServiceList.js.

function CareProviderLinkBuilder() {
	var tbl=document.getElementById("tRBAppointment_ServiceList");
	//var delim=String.fromCharCode(2);
	for (var i=1;i<tbl.rows.length;i++) {
		//64807 RC 25/09/07 Removed this so the schedule calendar will display properly if no resource selected. Lets hope it doesn't break anything...
		if (document.getElementById("schedlistz"+i)) {
			var serId = mPiece(document.getElementById("serIdz"+i).value,"|",0)
			var serarray=serId.split("|");
			var locId = document.getElementById("locIdz"+i).value
			var locobj=document.getElementById("locDescz"+i)
			if (locobj) {
				var locDesc = document.getElementById("locDescz"+i).innerText; if (locDesc==" ") locDesc="";
			} else {locDesc=""}
			var resId = document.getElementById("resIdz"+i).value
			var payId = document.getElementById("payIdz"+i).value
			var planId = document.getElementById("planIdz"+i).value
			var payor=""; var obj = document.getElementById("payDescz"+i)
			if (obj) payor = obj.innerHTML
			var plan = ""; var obj = document.getElementById("planDescz"+i)
			if (obj) plan = obj.innerHTML
			var obreason = document.getElementById("obreasonz"+i).value
			var main = mPiece(document.getElementById("serIdz"+i).value,"|",1)
			var nodays = mPiece(document.getElementById("serIdz"+i).value,"|",2)
			var urgent = document.getElementById("urgentIDz"+i).value
			var duration = document.getElementById("durationIDz"+i).value
			//LOG 43315 RC 13/09/04 Add Hospital and Health Care area to Calendar
			var HCAID=document.getElementById("HCARowIDz"+i).value
			var hospIDs=document.getElementById("HospIDsz"+i).value
			//Log 31104 RC 22/01/03
			var obj = document.getElementById("Transportz"+i)
			if (obj) var transport=obj.innerHTML
			var obj = document.getElementById("Interpreterz"+i)
			if (obj) var interpreter=obj.innerHTML
			var obj = document.getElementById("TransReqz"+i)
			if (obj) var trareq=obj.value
			var obj = document.getElementById("IntReqz"+i)
			if (obj) var intreq=obj.value
			var obj=document.getElementById("datez"+i)
			if (obj) var date=obj.innerHTML
			var obj=document.getElementById("timez"+i)
			if (obj) var time=obj.innerHTML
			var stype=document.getElementById("sesstypez"+i).value;
			var disint=document.getElementById("disIntz"+i).value;
			var distrans=document.getElementById("disTransz"+i).value
			var serDesc=""; var QLDOutChk=""
			var obj=document.getElementById("serDescz"+i)
			if (obj) serDesc=obj.innerHTML
			var obj=document.getElementById("QLDOutChkz"+i)
			if (obj) QLDOutChk=obj.value
			//TWKFL=475&TWKFLI=1
			//alert("rbcalendar.multi.csp?RescID="+resId+"&CTLOCDesc="+locDesc+"&ServID="+serId+"&serv="+serDesc)
			var lnk="rbcalendar.multi.csp?RescID="+resId+"&CTLOCDesc="+locDesc+"&ServID="+serId+"&serv="+serDesc+"&HCAId="+HCAID+"&HospIds="+hospIDs+"&QLDOutChk="+QLDOutChk;
			//lnk=lnk+"&OBParam="+locId+delim+resId+delim+serId+delim+payId+delim+planId+delim+payor+delim+plan+delim+obreason+delim+main+delim+nodays+delim+urgent+delim+duration+delim+transport+delim+interpreter+delim+date+delim+time+delim+stype+delim+trareq+delim+intreq+delim+disint+delim+distrans;
			//alert(lnk);
			// LOG 44102 RC 02/07/04 if date and time are already populated, disable links on calander page by removing TWKFL and TWKFLI
			if (((date=="")||(date=="&nbsp;"))&&((time=="")||(time=="&nbsp;"))){
				lnk=lnk+"&OBParam="+i+"&TWKFL=475&TWKFLI=1"
			} else {
				lnk=lnk+"&OBParam="+i
			}
			var obj=document.getElementById("resDescz"+i);
			if (obj) {
				//alert(obj.outerHTML);
				var innertxt=obj.innerHTML
				//alert(innertxt);
				//var url="<A id=resDescz"+i+" name=resDescz"+i+" HREF="+'"'+"#"+'"'+" onClick="+'"'+"websys_lu('"+lnk+"',false,'top=10,left=10,height=500,width=500');"+'"'+" >"+innertxt+'</A>';
				var url="<A id=resDescz"+i+" name=resDescz"+i+" HREF="+'"'+"#"+'"'+" onClick="+'"'+"RBEditWindow=websys_createWindow('"+lnk+"','frmEditServiceList','top=10,left=10,height=500,width=500,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes');"+'"'+" >"+innertxt+'</A>';
				//alert(url);
				obj.outerHTML=url;
			}
			//LOG 43315 RC 03/08/04 Add a Schedule Calendar link for QLD
			var obj=document.getElementById("ScheduleCalendarz"+i);
			if (obj) {
				var url="<A id=ScheduleCalendarz"+i+" name=ScheduleCalendarz"+i+" HREF="+'"'+"#"+'"'+" onClick="+'"'+"RBEditWindow=websys_createWindow('"+lnk+"','frmEditServiceList','top=10,left=10,height=500,width=500,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes');"+'"'+" >"+t["Cal"]+"</A>";
				obj.outerHTML=url;
			}
		}
	}
	return false;
}

//LOG 43413 RC 23/07/04 Sams wanted to be able to add different patients to different appointments in the same booking.
function AddPatientClickHandler(evt) {
	var eSrc = websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc = websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");
	var row=eSrcAry[eSrcAry.length-1];

	var Rowobj=document.getElementById("RowNumber")
	if (Rowobj) Rowobj.value=row;

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=PAPerson.Find&returnSelected=1";
	websys_lu(lnk,false,'width=600, height=400');
	return false;
}

//Log 30495 To allow for multiple careproviders
function CompareStrings(str1,str2) {
	var str1ary=str1.split(" ");
	var str1a=str1ary.join("");
	var str2ary=str2.split(" ");
	var str2a=str2ary.join("");
	if (str1a!=str2a) return false;
	return true;
}

document.body.onload = DocumentLoadHandler;
