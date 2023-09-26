// Copyright (c) 2000 TRAK Systems Pty. ALL RIGHTS RESERVED.
var debug="N"  //"Y" = alerts and stuff, "N" = alert free

function DocumentLoadHandler() {
	assignChkHandler()
	/*
	if (parent.frames["RBServList"]) {
		var Servdoc=parent.frames["RBServList"].document;
		var sertbl=Servdoc.getElementById("tRBAppointment_ServiceList");
		var schedlist=""
		for (var i=1;i<sertbl.rows.length;i++) {
			if (Servdoc.getElementById("schedlistz"+i)) schedlist=schedlist+Servdoc.getElementById("schedlistz"+i).value+"^"
			if (Servdoc.getElementById("addStrz"+i)) {
				for (var ii=0; mPiece(Servdoc.getElementById("addStrz"+i).value,"@",ii)!=""; ii++) {
					var addstr=mPiece(Servdoc.getElementById("addStrz"+i).value,"@",ii)
					schedlist=schedlist+mPiece(addstr,"*",0)+"^"
				}
			}
		}
		var tbl=document.getElementById("tRBAppointment_ApptList");
		for (var i=1;i<tbl.rows.length;i++) {
			//if (mPiece(schedlist,"^",0)!="") {
				var ID=document.getElementById("IDz"+i).value
				if (schedlist.indexOf(ID)!=-1) document.getElementById("chkz"+i).checked=true;
			//}
		}
	}
	*/
}

//  cjb 01/11/2005 52820 - this is called from PAPerson.List.js when opened in a new window.  Go through all the checked rows and re-set the locks for each
function KeepLock() {
	var tbl=document.getElementById("tRBAppointment_ApptList");
	for (var i=1;i<tbl.rows.length;i++) {
		var obj=document.getElementById("chkz"+i)
		if ((obj)&&(obj.checked)) {
			var lnk = "rbappointment.blockschedule.csp?scheduleID="+document.getElementById("IDz"+i).value+"&checked=1&rowid="+i+"&row="+"chkz"+i+"&KeepLock=1"
			websys_createWindow(lnk,"TRAK_hidden");
		}
	}
}

function assignChkHandler(schedlist) {
	var tbl=document.getElementById("tRBAppointment_ApptList");
	for (var i=1;i<tbl.rows.length;i++) {
		var obj=document.getElementById("chkz"+i)
		if (obj) {
				obj.onclick = lockcheckhandler;
		}
	}
	return;
}

//LOG 43413 RC 30/07/04 Had to make this locking stuff occur before the check handler so it wouldn't actually change the
//middle frame if the slot was locked. Funnily enough this ended up making it SO much easier...
function lockcheckhandler(e) {
	var obj=websys_getSrcElement(e);
	var rowid=obj.id
	var rowAry=rowid.split("z");

	if (document.getElementById("chkz"+rowAry[1]).checked) {
		//LOG 43413 RC 29/07/04 Call csp to lock schedID before doing click handler.
		var lnk = "rbappointment.blockschedule.csp?scheduleID="+document.getElementById("IDz"+rowAry[1]).value+"&checked=1&rowid="+rowAry[1]+"&row="+rowid
		websys_createWindow(lnk,"TRAK_hidden");
	} else {
		var lnk = "rbappointment.blockschedule.csp?scheduleID="+document.getElementById("IDz"+rowAry[1]).value+"&checked=0&rowid="+rowAry[1]+"&row="+rowid
		websys_createWindow(lnk,"TRAK_hidden");
	}
}


function chkClickHandler(row) {
	//alert(row);
	//var obj=websys_getSrcElement(row);
	//var rowid=obj.id
	//debugger;
	var rowAry=row.split("z");
	//Log 32534 Warn that more than one appointment has been made for a radiology order
	var radrestrict=document.getElementById("RestrictRad");
	//Log 53841 Allow User to book overlapping appointments if configured in System Params
	var BookOverLapping=document.getElementById("BookOverLapping");
	var oeoriID=top.frames["TRAK_main"].frames["RBApptFind"].document.getElementById("oeoriID");
	var NoSelectMultiRow=document.getElementById("NoSelectMultiRow"); //RC LOG 47855 20/12/04

	//Log 31104 RC 22/01/03
	/*var ServListFrame=top.frames["TRAK_main"].frames["RBServList"]
   	if (ServListFrame) {
		var intobj=top.frames["TRAK_main"].frames["RBServList"].document.getElementById("Interpreterz"+rowAry[1]);
		var transobj=top.frames["TRAK_main"].frames["RBServList"].document.getElementById("Transportz"+rowAry[1]);
		var intreqobj=top.frames["TRAK_main"].frames["RBServList"].document.getElementById("IntReqz"+rowAry[1]);
		var trareqobj=top.frames["TRAK_main"].frames["RBServList"].document.getElementById("TransReqz"+rowAry[1]);
		var disintobj=top.frames["TRAK_main"].frames["RBServList"].document.getElementById("disIntz"+rowAry[1]);
		var distraobj=top.frames["TRAK_main"].frames["RBServList"].document.getElementById("disTransz"+rowAry[1]);
		if (intobj) var interpreter=intobj.innerHTML;
		if (transobj) var transport=transobj.innerHTML;
		if (intreqobj) var intreq=intreqobj.value;
		if (trareqobj) var trareq=trareqobj.value;
		if (disintobj) var disint=disintobj.value;
		if (distraobj) var distra=distraobj.value;
	}*/
	//Log 35272 BC 29-4-2003 Allowing for linked resource appointments
	var linkedCP=false;
	if (top.frames["TRAK_main"].frames["RBApptFind"].document.getElementById("LinkFlag")) linkedCP=top.frames["TRAK_main"].frames["RBApptFind"].document.getElementById("LinkFlag").checked;
	//31104 BR if we pass through the Trans Int that was there on the search, will override and changes
	//made via the editservicelist.
	/*var interpreter=document.getElementById("Interpreterz"+rowAry[1]).value;
	var transport=document.getElementById("Transportz"+rowAry[1]).value;
	var intreq=document.getElementById("IntReqz"+rowAry[1]).value;
	var trareq=document.getElementById("TransReqz"+rowAry[1]).value;
	var disint=document.getElementById("disIntz"+rowAry[1]).value;
	var distra=document.getElementById("disTransz"+rowAry[1]).value;*/
	var stype=""; if (document.getElementById("SessionTypez"+rowAry[1])) {
		stype=document.getElementById("SessionTypez"+rowAry[1]).innerHTML;
		if (stype='&nbsp;') stype="";
	}
	//End Log 31104

	// LOG 45545 RC 03/08/04 Multiple Appointments made at same time.
	var serdoc=top.frames["TRAK_main"].frames["RBServList"].document
	var serlist=serdoc.getElementById("tRBAppointment_ServiceList");
	if (serlist) serRowLen=serlist.rows.length;
	var applocid=document.getElementById("LocIdz"+rowAry[1]).value
	var appresid=document.getElementById("ResIdz"+rowAry[1]).value
	var appserid=document.getElementById("SerIdz"+rowAry[1]).value
	var appttime=document.getElementById("cTimez"+rowAry[1]).value
	var apptdate=document.getElementById("cDatez"+rowAry[1]).value
	var apptST=document.getElementById("HiddenSessTypeIDz"+rowAry[1]).value
	var flags=document.getElementById("flagsz"+rowAry[1]).value
	var serRowId="";
	for (var j=1; j<serRowLen; j++) {
		var serlocid=serdoc.getElementById("locIdz"+j);
		var serresid=serdoc.getElementById("resIdz"+j);
		var serserid=serdoc.getElementById("serIdz"+j);
		var serdesc=serdoc.getElementById("serDescz"+j);
		var serdate=serdoc.getElementById("datez"+j);
		if ((serdate)&&(serdate.innerHTML=='&nbsp;')) serdate.innerHTML="";
		var sertime=serdoc.getElementById("timez"+j);
		if ((sertime) && (sertime.innerHTML=='&nbsp;')) sertime.innerHTML="";
		var serschedlst=serdoc.getElementById("schedlistz"+j);
		var serdur=serdoc.getElementById("Durationz"+j);
		var serpat=serdoc.getElementById("RegistrationNoz"+j);
		var serST=serdoc.getElementById("sesstypez"+j);
		var check=serdoc.getElementById("servListz"+j);
		if (((check)&&(check.checked==true))&&((serserid)&&((mPiece(serserid.value,"|",0)==appserid)))) {
			serRowId=j;
			var multi="";
			var multiobj=serdoc.getElementById("NoOfSessz"+serRowId);
			if (multiobj) multi=multiobj.innerHTML
			if ((multi=="")||(multi=='&nbsp;')) multi=document.getElementById("mselect").value;
			if ((serlocid.value==applocid)&&(serresid.value==appresid)&&(serschedlst.value!="")) {
				if ((multi!="")&&(serST.value!=apptST)&&(multi!=1)) {
					alert(t["MSsessType"]);
					document.getElementById("chkz"+rowAry[1]).checked=false;
					return false;
				}
				if ((NoSelectMultiRow)&&(NoSelectMultiRow.value==1)) {
					if (document.getElementById("chkz"+rowAry[1]).checked==true) {
						if (((serdate.innerHTML!="") && (sertime.innerHTML!=""))) {
							alert(t["NoBookMultiAppt"]);
							document.getElementById("chkz"+rowAry[1]).checked=false;
							return false
						}
					}
				}
			}
		}
		if (document.getElementById("chkz"+rowAry[1]).checked) {
			if (mPiece(flags,"^",0)!=0) {
				if (mPiece(flags,"^",0)==61) {
					alert(t["NoApptPayor"]);
					document.getElementById("chkz"+rowAry[1]).checked=false;
					return false
				} else if (mPiece(flags,"^",0)==62) {
					if (!confirm(t["WarnApptPayor"])) {
						document.getElementById("chkz"+rowAry[1]).checked=false;
						return false;
					}
				}
			}
		}
		if (apptdate=="") {
			for (var k=rowAry[1]; k>0; k--) {
				apptdate=document.getElementById("cDatez"+k).value
				if (apptdate!="") {break;}
			}
		}
		var apptdesc=mPiece(document.getElementById("detailsz"+rowAry[1]).value,"^",0)
		if (apptdesc=="") {
			for (var k=rowAry[1]; k>0; k--) {
				apptdesc=mPiece(document.getElementById("detailsz"+k).value,"^",0)
				if (apptdesc!="") {break;}
			}
		}
		if ((document.getElementById("chkz"+rowAry[1]).checked)&&(BookOverLapping.value!="Y")) {
			if ((!serpat)||((serpat)&&((serpat.innerHTML=="&nbsp;")||(serpat.innerHTML=="")))) {
				if ((serdesc)&&(serdate)&&(sertime)&&(serdur)) {
					var difference=DateTimeDiffInHM(serdate.innerHTML,sertime.innerHTML,apptdate,appttime);
					var difmin=(difference["hr"]*60)+(difference["mn"])
					if (difmin<parseInt(serdur.innerHTML)) {
						alert(apptdesc+" "+t["CannotBook"]);
						document.getElementById("chkz"+rowAry[1]).checked=false;
						return false;
					}
				}
			}
		}
	}

	//alert("interpreter="+interpreter+"+transport="+transport+"+disint="+disint+"+distra="+distra+"+intreq="+intreq+"+trareq="+trareq);

	if (parent.ServReady==1) {
		parent.ServReady=0
		var tblApptList=document.getElementById("tRBAppointment_ApptList");
		//var multi=document.getElementById("mselect");
		var schedID = document.getElementById("IDz"+rowAry[1]).value
		var servID = document.getElementById("SerIdz"+rowAry[1]).value
		var duration=""
		var price=""
		//var duration = document.getElementById("Durationz"+rowAry[1]).innerHTML
		//var price = document.getElementById("Pricez"+rowAry[1]).value
		var obj = document.getElementById(row)
		var ApptStr=tkMakeServerCall("web.RBApptSchedule","GetServiceRowStr",obj.checked,schedID,servID,duration+"^"+price);

		var rowLen=tblApptList.rows.length;

		//Log 23514 BC 30-5-2002 Enable the multiselect feature to match the VB code
		// Only perform on the first selected appointment
		var howmanyrowschked=howManyChked(rowLen);
		if (howmanyrowschked==1) {}
		var mulSelLst="";
		if (multi!="" && multi!="undefined") {
			//alert(multi+"-"+serRowId);
			var mulSelLst=multiselectHandler(rowAry[1],rowLen,multi,serRowId);
			var mslCnt=mPiece(mulSelLst,"^",1); var mulSelLst=mPiece(mulSelLst,"^",0);
		}

		var finddoc=top.frames["TRAK_main"].frames["RBApptFind"].document
		if (finddoc) {
			var obj=finddoc.getElementById("bestplan")
			if (obj) {
				if (howmanyrowschked>0) {
					obj.disabled=false
					obj.onclick=bestplan;
				} else {
					obj.disabled=true
					obj.onclick="";
				}
			}
		}

		//Log 36001 Warn if the same service is chosen for the same careprovider on the same day
		var warnobj=document.getElementById("WarnSDSCL")
		if ((warnobj)&&(warnobj.value=="Y")&&(howmanyrowschked>1)) {WarnIfSameDayService(rowLen);}

		var chkbox="";
		var SchedId="";
		var ServDesc="";
		var LocDesc="";
		var ResDesc="";
		var DayDesc="";
		var DateDesc="";
		var TimeDesc="";
		var DurationOfService="";
		var Price="";
		var ResId="";
		var LocId="";
		var dServDesc="";
		var dLocDesc="";
		var dResDesc="";
		var dResId="";
		// Log 37518 BC 9-9-2003 Add HCA and Hospitals to Edit Service List
		var dHCARowID="";
		var dHCADesc="";
		var dHOSPDesc="";
		var dHospIDs="";
		var ServId="";
		var dLocId="";
		var ConsultCateg=""
		// Log 43413 RC 26/07/04 Added PatientNos To Service List
		var dPatNos="";
		//debugger;
		var HCADescobj=top.frames["TRAK_main"].frames["RBServList"].document.getElementById("HCADescz"+rowAry[1]);
		var HCARowIDobj=top.frames["TRAK_main"].frames["RBServList"].document.getElementById("HCARowIDz"+rowAry[1]);
		var HOSPDescobj=top.frames["TRAK_main"].frames["RBServList"].document.getElementById("HOSPDescz"+rowAry[1]);
		var HospIDsobj=top.frames["TRAK_main"].frames["RBServList"].document.getElementById("HospIDsz"+rowAry[1]);
		var PatNoobj=top.frames["TRAK_main"].frames["RBServList"].document.getElementById("RegistrationNoz"+rowAry[1]);
		var ServId=mPiece(document.getElementById("HIDDENz"+rowAry[1]).value,"^",1)
		var NoSelectMultiRow=document.getElementById("NoSelectMultiRow").value
		var ConsultCateg=serdoc.getElementById("ConsultCategz"+serRowId).value;
		if (HCADescobj) dHCADesc=HCADescobj.innerHTML
		if (dHCADesc=='&nbsp;') dHCADesc="";
		if (HCARowIDobj) dHCARowID=HCARowIDobj.value
		if (HOSPDescobj) dHOSPDesc=HOSPDescobj.innerHTML
		if (dHOSPDesc=='&nbsp;') dHOSPDesc="";
		if (HospIDsobj) dHospIDs=HospIDsobj.value
		if (PatNoobj) dPatNos=PatNoobj.innerHTML
		if (dPatNos=='&nbsp;') dPatNos="";
		var numberChkd=0;

		//RC This was totally rewritten for LOG 49241. If it doesn't work, I have the old script on my PC for comparison or copy/pasting ;)
		if (rowAry[1]!="") {
			if ((document.getElementById("chkz"+rowAry[1]).checked) && (linkedCP ||(mPiece(mPiece(document.getElementById("HIDDENz"+rowAry[1]).value,"^",0),"||",0)==mPiece(mPiece(document.getElementById("HIDDENz"+rowAry[1]).value,"^",0),"||",0)))) {
				if ((multi>1)&&(mulSelLst=="")&&(mslCnt+1>multi)) {
					alert(t['moreMS']);
					document.getElementById("chkz"+rowAry[1]).checked=false;
					parent.ServReady=1
					return false;
				}
				SchedId=mPiece(document.getElementById("HIDDENz"+rowAry[1]).value,"^",0)
				if (mulSelLst!="") SchedId=SchedId+"z"+mulSelLst;
				stype=document.getElementById("HiddenSessTypeIDz"+rowAry[1]).value
				for (var j=rowAry[1]; j>0; j--) {
					var details=document.getElementById("detailsz"+j).value
					if ((mPiece(details,"^",0)!="")&&(ServDesc=="")) { ServDesc = mPiece(details,"^",0) }
					if ((mPiece(details,"^",1)!="")&&(LocDesc=="")) {
						LocDesc = mPiece(details,"^",1);
						if (LocDesc.indexOf("&")!=-1) LocDesc=LocDesc.replace("&","|||amp|||");
					}
					if ((mPiece(details,"^",2)!="")&&(ResDesc=="")) { ResDesc = mPiece(details,"^",2) }
					if ((mPiece(details,"^",3)!="")&&(DayDesc=="")) { DayDesc = mPiece(details,"^",3) }
					if ((mPiece(details,"^",4)!="")&&(DateDesc=="")) { DateDesc = mPiece(details,"^",4) }
					if ((mPiece(details,"^",5)!="")&&(TimeDesc=="")) { TimeDesc = mPiece(details,"^",5) }
					if ((mPiece(details,"^",6)!="")&&(DurationOfService=="")) { DurationOfService = mPiece(details,"^",6) }
					if ((mPiece(details,"^",7)!="")&&(Price=="")) { Price= mPiece(details,"^",7) }
					if ((document.getElementById("ResIdz"+rowAry[1]))&&(ResId==""))  {ResId=document.getElementById("ResIdz"+rowAry[1]).value;}
					if ((document.getElementById("LocIdz"+rowAry[1]))&&(LocId==""))  {LocId=document.getElementById("LocIdz"+rowAry[1]).value;}
					if ((ServDesc!="")&&(LocDesc!="")&&(ResDesc!="")&&(DayDesc!="")&&(DateDesc!="")&&(TimeDesc!="")&&(DurationOfService!="")) { break }
				}
				//RC making sure the counts add up
				if ((multi>1)&&(mulSelLst=="")&&(mslCnt<multi)) mslCnt=parseInt(mslCnt)+1;
				var servCnt=serdoc.getElementById("multiSelCntz"+serRowId).value;
				if ((mslCnt<multi)&&(parseInt(mslCnt)+parseInt(servCnt)==multi)) mslCnt=multi;
			} else {
				//BR 31940. Added extra check to IF statement so that it checks Resource is the same as well as service.
				//Log 35272 BC 29-4-2003 Allowing for linked resource appointments
				//Log 32534 Warn that more than one appointment has been made for a radiology order
				if ((radrestrict.value=="Y") && (oeoriID.value!="")) {
					var procede=confirm(t["MoreThanOneAppointment"]);
					if (!procede) {
						//for (var ii=1; ii<rowLen; ii++) {
							document.getElementById("chkz"+rowAry[1]).checked=false;
						//}
						var url=parent.location;
						parent.location=url;
						//alert(parent.location);
						return;
					} else {radrestrict.value=="N"}
				}
				var stillchecked=0;
				var stillchecked=tkMakeServerCall("web.RBApptSchedule","IsServiceData",appserid)
				/*for (var j=1; j<rowLen; j++) {
					if ((document.getElementById("chkz"+j).checked) && (mPiece(document.getElementById("HIDDENz"+j).value,"^",1)==mPiece(document.getElementById("HIDDENz"+rowAry[1]).value,"^",1)) && (linkedCP ||(mPiece(mPiece(document.getElementById("HIDDENz"+j).value,"^",0),"||",0)==mPiece(mPiece(document.getElementById("HIDDENz"+rowAry[1]).value,"^",0),"||",0)))) {
						stillchecked=true; break;
					}
				}*/
				if (stillchecked==0) {
					var details=document.getElementById("detailsz"+rowAry[1]).value
					if ((mPiece(details,"^",0)!="")&&(dServDesc=="")) { dServDesc =mPiece(details,"^",0) }
					if ((mPiece(details,"^",1)!="")&&(dLocDesc=="")) { dLocDesc = mPiece(details,"^",1)}
					if ((mPiece(details,"^",2)!="")&&(dResDesc=="")) { dResDesc = mPiece(details,"^",2)}
					if ((document.getElementById("ResIdz"+rowAry[1]))&&(dResId=="")) {dResId=document.getElementById("ResIdz"+rowAry[1]).value;}
					if ((document.getElementById("LocIdz"+rowAry[1]))&&(dLocId=="")) {dLocId=document.getElementById("LocIdz"+rowAry[1]).value;}
					if ((NoSelectMultiRow)&&(NoSelectMultiRow.value==1)) {
						//RC LOG 47855 20/12/04 SAMS want to be able to blank out the resource, so we did it only if they
						//are using that paramenter.
						dResDesc=" "; dResId="";
					}
				} else {
					SchedId=mPiece(document.getElementById("HIDDENz"+rowAry[1]).value,"^",0)
					if (mulSelLst!="") SchedId=SchedId+"z"+mulSelLst;
					stype=document.getElementById("HiddenSessTypeIDz"+rowAry[1]).value
					for (var j=rowAry[1]; j>0; j--) {
						var details=document.getElementById("detailsz"+j).value
						if ((mPiece(details,"^",0)!="")&&(ServDesc=="")) { ServDesc = mPiece(details,"^",0) }
						if ((mPiece(details,"^",1)!="")&&(LocDesc=="")) {
							LocDesc = mPiece(details,"^",1);
							if (LocDesc.indexOf("&")!=-1) LocDesc=LocDesc.replace("&","|||amp|||");
						}
						if ((mPiece(details,"^",2)!="")&&(ResDesc=="")) { ResDesc = mPiece(details,"^",2) }
						if ((mPiece(details,"^",3)!="")&&(DayDesc=="")) { DayDesc = mPiece(details,"^",3) }
						if ((mPiece(details,"^",4)!="")&&(DateDesc=="")) { DateDesc = mPiece(details,"^",4) }
						if ((mPiece(details,"^",5)!="")&&(TimeDesc=="")) { TimeDesc = mPiece(details,"^",5) }
						if ((mPiece(details,"^",6)!="")&&(DurationOfService=="")) { DurationOfService = mPiece(details,"^",6) }
						if ((mPiece(details,"^",7)!="")&&(Price=="")) { Price= mPiece(details,"^",7) }
						if ((document.getElementById("ResIdz"+rowAry[1]))&&(ResId==""))  {ResId=document.getElementById("ResIdz"+rowAry[1]).value;}
						if ((document.getElementById("LocIdz"+rowAry[1]))&&(LocId==""))  {LocId=document.getElementById("LocIdz"+rowAry[1]).value;}
						if ((ServDesc!="")&&(LocDesc!="")&&(ResDesc!="")&&(DayDesc!="")&&(DateDesc!="")&&(TimeDesc!="")&&(DurationOfService!="")) { break }
					}
				}
				/*for (var j=rowLen-1; j>0; j--) {
					var details=document.getElementById("detailsz"+rowAry[1]).value
					if ((document.getElementById("chkz"+j).checked) && (mPiece(document.getElementById("HIDDENz"+j).value,"^",1)==mPiece(document.getElementById("HIDDENz"+rowAry[1]).value,"^",1)) && (linkedCP ||(mPiece(mPiece(document.getElementById("HIDDENz"+j).value,"^",0),"||",0)==mPiece(mPiece(document.getElementById("HIDDENz"+rowAry[1]).value,"^",0),"||",0)))) {
						alert("else if");
						SchedId=mPiece(document.getElementById("HIDDENz"+rowAry[1]).value,"^",0)
						//SchedId=mPiece(document.getElementById("HIDDENz"+rowAry[1]).value,"^",0)+"z"+mulSelLst;
						//rowAry[1]=j;
						for (var jj=j; jj>0; jj--) {
							var details=document.getElementById("detailsz"+jj).value
							//alert(details);
							if ((mPiece(details,"^",0)!="")&&(ServDesc=="")) { ServDesc = mPiece(details,"^",0) }
							if ((mPiece(details,"^",1)!="")&&(LocDesc=="")) {
								LocDesc = mPiece(details,"^",1);
								if (LocDesc.indexOf("&")!=-1) LocDesc=LocDesc.replace("&","|||amp|||");
							}
							if ((mPiece(details,"^",2)!="")&&(ResDesc=="")) { ResDesc = mPiece(details,"^",2) }
							if ((mPiece(details,"^",3)!="")&&(DayDesc=="")) { DayDesc = mPiece(details,"^",3) }
							if ((mPiece(details,"^",4)!="")&&(DateDesc=="")) { DateDesc = mPiece(details,"^",4) }
							if ((mPiece(details,"^",5)!="")&&(TimeDesc=="")) { TimeDesc = mPiece(details,"^",5) }
							if ((mPiece(details,"^",6)!="")&&(DurationOfService=="")) { DurationOfService = mPiece(details,"^",6) }
							if ((mPiece(details,"^",7)!="")&&(Price=="")) { Price= mPiece(details,"^",7) }
							if ((document.getElementById("ResIdz"+jj))&&(ResId==""))  {ResId=document.getElementById("ResIdz"+jj).value;}
							if ((document.getElementById("LocIdz"+jj))&&(LocId==""))  {LocId=document.getElementById("LocIdz"+jj).value;}
						}
					} else {
						alert('else else');
						if ((mPiece(details,"^",0)!="")&&(dServDesc=="")) { dServDesc =mPiece(details,"^",0) }
						if ((mPiece(details,"^",1)!="")&&(dLocDesc=="")) { dLocDesc = mPiece(details,"^",1)}
						if ((mPiece(details,"^",2)!="")&&(dResDesc=="")) { dResDesc = mPiece(details,"^",2)}
						if ((document.getElementById("ResIdz"+rowAry[1]))&&(dResId=="")) {dResId=document.getElementById("ResIdz"+rowAry[1]).value;}
						if ((NoSelectMultiRow)&&(NoSelectMultiRow.value==1)) {
							//RC LOG 47855 20/12/04 SAMS want to be able to blank out the resource, so we did it only if they
							//are using that paramenter.
							dResDesc=" "; dResId="";
						}
					}
					if ((ServDesc!="")&&(LocDesc!="")&&(ResDesc!="")&&(DayDesc!="")&&(DateDesc!="")&&(TimeDesc!="")&&(DurationOfService!="")) { break }
				}*/
			}
		}
		if (ServDesc!="") {
			//alert(SchedId+"^"+ServDesc+"^"+LocDesc+"^"+ResDesc+"^"+DayDesc+"^"+DateDesc+"^"+TimeDesc+"^^^^"+LocId+"^"+ResId+"^^^^^^^"+DurationOfService+"^^^^^"+stype+"^^^^^^"+dHCADesc+"^"+dHCARowID+"^"+dHOSPDesc+"^"+dHospIDs+"^^^"+dPatNos+"^^^"+Price+"^^^"+mslCnt+"^"+ServId);     //"^^^^^"
			//31104 BR removed Transport and interrepter as they may have changed after then find was performed.
			//var ApptStr=SchedId+"^"+ServDesc+"^"+LocDesc+"^"+ResDesc+"^"+DayDesc+"^"+DateDesc+"^"+TimeDesc+"^^^^^"+ResId+"^^^^^^^"+DurationOfService+"^^ ^"+interpreter+"^"+transport+"^"+stype+"^"+intreq+"^"+trareq+"^"+disint+"^"+distra+"^"+dHCADesc+"^"+dHCARowID+"^"+dHOSPDesc+"^"+dHospIDs;
			//alert(SchedId)
			var ApptStr=SchedId+"^"+websys_escape(ServDesc)+"^"+websys_escape(LocDesc)+"^"+websys_escape(ResDesc)+"^"+websys_escape(DayDesc)+"^"+websys_escape(DateDesc)+"^"+websys_escape(TimeDesc)+"^^^^"+LocId+"^"+ResId+"^^^^^^^"+DurationOfService+"^^^^^"+stype+"^^^^^^"+websys_escape(dHCADesc)+"^"+dHCARowID+"^"+websys_escape(dHOSPDesc)+"^"+dHospIDs+"^^^"+dPatNos+"^^^"+Price+"^^^"+mslCnt+"^"+ServId+"^"+NoSelectMultiRow+"^^"+websys_escape(ConsultCateg);
		} else {
			var ApptStr=" ^"+websys_escape(dServDesc)+"^"+websys_escape(dLocDesc)+"^"+websys_escape(dResDesc)+"^ ^ ^ ^"+"^^^"+dLocId+"^"+dResId+"^^^^^^^ ^^"+stype+"^^^^^^^^^"+websys_escape(dHCADesc)+"^"+dHCARowID+"^"+websys_escape(dHOSPDesc)+"^"+dHospIDs+"^^^"+dPatNos+"^^^"+Price+"^^^"+mslCnt+"^"+ServId+"^"+NoSelectMultiRow+"^^"+websys_escape(ConsultCateg);
		}
		//alert(ApptStr);
		// Log 38692 BC 16-9-2003 Extra checking for waiting list preadmission
		var oktocontinue="";
		if (DateDesc!=""){ oktocontinue=CheckSelectedDateAgainstAdm(DateDesc);}
		if (oktocontinue!="N"){
			top.frames["TRAK_hidden"].document.writeln(ApptStr)
			parent.frames["RBServList"].Refresh("Update",obj,rowAry[1],ApptStr)
		} else {
			if (document.getElementById("chkz"+rowAry[1])) {
				document.getElementById("chkz"+rowAry[1]).checked=false
			}
			parent.ServReady=1
		}
	} else {
		if (document.getElementById("chkz"+rowAry[1])) {
			document.getElementById("chkz"+rowAry[1]).checked=false
		}
	}

	var obj=top.frames["TRAK_main"].frames["RBApptFind"].document.getElementById("PIN")
	if (obj) obj.focus()
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

function FindFirstDateTime() {
/*
FirstDay = ""
FirstDate = ""
FirstTime = ""
FirstLocation = ""
FirstResource = ""

For CountAppts = 1 To gApptsListTotal
    If (ServiceRowId = "") Or gApptsList(CountAppts).ServiceRowId = ServiceRowId Then
        If (FirstDate = "") Or (FirstDate > gApptsList(CountAppts).Date) Or ((FirstDate = gApptsList(CountAppts).Date) And (FirstTime > gApptsList(CountAppts).Time)) Then
            FirstDay = gApptsList(CountAppts).Day
            FirstDate = gApptsList(CountAppts).Date
            FirstTime = gApptsList(CountAppts).Time
            If gApptsList(CountAppts).Price = "0" Then
                FirstPrice = ""
            Else
                FirstPrice = gApptsList(CountAppts).Price
            End If
        End If
    End If
Next
*/
}
function mPiece(s1,sep,n) {
    //Split the array with the passed delimeter
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
}

function CallCalendar(resId,serId) {
	var lnk="rbcalendar.csp?RescID="+resId+"&ServID="+serId
	//Log: 59598, 03-07-2006 BC: add "status=yes"
	window.open(lnk,"sub","HEIGHT=500,WIDTH=500,status=yes");
}

function checkedCheckBoxes(f,tbl,col) {
	var aryfound=new Array;found=0;
	for (var i=1;i<tbl.rows.length;i++) {
		if (f.elements[col+i].checked && !f.elements[col+i].disabled) {
			aryfound[found]=i;found++;
		}
	}
	return aryfound;
}

//Log 23514 BC 30-5-2002 Enable the multiselect feature to match the VB code
// Find the next required slots if they are available
function multiselectHandler(rid,leng,slots,serRowId) {
	var consD=top.frames["TRAK_main"].frames["RBApptFind"].document.getElementById("ConsecDays");
	if (consD) var consD=consD.checked;
	var consT=top.frames["TRAK_main"].frames["RBApptFind"].document.getElementById("ConsecutiveTimes");
	if (consT) var consT=consT.checked;
	var cnt=1; var chk=1; var origslots=slots;
	var multiList=""; var servRow="";
	var apTime=document.getElementById("cTimez"+rid);
	var apservgrp=document.getElementById("ServiceGroupz"+rid);
	var apsess=document.getElementById("HiddenSessTypeIDz"+rid);
	var apLocId=document.getElementById("LocIdz"+rid);
	var apResId=document.getElementById("ResIdz"+rid);
	var apSerId=document.getElementById("SerIdz"+rid);
	var apDay=document.getElementById("cDayz"+rid);
	var apChk=document.getElementById("chkz"+rid);
	var nextrow=++rid;
	var serdoc=top.frames["TRAK_main"].frames["RBServList"].document
	var servCnt=parseInt(serdoc.getElementById("multiSelCntz"+serRowId).value);
	if (isNaN(servCnt)) servCnt=0;
	slots=slots-servCnt
	if ((apChk.checked==false)&&(origslots>1)) {
		var msconf=confirm(t["multiSel"]);
		if (msconf==false) nextrow=1;
		if (msconf==true) {
			multiLst=document.getElementById("IDz"+rid).value+"z"
			var mlcnt=servCnt-1;
			return multiList+"^"+mlcnt
		}
	}
	//RC make sure it isn't a cancel
	if ((slots<2)&&(nextrow!=1)) {return "^"+servCnt}
	for (var ij=nextrow;ij<leng;ij++) {
		var tapTime=document.getElementById("cTimez"+ij);
		var tapservgrp=document.getElementById("ServiceGroupz"+ij);
		var tapsess=document.getElementById("HiddenSessTypeIDz"+ij);
		var tapLocId=document.getElementById("LocIdz"+ij);
		var tapResId=document.getElementById("ResIdz"+ij);
		var tapSerId=document.getElementById("SerIdz"+ij);
		var tapDay=document.getElementById("cDayz"+ij);
		//RC Separate time test to allow for cancelling all multiselects, with some that might be at different times.
		var timepass=0;
		if (apTime.value==tapTime.value) timepass=1;
		if (consT==true) timepass=1;
		if (msconf==false) timepass=1;
		if (consD==true) {
			if ((timepass==1)&&(apservgrp.value==tapservgrp.value)&&(apsess.value==tapsess.value)&&(apLocId.value==tapLocId.value)&&(apResId.value==tapResId.value)&&(apSerId.value==tapSerId.value)) {
				var obj=document.getElementById("chkz"+ij);
				if (obj) {
					if (obj.checked==true) {
						cnt++;
						obj.checked=false;
						chk=0;
						multiList=multiList+document.getElementById("IDz"+ij).value+"z"
						if (cnt==slots) {return multiList+"^"+0}
					} else if (msconf!=false) {
						cnt++;
						obj.checked=true;
						multiList=multiList+document.getElementById("IDz"+ij).value+"z"
						if (cnt==slots) {return multiList+"^"+cnt}
					}
				}
			}
		} else {
			if ((timepass==1)&&(apDay.value==tapDay.value)&&(apservgrp.value==tapservgrp.value)&&(apsess.value==tapsess.value)&&(apLocId.value==tapLocId.value)&&(apResId.value==tapResId.value)&&(apSerId.value==tapSerId.value)) {
				var obj=document.getElementById("chkz"+ij);
				if (obj) {
					if (obj.checked==true) {
						cnt++;
						obj.checked=false;
						chk=0;
						multiList=multiList+document.getElementById("IDz"+ij).value+"z"
						if (cnt==slots) {return multiList+"^"+0}
					} else if (msconf!=false) {
						cnt++;
						obj.checked=true;
						multiList=multiList+document.getElementById("IDz"+ij).value+"z"
						if (cnt==slots) {return multiList+"^"+cnt}
					}
				}
			}
		}
	}
	if (chk==1) alert(t['MissingMultiAppt']);
	if (msconf==false) cnt=0;
	return multiList+"^"+cnt
}

function bestplan() {
	var tblApptList=document.getElementById("tRBAppointment_ApptList");
	var rowLen=tblApptList.rows.length;
	var arcimidstr="";
	var patid=""
	var episid=""
	var PayId=""
	var PlanID=""
	var apptdatestr=""

	for (var bp=0;bp<rowLen;bp++) {
		var chkobj=document.getElementById("chkz"+bp)
		if ((chkobj)&&(chkobj.checked)) {
			arcimidstr=arcimidstr+document.getElementById("arcimidz"+bp).value+"^"
			if (apptdatestr=="") apptdatestr=document.getElementById("cDatez"+bp).value
			if (DateStringCompare(apptdatestr,document.getElementById("cDatez"+bp).value)==-1) {
				apptdatestr=document.getElementById("cDatez"+bp).value
			}
		}
	}
	var finddoc=top.frames["TRAK_main"].frames["RBApptFind"].document
	if (finddoc) {
		patid=finddoc.getElementById("PatientID").value
		episid=finddoc.getElementById("EpisodeID").value
		PayId=finddoc.getElementById("PayId").value
		PlanID=finddoc.getElementById("PlanID").value
	}
	//alert("&ARCIMID="+arcimidstr);
	var lnk = "arpatbill.bestplan.csp?PatientID="+patid+"&EpisodeID="+episid+"&ARCIMID="+arcimidstr+"&PayorID="+PayId+"&PlanID="+PlanID+"&apptdatestr="+apptdatestr+"&compref="+document.getElementById("TEVENT").value+"&CONTEXT="+session['CONTEXT'];
	//+"&PatientID="+patid+"&EpisodeID="+episid

	websys_createWindow(lnk,"frmBestPlan","resizable=yes,scrollbars=yes");
}

/*function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}*/

//Log 23514 BC 30-5-2002 Enable the multiselect feature to match the VB code
//count the number of ticked appointments
function howManyChked(leng) {
	var hmc=0;
	for (var i=1;i<leng;i++) {
		if (document.getElementById("chkz"+i).checked) {hmc++}
	}
	return hmc;
}

//Log 36001 Warn if the same service is chosen for the same careprovider on the same day
function WarnIfSameDayService(leng) {
	var twofound=0
	var n=0
	var arystr=new Array
	for (var i=1;i<leng;i++) {
		var chkobj=document.getElementById("chkz"+i)
		if ((chkobj)&&(chkobj.checked)) {
			var wssobj=	document.getElementById("ssStringz"+i);
			arystr[n]=wssobj.value;
			n=n+1;
		}
	}
	for (var j=0;j<arystr.length;j++)	{
		if (twofound==0){
			for (var k=j+1;k<arystr.length;k++) {
				if (arystr[j]==arystr[k]) twofound=1
			}
		}
	}
	if (twofound==1) alert(t['SameDayCPService']);
}
// Log 38692 BC 16-9-2003 Extra checking for waiting list preadmission
function CheckSelectedDateAgainstAdm(ODate) {
	//alert("Check Date "+ODate);
	var CheckDate="Y";
	var objAdmDate=top.frames["TRAK_main"].frames["RBApptFind"].document.getElementById("PAADMAdmDate");
	var objAdmType=top.frames["TRAK_main"].frames["RBApptFind"].document.getElementById("AdmsnType");
	var objVisitStat=top.frames["TRAK_main"].frames["RBApptFind"].document.getElementById("VisitStatus");
	var objWaitID=top.frames["TRAK_main"].frames["RBApptFind"].document.getElementById("WaitingListID");
	var OAdmDate="";
	if (objAdmDate) OAdmDate=objAdmDate.value;
	if ((ODate)&&(objAdmDate)){
		ODate=top.frames["TRAK_main"].frames["RBApptFind"].DateStringToArray(ODate);
	 	OAdmDate=top.frames["TRAK_main"].frames["RBApptFind"].DateStringToArray(OAdmDate);
	 	//alert(ODate["yr"]+","+ODate["mn"]-1+","+ODate["dy"])
	 	var NDate=new Date(ODate["yr"],ODate["mn"]-1,ODate["dy"]);
	 	var NAdmDate= new Date(OAdmDate["yr"],OAdmDate["mn"]-1,OAdmDate["dy"]);
	 	//alert(objAdmType.value+","+objVisitStat.value+","+objWaitID.value+","+NAdmDate.valueOf()+","+NDate.valueOf() )
		if ((objAdmType.value=="I")&&(objVisitStat.value=="P")&&(objWaitID.value!="")) {
		 	if ( NAdmDate.valueOf() < NDate.valueOf() ){
		 		alert(t['RBAppAfterAdm']);
				CheckDate="N";
	 		}
		}
	}
	return CheckDate
}

document.body.onload = DocumentLoadHandler;