// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
if (window.name!="appointments") window.name="DaySessionCP"
if ((self != top) && !top.frames["TRAK_main"]){ top.location=self.document.location; }
// LOG 52747 RC 01/06/05 Put this in for single appointment multi screens. No other way I could think to do it than to
// use a variable.
if ((document.getElementById("FullScreen"))&&(document.getElementById("FullScreen").value==1)&&((top.frames["TRAK_main"])&&(top.frames["TRAK_main"].location!=self.document.location))){ top.frames["TRAK_main"].location=self.document.location; }

var next=document.getElementById("NextSession");
if (next) {
	next.disabled=true;
	next.onclick=LinkDisable;
}
var prev=document.getElementById("PrevSession");
if (prev) {
	prev.disabled=true;
	prev.onclick=LinkDisable;
}

var tbl=document.getElementById("tRBAppointment_FindRescDaySched");
var f=document.getElementById("fRBAppointment_FindRescDaySched");
var RescID=f.elements['RescID'].value;
var date=f.elements['DateLogical'].value;
var dt=f.elements['DateNow'].value;
var tm=f.elements['TimeNow'].value;
var dl=f.elements['DateLogical'].value;
var wi=f.elements['WorkID'].value;
var DefServID=f.elements['DefaultServID'].value;
var nextprev=f.elements['nextprev'].value;
var context=session['CONTEXT'];
//alert(f.elements['SessID'].value);
FixNextPrev();

function docLoaded() {
	//alert(FNcommonLink());
	//log 37672 BC 31-7-2003 websys_firstfocus() doesn't need to be used
	//websys_firstfocus();
	//FixNextPrev();
	RefDate=document.getElementById("RefExpDate")
	if (RefDate.value=="EXP") alert(t['RBReferral']);
	// LOG 28361 BC 16-9-2002 Allow booking from the Resource Schedule when in the worklist frame
	// only clear the patient info if not in the worklist frames
	if (wi=="") EPR_ClearSelectedEpisode();
		// LOG 35XXX BC 6-6-2003 make sure the episode is cleared on load if in a worklist
		var parwin=window.parent;
		if (parwin) {
			var parparwin=parwin.parent
			if (parparwin) {
					//Find the frames on the parent of the parent window
					var fr=parparwin.parent.frames;
					if (fr["eprmenu"]) {
						//Get the episode and patient IDs from the epr menu
						fr["eprmenu"].document.getElementById("PatientID").value="";
						fr["eprmenu"].document.getElementById("EpisodeID").value="";
					}
			}
		}

	var date=document.getElementById("DateLogical").value;
	//alert(date);

	// LOG 27963 BC 2-9-2002 Remove the link to the multislot override if there is no session ID (otherwise the slot override shows no service groups)
	//var obj=document.getElementById("SessID")
	//if ((obj)&&(obj.value=="")) {
	//	RemoveMultiSlotOverride()
	//}

	//KM 21-Aug-2002: Removed because new icon profile stuff takes over.
	//if ((document.getElementById("iLISTz1"))&&(document.getElementById("PatientInfoz1"))) {
	//	imagesShow(tbl,f);
	//}
	var obj=document.getElementById("find1")
	if (obj) obj.onclick=RegNoSearchHandler;
	var obj=document.getElementById("Date")
	if (obj) obj.onchange=DateChange;
	//Log 61263 - 09.11.2006
	var obj=document.getElementById("UseURN")
	if (obj) obj.onchange=UseURNChange;
	//End Log 61263
	f.onsubmit=RegNoSearchHandler;
	for (var i=1;i<tbl.rows.length;i++) {
		var eSrc=f.elements['StatusCodez'+i];
		var obj=getRow(eSrc)
		var col=f.elements['StatusColorz'+i].value;
		var ApptTime=f.elements['TimeLogicalz'+i].value;
		if (col!="") obj.style.cssText="color:"+col+";";
		if (eSrc.value=="P") {
			if (dt>date) obj.style.cssText="color:red;";
			if (dt==date && tm>ApptTime) obj.style.cssText="color:red;";
		}
		// ANA LOG 23612 Highlight Row with the selected time from Client Diary.
		var ptobj=document.getElementById("PrefTime")
		var tobj=document.getElementById("TimeLogicalz"+i)
		//alert("hello "+ptobj.value+" tobj.value "+tobj.value)
		if ((ptobj)&&(tobj)&&(ptobj.value!="")&&(ptobj.value==tobj.value)) {
			var elementid="Timez"+i;
			//alert("elementid "+elementid)
			HighlightRow_OnLoad(elementid);
		}
	}
	checkSqueezedInSlots();
	DisableVIP();		// cjb 24/01/2006 55848
	checkSlotOverrides();
	checkPublicHoliday();

	MessageLinkBuilder();
	MultiSlotOverrideLinkBuilder();
	//Log 31834 BC 6-2-2003 Allow a version that gives both session messages and MSOs
	BothMultiSOandMessageLinkBuilder();
	AppointmentSummarys();
	//SetBookButtonClickHandlers(); //called when this .js is loaded
	//LOG 28360 BC 12-9-2002 Ensure the odometer is showing the same date as the worklist
	odometerRefresh();
	CorrectLinks();

	var next1=document.getElementById("NextSession");
	if (next1) next1.onclick=NextSession
	var prev1=document.getElementById("PrevSession");
	if (prev1) prev1.onclick=PrevSession

	//Log 61392 - 24.04.2007 - set tooltip
	for (var i=1;i<tbl.rows.length;i++) {
		var objATime=document.getElementById("Timez"+i);
		var objToolTip=document.getElementById("ToolTipz"+i);

		if ((objATime)&&(objToolTip)) objATime.title=objToolTip.value;
	}
}
SetBookButtonClickHandlers();

// LOG 42056 RC 22/03/04 This onclicks are needed incase there is a problem with the generation process for schedules.
// These will check to make sure dates and schedules are right now before running the link. They will correct date and
// schedule problems that exist also.

function NextSession() {
	var date=document.getElementById("DateLogical");
	var next=document.getElementById("NextSession");
if ((next)&&(next.disabled)) return false;
	if ((date)&&(next)) {
		//alert(next.href);
		var href=next.href;
		var arrya=href.split("&date=");
		var arryb=arrya[1].split("&sessId=");
		var arryc=arryb[1].split("&ORIROWID=");
		if ((arryb[0]=="undefined")||(arryb[0]=="")) arryb[0]=parseInt(date.value)+1;
		if ((arryc[0]=="undefined")||(arryc[0]=="")) arryc[0]="";
		href=arrya[0]+"&date="+arryb[0]+"&sessId="+arryc[0]+"&ORIROWID="+arryc[1];
		next.href=href
	}
}

function PrevSession() {
	var date=document.getElementById("DateLogical");
	var prev=document.getElementById("PrevSession");
if ((prev)&&(prev.disabled)) return false;
	if ((date)&&(prev)) {
		var href=prev.href;
		var arrya=href.split("&date=");
		var arryb=arrya[1].split("&sessId=");
		var arryc=arryb[1].split("&ORIROWID=");
		if ((arryb[0]=="undefined")||(arryb[0]=="")) arryb[0]=parseInt(date.value)-1;
		if ((arryc[0]=="undefined")||(arryc[0]=="")) arryc[0]="";
		href=arrya[0]+"&date="+arryb[0]+"&sessId="+arryc[0]+"&ORIROWID="+arryc[1];
		prev.href=href
	}
}

function windowframe() {
	var parobj=window.parent;
	if (parobj) {
		var fr=window.parent.frames;
		if (fr&&fr.length>0) {
			if (fr[0].name="resources") {
				return 1;
			}
		}
	}
	return 0;
}

//LOG 28360 BC 12-9-2002 A function to ensure the odometer is showing the same date as the worklist
// This function finds the parent frames of the frames that the worklist is held in.  If the odometer is
// present in any of the frames it is refreshed.
function odometerRefresh() {
	// Find the parent window
	//var parwin=document.parent;
	var workid=document.getElementById("WorkID");
	//alert(workid.value);
	var parwin=window.parent;
	if (parwin) {
		// find the parent of the parent window
		//alert("Parent found");
		var parparwin=parwin.parent
		if (parparwin) {
			//Find the frames on the parent of the parent window
			var fr=parwin.parent.frames;
			//alert(fr[1].name);
			if (fr&&fr.length>0) {
				for (var i=0; i<fr.length; i++) {
					// look for the correct widow containing the odometer
					if (fr[i].document.getElementById("fPAOdometer_Edit")) {
						// Setting needed info
						var frame=fr[i].name
						var odom=fr[i].document.getElementById("fPAOdometer_Edit");
						var thisone=i
					} else {
						//finding the link from another window as the link in the wanted window is set to the wrong thing
						//when the odometer is updated (ie from websys.worklist.csp to websys.csp)
						//var loc=new String(fr[1].location);
					}
				}
				//Determine which is the correct frame to use
				if (odom) {
					//alert(loc);
					switch (frame) {
						case "work_left" :
							frame="L";
							break;
						case "work_right" :
							frame="R";
							break;
						case "work_top" :
							frame="T";
							break;
						default :
							frame="B";
							break;
						}
					//var arry1=new Array()
					//arry1=loc.split("&");
					var newdate=dl;
					// Build the new link
					loc="epr.worklist.frame.csp?WorkID="+workid.value+"&frame="+frame+"&newdate="+newdate+"&RescID="+RescID+"&CONTEXT="+context;
					//alert(loc);
					// reset the location of the frame
					fr[thisone].location=loc
				}
			}
		}
	}
}

function checkSlotOverrides() {
	//var tbl=document.getElementById("tRBAppointment_FindRescDaySched");
	for (var i=1;i<tbl.rows.length;i++) {
		if (f.elements['slotoverz'+i].value=='0') {
			tbl.rows[i].className="SlotOverride";
		}
	}
	return;
}

function checkSqueezedInSlots() {
	//var tbl=document.getElementById("tRBAppointment_FindRescDaySched");
	for (var i=1;i<tbl.rows.length;i++) {
		if (f.elements['squeezedz'+i].value=='1') {
			tbl.rows[i].className="SqueezedIn";
		}
	}
	return;
}

// cjb 24/01/2006 55848
function DisableVIP() {
	for (var i=1;i<tbl.rows.length;i++) {
		if ((f.elements['PatientIDz'+i].value=="")&&(f.elements['EpisodeIDz'+i].value!="")) {
			tbl.rows[i].className="clsRowDisabled";
			var Select=f.elements["Selectz"+i];
			if (Select) Select.disabled=true;
			var obj=document.getElementById('Statusz'+i);
			if (obj) var deletenode=obj.removeNode(false);
			var obj=document.getElementById('Servicez'+i);
			if (obj) var deletenode=obj.removeNode(false);
			var obj=document.getElementById('ArriveWithPayorPlanz'+i);
			if (obj) var deletenode=obj.removeNode(false);
			var obj=document.getElementById('Arrivedz'+i);
			if (obj) var deletenode=obj.removeNode(false);
			var obj=document.getElementById('overbookz'+i);
			if (obj) var deletenode=obj.removeNode(false);
		}
	}
	return;
}


function checkPublicHoliday() {
	var PubHol=f.elements['PubHol'].value

	if (PubHol!= "" ){
		for (var i=1;i<tbl.rows.length;i++) {
				tbl.rows[i].className="PublicHol";
		}
	}
	return;
}

function SelectRowHandler() {
	//alert("kk");
	//If Arrived Column was clicked then perform status update.
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	if (eSrcAry.length>0) {
		if (eSrcAry[0]=="Arrived" || eSrcAry[0]=="ArriveWithPayorPlan") {
			var Stat=f.elements['StatusCodez'+eSrcAry[1]].value;
			var resrow="",currsess="";
			var resrow=document.getElementById("resrowz1");
            		var currsess=document.getElementById("currsessz1");
			if (Stat=="P") {
				var message=validateStatusChange("A",date,dt,f.elements['ApptIDz'+eSrcAry[1]].value.split(","),Stat.split(","))
				if (message=="") {
                   			if (eSrcAry[0]=="ArriveWithPayorPlan") {
						var ptID=f.elements['PatientIDz'+eSrcAry[1]].value
						var epID=f.elements['EpisodeIDz'+eSrcAry[1]].value
						//websys_createWindow('rbappointment.changestatus.payorplan.csp?&EpisodeID=' + epID +'&CONTEXT='+context+ '&PatientID=' + ptID+'&ApptID='+f.elements['ApptIDz'+eSrcAry[1]].value.split(",")+'&RescID='+RescID+'&date='+dt+'&PresentStatus='+Stat.split(","),'','Left=3000,top=1000,width=250,height=500');
						var arrPayorPlan=f.elements['PayorPlanz'+eSrcAry[1]].value.split("^");
						if ((arrPayorPlan[0]=="")||(arrPayorPlan[1]=="")) {
							websys_createWindow(eSrc.href + ' &EpisodeID=' + epID +'&CONTEXT='+context+ '&PatientID=' + ptID+'&ApptID='+f.elements['ApptIDz'+eSrcAry[1]].value.split(",")+'&RescID='+RescID+'&date='+dt+'&PresentStatus='+Stat.split(",")+"&Payor="+arrPayorPlan[0]+"&Plan="+arrPayorPlan[1]+"&PatientBanner=1",'','Left=100,top=100,width=500,height=250');
						} else {
							//document.getElementById('Arrivedz'+eSrcAry[1]).click();
							eSrc.href = 'websys.csp?TEVENT=t265iArrived&TRELOADID='+TRELOADID;
							//changes here need to be reflected in below "Arrived" case
							eSrc.href += '&Status=A&RescID='+RescID+'&CONTEXT='+context+'&date='+dt+'&ApptID='+f.elements['ApptIDz'+eSrcAry[1]].value.split(",")+'&PresentStatus='+Stat.split(",")+resrow;
							return true;
						}
					} else {
                   				if ((resrow)&&(currsess)) var resrow="&resrow="+resrow.value+"&currsess="+currsess.value
                   				//LOG 33257 BC24-2-2003 ensure that the popup schedule remains open
						//websys_createWindow('rbappointment.changestatus.csp?Status=A&RescID='+RescID+'&date='+dt+'&ApptID='+f.elements['ApptIDz'+eSrcAry[1]].value.split(",")+'&PresentStatus='+Stat.split(",")+resrow,window.name,'');
						//websys_createWindow('rbappointment.changestatus.csp?Status=A&RescID='+RescID+'&CONTEXT='+context+'&date='+dt+'&ApptID='+f.elements['ApptIDz'+eSrcAry[1]].value.split(",")+'&PresentStatus='+Stat.split(",")+resrow,'','Left=30,top=10');
						//changes here need to be reflected in above "ArriveWithPayorPlan" case when Payor and Plan have been entered
						eSrc.href += '&Status=A&RescID='+RescID+'&CONTEXT='+context+'&date='+dt+'&ApptID='+f.elements['ApptIDz'+eSrcAry[1]].value.split(",")+'&PresentStatus='+Stat.split(",")+resrow;
						return true;
					}
				} else {
					alert(message);
				}
			}
			return false;
		}
		if (eSrcAry[0]=="DayOverride") {
			// SB Log 23470: All info now passed on LinkExpression to fix problem with frame moving to 'Medtrak'
			//		 screen when row selected twice.
			//var time=f.elements['TimeLogicalz'+eSrcAry[1]].value;
			//var load=f.elements['loadz'+eSrcAry[1]].value;
			//var sessId=f.elements['sessionz'+eSrcAry[1]].value;
			//var lnk='websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.SlotOverride&Resource='+RescID+'&Date='+date+'&Time='+time+'&load='+load+'&SessID='+sessId
			//websys_createWindow(lnk,"","width=400,height=270,resizable=yes,scroll=yes");
			//return false;
		}
	}
	//SB 18/08/04 (43901): We want to see yellow when the row is selected, so commented out the following.
	//checkSqueezedInSlots();
	checkSlotOverrides();
}

function DateChange(e) {
	var eSrc=websys_getSrcElement(e);
	if (eSrc.id=="Date") {Date_changehandler(e);}
	var objDate=document.getElementById("Date");
	if ((eSrc.className=="") && (objDate.value!="")) {RegNoSearchHandler();}
}

//Log 61263 - 09.11.2006 - This gets the PatientID that we need to make the booking.
function UseURNChange(e) {
	var eSrc=websys_getSrcElement(e);
	var URN="";

	if (eSrc.id=="UseURN") {
		URN=eSrc.value;
		var PatID=tkMakeServerCall("web.PAPatMas","GetIdFromCodeOrDescription",URN);
		var obj=document.getElementById("URNPatID");
		if (obj) obj.value=PatID;
	}
}

function RegNoSearchHandler() {
	var objdate=document.getElementById("Date")

	var RegNoSearch=""
	if (f.elements["RegNoSearch"]) RegNoSearch=f.elements["RegNoSearch"].value;
	var MedRecSearch=""
	if (f.elements["MedRecSearch"]) MedRecSearch=f.elements["MedRecSearch"].value;
	if (objdate.className!="clsInvalid") {
		var date=objdate.value;
		if (TK_dtformat=="THAI") date=AddToDateStrGetDateStr(date,"Y",-543)
		var date=DateStringTo$H(date);
		if (isNaN(date)==true) date=document.getElementById("DateLogical").value
		//date=dateH.value;
		var timefrom="",timeto="";
		var workid=f.elements["WorkID"].value;
		if (f.elements["timefrom"]) timefrom=f.elements["timefrom"].value;
		if (f.elements["timeto"]) timeto=f.elements["timeto"].value;
		var epID=document.getElementById("EpID").value;
		var PatID=document.getElementById("PatID").value;
		var ServID=document.getElementById("ServID").value;
		// LOG 30934 RC 06/12/02 This sessall is used to do the find over all sessions on the RBAppointment.FindResDaySched page.
		var sessall="";
		//if ((top.frames['eprmenu']) && (top.frames['eprmenu'].RBSessAll)) var sessall=top.frames['eprmenu'].RBSessAll;
		var sessID="";
		//SB 07/01/05 (48590): We need to ensure the session isn't set when searching by date, so we clearout the following fields
		//if (objdate && objdate.value!="") {RegNoSearch="";MedRecSearch=""}
		if ((RegNoSearch!="")||(MedRecSearch!="")) {
			var objSess=document.getElementById("SessID");
			if (objSess) sessID=objSess.value;
		}
		//alert(sessID);
		if (windowframe()==1) {
			//alert('RescID='+RescID+'&date='+date+'&timefrom='+timefrom+'&timeto='+timeto+'&RegistrationNo='+RegNoSearch+'&sessall='+sessall+'&sessId='+sessID+'&WorkID='+workid+'&EpisodeID='+epID+'&PatientID='+PatID+'&ServID='+ServID+'&MedRecSearch='+MedRecSearch);
			websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.FindRescDaySched&RescID='+RescID+'&date='+date+'&timefrom='+timefrom+'&timeto='+timeto+'&RegistrationNo='+RegNoSearch+'&sessall='+sessall+'&sessId='+sessID+'&WorkID='+workid+'&EpisodeID='+epID+'&PatientID='+PatID+'&ServID='+ServID+'&MedRecSearch='+MedRecSearch+'&CONTEXT='+context,window.name,'');
		} else {
			window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.FindRescDaySched&RescID='+RescID+'&date='+date+'&timefrom='+timefrom+'&timeto='+timeto+'&RegistrationNo='+RegNoSearch+'&sessall='+sessall+'&sessId='+sessID+'&WorkID='+workid+'&EpisodeID='+epID+'&PatientID='+PatID+'&ServID='+ServID+'&MedRecSearch='+MedRecSearch+'&CONTEXT='+context;
		}
	}
	return false;
}

function DateHTMLToLogical(dt) {
	/* This natty little function is needed to convert the html date that the user enters
	into a proper logical date for the FindResDaySched query to use to complete the query.
	Without this, for some reason the query completes itself fine, but returns a date
	something like ??/01/1841. Because of it being a html date, when it trys to display
	the new date, it takes the day from the date as being the whole logical date, hence it
	displays only a few days from the beginning of the logical date system, which happens
	to be 01/01/1841.*/

	var logdt=47117; //Javascript starts it dates at 01/01/1970, which is that logical date.
	var lu=dt.split("/");
	if (lu[0]>31) return(dt) //just in case someone decides to input a logical date.
	var dt=new Date(lu[2],lu[1]-1,lu[0])
	dtMilli=Date.parse(dt)/86400000 //there are 86,400,000 milliseconds in a day...
	if (isNaN(dtMilli)) {
		alert("That is not a valid date");
		//by using DateLogical, it will take the screen back to the last date in the system
		dtlog=document.getElementById("DateLogical").value;
		return(dtlog);
	}
	days=Math.round(dtMilli); //round the date to the nearest millisecond
	logdt+=days;
	return(logdt);
}

//Log 31834 BC 6-2-2003 Allow a version that gives both session messages and MSOs
function BothMultiSOandMessageLinkBuilder() {
	var Both=document.getElementById("BothMSOandSessMess");
	var sessMessage=document.getElementById("sessMessage");
	var replace=document.getElementById("messages");
		if ((Both)&&(replace)) {
		var logicaldate=document.getElementById("DateLogical");
		logicaldate=logicaldate.value
		var str="";
		var urls="<table><tbody>";
		//var urls="<table align=right><tbody>";
		// Remove the workflow as not required
		//var TWKFL="&TWKFL="
		//var TWKFLI="&TWKFLI="
		var arry1 = replace.value.split("$$");
		for (var i = 0;i<arry1.length-1;i++) {
			var q=i+1
			var arry2=arry1[i].split("^");
			var resid =arry2[0];
			var  pos=resid.indexOf("|");
			resid=resid.substr(0,pos);
			urls+="<tr><td>";
			if (arry2[5]=="Y") urls+="<b>";
			urls+=t["SessLabel"]+" &nbsp;";
			if (arry2[5]=="Y") urls+="</b>";
			urls+="</td><td>";
			if (arry2[5]=="Y") urls+="<b>";
			urls+=arry2[1]+"&nbsp;";
			if (arry2[5]=="Y") urls+="</b>";
			urls+="</td><td>";
			if (arry2[5]=="Y") urls+="<b>";
			urls+=arry2[2]+"&nbsp;";
			if (arry2[5]=="Y") urls+="</b>";
			urls+="</td><td>";
			if (arry2[5]=="Y") urls+="<b>";
			urls+=arry2[3]+"&nbsp;";
			if (arry2[5]=="Y") urls+="</b>";
			// Log 58895 - GC - 17-05-2006: Added Session Description
			if (arry2[5]=="Y") urls+="<b>";
			urls+="&nbsp;"+arry2[7]+"&nbsp;";
			if (arry2[5]=="Y") urls+="</b>";
			// End Log 58895
			urls+="</td><td>";
            urls+="<A id=AddMessagez"+q+" name=AddMessagez"+q+" HREF="+'"'+"#"+'"'+" onClick="+'"'+"websys_lu('websys.default.csp?WEBSYS.TCOMPONENT=RBServiceOverride.Edit.Message&ID="+arry2[4]+"&RBSessID="+arry2[0]+"&CONTEXT="+context+"&RBSessIDs="+arry2[0]+"&LogicalDate="+logicaldate+"',false,'top=30,left=20');"+'"'+" tabIndex="+'"'+0+'"'+" >"+'<img SRC="../images/websys/edit.gif" BORDER="0"></A>';
			urls+="</td><td>"
			urls+="<A id=AddSlotz"+q+" name=AddSlotz"+q+" HREF="+'"'+"#"+'"'+" onClick="+'"'+"websys_lu('rbappointment.multislotoverride.csp?TEPRSTART=1&resource="+resid+"&CONTEXT="+context+"&sessionId="+arry2[0]+"&date="+logicaldate+"',false,'top=30,left=20');"+'"'+" tabIndex="+'"'+0+'"'+" >"+t['MultiSlotOverride']+'</A>';
			urls+="</td></tr>"
		}
		urls+="</tbody></table>"
		Both.innerHTML=urls;
		if (sessMessage && arry2) sessMessage.innerText=arry2[6]
	}
	return "";
}

function MultiSlotOverrideLinkBuilder() {
	var MultiSlotOverride=document.getElementById("MultiSlotOverride");
	var replace=document.getElementById("messages");
	if ((MultiSlotOverride)&&(replace)) {
		var logicaldate=document.getElementById("DateLogical");
		logicaldate=logicaldate.value
		var str="";
		var urls="<table><tbody>";
		// Remove the workflow as not required
		//var TWKFL="TWKFL="
		//var TWKFLI="&TWKFLI="
		var arry1 = replace.value.split("$$");
		for (var i = 0;i<arry1.length-1;i++) {
			var q=i+1
			var arry2=arry1[i].split("^");
			var resid =arry2[0];
			var  pos=resid.indexOf("|");
			resid=resid.substr(0,pos);
            urls+="<tr><td>";
            if (arry2[5]=="Y") urls+="<b>";
			urls+=t["SessLabel"]+" &nbsp;";
            if (arry2[5]=="Y") urls+="</b>";
			urls+="</td><td>";
			if (arry2[5]=="Y") urls+="<b>";
			urls+=arry2[1]+"&nbsp;";
			if (arry2[5]=="Y") urls+="</b>";
			urls+="</td><td>";
			if (arry2[5]=="Y") urls+="<b>";
			urls+=arry2[2]+"&nbsp;";
			if (arry2[5]=="Y") urls+="</b>";
			urls+="</td><td>";
			if (arry2[5]=="Y") urls+="<b>";
			urls+=arry2[3]+"&nbsp;";
			if (arry2[5]=="Y") urls+="</b>";
			urls+="</td><td>";
			urls+="<A id=AddMessagez"+q+" name=AddMessagez"+q+" HREF="+'"'+"#"+'"'+" onClick="+'"'+"websys_lu('rbappointment.multislotoverride.csp?TEPRSTART=1&resource="+resid+"&CONTEXT="+context+"&sessionId="+arry2[0]+"&date="+logicaldate+"',false,'top=30,left=20');"+'"'+" tabIndex="+'"'+0+'"'+" >"+t['MultiSlotOverride']+'</A>';
			urls+="</td></tr>"
		}
		urls+="</tbody></table>"
		MultiSlotOverride.innerHTML=urls;
	}
	return "";
}

 function MessageLinkBuilder() {
	var replaceme=document.getElementById("messlink");
	var replace=document.getElementById("messages");
	var sessMessage=document.getElementById("sessMessage");
	if ((replaceme)&&(replace)) {
		var logicaldate=document.getElementById("DateLogical");
		logicaldate=logicaldate.value
		var str="";
		var urls="<table><tbody>";
		// Remove the workflow as not required
		var obj=document.getElementById("TWKFL");
		//if (obj) var TWKFL="&TWKFL="+obj.value;
		var TWKFL="&TWKFL="
		var obj=document.getElementById("TWKFLI");
		//if (obj) var TWKFLI="&TWKFLI="+(obj.value);
		var TWKFLI="&TWKFLI="
		var arry1 = replace.value.split("$$");
		for (var i = 0;i<arry1.length-1;i++) {
			var q=i+1
			var arry2=arry1[i].split("^");
			urls+="<tr><td>";
			if (arry2[5]=="Y") urls+="<b>";
			urls+=t["SessLabel"]+" &nbsp;";
			if (arry2[5]=="Y") urls+="</b>";
			urls+="</td><td>";
			if (arry2[5]=="Y") urls+="<b>";
			urls+=arry2[1]+"&nbsp;";
			if (arry2[5]=="Y") urls+="</b>";
			urls+="</td><td>";
			if (arry2[5]=="Y") urls+="<b>";
			urls+=arry2[2]+"&nbsp;";
			if (arry2[5]=="Y") urls+="</b>";
			urls+="</td><td>";
			if (arry2[5]=="Y") urls+="<b>";
			urls+=arry2[3]+"&nbsp;";
			if (arry2[5]=="Y") urls+="</b>";
			urls+="</td><td>";
			urls+="<A id=AddMessagez"+q+" name=AddMessagez"+q+" HREF="+'"'+"#"+'"'+" onClick="+'"'+"websys_lu('websys.default.csp?WEBSYS.TCOMPONENT=RBServiceOverride.Edit.Message"+TWKFL+TWKFLI+"&ID="+arry2[4]+"&CONTEXT="+context+"&RBSessID="+arry2[0]+"&RBSessIDs="+arry2[0]+"&LogicalDate="+logicaldate+"',false,'top=30,left=20');"+'"'+" tabIndex="+'"'+0+'"'+" >"+'<img SRC="../images/websys/edit.gif" BORDER="0"></A>';
			urls+="</td></tr>"
		}
		urls+="</tbody></table>"
		//alert(urls);
		if (sessMessage && arry2) sessMessage.innerText=arry2[6]
		replaceme.innerHTML=urls

	}
	return "";
}

function RemoveMultiSlotOverride() {
	var removeme=document.getElementById("MultiSlotOverride");
	if (removeme) {
		removeme.innerHTML=""
		var killed=removeme.removeNode(false);
	}
}
var loc;
// LOG 28361 BC 16-9-2002 Allow booking from the Resource Schedule when in the worklist frame
function BookingButtonClickHandler(e){
	// Set up the variables
	var PatientID=""
	var EpisodeID=""
	var ServID=""
	// Find which booking button has been clicked
	var obj=websys_getSrcElement(e);
	// Find the link
	if (obj.tagName=="A") var parobj=obj;
	else var parobj=obj.parentNode;

	loc=new String(parobj.href);
	// Break the link into it's components
	var lnkpart=loc.split("=")
	if (wi!="") {
		//Test to see if the PatientID and EpisodeIDs are empty, if they are then look for them in the epr menu
		if ((lnkpart[5]=="&EpisodeID")&&(lnkpart[6]=="&RescID")){
			var workid=document.getElementById("WorkID");
			if (workid.value!="") {
				var parwin=window.parent;
				if (parwin) {
					// find the parent of the parent window
					var parparwin=parwin.parent
					if (parparwin) {
						//Find the frames on the parent of the parent window
						var fr=parparwin.parent.frames;
						if (fr["eprmenu"]) {
							//Get the episode and patient IDs from the epr menu
							PatientID=fr["eprmenu"].document.getElementById("PatientID").value;
							EpisodeID=fr["eprmenu"].document.getElementById("EpisodeID").value;
							// If there are no IDs then warn the user to select a patient and stop the class method from being performed
							if ((PatientID=="")||(EpisodeID=="")) {
								alert(t['NoPatient']);
								return websys_cancel();
							}
							// Rebuild the link and pass the information out to the class method
							/*lnkpart[5]=PatientID+lnkpart[5];
							lnkpart[6]=EpisodeID+lnkpart[6];
							lnkpart[8]=DefServID+lnkpart[8];
							loc=lnkpart.join("=")
							alert(loc);
							parobj.href=loc
							return;*/
							//LOG 49444 RC 15/04/05 Allow selection of service for walkin patients
							var locid=document.getElementById("LocID").value
							var resid=document.getElementById("RescID").value
							var schid=mPiece(lnkpart[4],"&",0)
							var date=mPiece(lnkpart[10],"&",0)
							//var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.UpdateBooking&PatientBanner=1&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&locid="+locid+"&resid="+resid+"&SchedID="+schid+"&date="+date+"&WorkID="+workid.value;
							// RC 02/05/07 62697 Changed to csp to accomodate a hidden frame for appointment checks
							var lnk = "rbappointment.updatebooking.popup.csp?PatientBanner=1&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&locid="+locid+"&resid="+resid+"&SchedID="+schid+"&date="+date+"&WorkID="+workid.value;
							websys_createWindow(lnk,"frmUpdateBooking","width=300,height=300,top=150,left=300,resizable=yes,scrollbars=yes")
							return websys_cancel();
						}
					}
				}
				// If there are no IDs then warn the user to select a patient and stop the class method from being performed
				alert(t['NoPatient']);
				return websys_cancel();
			}
		}
	} else {
	    //Log 61263
		if (parobj) {
			var winlink=parobj.href;
			var tmplnkpart=winlink.split("&")

			tmpPatID=mPiece(tmplnkpart[6],"=",1)
		}

		if ((window.name=="appointments")||((window.name=="DaySessionCP")&&(tmpPatID==""))) {  //Log 61263 - 09.11.2006 -  If its not from Single Appt workflow or walkins workflow, come in here.
			var obj=document.getElementById("URNPatID");
			var UPatID="";
			if (obj) UPatID=obj.value;

			var locid=document.getElementById("LocID").value;
			var resid=document.getElementById("RescID").value;
			if (window.name=="appointments") {
				var schid=mPiece(lnkpart[4],"&",0);
				var date=mPiece(lnkpart[10],"&",0);
			} else {
				var schid=mPiece(lnkpart[6],"&",0);
				var date=mPiece(lnkpart[12],"&",0);
			}
			var params=locid+"^"+resid+"^"+schid+"^"+date;

			if (UPatID=="") {
				//If we dont have a patient, go and find
				var lnk="websys.default.csp?WEBSYS.TCOMPONENT=PAPerson.Find&returnSelected=1&updateBooking=1&params="+params;
				websys_createWindow(lnk,"frmApptPersonList",'width=600, height=400');
			} else {
				//Do the booking for existing patient.
				//var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.UpdateBooking&PatientBanner=1&PatientID="+UPatID+"&EpisodeID="+EpisodeID+"&locid="+locid+"&resid="+resid+"&SchedID="+schid+"&date="+date;
				// RC 02/05/07 62697 Changed to csp to accomodate a hidden frame for appointment checks
				var lnk = "rbappointment.updatebooking.popup.csp?PatientBanner=1&PatientID="+UPatID+"&EpisodeID="+EpisodeID+"&locid="+locid+"&resid="+resid+"&SchedID="+schid+"&date="+date;
				websys_createWindow(lnk,"frmUpdateBooking","width=300,height=300,top=150,left=300,resizable=yes,scrollbars=yes")

			}
			return websys_cancel();
			//End Log 61263
		}else{
			//ShowApptMessages(loc)
			ShowApptMessages(parobj);
			return websys_cancel();
		}
	}
	// The link already had all the necessary information so just keep going
	return;
}

function OverbookButtonClickHandler(e) {
	var obj=websys_getSrcElement(e);
	if (obj.tagName=="IMG") obj=websys_getParentElement(obj);
	var rowid=obj.id
	var rowAry=rowid.split("z");

	var SingleApptOB=document.getElementById("SingleApptOB").value
	if (SingleApptOB!="1") {
		var objWindow=document.getElementById("Window")
		//alert(	objWindow.value);
		if (objWindow.value=="frmEditServiceList") {
			var objopen=window.open("","frmEditServiceList")

			var Timez = document.getElementById("Timez"+rowAry[1]).innerHTML
			objopen.document.getElementById("Time").value=Timez

			window.close();
			return false;
		}
	} else if (SingleApptOB=="1") {
		var patid=document.getElementById("PatID").value; var epid=document.getElementById("EpID").value; var locid=document.getElementById("LocID").value; var resid=document.getElementById("RescID").value;
		var date=document.getElementById("DateLogical").value; var serid=document.getElementById("ServID").value; var schid=document.getElementById("SchedIDz"+rowAry[1]).value;
		var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.SingApptOBReason.Edit&PatientBanner=1&PatientID="+patid+"&EpisodeID="+epid+"&locid="+locid+"&resid="+resid+"&SchedID="+schid+"&date="+date+"&ServiceID="+serid;
		websys_createWindow(lnk,"frmSingApptOBReason","width=300,height=300,top=150,left=300,resizable=yes,scrollbars=yes")
		return false;
	}
}
//function ShowApptMessages(winlink) {
function ShowApptMessages(linkobj) {
	//alert (linkobj.value)
	var winlink=linkobj.href;
	var lnkpart=winlink.split("&")
	var row=""
	//if (lnkpart[23]) row=mPiece(lnkpart[23],"z",1)
	row = mPiece(linkobj.id,"z",1);
	PatientID=mPiece(lnkpart[6],"=",1)
	EpisodeID=mPiece(lnkpart[7],"=",1)
	DateLogical=mPiece(lnkpart[11],"=",1)
	DateHtml=document.getElementById("Date").value
	TimeHtml=document.getElementById("Timez"+row).innerText
	ScheduleID=mPiece(lnkpart[5],"=",1)
	ServiceID=mPiece(lnkpart[9],"=",1)
	LocationID=session['LOGON.CTLOCID']
	//LocationID=document.getElementById("LocID").value
	ResID=mPiece(lnkpart[8],"=",1)
	UserCode=session['LOGON.USERCODE']
	overbook=""
	WaitListID=""
	str=DateHtml+"*"+TimeHtml+"*"+ScheduleID+"*"+escape(ServiceID)+"*"+""+"*"+LocationID+"^";
//	str=DateHtml+"*"+TimeHtml+"*"+ScheduleID+"*"+encodeURIComponent(ServiceID)+"*"+""+"*"+LocationID+"^";
	var MUserC="1"
	var lnk = "rbappointment.checkbeforeupdate.csp?PatientID="+PatientID+"&Str="+str+"&Overbook="+overbook+"&EpisodeID="+EpisodeID+"&WaitListID="+WaitListID+"&Date="+DateHtml+"&UserCode="+UserCode+"&MUserC="+MUserC;
	websys_createWindow(lnk,"TRAK_hidden");

}

function UpdateClickHandler() {
	window.location=loc
	return websys_cancel();
}

function QuitHandler() {
	return websys_cancel();
}

function mPiece(s1,sep,n) {
	//Split the array with the passed delimeter
      delimArray = s1.split(sep);

	//If out of range, return a blank string
      if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
	} else {
	  return ""
      }
}

function SetBookButtonClickHandlers() {
	for (var ij=1;ij<tbl.rows.length;ij++) {
		var buttona="BookApptz"+ij;
		var buttonobj=document.getElementById(buttona);
		if (buttonobj) buttonobj.onclick=BookingButtonClickHandler;

		var buttono="overbookz"+ij;
		var buttonobj=document.getElementById(buttono);
		if (buttonobj) buttonobj.onclick=OverbookButtonClickHandler;
	}
	return;
}

function CorrectLinks() {
	for (var i=1;i<tbl.rows.length;i++) {
		var typeflag=f.elements['TypeFlagz'+i].value;
		var type=typeflag.split("^");
		if (type[0]=='AN') {
			tbl.rows[i].className="PatientNotAttending";
		}
		if (type[0]=='E') {
			tbl.rows[i].className="NotAvailableEvent";
			var obj=document.getElementById('RegNoz'+i);
			if (obj) {
				//alert(obj.outerHTML);
				var innertxt=obj.innerHTML
				var url="<A id=RegNoz"+i+" name=RegNoz"+i+" HREF="+'"'+"#"+'"'+" onClick="+'"'+"websys_lu('rbevent.edit.csp?ID="+type[2]+"',false,'top=10,left=10');"+'"'+" >"+innertxt+'</A>';
				//alert(url);
				obj.outerHTML=url;
			}
			var obj=document.getElementById('RTMAS_MRNoz'+i);
			if (obj) {
				//alert(obj.outerHTML);
				var innertxt=obj.innerHTML
				var url="<A id=RTMAS_MRNoz"+i+" name=RTMAS_MRNoz"+i+" HREF="+'"'+"#"+'"'+" onClick="+'"'+"websys_lu('rbevent.edit.csp?ID="+type[2]+"&CONTEXT="+context+"',false,'top=10,left=10');"+'"'+" >"+innertxt+'</A>';
				//alert(url);
				obj.outerHTML=url;
			}
		}
		if (type[0]=='N') {
			tbl.rows[i].className="NotAvailable";
			var obj=document.getElementById('RegNoz'+i);
			var resid=document.getElementById('RescID').value;
			if (obj) {
				//alert(obj.outerHTML);
				var innertxt=obj.innerHTML
				var re=/(\|\|)/gi;
				if (type[1].search(re)!=-1) {
					var url="<A id=RegNoz"+i+" name=RegNoz"+i+" HREF="+'"'+"#"+'"'+" onClick="+'"'+"websys_lu('websys.default.csp?WEBSYS.TCOMPONENT=RBResEffDateSessNotAvail.Edit&ID="+type[1]+"&ResID="+resid+"&CONTEXT="+context+"',false,'top=10,left=10,height=200,width=400');"+'"'+" >"+innertxt+'</A>';
					var NAurl="<A id=RegNoz"+i+" name=RegNoz"+i+" HREF="+'"'+"#"+'"'+" onClick="+'"'+"websys_lu('websys.default.csp?WEBSYS.TCOMPONENT=RBResEffDateSessNotAvail.Edit&ID="+type[1]+"&ResID="+resid+"&CONTEXT="+context+"',false,'top=10,left=10,height=200,width=400');"+'"'+" ><IMG src='../images/websys/edit.gif' border=0></A>";
					var NAobj=document.getElementById('NotAvailablez'+i);
					if (NAobj) NAobj.outerHTML=NAurl;
				} else {
					var url="<A id=RegNoz"+i+" name=RegNoz"+i+" HREF="+'"'+"#"+'"'+" onClick="+'"'+"websys_lu('websys.default.csp?WEBSYS.TCOMPONENT=RBNotAvail.Edit&ID="+type[1]+"&ResID="+resid+"&CONTEXT="+context+"',false,'top=10,left=10,width=640,height=480');"+'"'+" >"+innertxt+'</A>';
				}
				//alert(url);
				obj.outerHTML=url;
			}
			var obj=document.getElementById('RTMAS_MRNoz'+i);
			if (obj) {
				var innertxt=obj.innerHTML
				var re=/(\|\|)/gi;
				if (type[1].search(re)!=-1) {
					var url="<A id=RTMAS_MRNoz"+i+" name=RTMAS_MRNoz"+i+" HREF="+'"'+"#"+'"'+" onClick="+'"'+"websys_lu('websys.default.csp?WEBSYS.TCOMPONENT=RBResEffDateSessNotAvail.Edit&ID="+type[1]+"&ResID="+resid+"&CONTEXT="+context+"',false,'top=10,left=10,height=200,width=400');"+'"'+" >"+innertxt+'</A>';
					var NAurl="<A id=RTMAS_MRNoz"+i+" name=RTMAS_MRNoz"+i+" HREF="+'"'+"#"+'"'+" onClick="+'"'+"websys_lu('websys.default.csp?WEBSYS.TCOMPONENT=RBResEffDateSessNotAvail.Edit&ID="+type[1]+"&ResID="+resid+"&CONTEXT="+context+"',false,'top=10,left=10,height=200,width=400');"+'"'+" ><IMG src='../images/websys/edit.gif' border=0></A>";
					var NAobj=document.getElementById('NotAvailablez'+i);
					if (NAobj) NAobj.outerHTML=NAurl;
				} else {
					var url="<A id=RTMAS_MRNoz"+i+" name=RTMAS_MRNoz"+i+" HREF="+'"'+"#"+'"'+" onClick="+'"'+"websys_lu('websys.default.csp?WEBSYS.TCOMPONENT=RBNotAvail.Edit&ID="+type[1]+"&ResID="+resid+"&CONTEXT="+context+"',false,'top=10,left=10,width=640,height=480');"+'"'+" >"+innertxt+'</A>';
				}
				//alert(url);
				obj.outerHTML=url;
			}
		}
		//SB 16/12/03 (41291): Not Available for number of weeks for session (defined in VB) not showing in web
		if (type[0]=='NASESS') {
			tbl.rows[i].className="NotAvailable";
			var obj=document.getElementById('RegNoz'+i);
			var resid=document.getElementById('RescID').value;
			if (obj) {
				var innertxt=obj.innerHTML
				var url=innertxt;
				obj.outerHTML=url;
			}
			var obj=document.getElementById('RTMAS_MRNoz'+i);
			if (obj) {
				var innertxt=obj.innerHTML
				var url=innertxt;
				obj.outerHTML=url;
			}
		}
	}
	return;
}

// Log 33542 BC 11-03-2003 Ensure that no patient is selected after a quick appointment has been made
function PAAdmListDocCurrentRefresh() {
	// Find the parent window
	//var parwin=document.parent;
	var workid=document.getElementById("WorkID");
	//alert(workid.value);
	var parwin=window.parent;
	if (parwin) {
		// find the parent of the parent window
		//alert("Parent found");
		var parparwin=parwin.parent
		if (parparwin) {
			//Find the frames on the parent of the parent window
			var fr=parwin.parent.frames;
			//alert(fr[1].name);
			if (fr&&fr.length>0) {
				for (var i=0; i<fr.length; i++) {
					// look for the correct widow containing the odometer
					if (fr[i].document.getElementById("fPAAdm_ListDocCurrent")) {
						// Setting needed info
						var loc=fr[i].location
						fr[i].location=loc
					}
				}
			}
		}
	}
}

//Log 31215 BC 5-8-2003 Appointment Summary
function AppointmentSummarys() {
	var delim=String.fromCharCode(2);
	var Both=document.getElementById("AppointmentTotals");
	var replaceSlot=document.getElementById("ReplaceMeApptTotals");
	//BR 30/10/03 39070. Need to show Appointment totals. Different from Total number of slots...
	var replaceAppt=document.getElementById("ReplaceMeRealApptTotals");
	if ((Both)&&((replaceSlot)||(replaceAppt))) {
		//alert("starting link builder "+Both.value);
		var summarySlot="",summaryAppt="";
		var arry1 = Both.value.split("|");
		for (var i = 0;i<arry1.length;i++) {
			var arry2=arry1[i].split(delim);
			//LOG 41972 RC 01/03/04 arry2[4] was coming up as 'undefined' when there were no appointments
			//so now if that occurs, or if the value is "", it will not display that apponitment slot information.
			//First part is the number of slots per service group
			if ((arry2[1])||(arry2[1]!="")) {
				if (summarySlot!="") summarySlot=summarySlot+", "+arry2[1]+" "+arry2[0];
				if (summarySlot=="") summarySlot=arry2[1]+" "+arry2[0];
			}
			//Second part is number of actual appointments.
			if (arry2[4]) {
				if (summaryAppt!="") summaryAppt=summaryAppt+", "+arry2[4]+" "+arry2[0];
				if (summaryAppt=="") summaryAppt=arry2[4]+" "+arry2[0];
			}
		}
		if (replaceAppt) replaceAppt.innerText=summaryAppt;
		if (replaceSlot) replaceSlot.innerText=summarySlot;
	}
	return ;
}


function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	//if (el.id=="ViewableBy") VIEWABLE=el;
	if (el.disabled) {
		return false;
	}
	return true;
}
function FixNextPrev() {
	var date=document.getElementById("DateLogical").value;
	if (nextprev!=""){
		var sessarray=nextprev.split("^");
		var nextid=document.getElementById("NextSessId");
		if (nextid) nextid=sessarray[2];
		var previd=document.getElementById("PrevSessId");
		if (previd) previd=sessarray[0];
		var next=document.getElementById("NextSession");
		if (next) {
			if (sessarray[2]!="END") {
				var href=next.href;
				var arrya=href.split("&date=");
				var arryb=arrya[1].split("&sessId=");
				var arryc=arryb[1].split("&conSTR=");
				href=arrya[0]+"&date="+sessarray[3]+"&sessId="+sessarray[2]+arryc[1];
				next.href=href
				next.disabled=false;
				next.onclick="";
			} else {
				next.disabled=true;
				next.onclick=LinkDisable;
			}
		}
		var prev=document.getElementById("PrevSession");
		if (prev) {
			if (sessarray[0]!="END") {
				var href=prev.href;
				var arrya=href.split("&date=");
				var arryb=arrya[1].split("&sessId=");
				var arryc=arryb[1].split("&conSTR=");
				href=arrya[0]+"&date="+sessarray[1]+"&sessId="+sessarray[0]+arryc[1];
				prev.href=href
				prev.disabled=false;
				prev.onclick="";
			} else {
				prev.disabled=true;
				prev.onclick=LinkDisable;
			}
		}
	}
}

// Log 61700 - KB - 28/2/2007 New print handler.
function PrintSelectedRowsHandler(tblname,lnk,newwin) {
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
	if (aryfound.length==0) {
		alert(t['NOSELECTION']);
	} else {
		if (newwin=="TRAK_hidden") {
                        //Log 59598 - BOC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
			var hiddenwin=websys_createWindow("","TRAK_hidden","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
			//var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
				document.writeln('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="ApptID">');
				// for each row selected
				for (i in aryfound) {
					var row=aryfound[i];
					// check for specific values - these values must be hidden in the component

					if (!f.elements["ApptIDz"+row]) continue;
					if (f.elements["ApptIDz"+row].value!="") {
						document.writeln('<INPUT NAME="ApptID" VALUE="' + f.elements["ApptIDz"+row].value + '">');
					}
				}

				//Log 63924 - 08.06.2007 - to prevent stack overflow error
				//document.writeln('</FORM><SCR'+'IPT>');
				//document.writeln('window.HFORM.submit();');
				//document.writeln('</SCR'+'IPT></BODY></HTML>');
				// Log 44250 - AI - 26-07-2004 : Some sites are getting stack errors when the Print menu is called after selecting a row.
				//document.close();

				document.writeln('</FORM></BODY></HTML>');
				document.close();
				document.HFORM.submit();
				// End Log 63924
			}
		} else {
			// for each row selected
			for (i in aryfound) {
				var row=aryfound[i];
				// check for specific values - these values must be hidden in the component
				if (!f.elements["ApptIDz"+row]) continue;
				if (f.elements["ApptIDz"+row].value!="") {
					// when the report is crystal and will be previewed pass these parameters so they can
					// be converted to prompt(n) variables.
					PassReportParametersForPreview(lnk,newwin,f.elements["ApptIDz"+row].value);
				}
			}
		}
	}
}



window.document.body.onload=docLoaded;

window.document.body.onunload=PAAdmListDocCurrentRefresh;
