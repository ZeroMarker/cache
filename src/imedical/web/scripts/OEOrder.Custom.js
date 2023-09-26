// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var nparams="";
var vparams="";
var tparams="";
var totCount=0;
var k=0;
var hidItemCnt=0;
var Update=true;
var path="";
var lstGroup1;
var lstGroup2;
var lstGroup3;
var lstGroup4;
var lstGroup5;
var lstOrders;
var OSRowidFromitype="";
var itmidsForQuest="";
var alertreason="";
var strDefaultData="";

var Gparam1="";
var Gparam2="";
var Gparam3="";
var Gparam4="";
var Gcheckval=1;
var Gparam5="";
var Gsdcheckval="Y";
var Aparam1="";
var Acheckval="";
var Dparam1="";
var Dcheckval="";
var Nparam1="";
var Nparam2="";
var Nparam3=""; //This param is not for csp method, it is used in showing the order group number 
var Ncheckval="";
var Uparam1="";
var Uparam2="";
//Log 63171 04/04/07 PeterC 
var OrdDetMultiClick="";
var UpdateClicked=0;

// log 63386 BoC
var QuestionnaireWin="";

//log 64353
var winAlertScreen="";
var OrdExeWin="";
var OrdDetailsWin="";

//jpd 48368
var IspayorObj=document.getElementById("IsPayorOnPage");
var IsplanObj=document.getElementById("IsPlanOnPage");

// JD 54852
var SessionList=0;
var ShowList=document.getElementById("showlist");
if (ShowList) SessionList=ShowList.value;

//log 60877 timeout to allow username and PIN validation
function DelayedRefreshSessionList() {
	setTimeout("RefreshSessionList()",500);
}

function RefreshSessionList(){
	if (SessionList!=1) return;

/*************************************************************************************\
*	Please have a think about what you force into the sessionlist component	      *
*		The frame is refreshed constantly so keep as much of the	      *
*		functionality as possible on the OEOrder.Custom and 		      *
*		oeorder.updateorders.csp submit!				      *
\*************************************************************************************/

	var EpisodeID="";
	var objEpisodeID=document.getElementById("EpisodeID");
	if (objEpisodeID) EpisodeID=objEpisodeID.value;
	var PatientID="";
	var objPatientID=document.getElementById("PatientID");
	if(objPatientID) PatientID=objPatientID.value;

	var url= "websys.default.csp?WEBSYS.TCOMPONENT=OEOrder.SessionList&EpisodeID="+EpisodeID+"&PatientID="+PatientID; 
	websys_createWindow(url,'orderlist');

	//log 62055
	//window.setTimeout("websys_setfocus('Item')",500);

	return;
}
// this is where I will hide order list box AND delete / add to favorites / order details links
function hideel(el){
	var obj=document.getElementById(el);
	if (obj) obj.style.visibility="hidden";
	var luobj=document.getElementById("lt2183i"+el);
	if (luobj) luobj.style.visibility="hidden";
	var cobj=document.getElementById("c"+el);
	if (cobj) cobj.style.visibility="hidden";

	return;
}
if (SessionList==1) {
	hideel("Orders");
	hideel("AddToFav");
	hideel("Delete");
	hideel("OrderDetails");
}

var OrderDetailsOpenCount=0;

var cNewOrders="";
var cCat="";
var cDeletedOrderItemIDs="";
var objDel=document.getElementById("cDeletedOrderItemIDs");
if (objDel) cDeletedOrderItemIDs=objDel.value;
var LabOrderWithoutExternalCode="";
var StockInOtherLoc="";

//used for favourites
var currTab="";
var itemdataDelim = String.fromCharCode(4);
var groupitemDelim = String.fromCharCode(28);
var tabgroupDelim = String.fromCharCode(1);

//if in order entry frame (with eprchart) then allow next item in workflow to jump out of orderframes and back to main frame
if (window.name=="oeorder_entry") {
	if (window.parent.name=="") window.parent.name="OEWIN";
	document.forms['fOEOrder_Custom'].elements['TFRAME'].value=window.parent.name;
}

var evtTimer;
var evtName;
var doneInit=0;

//Disable Clinical Condition for patients not pregnant
var PregFlag=document.getElementById('HidPregFlag');
if (PregFlag && (PregFlag.value!="on")) {
	var obj=document.getElementById('ClinCond');
	if (obj) {
		obj.value="";
		obj.disabled=true;
		var obj=document.getElementById('ld128iClinCond');
		if (obj) obj.disabled=true;
	}
	var obj=document.getElementById('ClinCondDR');
	if (obj) obj.value="";
}

// JPD LOG 52132 26-07-05
function ClinCondLookUp(str) {
	var lu=str.split("^");
	var Code=document.getElementById('ClinCondDR');
	if (Code) Code.value=lu[1];
	var Desc=document.getElementById('ClinCond');
	if (Desc) Desc.value=lu[0];
	return;
}

function BuildRtFrmStr(){
	var obj=document.getElementById('HidRtFrmStr');
	var rtobj=document.getElementById('Route');
	var frmobj=document.getElementById('Form');
	var strobj=document.getElementById('Strength');
	var rt,frm,str=""	

	if (rtobj) rt=rtobj.value;
	if (frmobj) frm=frmobj.value;
	if (strobj) str=strobj.value;

	if (obj) obj.value=rt+"|"+frm+"|"+str;
	//tedt
	PharmParamHandler();
	return;
}

function xItem_lookuphandler(e) {
	if (evtName=='Item') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var url='websys.lookup.csp';
		url += "?ID=d128iItem";
		url += "&CONTEXT=Kweb.OEOrdItem:LookUpItm";
		url += "&TLUJSF=OrderItemLookupSelect";
		var obj=document.getElementById('Item');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		var obj=document.getElementById('GroupID');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		var obj=document.getElementById('Category');
		if (obj) url += "&P3=" + websys_escape(obj.value);
		var obj=document.getElementById('subCatID');
		if (obj) url += "&P4=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P5=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P6=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P7=" + websys_escape(obj.value);
		var obj=document.getElementById('EpisodeID');
		if (obj) url += "&P8=" + websys_escape(obj.value);
		var obj=document.getElementById('OrdCatGrp');
		if (obj) url += "&P12=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
	var obj=document.getElementById('Item');
	if (obj) obj.onkeydown=Item_lookuphandler;
	var obj=document.getElementById('ld128iItem');
	if (obj) obj.onclick=Item_lookuphandler;

//Log 47556	
var evtTimerPharmacy;
var evtNamePharmacy;
var doneInitPharmacy=0;
var brokerflagPharmacy=1;
function PharmacyItem_lookuphandler(e) {
	if (evtNamePharmacy=='PharmacyItem') {
		window.clearTimeout(evtTimerPharmacy);
		evtTimerPharmacy='';
		evtNamePharmacy='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		brokerflagPharmacy=0;
		var url='websys.lookup.csp';
		url += "?ID=d128iPharmacyItem";
		url += "&CONTEXT=Kweb.OEOrdItem:LookUpItm";
		url += "&TLUJSF=OrderItemLookupSelect";
		//var obj=document.getElementById('Item');
		//if (obj) url += "&P1=" + websys_escape(obj.value);
		url += "&P1=XXX";
		var obj=document.getElementById('GroupID');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		var obj=document.getElementById('Category');
		if (obj) url += "&P3=" + websys_escape(obj.value);
		var obj=document.getElementById('subCatID');
		if (obj) url += "&P4=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P5=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P6=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P7=" + websys_escape(obj.value);
		var obj=document.getElementById('EpisodeID');
		if (obj) url += "&P8=" + websys_escape(obj.value);
		var obj=document.getElementById('OrdCatGrp');
		if (obj) url += "&P12=" + websys_escape(obj.value);
		var obj=document.getElementById('PharmacyItem');
		if (obj) url += "&P13=" + websys_escape(obj.value);
		var obj=document.getElementById('Form');
		if (obj) url += "&P14=" + websys_escape(obj.value);
		var obj=document.getElementById('Strength');
		if (obj) url += "&P15=" + websys_escape(obj.value);
		var obj=document.getElementById('Route');
		if (obj) url += "&P16=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
	var obj=document.getElementById('PharmacyItem');
	if (obj) obj.onkeydown=PharmacyItem_lookuphandler;
	var obj=document.getElementById('ld128iPharmacyItem');
	if (obj) obj.onclick=PharmacyItem_lookuphandler;

	
function Item_changehandler(encmeth) {
	evtName='Item';
	if (doneInit) { evtTimer=window.setTimeout("Item_changehandlerX('"+encmeth+"');",200); }
	else { Item_changehandlerX(encmeth); evtTimer=""; }
}
function Item_changehandlerX(encmeth) {
	if (evtTimer) {
		window.clearTimeout(evtTimer);
		evtName='';
		evtTimer='';
	}
	var obj=document.getElementById('Item');

	if (obj.value!='') {
		var tmp=document.getElementById('Item');
		if (tmp) {var p1=tmp.value } else {var p1=''};
		var tmp=document.getElementById('GroupID');
		if (tmp) {var p2=tmp.value } else {var p2=''};
		var tmp=document.getElementById('Category');
		if (tmp) {var p3=tmp.value } else {var p3=''};
		var tmp=document.getElementById('subCatID');
		if (tmp) {var p4=tmp.value } else {var p4=''};
		var tmp=document.getElementById('""');
		if (tmp) {var p5=tmp.value } else {var p5=''};
		var tmp=document.getElementById('""');
		if (tmp) {var p6=tmp.value } else {var p6=''};
		var tmp=document.getElementById('""');
		if (tmp) {var p7=tmp.value } else {var p7=''};
		var tmp=document.getElementById('EpisodeID');
		if (tmp) {var p8=tmp.value } else {var p8=''};
		if (cspRunServerMethod(encmeth,'Item_lookupsel','OrderItemLookupSelect',p1,p2,p3,p4,p5,p6,p7,p8)=='0') {
			obj.className='clsInvalid';
			//websys_setfocus('Item');
			return websys_cancel();
		}
	}
	obj.className='';
}

function HiddenDeleteOrder_changehandler(encmeth) {
	//Dcheckval=cspRunServerMethod(encmeth,Dparam1);
	if (cspRunServerMethod(encmeth,Dparam1)==1) {
		RefreshSessionList();
	}
	return;
}

function HiddenUpdateGroupNumber_changehandler(encmeth) {
	var ret="";
	var selList = lstOrders;
	var length = selList.length;
	ret=cspRunServerMethod(encmeth,Uparam1,Uparam2);
	if (ret=="Y") {
		for (var i=0; i<length; i++) {
			if (selList.options[i].selected) selList.options[i].text=mPiece(selList.options[i].text,"((",0)+"(("+Uparam1+"))";
		}
	}
}

function HiddenNewDentalOrder_changehandler(encmeth) {
	//Dcheckval=cspRunServerMethod(encmeth,Dparam1);
	var EpisodeID="";
	var objEpisodeID=document.getElementById("EpisodeID");
	if (objEpisodeID) EpisodeID=objEpisodeID.value;
	Ncheckval=cspRunServerMethod(encmeth,Nparam1,Nparam2,EpisodeID);
	if (Ncheckval!="") {
		var k=lstOrders.length;
		var NewOrderString="";
		var NewOrder="";
		var OrderDesc="";
		var OrderRowID="";
		var OrderItmMastID="";
		var idata="";
		var itype="";
		for (var bm3=0; bm3<k; bm3++) {
			if (lstOrders.options[bm3].ORIRowId.indexOf(Nparam1)>-1) {
				idata=lstOrders.options[bm3].idata;
				itype=lstOrders.options[bm3].itype;
				break;
			}
		}
		for (var bm3=0; bm3<Ncheckval.split("^").length-1; bm3++) {
			NewOrder=mPiece(Ncheckval,"^",bm3);
			OrderRowID=mPiece(NewOrder,String.fromCharCode(1),0);
			OrderItmMastID=mPiece(NewOrder,String.fromCharCode(1),1);
			OrderDesc=mPiece(NewOrder,String.fromCharCode(1),2);
			if (Nparam3!="") lstOrders.options[k+bm3]=new Option(OrderDesc+"(("+Nparam3+"))",OrderItmMastID);
			else lstOrders.options[k+bm3]=new Option(OrderDesc,OrderItmMastID);
			lstOrders.options[k+bm3].ORIRowId=OrderItmMastID+"*"+OrderRowID+"*V^";
			lstOrders.options[k+bm3].idata=idata;
			if (itype.split(Nparam1).length=1)lstOrders.options[k+bm3].itype=itype;
			if (itype.split(Nparam1).length>1) lstOrders.options[k+bm3].itype=mPiece(itype,Nparam1,0)+OrderRowID+mPiece(itype,Nparam1,1);
			NewOrderString=NewOrderString+lstOrders.options[k+bm3].ORIRowId;
		}
		if (NewOrderString!="") {
			var OEOrdItemIDsobj=document.getElementById("OEOrdItemIDs");
			if (OEOrdItemIDsobj) OEOrdItemIDsobj.value=OEOrdItemIDsobj.value+NewOrderString;
		}
	}
}

function HiddenCheck_changehandler(encmeth) {
	Gcheckval=cspRunServerMethod(encmeth,Gparam1,Gparam2,Gparam3,Gparam4);
}

function HiddenAuthCheck_changehandler(encmeth) {
	Acheckval=cspRunServerMethod(encmeth,Aparam1);
}

function PricesClickHandler() {
}

//prompts if user wants to add item that has already been ordered
function ShouldAddItem(IDs,desc) {

	var match=0;
	var additem=1;
	var date="";
	var careprov="";
	var time="";
	var testepisno="";
	var DetailedMessage="N";
	var ordertype="";
	var EpisodeID="";
	var dupItemDesc="";
	var dupMsg="";

	var obj=document.getElementById("EpisodeID");
	if (obj) EpisodeID=obj.value;
	var currItemsArray=currItems.split("^");
	var IDsArray=IDs.split(String.fromCharCode(12));
	var ID="";

	var IDDesc="";
	var len="";
	var tempIDs=""
	for (var j=0;j<IDsArray.length;j++) {
		ID=IDsArray[j];
		IDDesc=ID.split(String.fromCharCode(14));
		len=IDDesc.length;
		if (len>1) ID=IDDesc[1];
		if (ID=="") continue;
		for (var i=1;i<currItemsArray.length;i++) {
			if ((mPiece(currItemsArray[i],String.fromCharCode(1),0)==ID) && (mPiece(currItemsArray[i],String.fromCharCode(1),0)!="")) {
				match++;
				careprov=mPiece(currItemsArray[i],String.fromCharCode(1),1);
				date=mPiece(currItemsArray[i],String.fromCharCode(1),2);
				time=mPiece(currItemsArray[i],String.fromCharCode(1),3);
				testepisno=mPiece(currItemsArray[i],String.fromCharCode(1),4);
				ordertype=mPiece(currItemsArray[i],String.fromCharCode(1),5);
				DetailedMessage="Y";
				// if it is an order set, save the duplicate order item's desc for warning message
				if (IDsArray.length>1) {
					if (j>0) {
						tempIDs=IDsArray[j+1].split(String.fromCharCode(14));
						if (dupItemDesc!="") dupItemDesc=dupItemDesc+" and ";
						dupItemDesc=dupItemDesc+tempIDs[0];
					}
				}
				break;
			}
		}
		if (IDsArray.length>1 && j>0) continue;
		if(match>0) break;
	}

	if (match > 0) {
		if (DetailedMessage=="Y") {
			// BM Log 32812 Check Department Override for the order item for multiple order
			Gparam1=ID;
			Gparam2=EpisodeID;
			Gparam3=date;
			Gparam4=time;
			var hcobj=document.getElementById('HiddenCheck');
			if (hcobj) hcobj.onclick=hcobj.onchange;
			if (hcobj) {
				hcobj.click();
			}
			if (Gcheckval=="1") {
				if ((ordertype=="L") || (ordertype=="N")) {
					//if it is an order set, display the duplicate order items descs in warning message
					if (IDsArray.length>1 && dupItemDesc!="") {
						if (match==1) {
							//additem=confirm(t['MultipleOrder_Desc']+dupItemDesc+" in "+desc+"\n"+t['MultipleOrder_Date']+date+"\n"+t['MultipleOrder_Time']+time+"\n"+t['MultipleOrder_CareProv']+careprov+"\n"+t['MultipleOrder_TestEpisodeNo']+testepisno+"\n"+t['MultipleOrder_WantToAdd']);
							dupMsg=t['MultipleOrder_Desc']+dupItemDesc+" in "+desc+"<br>"+t['MultipleOrder_Date']+date+"<br>"+t['MultipleOrder_Time']+time+"<br>"+t['MultipleOrder_CareProv']+careprov+"<br>"+t['MultipleOrder_TestEpisodeNo']+testepisno;
						}
						else {
							//additem=confirm(t['MultipleOrder_Desc']+dupItemDesc+" in "+desc+"\n"+t['MultipleOrder_WantToAdd']);
							dupMsg=t['MultipleOrder_Desc']+dupItemDesc+" in "+desc;
						}
					}
					else {
						//additem=confirm(t['MultipleOrder_Desc']+desc+"\n"+t['MultipleOrder_Date']+date+"\n"+t['MultipleOrder_Time']+time+"\n"+t['MultipleOrder_CareProv']+careprov+"\n"+t['MultipleOrder_TestEpisodeNo']+testepisno+"\n"+t['MultipleOrder_WantToAdd']);
						dupMsg=t['MultipleOrder_Desc']+desc+"<br>"+t['MultipleOrder_Date']+date+"<br>"+t['MultipleOrder_Time']+time+"<br>"+t['MultipleOrder_CareProv']+careprov+"<br>"+t['MultipleOrder_TestEpisodeNo']+testepisno;
					}
				} else {
					//if it is an order set, display the duplicate order items descs in warning message
					if (IDsArray.length>1 && dupItemDesc!="") {
						if (match==1) {
							//additem=confirm(t['MultipleOrder_Desc']+dupItemDesc+" in "+desc+"\n"+t['MultipleOrder_Date']+date+"\n"+t['MultipleOrder_Time']+time+"\n"+t['MultipleOrder_CareProv']+careprov+"\n"+t['MultipleOrder_WantToAdd']);
							dupMsg=t['MultipleOrder_Desc']+dupItemDesc+" in "+desc+"<br>"+t['MultipleOrder_Date']+date+"<br>"+t['MultipleOrder_Time']+time+"<br>"+t['MultipleOrder_CareProv']+careprov;
						}
						else {
							//additem=confirm(t['MultipleOrder_Desc']+dupItemDesc+" in "+desc+"\n"+t['MultipleOrder_WantToAdd']);
							dupMsg=t['MultipleOrder_Desc']+dupItemDesc+" in "+desc;
						}
					}
					else {
						//additem=confirm(t['MultipleOrder_Desc']+desc+"\n"+t['MultipleOrder_Date']+date+"\n"+t['MultipleOrder_Time']+time+"\n"+t['MultipleOrder_CareProv']+careprov+"\n"+t['MultipleOrder_WantToAdd']);
						dupMsg=t['MultipleOrder_Desc']+desc+"<br>"+t['MultipleOrder_Date']+date+"<br>"+t['MultipleOrder_Time']+time+"<br>"+t['MultipleOrder_CareProv']+careprov;
					}
				}
			}
		} else {
			//if it is an order set, display the duplicate order items descs in warning message
			if (IDsArray.length>1 && dupItemDesc!="") {
				//additem=confirm(t['MultipleOrder_Desc']+dupItemDesc+" in "+desc+"\n"+t['MultipleOrder_WantToAdd']);
				dupMsg=t['MultipleOrder_Desc']+dupItemDesc+" in "+desc;
			}
			else {
				//additem=confirm(t['MultipleOrder_Desc']+desc+"\n"+t['MultipleOrder_WantToAdd']);
				dupMsg=t['MultipleOrder_Desc']+desc;
			}
		}
	}
	return dupMsg;
}

function AgeSexRestrictionCheck(selItmid,seldesc,selsubcatcode,seldur,selmatch,obj,seltype) {
	var DrugString="";
	var EpisObj=document.getElementById("EpisodeID");
	if (EpisObj) EpisID=EpisObj.value;

	var DDObj=document.getElementById("DischDate");
	if(DDObj && (DDObj.value!="")) {
		selmatch="found"
	}

	if (selsubcatcode=="R") {
		DrugString=DrugInteractionCheck(selItmid,seldesc,seldur,"");
		var DIobj=document.getElementById("DrugString");
		if ((DIobj)&&(DrugString!="")) DIobj.value=DrugString;
	}
	var PatObj=document.getElementById("PatientID");
	if (PatObj) PatID=PatObj.value;

	var DateObj=document.getElementById("Date");
	if (DateObj) DateVal=DateObj.value;

	var OrderSetRowid=lstOrders.options[lstOrders.selectedIndex].value;

	var f1=top.frames['TRAK_hidden'];
	//AmiN  log25880 adding message for items not covered by insurance    IT is an F ONE not F L
	if (f1) {
		//ANA LOG 25687 Checks system flag to decide wether to show message as a pop up or on the summary screen. 30-SEP-02
		var alertOBJ=document.getElementById("SUMMFlag")
		if ((alertOBJ)&&(alertOBJ.value!="Y")) {
			DrugString=escape(DrugString);
			OrderSetRowid=escape(OrderSetRowid);
			f1.location="oeorder.agesexrestriction.csp?PatID="+PatID+"&OEORIItmMastDR="+selItmid+"&ARCIMDesc="+seldesc+"&durid="+seldur+"&CatMatch="+selmatch+"&OrderSetRowid="+OrderSetRowid+"&DateVal="+DateVal+"&EpisID="+EpisID+"&type="+seltype+"&drugs="+DrugString;
			//f1.location="oeorder.agesexrestriction1.csp?PatID="+PatID+"&OEORIItmMastDR="+selItmid+"&ARCIMDesc="+seldesc+"&durid="+seldur+"&CatMatch="+selmatch+"&OrderSetRowid="+OrderSetRowid+"&DateVal="+DateVal+"&EpisID="+EpisID+"&type="+seltype+"&drugs="+DrugString;
		} else {
			if (selmatch=="found") {
				//OrderDetailsOpen(seldesc,"",selItmid,OrderSetRowid,EpisID);
			}
		}
	}
	else if (selmatch=="found") {
		//OrderDetailsOpen(seldesc,"",selItmid,OrderSetRowid,EpisID);
	}
}
function AlertCheck(selItmid,seldesc,selsubcatcode,seldur,selmatch,obj,seltype) {
	var DrugString="";
	var EpisObj=document.getElementById("EpisodeID");
	if (EpisObj) EpisID=EpisObj.value;

	var DDObj=document.getElementById("DischDate");
	if(DDObj && (DDObj.value!="")) {
		selmatch="found"
	}

	if (selsubcatcode=="R") {
		DrugString=DrugInteractionCheck(selItmid,seldesc,seldur,"");
		var DIobj=document.getElementById("DrugString");
		if ((DIobj)&&(DrugString!="")) DIobj.value=DrugString;
	}
	var PatObj=document.getElementById("PatientID");
	if (PatObj) PatID=PatObj.value;

	var DateObj=document.getElementById("Date");
	if (DateObj) DateVal=DateObj.value;

	var OrderSetRowid=lstOrders.options[lstOrders.selectedIndex].value;

	var f1=top.frames['TRAK_hidden'];
	//AmiN  log25880 adding message for items not covered by insurance    IT is an F ONE not F L
	if (f1) {
		//ANA LOG 25687 Checks system flag to decide wether to show message as a pop up or on the summary screen. 30-SEP-02
		DrugString=escape(DrugString);
		OrderSetRowid=escape(OrderSetRowid);
		f1.location="oeorder.agesexrestriction.csp?PatID="+PatID+"&OEORIItmMastDR="+selItmid+"&ARCIMDesc="+seldesc+"&durid="+seldur+"&CatMatch="+selmatch+"&OrderSetRowid="+OrderSetRowid+"&DateVal="+DateVal+"&EpisID="+EpisID+"&type="+seltype+"&drugs="+DrugString;
	}
}

function DrugInteractionCheck(selItmid,selItmDesc,selItmDur,os) {
	var EpisObj=document.getElementById("EpisodeID");
	if (EpisObj) EpisID=EpisObj.value;

	var selList = lstOrders;
	var length = selList.length;
	var drugs="";
	var subcatcode="";
	var listItem="";
	var listValue="";
	var dur="";
	var drugParams="";
	for (var i=0; i<length; i++) {
		subcatcode=mPiece(selList.options[i].id,String.fromCharCode(4),0);
		if (subcatcode=="R") {
			listItem = selList.options[i].text;
			listValue = selList.options[i].value;
			dur = mPiece(selList.options[i].id,String.fromCharCode(4),1);
			drugParams=listValue+String.fromCharCode(2)+String.fromCharCode(2)+dur+String.fromCharCode(2);
			drugs=drugs+drugParams+String.fromCharCode(5);
		}
	}
	//var f2=top.frames['TRAK_hidden'];
	//if ((os!="") && (f2)) top.frames['TRAK_hidden'].location="oeorder.druginteractions.csp?itmMast="+selItmid+"&durid="+selItmDur+"&drugs="+drugs+"&EpisodeID="+EpisID+"&ordDesc="+selItmDesc+"&forderset="+os;
	return drugs;
}
function getAlertDesc(desc) {
	var listid = lstOrders.options[lstOrders.length-1].id;
	lstOrders.options[lstOrders.length-1].id = listid + String.fromCharCode(4)+desc;
}

function AddClinPathOrder() {
	//Log 61687 06/12/06 PeterC
	var ClinPathIDs="";
	if (document.getElementById("StepPathIds")) { ClinPathIDs=document.getElementById("StepPathIds").value; }
	var HidClinPathSttDate="09/12/2006";
	if (ClinPathIDs!=""){
		var rep=ClinPathIDs.split("*");
		for (i=0;i<rep.length;i++) {
			var idesc,icode,iorderCatID,OSItemIDs,type="";
			icode=mPiece(rep[i],"^",0);
			idesc=mPiece(rep[i],"^",1);
			iorderCatID=mPiece(rep[i],"^",2);
			OSItemIDs=mPiece(rep[i],"^",3);
			if (icode.indexOf("||")>-1) type="ARCIM";
			else {type="ARCOS";}
			AddItemToList(lstOrders,icode,idesc,"",type,"","","",iorderCatID,"","",OSItemIDs);
		}
		if (document.getElementById("StepPathIds")) { document.getElementById("StepPathIds").value=1; }
		SelectAllItemList();
		UpdateOnAddClick(1);
	}
}

function AddSOAPorders() {
	// JD 61812
	var NO_ADD="";
	if (document.getElementById("NO_ADD")) { NO_ADD=document.getElementById("NO_ADD").value; }

	if ((SOAPorders!="") && (NO_ADD=="")) {
		var rep=SOAPorders.split("*");
		for (i=0;i<rep.length;i++) {
			var idesc,icode,itypecode,iordertype,iorderCatID,idur,isetid,OSItemIDs="";
			icode=mPiece(rep[i],"^",10);
			idesc=mPiece(rep[i],"^",1);
			itypecode=mPiece(rep[i],"^",2);
			iordertype=mPiece(rep[i],"^",3);
			isetid=mPiece(rep[i],"^",6);
			OSItemIDs=mPiece(rep[i],"^",5);
			iorderCatID=mPiece(rep[i],"^",7);
			idur=mPiece(rep[i],"^",8);

			if(OSItemIDs!="") {
				var Itemids="";
				Itemids=icode+String.fromCharCode(12)+OSItemIDs;
				var OSItemIDArr=OSItemIDs.split(String.fromCharCode(12))
				for (var ii=0;ii<OSItemIDArr.length;ii++) {
					if (OSItemIDArr[ii].split(String.fromCharCode(14)).length > 1) OSItemIDArr[ii]=OSItemIDArr[ii].split(String.fromCharCode(14))[1];
				}
				OSItemIDs=OSItemIDArr.join(String.fromCharCode(12));
			}
			AddItemToList(lstOrders,icode,idesc,itypecode,iordertype,"","",isetid,iorderCatID,idur,"1",OSItemIDs,"","","","");
		}
		if (document.getElementById("NO_ADD")) { document.getElementById("NO_ADD").value=1; }
		SelectAllItemList();
		UpdateOnAddClick(1);
	}
}

function AddRepeatOrders() {
	// JD 61812
	var NO_ADD="";
	if (document.getElementById("NO_ADD")) { NO_ADD=document.getElementById("NO_ADD").value; }

	if ((RepeatOrdersFromEPR!="") && (NO_ADD=="")) {
		var repeat=RepeatOrdersFromEPR.split(String.fromCharCode(6));
		var iorderRowId="";
		var icode="";
		var idesc="";
		var isubcatcode="";
		var iordertype="";
		var iorderCatID="";
		var idur="";
		var imes="";
		for (i=0;i<repeat.length;i++) {
			iorderRowId=mPiece(repeat[i],String.fromCharCode(4),0)
			icode=mPiece(repeat[i],String.fromCharCode(4),10)
			idesc=mPiece(repeat[i],String.fromCharCode(4),1)
			isubcatcode=mPiece(repeat[i],String.fromCharCode(4),2)
			iordertype=mPiece(repeat[i],String.fromCharCode(4),3)
			iorderCatID=mPiece(repeat[i],String.fromCharCode(4),7)
			idur=mPiece(repeat[i],String.fromCharCode(4),8)
			imes=mPiece(repeat[i],String.fromCharCode(4),9)
			AddItemToList(lstOrders,icode,idesc,isubcatcode,iordertype,"","","",iorderCatID,idur,"","","",iorderRowId,"","");
		}
		if (document.getElementById("NO_ADD")) { document.getElementById("NO_ADD").value=1; }
		//Log 42624 PeterC 22/03/04 Need to highlight all orders to avoid incorrect assigning of OEORowID
		
		SelectAllItemList();
		UpdateOnAddClick(1);
	}
}

function SelectAllItemList() {
	for (pi=0;pi<lstOrders.length;pi++) {
		lstOrders.options[pi].selected=true;
	}
}

//Log 49182 PeterC 20/04/05 Use the below function to tell which order has yet to be updated.
function SelectAllPreUpdateItem() {
	for (pi=0;pi<lstOrders.length;pi++) {
		var HasUpdate=lstOrders.options[pi].itype;
		if(HasUpdate.indexOf("*V")==-1) lstOrders.options[pi].selected=true;
	}
}

function OrderDetailsPage(f) {
		var OEOrdItemIDsobj=document.getElementById("OEOrdItemIDs");
		var txtobj=document.getElementById("itemtext"); //Enter item with free text area
		if (txtobj) {
			itemtext=txtobj.value;
			var str=StripAllSpaces(itemtext);
		}
		if (lstOrders.selectedIndex == -1) {
			return;
		}
		var ItemDesc = mPiece(lstOrders.options[lstOrders.selectedIndex].text,"((",0);
		var itemdata=lstOrders.options[lstOrders.selectedIndex].idata;
		var itemvalue=lstOrders.options[lstOrders.selectedIndex].value;  // OrderSetRowid
		var itype=lstOrders.options[lstOrders.selectedIndex].itype;
		var CatID=mPiece(lstOrders.options[lstOrders.selectedIndex].itype,String.fromCharCode(4),3);
		var SubCatID=mPiece(lstOrders.options[lstOrders.selectedIndex].itype,String.fromCharCode(4),5);
		var ORIRowID="";
		var OrdRowIdString="";
		ORIRowID=lstOrders.options[lstOrders.selectedIndex].ORIRowId;
		
		OrdRowIdString=ORIRowID;
		if ((ORIRowID!="")&&(ORIRowID!=null)) {
			var NewOrderArr=ORIRowID.split("^")
			var ORIRowID="";
			var currOrder="";
			var ORIRowIDArr="";
			for (var jl=0;jl<NewOrderArr.length;jl++) {
				currOrder=NewOrderArr[jl]
				if(currOrder=="") continue;
				ORIRowIDArr=currOrder.split("*")
				if (ORIRowIDArr.length>1) ORIRowID=ORIRowID+ORIRowIDArr[1]+"^";
			}
			ORIRowID=ORIRowID.substring(0,(ORIRowID.length-1))
			//var ORIRowIDArr=ORIRowID.split("*")
			//ORIRowID=ORIRowIDArr[1];
			}
		var ItemId=lstOrders.options[lstOrders.selectedIndex].id;

		var OSRowid=itemvalue;
		var OSRowidFromitype = mPiece(itype,String.fromCharCode(4),2);
		if (!OSRowidFromitype) {
			OSRowidFromitype="";
		}
		OrderDetailsOpenCount++;
		if (mPiece(itype,String.fromCharCode(4),0)=="ARCOS") {
			//Log 63171 04/04/07 PeterC
			OrdDetMultiClick="";
			OSItemListOpen(OSRowid,ItemDesc,"YES","",OrdRowIdString);
		} else if (OSRowid.indexOf("||")<0) {
			//Log 63171 04/04/07 PeterC
			OrdDetMultiClick="";
			OSItemListOpen(OSRowid,ItemDesc,"YES","",OrdRowIdString);
		} else {
			if (!itemdata) itemdata="";
			if (OSRowidFromitype!="") OSRowid=OSRowidFromitype;
			if (mPiece(itemdata,String.fromCharCode(1),4)=="NODETAILS") itemdata="";
			var EpisObj=document.getElementById("EpisodeID");
			if (EpisObj) EpisID=EpisObj.value;
			if (ORIRowID=="") {
				var itypeLen=itype.split(String.fromCharCode(4)).length;
				if (itypeLen>1) ORIRowID=mPiece(itype,String.fromCharCode(4),itypeLen-2);
				if (ORIRowID.split("*").length>1) ORIRowID=mPiece(ORIRowID,"*",1);
			}
			OrderDetailsOpen(ItemDesc,itemdata,itemvalue,OSRowid,EpisID,ORIRowID); // itemvalue from item selected in Selected Orders
			//Log 58162 BoC
			setTimeout("QuestionnaireOpen('"+CatID+"','"+SubCatID+"','"+ORIRowID+"','"+EpisID+"','"+itemvalue+"')",1500);
		}
}
function OrderDetailsShowing(f,ShowAutoOnly) {
		var txtobj=document.getElementById("itemtext"); //Enter item with free text area
		if (txtobj) {
			itemtext=txtobj.value;
			var str=StripAllSpaces(itemtext);
		}
		//if ((lstOrders.selectedIndex == -1) && ((str==""))) {
		//Log 41115 PeterC: Modified the above for freetext to work
		if (lstOrders.selectedIndex == -1) {
			//alert("Please select an item");
			return;
		}
		if (lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount] && lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].selected) {
			var ItemDesc = lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].text;
			var itemdata=lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].idata;
			var itemvalue=lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].value;  // OrderSetRowid
			var itype=lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].itype;
			var CatID=mPiece(lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].itype,String.fromCharCode(4),3);
			var SubCatID=mPiece(lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].itype,String.fromCharCode(4),5);
			var HasAutoPopUp=mPiece(lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].itype,String.fromCharCode(4),6);
			var ORIRowID=""
			ORIRowID=lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].ORIRowId;
			if (ORIRowID!="") {
				var ORIRowIDArr=ORIRowID.split("*")
				if (ORIRowIDArr.length>1) ORIRowID=ORIRowIDArr[1];
			}
			var OSOrdRowIdString="";
			var itypeLen=itype.split(String.fromCharCode(4)).length;
			if (itypeLen>1) OSOrdRowIdString=mPiece(itype,String.fromCharCode(4),itypeLen-2);

			var OSRowid=itemvalue;
			var OSRowidFromitype = mPiece(itype,String.fromCharCode(4),2);
			if (!OSRowidFromitype) {
				OSRowidFromitype="";
			}

			var LinkedItmID1="";
			var newOrderValue=lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].text;
			if (newOrderValue.substring(0,5)=="     ") {
				var bCanCopy=false;
				var orderValue="";
				var orderType="";
				for (var bm8=0;bm8<lstOrders.selectedIndex+OrderDetailsOpenCount;bm8++) {
					orderValue=lstOrders.options[bm8].text;
					orderType=mPiece(lstOrders.options[bm8].id,String.fromCharCode(4),0);
					if (orderValue.substring(0,1)!=" ") {
						if (orderType=="R") {
							bCanCopy=true;
							LinkedItmID1=lstOrders.options[bm8].ORIRowId;
							if (LinkedItmID1.split("*").length>1) LinkedItmID1=mPiece(LinkedItmID1,"*",1);
						}
			 			else {
							bCanCopy=false;
							LinkedItmID1="";
						}
					}
				}
				lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].text="   "+newOrderValue.substring(5,newOrderValue.length)
			}

			OrderDetailsOpenCount++;
			if (mPiece(itype,String.fromCharCode(4),0)=="ARCOS") {
				var open="";
				//Log 44538 28/07/04 PeterC: Take out the first item in OS for testing
				var OSFirstItem=newItmMastDR=mPiece(mPiece(OSOrdRowIdString,"^",0),"*",0);
				//Log 49059 PeterC 22/03/05: Now pass "OSRowid" into matchCategory
				if (matchCategory("OS",CatID,SubCatID,(OSFirstItem+"^"+OSRowid))) {
				//if (matchCategory("OS",CatID,SubCatID,itemvalue)) {
					//Log 63171 04/04/07 PeterC
					OrdDetMultiClick="";
					OSItemListOpen(OSRowid,ItemDesc,"YES","",OSOrdRowIdString);
				}
				else if (open=="Y") {
					//Log 63171 04/04/07 PeterC
					OrdDetMultiClick="";
					OSItemListOpen(OSRowid,ItemDesc,"YES","",OSOrdRowIdString);
				}
				else OrderDetailsShowing(f);
			} else if (OSRowid.indexOf("||")<0) {
				if (matchCategory("OS",CatID,SubCatID,itemvalue)) {
					//Log 63171 04/04/07 PeterC
					OrdDetMultiClick="";
					OSItemListOpen(OSRowid,ItemDesc,"YES","",OSOrdRowIdString);
				}
				else OrderDetailsShowing(f);
			} else {
				if (!itemdata) itemdata="";
				if (OSRowidFromitype!="") OSRowid=OSRowidFromitype;

				if (mPiece(itemdata,String.fromCharCode(1),4)=="NODETAILS") itemdata="";
				var EpisObj=document.getElementById("EpisodeID");
				if (EpisObj) EpisID=EpisObj.value;
				//Log 49059 PeterC 15/02/05: Do not pop up the detail page again if it already has pop up
				if((matchCategory("IM",CatID,SubCatID,itemvalue) && (HasAutoPopUp!="1")) || (LinkedItmID1!="")) {
					OrderDetailsOpen(ItemDesc,itemdata,itemvalue,OSRowid,EpisID,ORIRowID,LinkedItmID1); // itemvalue from item selected in Selected Orders
					//Log 52136 16/05/05 PeterC
					
					//Log 58162 BoC
					setTimeout("QuestionnaireOpen('"+CatID+"','"+SubCatID+"','"+ORIRowID+"','"+EpisID+"','"+itemvalue+"')",3500);

					var DataStr = lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount-1].itype
					var lu=DataStr.split(String.fromCharCode(4));
					if(lu) {
						lu[6]="1";
						DataStr=lu.join(String.fromCharCode(4));
						DataStr=DataStr.replace("undefined","");
						lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount-1].itype=DataStr;
					}
				}
				else if (mPiece(StockInOtherLoc,itemvalue+"*",0)!=StockInOtherLoc) { // If the stock exists in other Receiving Location, user choose to continue order this item, pop up the detail screen to ask user to choose a rec loc.
					OrderDetailsOpen(ItemDesc,itemdata,itemvalue,OSRowid,EpisID,ORIRowID,LinkedItmID1); 
					setTimeout("QuestionnaireOpen('"+CatID+"','"+SubCatID+"','"+ORIRowID+"','"+EpisID+"','"+itemvalue+"')",3500);
				}
				else if(OrdDetMultiClick=="Y") {
					//Log 63171 04/04/07 PeterC
					OrderDetailsOpen(ItemDesc,itemdata,itemvalue,OSRowid,EpisID,ORIRowID,LinkedItmID1);
				}
				else OrderDetailsShowing(f);
			}
		}
		else if(!lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount]) {
			//Log 63171 04/04/07 PeterC
			OrdDetMultiClick=""
		}
}
function OrderDetailsOpen(sItemDesc,sitemdata,sitemvalue,sOSRowid,sEpisodeID,ORIRowID,LinkedItmID1,delayed) {
		//log 62148 BoC escape sItemDesc for setTimeout
		if (!delayed) {
			sItemDesc=escape(sItemDesc);
		}
		var win=window.open('',"AlertScreen");
		var uobj="";
		if (win) uobj=win.document.getElementById("Update");
		if ((win)&&(uobj)) {
			setTimeout("OrderDetailsOpen('"+sItemDesc+"','"+sitemdata+"','"+sitemvalue+"','"+sOSRowid+"','"+sEpisodeID+"','"+ORIRowID+"','"+LinkedItmID1+"','true')",500);
		}
		else {
		if (win) win.window.close();
		var OkToOpen=1;
		var OSdefSobj=document.getElementById("OECFDefaultCheckBsUnselect");
		var OSIndex=sOSRowid.indexOf("||");
		//if ((OSdefSobj)&&(OSdefSobj.value=="Y")&&(OSIndex==-1)) OkToOpen=0;
		var PatObj=document.getElementById("PatientID");
		if (PatObj) PatientID=PatObj.value;
		var EpisLoc=document.getElementById("EpisLoc");
		if (EpisLoc) {var PatientLocation=EpisLoc.value;} else {
			var PatLoc=document.getElementById("PatLoc");
			if (PatLoc) var PatientLocation=PatLoc.value;
		}
		//log60454 TedT use websys_escape instead of escape
		if (PatientLocation!="") PatientLocation=websys_escape(PatientLocation);
		//if (sItemDesc!="") sItemDesc=escape(sItemDesc);
		if (!LinkedItmID1) LinkedItmID1="";
		//Loads default values - if default carry to every item - log 22982
		if (sitemdata=="") sitemdata=strDefaultData;
		var context="";
		var contextobj=document.getElementById("CONTEXT");
		if (contextobj) context=contextobj.value;
		var OrderedRowIDs="";
		for (var bm6=0;bm6<lstOrders.length;bm6++) {
			if (bm6!=lstOrders.selectedIndex) {
				OrderedRowIDs=OrderedRowIDs+lstOrders.options[bm6].ORIRowId+"^";
			}
		}
		var CantModifyToothFlag="";
		var TeethIDsobj=document.getElementById("TeethIDs");
		if ((TeethIDsobj)&&(TeethIDsobj.value!="")) CantModifyToothFlag="Y";
		//Log 50088 PeterC 21/03/05 Need to escape the itemdata
		//log 60454 TedT use websys_escape instead of escape
		if(sitemdata!="") sitemdata=websys_escape(sitemdata);
		
		var Weightobj=document.getElementById("MRObsWeight");
		var Heightobj=document.getElementById("MRObsHeight");
		if (Heightobj) {Height=Heightobj.value;}
		else {Height="";}
		if (Weightobj) {Weight=Weightobj.value;}
		else {Weight="";}
		//log 61451 TedT pass all ORIRowID instead of first part only
		//ORIRowID=mPiece(ORIRowID,"^",0) 
		//log 61419 BoC
		//var CareProv="";
		//var CareProvObj=document.getElementById("CareProv");
		//if (CareProvObj) CareProv=CareProvObj.value
		//var OrderDoctor=""
		//var OrderDoctorObj=document.getElementById("Doctor");
		//if (OrderDoctorObj) OrderDoctor=OrderDoctorObj.value;
		//if ((CareProv=="")&&(OrderDoctor!="")) CareProv=OrderDoctor;
		//log 63163 remove "&PatientLoc="+PatientLocation+ // +"&Doctor="+CareProv
		var url = "oeorder.mainloop.csp?ID="+ORIRowID+"&ARCIMDesc="+sItemDesc+"&EpisodeID="+sEpisodeID+"&itemdata="+sitemdata+"&OEORIItmMastDR="+sitemvalue+"&ORDERSETID="+sOSRowid+"&PatientID="+PatientID+"&LinkedOrder="+LinkedItmID1+"&OrderWindow="+window.name+"&CONTEXT="+context+"&OrderedRowIDs="+OrderedRowIDs+"&CantModifyToothFlag="+CantModifyToothFlag+"&Weight="+Weight+"&Height="+Height;
        	if(OkToOpen==1) OrdDetailsWin=websys_createWindow(url, "frmOrderDetails","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
		}
}

//Log 58162 BoC 05/09/2006: new function to open Questionnaire window if it's defined.
function QuestionnaireOpen(CatID,SubCatID,ORIRowID,EpisID,itemvalue) {
	if (matchQuesCategory(CatID,SubCatID,itemvalue)) {
		var PatObj=document.getElementById("PatientID");
		if (PatObj) PatientID=PatObj.value;
		var win=window.open('',"frmOrderDetails");
		if (win) {
			var QnaireId="";
			var obj=win.document.getElementById("QuestionnaireID");
			if (obj) QnaireId=obj.value;
			var obj=win.document.getElementById("ID");
			if (obj) OEId=obj.value;
			var obj=win.document.getElementById("QuestRowID");
			if (obj) QuestRowId=obj.value;
			if ((QnaireId=="")||(OEId=="")) {
				if (win.frames["OrdDetFrame"]) {
					var obj=win.frames["OrdDetFrame"].document.getElementById("QuestionnaireID");
					if (obj) QnaireId=obj.value;
					var obj=win.frames["OrdDetFrame"].document.getElementById("ID");
					if (obj) OEId=obj.value;
					var obj=win.frames["OrdDetFrame"].document.getElementById("QuestRowID");
					if (obj) QuestRowId=obj.value;
				}
			}
		}        
		if (QnaireId!="") {
			//Log 64787 PeterC 07/01/08: Shouldn't pass multiple PatientID and EpisodeID
			PatientID=mPiece(PatientID,"^",0);
			EpisID=mPiece(EpisID,"^",0);
			OEId=mPiece(OEId,"^",0);
			var url = "ssuserdefwindowcontrols.questionnaire.csp?QuestionnaireID="+QnaireId+"&PatientID="+PatientID+"&EpisodeID="+EpisID+"&OEORIRowId="+OEId+"&ID="+QuestRowId+"&norefresh=1";
			// log 63386 BoC
			QuestionnaireWin=websys_createWindow(url, "","top=0,width=500,toolbar=no,top=10,left=10,directories=no,menubar=no,scrollbars=yes,resizable=yes");
		}
	}
}

function CollectedFields(DataFields){
	var selItem=lstOrders.options[lstOrders.selectedIndex];
	selItem.idata=DataFields;
}

function SetDefaultData(sDefaultData) {
	var obj=document.getElementById("DefaultData");
	strDefaultData=sDefaultData;
	if (obj) obj.value=sDefaultData
}

function KeepPriority() {
	var obj=document.getElementById("OECFKeepPriorDateSession");
	if (obj) {
		if (obj.value=="Y") {
			return true;
		} else {
			return false;
		}
	}
	return false
}

function CheckFreqBeforeUpdate() {
	var length = lstOrders.length;
	for (var i=0; i<length; i++) {
		if (lstOrders.options[i].id="NO DEFAULT") {
			Update=false;
			break;
		}
	}
}
function getDelim(val) {
	var delim="";
	if (val>0) {
		for (i=1;i<val;i++) {
			delim=delim+String.fromCharCode(1);
		}
		return delim;
	}
}
// removes all spaces from a string
function StripAllSpaces(str)  {
	var re = /(\s)/g ;
	return str.replace(re,"");
}


function OrderItemLookupSelect(txt) { //passed in from the component manager.
	//Add an item to lstOrders when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var idesc=adata[0];
	var icode=adata[1];
	var ifreq=adata[2];
	var iordertype=adata[3];
	var ialias=adata[4];
	var isubcatcode=adata[5];
	var iorderCatID=adata[6];
	var iSetID=adata[7];
	var mes=adata[8];
	var irangefrom=adata[9];
	var irangeto=adata[10]
	var iuom=adata[11];
	var idur=adata[12];
	var igeneric=adata[13];
	var match="notfound";
	var SetRef=1;
	var OSItemIDs=adata[15];
	var iorderSubCatID=adata[16];

	window.focus();

	if (iordertype=="ARCIM") iSetID="";
	var Itemids="";
	if(OSItemIDs=="") Itemids=icode;
	else Itemids=icode+String.fromCharCode(12)+OSItemIDs;

	//var DupMsg=ShouldAddItem(Itemids,idesc);
	//cDupMsg=icode+"^"+DupMsg+String.fromCharCode(4);
	// move the duplicate order check to summaryscreen
	var OSItemIDArr=OSItemIDs.split(String.fromCharCode(12))
	for (var i=0;i<OSItemIDArr.length;i++) {
		if (OSItemIDArr[i].split(String.fromCharCode(14)).length > 1) OSItemIDArr[i]=OSItemIDArr[i].split(String.fromCharCode(14))[1];
	}
	OSItemIDs=OSItemIDArr.join(String.fromCharCode(12));
	if (!lstOrders) lstOrders=document.getElementById("Orders");
	AddItemToList(lstOrders,icode,idesc,isubcatcode,iordertype,ialias,"",iSetID,iorderCatID,idur,SetRef,OSItemIDs,iorderSubCatID,"","","");

	//AgeSexRestrictionCheck(icode,idesc,isubcatcode,idur,match,"",iordertype);

	document.fOEOrder_Custom.Item.value="";
	if (document.fOEOrder_Custom.PharmacyItem) document.fOEOrder_Custom.PharmacyItem.value="";
	UpdateOnAddClick();
	//log 62055
	//window.setTimeout("websys_setfocus('Item')",600);
}

function GetFreeText() {
	var freeText="";
	var obj = document.getElementById("itemtext")
	if (obj) {
		freeText=obj.value;
		var str=StripAllSpaces(freeText);
		if (str!="") {
			var fields=UpdateFields("",freeText)
			////AddInputCust(String.fromCharCode(1)+String.fromCharCode(1)+String.fromCharCode(1)+fields);
			//var delim=getDelim(63);
			//freeText=delim+freeText;
		}
	}
}

function UpdateFields(idata,text,Freq,Dur,Priority,DosageQty,Status,ProcNote) {
	//var arrElem = new Array("CopyOrderRowId","ID","EpisodeID","OEORIItmMastDR","ORDERSETID","OECPRDesc","OSTATDesc","CTLOCDesc","OEORISttDat","OEORISttTim","OEORIItemGroup","OEORIQty","OEORIRemarks","OEORIDepProcNotes","OEORIDoseQty","CTUOMDesc","PHCFRDesc1","PHCINDesc1","PHCDUDesc1","OEORIMaxNumberOfRepeats","OEORILabEpisodeNo","OEORILab1","OEORILab2","TestSetCode","DeptDesc","CTPCPDesc","CONSDesc","OEORIWhoGoWhere","OEORIPrice","Doctor","RMFrequency","RMDuration","OEORIBillDesc","BillPrice","OrderTypeCode","MealType","RiceType","Volume","Energy","Protein","Fat","Carbohydrate","DelayMeal","SteriliseUtensils","PasteurisedFood","CoveredByMainInsur","PortableEquiptRequired","AdmAfterSkinTest","ContactCareProv","AlertReason","CareProvList","NeedleGauge","NeedleType","BodySite","QuantityUnit","FlowQuantity","FlowTimeUnit","FlowTime","FlowRateDescr","FlowRateUnit","Interval","teeth","ColDate","ColTime","freeText","ReceivedDate","ReceivedTime");
	var arrElem = new Array("ID","EpisodeID","OEORIItmMastDR","ORDERSETID","OECPRDesc","OSTATDesc","CTLOCDesc","OEORISttDat","OEORISttTim","OEORIItemGroup","OEORIQty","OEORIRemarks","OEORIDepProcNotes","OEORIDoseQty","CTUOMDesc","PHCFRDesc1","PHCINDesc1","PHCDUDesc1","OEORIMaxNumberOfRepeats","OEORILabEpisodeNo","OEORILab1","OEORILab2","TestSetCode","DeptDesc","CTPCPDesc","CONSDesc","OEORIWhoGoWhere","OEORIPrice","Doctor","RMFrequency","RMDuration","OEORIBillDesc","BillPrice","OrderTypeCode","MealType","RiceType","Volume","Energy","Protein","Fat","Carbohydrate","DelayMeal","SteriliseUtensils","PasteurisedFood","CoveredByMainInsur","PortableEquiptRequired","AdmAfterSkinTest","ContactCareProv","AlertReason","CareProvList","NeedleGauge","NeedleType","BodySite","QuantityUnit","FlowQuantity","FlowTimeUnit","FlowTime","FlowRateDescr","FlowRateUnit","Interval","teeth","ColDate","ColTime","freeText","ReceivedDate","ReceivedTime","","OEORIRefDocDR");
	var arrData = new Array(arrElem.length);
	var PNobj=document.getElementById("OEORIDepProcNotes");
	var RDobj=document.getElementById("OEORIRefDocDR");
	var dobj=document.getElementById("Doctor");
	var gobj=document.getElementById("OEORIItemGroup");
	var STDObj=document.getElementById("OEORISttDat");
	var ProcNotes="";
	var Doctor="";
	var Group="";
	var ReffDr="";
	var StartDate="";

	if (PNobj) ProcNotes=PNobj.value;
	while(ProcNotes.indexOf(String.fromCharCode(13))!=-1) {
		ProcNotes=ProcNotes.replace(String.fromCharCode(13),"|");
	}
	arrData=idata.split(String.fromCharCode(1));
	for (var i=0; i<arrElem.length; i++) {
		if (arrElem[i]=="OEORIDepProcNotes" && ProcNotes!="") {
			if (arrData[i]!=null) {
				arrData[i]=arrData[i]+String.fromCharCode(13)+String.fromCharCode(10)+String.fromCharCode(13)+String.fromCharCode(10)+ProcNotes;
			} else {
				arrData[i]=ProcNotes;
			}
		}
		//Log 51206 13/04/05 PeterC
		if ((arrElem[i]=="OEORIRefDocDR")&&(ReffDr!="")) {
			 if ((arrData[i]=="") || (arrData[i]==null)) arrData[i]=ReffDr;
		}
		if (arrElem[i]=="Doctor") {
			if ((arrData[i]=="") || (arrData[i]==null)) arrData[i]=Doctor;
		}
		if (text!=="" && arrElem[i]=="freeText") arrData[i]=String.fromCharCode(1)+text;
		//Log 48562 18/04/05 PeterC
		if ((arrElem[i]=="OEORISttDat")&&(StartDate!="")) {
			 if ((arrData[i]=="") || (arrData[i]==null)) arrData[i]=StartDate;
		}

	}
	var str=arrData.join(String.fromCharCode(1));
	return str;
}
function GetOrderData() {
	// This will now gather all the OEOriRowIds and set them into hitten fields. No other data is set as of now.
	var selList = lstOrders;
	var length = selList.length;
	var freqItems="";
	var DataFound=false;
	var freqItems="";
	var idData="";
	var listData="";
	var listItem="";
	var listValue="";
	var ORIRowID="";
	for (var i=0; i<length; i++) {

		listItem = selList.options[i].text;
		//var freq = selList.options[i].id;
		listData = selList.options[i].idata;
		listValue = selList.options[i].value;
		idData = selList.options[i].id;
		ORIRowID=selList.options[i].ORIRowId;
		if ((ORIRowID!="")&&(ORIRowID!=null)) {
			AddInput(selList,ORIRowID)
		}
	}
}
function RedrawFavourites(tabidx,FocusWindowName) {
	var formulary="";
	var CONTEXT=document.getElementById("CONTEXT");
	if (CONTEXT) CONTEXT=CONTEXT.value;
	var obj=document.getElementById("NonFormulary");
	if (obj) {
	 	if (obj.checked) formulary="Y";
		else {formulary="N";}
	}
	//log 64160 pass in CONTEXT
	if (tkMakeServerCall("epr.PreferencesQuery","DrawOrderPrefTabItems",tabidx,FocusWindowName,EpisodeID,CTLOC,formulary,CONTEXT)) {}
	var obj=document.getElementById("TAB"+currTab);
	if (obj) obj.className="PrefTab";
	var obj=document.getElementById("TAB"+tabidx);
	if (obj) obj.className="selectedPrefTab";
	currTab=tabidx;
}
function AddToPrefTabClickHandler(evt) {
	if (lstOrders.selectedIndex == -1) return false;
	var lnk = document.getElementById('addtotabs');
	newlnk = lnkFav + "&TABIDX="+currTab + "&CTLOCID="+PatLocID;
	var arr = new Array();
	var type="";
	var id="";
	var oerowid="";
	for (var j=0,i=0; j<lstOrders.length; j++) {
		if (lstOrders.options[j].selected==true) {
			type = lstOrders.options[j].itype.split(String.fromCharCode(4))[0];
			id = lstOrders.options[j].value.split(String.fromCharCode(4))[1];
			if (!id) id = lstOrders.options[j].value;
			arr[i] = type + itemdataDelim + id;
			i++;
		}
	}
	newlnk += "&EXTRAPREFITEMS="+escape(arr.join(groupitemDelim));
	websys_createWindow(newlnk,'TRAK_hidden');
	return false;
}
function EnabledUpdateBtnHandler() {
	var obj=document.getElementById("Update");
	if (obj) obj.disabled=false;
}
function Init() {
	var j;
	var obj;

	//log60222 TedT
	obj=document.getElementById("OEORIItemGroup");
	if (obj) obj.onblur=GroupOnBlur;

	obj=document.getElementById("Add");
	if (obj) obj.onclick=AddClickHandler;

	obj=document.getElementById("AddToFav");
	if (obj) obj.onclick=AddToPrefTabClickHandler;
	if (tsc['AddToFav']) websys_sckeys[tsc['AddToFav']]=AddToPrefTabClickHandler;

	obj=document.getElementById("Delete");
	if (obj) obj.onclick=DeleteClickHandler;

	obj=document.getElementById("OrderDetails")
	if (obj) {
		obj.disabled=false;
		obj.onclick=OrderDetailsClickHandler;
	}

	obj=document.getElementById("Update")
	if (obj) {
		obj.disabled=false;
		obj.onclick=UpdateClickHandler;
	}
	if (tsc['Update']) {
		websys_sckeys[tsc['Update']]=UpdateClickHandler;
	}

	obj=document.getElementById("UpdateGroupNumber");
	if (obj) obj.onclick=UpdateGroupNumberClickHandler;
	
	obj=document.getElementById("CheckPrices");
	if (obj) obj.onclick=PricesClickHandler;
	
	obj=document.getElementById("CheckCosts");
	if (obj) obj.onclick=CostsClickHandler;

	for (var j=1; j<6; j++) {
		obj=document.getElementById("group"+j);
		if (obj) { 
			obj.ondblclick=ListDoubleClickHandler;
			// Log 60083 - Bo - 13-07-2006 : Single-click handler for populating full item description.
			obj.onclick=ListSingleClickHandler;
		}
	}

	// Log 60083 - Bo - 13-07-2006: Don't allow users to touch the data stored in this field. We need this field enabled so the scrollbars are enabled.
	var obj=document.getElementById("ItemDescription");
	if (obj) {
		obj.onfocus=DoNotAllow;
		obj.onkeydown=DoNotAllow;
		// stops copying and pasting
		obj.ondragstart=DoNotAllow;
		obj.onselectstart=DoNotAllow;
		obj.oncontextmenu=DoNotAllow;
		obj.wrap="off";
	}

	//end log 60083

	var SpecColObj=document.getElementById("SpecCollected");
	if (SpecColObj) SpecColObj.onclick=SpecColCheck;
	var ColDateobj=document.getElementById("ColDate");
	var ColTimeobj=document.getElementById("ColTime");

	if (ColDateobj && ColDateobj.value!="") {
		if (SpecColObj)	SpecColObj.checked=true;
	}

	var RecDateObj=document.getElementById("ReceivedDate");
	if (RecDateObj) RecDateObj.onblur=ActivateSpecCol;

	var PINObj=document.getElementById("PIN");
	if((PINObj)&&(PINObj.className!="clsInvalid")) {
		if((ColDateobj)&&(ColDateobj.value==""))
		DisableFields();
	}
	//Log 49262 PeterC 24/01/05
	var obj=document.getElementById("CareProv");
	var LCobj=document.getElementById("LogonCareProvID");
	var DIobj=document.getElementById("DoctorID");

	if((obj)&&(obj.value!="")&&(LCobj)&&(LCobj.value!="")&&(DIobj)&&(DIobj.value=="")) DIobj.value=LCobj.value;
	

	MultiEpisodeID();

	if(IspayorObj) IspayorObj.value="N";
	if(IsplanObj) IsplanObj.value="N";

	var payorObj=document.getElementById("InsurPayor");
	if (payorObj){
		IspayorObj=document.getElementById("IsPayorOnPage");
		if(IspayorObj) IspayorObj.value="Y";
	}

	var planObj=document.getElementById("InsurPlan");
	if (planObj){
		IsplanObj=document.getElementById("IsPlanOnPage");
		if(IsplanObj) IsplanObj.value="Y";
	}

	var decobj=document.getElementById("IsDeceased");
	if((decobj)&&(decobj.value=="Y")) alert(t['PAT_DECEASED']);

	// Log 60108 Bo 24-07-2006: Popup the alert msg when place orders against a cancelled episode.
	var VSobj=document.getElementById("VisitStatus");
	if ((VSobj)&&(VSobj.value=="C")) alert(t['CancelledEpisode']);

	var locflagObj=document.getElementById("UseTmpPatLoc");
	if (locflagObj) locflagObj.onclick=LocFlagClickHanlder;
	
	ShowBrandsClickHandler();		// cjb 19/06/2006 59766 - need to run this method on load to set the hidden field, in case the check box (es) aren't on the form.
	//TedT
	var form=document.getElementById("Form"); 
	if (form) form.onblur=BuildRtFrmStr;
	var str=document.getElementById("Strength"); 
	if (str) str.onblur=BuildRtFrmStr;
	var route=document.getElementById("Route");
	if (route) route.onblur=BuildRtFrmStr;
	
	//log60323 TedT
	var MRDia=document.getElementById("MRDiagnos");
	obj=document.getElementById("LinkDiagnosis"); 
	if(obj) {
		obj.onclick=LinkDiagnosisClickHandler;
		if(MRDia && MRDia.value!="") obj.style.fontWeight="bold";
	}

	// 60317
	var Doc=document.getElementById("AuthDoctor");
	if (Doc) Doc.onblur=DoctorCheck1;
	PhoneOrdersLoadHandler();
}

function PhoneOrdersLoadHandler() {
	var Phone=document.getElementById("PhoneOrder");
	if (!Phone) return false;
	var User2=document.getElementById("User2");
	var PIN2=document.getElementById("PIN2");
	var User2L=document.getElementById("cUser2");
	var PIN2L=document.getElementById("cPIN2");
	var Doc=document.getElementById("AuthDoctor");
	var DocL=document.getElementById("cAuthDoctor");
	if (Phone.value=="Y") {
		if ((!User2) || (!Doc)) {
			alert(t['PHONE_FIELD']);
			Phone.checked=false;
			return false
		} else {
			User2.disabled=false;
			User2.className="clsRequired";
			Doc.className="clsRequired";
			if (PIN2) {
				PIN2.disabled=false;
				PIN2.className="clsRequired";
			}
			if (User2L) User2L.className="clsRequired";
			if (PIN2L) PIN2L.className="clsRequired";
			if (DocL) DocL.className="clsRequired";
			DoctorCheck1();
		}
	} else {
		if (User2) {
			User2.disabled=true;
			User2.className="disabledField";
			if (User2L) User2L.className="";
		}
		if (PIN2) {
			PIN2.disabled=true;
			PIN2.className="disabledField";
			if (PIN2L) PIN2L.className="";
		}
	}

}

function DoctorCheck(str) {
	var lu = str.split("^");
	var obj=document.getElementById("AuthDoctorID");
	if (obj) obj.value=lu[1];

	var Phone=document.getElementById("PhoneOrder");
	if ((!Phone)||(Phone.value!="Y")) return false;

	var Doc=document.getElementById("AuthDoctor");
	if (lu[10]=="") {
		alert(t['AuthDoctor'] + " " + t['XINVALID'] + "\n" + t['CAREPROVUSER']);
		if (Doc) Doc.value="";
		if (obj) obj.value="";
		return false;
	}
	var clingrp=document.getElementById("UseClinGrpForPhone");
	if (clingrp && (clingrp.value==1)) {
		if (document.getElementById("GroupID")) document.getElementById("GroupID").value=lu[10];
	}
	DoctorCheck1();
	return false;
}

function DoctorCheck1() {
	var Phone=document.getElementById("PhoneOrder");
	if ((!Phone)||(Phone.value!="Y")) return false;
	var Doc=document.getElementById("AuthDoctor");
	var DocID=document.getElementById("AuthDoctorID");
	var Add=document.getElementById("Add");
	var Item=document.getElementById("Item");
	var ItemLU=document.getElementById("ld128iItem");
	var group1=document.getElementById("group1");
	var group2=document.getElementById("group2");
	var group3=document.getElementById("group3");
	var group4=document.getElementById("group4");
	var group5=document.getElementById("group5");
	var clingrp=document.getElementById("UseClinGrpForPhone");

	if ((Doc)&&(DocID)) {
		if ((Doc.value=="")||(DocID.value=="")){
			if (Add) Add.disabled=true;
			if (Item) Item.disabled=true;
			if (ItemLU) ItemLU.disabled=true;
			if (group1) group1.disabled=true;
			if (group2) group2.disabled=true;
			if (group3) group3.disabled=true;
			if (group4) group4.disabled=true;
			if (group5) group5.disabled=true;
		} else {
			if (Item) Item.disabled=false;
			if (ItemLU) ItemLU.disabled=false;
			if (clingrp && (clingrp.value!=1)) {
				// only enable favorites groups if ordering by login group - otherwise useless.
				if (group1) group1.disabled=false;
				if (group2) group2.disabled=false;
				if (group3) group3.disabled=false;
				if (group4) group4.disabled=false;
				if (group5) group5.disabled=false;
				if (Add) Add.disabled=false;
			}
		}
	} else {
		if (Add) Add.disabled=true;
		if (Item) Item.disabled=true;
		if (ItemLU) ItemLU.disabled=true;
		if (group1) group1.disabled=true;
		if (group2) group2.disabled=true;
		if (group3) group3.disabled=true;
		if (group4) group4.disabled=true;
		if (group5) group5.disabled=true;
	}

	return false;
}

// Log 60083 - Bo - 13-07-2006 : Log changes start here.
//function to allow time out before running actual code.
var srcGroupList="";

// globals to store the previously-selected items in the group lists. Stored as an array so the group number can be a variable.
var selgroup=new Array();
selgroup[1]=new Array();
selgroup[2]=new Array();
selgroup[3]=new Array();
selgroup[4]=new Array();
selgroup[5]=new Array();

//function to allow time out before running actual code.
function ListSingleClickHandler() {
	srcGroupList=websys_getSrcElement();
	if (srcGroupList) srcGroupList=srcGroupList.id;
	setTimeout("DelayedListSingleClick()",200);
	return false;
}

// Log 60083 - Bo - 13-07-2006 : Single-click handler for populating full item description.
function DelayedListSingleClick() {
	// This logic can't exactly handle "multi-select" - click and drag; or using the SHIFT key - if selection moves UPWARDS.
	//   We simply display the BOTTOM-MOST entry, from the multiple entries that were "changed". (ie. as if the selction was DOWNWARDS).
	//   It DOES cover for use of the CTRL key, as well as all single left-clicks (ie. the basic usage).

	var singledescval="";
	var objSingleItemDesc=document.getElementById("ItemDescription");
	// no need to run any of the functionality below if field not on page.
	if (!objSingleItemDesc) return;
	if (objSingleItemDesc) {
		objSingleItemDesc.value="";
	}
	var objGroupList=document.getElementById(srcGroupList);
	var groupno=srcGroupList.charAt((srcGroupList.length)-1);
	if (objGroupList) {
		// selecteditemadded is a flag (0 or 1) for "has a new entry been added in the hidden array for a newly-selected item?".
		var selecteditemadded=0;
		// Go throught the entries in the actual group list, checking for "what has changed" against the hidden selections, selgroupx.
		for (var i=0;i<objGroupList.length;i++) {
			// match the "real" item against our array. Used in the j loop below.
			var matched=0;
			// numadded is a count for "how many un-selected item entries were added to the hidden array", so we limit the j loop, below.
			var numadded=0;
			for (var j=0;j<((selgroup[groupno].length)-numadded);j++) {
				if (selgroup[groupno][j]==i) matched=1;
				if ((selgroup[groupno][j]==i)&&(objGroupList.options[i].selected==false)) {
					selgroup[groupno][j]="BLANK";
				}
			}
			if ((!matched)&&(objGroupList.options[i].selected==true)) {
				selgroup[groupno][(selgroup[groupno].length)]=i;
				selecteditemadded++;
			}
		}
		// Now, find the "last-used" entry in the array and "display" it. singledescval should be blank still.
		if (singledescval=="") {
			for (var k=selgroup[groupno].length;k>0;k--) {
				var lastselected=selgroup[groupno][k-1];
				if (singledescval=="") {
					if (lastselected=="BLANK") {
						singledescval="";
						break;
					}
					if (lastselected!="BLANK") {
						lastselected=parseInt(lastselected)+1;
						if ((lastselected!="")) {
						lastselected=lastselected-1;
						singledescval=objGroupList.options[lastselected].innerText;
						}
					}
				}
			}
		}


	}
	// display the item in the field.
	if (objSingleItemDesc) {
		objSingleItemDesc.value=singledescval;
	}

	return false;
}

function DoNotAllow() {
	return false;
}

//end log: 60083

//57045
function LocFlagClickHanlder(){
	if (lstOrders.selectedIndex != -1) {
		var locflagObj=document.getElementById("UseTmpPatLoc");
		if (locflagObj && locflagObj.checked) alert(t['CHLOCFLG']);
		else alert(t['UNCHLOCFLG']);
	}
	return;
}


function SetHidDoc(){
	var Docobj=document.getElementById("CareProv");
	var HidDocobj=document.getElementById("HidDoctor");
	HidDocobj.value=Docobj.value;

	return;
}

function MultiEpisodeID() {
	var TObj=document.getElementById("MultiEpisodeID");
	var EObj=document.getElementById("EpisodeID");
	if((TObj)&&(TObj.value!="")&&(EObj)) {
		EObj.value=TObj.value;
		var temp=TObj.value;
		var delimArray = temp.split("^");
		if (delimArray.length>1) {
			window.parent.NoEPRChart();
			window.parent.NoPABanner();

		}
	}
}

function SetPayorPlan() {
	var PlanObj=document.getElementById("InsurPlan");
	if (PlanObj) PlanObj.value="";
}

function ResetPayor(str) {
	if (str) {
		var lu=str.split("^");
		var PayorObj=document.getElementById("InsurPayor");
		if (PayorObj) PayorObj.value=lu[2];
	}
}

function REFDDesc_lookupsel(value) {
	try {
		var obj=document.getElementById("OEORIRefDocDR");
		if (obj) {
  			obj.value=unescape(value);
			obj.className='';
		websys_nextfocus(obj.sourceIndex);
		}
	} catch(e) {};
}

function ActivateSpecCol() {
	var RecDate="";
	var RecTime="";
	var SpecColObj=document.getElementById("SpecCollected");
	var RecDateObj=document.getElementById("ReceivedDate");
	if (RecDateObj) RecDate=RecDateObj.value;

	var RecTimeObj=document.getElementById("ReceivedTime");

	if(RecDate!=""){
		var hidRecTime="";
		var RecTimeobj=document.getElementById("ReceivedTime");
		var hidRecTimeobj=document.getElementById("HidRecTime");
		RecTimeobj.value=hidRecTimeobj.value;

		var SpecColObj=document.getElementById("SpecCollected");
		if (SpecColObj&&SpecColObj.checked==false) {
			if (SpecColObj) SpecColObj.checked=true;
			SpecColCheck();
		}

	}

	else {
		if (RecTimeObj) RecTimeObj.value="";
	}
}

function SpecColCheck() {
	var SpecColObj=document.getElementById("SpecCollected");
	if (SpecColObj&&SpecColObj.checked) {
		EnableFields();
		var hidColDate="";
		var hidColTime="";

		var ColDateobj=document.getElementById("ColDate");
		var ColTimeobj=document.getElementById("ColTime");
		var hidColDateobj=document.getElementById("HidColDate");
		var hidColTimeobj=document.getElementById("HidColTime");
		if ((hidColDateobj) && (ColDateobj)) ColDateobj.value=hidColDateobj.value;
		if ((hidColTimeobj) && (ColTimeobj)) ColTimeobj.value=hidColTimeobj.value;
	} else {
		DisableFields();
	}

}

function EnableFields() {
	var ColDateObj = document.getElementById("ColDate");
	var ColTimeObj = document.getElementById("ColTime");
	var ColDatelbl = document.getElementById("cColDate");
	var ColTimelbl = document.getElementById("cColTime");

	if (ColDateObj&&ColTimeObj) {
		ColDateObj.disabled = false;
		ColTimeObj.disabled = false;
		ColDateObj.className = "";
		ColTimeObj.className = "";
		if (ColTimelbl) ColTimelbl = ColTimelbl.className = ""; //"clsRequired";
		if (ColDatelbl) ColDatelbl = ColDatelbl.className = ""; //"clsRequired";
	}
}

function DisableFields() {
	var ColDateObj = document.getElementById("ColDate");
	var ColDatelbl = document.getElementById("cColDate");
	var ColTimeObj = document.getElementById("ColTime");
	var ColTimelbl = document.getElementById("cColTime");

	if ((ColDateObj)&&(ColDateObj.tagName=="INPUT")&&(ColTimeObj)&&(ColTimeObj.tagName=="INPUT")) {
		ColDateObj.value = "";
		ColTimeObj.value = "";
		ColDateObj.disabled = true;
		ColTimeObj.disabled = true;
		ColDateObj.className = "disabledField";
		ColTimeObj.className = "disabledField";
		if (ColDatelbl) ColDatelbl = ColDatelbl.className = "";
		if (ColTimelbl) ColDatelbl = ColTimelbl.className = "";
	}
}

function mPiece(s1,sep,n) {
	//Getting wanted piece, passing (string,separator,piece number)
	//First piece starts from 0
	//Split the array with the passed delimeter
	delimArray = s1.split(sep);
	//If out of range, return a blank string
	if ((n <= delimArray.length-1) && (n >= 0)) return delimArray[n];
}

function AddClickHandler() {
	var obj=document.getElementById("itemtext");	//from "Enter item with free text" section
	if (obj) {
		var itemtext=obj.value;
		var str=StripAllSpaces(itemtext);
		if (str!="") OSItemListOpen("","","",itemtext);
		obj.value="";
	}
	//Add items to the lstOrders listbox from groups listboxes
	lstOrders.selectedIndex=-1;
	//Adds selected items from all group listboxes when an "Add" button is clicked.
	if (lstGroup1) AddItemsFromFav(document.fOEOrder_Custom,lstGroup1.name,lstOrders.name,1); //defined in oeorder.custom.csp	relating to "group1"
	if (lstGroup2) AddItemsFromFav(document.fOEOrder_Custom,lstGroup2.name,lstOrders.name,1);
	if (lstGroup3) AddItemsFromFav(document.fOEOrder_Custom,lstGroup3.name,lstOrders.name,1);
	if (lstGroup4) AddItemsFromFav(document.fOEOrder_Custom,lstGroup4.name,lstOrders.name,1);
	if (lstGroup5) AddItemsFromFav(document.fOEOrder_Custom,lstGroup5.name,lstOrders.name,1);
	DeSelectAll();
	UpdateOnAddClick();
	return false;
}

function CheckIfOrderGroupNumberExceed(GroupNumber) {
	var selList = lstOrders;
	var length = selList.length;
	var OrderGroupNumber="";
	var OrderGroupNumberCnt=0;
	var newOrderGroupNumber="";
	var objOrderGroupNumber=document.getElementById("OEORIItemGroup");
	if ((GroupNumber)&&(GroupNumber!="")) newOrderGroupNumber=GroupNumber;
	else {
		if ((objOrderGroupNumber)&&(objOrderGroupNumber.value!="")) newOrderGroupNumber=objOrderGroupNumber.value;
	}
	if (newOrderGroupNumber=="") return false;
	
	for (var i=0; i<length; i++) {
		OrderGroupNumber = mPiece(selList.options[i].text,"((",1);
		if (OrderGroupNumber) OrderGroupNumber=mPiece(OrderGroupNumber,"))",0);
		if ((OrderGroupNumber)&&(OrderGroupNumber!="")&&(OrderGroupNumber==newOrderGroupNumber)) OrderGroupNumberCnt++;
	}
	
	//Log 48723 Check for all orders in the same episode
	for (var i=0; i<GroupNumbersUsed.split("^").length-1; i++) {
		OrderGroupNumber=mPiece(GroupNumbersUsed,"^",i);
		if ((OrderGroupNumber)&&(OrderGroupNumber!="")&&(OrderGroupNumber==newOrderGroupNumber)) OrderGroupNumberCnt++;
	}
	
	if (OrderGroupNumberCnt>OrdersNumberInGroupWarning) return true;
	else return false;
}

function CheckFinancialDischarge(){
	return true;
}

function UpdateOnAddClick(startonly,doNotPopupWarning,doNotShowDrgSubs) {
	var valGroup="";
	var PathwayDR="";
	var check=VerifyColRecDateTime();
	if (check==false) return false;
	var FinanDisch=CheckFinancialDischarge();
	if(!FinanDisch) {
		alert(t['FINAN_DISCH']);
		DeleteClickHandler();
		return false;
	}
	var Patient="";
	if (!isInvalid("Doctor")) {
		alert(t['Doctor']+" "+t['XINVALID']);
		DeleteClickHandler();
		return false;
	}

	var sobj=document.getElementById("OEORISttDat");
	if ((sobj)&&(sobj.value!="")&&!StartDateInRange()) { 	//log 30710 AmiN Start Date must be within Episode Admin Date and Discharge date.
		var DateOKobj=document.getElementById("Update");
		if (DateOKobj) DateOKobj.disabled=false;
		return false;
	}
	var OrdersNumberInGroupWarning="";
	var OrdNumInGroupWarnObj=document.getElementById("OrdersNumberInGroupWarning");
	if (OrdNumInGroupWarnObj) OrdersNumberInGroupWarning=OrdNumInGroupWarnObj.value;
	
	//log57014 TedT do not popup warning twice  
	if (OrdersNumberInGroupWarning!="" && !doNotPopupWarning) {
		var checkOrderGroupNumber=CheckIfOrderGroupNumberExceed();
		if (checkOrderGroupNumber==true) {
			var ret=confirm(t['OrderGroupNumberExceedLimit']+'\n'+t['CONTINUE']);
			if (ret==false) { DeleteClickHandler(); return false;}
		}
	}
	
	DeleteAllHiddenItems();

	GetOrderDataOnAdd();
	var patobj=document.getElementById("PatientID");
	if (patobj) Patient=patobj.value;
	var epobj=document.getElementById("EpisodeID");
	if (epobj) EpisodeID=epobj.value;
	var gpobj=document.getElementById("OEORIItemGroup");
	if (gpobj) valGroup=gpobj.value;
	
	var pathwayobj=document.getElementById("PathwayDR");
	if (pathwayobj) PathwayDR=pathwayobj.value;
	var hidItemUrl="";
	
	var ReceiveLabOrderID="";
	var objReceiveLabOrd=document.getElementById("ReceiveOrderID");
	if (objReceiveLabOrd) ReceiveLabOrderID=objReceiveLabOrd.value;
	var SummFlag="";
	var alertOBJ=document.getElementById("SUMMFlag")
	if (alertOBJ) SummFlag=alertOBJ.value;
	var oeObj=document.getElementById("OEOrdItemIDs");
	var InsertedItems="";
	if (oeObj) InsertedItems=oeObj.value;
	var SelectedOrders="";
	for (i=0;i<lstOrders.length;i++) {
		if (!lstOrders.options[i].selected) {
			SelectedOrders=SelectedOrders+lstOrders.options[i].itype.split(itemdataDelim)[0]+"*"+lstOrders.options[i].value+"^";
		}
	} 
	//var f1=top.frames['TRAK_hidden'];
	//if (f1) f1.location="oeorder.updateorders.csp?PatientID="+Patient+"&EpisodeID="+EpisodeID+"&SUMMFlag="+SummFlag+"&OEORIItemGroup="+valGroup+"&kCounter="+hidItemCnt+hidItemUrl;
	var ColDate="";
	var coldateobj=document.getElementById("ColDate");
	if (coldateobj) ColDate=coldateobj.value;
	var ColTime="";
	var coltimeobj=document.getElementById("ColTime");
	if (coltimeobj) ColTime=coltimeobj.value;
	var RecevDate="";
	var recevdateobj=document.getElementById("ReceivedDate");
	if (recevdateobj) RecevDate=recevdateobj.value;
	var RecevTime="";
	var recevtimeobj=document.getElementById("ReceivedTime");
	if (recevtimeobj) RecevTime=recevtimeobj.value;
	var Priority="";
	var priorityobj=document.getElementById("OECPRDesc");
	if (priorityobj) Priority=priorityobj.value;
	var AuthDoctor="";
	var authdoctorobj=document.getElementById("AuthDoctor");
	if (authdoctorobj) AuthDoctor=authdoctorobj.value;
	var AppointmentFlag="";
	var appointmentflagobj=document.getElementById("AppointmentFlag");
	if (appointmentflagobj) AppointmentFlag=appointmentflagobj.value;
	var ApptID="";
	var apptidobj=document.getElementById("ApptID");
	if (apptidobj) ApptID=apptidobj.value;
	var TeethIDs="";
	var TeethIDsobj=document.getElementById("TeethIDs");
	if (TeethIDsobj) TeethIDs=TeethIDsobj.value;
	var CareProv="";
	var CareProvobj=document.getElementById("CareProv");
	if (CareProvobj) CareProv=CareProvobj.value;
	var AuthClinician="";
	var AuthClinicianobj=document.getElementById("AuthClinician");
	if (AuthClinicianobj) AuthClinician=AuthClinicianobj.value;
	var IsPayorOn="";
	var payoron=document.getElementById("IsPayorOnPage");
	if (payoron) IsPayorOn=payoron.value;
	var IsPlanOn="";
	var planon=document.getElementById("IsPlanOnPage");
	if (planon) IsPlanOn=planon.value;
	var PayorObj="";
	PayorObj=document.getElementById("InsurPayor");
	if (PayorObj) var Payor=PayorObj.value;
	var PlanObj="";
	PlanObj=document.getElementById("InsurPlan");
	if (PlanObj) var Plan=PlanObj.value;

	var EligStatus="";
	var EligObj=document.getElementById("EligibilityStatus");
	if (EligObj) EligStatus=EligObj.value;

	var AuthDoctorID="";
	var AuthIDObj=document.getElementById("AuthDoctorID");
	if (AuthIDObj) AuthDoctorID=AuthIDObj.value;

	var OEORISttTim="";
	var stimeObj=document.getElementById("OEORISttTim");
	if (stimeObj) OEORISttTim=stimeObj.value;

	var OEORISttDat="";
	var sdateObj=document.getElementById("OEORISttDat");
	if (sdateObj) OEORISttDat=sdateObj.value;

	var OEORIDepProcNotes="";
	var ProcObj=document.getElementById("OEORIDepProcNotes");
	if (ProcObj) OEORIDepProcNotes=ProcObj.value;
	if (OEORIDepProcNotes!=""){
		// pass in with line breaks removed, replaced with "|", but first replace actual "|" with $c(8)
		while(OEORIDepProcNotes.indexOf("|")!=-1) {
			OEORIDepProcNotes=OEORIDepProcNotes.replace("|",String.fromCharCode(8));
		}
		while(OEORIDepProcNotes.indexOf("+")!=-1) {
			OEORIDepProcNotes=OEORIDepProcNotes.replace("+",String.fromCharCode(2));
		}
		OEORIDepProcNotes=websys_escape(OEORIDepProcNotes);
	}

	//Passing all fields for consistency in function 56633 JPD
	var OEORISpecialtyDR="";
	var OEORISpecialtyDRObj=document.getElementById("OEORISpecialtyDR");
	if (OEORISpecialtyDRObj) OEORISpecialtyDR=OEORISpecialtyDRObj.value;

	var ClinCondDR="";
	var ClinCondDRObj=document.getElementById("ClinCondDR");
	var ClinCondObj=document.getElementById("ClinCond");
	//only pass a clinical condition code to be inserted if the field is displayed and holds a value.
	if (ClinCondDRObj && ((ClinCondObj)&&(ClinCondObj.value!=""))) ClinCondDR=ClinCondDRObj.value;

	var CLNPhone="";
	var CLNPhoneObj=document.getElementById("CLNPhone");
	if (CLNPhoneObj) CLNPhone=CLNPhoneObj.value;

	var OEORIRefDocDR="";
	var OEORIRefDocDRObj=document.getElementById("OEORIRefDocDR");
	if (OEORIRefDocDRObj) OEORIRefDocDR=OEORIRefDocDRObj.value;

	var Doctor="";
	var DoctorObj=document.getElementById("Doctor");
	if (DoctorObj) Doctor=DoctorObj.value;

	//Log 61986 PeterC 14/12/06 Added the below line to fix character set problems
	if((CareProv=="")&&(Doctor!="")) CareProv=Doctor;

	var DoctorID="";
	var DoctorIDObj=document.getElementById("DoctorID");
	if (DoctorIDObj) DoctorID=DoctorIDObj.value;

	// 57045
	var EpisLoc=""
	var EpisLocObj=document.getElementById("EpisLoc");
	if (EpisLocObj) EpisLoc=EpisLocObj.value;	
	var UseTmpPatLoc=""
	var UseTmpPatLocObj=document.getElementById("UseTmpPatLoc");
	if (UseTmpPatLocObj) UseTmpPatLoc=UseTmpPatLocObj.checked;

	currItems=escape(currItems);
	
	var Height=""
	var Height=document.getElementById("MRObsHeight");
	if (Height) Height=Height.value;
	var Weight=""
	var Weight=document.getElementById("MRObsWeight");
	if (Weight) Weight=Weight.value;
	var mradm=document.getElementById("mradm");
	if (mradm) mradm=mradm.value;

	//log60222 TedT
	var grprowid=document.getElementById("GRPRowID");
	if (grprowid) grprowid=grprowid.value;

	// 60317
	if ((document.getElementById("PhoneOrder")) && (document.getElementById("PhoneOrder").value=="Y")) {var PhoneOrder="Y"; } else {var PhoneOrder="N";}

	//BM Log 45069, 46403 Fix the problem that url is too long
 	var newwin=window.open("","TRAK_hidden");
	var doc = newwin.document;
 	doc.open("text/html");
	if (doc.charset!=window.document.charset) doc.charset=window.document.charset;
 	doc.write("<html><head></head><body>\n");
 	doc.writeln('<form name="OrderEntry" id="OrderEntry" method="POST" action="oeorder.updateorders.csp">');
 	doc.writeln('<input name="PatientID" value="'+Patient+'">');
 	doc.writeln('<input name="EpisodeID" value="'+EpisodeID+'">');
 	doc.writeln('<input name="SUMMFlag" value="'+SummFlag+'">');
 	doc.writeln('<input name="OEORIItemGroup" value="'+valGroup+'">');
 	doc.writeln('<input name="currItems" value="'+currItems+'">');
 	doc.writeln('<input name="SelectedOrders" value="'+SelectedOrders+'">');
 	doc.writeln('<input name="PathwayDR" value="'+PathwayDR+'">');
 	doc.writeln('<input name="kCounter" value="'+hidItemCnt+'">');
 	doc.writeln('<input name="EligibilityStatus" value="'+EligStatus+'">');
 	doc.writeln('<input name="AuthDoctorID" value="'+AuthDoctorID+'">');
 	doc.writeln('<input name="DoctorID" value="'+DoctorID+'">'); // 63300
 	doc.writeln('<input name="OEORISttTim" value="'+OEORISttTim+'">');
 	doc.writeln('<input name="OEORISttDat" value="'+OEORISttDat+'">');
 	doc.writeln('<input name="OEORIDepProcNotes" value="'+OEORIDepProcNotes+'">');
	//log60222 Tedt
	doc.writeln('<input name="GRPRowID" value="'+grprowid+'">');

	var HIobj=""; 
	var tempval="";
	var parts="";
	var f="";
 	for (i=1; i<=hidItemCnt; i++) {
  		HIobj=document.getElementById("hiddenitem"+i);
  		if (HIobj) {

   		// Log 43091 removed the '&' char from HIobj
		//log 60048 TedT  //log60454 TedT use websys_escape
   		tempval=websys_escape(HIobj.value);
   		//tempval=escape(tempval.replace("&",""));
		doc.writeln('<input name="hiddenitem'+i+'" value="'+tempval+'">');
		}
 	}
	doc.writeln('<input name="OrderWindow" value="'+window.name+'">');
 	doc.writeln('<input name="InsertedItems" value="'+InsertedItems+'">');
 	doc.writeln('<input name="ReceiveLabOrderID" value="'+ReceiveLabOrderID+'">');
 	doc.writeln('<input name="ColDate" value="'+ColDate+'">');
 	doc.writeln('<input name="ColTime" value="'+ColTime+'">');
	doc.writeln('<input name="ReceivedDate" value="'+RecevDate+'">');
	doc.writeln('<input name="ReceivedTime" value="'+RecevTime+'">');
	doc.writeln('<input name="OECPRDesc" value="'+Priority+'">');
	doc.writeln('<input name="AuthDoctor" value="'+AuthDoctor+'">');
	doc.writeln('<input name="AppointmentFlag" value="'+AppointmentFlag+'">');
	doc.writeln('<input name="ApptID" value="'+ApptID+'">');
	doc.writeln('<input name="TeethIDs" value="'+TeethIDs+'">');
	doc.writeln('<input name="CareProv" value="'+CareProv+'">');
	doc.writeln('<input name="AuthClinician" value="'+AuthClinician+'">');
	doc.writeln('<input name="IsPayorOnPage" value="'+IsPayorOn+'">');
	doc.writeln('<input name="IsPlanOnPage" value="'+IsPlanOn+'">');
	doc.writeln('<input name="InsurPayor" value="'+Payor+'">');
	doc.writeln('<input name="InsurPlan" value="'+Plan+'">');
	doc.writeln('<input name="MRObsHeight" value="'+Height+'">');
	doc.writeln('<input name="MRObsWeight" value="'+Weight+'">');
	doc.writeln('<input name="mradm" value="'+mradm+'">');
	//Passing all fields for consistency in function 56633 JPD
	doc.writeln('<input name="OEORISpecialtyDR" value="'+OEORISpecialtyDR+'">');
	doc.writeln('<input name="ClinCondDR" value="'+ClinCondDR+'">');
	doc.writeln('<input name="CLNPhone" value="'+CLNPhone+'">');
	doc.writeln('<input name="OEORIRefDocDR" value="'+OEORIRefDocDR+'">');
	doc.writeln('<input name="Doctor" value="'+Doctor+'">');
	doc.writeln('<input name="EpisLoc" value="'+EpisLoc+'">');
	doc.writeln('<input name="UseTmpPatLoc" value="'+UseTmpPatLoc+'">');
	// 58993
	doc.writeln('<input name="ConsultID" value="'+ConsultID+'">');
	doc.writeln('<input name="PhoneOrder" value="'+PhoneOrder+'">');  //60317

	if (startonly) {
		doc.writeln('<input name="REFRESHFAV" value=1>');
	}
	if (doNotPopupWarning) {
		doc.writeln('<input name="DoNotCheckInsuranceCover" value=1>');
	}
	if (doNotShowDrgSubs) {
		doc.writeln('<input name="doNotShowDrgSubs" value=1>');
	}
	//etc for each field we want to send
	
 	doc.writeln("<INPUT TYPE=SUBMIT>");
 	doc.writeln("</form>");

 	doc.writeln("</body></html>");
 	doc.close();

	var frm=doc.getElementById('OrderEntry');
	if (frm) frm.submit();
	
	DisableUpdateButton(1);
	DisableOrderDetailsButton(1);
	DisableCheckPricesButton(1);
	DisableAddButton(1);
}

function PopUpQuesSumm(WorkFlowID,ReceivedDateTime,CollectDateTime,NewOrderString,EpisString,DisplayQuestionFlag,OEMessageFlag,AllergyFlag,AllergyItems,PathwayDR,OrderItemsID,NewOrders,ORIRowIDs,InteractFlag,DrugIntString,TherpDupStr,LabFlag,HasAction,AfterAction,BeforeAction,ActionItemString,NewLabEpisodeNumber,NewLabOrders,NewLabSpecs,NewLabColDate,NewLabColTime,NewLabRecDate,NewLabRecTime,SilentMode,OrderSetID,AgeSexFlag,AgeSexString,AgeSexItem,DosageRange,SubCat,Cat,DupMsg,HasDSSMsg,gotOEMsg,ordSetID,PatientID,WARNING,MaxCumDoseFlag,CreateNewTeethFlag,HasDrgSubs,PregnBrFdFlag,PregnBrFdItem) {
	//Log 53047 PeterC 14/06/05: For XP computers requires a timeout here
	if (evtTimer) {
		window.setTimeout("PopUpQuesSumm()",2000);
   	} else {}
	cNewOrders=NewOrders;
	cCat=Cat;
	var NewOrderRowId="";
	var NewOrderSetID="";
	var EpisodeNumber=1;
	var EpisodeCount=0;
	var bSelectedOrders=false;
	var meobj=document.getElementById("MultiEpisodeID");
	if (meobj) EpisodeNumber=meobj.value.split("^").length;
	var LastOrderSetID=mPiece(ordSetID,"^",0);
	var NewOrderCount=NewOrders.split("^").length-1;
	var SelectedOrderBM=0;
	for (var i=0;i<lstOrders.length;i++) {
		if (lstOrders.options[i]&&lstOrders.options[i].selected) lstOrders.options[i].ORIRowId="";
	}
	for (var i=0;i<NewOrderCount;i++){
		while ((!bSelectedOrders)&&(SelectedOrderBM<lstOrders.length)&&(lstOrders.options[SelectedOrderBM])&&(!lstOrders.options[SelectedOrderBM].selected)) SelectedOrderBM++;
		EpisodeCount=0;
		if ((bSelectedOrders&&(SelectedOrderBM<lstOrders.length))||((lstOrders.options[SelectedOrderBM])&&(lstOrders.options[SelectedOrderBM].selected))) {
			bSelectedOrders=true;
			do {
				EpisodeCount++;
				NewOrderSetID=mPiece(ordSetID,"^",i+1);
				NewOrderRowId=mPiece(NewOrders,"^",i);
				lstOrders.options[SelectedOrderBM].itype=lstOrders.options[SelectedOrderBM].itype+NewOrderRowId;
				lstOrders.options[SelectedOrderBM].ORIRowId=lstOrders.options[SelectedOrderBM].ORIRowId+NewOrderRowId;
				if (EpisodeCount!=EpisodeNumber) {
					i++;
					lstOrders.options[SelectedOrderBM].itype=lstOrders.options[SelectedOrderBM].itype+"^";
					lstOrders.options[SelectedOrderBM].ORIRowId=lstOrders.options[SelectedOrderBM].ORIRowId+"^";
				}
			} while (EpisodeCount!=EpisodeNumber)
			if ((NewOrderSetID==LastOrderSetID)&&(LastOrderSetID!="")) {
				lstOrders.options[SelectedOrderBM].itype=lstOrders.options[SelectedOrderBM].itype+"^";
				lstOrders.options[SelectedOrderBM].ORIRowId=lstOrders.options[SelectedOrderBM].ORIRowId+"^";
			}
			else {
				lstOrders.options[SelectedOrderBM].itype=lstOrders.options[SelectedOrderBM].itype+String.fromCharCode(4);
				SelectedOrderBM++;
			}
			
		}
		LastOrderSetID=NewOrderSetID;
	}

	//TedT created popupWarning fn to handle warnings
	var OrdRowIDExternalCodeNotExist="";
	var NonDentalOrder="";
	var DelStockInOtherLoc="";
	var a = popupWarning(WARNING);
	if(a==false) return false;
	OrdRowIDExternalCodeNotExist=a[0];
	NonDentalOrder=a[1];
	DelStockInOtherLoc=a[2];
	
		var objSSGRPDisplayQnsOnSumScreen=document.getElementById("SSGRPDisplayQnsOnSumScreen");
		if (objSSGRPDisplayQnsOnSumScreen && (objSSGRPDisplayQnsOnSumScreen.value=="A")) DisplayQuestionFlag=0;

		OrderDetailsOpenCount=0;
		
		//log60520 TedT if DiagnosOSflag is on, popup the OS item list screen
		if(DiagnosOSFlag==1) {
			DiagnosOSFlag=0;
			var obj=lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount];
			if(obj) {
				var itype=obj.itype;
				var ItemDesc = obj.text;
				var OSRowid=obj.value;
				var OSOrdRowIdString="";
				var itypeLen=itype.split(String.fromCharCode(4)).length;
				if (itypeLen>1) OSOrdRowIdString=mPiece(itype,String.fromCharCode(4),itypeLen-2);
				OSItemListOpen(OSRowid,ItemDesc,"YES","",OSOrdRowIdString);
			}
		} else if ((DisplayQuestionFlag==1)||(AgeSexFlag==1)||(DosageRange!="")||(DupMsg!="")||(AllergyFlag==1)||(HasDSSMsg==1)||(gotOEMsg==1)||(InteractFlag==1)||(PregnBrFdFlag==1)) {
			AllergyItems=escape(AllergyItems);
			EpisString=escape(EpisString);
			NewOrderString=escape(NewOrderString);
			
			// Do not show the alert screen if all order items have not external code, or all orders are not dental order when only allow to order dental order
			if (((OrdRowIDExternalCodeNotExist.split("^").length-2)<NewOrderCount)&&((NonDentalOrder.split("^").length-1)<NewOrderCount)&&DelStockInOtherLoc.split("^").length-1<NewOrderCount) {
				//Removed from URL: "&NewOrders="+NewOrders
				var URL="websys.csp?TWKFL="+WorkFlowID+"&ReceivedDateTime="+ReceivedDateTime+"&CollectDateTime="+CollectDateTime+"&NewOrderString="+NewOrderString+"&EpisString="+EpisString+"&DisplayQuestionFlag="+DisplayQuestionFlag+"&OEMessageFlag="+OEMessageFlag+"&AllergyFlag="+AllergyFlag+"&AllergyItems="+AllergyItems+"&PathwayDR="+PathwayDR+"&OrderItemsID="+OrderItemsID+"&ORIRowIDs="+ORIRowIDs+"&InteractFlag="+InteractFlag+"&MaxCumDoseFlag="+MaxCumDoseFlag+"&DrugIntString="+escape(DrugIntString)+"&TherpDupStr="+escape(TherpDupStr)+"&LabFlag="+LabFlag+"&HasAction="+HasAction+"&AfterAction="+AfterAction+"&BeforeAction="+BeforeAction+"&ActionItemString="+escape(ActionItemString)+"&NewLabEpisodeNumber="+NewLabEpisodeNumber+"&NewLabOrders="+NewLabOrders+"&NewLabSpecs="+NewLabSpecs+"&NewLabColDate="+NewLabColDate+"&NewLabColTime="+NewLabColTime+"&NewLabRecDate="+NewLabRecDate+"&NewLabRecTime="+NewLabRecTime+"&SilentMode="+SilentMode+"&DupMsg="+DupMsg+"&OrderSetID="+OrderSetID+"&AgeSexFlag="+AgeSexFlag+"&AgeSexString="+AgeSexString+"&AgeSexItem="+AgeSexItem+"&DosageRange="+DosageRange+"&HasDSSMsg="+HasDSSMsg+"&OrdRowIDExternalCodeNotExist="+OrdRowIDExternalCodeNotExist+"&StockInOtherLoc="+StockInOtherLoc+"&DelStockInOtherLoc="+DelStockInOtherLoc+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&OrderWindow="+window.name+"&PregnBrFdItem="+PregnBrFdItem+"&PregnBrFdFlag="+PregnBrFdFlag;
				URL=URL+"&ShowOrderDetailFlag=1";
				var features="top=30,left=20,width=820,height=620,scrollbars=yes,toolbar=no,resizable=yes";
				//log 62141 waiting for sessionlist finishing refresh
				window.setTimeout("websys_createWindow('"+URL+"','AlertScreen','"+features+"')",1500);
			}
		}
		else {
			OrderDetailsShowing(document.fOEOrder_Custom);
			// No alert screen, so enable Order Details button at this point.
			// PeterC LOG 42321 16/02/04
			DisableUpdateButton(0);
			DisableOrderDetailsButton(0);
			DisableCheckPricesButton(0);
			//DisableAddButton(0);
			//var updObj=document.getElementById("Update");
			//if (updObj) {updObj.disabled=false; updObj.onclick=UpdateClickHandler;}
			var bShowExec="";
			for (var k=1;k<NewOrders.split("^").length;k++) {
				var newItmMastDR,newOrdIdDR,newSubCat,newExecIdDR;
				newItmMastDR=mPiece(mPiece(NewOrders,"^",k-1),"*",0);
				newOrdIdDR=mPiece(mPiece(NewOrders,"^",k-1),"*",1);
				//Log 62348 PeterC 08/02/07
				var ExecID=""
				ExecID=tkMakeServerCall("web.OEOrdExec","GetFirstExec",newOrdIdDR)
				newExecIdDR=ExecID;
				//newExecIdDR=newOrdIdDR+"||1";
				newSubCat=mPiece(SubCat,"^",k-1);
				//Log 64572 PeterC 09/08/07
				var OrdType=""
				var OrdType=tkMakeServerCall("web.ARCItmMast","GetOrderType",newItmMastDR)
				//if (newSubCat!="") {
				if ((newSubCat!="")&&((OrdType=="X")||(OrdType=="I")||(OrdType=="R"))) {
					if (newSubCat.split("*").length>1) {
						bShowExec=matchExecCategory(newSubCat.split("*")[1],newItmMastDR);
						if (bShowExec) PopUpExecWithoutExecTime(newOrdIdDR);
					} else {
						bShowExec=matchExecCategory(newSubCat,newItmMastDR);
						if (bShowExec) PopUpExec(newItmMastDR,newExecIdDR,newOrdIdDR);
					}
				}
			}
		}
		if (CreateNewTeethFlag=="Y") {
			var TeethIDs="";
			var TeethIDsobj=document.getElementById("TeethIDs");
			if (TeethIDsobj) TeethIDs=TeethIDsobj.value;
			if (NewOrderRowId.split("*").length>1) NewOrderRowId=mPiece(NewOrderRowId,"*",1);
			if (TeethIDs.split("^").length>1) AddNewDentalOrder(NewOrderRowId,TeethIDs);
		}
		//Log 63391 PeterC 26/04/07: Repeating OS causes ItemIDs to be bunched up in the first ID. If Id is blank, copy acorss from previous node.
		for (var i=0;i<lstOrders.length;i++) {
			if ((lstOrders.options[i]&&lstOrders.options[i].selected)&&(lstOrders.options[i].ORIRowId=="")&&(i>0)) lstOrders.options[i].ORIRowId=lstOrders.options[i-1].ORIRowId;
		}
}

function popupWarning(WARNING){
	WARNING=unescape(WARNING);
	var ret=new Array();
	var WarningMsg="";
	var OrdRowIDExternalCodeNotExist="^";
	var NonDentalOrder="";
	var WarnMsg="";
	var WarnDetail="";
	var WarnDesc="";
	var WarnItmMastID="";
	var WarnCount=0;
	var OEORIobj="";
	var NewOrderRowIds="";
	var NewOrderArr="";
	var del="";
	var newNewOrderRowIds="";
	StockInOtherLoc="";
	var DelStockInOtherLoc="";
	var DelOrdRowId="";
	var DefaultRecLoc="";
	
	for (var i=0;i<WARNING.split("^").length-1;i++) {
		WarnMsg=mPiece(WARNING,"^",i);
		if (WarnMsg!="") {
			if (mPiece(WarnMsg,String.fromCharCode(2),0)!=WarnMsg) {
				DefaultRecLoc=mPiece(WarnMsg,String.fromCharCode(2),4);
				WarnDetail=mPiece(WarnMsg,String.fromCharCode(2),1);
				WarnDetail2=mPiece(WarnMsg,String.fromCharCode(2),5);
				WarnDetail3=mPiece(WarnMsg,String.fromCharCode(2),6);
				WarnDetail4=mPiece(WarnMsg,String.fromCharCode(2),7);
				WarnItmMastID=mPiece(WarnMsg,String.fromCharCode(2),2);
				WarnDesc=mPiece(WarnMsg,String.fromCharCode(2),3);
				WarnCount=parseInt(mPiece(WarnMsg,String.fromCharCode(2),8));
				WarnMsg=mPiece(WarnMsg,String.fromCharCode(2),0);
				
				if (WarnMsg=="BADTESTSET") {
					OrdRowIDExternalCodeNotExist=OrdRowIDExternalCodeNotExist+WarnDetail+"^";
					for (var j6=lstOrders.length;j6>0;j6--) {
						//Log 63893 PeterC 12/06/07
						//Log 64734 PeterC 27/08/07
						if (SessionList) {
							for (var ii=1;ii<OrdRowIDExternalCodeNotExist.split("^").length-1;ii++) {
								var CurrOrdRowIDExternalCodeNotExist=mPiece(OrdRowIDExternalCodeNotExist,"^",ii);
								if(CurrOrdRowIDExternalCodeNotExist!="") DeleteOrder(CurrOrdRowIDExternalCodeNotExist);
							}
						}

						if (lstOrders.options[j6-1].ORIRowId.split(WarnDetail).length>1) {
							if (lstOrders.options[j6-1].ORIRowId.split("^").length==1) lstOrders.options[j6-1]=null;	
						}
					}
					OEORIobj=document.getElementById("OEOrdItemIDs");
					if (OEORIobj) {
						NewOrderRowIds=OEORIobj.value;
						
						NewOrderArr=NewOrderRowIds.split("^");
						del=-1;
						for (var b5=0;b5<NewOrderArr.length;b5++) {
							if (mPiece(NewOrderArr[b5],"*",1)==WarnDetail) {
								del=b5;
								break;
							}
						}
						if (del>-1) {
							newNewOrderRowIds="";
							for (var b5=0;b5<NewOrderArr.length;b5++) {
								if (b5!=del) {
									if (newNewOrderRowIds!="") newNewOrderRowIds=newNewOrderRowIds+"^";
									newNewOrderRowIds=newNewOrderRowIds+NewOrderArr[b5];
								}
							}
							OEORIobj.value=newNewOrderRowIds;
						}
					}
					WarnDetail="";
					if (WarningMsg=="") WarningMsg=t[WarnMsg]+": "+WarnDesc;
					else WarningMsg=WarningMsg+", "+WarnDesc;
					alert(WarningMsg);
					LabOrderWithoutExternalCode=LabOrderWithoutExternalCode+WarnItmMastID+"^";
				}
				if (WarnMsg=="ExternalCodeNotExist") {
					OrdRowIDExternalCodeNotExist=OrdRowIDExternalCodeNotExist+WarnDetail+"^";
					for (var j6=lstOrders.length;j6>0;j6--) {
						//Log 63893 PeterC 12/06/07
						//Log 64734 PeterC 27/08/07
						if (SessionList) {
							for (var ii=1;ii<OrdRowIDExternalCodeNotExist.split("^").length-1;ii++) {
								var CurrOrdRowIDExternalCodeNotExist=mPiece(OrdRowIDExternalCodeNotExist,"^",ii);
								if(CurrOrdRowIDExternalCodeNotExist!="") DeleteOrder(CurrOrdRowIDExternalCodeNotExist);
							}
						}

						if (lstOrders.options[j6-1].ORIRowId.split(WarnDetail).length>1) {
							if (lstOrders.options[j6-1].ORIRowId.split("^").length==1) lstOrders.options[j6-1]=null;	
						}
					}
					OEORIobj=document.getElementById("OEOrdItemIDs");
					if (OEORIobj) {
						NewOrderRowIds=OEORIobj.value;
						
						NewOrderArr=NewOrderRowIds.split("^");
						del=-1;
						for (var b5=0;b5<NewOrderArr.length;b5++) {
							if (mPiece(NewOrderArr[b5],"*",1)==WarnDetail) {
								del=b5;
								break;
							}
						}
						if (del>-1) {
							newNewOrderRowIds="";
							for (var b5=0;b5<NewOrderArr.length;b5++) {
								if (b5!=del) {
									if (newNewOrderRowIds!="") newNewOrderRowIds=newNewOrderRowIds+"^";
									newNewOrderRowIds=newNewOrderRowIds+NewOrderArr[b5];
								}
							}
							OEORIobj.value=newNewOrderRowIds;
						}
					}
					WarnDetail="";
					if (WarningMsg=="") WarningMsg=t[WarnMsg]+": "+WarnDesc;
					else WarningMsg=WarningMsg+", "+WarnDesc;
					alert(WarningMsg);
					LabOrderWithoutExternalCode=LabOrderWithoutExternalCode+WarnItmMastID+"^";
				}
				else if (WarnMsg=="INVALID_TOOTH_AREA") {
					for (var j6=lstOrders.length;j6>0;j6--) {
						lstOrders.options[j6-1]=null;	
					}
					OEORIobj=document.getElementById("OEOrdItemIDs");
					if (OEORIobj) OEORIobj.value="";
					alert(t[WarnMsg]);
					return false;
				}
				else if (WarnMsg=="DENTAL_ORDER_ONLY") {
					for (var j6=lstOrders.length;j6>0;j6--) {
						if (lstOrders.options[j6-1].itype.split(WarnItmMastID).length>1) {
							lstOrders.options[j6-1]=null;	
							NonDentalOrder=NonDentalOrder+WarnItmMastID+"^";
							alert(t[WarnMsg]+"\n"+WarnDesc);
						}
					}
				}
				else if (WarnMsg=="STOCK_IN_OTHER_LOC") {
					//WarnDetail is the receiving location id that has stock
					//WarnItmMastID is the order ARCIM ID
					//WarnDesc is the desc of the order item
					//DefaultRecLoc is the desc of the default receiving location
					if (!DefaultRecLoc) DefaultRecLoc=t['DEFRECLOC'];
					var choice1=confirm(t[WarnMsg]+' '+DefaultRecLoc+'. \n'+WarnDesc+'\n\n'+WarnDetail2+" "+t['SELECT_NEW_REC_LOC']);
					if (choice1==false) {
						DelOrdRowId="";
						var xx=0;
						var contains=false;
						var deleteString="";
						var itypeLen="";
						var delStrArr="";
						for (var j6=lstOrders.length;j6>0&&xx<WarnCount;j6--) {
							if (!lstOrders.options[j6-1].selected) continue;
							deleteString=lstOrders.options[j6-1].itype;
							itypeLen=deleteString.split(String.fromCharCode(4)).length;
							if(deleteString!="") deleteString=mPiece(deleteString,String.fromCharCode(4),itypeLen-2);
							delStrArr=deleteString.split("^");	
							for(var y=0; y<delStrArr.length; y++){
								if (mPiece(delStrArr[y],"*",0)==WarnItmMastID) 
									contains=true;							
							}
							if (contains || lstOrders.options[j6-1].ORIRowId.split(WarnItmMastID).length>1) {
								if (contains || lstOrders.options[j6-1].ORIRowId.split("^").length==1) {
									//log59207 tedt only remove items specified in warning
									if(contains || WarnItmMastID==mPiece(lstOrders.options[j6-1].ORIRowId,"*",0)) {
										/*DelOrdRowId=mPiece(lstOrders.options[j6-1].ORIRowId,"*",1);
										DelStockInOtherLoc=DelStockInOtherLoc+DelOrdRowId+"^";
										//Log 56891 PeterC 25/05/06
										DeleteItemIDs("*"+DelOrdRowId+"*^");
										lstOrders.options[j6-1]=null;	*/
										DelStockInOtherLoc=DelStockInOtherLoc+DeleteSelected(j6-1,WarnDetail,WarnItmMastID);
										xx++;
									}
								}
							}
						}
						RefreshSessionList();
					}
					else StockInOtherLoc=StockInOtherLoc+WarnItmMastID+"*"+WarnDetail+"^";
				}
				else if (WarnMsg=="GENERIC_STOCK_IN_OTHER_LOC") {
					//WarnDetail is the receiving location id that has stock
					//WarnItmMastID is the order ARCIM ID
					//WarnDesc is the desc of the order item
					//DefaultRecLoc is the desc of the default receiving location
					if (!DefaultRecLoc) DefaultRecLoc=t['DEFRECLOC'];
					var choice1=confirm(t["STOCK_IN_OTHER_LOC"]+' '+DefaultRecLoc+'. \n'+WarnDesc+'\n\n'+WarnDetail2+" "+t['GEN_STOCK1']+" "+WarnDetail4+" "+t['GEN_STOCK2']);
					if (choice1==false) {
						DelOrdRowId="";
						for (var j6=lstOrders.length;j6>0;j6--) {
							if (lstOrders.options[j6-1].ORIRowId.split(WarnItmMastID).length>1) {
								if (lstOrders.options[j6-1].ORIRowId.split("^").length==1) {
									DelOrdRowId=mPiece(lstOrders.options[j6-1].ORIRowId,"*",1);
									DelStockInOtherLoc=DelStockInOtherLoc+DelOrdRowId+"^";
									//Log 56891 PeterC 25/05/06
									DeleteItemIDs("*"+DelOrdRowId+"*^");
									lstOrders.options[j6-1]=null;	
								}
							}
						}
						OEORIobj=document.getElementById("OEOrdItemIDs");
						if (OEORIobj) {
							NewOrderRowIds=OEORIobj.value;
						
							NewOrderArr=NewOrderRowIds.split("^");
							del=-1;
							for (var b5=0;b5<NewOrderArr.length;b5++) {
								if (mPiece(NewOrderArr[b5],"*",1)==DelOrdRowId) {
									del=b5;
									break;
								}
							}
							if (del>-1) {
								newNewOrderRowIds="";
								for (var b5=0;b5<NewOrderArr.length;b5++) {
									if (b5!=del) {
										if (newNewOrderRowIds!="") newNewOrderRowIds=newNewOrderRowIds+"^";
										newNewOrderRowIds=newNewOrderRowIds+NewOrderArr[b5];
									}
								}
								OEORIobj.value=newNewOrderRowIds;
							}
						}
						RefreshSessionList();
					}
					else {
						StockInOtherLoc=StockInOtherLoc+WarnDetail3+"*"+WarnDetail+"^";
					}
				}
			}
			else {
				WarnDetail=mPiece(WarnMsg,"*",1);
				WarnItmMastID=mPiece(WarnMsg,"*",2);
				WarnMsg=mPiece(WarnMsg,"*",0);
				if ((t[WarnMsg])&&(t[WarnMsg]!="")) {
					alert(t[WarnMsg]+"\n"+WarnDetail);
				}
				if(WarnMsg=="NO_STOCK") {
					//Log 48243 PeterC 18/03/05
					//log59207 tedt only remove items specified in tbe warning from selected order 
					DelStockInOtherLoc=DelStockInOtherLoc+DeleteClickHandler(WarnItmMastID);
					DeleteAllHiddenItems();
					DisableAddButton("0");
					DisableUpdateButton("0");
					DisableOrderDetailsButton("0");
					DisableCheckPricesButton("0");
					//TedT store in DelStockInOtherLoc instead of return false
					//return false;
				}
				if(WarnMsg=="NO_FREQ") {
					//Log 55235 PeterC 31/08/05
					DeleteClickHandler();
					DeleteAllHiddenItems();
					DisableAddButton("0");
					DisableUpdateButton("0");
					DisableOrderDetailsButton("0");
					DisableCheckPricesButton("0");
					return false;
				}				
			}
		}
	}
	if (WarningMsg!="") {
		var Updateobj=document.getElementById("Update");
		if (Updateobj) Updateobj.disabled=false;	
		DisableOrderDetailsButton(0);
		DisableCheckPricesButton(0);
	}
	
	//Log 56891 PeterC 25/05/06
	window.setTimeout("DeleteItemIDs('"+DelStockInOtherLoc+"');",600);
	//DeleteItemIDs(DelStockInOtherLoc);
	ret[0]=OrdRowIDExternalCodeNotExist;
	ret[1]=NonDentalOrder;
	ret[2]=DelStockInOtherLoc;
	return ret;
}

function DeleteOrder(ordid) {
	if (ordid=="" || ordid==null) return false;
	var i=tkMakeServerCall("web.OEOrder","DeleteSessionItemHandler",ordid);
	return true;
}

function DeleteItemIDsAll(NewOrders) {
	var deleteOrder="";
	for (var b1=0;b1<NewOrders.split("^").length-1;b1++) {
		deleteOrder=deleteOrder+mPiece(mPiece(NewOrders,"^",b1),"*",1)+"^";
	}
	cDeletedOrderItemIDs=cDeletedOrderItemIDs+NewOrders;
	if (lstOrders) {
		for (var b1=(lstOrders.length-1); b1>=0; b1--) {
			if (lstOrders.options[b1].selected) {
				lstOrders.options[b1]=null;
			}
		}
	}
	if (NewOrders!="") tkMakeServerCall("web.OEOrder","UpdateItemTempQty",NewOrders);	
	Dparam1=deleteOrder;
	var dobj=document.getElementById('HiddenDeleteOrder');
	if (dobj) dobj.onclick=dobj.onchange;
	if (dobj) {
		dobj.click();
	}
}


function DeleteItemIDs(NewOrders) {
	var deleteOrder="";
	var NewArray=NewOrders.split("^");
	
	for (var b1=0;b1<NewArray.length-1;b1++) {
		if(mPiece(NewArray[b1],"*",1))
			deleteOrder=deleteOrder+mPiece(NewArray[b1],"*",1)+"^";
		else
			deleteOrder=deleteOrder+NewArray[b1];
	}
	cDeletedOrderItemIDs=cDeletedOrderItemIDs+NewOrders;

	//log 61228 11/10/2006 Boc: remove item from lstOrders when deleting item from OEOrder.SessionList
	//log 61971 TedT remove all items exist in NewOrders
	//var delord=mPiece(NewOrders,"*",0)
	if (lstOrders) {
		for (var i=0; i<lstOrders.options.length; i++) {
			for (var j=0; j<NewArray.length; j++) {
				if (lstOrders.options[i] && mPiece(NewArray[j],"*",0)==lstOrders.options[i].value) lstOrders.options[i]=null;
			}
		}
	}
	//log59207 TedT only delete out of stock otpions instead of all selected items
	if (deleteOrder!="") tkMakeServerCall("web.OEOrder","UpdateItemTempQty",deleteOrder);
	Dparam1=deleteOrder;
	var dobj=document.getElementById('HiddenDeleteOrder');
	if (dobj) dobj.onclick=dobj.onchange;
	if (dobj) {
		dobj.click();
	}
}

function DeleteErrorLabOrders(ErrorLabOrderIDs) {
	var NewOrderString="";
	var NewOrderItem="";
	var OrderString="";
	var OEORIobj=document.getElementById("OEOrdItemIDs");
	var NewOrderItemString="";
	if (OEORIobj) {
		NewOrderString=OEORIobj.value;
		for (var i=1;i<ErrorLabOrderIDs.split("^").length;i++) {
			NewOrderItem="*"+mPiece(ErrorLabOrderIDs,"^",i-1)+"*";
			for (var j=1;j<NewOrderString.split("^").length;j++) {
				NewOrderItemString=mPiece(NewOrderString,"^",j-1);
				if (NewOrderItemString.split(NewOrderItem).length==1) {
					if (OrderString.split(NewOrderItemString).length==1) OrderString=OrderString+NewOrderItemString+"^";
				}
			}
			NewOrderString=OrderString;
		}
		OEORIobj.value=NewOrderString;
	}
	var deleteString="";
	var itypeLen="";
	for (var i=1;i<ErrorLabOrderIDs.split("^").length;i++) {
		NewOrderItem="*"+mPiece(ErrorLabOrderIDs,"^",i-1)+"*";
		if (lstOrders) {
			for (var b1=(lstOrders.length-1); b1>=0; b1--) {
				if (lstOrders.options[b1].selected) {
					deleteString=lstOrders.options[b1].itype;
					itypeLen=deleteString.split(String.fromCharCode(4)).length;
					deleteString=mPiece(deleteString,String.fromCharCode(4),itypeLen-2);
					if (deleteString.split(NewOrderItem).length>1) {
						if (deleteString.split("^").length<3) lstOrders.options[b1]=null;
					}
				}
			}
		}
	}
	Dparam1=ErrorLabOrderIDs;
	var dobj=document.getElementById('HiddenDeleteOrder');
	if (dobj) dobj.onclick=dobj.onchange;
	if (dobj) {
		dobj.click();
	} 
}

function DeleteOrderByID(OrdRowId) {
	var OEORIobj=document.getElementById("OEOrdItemIDs");
	if (OEORIobj) {
		var NewOrderRowIds=OEORIobj.value;
		var NewOrderArr=NewOrderRowIds.split("^");
		var del=-1;
		for (var b5=0;b5<NewOrderArr.length;b5++) {
			if (mPiece(NewOrderArr[b5],"*",1)==OrdRowId) {
				del=b5;
				break;
			}
		}
		if (del>-1) {
			var newNewOrderRowIds="";
			for (var b5=0;b5<NewOrderArr.length;b5++) {
				if (b5!=del) {
					if (newNewOrderRowIds!="") newNewOrderRowIds=newNewOrderRowIds+"^";
					newNewOrderRowIds=newNewOrderRowIds+NewOrderArr[b5];
				}
			}
			OEORIobj.value=newNewOrderRowIds;
		}
	}
	for (var b6=0; b6<lstOrders.length; b6++) {
		if ((mPiece(lstOrders.options[b6].ORIRowId,"*",1)==OrdRowId)||(lstOrders.options[b6].ORIRowId==OrdRowId)) {
			lstOrders.options[b6]=null;
			if (OrderDetailsOpenCount>0) OrderDetailsOpenCount--;
		}
	}
	Dparam1=OrdRowId;
	var dobj=document.getElementById('HiddenDeleteOrder');
	if (dobj) dobj.onclick=dobj.onchange;
	if (dobj) {
		dobj.click();
	}
}

function PopUpExec(ordItmMastId,ordExecId,ordId) {
	var valPatient;
	var valEpisode;
	var patobj=document.getElementById("PatientID");
	var episobj=document.getElementById("EpisodeID");
	if (patobj) valPatient=patobj.value;
	if (episobj) valEpisode=episobj.value;
	//Log 64787 PeterC 02/01/08: Do not launch exec. screen if multiple patient
	var EpisStr;
	var isOK="Y";
	EpisStr=valEpisode.split("^");
	if(EpisStr.length > 1) isOK="N";
	//log60736 TedT added new pending flag
	var URL="oeordexec.edit.csp?PatientBanner=1&PatientID="+valPatient+"&PARREF="+ordId+"&ID="+ordExecId+"&refresh=0"+"&OrderWindow="+window.name+"&pending=1"+"&EpisodeID="+valEpisode;
	var OD="";
	var windesc="";
	if(ordId!="") OD=ordId.split("||");
	if((OD)&&(OD[1])) windesc="ORDEXEC"+OD[1];
	var features='scrollbars=yes,toolbar=no,resizable=yes'
	if (isOK=="Y") OrdExeWin=websys_createWindow(URL,windesc,features)
}
function PopUpExecWithoutExecTime(ordId) {
	var valPatient;
	var valEpisode;
	var patobj=document.getElementById("PatientID");
	var episobj=document.getElementById("EpisodeID");
	if (patobj) valPatient=patobj.value;
	if (episobj) valEpisode=episobj.value;
	//Log 64787 PeterC 02/01/08: Do not launch exec. screen if multiple patient
	var EpisStr;
	var isOK="Y";
	EpisStr=valEpisode.split("^");
	if(EpisStr.length > 1) isOK="N";
	//log60736 TedT added new pending flag
	var URL="oeordexec.edit.csp?PatientBanner=1&PatientID="+valPatient+"&PARREF="+ordId+"&ID=&refresh=0"+"&OrderWindow="+window.name+"&pending=1"+"&EpisodeID="+valEpisode;
	var features='scrollbars=yes,toolbar=no,resizable=yes'
	if (isOK=="Y") OrdExeWin=websys_createWindow(URL,'',features)
}

var DupitmOK = new Array();
// this is an array of flags which catch a response to 'duplicate order' alert.
// it must be global so that repeat item alert does not appear with every item added.
// jpd log 49644 - April 2005

function GetOrderDataOnAdd() {
	//debugger;
	var selList = lstOrders;
	var length = selList.length;
	var freqItems="";
	var DataFound=false;
	var freqItems="";
	var idData="";
	var listData="";
	var rowData="";

	var ORIRowId="";
	var listItem="";
	var listValue="";
	var listIType="";
	var arrData="";
	var fields="";
	var hidItemValue="";

	var Freq="";
	var Dur="";
	var Priority="";
	var DosageQty="";
	var Status="";
	var ProcNote="";

	//var Count = new Array(); //array to count occurances of each item in orders list jpd 49644
	
	for (var i=0; i<length; i++) {
		ORIRowId="";
		listItem = mPiece(selList.options[i].text,"((",0);
		//var freq = selList.options[i].id;
		listData = selList.options[i].idata;
		listValue = selList.options[i].value;
		idData = selList.options[i].id;
		//log 63321 TedT 
		rowData = selList.options[i].ORIRowId

		if(idData!="") {
			Freq=mPiece(idData,String.fromCharCode(4),1);
			Dur=mPiece(idData,String.fromCharCode(4),2);
			Priority=mPiece(idData,String.fromCharCode(4),3);
			DosageQty=mPiece(idData,String.fromCharCode(4),4);
			Status=mPiece(idData,String.fromCharCode(4),5);
			ProcNote=mPiece(idData,String.fromCharCode(4),6);
		}
		itmidsForQuest=itmidsForQuest+listValue+"^";
		listIType=selList.options[i].itype;
		if (listIType!="" && listIType!=null) {
			if (mPiece(listIType,String.fromCharCode(4),0)=="ARCOS") {
				listValue = String.fromCharCode(1) + listValue;
			}
			if (listData!="" && listData!=null) {
				//Find if using default values - log 22982
				arrData=listData.split(String.fromCharCode(1));
				//Log 48858 PeterC 31/03/05
				fields=UpdateFields(listData,"",Freq,Dur,Priority,DosageQty,Status,ProcNote);
				hidItemValue=listItem+String.fromCharCode(1)+fields;
				AddInputCust(selList,i,hidItemValue);
				//log 63321 this is due to page being refreshed upon error message (such as invalid pin) and clearing selected orders listbox
				AddInputExtra("DATA"+String.fromCharCode(1)+idData+String.fromCharCode(1)+listValue+String.fromCharCode(1)+listIType+String.fromCharCode(1)+rowData);
				DataFound=true;
			}
			if (DataFound==false) {
				//Log 48858 PeterC 31/03/05
				fields=UpdateFields(String.fromCharCode(1)+String.fromCharCode(1)+listValue,"",Freq,Dur,Priority,DosageQty,Status,ProcNote);
				AddInputCust(selList,i,listItem+String.fromCharCode(1)+fields);
				//log 63321 this is due to page being refreshed upon error message (such as invalid pin) and clearing selected orders listbox
				AddInputExtra("DATA"+String.fromCharCode(1)+idData+String.fromCharCode(1)+listValue+String.fromCharCode(1)+listIType+String.fromCharCode(1)+rowData);
			}
		}
		DataFound=false;
	}
	
	GetFreeText();
	document.fOEOrder_Custom.kCounter.value = hidItemCnt;
}

function AddRowIdToListItem(NewOrderStr,SpecFlag,ExtLabFlag) {
	// Adding RowId to the newly inserted Items - called from oeorder.updateorder.csp
	var list = lstOrders;
	var k=0;
	var NOArr=mPiece(NewOrderStr,"^",k);		//Get first piece of OrderString]
	var multi=document.getElementById("MultiEpisodeID"); 	//MultiEpisodeID
	var ItmMastID="";
	var OldItmMastID="";
	var NewItemCount=0;
	var ROEobj=document.getElementById("RepeatOE"); 

	//Check to see if the correct flags are on
	if ((SpecFlag=="Y")&&(ExtLabFlag=="Y")&&((multi)&&(multi.value==""))) {
		if (NOArr!="") {
			for (var ItemCount=0;;ItemCount++) {
				ItmMastID=mPiece(NOArr,"*",0);
				if (list.options[ItemCount]&&(mPiece(list.options[ItemCount].itype,String.fromCharCode(4),0)=="ARCOS")) break;
				if ((list.options[ItemCount])&&(list.options[ItemCount].selected)&&(list.options[ItemCount].ORIRowId=="")&&(list.options[ItemCount].value==ItmMastID)) {
					list.options[ItemCount].ORIRowId=NOArr+"^";
					OldItmMastID=ItmMastID;
					k++; NOArr=mPiece(NewOrderStr,"^",k);
					if (NOArr=="") break;
					if (mPiece(list.options[ItemCount].itype,String.fromCharCode(4),0)=="ARCOS") break;
				} else if ((list.options[ItemCount])&&(list.options[ItemCount].selected)&&(list.options[ItemCount].ORIRowId=="")&&(list.options[ItemCount].value!=ItmMastID)) {
					NewItemCount=list.options.length;
					list.options[NewItemCount] = new Option(list.options[ItemCount-1].text,list.options[ItemCount-1].value);
					if (list.options[NewItemCount]) {
						list.options[NewItemCount].id=list.options[ItemCount-1].id;
						list.options[NewItemCount].itype=list.options[ItemCount-1].itype;
						list.options[NewItemCount].selected=false;
						list.options[NewItemCount].idata=list.options[ItemCount-1].idata;
						list.options[NewItemCount].ORIRowId=NOArr+"^";
					}
					k++; NOArr=mPiece(NewOrderStr,"^",k);
					if (NOArr=="") break;
					ItemCount--;
				} else if (!(list.options[ItemCount])) {
					//Add extra item to list for multiple specimens
					list.options[list.options.length] = new Option(list.options[ItemCount-1].text,list.options[ItemCount-1].value);
					if (list.options[ItemCount]) {
						list.options[ItemCount].id=list.options[ItemCount-1].id;
						list.options[ItemCount].itype=list.options[ItemCount-1].itype;
						list.options[ItemCount].selected=false;
						list.options[ItemCount].idata=list.options[ItemCount-1].idata;
						list.options[ItemCount].ORIRowId=NOArr+"^";
					}
					k++; NOArr=mPiece(NewOrderStr,"^",k);
					if (NOArr=="") break;
				}
			}
		}
	} else {
		for (var ItemCount=0;ItemCount<list.length;ItemCount++) {
			if ((list.options[ItemCount])&&(list.options[ItemCount].ORIRowId=="")) {
				list.options[ItemCount].ORIRowId=NewOrderStr
			}
		}
	}
}

function DisableOrderDetailsButton(Disable){
	// disable Order Details button till the alert screen update or closes.
	// PeterC LOG 42321 16/02/04
	var odObj=document.getElementById("OrderDetails");
	if ((odObj)&&(Disable=="1")) {
		odObj.disabled=true;
		odObj.onclick="";
	}
	if ((odObj)&&(Disable=="0")) {
		odObj.disabled=false;
		odObj.onclick=OrderDetailsClickHandler;
	}
}
function DisableCheckPricesButton(Disable){
	// disable Check Prices button till the alert screen update or closes.
	// DL

	var checkpriObj=document.getElementById("CheckPrices");
	if ((checkpriObj)&&(Disable=="1")) {
		checkpriObj.disabled=true;
		checkpriObj.onclick="";
	}
	if ((checkpriObj)&&(Disable=="0")) {
		checkpriObj.disabled=false;
		checkpriObj.onclick=PricesClickHandler;
	}
}

function DisableAddButton(Disable,tempOrderID){
	// disable add button till csp finishes inserting items to database.
	// ANA LOG XXX
	var addObj=document.getElementById("Add");
	if ((addObj)&&(Disable=="1")) addObj.disabled=true;
	if ((addObj)&&(Disable=="0")) addObj.disabled=false;

	//LOG 35421 RC 03/07/03 Need a string of all the OrderIDs so we can do a check on update.
	if (Disable=="0") {
		var OEORIobj=document.getElementById("OEOrdItemIDs")
		if ((OEORIobj)&&(tempOrderID)) {
			if (OEORIobj.value!="") {
				OEORIobj.value=OEORIobj.value+tempOrderID;
			}
			if (OEORIobj.value=="") {
				OEORIobj.value=tempOrderID;
			}
		}
	}

}
function DisableUpdateButton(Disable){
	// disable Update button till csp finishes inserting items to database.
	var updObj=document.getElementById("Update");
	if ((updObj)&&(Disable=="1")) {
		updObj.disabled=true;
	}
	if ((updObj)&&(Disable=="0")) {
		updObj.disabled=false;
		updObj.onclick=UpdateClickHandler;
	}
}
//Log 66227 PeterC 31/01/08
function OEORIDepProcNotes_keydownhandler(encmeth) {
	var obj=document.getElementById("OEORIDepProcNotes");
	//LocateCode(obj,encmeth);
	LocateCode(obj,encmeth,false,"Kweb.MRCWordResultCode:LookUpByCode","MRCWordResultCode_lookupSelect");
}

function ListDoubleClickHandler() {
	var eSrc=websys_getSrcElement();
	//Add items to the lstOrders listbox from groups listbox
	lstOrders.selectedIndex=-1;
	//Adds selected item from the group listboxes when an "Add" button is clicked.
	if (eSrc.id=="group1") AddItemsFromFav(document.fOEOrder_Custom,lstGroup1.name,lstOrders.name,1);
	if (eSrc.id=="group2") AddItemsFromFav(document.fOEOrder_Custom,lstGroup2.name,lstOrders.name,1);
	if (eSrc.id=="group3") AddItemsFromFav(document.fOEOrder_Custom,lstGroup3.name,lstOrders.name,1);
	if (eSrc.id=="group4") AddItemsFromFav(document.fOEOrder_Custom,lstGroup4.name,lstOrders.name,1);
	if (eSrc.id=="group5") AddItemsFromFav(document.fOEOrder_Custom,lstGroup5.name,lstOrders.name,1);

	DeSelectAll();
	UpdateOnAddClick();
	return false;
}

function DeSelectAll() {
	//Deselects all listboxes
	if (lstGroup1) lstGroup1.selectedIndex=-1;
	if (lstGroup2) lstGroup2.selectedIndex=-1;
	if (lstGroup3) lstGroup3.selectedIndex=-1;
	if (lstGroup4) lstGroup4.selectedIndex=-1;
	if (lstGroup5) lstGroup5.selectedIndex=-1;
	// Log 60083 - Bo - 13-07-2006 : Clear the "Item Description" text area as well.
	var obj=document.getElementById("ItemDescription");
	if (obj) obj.value="";
	// end Log 60083
}

function AddToFavClickHandler() {
	//Add selected items from lstOrders to lstGroup1,
	//at the same time, add Favourite categories
	AddItems(document.fOEOrder_Custom,lstOrders.name,lstGroup1.name);
	AddToFavUpdate(document.fOEOrder_Custom,0);
	return false;
}
function AddItems(f,selfrom,selto,docheck) {
	var selary=getSelected(f.elements[selfrom],0,docheck);
	addSelected(f.elements[selto],selary,0);
}
function AddToFavUpdate(f,cls) {
	var vArray = new Array();
	var lst = f.elements["Orders"];
	var i=0;

	if (lst.selectedIndex == -1) {
		return;
	}
	for (var j=0; j<lst.length; j++) {
		if (lst.options[j].selected==true) {
			vArray[i] = lst.options[j].itype + String.fromCharCode(28) + lst.options[j].value;
			i++;
		}
	}
	var path = "oeorder.orgfavupdate.csp?LstGroup1="+escape(vArray.join(String.fromCharCode(1)))+"&OrderWindow="+window.name;
	websys_createWindow(path,"TRAK_hidden","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
}

function DeleteClickHandler(itemMastID) {

	var itemMastIDarr="";
	var deleteOrderRowID="";
	var itemid=""
	var itmcnt="";
	
	if(itemMastID!=null) itemMastIDarr=itemMastID.split(String.fromCharCode(4));
	
	//Delete items from lstOrders listbox when a "Delete" button is clicked.
	for (var i=(lstOrders.length-1); i>=0; i--) {
		if (lstOrders.options[i].selected) {
			if(itemMastIDarr!="") {
				for(var j=0; j<itemMastIDarr.length; j++) {
					itmcnt=parseInt(mPiece(itemMastIDarr[j],String.fromCharCode(1),1));
					itemid=mPiece(itemMastIDarr[j],String.fromCharCode(1),0);
					//65489
					var serverupdate=tkMakeServerCall("web.OEOrder","CheckDeletes",itemid);
					if (serverupdate==0) {
						alert(t['NODELETE']);
						break;
					}
					if(lstOrders.options[i].itype.indexOf(itemid)>0 && itmcnt>0){
						deleteOrderRowID=deleteOrderRowID+DeleteSelected(i,"",itemid);
						//deleteOrderRowID=deleteOrderRowID+DeleteSelected(i);
						itemMastIDarr[j]=itemid+String.fromCharCode(1)+(itmcnt-1);
						break;
					}
				}
			}
			else
				deleteOrderRowID=deleteOrderRowID+DeleteSelected(i);
		}
	}
	
	window.setTimeout("DeleteItemIDs('"+deleteOrderRowID+"');",600);
	return deleteOrderRowID;
}

//TedT delete the selected item, update qty count for item
function DeleteSelected(i,recloc,itemid){

	var deleteString="";
	var itypeLen="";
	var OEORIobj="";
	var NewOrderArr="";
	var del=false;
	var newNewOrderRowIds="";
	var delStrArr="";
	var DelStockInOtherLoc="";
	var newItype="";
	var newItypeArr="";
	
	if (recloc==null) recloc="";
	if(lstOrders.options[i].itype) deleteString=lstOrders.options[i].itype;
	itypeLen=deleteString.split(String.fromCharCode(4)).length;
	if(deleteString!="") deleteString=mPiece(deleteString,String.fromCharCode(4),itypeLen-2);
	delStrArr=deleteString.split("^");

	//65489
	var serverupdate=tkMakeServerCall("web.OEOrder","CheckDeletes",mPiece(deleteString,"*",1));
	if (serverupdate==0) {
		alert(t['NODELETE']);
		return false;
	}

	OEORIobj=document.getElementById("OEOrdItemIDs");
	if (OEORIobj)
		NewOrderArr=(OEORIobj.value).split("^");

	for(var b=0; b<delStrArr.length;b++){
		if (itemid!=null && (mPiece(delStrArr[b],"*",0)!=itemid || del)) {
			newItype=newItype+delStrArr[b]+"^";
			continue;
		}
		if (delStrArr[b]!="") DelStockInOtherLoc=DelStockInOtherLoc+mPiece(delStrArr[b],"*",1)+"^";
		for (var b5=0;b5<NewOrderArr.length;b5++) {
			//log59642 TedT
			if (NewOrderArr[b5]!=null&&mPiece(NewOrderArr[b5],"*",1)==mPiece(delStrArr[b],"*",1)) {
				NewOrderArr[b5]=null;
				del=true;
				break;
			}
		}
	}
	if (del) {
		newNewOrderRowIds="";
		for (var b5=0;b5<NewOrderArr.length;b5++) {
			if (NewOrderArr[b5]!=null&&NewOrderArr[b5]!="")
				newNewOrderRowIds=newNewOrderRowIds+NewOrderArr[b5]+"^";
		}
		OEORIobj.value=newNewOrderRowIds;
	}
	
	if(newItype=="")
		lstOrders.options[i]=null;
	else{
		//TedT, update the itype value without the deleted item
		lstOrders.options[i].ORIRowId=newItype;
		newItypeArr=(lstOrders.options[i].itype).split(String.fromCharCode(4));
		newItypeArr[itypeLen-2]=newItype;
		newItype=newItypeArr.join(String.fromCharCode(4));
		lstOrders.options[i].itype=newItype;
	}
		
	return DelStockInOtherLoc;
}

function DeleteOrderSetClickHandler(setid) {
	//RemoveOrderSetFromList(document.fOEOrder_Custom,lstOrders,setid)
	var OrderSetGroupNumber="";
	for (var i=(lstOrders.length-1); i>=0; i--) {
		if (lstOrders.options[i].selected){
			var selItmid=lstOrders.options[i].value;
			if(setid==selItmid) {
				OrderSetGroupNumber=mPiece(lstOrders.options[i].text,"((",1);
				if (OrderSetGroupNumber) OrderSetGroupNumber=mPiece(OrderSetGroupNumber,"))",0);
				else OrderSetGroupNumber="";
				lstOrders.options[i]=null;
			}
		}
	}
	return OrderSetGroupNumber;
}

//Log 49182 PeterC 02/05/05
function ShowDrgSubs(ItemList,NonSubItems)
{
	var PatientID="";
	var EpisodeID="";
	var windesc="";
	var PObj=document.getElementById("PatientID");
	if (PObj) PatientID=PObj.value;
	var EObj=document.getElementById("EpisodeID");
	if (EObj) EpisodeID=EObj.value;

	var ItemArray=ItemList.split(String.fromCharCode(4));
	for(i=0;i<ItemArray.length;i++)
	{
		var CurrItemList=ItemArray[i];
		if(CurrItemList=="") break;
		var URL="oeorder.showdrgsubs.csp?ItemList="+CurrItemList+"&NonSubItems="+NonSubItems+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PatientBanner=1"+"&SubsItemCount="+(ItemArray.length-1);
		var features="top=30,left=20,width=410,height=310,scrollbars=yes,toolbar=no,resizable=yes";
		windesc="ShowDrgSubs"+i;
		websys_createWindow(URL,windesc,features);
	}
	return false;
}

function DeleteOrderClickHandler(ARCIM) {
	for (var i=(lstOrders.length-1); i>=0; i--) {
		if (lstOrders.options[i].selected){
			var selItmid=lstOrders.options[i].value;
			if(ARCIM==selItmid) {
				lstOrders.options[i]=null;
			}
		}
	}
}

function AddItemToList(list,code,desc,subcatcode,ordertype,alias,data,setid,ordcatID,dur,setref,OSItemIDs,ordersubcatID,CopyOrdRowId,DoNotClearSelection,HasAutoPopUp) {	  //Add an item to a listbox
	if (list=="") list=lstOrders;
	var OrderGroupNumber="";
	var objOrderGroupNumber=document.getElementById("OEORIItemGroup");
	if ((objOrderGroupNumber)&&(objOrderGroupNumber.value!="")) OrderGroupNumber=objOrderGroupNumber.value;
	var obj=document.getElementById("DefaultData");
	if ((obj)&&(data=="")) data=obj.value;
	if ((DoNotClearSelection!=1) && (list.length>0)) list.selectedIndex = -1;
	//Log 46424 add the order group number in listbox text
	if (OrderGroupNumber!="") list.options[list.length] = new Option(desc+"(("+OrderGroupNumber+"))",code);
	else list.options[list.length] = new Option(desc,code);
	list.options[list.length-1].id=subcatcode+String.fromCharCode(4)+dur+String.fromCharCode(4)+setref+String.fromCharCode(4);
	list.options[list.length-1].itype=ordertype+String.fromCharCode(4)+alias+String.fromCharCode(4)+code+String.fromCharCode(4)+ordcatID+String.fromCharCode(4)+OSItemIDs+String.fromCharCode(4)+ordersubcatID+String.fromCharCode(4)+HasAutoPopUp+String.fromCharCode(4);
	list.options[list.length-1].selected=true;
	list.options[list.length-1].idata=data;
	var CurrEpisId="";
	var EpisObj="";
	if (CopyOrdRowId) {
		var itemdata="";
		for (b9=1;b9<103;b9++) {
			if (b9==2) {
				CurrEpisId="";
				EpisObj=document.getElementById("EpisodeID");
				if (EpisObj) CurrEpisId=EpisObj.value;
				itemdata=itemdata+CurrEpisId+String.fromCharCode(1);
			}
			else if (b9==3) itemdata=itemdata+code+String.fromCharCode(1);
			else if (b9==4) itemdata=itemdata+code+String.fromCharCode(1);
			else itemdata=itemdata+String.fromCharCode(1);
		}
		itemdata=itemdata+CopyOrdRowId+String.fromCharCode(1);
		list.options[list.length-1].idata=itemdata;
	}
	else {
		list.options[list.length-1].idata=data;
		var objLinkedOrder=document.getElementById("LinkedOrder");
		if ((objLinkedOrder)&&(objLinkedOrder.checked==true)&&(list.length>1)) {
			if ((ordertype=="ARCIM")&&(subcatcode=="R")) {
				var orderValue="";
				var orderType1="";
				var bCanCopy=false;
				for (var loop7=0;loop7<list.length-1;loop7++) {
					if (list.options[loop7]) {
						 orderValue=list.options[loop7].text;
						 orderType1=mPiece(list.options[loop7].id,String.fromCharCode(4),0);
						 if (orderValue.substring(0,1)!=" ") {
						 	if (orderType1=="R") bCanCopy=true;
						 	else bCanCopy=false;
						 }
					}
				}
				if (bCanCopy) list.options[list.length-1].text="     "+list.options[list.length-1].text;
			}
		}
	}
	list.options[list.length-1].ORIRowId="";
}

function AddIndividualItemInOrderSetToList(list,code,desc,subcatcode,ordertype,alias,data,setid,ordcatID,dur,setref,OSItemIDs,ordersubcatID,OrdRowId) {	  //Add an item to a listbox
	if (list=="") list=lstOrders;
	var obj=document.getElementById("DefaultData");
	if ((obj)&&(data=="")) data=obj.value;
	list.options[list.length] = new Option(desc,code);
	list.options[list.length-1].id=subcatcode+String.fromCharCode(4)+dur+String.fromCharCode(4)+setref+String.fromCharCode(4);
	list.options[list.length-1].itype=ordertype+String.fromCharCode(4)+alias+String.fromCharCode(4)+setid+String.fromCharCode(4)+ordcatID+String.fromCharCode(4)+OSItemIDs+String.fromCharCode(4)+ordersubcatID+String.fromCharCode(4)+OrdRowId+String.fromCharCode(4);
	//Log 43828 10/05/04 PeterC: Set the below line to "false"
	list.options[list.length-1].selected=false;
	list.options[list.length-1].idata=data+String.fromCharCode(1);
	list.options[list.length-1].ORIRowId=mPiece(OrdRowId,"*",1);
}

function AddItemsFromFav(f,selfrom,selto,docheck) {
	var selary=getSelected(f.elements[selfrom],0,docheck);
	addSelectedFav(f.elements[selto],selary,0);
}

function addSelectedFav(obj,selary,s) {
	var k=obj.length;
	var match="notfound";
	var desc="";
	var selItmid="";
	var selItmDesc="";
	var selItmDur="";
	var subcatcode="";
	var obj1="";
	var objLinkedOrder="";
	var orderValue="";
	var orderType="";
	var bCanCopy="";
	var CatID="";
	var SubCatID="";
	var OrderType="";
	var setid="";
	var OrderGroupNumber="";
	var objOrderGroupNumber=document.getElementById("OEORIItemGroup");
	if ((objOrderGroupNumber)&&(objOrderGroupNumber.value!="")) OrderGroupNumber=objOrderGroupNumber.value;
	//Log 48858 PeterC 31/03/05
	var Freq="";
	var Dur="";
	var Priority="";
	var DosageQty="";
	var Status="";
	var ProcNote="";

	for (var i=0;i<selary.length;i++) {
		//Log 46424 add the order group number in listbox text
		if (OrderGroupNumber!="") obj.options[k]=new Option(selary[i]["txt"]+"(("+OrderGroupNumber+"))",selary[i]["val"].split(String.fromCharCode(4))[2]);
		else obj.options[k]=new Option(selary[i]["txt"],selary[i]["val"].split(String.fromCharCode(4))[2]);
		//obj.options[k]=new Option(selary[i]["txt"],selary[i]["val"]);
		desc=obj.options[k].text;
		//obj.options[k].itype=obj.options[k].value;
		obj.options[k].itype=selary[i]["val"];
		//log 63321 TedT if value is null, dont set variable
		var arySelary=selary[i]["val"].split(String.fromCharCode(4));
		if(arySelary[10]) Freq=arySelary[10];
		if(arySelary[11]) Dur=arySelary[11];
		if(arySelary[12]) Priority=arySelary[12];
		if(arySelary[13]) DosageQty=arySelary[13];
		if(arySelary[14]) Status=arySelary[14];
		if(arySelary[15]) ProcNote=arySelary[15];
		/*Freq=selary[i]["val"].split(String.fromCharCode(4))[10];
		Dur=selary[i]["val"].split(String.fromCharCode(4))[11];
		Priority=selary[i]["val"].split(String.fromCharCode(4))[12];
		DosageQty=selary[i]["val"].split(String.fromCharCode(4))[13];
		Status=selary[i]["val"].split(String.fromCharCode(4))[14];
		ProcNote=selary[i]["val"].split(String.fromCharCode(4))[15];*/
		if(ProcNote!="") ProcNote=unescape(ProcNote);

		if (obj.options[k].value!="" && obj.options[k].value.split(String.fromCharCode(28)).length>8) {
			selItmid=mPiece(obj.options[k].value,String.fromCharCode(28),1);
			selItmDesc=desc;
			selItmDur=mPiece(obj.options[k].value,String.fromCharCode(28),6);
			subcatcode=mPiece(obj.options[k].value,String.fromCharCode(28),7);
			obj.options[k].id=subcatcode+String.fromCharCode(4)+selItmDur+String.fromCharCode(4);
		}
		else {
			subcatcode=mPiece(obj.options[k].itype,String.fromCharCode(4),8);
			obj.options[k].id=mPiece(obj.options[k].itype,String.fromCharCode(4),8)+String.fromCharCode(4)+mPiece(obj.options[k].itype,String.fromCharCode(4),7)+String.fromCharCode(4);
		}
		obj1=document.getElementById("DefaultData");
		if (obj) obj.options[k].idata=obj1.value;
		if (obj) obj.options[k].ORIRowId="";

		objLinkedOrder=document.getElementById("LinkedOrder");
		if ((objLinkedOrder)&&(objLinkedOrder.checked==true)&&(k>0)&&(mPiece(obj.options[k].itype,String.fromCharCode(4),0)=="ARCIM")) {
			if (mPiece(obj.options[k].id,String.fromCharCode(4),0)=="R") {
				orderValue="";
				orderType="";
				bCanCopy=false;
				for (var loop7=0;loop7<k;loop7++) {
					orderValue=obj.options[loop7].text;
					orderType=mPiece(obj.options[loop7].id,String.fromCharCode(4),0);
					if (orderValue.substring(0,1)!=" ") {
						if (orderType=="R") bCanCopy=true;
						else bCanCopy=false;
					}
				}
				if (bCanCopy) obj.options[k].text="     "+obj.options[k].text;
			}
		}

		CatID=mPiece(obj.options[k].itype,String.fromCharCode(4),3);
		SubCatID=mPiece(obj.options[k].itype,String.fromCharCode(4),5);
		OrderType=mPiece(obj.options[k].itype,String.fromCharCode(4),0);
		setid=mPiece(obj.options[k].value,String.fromCharCode(28),1);

		if ((setid)&&(setid!="")) obj.options[k].value=setid;
		obj.options[k].selected=true;
		if (OrderType=="ARCIM") {
			obj.options[k].id=subcatcode+String.fromCharCode(4);
		}
		//Log 48858 PeterC 31/03/05
		obj.options[k].id=obj.options[k].id+Freq+String.fromCharCode(4)+Dur+String.fromCharCode(4)+Priority+String.fromCharCode(4)+DosageQty+String.fromCharCode(4)+Status+String.fromCharCode(4)+ProcNote+String.fromCharCode(4)
		//AmiN  log25880 adding message for items not covered by insurance
		k++;
	}
}

function OrderDetailsClickHandler() {		//displays new page where the user can edit some of the fields.
	OrderDetailsOpenCount=0;
	//Log 63171 04/04/07 PeterC
	OrdDetMultiClick="Y";
	OrderDetailsPage(document.fOEOrder_Custom);
	return false;
}

function DeleteAllHiddenItems() {
	var id="";
	var objhid="";
	
	for (i=1; i<=hidItemCnt; i++) {
		id="hiddenitem"+i;
		objhid=document.getElementById(id);
		if (objhid) objhid.outerText='';
	}
	hidItemCnt=0;
}

function InvalidFields() {
	var invalid=false;
	if(!isInvalid("OEORIRefDocDR")&&(!invalid)) {
		alert(t['OEORIRefDocDR']+":  "+t['XINVALID']);
		invalid=true;
	}


	if(!isInvalid("Doctor")&&(!invalid)) {
		alert(t['Doctor']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("EpisLoc")&&(!invalid)) {
		alert(t['EpisLoc']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("InsurPayor")&&(!invalid)) {
		alert(t['InsurPayor']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("InsurPlan")&&(!invalid)) {
		alert(t['InsurPlan']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("OECPRDesc")&&(!invalid)) {
		alert(t['OECPRDesc']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("ReasonAlert")&&(!invalid)) {
		alert(t['ReasonAlert']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("TempLoc")&&(!invalid)) {
		alert(t['TempLoc']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("OEORISpecialtyDR")&&(!invalid)) {
		alert(t['OEORISpecialtyDR']+":  "+t['XINVALID']);
		invalid=true;
	}
	if(!isInvalid("AuthDoctor")&&(!invalid)) {
		alert(t['AuthDoctor']+":  "+t['XINVALID']);
		invalid=true;
	}
	if(!isInvalid("AuthClinician")&&(!invalid)) {
		alert(t['AuthClinician']+":  "+t['XINVALID']);
		invalid=true;
	}



	return invalid;
}

function UpdateClickHandler() {
   //SB 7/6/05 (52418): Use timer to allow brokers to validate before update is triggered.
   if (evtTimer) {
	window.setTimeout("UpdateClickHandler()",websys_brokerTime+20);
   } else {
	// 60317
	var Phone=document.getElementById("PhoneOrder");
	var User2=document.getElementById("User2");
	var PIN2=document.getElementById("PIN2");
	if (Phone && (Phone.value=="Y")) {
		if ((User2 && (User2.value=="")) || (PIN2 && (PIN2.value==""))) {
			alert(t['User2Req']);
			return false;
		}
	}
	var itmtxtobj=document.getElementById("itemtext");
	var hiditmtxtobj=document.getElementById("hiditemtext");
	if ((itmtxtobj)&&(hiditmtxtobj)) hiditmtxtobj.value=escape(itmtxtobj.value);

	var NewOrderItem="";
	var NewOrderString="";
	var siobj=document.getElementById("Orders");
	var auobj=document.getElementById("AllowUpdateWithNoOrders");
	if (siobj) {
		if ((siobj.options.length==0)&&(auobj)&&(auobj.value!="Y")) {
			if ((itmtxtobj)&&(itmtxtobj.value=="")) {
				alert(t['NoSelectedOrder']);
				return false;
			}
		}
		if (siobj.length>0) {
			var j=0;
			for (var i=0;i<=(siobj.length-1);i++) {
				if (siobj.options[i].selected==true) j++
			}
			if (j==0) siobj.options[0].selected=true;
		}
	}

	if (InvalidFields()==true) {
		return false;
	}

	//Log 48511
	if (!StartDateInRange(true)) return false;
	
	var OEORIobj=document.getElementById("OEOrdItemIDs")
	if (OEORIobj) {
		//log59778 TedT, remove order id from OEOrdItemIDs if already deleted from list
		var del=(cDeletedOrderItemIDs.split("^").length>0);
		if(!del) NewOrderString=OEORIobj.value;
		var OEORIarr=(OEORIobj.value).split("^");
		for(var i=0; i<OEORIarr.length-1&&del; i++){
			if(cDeletedOrderItemIDs.indexOf(mPiece(OEORIarr[i],"*",1))>=0)
				OEORIarr[i]=null;
		}
		for(var i=0; i<OEORIarr.length-1&&del; i++){
			if(OEORIarr[i]!=null)
				NewOrderString=NewOrderString+OEORIarr[i]+"^";
		}
		//end log59778---------------------------------------------
		OEORIobj.value=NewOrderString;
		cDeletedOrderItemIDs="";
		Aparam1=NewOrderString;
		var hcobj=document.getElementById('HiddenAuthCheck');
		if (hcobj) hcobj.onclick=hcobj.onchange;
		if (hcobj) {
			hcobj.click();
		}
		if (Acheckval!="") {
			var adobj=document.getElementById("AuthDoctor");
			//Log 46764 12/10/04 PeterC: Also consider the new 5 column "AuthClinician" field.
			if (!adobj) adobj=document.getElementById("AuthClinician");
			if (!adobj || (adobj && (adobj.value==""))) {
				if((Acheckval.indexOf("^")==-1)&&(Acheckval.indexOf("###")==-1)&&(Acheckval.indexOf("|||")==-1)&&(Acheckval.indexOf("!!!")==-1)){
					alert(Acheckval+" "+t['AuthDocNeeded']);
					return;
				}
				if(Acheckval.indexOf("^^")!=-1){
					alert(Acheckval.substring(0,(Acheckval.length-2))+t['NOACCESSITM']);
					return;
				}
				if(Acheckval.indexOf("^")!=-1){
					alert(Acheckval.substring(0,(Acheckval.length-1))+" "+t['QTY_OUTRANGE']);
					return;
				}
				if(Acheckval.indexOf("###")!=-1){
					
					Acheckval=Acheckval.substring(0,(Acheckval.length-3))
					while(Acheckval.indexOf("||")!=-1) {
						Acheckval=Acheckval.replace("||","\n");
					}
					var ret=confirm(Acheckval+'\n'+t['CONTINUE']);
					if (ret==false) {
						return false;
					}
					
				}
				if(Acheckval.indexOf("|||")!=-1){
					alert(Acheckval.substring(0,(Acheckval.length-3))+" "+t['NORECLOC']);
					return false;
				}
				if(Acheckval.indexOf("!!!")!=-1){
					alert(Acheckval.substring(0,(Acheckval.length-3))+"\n"+t['TYPESPECFIELDS']);
					return false;
				}
			}
		}
	}
	
	var summflag=document.getElementById("SUMMFlag");
	//Log 38102 Put hidden item in order to update daybook.
	DeleteAllHiddenItems();
	GetOrderDataOnAdd();
	var selList = lstOrders;
	var length = selList.length;
	var OEOrdItemIDsobj=document.getElementById("OEOrdItemIDs");

	//LOG 55511 JPD
	var CheckEpisDates=document.getElementById("AllowOrderOutEpisRange");
	if (CheckEpisDates.value!="Y") {
		var AdmDateobj=document.getElementById("AdmDate");
		var DischDateobj=document.getElementById("DischDate");
		var OEORISttDatobj=document.getElementById("OEORISttDat");
		var AddOnUpdateObj=document.getElementById("AddOnUpdate");
		var AdmDate,DischDate,OEORISttDat,AddOnUpdate=""
		if (AddOnUpdateObj) AddOnUpdate=AddOnUpdateObj.value;
		if (AdmDateobj) AdmDate=AdmDateobj.value;
		if (DischDateobj) DischDate=DischDateobj.value;
		// Log 56633 only pass in a custom start date value if override is checked
		if ((OEORISttDatobj)&& (AddOnUpdate=="on")) OEORISttDat=OEORISttDatobj.value;
		if (OEOrdItemIDsobj) OEOrdItemIDs=OEOrdItemIDsobj.value;
		//Log 58352 PeterC 24/04/06
		var TrimOEOrdItemIDs="";
		if(OEOrdItemIDs!="") {
			OSArr=OEOrdItemIDs.split("^");
			for (ix=0;ix<OSArr.length;ix++) {
				var CurrPce=OSArr[ix];
				if(CurrPce!="") TrimOEOrdItemIDs=TrimOEOrdItemIDs+"*"+mPiece(CurrPce,"*",1)+"^";
			}
		}
		//---------------------------------------
		var newwin=window.open("","TRAK_hidden");
		var doc = newwin.document;
		doc.open("text/html");
		doc.write("<html><head></head><body>\n");
		doc.writeln('<form name="OrderEntry" id="OrderEntry" method="POST" action="oeorder.checkepisdates.csp">');
		doc.writeln('<input name="OEOrdItemIDs" value="'+TrimOEOrdItemIDs+'">');
		doc.writeln('<input name="AdmDate" value="'+AdmDate+'">');
		doc.writeln('<input name="DischDate" value="'+DischDate+'">');
		doc.writeln('<input name="OEORISttDat" value="'+OEORISttDat+'">');
		doc.writeln('<input name="WINNAME" value="'+window.name+'">');
		doc.writeln("<INPUT TYPE=SUBMIT>");
		doc.writeln("</form>");
		doc.writeln("</body></html>");
		doc.close();
		var frm=doc.getElementById('OrderEntry');
		if (frm) frm.submit();
		//---------------------------------------

	}
	// To allow check dates csp to run before update_click
	window.setTimeout("UpdateClickHandlerFinish()",1000);
   }
}
// Split updateclick function for timeout to allow check dates csp to run before update_click
function UpdateClickHandlerFinish() {
	var flagobj=document.getElementById("dateflag");
	if (flagobj&&(flagobj.value=="N")) {
		flagobj.value="Y";
		return false;
	}
	UpdateClicked=1;
	Update_click();
}

function StartDateInRange(DoNotClickDeleteWhenNotContinue) {   // *****  Log# 30710; AmiN ; 17/Dec/2002 Start Date must be within Episode Admin Date and Discharge date *****
	if (!DoNotClickDeleteWhenNotContinue) DoNotClickDeleteWhenNotContinue=false;
	var aobj=document.getElementById("AdmDate");
	var dobj=document.getElementById("DischDate");
	var sobj=document.getElementById("OEORISttDat");
	var AOOERobj=document.getElementById("AllowOrderOutEpisRange");
	//tedt 2006 had wrong syntax for declaring multiple variables
	var atime=""; 
	var dtime="";
	var stime="";
	var atobj=document.getElementById("AdmTime");
	if ((atobj)&&(atobj.value!="")) atime=atobj.value;
	var dtobj=document.getElementById("DischTime");
	if ((dtobj)&&(dtobj.value!="")) dtime=dtobj.value;
	var stobj=document.getElementById("OEORISttTim");
	if ((stobj)&&(stobj.value!="")) stime=stobj.value;
	if ((!stobj)||((stobj)&&(stobj.value==""))) {
		var htobj=document.getElementById("hidCurrTime");
		if ((htobj)&&(htobj.value!="")) stime=htobj.value;
	}
	if (sobj && (sobj.value!="")) {
		if (dobj && (dobj.value!="") && aobj && (aobj.value!="")) {
			if ((DateTimeStringCompare(sobj.value,stime,dobj.value,dtime)>0) && (AOOERobj) && (AOOERobj.value!="Y")) { //OEORISttDat(entered Date)>DischDate
				alert(t['STARTDATE_OUT']+" "+aobj.value+" to " + dobj.value);
				sobj.value=""
				if(stobj) stobj.value="";
				if (!DoNotClickDeleteWhenNotContinue) DeleteClickHandler();
				return false;
			}else if ((DateTimeStringCompare(sobj.value,stime,aobj.value,atime)<0) && (AOOERobj) && (AOOERobj.value!="Y")) {   //OEORISttDat(entered Date)<AdmDate
				alert(t['STARTDATE_OUT']+" "+aobj.value+" to " + dobj.value);
				sobj.value=""
				if(stobj) stobj.value="";
				if (!DoNotClickDeleteWhenNotContinue) DeleteClickHandler();
				return false;
			}
		}else{   //  Catches when  DischDate empty
			if ((DateTimeStringCompare(sobj.value,stime,aobj.value,atime)<0) && (AOOERobj) && (AOOERobj.value!="Y")) {   //  OEORISttDat(entered Date)< AdmDate
				var bContinue=1;
				bContinue=confirm(t['STARTDATE_EXCEED']+" "+aobj.value + "\n" + t['CONTINUE']);
				if (!bContinue) {
					sobj.value=""
					if(stobj) stobj.value="";
					if (!DoNotClickDeleteWhenNotContinue) DeleteClickHandler();
					return false;
				}
			}
		}
	}
	return true;
	// end Log# 30710;
}

function zVerifyDateformat(obj) {  //log 30710 AmiN Start Date must be within Episode Admin Date and Discharge date.

	var date="";
	date=obj.value;

	var dateArr = date.split(dtseparator);

	if(dtformat=="YMD")
	{
		date = new Date(dateArr[0],dateArr[1],dateArr[2]);
	}

	else if(dtformat=="MDY")
	{
		date = new Date(dateArr[2],dateArr[0],dateArr[1]);
	}

	else
	{
		date = new Date(dateArr[2],dateArr[1],dateArr[0]);
	}

	return date;
}

function OSItemListOpen(id,OSdesc,del,itemtext,OrdRowIdString) {
	
	var VSobj=document.getElementById("VisitStatus");
	if ((!VSobj) || ((VSobj) && (VSobj.value!="C"))) {
	
	if (!OrdRowIdString) OrdRowIdString="";
	var TrimOSStr="";
	//Log 58352 18/04/06 PeterC
	if(OrdRowIdString!="") {
		OSArr=OrdRowIdString.split("^");
		for (ix=0;ix<OSArr.length;ix++) {
			var CurrPce=OSArr[ix];
			if(CurrPce!="") TrimOSStr=TrimOSStr+"*"+mPiece(CurrPce,"*",1)+"^";
		}
	}
	if(TrimOSStr!="") OrdRowIdString=TrimOSStr;
	var obj=document.getElementById("DefaultData");
	var patobj=document.getElementById("PatientID");
	var Patient = "";
	if (patobj) Patient=patobj.value;
	var objEpisodeID=document.getElementById("EpisodeID")
	var EpisodeID="";
	if (objEpisodeID) EpisodeID=objEpisodeID.value;

	var formulary="";
	var obj=document.getElementById("NonFormulary");
	if (obj) {
	 	if (obj.checked) formulary="Y";
		else {formulary="N";}
	}

	if (itemtext!="") {
		itemtext=escape(itemtext);
		var url="oeorder.ositemlist.csp?HiddenDelete="+del+"&itemtext="+itemtext+"&PatientID="+Patient+"&EpisodeID="+EpisodeID+"&OSOrderRowIDs="+escape(OrdRowIdString)+"&formulary="+formulary+"&OrderWindow="+window.name;
	} else {
		//var url="oeorder.ositemlist.csp?TEVENT=d128iHideButton"+"&HiddenDelete="+del+"&ORDERSETID="+id+"&ARCIMDesc="+OSdesc+"&PatientID="+Patient+"&EpisodeID="+EpisodeID+"&OSOrderRowIDs="+escape(OrdRowIdString)+"&LabOrderWithoutExternalCode="+LabOrderWithoutExternalCode+"&OrderWindow="+window.name;
		var url="oeorder.ositemlist.csp?HiddenDelete="+del+"&ORDERSETID="+id+"&ARCIMDesc="+OSdesc+"&PatientID="+Patient+"&EpisodeID="+EpisodeID+"&OSOrderRowIDs="+escape(OrdRowIdString)+"&LabOrderWithoutExternalCode="+LabOrderWithoutExternalCode+"&OrderWindow="+window.name;
	}
	//Adds default data to the url - log 22982
	if (obj) {
		var defdata="";
		url=url+"&DefaultData="+escape(defdata);
	}

        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.  
	websys_createWindow(url,"frmOSList","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")

	
	}

}

function matchCategory(Type,orderCat,orderSubCat,orderCode) {
	//Log 49059 PeterC 23/03/05
	var OSID=""
	if(mPiece(orderCode,"^",1)) OSID=mPiece(orderCode,"^",1);
	orderCode=mPiece(orderCode,"^",0);

	if (orderCat=="" || orderSubCat=="") {
		var NewOrders=cNewOrders.split("^");
		for (var b1=0;b1<NewOrders.length-1;b1++) {
			if (mPiece(mPiece(cNewOrders,"^",b1),"*",0)==orderCode) {
				var piece=mPiece(cCat,"^",b1);				
				if(piece) {
					orderCat=mPiece(piece,"*",0);
					orderSubCat=mPiece(piece,"*",1);
				}
				//orderCat=mPiece(mPiece(cCat,"^",b1),"*",0);
				//orderSubCat=mPiece(mPiece(cCat,"^",b1),"*",1);
			}
		}
	}
	if  (Type=="OS") {
		var objOSCat=document.getElementById("groupSetCat");
		var objOSSubCat=document.getElementById("groupSetSubCat");
		if (objOSCat && objOSSubCat) {
			var grpOSCatArray=objOSCat.value.split(",")
			var grpOSSubCatArray=objOSSubCat.value.split(",")
			for (i=0;i<grpOSCatArray.length;i++) {
				if ((orderCat==grpOSCatArray[i])&&(orderCat!="")) {
					return true;
				}
			}
			for (i=0;i<grpOSSubCatArray.length;i++) {
				if ((orderSubCat==grpOSSubCatArray[i])&&(orderSubCat!="")) {
					return true;
				}
			}
		}
	}
	else {
		var objIMCat=document.getElementById("groupItemCat");
		var objIMSubCat=document.getElementById("groupItemSubCat");
		if (objIMCat && objIMSubCat) {
			var grpIMCatArray=objIMCat.value.split(",")
			var grpIMSubCatArray=objIMSubCat.value.split(",")
			for (i=0;i<grpIMCatArray.length;i++) {
				if ((orderCat==grpIMCatArray[i])&&(orderCat!="")) {
					return true;
				}
			}
			for (i=0;i<grpIMSubCatArray.length;i++) {
				if ((orderSubCat==grpIMSubCatArray[i])&&(orderSubCat!="")) {
					return true;
				}
			}
		}
	}
	var objIMItem=document.getElementById("groupItemItem");
	//Log 49059 PeterC 23/03/05
	if ((OSID!="")&&(orderCode!="")) OSID=orderCode;
	if (objIMItem) {
		var grpIMItemArray=objIMItem.value.split(",")
		for (i=0;i<grpIMItemArray.length;i++) {
			if (orderCode==grpIMItemArray[i]) {
				return true;
			}
		}
	}

	return false;
}
function matchExecCategory(orderSubCat,orderCode) {
	var objIMSubCat=document.getElementById("groupExecSubCat");
	if (objIMSubCat) {
		var grpIMSubCatArray=objIMSubCat.value.split(",")
		for (i=0;i<grpIMSubCatArray.length;i++) {
			if (orderSubCat==grpIMSubCatArray[i]) {
				return true;
			}
		}
	}
	var objIMItem=document.getElementById("groupExecItem");
	if (objIMItem) {
		var grpIMItemArray=objIMItem.value.split(",")
		for (i=0;i<grpIMItemArray.length;i++) {
			if (orderCode==grpIMItemArray[i]) {
				return true;
			}
		}
	}
	return false;
}

//Log 58162 BoC 05/09/2006: new function to check category and Sub Category for "Show questionnaire for orders of subcategory" and "Show questionnaire for orders of category".
function matchQuesCategory(orderCat,orderSubCat,orderCode) {
	var OSID="";
	if(mPiece(orderCode,"^",1)) OSID=mPiece(orderCode,"^",1);
	orderCode=mPiece(orderCode,"^",0);
	if (orderCat=="" || orderSubCat=="") {
		var NewOrders=cNewOrders.split("^");
		for (var b1=0;b1<NewOrders.length-1;b1++) {
			if (mPiece(mPiece(cNewOrders,"^",b1),"*",0)==orderCode) {
				var piece=mPiece(cCat,"^",b1);				
				if(piece) {
					orderCat=mPiece(piece,"*",0);
					orderSubCat=mPiece(piece,"*",1);
				}
				//orderCat=mPiece(mPiece(cCat,"^",b1),"*",0);
				//orderSubCat=mPiece(mPiece(cCat,"^",b1),"*",1);
			}
		}
	}
	var objOEQuesCat=document.getElementById("OEQuesCat");
	if (objOEQuesCat) {
		var grpOEQuesCatArray=objOEQuesCat.value.split(",");
		for (i=0;i<grpOEQuesCatArray.length ;i++ ){
			if ((orderCat==grpOEQuesCatArray[i])&&(orderCat!="")) return true;
		}
	}
	var objOEQuesSubCat=document.getElementById("OEQuesSubCat");
	if (objOEQuesSubCat) {
		var grpOEQuesSubCatArray=objOEQuesSubCat.value.split(",");
		for (i=0;i<grpOEQuesSubCatArray.length ;i++ ){
			if ((orderSubCat==grpOEQuesSubCatArray[i])&&(orderSubCat!="")) return true;
		}
	}
	return false;
}

//counter for the number of INPUT boxes
function AddInputCust(selList,i,value) {
	// ANA LOG XXX
	// This is called to add hidden items when the item is added into the list box.
	// These items are accessed in ##Clas(web.OEOrdItem).InsertItems(X,X).
	var ORIRowId="";
	if (selList) ORIRowId=selList.options[i].ORIRowId;
	//if (ORIRowId!="") return ;
	hidItemCnt++;
	//Create a new element
	var NewElement=document.createElement("INPUT");
	//set the properties
	NewElement.id = 'hiddenitem' + hidItemCnt;
	NewElement.name = 'hiddenitem' + hidItemCnt;
	//NewElement.value = escape(value);
	//BM for drug interaction alert
	if (ORIRowId!="") {
		var newValue="";
		for (var loop9=0;loop9<value.split(String.fromCharCode(1)).length;loop9++) {
			if (loop9==1) {
				if (ORIRowId.split("*").length>1) newValue=newValue+mPiece(ORIRowId,"*",1)+String.fromCharCode(1);
				else newValue=newValue+ORIRowId+String.fromCharCode(1);
			}
			else newValue=newValue+mPiece(value,String.fromCharCode(1),loop9)+String.fromCharCode(1);
		}
		NewElement.value=newValue;
	}
	else {NewElement.value = value;}

	//NewElement.value = value;
	NewElement.type = "HIDDEN";
	document.fOEOrder_Custom.dummy.insertAdjacentElement("afterEnd",NewElement);
}

function AddInput(selList,value){
	// ANA LOG XXX
	// this is called on Update. Will add hidden fields in OEOrder.Custom which are OEOriRowIds.
	hidItemCnt++;
	var NewElement=document.createElement("INPUT");
	//set the properties
	NewElement.id = 'hiddenitem' + hidItemCnt;
	NewElement.name = 'hiddenitem' + hidItemCnt;
	NewElement.value = value;
	NewElement.type = "HIDDEN";
	document.fOEOrder_Custom.dummy.insertAdjacentElement("afterEnd",NewElement);
}

function deSelect(f,name) {   //Makes sure that only options in the select box, which presently has the focus, are highlighted.
	for (var i=0;i<f.elements.length;i++) {
		if (f.elements[i].type=="select-multiple" && f.elements[i].name!=name) {
			for (var j=0;j<f.elements[i].length;j++) {
				f.elements[i].options[j].selected=false;
			}
		}
	}
	var ary=getSelected(f.elements[name],0);
	tArray=new Array();
	n=0;
	for (var i=ary.length-1;i>=0;i--) {tArray[n]=ary[i]["txt"];n++}
	document.all.tags("label")["item"].innerHTML=tArray.join("<BR>");
}

function RemoveOneItemFromList(indx) {
	if (lstOrders) {
		lstOrders.options[indx]=null;
	}
}
function RemoveFromList(f,obj) {
	var deleteString="";
	var itypeLen="";
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected) {
			deleteString=obj.options[i].itype;
			itypeLen=deleteString.split(String.fromCharCode(4)).length;
			deleteString=mPiece(deleteString,String.fromCharCode(4),itypeLen-2);
			cDeletedOrderItemIDs=cDeletedOrderItemIDs+deleteString;
			obj.options[i]=null;
		}
	}
}

//returns 2dimArray of all highlighted options from multi-select boxes
//also deletes those options if the del variable passed in is 1.
//checkmulti sets if option should be checked against already ordered items
function getSelected(obj,del,checkmulti) {
  var ary=new Array();
  var n=0;
  var doAdd="";
  var val="";
  var icode="";
  var favItemIDs="";
  var OSItemsWithoutDesc="";
  var OSItemIDInOSArr="";
  if (obj) {
	for (var i=0;i<=obj.length-1;i++) {
		if (obj.options[i].selected==true) {
			doAdd=1;
			if (checkmulti==1) {
				val=mPiece(obj.options[i].value,String.fromCharCode(28),1);
				if (val==null) val=obj.options[i].value;
				icode=val;
				//BM
				if(mPiece(obj.options[i].value,String.fromCharCode(4),0)=="ARCOS"){
					favItemIDs=val+String.fromCharCode(12)+mPiece(obj.options[i].value,String.fromCharCode(4),4);
					val=favItemIDs;
				}
				doAdd=true; //Move the duplicate order check to summaryscreen
			}
			if (doAdd) {
				ary[n]=new Array();
				ary[n]["txt"]=obj.options[i].text;
				if(mPiece(obj.options[i].value,String.fromCharCode(4),0)=="ARCOS") {
					// BM  for orderset
					OSItemsWithoutDesc="";
					OSItemIDInOSArr=mPiece(obj.options[i].value,String.fromCharCode(4),4);
					OSItemIDInOSArr=OSItemIDInOSArr.split(String.fromCharCode(12));
					for (var j=0;j<OSItemIDInOSArr.length;j++) {
						if (OSItemIDInOSArr[j].split(String.fromCharCode(14)).length > 1) {
							if (OSItemIDInOSArr[j].split(String.fromCharCode(14))[1]!="") OSItemsWithoutDesc=OSItemsWithoutDesc+OSItemIDInOSArr[j].split(String.fromCharCode(14))[1]+String.fromCharCode(12);
						}
						else {
							if (j==0) OSItemsWithoutDesc=OSItemsWithoutDesc+OSItemIDInOSArr[j]+String.fromCharCode(12);
						}
					}
					OSItemIDInOSArr=obj.options[i].value.split(String.fromCharCode(4));
					OSItemIDInOSArr[4]=OSItemsWithoutDesc;
					ary[n]["val"]=OSItemIDInOSArr.join(String.fromCharCode(4));
				}
				else {
					ary[n]["val"]=obj.options[i].value;
				}
				n++;
			}
			if (del==1) obj.options.remove(i);
		}
	}
  }
	return ary;
}

//adds options to a select box from 2dimArray passed to function.
//also makes these added options selected if variable s is 1.
function addSelected(obj,selary,s) {
	var k=obj.length;
	var tmpval="";
	var tmpitype="";
	for (var i=0;i<selary.length;i++) {
		obj.options[k]=new Option(selary[i]["txt"],selary[i]["val"]);
		obj.options[k].itype=obj.options[i].value;
		tmpval=mPiece(obj.options[k].value,String.fromCharCode(28),1);
		tmpitype=obj.options[k].value;
		if ((tmpval)&&(tmpval!="")) obj.options[k].value=tmpval;
		if (s==1) obj.options[k].selected=true;
		k++;
	}
}

//collects data from all relevant form elements and submits form.
function submitForm(f,cls) {
	//not in use, need to double check
	var valArray=new Array();
	var namArray=new Array();
	var vArray="";
	var ntemp="";
	var vtemp="";
	for (var i=0;i<5;i++) {
		vArray=new Array();
		ntemp="group"+eval(i+1)+"name"
		if (f.elements[ntemp]) {namArray[i]=f.elements[ntemp].value;}
		vtemp="group"+eval(i+1)
		for (var j=0;j<f.elements[vtemp].length;j++) vArray[j]=f.elements[vtemp].options[j].value
		valArray[i]=vArray.join(",");
	}
	path=path+"&names="+namArray.join(",")+"&vals="+valArray.join(":");
	var hf=window.opener.top.frames["TRAK_hidden"];
	if (hf) hf.location.href=path;
	if (cls==1) window.close();
}


//fills non-hidden form elements with correct values from pre-defined arrays.
function docLoaded(f) {
	var namArray=nparams.split(",");
	var valArray=vparams.split(":");
	var txtArray=tparams.split(":");
	var selary="";
	var ntemp="";
	var goAhead="";
	var vtemp="";
	var vArray="";
	var tArray="";
	var idataArray="";
	var itypeArray="";
	if (tparams.split(":")!="") {
		for (var i=0;i<namArray.length;i++) {
			selary=new Array()
			ntemp="group"+eval(i+1)+"name"
			goAhead=0;
			if (f.elements[ntemp]) {f.elements[ntemp].value=namArray[i]}
			vtemp="group"+eval(i+1)
			vArray=new Array();
			tArray=new Array();
			idataArray=new Array();
			itypeArray=new Array();
			if (valArray[i]) var vArray=valArray[i].split(",");
			if (txtArray[i]) var tArray=txtArray[i].split("^");
			for (var j=0;j<vArray.length;j++) {
				if (vArray[j]!="") {
					selary[j]=new Array();
					selary[j]["val"]=vArray[j];
					selary[j]["txt"]=tArray[j];
					selary[j]["idata"]=idataArray[j];
					selary[j]["itype"]=itypeArray[j];
					goAhead=1;
				}
			}
			if (goAhead==1) addSelected(f.elements[vtemp],selary,0)
		}
	}
}

function getOSItemCount(j) {
	var count=1;
	totCount=0;
	for (var i=j+1; i<lstOrders.options.length; i++) {
		//store desc if order set, else itemid
		itmcount=mPiece(lstOrders.options[i].id,String.fromCharCode(4),2)
		if ((itmcount==1)||(itmcount=="")) return count;
		count=count+1;
	}
	return count;
}

function PricesClickHandler(evt) { 	//form string of items to check prices first
	var itms = "";
	var qty = "";
	var uom = "";
	var drugformid="";
	var price= "";
	var sets = "";
	var count=0;
	var itmcount=0;
	var ordidstr="";

	var ItemNoOS="";
	var itype="";
	var itypeLen="";
	var itemdata="";
	var itemtype="";
	for (var i=0; i<lstOrders.options.length; i++) {
		//store desc if order set, else itemid
		ItemNoOS=mPiece(lstOrders.options[i].id,String.fromCharCode(4),2)
		if (ItemNoOS==1) totCount=getOSItemCount(i);
		if ((!ItemNoOS)||(ItemNoOS=="")) totCount=0;
		if (lstOrders.options[i].value == "") {
			itms += mPiece(lstOrders.options[i].itype,String.fromCharCode(1),2) + "^";

			itype=lstOrders.options[i].itype;
			itypeLen=itype.split(String.fromCharCode(4)).length;
			if (itypeLen>1) ORIRowID=mPiece(itype,String.fromCharCode(4),itypeLen-2);
			if (ORIRowID.split("*").length>1) {
					ORIRowID=mPiece(ORIRowID,"*",1);
					//Log 63806 PeterC 02/07/07
					if(ORIRowID!="") ORIRowID=mPiece(ORIRowID,"^",0);
				}
				if(ORIRowID!="") {
					ordidstr += ORIRowID + "^";
					sets += mPiece(itype, String.fromCharCode(4), 0) + String.fromCharCode(1) + mPiece(itype, String.fromCharCode(4), 2) + String.fromCharCode(1) + totCount + "^";
				}
		} else {
			itms += lstOrders.options[i].value + "^";
			itype=lstOrders.options[i].itype;
			itypeLen=itype.split(String.fromCharCode(4)).length;
			if (itypeLen>1) ORIRowID=mPiece(itype,String.fromCharCode(4),itypeLen-2);
			//Log 63806 PeterC 02/07/07
			var ORIRowIDLen=ORIRowID.split("^").length;
			for (var ij=0; ij<ORIRowIDLen; ij++) {
				ORIRowIDTemp=mPiece(ORIRowID,"^",ij);
				if (ORIRowIDTemp.split("*").length>1) {
					ORIRowIDTemp=mPiece(ORIRowIDTemp,"*",1);
					if(ORIRowIDTemp!="") ORIRowIDTemp=mPiece(ORIRowIDTemp,"^",0);
				}
				if(ORIRowIDTemp!="") {
					sets += mPiece(itype, String.fromCharCode(4), 0) + String.fromCharCode(1) + mPiece(itype, String.fromCharCode(4), 2) + String.fromCharCode(1) + totCount + "^";
					ordidstr += ORIRowIDTemp + "^";
				}
			}

		}
		itemdata = lstOrders.options[i].idata;
		if (itemdata!="") itemdata=unescape(itemdata);
		itemtype = lstOrders.options[i].itype;
		/*
		if (itemtype) {
			sets += mPiece(itemtype, String.fromCharCode(4), 0) + String.fromCharCode(1) + mPiece(itemtype, String.fromCharCode(4), 2) + String.fromCharCode(1) + totCount + "^";
		} else {
			sets += "" + "^";
		}
		*/
	}
	
	//log 61703 TedT
	var save=tkMakeServerCall("web.OEOrdItem","TMPPriceOrderIDs",ordidstr,sets);

	//sets=escape(sets);
	var EpisodeID="";
	var objEpisodeID=document.getElementById("EpisodeID")
	if (objEpisodeID) {
		EpisodeID=objEpisodeID.value;

		//var evtSrc=websys_getSrcElement(evt);
		//Log 58352 PeterC 28/04/06
		while(ordidstr.indexOf("^^")!=-1) {
			ordidstr=ordidstr.replace("^^","^");
		}
		//var path="websys.default.csp?WEBSYS.TCOMPONENT=OEOrder.CheckPrices&EpisodeID="+EpisodeID+"&itemstr="+itms+"&qtystr="+qty+"&ordsetidstr="+sets+"&billpricestr="+price+"&uomstr="+uom+"&drugformstr="+drugformid+"&ordidstr="+ordidstr;
		//log 61703 TedT
		var path="websys.default.csp?WEBSYS.TCOMPONENT=OEOrder.CheckPrices&EpisodeID="+EpisodeID;

		websys_lu(path,false,"");
	}
	return false;
}

function CostsClickHandler(evt) { 	//form string of items to check prices first
	var itms = "";
	var qty = "";
	var uom = "";
	var drugformid="";
	var price= "";
	var sets = "";
	var count=0;
	var itmcount=0;
	var ordidstr="";

	var ItemNoOS="";
	var itype="";
	var itypeLen="";
	var itemdata="";
	var itemtype="";
	for (var i=0; i<lstOrders.options.length; i++) {
		//store desc if order set, else itemid
		ItemNoOS=mPiece(lstOrders.options[i].id,String.fromCharCode(4),2)
		if (ItemNoOS==1) totCount=getOSItemCount(i);
		if ((!ItemNoOS)||(ItemNoOS=="")) totCount=0;
		if (lstOrders.options[i].value == "") {
			itms += mPiece(lstOrders.options[i].itype,String.fromCharCode(1),2) + "^";
			itype=lstOrders.options[i].itype;
			itypeLen=itype.split(String.fromCharCode(4)).length;
			if (itypeLen>1) ORIRowID=mPiece(itype,String.fromCharCode(4),itypeLen-2);
			if (ORIRowID.split("*").length>1) ORIRowID=mPiece(ORIRowID,"*",1);
			ordidstr += ORIRowID + "^";
		} else {
			itms += lstOrders.options[i].value + "^";
			itype=lstOrders.options[i].itype;
			itypeLen=itype.split(String.fromCharCode(4)).length;
			if (itypeLen>1) ORIRowID=mPiece(itype,String.fromCharCode(4),itypeLen-2);
			if (ORIRowID.split("*").length>1) ORIRowID=mPiece(ORIRowID,"*",1);
			ordidstr += ORIRowID + "^";
		}
		itemdata = lstOrders.options[i].idata;
		if (itemdata!="") itemdata=unescape(itemdata);
		
		if (itemdata) {
			qty += mPiece(itemdata, String.fromCharCode(1), 10) + "^";
			uom += mPiece(itemdata,String.fromCharCode(1), 14) + "^";
			drugformid += mPiece(itemdata,String.fromCharCode(1), 93) + "^";
			price += mPiece(itemdata,String.fromCharCode(1), 32) + "^";
		} else {
			qty += "" + "^";
			uom += "" + "^";
			drugformid += "" + "^";
			price += "" + "^";
		}
		itemtype = lstOrders.options[i].itype;
		if (itemtype) {
			sets += mPiece(itemtype, String.fromCharCode(4), 0) + String.fromCharCode(1) + mPiece(itemtype, String.fromCharCode(4), 2) + String.fromCharCode(1) + totCount + "^";
		} else {
			sets += "" + "^";
		}
	}
	sets=escape(sets);
	var EpisodeID="";
	var objEpisodeID=document.getElementById("EpisodeID")
	if (objEpisodeID) {
		EpisodeID=objEpisodeID.value;
		//Log 58352 PeterC 28/04/06
		while(ordidstr.indexOf("^^")!=-1) {
			ordidstr=ordidstr.replace("^^","^");
		}
		var path="websys.default.csp?WEBSYS.TCOMPONENT=OEOrder.CheckCosts&EpisodeID="+EpisodeID+"&itemstr="+itms+"&qtystr="+qty+"&ordsetidstr="+sets+"&billpricestr="+price+"&uomstr="+uom+"&drugformstr="+drugformid+"&ordidstr="+ordidstr;
		websys_lu(path,false,"");
	}
	return false;
}

function LookUpCatSelect(txt) {
	//ANA 06.03.2002 Function to Return the Category ID
	var adata=txt.split("^");
	var catDesc=adata[0];
	var catID=adata[1];
	var catCode=adata[2];
	var cobj=document.getElementById("catID");
	if (cobj) cobj.value=catID;
	var scobj=document.getElementById("SubCategory");
	if (scobj) scobj.value="";
	var iobj=document.getElementById("Item");
	if (iobj) iobj.value="";

}

function LookUpSubCatSelect(txt) {
	//ANA 06.03.2002 Function to Return the SubCategory ID
	var adata=txt.split("^");
	var subCatDesc=adata[0];
	var subCatID=adata[1];
	var subCatCode=adata[2];
	var subcatobj=document.getElementById("subCatID");
	if (subcatobj) subcatobj.value=subCatID;

}

var cobj=document.getElementById("Category");
if (cobj) cobj.onblur=checkBlank;

//LOG 30799 02/12/02 PeterC: Commented out to prevent the Subcategory field from reseting
var scobj=document.getElementById("SubCategory");
if (scobj) scobj.onblur=SubCatChangeHandler;

function SubCatChangeHandler() {
	if ((scobj) && (scobj.value=="")) {
		var subcatobj=document.getElementById("subCatID");
		if (subcatobj) subcatobj.value="";
	}
}
function checkBlank(){
	var catobj=document.getElementById("catID");
	var subcatobj=document.getElementById("subCatID");
	if (cobj.value=="") {
		catobj.value="";
		cobj.value="";
		scobj.value="";
		subcatobj.value="";
	}
	if(scobj.value=="") {
		scobj.value="";
		subcatobj.value=""
	}
}

//TN:21-Jun-2002: create new hidden fields to store extra details already stored against the selected order item.
//only used for when order entry screen is being refreshed from some server side error message (such as invalid pin)
//should never call this unless you have already called AddInput();
function AddInputExtra(value) {
	//hidItemCnt has been incremented via AddInput();
	var obj=document.forms['fOEOrder_Custom'].elements['hiddenitem'+hidItemCnt];
	if (obj && (obj.value!=null)) {
		var NewElement=document.createElement("INPUT");
		NewElement.id = 'hiddenextra' + hidItemCnt;
		NewElement.name = 'hiddenextra' + hidItemCnt;
		NewElement.value = value;
		NewElement.type = "HIDDEN";
		obj.insertAdjacentElement("afterEnd",NewElement);

		var arrReloadVals=value.split(String.fromCharCode(1));
	}
}

function ReloadOrderSelectionListBox() {
	var lst=document.forms['fOEOrder_Custom'].elements['Orders'];
	var lstlength=0;
	var hidItem="";
	var hidItemExtra="";
	var desc=""; var value=""; var idval=""; var idata=""; var itype=""; var rowData="";
	var arrReloadVals="";
	var arrReloadExtraVals="";
	for (var i=1; i<=reloadingcnt; i++) {
	  //if (value=arrReloadExtraVals[2]!="") {
		hidItem=unescape(arrReload[i]);
		hidItemExtra=unescape(arrReloadExtra[i]);
		if (hidItem) {
			arrReloadVals=hidItem.split(String.fromCharCode(1));
			arrReloadExtraVals=hidItemExtra.split(String.fromCharCode(1));
			desc=arrReloadVals[0]; if (!desc) desc="";
			if ((arrReloadVals.length>2)&&(arrReloadExtraVals[0]=="DATA")) {
				idata=hidItem.substring(hidItem.indexOf(String.fromCharCode(1))+1);
			}
			//log 63412 for order set cases
			if (mPiece(arrReloadExtraVals[4],String.fromCharCode(4),0)=="ARCOS") {
				idval=arrReloadExtraVals[1]; if (!idval) idval="";
				value=arrReloadExtraVals[3]; if (!value) value="";
				itype=arrReloadExtraVals[4]; if (!itype) itype="";
				rowData=arrReloadExtraVals[5]; if (!rowData) rowData="";
			}
			else {
				idval=arrReloadExtraVals[1]; if (!idval) idval="";
				value=arrReloadExtraVals[2]; if (!value) value="";
				itype=arrReloadExtraVals[3]; if (!itype) itype="";
				//log 63321 TedT
				rowData=arrReloadExtraVals[4]; if (!rowData) rowData="";
			}
			lstlength=lstlength=lst.options.length;
			lst.options[lstlength]=new Option(desc,value);
			lst.options[lstlength].id=idval;
			lst.options[lstlength].itype=itype;
			lst.options[lstlength].idata=idata;
			//log 63321 TedT
			lst.options[lstlength].ORIRowId=rowData;
		}
	  //}
	}
}

function VerifyColRecDateTime() {

	var cd="";
	var ct="";
	var rd="";
	var rt="";


	var cdobj=document.getElementById("ColDate");
	if(cdobj) cd=cdobj.value;

	var ctobj=document.getElementById("ColTime");
	if(ctobj) ct=ctobj.value;

	var rdobj=document.getElementById("ReceivedDate");
	if(rdobj) rd=rdobj.value;

	var rtobj=document.getElementById("ReceivedTime");
	if(rtobj) rt=rtobj.value;

	var CDate ="";
	var RDate ="";

	if(rd=="" && rt!=""){
		alert(t['RECEIVE_DATETIME']);
		return false;
	}

	if(rd!=""){

		if(cd=="" || ct=="" || rt=="")
		{
			alert(t['RECEIVE_DATETIME']);
			return false;
		}

		else{
			var CdateArr = cd.split(dtseparator);
			var RdateArr = rd.split(dtseparator);
			var CtimeArr = ct.split(":");
			var RtimeArr = rt.split(":");

			if(dtformat=="YMD")
			{
				CdateArr[1]=CdateArr[1]-1;
				RdateArr[1]=RdateArr[1]-1;
				CDate = new Date(CdateArr[0],CdateArr[1],CdateArr[2],CtimeArr[0],CtimeArr[1]);
				RDate = new Date(RdateArr[0],RdateArr[1],RdateArr[2],RtimeArr[0],RtimeArr[1]);
			}

			else if(dtformat=="MDY")
			{
				CdateArr[0]=CdateArr[0]-1;
				RdateArr[0]=RdateArr[0]-1;
				CDate = new Date(CdateArr[2],CdateArr[0],CdateArr[1],CtimeArr[0],CtimeArr[1]);
				RDate = new Date(RdateArr[2],RdateArr[0],RdateArr[1],RtimeArr[0],RtimeArr[1]);
			}

			else
			{
				CdateArr[1]=CdateArr[1]-1;
				RdateArr[1]=RdateArr[1]-1;
				CDate = new Date(CdateArr[2],CdateArr[1],CdateArr[0],CtimeArr[0],CtimeArr[1]);
				RDate = new Date(RdateArr[2],RdateArr[1],RdateArr[0],RtimeArr[0],RtimeArr[1]);
			}


		}

		if (CDate>RDate){
			alert(t['INVALID_COLDATE']);
			return false;
		}

	}
}
function PrefAddItem(lstcnt,val,desc,hasdefault) {
	var lst=eval('lstGroup'+lstcnt);
	lst.options[lst.options.length] = new Option(desc,val);
	if(hasdefault=="Y") lst.options[lst.options.length-1].style.color="Blue";

}
function OEORISttDat_onBlur(e) {
	var obj=document.getElementById("OEORISttDat");
	Gparam5=obj.value;
	var objDate = DateStringToDateObj(Gparam5);
	var objToday = new Date();
	if (objDate < objToday) {
		var hsdcobj=document.getElementById("HiddenStartDateCheck");
		if (hsdcobj) hsdcobj.onchange();
		if (Gsdcheckval=="Y") {
			alert(t['InClosedAccPeriod']);
		}
	}
}

function HiddenStartDateCheck_changehandler(encmeth) {
	Gsdcheckval=cspRunServerMethod(encmeth,Gparam5);
}

function EnterKey(e) {
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==13){
		try {
			var eSrc=websys_getSrcElement();
			if ((eSrc.id=="group1")||(eSrc.id=="group2")||(eSrc.id=="group3")||(eSrc.id=="group4")||(eSrc.id=="group5")) ListDoubleClickHandler();
		}
		catch(e) {}
	}

}

function RunInHiddenWindow(url) {
//PeterC 22/03/04 Log 42624 need to close the window open by running var alertwin = window.open("","AlertScreen");
	var alertwin = window.open("","AlertScreen");
	if (alertwin) {
		var pobj=alertwin.document.getElementById("PatientID");
		if ((pobj)&&(pobj.value!="")) {
			url=url+"&FocusWindowName=AlertScreen";
		}
		if (alertwin.location=="about:blank") alertwin.close();
	}
	websys_createWindow(url,"TRAK_hidden");
}

function AddNewDentalOrder(OrderRowID,NewTeeth,OrderGroupNumber) {
	Nparam1=OrderRowID;
	Nparam2=NewTeeth;
	Nparam3=OrderGroupNumber; //This param is not for csp method, it is used in showing the order group number 
	var hndobj=document.getElementById('HiddenNewDentalOrder');
	if (hndobj) hndobj.onclick=hndobj.onchange;
	if (hndobj) {
		hndobj.click();
	}
}

//JPD LOG 51637
function OrdCatGrpJSHandler(str){
	var lu=str.split("^");
	var CatGrp=document.getElementById('OrdCatGrp');
	if (CatGrp) CatGrp.value=lu[0];
	var Category=document.getElementById('Category');
	if (Category) Category.value="";
	var scobj=document.getElementById("SubCategory");
	if (scobj) scobj.value="";
	return;
}

//Log 46424 Add Order Group Number 
function ChangeOrderGroupNumber(NewOrderGroupNumber) {
	var selList = lstOrders;
	var length = selList.length;
	var OrderRowID=mPiece(NewOrderGroupNumber,"^",0);
	var newOrderGroupNumber=mPiece(NewOrderGroupNumber,"^",1);
	
	for (var i=0; i<length; i++) {
		if (selList.options[i].ORIRowId.split(OrderRowID).length>1) {
			if (newOrderGroupNumber!="") selList.options[i].text = mPiece(selList.options[i].text,"((",0)+"(("+newOrderGroupNumber+"))";
			else selList.options[i].text = mPiece(selList.options[i].text,"((",0);
			break;
		}
	}
}

function UpdateGroupNumberClickHandler() {
	var selList = lstOrders;
	var length = selList.length;
	var selOrderRowID="";
	var GroupNumber="";
	var objGroupNumber=document.getElementById("OEORIItemGroup");
	if ((objGroupNumber)&&(objGroupNumber.value!="")) GroupNumber=objGroupNumber.value;
	
	if (GroupNumber!="") {
		for (var i=0; i<length; i++) {
			if (selList.options[i].selected) selOrderRowID=selOrderRowID+selList.options[i].ORIRowId+"^";
		}
		if (selOrderRowID!="") {
			Uparam1=GroupNumber;
			Uparam2=selOrderRowID;
			var hugnobj=document.getElementById('HiddenUpdateGroupNumber');
			if (hugnobj) hugnobj.onclick=hugnobj.onchange;
			if (hugnobj) {
				hugnobj.click();
			}
		}
	}
}

function BodyUnloadHandler(evt) {
	if (window.event) {
		if ((window.event.clientX < 0)&&(!UpdateClicked)) {
			if ((!top.frames["eprmenu"])&&(!top.frames["TRAK_menu"])) {
				var hidObj=document.getElementById('HidUnload');
				//uncommented out the following line for log 60706
				if (hidObj) hidObj.onchange();
			}
		}
	}
	UpdateClicked=0;
	websys_onunload();
}

function HidUnload_changehandler(encmeth) {

	var sessparam1="";
	var sessObj=document.getElementById("SessionID");
	if (sessObj) sessparam1=sessObj.value;
	Gcheckval=cspRunServerMethod(encmeth,sessparam1);


}
window.onunload=BodyUnloadHandler;

document.body.onkeydown=EnterKey;
var obj=document.getElementById("OEORIRefDocDR");
//if (obj) obj.onkeydown=REFDDesc_lookuphandlerCustom;
var obj=document.getElementById("ld128iOEORIRefDocDR");
//if (obj) obj.onclick=REFDDesc_lookuphandlerCustom;
var obj=document.getElementById("OEORISttDat");
if ((obj)&&(obj.value!="")) obj.onblur=OEORISttDat_onBlur;
//Log 54451 PeterC 19/08/05
var obj=document.getElementById("NonFormulary");
if (obj) obj.onclick=NonFormularyClickHandler;
var obj=document.getElementById("ShowBrands");
if (obj) obj.onclick=ShowBrandsClickHandler;
MultiEpisodeID();

function NonFormularyClickHandler() {
	//log 60958 TedT
	var fobj=document.getElementById("hidNonForm");
	if(fobj) {
		if(this.checked) fobj.value="Y";
		else fobj.value="";
	}
	var CurrTab="";
	CurrTab=window.currTab;
	RedrawFavourites(CurrTab,"");
	ShowBrandsClickHandler();
}

function ShowBrandsClickHandler() {
	//Log 55414 24/10/05 PeterC: Now combine "Non-Formulary" and "Show Brands" into one flag
	var NonForm,ShowBrand="false";
	//log 60958 use hidden item instead of check box
	var fobj=document.getElementById("hidNonForm");
	var bobj=document.getElementById("ShowBrands");
	var hidfbobj=document.getElementById("NonFormAndBrand");
	if(hidfbobj) {
		if((fobj)&&(fobj.value=="Y")) NonForm="true";
		if((bobj)&&(bobj.checked)) ShowBrand="true";
		if(NonForm!="true") NonForm=false;
		if(ShowBrand!="true") ShowBrand=false;
		hidfbobj.value=NonForm+"|"+ShowBrand;
		//TedT
		PharmParamHandler();
	}
}

//tedt combine pharmacy param
function PharmParamHandler(txt) {
	var hidfbobj=document.getElementById("NonFormAndBrand"); 
	var HidRtFrmStr=document.getElementById("HidRtFrmStr"); 
	var pharm=document.getElementById("Pharm");
	var HidRegion=document.getElementById("HidRegion");
	var Region=document.getElementById("Region"); 
	var x="";
	
	if(hidfbobj) x+=hidfbobj.value;
	x+="^";
	if(HidRtFrmStr) x+=HidRtFrmStr.value;
	x+="^";
	if((HidRegion)&&(Region)&&(Region.value!="")) x+=HidRegion.value;
	if(pharm) pharm.value=x;
}

//log60323 TedT
function LinkDiagnosisClickHandler() {
	var mradm=document.getElementById("mradm"); 
	if(mradm) mradm=mradm.value;
	var consult=document.getElementById("ConsultID");
	if(consult) consult=consult.value;
	var patient=document.getElementById("PatientID");
	if(patient) patient=patient.value;
	var episode=document.getElementById("EpisodeID");
	if(episode) episode=episode.value;
	var MRDia=document.getElementById("MRDiagnos");
	if(MRDia) MRDia=MRDia.value;
	var CONTEXT=document.getElementById("CONTEXT");
	if(CONTEXT) CONTEXT=CONTEXT.value;
	
	var orderlist=parent.frames["orderlist"];
	var orderids="";
	if(orderlist) orderids=orderlist.GetSelectedOrders();
	else orderids=SelectedOrders();
	if(orderids=="") {
		alert(t['NOSELECT']);
		return false;
	}
	var url="oeorder.diagnosis.csp?CONTEXT="+CONTEXT+"&PatientID="+patient+"&EpisodeID="+episode+"&mradm="+mradm+"&ConsultID="+consult+"&OrderIDs="+orderids+"&MRDiagnos="+MRDia+"&ActiveDiagnosis=Y";
	websys_createWindow(url,"","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");

	return false;
}

//TedT get order ids for highlighted orders
function SelectedOrders() {
	var orderids="";
	var temp="";
	for (var bm6=0;bm6<lstOrders.length;bm6++) {
		if (lstOrders.options[bm6].selected) {
			temp=lstOrders.options[bm6].ORIRowId;
			orderids=orderids+(temp.split("*"))[1]+"^";
		}
	}
	
	return orderids;
}

//Log 62324 PeterC 23/03/07
var obj=document.getElementById("Region");
if (obj) obj.onblur=PharmParamHandler;

//Log 62324 PeterC 25/01/07
function RegionLookUpHandler(str) {
	var lu=str.split("^");
	var Desc=document.getElementById("Region");
	if (Desc) Desc.value=lu[0];
	var HidDesc=document.getElementById("HidRegion");
	if (HidDesc) HidDesc.value=lu[1];

	PharmParamHandler();
	return;
}