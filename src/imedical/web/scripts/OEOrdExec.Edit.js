// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Change Log
//  Modified by Alwin - 2/7/05
// * Included method EnableMandatoryField(fldName)
// * Included method UserLookUpSelect
// * Calls EnableMandatoryField if the overseer is required (ie == "Y")
// * Runs a validator to ensure that overseer fields are entered correctly

//// 59254
function ChangeAdmStat(lnk,newwin) {
	if (AdminFlag!="Y") {
		alert(t['NO_STAT']);
		return;
	}
	if ((document.getElementById('AllowChangeAdminStatus')) && (document.getElementById('AllowChangeAdminStatus').value=="1")) {
		if (document.getElementById('ID')) {var ParID=document.getElementById('ID').value;} else {var ParID="";}
		if (ParID=="") { return; }
		lnk = lnk + "&ParID=" + ParID;
		websys_lu(lnk,0,newwin);
	} else { alert(t['INVAL_GRP']); }
	return;
	
}

function OECRouteLookUpHandler(str) {
	var lu = str.split("^");
	var obj=document.getElementById("OEORIRoute")
	if (obj) obj.value = lu[0]
}

var AdminFlag="";
function DoDisable() {
	var execStat=document.getElementById("OEOREOrderStatusDR");
	//if administered, disable fields
	if ((execStat)&&(execStat.value!="")) {
		AdminFlag="Y";

		var arrFields=document.getElementsByTagName("INPUT");

		for (var i=0; i<arrFields.length; i++) {
		//alert ("arrFields  "+arrFields[i].type);
			if ((arrFields[i].type!="hidden")&&(arrFields[i].id!="PIN")&&(arrFields[i].id!="UserCode"))
				arrFields[i].disabled=true;
		}
		var arrLookUps=document.getElementsByTagName("IMG");

		for (var i=0; i<arrLookUps.length; i++) {
				if ((arrLookUps[i].id.substr(6)!="OEOREMedOutcomeDR")&&(arrLookUps[i].id.substr(6)!="SkinTestOutcome")&&(arrLookUps[i].id)&&(arrLookUps[i].id.indexOf("ld")==0))
				arrLookUps[i].disabled=true;
		}
		var obj=document.getElementById("SelectBatches");
		if (obj) {
			obj.disabled=true;
			obj.onclick = {};
		}
		obj=document.getElementById("OEOREMedOutcomeDR");
		if (obj) {
			obj.disabled=false
		}
		//log59552 TedT 06/2006 skin test outcome shouldnt be disabled
		obj=document.getElementById("SkinTestOutcome");
		if (obj) {
			obj.disabled=false
		}
		//var obj=document.getElementById("update1");
		//if (obj) obj.disabled=true;
	}
}

function DoEnable() {
	var execStat=document.getElementById("OEOREOrderStatusDR");
	//if administered, disable fields
	if ((execStat)&&(execStat.value!="")) {
		var arrFields=document.getElementsByTagName("INPUT");

		for (var i=0; i<arrFields.length; i++) {
		//alert ("arrFields  "+arrFields[i].type);
			if ((arrFields[i].type!="hidden")&&(arrFields[i].id!="PIN")&&(arrFields[i].id!="UserCode"))
				arrFields[i].disabled=false;
		}
		var arrLookUps=document.getElementsByTagName("IMG");

		for (var i=0; i<arrLookUps.length; i++) {
			if ((arrLookUps[i].id)&&(arrLookUps[i].id.indexOf("ld")==0))
				arrLookUps[i].disabled=false;
		}
		var obj=document.getElementById("SelectBatches");
		if (obj) obj.disabled=false;

		//var obj=document.getElementById("update1");
		//if (obj) obj.disabled=true;
	}
}

// LOG 36920 RC These checks are done here instead of in the websysSave because the websysSave is still the generated one,
// and I couldn't be bothered to change it, and this was just as easy.
// LOG 41260 RC This has been moved to the websysBeforeSave of OEOrdExec.
/*function CheckDate() {
	var dateobj=document.getElementById("OEOREDateExecuted");
	var today=new Date();
	var dtex=new Date();
	if (dateobj) {
		var day=parseInt(mPiece(dateobj.value,"/",0),10)
		var month=parseInt(mPiece(dateobj.value,"/",1),10)
		var year=parseInt(mPiece(dateobj.value,"/",2))
		dtex.setDate(day); dtex.setMonth(month-1); dtex.setFullYear(year);
		if (today.valueOf()<dtex.valueOf()) {
			alert(t['DateFuture']);
			return 0;
		}
	}
	return 1;
}

function CheckTime() {
	var timeobj=document.getElementById("OEORETimeExecuted");
	var now=new Date();
	var tmex=new Date();
	if (timeobj) {
		var hours=parseInt(mPiece(timeobj.value,":",0))
		var mins=parseInt(mPiece(timeobj.value,":",1))
		tmex.setHours(hours); tmex.setMinutes(mins);
		if (now.getTime()<tmex.getTime()) {
			alert(t['DateFuture']);
			return 0;
		}
	}
	return 1;
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
}*/


/*
 * Simple function which inserts the OverSeer User's code rather than
 * Description
 */
function UserLookUpSelect(str) {
	var userLookUpVals = str.split("^");
	document.getElementById("OverseerUser").value=userLookUpVals[2];
}


function updateClick() {

	// check alt location and batch.
	var AltLocObj=document.getElementById("OEOREAltRecLocDR");
	var HSBObj=document.getElementById("HidStockBatches");
	var SBObj=document.getElementById("OEOREStockBatches");

	var ORideobj=document.getElementById("PackOverride");
	var hidORideobj=document.getElementById("overridepack");

	var AltLocObj=document.getElementById("OEOREAltRecLocDR");
	var lookupobj=document.getElementById('ld489iOEOREAltRecLocDR');
	var SBObj=document.getElementById("OEOREStockBatches");
	//--Log 59854 PeterC 08/08/06--------------
	var CTPCPDObj=document.getElementById("CTPCPDesc");
	var STATDObj=document.getElementById("STATDesc");
	if(CTPCPDObj&&(CTPCPDObj.className=="clsRequired")&&(CTPCPDObj.value=="")) {
		alert(t['CTPCPDesc'] + " " + t['XMISSING']);
		return false;
	}
	if(CTPCPDObj&&(CTPCPDObj.className=="clsInvalid")&&(CTPCPDObj.value!="")) {
		alert(t['CTPCPDesc'] + " " + t['XINVALID']);
		return false;
	}
	if(STATDObj&&(STATDObj.className=="clsRequired")&&(STATDObj.value=="")) {
		alert(t['STATDesc'] + " " + t['XMISSING']);
		return false;
	}
	if(STATDObj&&(STATDObj.className=="clsInvalid")&&(STATDObj.value!="")) {
		alert(t['STATDesc'] + " " + t['XINVALID']);
		return false;
	}
	//----------------------------------------
	var skintest=document.getElementById("SkinTestOutcome");
	var testok=document.getElementById("SkinTestOK");
	var canAdmin=document.getElementById("CanAdmin");
	var execStat=document.getElementById("OEOREOrderStatusDR");
	var statCanAdmin=document.getElementById("StatCanAdmin");
	
	//log59552 TedT if skinTestOK field is 0, skin test outcome is madatory
	if(testok && skintest && testok.value==0 && skintest.value=="") {
		alert(t['SKINTEST']);
		return false;
	}
	//log61355 TedT 
	var passAdmin=(canAdmin && statCanAdmin && (canAdmin.value==statCanAdmin.value || (canAdmin.value!="Y"&&statCanAdmin.value!="Y")));
	//log59552 TedT if this is not first administer, and testok is 0, and selected skin testoutcome cannot be administered, do not allow update
	if(testok && testok.value==0 && !passAdmin) {
		if(statCanAdmin.value=="Y")
			alert(t['POSADMIN']);
		else 
			alert(t['NEGADMIN']);
		skintest.focus();
		return false;
	}
	
	if (ORideobj && ORideobj.checked) {
		if ((AltLocObj && AltLocObj.value=="")||(SBObj && SBObj.value=="")) {
			alert(t['NOOVERRIDE']);
			return 0;
		}
	}
	if((SBObj)&&(SBObj.value=="")) HSBObj.value=""
	if (AltLocObj && AltLocObj.value!="") {
		if (SBObj && HSBObj) {
			if ((SBObj.value=="")||(HSBObj.value=="")) {
				alert(t['AltLocNoBatch'] + " " + t['OEOREAltRecLocDR'] + " " + AltLocObj.value);
				return 0;
			}
		} else {
			alert(t['AltLocNoBatch'] + " " + t['OEOREAltRecLocDR'] + " " + AltLocObj.value);
			return 0;
		}
	}

	//JPD Log 35242
	var OEOREQtyOrd=document.getElementById("OEOREQtyOrd");
	var OEOREQtyAdmin=document.getElementById("OEOREQtyAdmin");
	if (PRNObj && PRNObj.value=="Y"){
		if (OEOREQtyAdmin && (parseInt(OEOREQtyAdmin.value)>parseInt(OEOREQtyOrd.value))) {
			var dosemsg=confirm(t['ORDDOSE']+"\n"+t['CONTINUE']);
			if (!dosemsg) return false;
		}
		if ((ReaObj) && (ReaObj.value == "")) {
			alert(t['OEOREPRNReason'] + " " + t['XMISSING']);
			return false;
		}
	}
	//end log 35242

	// Log 47176 - AI - 06-12-2004 : Prompt for OK/Cancel if the Administered date/time is in the future.
	//    NOTE: This is a custom script function ( therefore it is NOT in THIS file! ).
	try { 
		var ovsMand = document.getElementById("isOverSeerMandatory");
		var execStat=document.getElementById("OEOREOrderStatusDR");
		var userCode = document.getElementById("UserCode");
		var ovsUser = document.getElementById("OverseerUser");
	
		if (userCode) {
			if (userCode.value == ovsUser.value) {
				alert(t['USEROVERSEE']);
				websys_setfocus(ovsUser.name);
				return false;
			}
		}

		if (ovsMand && ovsMand.value == "Y"  && ((execStat)&&(execStat.value==""))) {

			var ovsUserPass = document.getElementById("OverseerPassword");
			
			if ((ovsUser) && (ovsUser.value == "")) {
				alert(t['OVERSEE'] + t['XMISSING']);
				return false;
			}
			if ((ovsUserPass) && (ovsUserPass.value == "")) {
				alert(t['OVERSEEPASS'] + t['XMISSING']);
				return false;
			}
			

		}

		if(!CheckAdministeredDateTime()) {
			return false;
		}
	} catch(e) {}
	// end Log 47176

	DoEnable();
	/*if (CheckDate()==0) {
		return false;
	}
	if (CheckTime()==0) {
		return false;
	}*/
	//Log 49584 PeterC 12/05/05
	var HidAdmQty = document.getElementById("HidOEOREQtyAdmin");
	var AdmQty = document.getElementById("OEOREQtyAdmin");
	//Log 58091 PeterC 03/02/06
	if((HidAdmQty)&&(AdmQty)&&(parseInt(AdmQty.value)>parseInt(HidAdmQty.value))) {
		alert(t['EXCEEDQTY']+ HidAdmQty.value);
		return false;
	}
	if((AdmQty)&&(AdmQty.value!="")&&(HidAdmQty)) HidAdmQty.value=AdmQty.value;
	//Log 59854 19/07/06
	var IFObj=document.getElementById("IsFirst");
	var PBVObj=document.getElementById("OEOREPrevBagVolume");
	if((IFObj)&&(IFObj.value=="N")&&(PBVObj)&& ((PBVObj.value=="")||(PBVObj.className =="clsInvalid"))) {
		alert(t['OEOREPrevBagVolume'] +" "+ t['XMISSING']);
		return false;
	}
	var IPAObj=document.getElementById("IVContPrevAdmin");
	if((IPAObj)&&(IPAObj.value!="")) {
		if(IPAObj.value=="N") {
			var msg=confirm(t['IVCONT_INCOMPLETE']);
			if (!msg) return false;
		} 
		else if(IPAObj.value=="ERR") {
			alert(t['IVCONT_NOTSTARTED']);
			return false;
		}
	}

	//Log 60136 PeterC 26/07/06
	var obj2=document.getElementById("HidStockBatches");
	if((obj2)&&(obj2.value=="")) {
		var HidBatchIds="";
		var tbl = document.getElementById("tOEOrdExec_RecipeList");
		if (tbl) {
			var AssignBatch="Y";
			for (var i=0;i<tbl.rows.length;i++) {
				var obj=document.getElementById("BatchIDz"+i);
				var obj0=document.getElementById("Batchz"+i);
				var obj1=document.getElementById("QTYBaseUOMz"+i);
				var obj3=document.getElementById("DefBatchIDz"+i);
				if((obj0)&&(obj0.className=="clsInvalid")) {
					alert(t['INVALID_BATCH']);
					return false;
				}
				//if(((obj0)&&(obj0.value!=""))||((obj3)&&(obj3.value!=""))) AssignBatch="Y";
				if((AssignBatch=="Y")&&(obj0)&&(obj0.value=="")&&(obj3)&&(obj3.value=="")) {
					alert(t["BATCH_MISSING"]);
					return false;
				}
				if ((obj)&&(obj.value!="")&&(obj0)&&(obj0.value!="")&&(obj1)) {
					HidBatchIds=HidBatchIds+obj.value+","+obj1.value+"&";
				}

				else if ((obj3)&&(obj3.value!="")&&(obj1)) {
					HidBatchIds=HidBatchIds+obj3.value+","+obj1.value+"&";
				}

			}
		}
		if(HidBatchIds!="") {
			HidBatchIds=HidBatchIds.substring(0,HidBatchIds.length-1);
			obj2.value=HidBatchIds;
		}
	}
	//Log 57298 PeterC 16/10/06
	Altbl=document.getElementById("tPharmacy_Prescription_Alert");
	Alfrm=document.getElementById("fPharmacy_Prescription_Alert");
	var BadOrders="";
	if (Altbl) {
		for (var i=1; i<Altbl.rows.length; i++) {
			var ChkORDIDObj=Alfrm.elements["RowIdz"+i];
			if (ChkORDIDObj) {
				var AAReasObj=Alfrm.elements["HIDDENOVERREASz"+i];
				var sevOVRIDEObj=Alfrm.elements["sevOVRIDEz"+i];
				if ((sevOVRIDEObj)&&(sevOVRIDEObj.value=="Y")) {
					if ((AAReasObj)&&(AAReasObj.value=="")) {
						// mandatory override required, but none entered...
						var drugname=""; 
						var dnobj=Alfrm.elements["hidordnamez"+i];
						if((dnobj)&&(dnobj.value!="")) {
							var drugname = dnobj.value;
							if (drugname!="") {
								if (BadOrders!="") BadOrders += ', ';
								BadOrders += drugname;
							}
						}
					}
				}
			}
		}
	}
	var BadString = "";
	if (BadOrders!="") {
 		BadString = t['OVERREQUIRED'] + ' ' + BadOrders;
		alert(BadString);
		return false;
	}
	if (Altbl) {
		var tmpstr="";
		for (var i=1; i<Altbl.rows.length; i++) {
			var ChkORDIDObj=Altbl.document.getElementById("RowIDz"+i);
			var AAReasIDObj=Altbl.document.getElementById("OVERREASIDz"+i);
			if (ChkORDIDObj && AAReasIDObj && (AAReasIDObj.value!="")) {
				if (tmpstr!="") tmpstr+="^";
				tmpstr+=ChkORDIDObj.value + String.fromCharCode(1) + AAReasIDObj.value;
			}
		}
		var objReasons = document.getElementById("Reasons");
		if (objReasons) objReasons.value = tmpstr;
	}
	return update1_click();
}


function EnableMandatoryField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "clsRequired";
	}
}


document.focus()

var ovsMand = document.getElementById("isOverSeerMandatory");

if (ovsMand && (ovsMand.value == "Y")) {
	EnableMandatoryField("OverseerUser");
	EnableMandatoryField("OverseerPassword");
}

//JPD LOG 52493 29/09/05
// Outside bodyonloadhandler to ensure field disables correctly after execution
var PRNObj=document.getElementById("PRNFlag");
var PriObj=document.getElementById("Priority");
var ReaObj=document.getElementById("OEOREPRNReason");
if (PRNObj && PRNObj.value=="Y") {
	if (ReaObj) EnableMandatoryField("OEOREPRNReason");
	// 57308
	var PlanDateObj=document.getElementById("OEOREExStDate");
	var PlanTimeObj=document.getElementById("OEOREExStTime");
	if (PlanDateObj) PlanDateObj.innerText=""
	if (PlanTimeObj) PlanTimeObj.innerText=""
} else if (ReaObj){
	ReaObj.disabled = true;
}

DoDisable();

function RecLocLookUpHandler(str) {
	var BatchObj=document.getElementById("OEOREStockBatches");
	if (BatchObj) BatchObj.value="";
	var lu = str.split("^");
	var IDObj=document.getElementById("OEOREAltRecLocDR1");
	if (IDObj) IDObj.value=lu[2];
	
}

function BodyOnLoadHandler() {

	var upd=document.getElementById("update1");
	if (upd) upd.onclick=updateClick;

	//log63172 disable update if order status is On Hold or Discontinued
	var OSTATCode=document.getElementById("OSTATCode");
	if ((OSTATCode) && (OSTATCode.value=="H" || OSTATCode.value=="D")) {
		var obj=document.getElementById("update1");
		if (obj) {
			obj.disabled=true;
			obj.onclick = {};
			alert(t['DCORDER']);
		}
		return false;
	}
	
	//log59552 TedT make skin test outcome field mandatory if SkinTestOk is not 1
	var skintest=document.getElementById("SkinTestOutcome");
	var testok=document.getElementById("SkinTestOK");
	if(testok && skintest && testok.value!=1) 
		EnableMandatoryField("SkinTestOutcome");
	if(skintest) skintest.onblur=SkinTestOnBlur;
	
	var BNumObj=document.getElementById("OEOREStockBatches");
	if ((BNumObj)&&(BNumObj.value!="")) {
		BNumObj.disabled=true;
		var LookUpObj=document.getElementById("ld489iOEOREStockBatches");
		if (LookUpObj) LookUpObj.disabled=true;
		//var obj=document.getElementById("SelectBatches");
		//if (obj) {
		//	obj.disabled=true;
		//	obj.onclick = {};
		//}
	}
	
	// object added 59002 - initialised early to piggyback functionality
	var ORideobj=document.getElementById("PackOverride");
	var packed=document.getElementById("PackedFlag");

	if (packed && packed.value=="N" && ORideobj) ORideobj.disabled=true; 
	
	if (packed && packed.value!="N") {
		var NewRecLocObj=document.getElementById("OEOREAltRecLocDR");
		if (NewRecLocObj) {
			//NewRecLocObj.value="";
			NewRecLocObj.disabled=true;
			var lookupobj=document.getElementById('ld489iOEOREAltRecLocDR');
			if (lookupobj) lookupobj.disabled=true;
			var IDObj=document.getElementById("OEOREAltRecLocDR1");
			if (IDObj) IDObj.value="";
		}	
	}

	// 58153
	var PriCode=document.getElementById("HIDPriorityCode");
	if (PriCode && (PriCode.value=="OM")){
		BNumObj.disabled=true;
		var LookUpObj=document.getElementById("ld489iOEOREStockBatches");
		if (LookUpObj) LookUpObj.disabled=true;
		var NewRecLocObj=document.getElementById("OEOREAltRecLocDR");
		if (NewRecLocObj) {
			NewRecLocObj.value="";
			NewRecLocObj.disabled=true;
			var lookupobj=document.getElementById('ld489iOEOREAltRecLocDR');
			if (lookupobj) lookupobj.disabled=true;
			var IDObj=document.getElementById("OEOREAltRecLocDR1");
			if (IDObj) IDObj.value="";
			if (ORideobj) ORideobj.disabled=true;
		}
	}

	/// Disable batch stuff if not med type orders.
	var TypeObj=document.getElementById("OrdType");
	//Log 60724 15-09-2006 BoC: don't disable 'Alternative Dispensing Location' for IV
	if (TypeObj && (TypeObj.value!="R") && (TypeObj.value!="I")) {
		if (ORideobj) ORideobj.disabled=true;
		var NewRecLocObj=document.getElementById("OEOREAltRecLocDR");
		if (NewRecLocObj) {
			NewRecLocObj.value="";
			NewRecLocObj.disabled=true;
			var lookupobj=document.getElementById('ld489iOEOREAltRecLocDR');
			if (lookupobj) lookupobj.disabled=true;
			var IDObj=document.getElementById("OEOREAltRecLocDR1");
			if (IDObj) IDObj.value="";
		}
		var BNumObj=document.getElementById("OEOREStockBatches");
		if (BNumObj) {
			BNumObj.disabled=true;
			var LookUpObj=document.getElementById("ld489iOEOREStockBatches");
			if (LookUpObj) LookUpObj.disabled=true;
		}
		var obj=document.getElementById("SelectBatches");
		if (obj) {
			obj.disabled=true;
			obj.onclick = {};
		}
	}

	if (TypeObj && (TypeObj.value=="R") && ORideobj){
		if (packed && packed.value!="N") {
			ORideobj.onclick=OverridePackClick;
			//OverridePackClick();
		}
	}

	// 59004
	if (TypeObj && (TypeObj.value=="I")) {
		var IVTypeObj=document.getElementById("RouteIVType");
		DisableEl("RouteAdmin");
		if (IVTypeObj && (IVTypeObj.value!="P")) {
			var ExDateObj=document.getElementById("OEOREDateExecuted");
			var ExTimeObj=document.getElementById("OEORETimeExecuted");
			var PrevDateObj=document.getElementById("OEOREPrevAdminEndDate");
			var PrevTimeObj=document.getElementById("OEOREPrevAdminEndTime");
			if (ExDateObj && ExTimeObj && PrevDateObj && PrevTimeObj){
				//Log 59854 PeterC 18/07/06
				if(IVTypeObj.value!="C") {
					//Log 60963 PeterC 19/09/06
					//if (PrevDateObj.value!="") { ExDateObj.value=PrevDateObj.value; }
					//if (PrevTimeObj.value!="") { ExTimeObj.value=PrevTimeObj.value; }
				}
				if (PrevDateObj.value=="" && PrevTimeObj.value=="") {
					var OEORIDateObj=document.getElementById("OrdStartDate");
					var OEORITimeObj=document.getElementById("OrdStartTime");
					//Log 59854 PeterC 18/07/06
					if(IVTypeObj.value!="C") {
						//Log 60963 PeterC 19/09/06
						//if (OEORIDateObj) ExDateObj.value=OEORIDateObj.value;
						//if (OEORITimeObj) ExTimeObj.value=OEORITimeObj.value;
					}
				}
			}
		}
		//makeRequired("OEOREExEnDate");
		//makeRequired("OEOREExEnTime");
	} else {
		DisableEl("OEOREExVol");
		DisableEl("OEOREExEnDate");
		DisableEl("OEOREExEnTime");
		var Obj=document.getElementById("OEOREExEnDate");
		if (Obj) Obj.value="";
		var Obj=document.getElementById("OEOREExEnTime");
		if (Obj) Obj.value="";
	}

	//Log 59854 19/07/06
	var IFObj=document.getElementById("IsFirst");
	var PBVObj=document.getElementById("OEOREPrevBagVolume");
	if((IFObj)&&(IFObj.value!="")&&(PBVObj)) PrevBagField(IFObj.value);

	//Log 59854 PeterC 08/08/06
	var IVTypeObj=document.getElementById("RouteIVType");
	var TypeObj=document.getElementById("OrdType");
	if ((TypeObj && (TypeObj.value!="I")) || (IVTypeObj && (IVTypeObj.value!="C"))) {
		makeRequired("CTPCPDesc");
		makeRequired("STATDesc");
	}

	//Log 60136 PeterC 26/07/06
	var tbl = document.getElementById("tOEOrdExec_RecipeList");
	if (tbl) {
		var HSBObj=document.getElementById("OEOREStockBatches");
		if((HSBObj)&&(HSBObj.value!="")) {
			var HSBArry=HSBObj.value.split(",")
			if (document.getElementById("LocationList")) {var Loc=document.getElementById("LocationList").value} else {var Loc=""}
			if (Loc!="") var LocArray=Loc.split(",")
			for (var i=0;i<tbl.rows.length;i++) {
				var obj=document.getElementById("Batchz"+i);
				var obj1=document.getElementById("lt2248iBatchz"+i);
				if (obj) {
					obj.value=HSBArry[i-1].replace(" ","");
					obj.disabled=true;
					if(obj1) obj1.style.visibility = "hidden";
					//// 60747
					var obj2=document.getElementById("Locationz"+i);
					if(obj2) {
						var obj3=document.getElementById("lt2248iLocationz"+i);
						if(obj3) obj3.style.visibility = "hidden";
						if (LocArray[i-1]!="") {
							obj2.value = LocArray[i-1];
							obj2.disabled=true;
						}
					}
				}
			}
			HSBObj.value="";
		}
		//log 63089 disable Alternate Dispensing. Dept. and Batch No. if creating mixtures from batches of multiple items
		if (HSBObj) HSBObj.disabled=true;
		var HSBLookupObj=document.getElementById("ld489iOEOREStockBatches");
		if (HSBLookupObj) HSBLookupObj.style.visibility = "hidden";
		var AltRecObj=document.getElementById("OEOREAltRecLocDR");
		if (AltRecObj) {
			AltRecObj.value="";
			AltRecObj.disabled=true;
		}
		var AltRecLookupObj=document.getElementById("ld489iOEOREAltRecLocDR");
		if (AltRecLookupObj) AltRecLookupObj.style.visibility = "hidden";
	}

	//Log 59854 PeterC 08/08/06
	var EndDateObj=document.getElementById("OEOREExEnDate");
	if(EndDateObj) EndDateObj.onblur=ContIVEndDateHandler;

	var OTObj=document.getElementById("OrdType");
	//Log 61048 PeterC 21/09/06
	if((OTObj)&&(OTObj.value!="")) {
		var OrdType=OTObj.value;
		if((OrdType!="R")&&(OrdType!="I")) {
			var CTUObj=document.getElementById("CTUOMDesc");
			if(CTUObj) CTUObj.value="";
			DisableEl("CTUOMDesc");
		}
	}
}

function PrevBagField(Status){
	var PBVObj=document.getElementById("OEOREPrevBagVolume");
	var execStat=document.getElementById("OEOREOrderStatusDR");
	if(Status=="Y") DisableField("OEOREPrevBagVolume");
	if((Status=="N")&&(execStat)&&(execStat.value=="")) EnableMandatoryField("OEOREPrevBagVolume");
	return;
}

function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = true;
		if (lbl) lbl = lbl.className = "";
	}
}

function DisableEl(str){
	var Obj=document.getElementById(str);
	var lObj=document.getElementById("ld489i"+str);
	var cObj=document.getElementById("c"+str);
	if (Obj) Obj.disabled=true;
	if (lObj) lObj.disabled=true;
	if (cObj) cObj.disabled=true;
	if (cObj) cObj.className="";
	return;
}

function makeRequired(str){
	var Obj=document.getElementById(str);
	var cObj=document.getElementById("c"+str);
	if (Obj) Obj.className="clsRequired";
	if (cObj) cObj.className="clsRequired";
	return;
}



// JD 59002
function OverridePackClick(){

	var ORideobj=document.getElementById("PackOverride");
	var hidORideobj=document.getElementById("overridepack");

	var AltLocObj=document.getElementById("OEOREAltRecLocDR");
	var lookupobj=document.getElementById('ld489iOEOREAltRecLocDR');
	var SBObj=document.getElementById("OEOREStockBatches");
	var LookUpObj=document.getElementById("ld489iOEOREStockBatches");
	var HidStock=document.getElementById("HidStockBatches");

	if (ORideobj && ORideobj.checked) {
		if (AltLocObj) AltLocObj.disabled=false;
		if (lookupobj) lookupobj.disabled=false;
		if (LookUpObj) LookUpObj.disabled=false;
		if (SBObj) SBObj.disabled=false;
		if (hidORideobj) hidORideobj.value="1";
	} else if (ORideobj && ORideobj.checked==false) {
		if (AltLocObj) {
			AltLocObj.disabled=true;
			AltLocObj.value="";
		}
		var AltLocIDObj=document.getElementById("OEOREAltRecLocDR1");
		if (AltLocIDObj) AltLocIDObj.value="";
		if (lookupobj) lookupobj.disabled=true;
		if (LookUpObj) LookUpObj.disabled=true;
		if (SBObj) SBObj.disabled=true;
		if (SBObj && defaultbatch) SBObj.value=defaultbatch;
		if (HidStock) HidStock.value=defaultbatchID;
		if (hidORideobj) hidORideobj.value="";
	}
	return;
}

function BatchSelectHandler(str){
	var lu = str.split("^");
	var HBNumObj=document.getElementById("HidStockBatches");
	var HidAdmQty = document.getElementById("HidOEOREStockQty");
	var qty = "";
	if (HidAdmQty) qty=HidAdmQty.value;
	var phyQty=lu[2];
	if (HBNumObj) HBNumObj.value = lu[1] + "," + qty;
	// check physical stock available for execution when batch number selected	
	var NegStk = document.getElementById("NegStk");
	if ((NegStk && NegStk.value!="Y") && (parseInt(phyQty)<parseInt(qty))) {
		alert(t['BatchStock']+" "+lu[0]);
		if (HBNumObj) HBNumObj.value ="";
		var BNumObj=document.getElementById("OEOREStockBatches");
		if (BNumObj) BNumObj.value ="";
	}
}

//log59552 TedT
function SkinTestLookUpHandler(str){
	var canAdmin=document.getElementById("CanAdmin");
	if (canAdmin) canAdmin.value=(str.split("^"))[2];
}

//log59552 TedT
function SkinTestOnBlur(){
	if(this.value==""){
		var canAdmin=document.getElementById("canAdmin");
		if(canAdmin) canAdmin.value="";
	}
}

//Log 60136 PeterC 26/07/06
function BatchLookUp(str) {
	//alert(str);

	var rowidx=lu_obj.id.replace('Batchz','');
	var lu = str.split("^");
	var obj=document.getElementById("Batchz"+rowidx);
	if (obj) obj.value = lu[1];
	var obj=document.getElementById("BatchIDz"+rowidx);
	if (obj) obj.value = lu[0];
}

//// 60747
function ListRecLocLookUpHandler(str) {
	var rowidx=lu_obj.id.replace('Locationz','');

	var BatchObj=document.getElementById("Batchz"+rowidx);
	if (BatchObj) BatchObj.value="";
	var lu = str.split("^");
	var IDObj=document.getElementById("LocIDz"+rowidx);
	if (IDObj) IDObj.value=lu[2];

	return true;
}

//log61355 TedT
function STATDescLookUpHandler(str) {
	var StatCanAdmin=document.getElementById("StatCanAdmin");
	var strArr=str.split("^");
	if (StatCanAdmin) StatCanAdmin.value=strArr[3];
	ContIVLookUpHandler(str);
}

function ContIVLookUpHandler(str) {
	//Log 59854 PeterC 08/08/06
	var IVTypeObj=document.getElementById("RouteIVType");
	var EndDateObj=document.getElementById("OEOREExEnDate");
	var EndTimeObj=document.getElementById("OEOREExEnTime");
	var HDObj=document.getElementById("hidCurDate");
	var HTObj=document.getElementById("hidCurTime");
	
	if(IVTypeObj && (IVTypeObj.value=="C")) {
		makeRequired("STATDesc");
		makeRequired("CTPCPDesc");
		if(EndDateObj&&(EndDateObj.value=="")) EndDateObj.value=HDObj.value;
		if(EndTimeObj&&(EndTimeObj.value=="")) EndTimeObj.value=HTObj.value;
	}	
}

function ContIVEndDateHandler(str) {
	//Log 59854 PeterC 08/08/06
	var IVTypeObj=document.getElementById("RouteIVType");
	var EndDateObj=document.getElementById("OEOREExEnDate");
	var EndTimeObj=document.getElementById("OEOREExEnTime");
	var HDObj=document.getElementById("hidCurDate");
	var HTObj=document.getElementById("hidCurTime");

	if(IVTypeObj && (IVTypeObj.value=="C") && (EndDateObj) && (EndDateObj.value!="")) {
		makeRequired("STATDesc");
		makeRequired("CTPCPDesc");
		if(EndDateObj&&(EndDateObj.value=="")) EndDateObj.value=HDObj.value;
		if(EndTimeObj&&(EndTimeObj.value=="")) EndTimeObj.value=HTObj.value;
	}	
}

// Need some var's to revert if user selects override but then changes mind - 59002
var defaultbatchID=document.getElementById("HidStockBatches").value;
var defaultbatch=document.getElementById("OEOREStockBatches");
if (defaultbatch) defaultbatch=defaultbatch.value;

document.body.onload=BodyOnLoadHandler;
