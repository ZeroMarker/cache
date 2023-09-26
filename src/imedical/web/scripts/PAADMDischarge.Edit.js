// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

if (document.getElementById("SepRefEntered")) {
	document.getElementById("SepRefEntered").tkItemPopulate = 1;
}
var curCPType, ordStrsInd; //ypz
function BodyOnloadHandler(e) {


	var objDisConDesc = document.getElementById('DISCONDesc');
	if (objDisConDesc) {
		document.getElementById("PAPERDeceasedDate").style.visibility = "hidden";
		document.getElementById("cPAPERDeceasedDate").style.visibility = "hidden";
		document.getElementById("ld1081iPAPERDeceasedDate").style.visibility = "hidden";
		document.getElementById("PAPERDeceasedTime").style.visibility = "hidden";
		document.getElementById("cPAPERDeceasedTime").style.visibility = "hidden";
		objDisConDesc.addEventListener("DOMAttrModified", ForobjDisConDesc, false);

		//objDisConDesc.onpropertychange = ForobjDisConDesc;
	}


	var obj
	if (window.opener) {
		if (window.opener.document.getElementById("PAADMDischgDate") && window.document.getElementById("PAADMDischgDate").value == "") {
			if (window.opener.document.getElementById("PAADMDischgDate").tagName != "LABEL") {
				window.document.getElementById("PAADMDischgDate").value = window.opener.document.getElementById("PAADMDischgDate").value;
			}
		}
		if (window.opener.document.getElementById("PAADMDischgTime") && window.document.getElementById("PAADMDischgTime").value == "") {
			if (window.opener.document.getElementById("PAADMDischgTime").tagName != "LABEL") {
				window.document.getElementById("PAADMDischgTime").value = window.opener.document.getElementById("PAADMDischgTime").value;
			}
		}
	}

	//ypz begin
	var objc, encmeth;
	objc = document.getElementById("GetUserType");
	if (objc) {
		encmeth = objc.value
	} else {
		encmeth = ''
	};
	var userId = session['LOGON.USERID'];
	curCPType = cspRunServerMethod(encmeth, userId);
	if (curCPType == "NURSE") {
		AlertAbnormalOrder();
	}


	//alert(curCPType)
	var objDischDate = document.getElementById("PAADMDischgDate");
	var objDischTime = document.getElementById("PAADMDischgTime");
	var objEstimDischDate = document.getElementById("PAADMEstimDischargeDate");
	var objEstimDischTime = document.getElementById("PAADMEstimDischargeTime");
	var objRFDDesc = document.getElementById("RFDDesc"); // + wxl 090305 begin
	var objRFDRowId = document.getElementById("RFDRowId");
	var objbtnRevFinDisch = document.getElementById("brnRevFinDisch");
	var objUpdate = document.getElementById('Update');
	var obj = document.getElementById('PAADMVisitStatusCode');
	if (obj.value != "D") {
		if (objbtnRevFinDisch) objbtnRevFinDisch.style.visibility = "hidden";
	} else {
		if (objUpdate) objUpdate.style.visibility = "hidden";
	}
	if (objbtnRevFinDisch) objbtnRevFinDisch.onclick = RevFinDischClick; // + wxl 090305 end
	/*if (objDischDate) {
	    //objDischDate.onblur=CheckDateTime;
	    objDischDate.onchange=CheckDateTime;
	}
	if (objDischTime) {
	    objDischTime.onblur=CheckDateTime;objDischTime.onchange=CheckDateTime;
	}
	*/
	switch (curCPType) {
		case "DOCTOR":
			//alert("Doctor");
			if (objDischDate) {
				objDischDate.disabled = true;
			}
			if (objDischTime) {
				objDischTime.disabled = true;
			}
			document.onkeydown = websys_sckey;
			document.onkeypress = websys_sckeypress;
			break;
		case "NURSE":
			//alert("Nurse");
			if (objEstimDischDate) {
				objEstimDischDate.disabled = true;
			}
			if (objEstimDischTime) {
				objEstimDischTime.disabled = true;
				if (objEstimDischTime.value == "") {
					if (objDischDate) {
						objDischDate.disabled = true;
					}
					if (objDischTime) {
						objDischTime.disabled = true;
					}
					if (objUpdate) {
						objUpdate.style.visibility = "hidden";
					}
					alert(t['alert:MedDischFirst']);
					return 0;
				}
			}
			//lgl+ 关于费用的各种判断规则
			var obj = document.getElementById("EpisodeID");
			var EpisodeID = obj.value
			var ret = tkMakeServerCall("web.DHCCAbFeeCheck", "GetCheckFeeFinal", EpisodeID, "")
			if (ret != "") {
				if (objDischDate) {
					objDischDate.disabled = true;
				}
				if (objDischTime) {
					objDischTime.disabled = true;
				}
				alert(ret);
				return 0;

			}
			break;
		default:
			if (objEstimDischDate) {
				objEstimDischDate.disabled = true;
			}
			if (objEstimDischTime) {
				objEstimDischTime.disabled = true;
			}
			if (objDischDate) {
				objDischDate.disabled = true;
			}
			if (objDischTime) {
				objDischTime.disabled = true;
			}
			//alert(curCPType);
			return 0;
	}
	objc = document.getElementById("GetAbnormalOrder");
	if (objc) {
		encmeth = objc.value
	} else {
		encmeth = ''
	};
	objc = document.getElementById("EpisodeID");
	if (objc) {
		var EpisodeID = objc.value
	} else {
		return 0
	};
	var objGetAdmDateTime = document.getElementById("GetAdmDateTime"); //wxl 090213 begin
	if (objGetAdmDateTime) {
		var AdmDateTime = cspRunServerMethod(objGetAdmDateTime.value, EpisodeID);
		tmpList = AdmDateTime.split("^");
		if (tmpList.length > 1) {
			if (tmpList[4] == "D") {

				objDischDate.value = tmpList[5];
				objDischTime.value = tmpList[6];
				objDischDate.disabled = true;
				objDischTime.disabled = true;
			}
		}
	} //wxl 090213 end
	//	var abnormalOrder=cspRunServerMethod(encmeth,EpisodeID,userId);
	//	var tmpList=abnormalOrder.split("^");
	//	//alert(abnormalOrder)
	//	if (tmpList.length<34){
	//		if (objDischDate) {objDischDate.disabled=true;}
	//		if (objDischTime) {objDischTime.disabled=true;}
	//		ordStrsInd=0; //not discontinue today long order
	//	}
	//	else
	//	{
	//		if ((tmpList[33])){//diag
	//			if (tmpList[33]!="0"){
	//				alert(tmpList[33])
	//				if (objEstimDischDate) {objEstimDischDate.disabled=true;}
	//				if (objEstimDischTime) {objEstimDischTime.disabled=true;}
	//				if (objDischDate) {objDischDate.disabled=true;}
	//				if (objDischTime) {objDischTime.disabled=true;}
	//		   		return 0;
	//			}
	//		}
	//	    ordStrsInd=tmpList[30];
	//		if (tmpList[0]=="0") ordStrsInd=0;
	//		var alertFlag=false;  //ypz 081022
	//		for (var i=0;i<25;i++)
	//		{
	//			//if ((tmpList[i]!="0")&&((i<1)||(curCPType=="NURSE"))) {
	//			if (tmpList[i]!="0") {
	//			    alert(tmpList[i]);
	//			    alertFlag=true;  //ypz 081022
	//			}
	//		}
	//		if ((tmpList[31])&&(curCPType=="NURSE")&&(alertFlag)){//can discharge    //ypz 081022 add
	//			if (tmpList[31]!="Y"){
	//				if (objDischDate) {objDischDate.value="";objDischDate.disabled=true;}//objDischDate.disabled=true; // wxl 090213
	//				if (objDischTime) {objDischTime.value="";objDischTime.disabled=true;}//objDischTime.disabled=true;
	//				return 0;
	//			}
	//		}
	//		var objGetCurDateTime=document.getElementById("GetCurDateTime");
	//		if (objGetCurDateTime){
	//			var curDateTime=cspRunServerMethod(objGetCurDateTime.value);
	//			tmpList=curDateTime.split("^");
	//			if (tmpList.length>1){
	//				if (curCPType=="DOCTOR"){
	//					if ((objEstimDischDate)&&(objEstimDischTime)){
	//						if((objEstimDischDate.value=="")&&(objEstimDischTime.value=="")){
	//							
	//							objEstimDischDate.value=tmpList[0];
	//							objEstimDischTime.value=tmpList[1];
	//						}
	//					}
	//				}
	//				if (curCPType=="NURSE"){
	//					if ((objDischDate)&&(objDischTime)){
	//						if((objDischDate.value=="")&&(objDischTime.value=="")){
	//							objDischDate.value=tmpList[0];
	//							objDischTime.value=tmpList[1];
	//						}
	//					}
	//				}
	//			}
	//		}
	//	}
	var objGetCurDateTime = document.getElementById("GetCurDateTime");
	if (objGetCurDateTime) {
		var curDateTime = cspRunServerMethod(objGetCurDateTime.value);
		tmpList = curDateTime.split("^");
		if (tmpList.length > 1) {
			if (curCPType == "DOCTOR") {
				if ((objEstimDischDate) && (objEstimDischTime)) {
					if ((objEstimDischDate.value == "") && (objEstimDischTime.value == "")) {

						objEstimDischDate.value = tmpList[0];
						objEstimDischTime.value = tmpList[1];
					}
				}
			}
			if (curCPType == "NURSE") {
				if ((objDischDate) && (objDischTime)) {
					if ((objDischDate.value == "") && (objDischTime.value == "")) {
						objDischDate.value = tmpList[0];
						objDischTime.value = tmpList[1];
					}
				}
			}
		}
	}
	//ypz end
	objc = document.getElementById("GetReaForRevFinDisch"); // + wxl 090305 begin
	if (objc) {
		encmeth = objc.value
		var ReaForRevFinDisch = cspRunServerMethod(encmeth, EpisodeID);
		var RFDStr = ReaForRevFinDisch.split("^");
		if (objRFDDesc) objRFDDesc.value = RFDStr[0];
		if (objRFDRowId) objRFDRowId.value = RFDStr[1];
	} // + wxl 090305 end
	obj = document.getElementById('OpenWordDoc');
	if (obj) obj.onclick = UpdateAndOpenWordDoc;

	obj = document.getElementById('Update');
	if (obj) obj.onclick = UpdateHandler;
	if (tsc['Update']) websys_sckeys[tsc['Update']] = UpdateHandler;

	obj = document.getElementById('MRADMMedicallyFit');
	if (obj) obj.onclick = ResetDelayDischarge;

	obj = document.getElementById('MRCIDDesc');
	if (obj) obj.onchange = PrimaryDiagnChange;

	obj = document.getElementById('PAADMDischgDate');
	// ab  - needed to set cache date to pass to brokers
	if (obj) obj.onblur = PAADMDischgDateChange;
	//PAADMDischgDateChange();

	if ((obj) && (obj.value == "")) {
		DisableField('DiscontAll');
	}

	setCheckBoxFlag();

	// ab 13.09.04 - 44999
	var obj = document.getElementById("PAADMType");
	if ((obj) && (obj.value == "E")) {
		alert(t["NotCorrectAdmType"]);
		DisableAllFields();
		return false;
	}

	//var obj=document.getElementById('ContactPerson')
	//if (obj) obj.onclick = checkContactDetails;

	var objDeleteSepRef = document.getElementById('DeleteSepRef'); //LOG 24187 BC 10-5-2002
	if (objDeleteSepRef) objDeleteSepRef.onclick = SepRefDeleteClickHandler; //LOG 24187 BC 10-5-2002

	var objBold = document.getElementById('BoldLinks');
	if (objBold) {
		var BoldLink = objBold.value.split("^");
		obj = document.getElementById('MedFitHist');
		if ((obj) && (BoldLink[0] == "1")) obj.style.fontWeight = "bold";
		obj = document.getElementById("EstDischargeHistory");
		if ((obj) && (BoldLink[1] == "1")) obj.style.fontWeight = "bold";
		//md 07/05/2003
		obj = document.getElementById("SNAPScreen");
		if ((obj) && (BoldLink[6] == "1")) obj.style.fontWeight = "bold";
		obj = document.getElementById("ContractCare");
		if ((obj) && (BoldLink[7] == "1")) obj.style.fontWeight = "bold";
		// cjb 04/05/2004 43722
		obj = document.getElementById("PalliativeCare");
		if ((obj) && (BoldLink[14] == "1")) obj.style.fontWeight = "bold";
	}

	var objmradmBold = document.getElementById('mradmBoldLinks');
	if (objmradmBold) {
		var mradmBoldLink = objmradmBold.value.split("^");
		var obj = document.getElementById('PsychDetails');
		if ((obj) && (mradmBoldLink[0] == "1")) obj.style.fontWeight = "bold";
	}

	var objBoldPA = document.getElementById('BoldLinksPAPerson');
	if (objBoldPA) {
		var BoldLinkPA = objBoldPA.value.split("^");
		var obj = document.getElementById('ContactPerson');
		if ((obj) && (BoldLinkPA[0] == "1")) obj.style.fontWeight = "bold";
		obj = document.getElementById('OtherAddresses');
		if ((obj) && (BoldLinkPA[1] == "1")) obj.style.fontWeight = "bold";
		//obj=document.getElementById('Alias');
		//if ((obj) && (BoldLinkPA[2]=="1")) obj.style.fontWeight="bold";
		//obj=document.getElementById('PAAlert');
		//if ((obj) && (BoldLinkPA[3]=="1")) obj.style.fontWeight="bold";
		//obj=document.getElementById('FamDocHist');
		//if ((obj) && (BoldLinkPA[4]=="1")) obj.style.fontWeight="bold";
		//obj=document.getElementById('MRNumber');
		//if ((obj) && (BoldLinkPA[5]=="1")) obj.style.fontWeight="bold";
		//obj=document.getElementById('Allergies');
		//if ((obj) && (BoldLinkPA[6]=="1")) obj.style.fontWeight="bold";
		/*	LOG 23929 BC 29-APR-2002 Adding a family Dentist*/
		//obj=document.getElementById('FamDentHist');
		//if ((obj) && (BoldLinkPA[7]=="1")) obj.style.fontWeight="bold";

	}
	//md 14/03/2003
	//var obj=document.getElementById("BedRequstHours");
	//var objstat=document.getElementById("PAADMVisitStatusCode");
	//var objpaadmtype=document.getElementById("PAADMType");
	//if ((obj)&&(obj.value!="")&&(objstat)&&(objstat.value=="A")&&(objpaadmtype)&&(objpaadmtype.value=="I"))
	//{
	//var objesdisdate=document.getElementById("PAADMEstimDischargeDate");
	//var objesdistime=document.getElementById("PAADMEstimDischargeTime");
	//var objeddmissing=document.getElementById("eddmissing");
	//if ((objesdisdate)&&(objesdisdate.value!="")) {PAADMEstimDischargeDateHandler(e);}
	//if (objesdisdate) objesdisdate.onblur=PAADMEstimDischargeDateHandler;
	//if ((objesdistime)&&(objesdistime.value!="")) {PAADMEstimDischargeTimeHandler(e);}
	//if (objesdistime) objesdistime.onblur=PAADMEstimDischargeTimeHandler;
	//}
	//md 14/03/2003
	//md 13.08.2004
	//md 18.04.2005 51518
	// ab 2.06.05 51518 - disable in custom script
	//var objstat=document.getElementById("PAADMVisitStatusCode");
	//var objPalCarePatD=document.getElementById("PAADM2PalliativeCarePatDays");
	//if  (objPalCarePatD) {PalliativeCarePatDays(); }
	//18.04.2005
	var ContrCareObj = document.getElementById("ContractCare");
	if (ContrCareObj) {
		ContrCareObj.onclick = ContrCareClickHandler;
	}

	//md 13.08.2004
	setLinks();
	// cjb 09/02/2005 49232 - moved from QH custom script
	CheckForMentalHealth();

	setCrossValParams();
	setCrossValFields();
	CrossValFieldLvl();

	var FUNDARObj = document.getElementById("FUNDARDesc");
	if (FUNDARObj) FUNDARObj.onblur = FUNDARBlurHandler;
	var obj = document.getElementById("CTDSPDesc");
	if (obj) obj.onblur = CTDSPDescBlurHandler;

	return;
}


function AlertAbnormalOrder() {
	obj = document.getElementById("EpisodeID");
	var EpisodeID = obj ? obj.value : ""
	var retStr = tkMakeServerCall("Nur.DHCADTDischarge", "getAbnormalOrder", EpisodeID, "Disch")
	if (retStr == "") {
		document.onkeydown = websys_sckey;
		document.onkeypress = websys_sckeypress;
		return;
	}
	var retStrArrat = retStr.split("^");
	var ifCanTrans = retStrArrat[0];
	if (ifCanTrans != "Y") {
		document.getElementById("Update").disabled = true;
	} else {
		document.onkeydown = websys_sckey;
		document.onkeypress = websys_sckeypress;
	}
	for (var i = 1; i < retStrArrat.length; i++) {
		var alertStr = retStrArrat[i];
		alert(alertStr);
	}
}

function UpdateHandler() {

	if (document.getElementById('PAPERDeceasedDate') != "") {
		if (IsValidDate(document.getElementById('PAPERDeceasedDate')) != 1) {
			alert("死亡日期格式不正确")
			return;
		}
	}

	if (document.getElementById('PAPERDeceasedTime') != "") {
		if (IsValidTime(document.getElementById('PAPERDeceasedTime')) != 1) {
			alert("时间格式不正确")
			return;
		}
	}

	var obj = document.getElementById('PAADMType');
	if (obj.value == "E") {
		alert(t['NotCorrectAdmType']);
		return false;
	}
	var obj = document.getElementById('PAADMVisitStatusCode');
	if (obj.value == "C") {
		alert(t['NotCurrentPat']);
		return false;
	}
	//alert(ordStrsInd);

	UpdateAllSepRefs();
	// when an error message occurs, the value of crossval is set to 2, not allowing the update
	var objCV = document.getElementById("CrossVal");
	if (objCV) objCV.value = 1;
	setCrossValParams();
	CrossVal(0);
	// if validation fails, then dont update
	var objCV = document.getElementById("CrossVal");
	if ((objCV) && (objCV.value == 2)) return false;


	// 24/09/02 Log#28003 HP: Check that financial field is ticked when system parameter (AllowDisWOFin) is not
	var objFD = document.getElementById('PAADMBillFlag');
	var dis = document.getElementById('PAADMDischgDate');
	if ((dis) && (dis.value != "")) {
		if ((objFD) && (objFD.checked == false)) {
			var objAllowFD = document.getElementById('AllowDisWOFin');
			if ((objAllowFD) && (objAllowFD.value != "Y")) {
				alert(t['FinDisMandatory']);
				objFD.focus();
				return false;
			}
		}
	}

	// ab 16.12.04 - 48358 - mandatory status checkbox in code table
	if (!CheckMandatoryField("TRDDesc")) return false;
	var obj = document.getElementById("TRDDesc");
	if ((obj) && (obj.disabled)) obj.disabled = false;

	var obj = document.getElementById("PAADMBillFlag");
	if ((obj) && (obj.disabled)) obj.disabled = false;

	//md 14.03.2003
	//if (!CheckMandatoryFields()) { return }

	//ypz begin
	var userId = session['LOGON.USERID'];
	var EpisodeID = document.getElementById('EpisodeID').value;
	var objDisConDesc = document.getElementById('DISCONDesc');
	var disConDesc = "";
	if (objDisConDesc) disConDesc = objDisConDesc.value;

	var objc, encmeth, retStr;
	objc = document.getElementById("DisconLongOrder");
	if (objc) {
		encmeth = objc.value
	} else {
		encmeth = ''
	};
	retStr = cspRunServerMethod(encmeth, ordStrsInd, EpisodeID, curCPType, userId, "", disConDesc);
	//alert("retStr="+retStr)
	if (retStr != 0) alert(t['alert:DischOrdFail']);

	if (curCPType == "NURSE") {
		//if (! CheckDateTime()) return;
		//var objDischargeBaby=document.getElementById("DischargeBaby");
		//if (objDischargeBaby) {
		//    retStr=cspRunServerMethod(objDischargeBaby.value,EpisodeID,userId);
		//    if (retStr!=0) alert(retStr)
		//}
		var objPAAdmDischarge = document.getElementById("PAAdmDischarge");
		var objUpdateDHCADMStatus = document.getElementById("UpdateDHCADMStatus"); //wxl 090213
		if (objPAAdmDischarge) {
			var dischgDate = "",
				dischgTime = "",
				deceasedDate = "",
				deceasedTime = "";
			var objPAADMDischgDate = document.getElementById("PAADMDischgDate")
			if (objPAADMDischgDate) dischgDate = objPAADMDischgDate.value;
			var objPAADMDischgTime = document.getElementById("PAADMDischgTime")
			if (objPAADMDischgTime) dischgTime = objPAADMDischgTime.value;

			var objDeceasedDate = document.getElementById("PAPERDeceasedDate")
			if (objDeceasedDate) deceasedDate = objDeceasedDate.value;

			var objDeceasedTime = document.getElementById("PAPERDeceasedTime")
			if (objDeceasedTime) deceasedTime = objDeceasedTime.value;

			if (objUpdateDHCADMStatus) //wxl 090213
			{
				ret = cspRunServerMethod(objUpdateDHCADMStatus.value, EpisodeID, "D", userId, dischgDate, dischgTime);
				if (ret != 0) {
					alert(ret);
					return;
				}
			}
			//retStr=cspRunServerMethod(objPAAdmDischarge.value,EpisodeID,userId,"","",dischgDate,dischgTime,disConDesc,deceasedDate,deceasedTime);
			var userpassword = document.getElementById("PIN")
			if (userpassword) userpassword = userpassword.value;
			//alert(dischgDate+"@"+dischgTime+"@"+disConDesc+"@"+deceasedDate+"@"+deceasedTime)

			retStr = cspRunServerMethod(objPAAdmDischarge.value, EpisodeID, userId, "", "", dischgDate, dischgTime, disConDesc, deceasedDate, deceasedTime, userpassword);

			if (retStr != "0") {
				alert(retStr);
				return;
			}
			var ifPrintWardDischarge = document.getElementById("ifPrintWardDischarge");
			if ((ifPrintWardDischarge) && (ifPrintWardDischarge.value == "Y")) PrintWardDischarge();
			var lnk = "epr.default.csp";
			window.location = lnk;
		}
	}

	//ypz end

	if (curCPType == "DOCTOR") {
		var objPAAdmDischarge = document.getElementById("PAAdmDischarge");
		if (objPAAdmDischarge) {
			var dischgDate = "",
				dischgTime = "",
				deceasedDate = "",
				deceasedTime = "",
				estimDischTime = "",
				estimDischTime = "";
			var objPAADMDischgDate = document.getElementById("PAADMDischgDate")
			if (objPAADMDischgDate) dischgDate = objPAADMDischgDate.value;
			var objPAADMDischgTime = document.getElementById("PAADMDischgTime")
			if (objPAADMDischgTime) dischgTime = objPAADMDischgTime.value;
			var objEstimDischDate = document.getElementById("PAADMEstimDischargeDate");
			if (objEstimDischDate) estimDischDate = objEstimDischDate.value;
			var objEstimDischTime = document.getElementById("PAADMEstimDischargeTime");
			if (objEstimDischTime) estimDischTime = objEstimDischTime.value;
			var objDeceasedDate = document.getElementById("PAPERDeceasedDate")
			if (objDeceasedDate) deceasedDate = objDeceasedDate.value;
			var objDeceasedTime = document.getElementById("PAPERDeceasedTime")
			if (objDeceasedTime) deceasedTime = objDeceasedTime.value;
			var userpassword = document.getElementById("PIN")
			if (userpassword) userpassword = userpassword.value;
			retStr = cspRunServerMethod(objPAAdmDischarge.value, EpisodeID, userId, estimDischDate, estimDischTime, dischgDate, dischgTime, disConDesc, deceasedDate, deceasedTime, userpassword);
			if (retStr != "0") {
				alert(retStr);
				return;
			}
			//websys.close.csp
			//var lnk="epr.default.csp";
			//window.location=lnk;
		}
		return Update_click();
	}
}

/* //ypz begin
function CheckDateTime()
{
    var objDischDate=document.getElementById("PAADMDischgDate");
    var objDischTime=document.getElementById("PAADMDischgTime");
	var	objEstimDischDate=document.getElementById("PAADMEstimDischargeDate");
	var	objEstimDischTime=document.getElementById("PAADMEstimDischargeTime");

	//alert(GetDateTime(objDischDate.value,"")+" "+GetDateTime(objEstimDischDate.value,""))
	if (GetDateTime(objDischDate.value,"")<GetDateTime(objEstimDischDate.value,"")) {
		alert(t['alert:dateTimeEarly']);
		websys_setfocus(objDischDate);
		return false;
	}
	//alert(GetDateTime(objDischDate.value,objDischTime.value)+"/"+GetDateTime(objEstimDischDate.value,objEstimDischTime.value))
	if (GetDateTime(objDischDate.value,objDischTime.value)<GetDateTime(objEstimDischDate.value,objEstimDischTime.value)) {
		alert(t['alert:dateTimeEarly']);
		websys_setfocus(objDischTime);
		return false;
	}
	return true;

}

function GetDateTime(dateStr,timeStr)
{
	var tmpList=dateStr.split("/");
	if (tmpList.length<3) return 0;
	var retVal=tmpList[2]*1000+tmpList[1]*50+tmpList[0];
	tmpList=timeStr.split(":");
	if (tmpList.length>1){
	    var timeVal=(tmpList[0]*3600)+(tmpList[1]*60);
	    if (tmpList[2]) timeVal=timeVal+tmpList[2]*1;
	    retVal=retVal+(timeVal/100000);
	}
	return retVal
}
//ypz end
*/

function CheckMandatoryField(field) {
	var obj = document.getElementById(field);
	var objC = document.getElementById("c" + field);
	if ((obj) && (objC) && (objC.className == "clsRequired") && (obj.value == "")) {
		alert(t[field] + " " + t["XMISSING"]);
		return false;
	}
	return true;
}

function ResetDelayDischarge(e) {
	var obj = websys_getSrcElement(e);

	if ((obj) && (obj.checked)) {
		EnableField('READELDesc');

	} else {
		DisableField('READELDesc');

	}
}

function setCheckBoxFlag() {
	var str = new Array()
	var IsOnForm = document.getElementById('HiddenCheckbox')
	var obj = document.getElementById('PAADMBillFlag')
	if (obj) {
		str[0] = "Y"
	}

	IsOnForm.value = str.join("^")

}

function PAADMDischgDateChange() {
	// ab 11.05.04 - 41904
	var pobj = document.getElementById('PAADMDischgDate');
	var objCT = document.getElementById("CTDate");
	if ((pobj) && (objCT)) {
		if (pobj.value != "") {
			objCT.value = DateStringTo$H(pobj.value);
			//EnableField('DiscontAll');
		} else {
			objCT.value = objCT.defaultValue;
			//DisableField('DiscontAll');
		}
	}
}

function PrimaryDiagnChange() {
	pobj = document.getElementById('MRCIDDesc');
	if ((pobj) && (pobj.value == "")) {
		obj = document.getElementById('MRCIDRowId');
		if (obj) obj.value = "";
	}
}

function PrimaryDiagnLookupSelect(str) {
	var lu = str.split("^");
	//alert(str);
	var obj = document.getElementById('MRCIDDesc');
	if (obj) obj.value = lu[0];
	var obj = document.getElementById('MRCIDRowId');
	if (obj) obj.value = lu[1];
}

function UpdateAllSepRefs() {
	var arrItems = new Array();
	var lst = document.getElementById("SepRefEntered");
	if (lst) {
		for (var j = 0; j < lst.options.length; j++) {
			//FCH: 14-Oct-2002: 
			//Added text value of options to string.
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;;
		}
		var el = document.getElementById("SepRefDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
		//alert(el.value );
	}
}
//LOG 24187 BC 10-5-2002 Separation Referral
function SepRefLookupSelect(txt) {
	//Add an item to SepRefEnetered when an item is selected from
	//the Lookup, then clears the Item text field.
	//alert(txt);
	var adata = txt.split("^");
	//alert("adata="+adata);
	var obj = document.getElementById("SepRefEntered");
	var MaxSepRefobj = document.getElementById("MaxSepRef");
	if (MaxSepRefobj) {
		MaxSepRef = MaxSepRefobj.value;
	} else {
		MaxSepRef = 4;
	}
	if (obj) {
		if (obj.options.length > (MaxSepRef - 1)) {
			alert(t['MaxSepRef']);
			var obj = document.getElementById("SepRefDesc");
			if (obj) obj.value = "";
			return;
		}
		//Need to check if SepRef already exists in the List and alert the user
		for (var i = 0; i < obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2) + adata[1]) {
				alert(t['SameSepRef']);
				var obj = document.getElementById("SepRefDesc") //Textbox with lookup for SepRef
				if (obj) obj.value = "";
				return;
			}
			if ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert(t['SameSepRef']);
				var obj = document.getElementById("SepRefDesc")
				if (obj) obj.value = "";
				return;
			}
			//alert(obj.options[i].value+"****"+adata[1])
		}
	}
	AddItemToList(obj, adata[1], adata[0]);
	var obj = document.getElementById("SepRefDesc")
	if (obj) obj.value = "";
	setCrossValParams();
	//CrossVal();
	//alert("adata="+adata);
}

//
function AddItemToList(list, code, desc) {
	//Add an item to a listbox
	code = String.fromCharCode(2) + code
	list.options[list.options.length] = new Option(desc, code);
}

function SepRefDeleteClickHandler() {
	//Delete items from SepRefEntered listbox when "Delete" button is clicked.
	var obj = document.getElementById("SepRefEntered")
	if (obj)
		RemoveFromList(obj);
	setCrossValParams();
	return false;
}

function RemoveFromList(obj) {
	for (var i = (obj.length - 1); i >= 0; i--) {
		if (obj.options[i].selected)
			obj.options[i] = null;
	}
}

//End LOG 24187

function setLinks() {
	var hidlnkobj = document.getElementById('hiddenLinks');
	if (hidlnkobj) hidlnkobj.value = "0";

	var PAobj = document.getElementById('PatientID');
	if ((PAobj) && (PAobj.value == "")) {

		if (hidlnkobj) hidlnkobj.value = "1";

	}

	// 02.04.03 Log 33832 HP: Disable Palliative Care link - used in QH only
	var PalCareObj = document.getElementById("PalliativeCare");
	if (PalCareObj) {
		PalCareObj.disabled = true;
		PalCareObj.onclick = LinkDisable;
	}
	// 14.05.03 Log 33816 MD: Disable Contract Care link - used in QH only
	// 13.08.2004 md  no longer 44797
	//var ContrCareObj=document.getElementById("ContractCare");
	//if (ContrCareObj) {
	//	ContrCareObj.disabled=true;
	//	ContrCareObj.onclick=LinkDisable;
	//}
	// 16.05.03 Log 32492 MD: Disable SNAP screen  link - used in QH only
	var SNAPObj = document.getElementById("SNAPScreen");
	if (SNAPObj) {
		SNAPObj.disabled = true;
		SNAPObj.onclick = LinkDisable;
	}
}


/*JW moved to websys.Edit.Tools.js - delete post 10/5/04
function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
} */

//JW: should not redirect.
/*function checkContactDetails() { // redirects to NOK edit/list depending on existing contacts
	var url, objBold;
	var objParRef = document.getElementById('PatientID');
	var objPatID = objParRef;
	var objHLinks = document.getElementById('hiddenLinks');
	var objcon = document.getElementById('ContactPerson');

	objBold=document.getElementById('BoldLinksPAPerson');
	if (objBold) var BoldLink = objBold.value.split("^");
	if (BoldLink[0]=="1")
	{
		url="panok.list.csp?PARREF="+objParRef.value+"&PatientID="+objPatID.value+"&hiddenLinks="+objHLinks.value+"&PatientBanner=1";

		websys_lu(url,false,"width=720,height=480,top=20,left=30")
		return false;
	}
	else
	{
		url="websys.default.csp?WEBSYS.TCOMPONENT=PANok.Edit&PARREF="+objParRef.value+"&PAPERFlag=1"+"&PatientID="+objPatID.value+"&hiddenLinks="+objHLinks.value+"&PatientBanner=1&FromLink=1";
		websys_lu(url,false,"width=720,height=480,top=20,left=30")
		return false;
	}
} */

function ContrCareClickHandler() {
	var id = "";
	var epi = document.getElementById('EpisodeID').value;
	var pat = document.getElementById('PatientID').value;
	var admdate = document.getElementById('PAADMAdmDate');
	if (admdate) {
		admd = admdate.value;
	}
	if (!admdate) {
		admd = "_zz";
	}
	var disdate = document.getElementById('PAADMDischgDate');
	if (disdate) {
		disd = disdate.value;
	}
	if (!disdate) {
		disd = "_zz";
	}
	websys_createWindow('paadmcontractcare.csp?%ID=' + id + '&PatientID=' + pat + '&EpisodeID=' + epi + '&PAADMAdmDate=' + admd + '&PAADMDischgDate=' + disd + '&PatientBanner=1', '', "top=30,left=20,width=620,height=420,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");

	return false;
}

function DISCONDescLookupSelect(str) {
	//dummy function for custom
}

function CareTypeLookupSelect(str) {
	setCrossValParams();
	return true;
}

function INTREALookupSelect(str) {
	setCrossValParams();
	return true;
}

function RCCTDescLookupSelect(str) {
	setCrossValParams();
	return true;
}

/*
function SepTypeLookupSelect(str) {
	setCrossValParams();
	CrossValFieldLvl();
	return true;
}*/

function CARAVLLookupSelect(str) {
	setCrossValParams();
	return true;
}

function PFSLookupSelect(str) {
	var lu = str.split("^");
	var obj
	obj = document.getElementById('PFSDesc');
	if (obj) obj.value = lu[0];
	obj = document.getElementById('PFSCode');
	if (obj) obj.value = lu[2];
	PFSCodechangeHandler(null);
	setCrossValParams();
	return true;
}

function FundLookupSelect(str) {
	var lu = str.split("^");
	var obj
	obj = document.getElementById('FUNDARDesc');
	if (obj) obj.value = lu[0];
	obj = document.getElementById('FUNDARCode');
	if (obj) obj.value = lu[2];
	FUNDARCodechangeHandler(null);
	setCrossValParams();
	return true;
}

function FUNDARBlurHandler() {
	var obj = document.getElementById("FUNDARDesc");
	var FundSource = document.getElementById("FUNDARCode");
	if ((obj) && (FundSource) && (obj.value == "")) FundSource.value = "";
	FUNDARCodechangeHandler();
	setCrossValParams();
}

function CTDSPDescBlurHandler() {
	var obj = document.getElementById("CTDSPDesc");
	var objTD = document.getElementById("TRDDesc");
	if ((obj) && (objTD) && (obj.value == "")) labelNormal("TRDDesc");
}

function CONTROLLookupSelect(str) {
	setCrossValParams();
	return true;
}

function CONTRTYPELookupSelect(str) {
	setCrossValParams();
	return true;
}

function DischDestLookupSelect(str) {

}

function SepTypeLookupSelect(str) {
	var lu = str.split("^");
	var obj = document.getElementById("SepCode");
	if (obj) obj.value = lu[2];

	setCrossValParams();
	// ab - 48358 - re-enabled this, we need to run crossval to enable/disable field based on code table
	CrossValFieldLvl();
	//md Log 48927 tab seq lost caused by last line
	var obj1 = document.getElementById("CTDSPDesc");
	if (obj1) websys_nextfocus(obj1.sourceIndex);

	return true;
}

//md 24/06/2003
function ACASLookupSelect(str) {
	setCrossValParams();
	return true;
}
//md 24/06/2003
//md 07/07/2003
function MHLSLookupSelect(str) {
	setCrossValParams();
	return true;
}

//--------------------------------------------------------------- ab 1.08.02 Cross Validation stuff


function CrossVal(skip) {
	// runs the cross validation function through a hidden broker
	var obj = document.getElementById("CrossVal");
	if ((obj) && (obj.onchange)) obj.onchange();
	// dont show the error more than once when tabbing between fields
	//if ((obj.value==2)&&(skip)) return true;
	return true;
}

function CrossValFieldLvl() {
	var objCVFL = document.getElementById("CrossValFieldLvl");
	if (objCVFL) {
		objCVFL.value = 1;
		CrossVal(0);
		objCVFL.value = "";
	}
}


function setCrossValFields() {
	// set the string to pass to the validation function
	obj = document.getElementById('CARETYPDesc');
	if (obj) obj.onblur = setCrossValParams;
	obj = document.getElementById('INTREADesc');
	if (obj) obj.onblur = setCrossValParams;
	obj = document.getElementById('CTDSPDesc');
	if (obj) obj.onblur = setCrossValParams;
	obj = document.getElementById('CARAVLDesc');
	if (obj) obj.onblur = setCrossValParams;
	obj = document.getElementById('PFSDesc');
	if (obj) obj.onblur = setCrossValParams;
	obj = document.getElementById("CONTROLDesc");
	if (obj) obj.onblur = setCrossValParams;
	obj = document.getElementById("FUNDARDesc");
	if (obj) obj.onblur = setCrossValParams;
	obj = document.getElementById('CONTRTYPEDesc');
	if (obj) obj.onblur = setCrossValParams;
	obj = document.getElementById("SepRefDesc");
	if (obj) obj.onblur = setCrossValParams;
	//md 24/06/2003
	obj = document.getElementById("ACASDesc");
	if (obj) obj.onblur = setCrossValParams;
	//md 07/07/2003
	obj = document.getElementById("MRADMMentHealthStatDR");
	if (obj) obj.onblur = setCrossValParams;
	obj = document.getElementById("RCCTDesc");
	if (obj) obj.onblur = setCrossValParams;
	return;
}

function setCrossValParams() {
	// sets the hidden ^ string for cross validation function
	var obj = document.getElementById("CrossValExtraParams"),
		str = "";
	if (obj) {
		var objParam = document.getElementById("PatientID");
		if (objParam) str = str + objParam.value;
		str = str + "^^^^^";
		var objParam = document.getElementById("CARETYPDesc");
		if (objParam) str = str + objParam.value;
		str = str + "^";
		var objParam = document.getElementById("INTREADesc");
		if (objParam) str = str + objParam.value;
		str = str + "^";
		var objParam = document.getElementById("CTDSPDesc");
		if (objParam) str = str + objParam.value;
		str = str + "^";
		var objParam = document.getElementById("CARAVLDesc");
		if (objParam) str = str + objParam.value;
		str = str + "^";
		var objParam = document.getElementById("PFSDesc");
		if (objParam) str = str + objParam.value;
		str = str + "^";
		var objParam = document.getElementById("FUNDARDesc");
		if (objParam) str = str + objParam.value;
		str = str + "^^";
		var objParam = document.getElementById("CONTROLDesc");
		if (objParam) str = str + objParam.value;
		str = str + "^";
		var objParam = document.getElementById("CONTRTYPEDesc");
		if (objParam) str = str + objParam.value;
		str = str + "^";
		var objParam = document.getElementById("SepRefEntered");
		var srstr = "";
		if (objParam) {
			for (var i = 0; i < objParam.options.length; i++) {
				if (i != 0) srstr = srstr + "$$";
				srstr = srstr + objParam.options[i].innerText;
			}
		}
		str = str + srstr;
		//md 24/06/2003
		str = str + "^^";
		var objParam = document.getElementById("ACASDesc");
		if (objParam) str = str + objParam.value;
		//md 07/07/2003
		str = str + "^";
		var objParam = document.getElementById("MRADMMentHealthStatDR");
		if (objParam) str = str + objParam.value;
		str = str + "^^";
		var objParam = document.getElementById("RCCTDesc");
		if (objParam) str = str + objParam.value;

		obj.value = str;
		//alert(obj.value);
	}
	return true;
}

//md 10/07/2003 moved js code from crossval method in web.PAAdm into js function + set onselect function for hidden broker

function ReturnFromCrossVal(str) {
	var lu = str.split("^");
	var errmsg = lu[0];
	var errtype = lu[1];
	var errfield = lu[2];
	var disable = lu[3];
	var statistical = lu[4];
	var objCV = document.getElementById("CrossVal");
	var objDisable = document.getElementById("CrossValDisable");
	if (objCV) objCV.value = "1";
	var fieldlvl = "";
	var objCVFL = document.getElementById("CrossValFieldLvl");
	if ((objCVFL) && (objCVFL.value == "1")) fieldlvl = 1;
	if (disable != "") {
		var disfields = disable.split("&");
		var i = 0;
		while (i != disfields.length) {
			if (disfields[i] != "") {
				var dis = disfields[i].split(",");
				var obj = document.getElementById(dis[0]);
				var objfrom = document.getElementById(dis[2]);
				if ((obj) && (objfrom) && (objfrom.value != "")) {
					if (dis[1] == "0") {
						if ((objDisable) && (objDisable.value != "")) {
							DisableField(dis[0]);
							DisableLookup("ld1081i" + dis[0]);
						}
						labelNormal(dis[0]);
					}
					if (dis[1] == "1") {
						EnableField(dis[0]);
						EnableLookup("ld1081i" + dis[0]);
						labelMandatory(dis[0]);
					}
				}
			}
			i = i + 1;
		}
	}
	if ((errtype == "E") && (fieldlvl != 1)) {
		var lu1 = errmsg.split("*");
		var m = 0;
		var msgalert = "";
		while (lu1[m] != "") {
			msgalert += lu1[m];
			msgalert += "\n"
			m = m + 1;
		}
		if (msgalert != "") {
			alert(msgalert);
		}
		if (errfield != "") {
			var obj = document.getElementById(errfield);
			if (obj) obj.value = "";
			websys_setfocus(errfield);
			if (objCV) objCV.value = "2";
		}
		return true;
	}
	if ((errtype == "W") && (fieldlvl != 1)) {
		var clear = !confirm(errmsg);
		if (errfield != "") {
			var obj = document.getElementById(errfield);
			if (obj) {
				if (clear == 1) {
					obj.value = "";
					if (objCV) objCV.value = "2";
				}
				websys_setfocus(errfield);
			}
		}
		return true;
	}
	if (statistical == "1") {
		StatisticalHandler();
		//var objCreateStat=document.getElementById("CreateStat");
		//if (objCreateStat) objCreateStat.value=1;
	} else if (statistical != "1") {
		var objCreateStat = document.getElementById("CreateStat");
		if (objCreateStat) objCreateStat.value = 0;
	}
	return true;
}

function CrossVal_changehandler(encmeth) {
	evtName = 'CrossVal';
	CrossVal_changehandlerX(encmeth);
}

//------------------------------------------------------------ end of cross val stuff

function UpdateAndOpenWordDoc() {
	return OpenWordDoc_click();
}

function OpenWordDoc() {
	var objWrdApp = new ActiveXObject("Word.Application");
	//var objWrdDoc = new ActiveXObject("Word.Document");
	objWrdApp.visible = true;

	if (objWrdApp) {
		//var wrdDoc=wrdApp.documents.Add();
		var objTemplatePath = document.getElementById('TemplatePath');
		if (objTemplatePath) {
			var strTemplatePath = objTemplatePath.value + "/"

			var objWrdDoc = objWrdApp.Documents.Add(strTemplatePath + "webDischarge.dot");
			if (objWrdDoc) {
				var objEpisodeID = document.getElementById('EpisodeID');
				if (objEpisodeID) {
					var strEpisodeID = objEpisodeID.value
					objWrdDoc.Variables.Add("EpisodeID", strEpisodeID);
					objWrdApp.Run("Medtrak");
					var FileSavePath = FilePathAndName()
					if (FileSavePath != "") {
						objWrdDoc.SaveAs(FileSavePath);
					}
				}
			}
		}
	}

	//Close word with the Quit method on the Application object.
	//objWrdApp.Application.Quit();

}

function FilePathAndName() {
	var obj = document.getElementById('SaveFilePath');
	if (obj) var strSaveFilePath = obj.value

	obj = document.getElementById('SaveFileSubDir');
	if (obj) var strSaveFileSubDir = obj.value

	obj = document.getElementById('SaveFileName');
	if (obj) var strSaveFileName = obj.value

	if ((strSaveFilePath != "") && (strSaveFileSubDir != "") && (strSaveFileName != "")) {
		//.doc extension hardcoded to be saved for word documents only
		strFilePathAndName = strSaveFilePath + strSaveFileSubDir + strSaveFileName + ".doc"
		strFilePath = strSaveFilePath + strSaveFileSubDir
	}
	CreateFilePath(strFilePath)
	return strFilePathAndName
}

function CreateFilePath(FilePath) {
	var objFileSys = new ActiveXObject("Scripting.FileSystemObject");

	// SA: Check if directory for document to be saved exists. If not,create it.
	// A single backslash is a specific character in JS, so directory path must
	// have a second backslash for each backslash. Comparison also requires "\\"
	// when comparing "\"

	for (var i = 0; i < FilePath.length; i++) {
		strFilePath += FilePath.charAt(i);
		if (FilePath.charAt(i) == "\\") strFilePath += "\\";
	}

	//alert(strFilePath)

	if (!objFileSys.FolderExists(FilePath)) {
		objFileSys.CreateFolder(FilePath);
	}
}

document.body.onload = BodyOnloadHandler;

//----

//Oct: 14-Oct-2002: reload listbox with values from hidden field.
//this is due to page being refreshed upon error message (such as invalid pin)
function SepRefListReload() {
	var el = document.getElementById("SepRefDescString");
	var lst = document.getElementById("SepRefEntered");
	if ((lst) && (el.value != "")) {
		var arrITEM = el.value.split(String.fromCharCode(1));
		for (var i = 0; i < arrITEM.length; i++) {
			var arrITEMVAL = arrITEM[i].split(String.fromCharCode(2));
			//don't add ones that have a child rowid as they would already be populated
			if ((arrITEMVAL[0] == "") && (arrITEMVAL[2] != "")) {
				AddItemToList(lst, arrITEMVAL[1], arrITEMVAL[2]);
			}
		}
	}
}

//FCH: 14-Oct-2002: reload listboxes with values in hidded fields.
//this is due to page being refreshed upon error message (such as invalid pin)
function ReloadListBoxes() {
	SepRefListReload();
}
//FCH: 14-Oct-2002: call this outside onload call so it can be called straight away, and not wait till everything has loaded.
ReloadListBoxes();

//----
//md 14/03/2003
function PAADMEstimDischargeDateHandler(e) {
	//alert("date call")
	var eSrc = websys_getSrcElement(e);
	var objD = document.getElementById('PAADMEstimDischargeDate');
	var objT = document.getElementById('PAADMEstimDischargeTime');
	var objeddmissing = document.getElementById("eddmissing");
	if ((objD) && (objD.value != "")) {
		if (objT) {
			labelMandatory('PAADMEstimDischargeTime')
		}
		if (!(objT) && (objeddmissing)) {
			objeddmissing.value = 2;
		}
	}
	if ((objD) && (objD.value == "")) {
		//alert("Normal time")
		if (objT) {
			labelNormal('PAADMEstimDischargeTime')
		}
	}

}

function PAADMEstimDischargeTimeHandler(e) {
	var eSrc = websys_getSrcElement(e);
	var objD = document.getElementById('PAADMEstimDischargeDate');
	var objT = document.getElementById('PAADMEstimDischargeTime');
	var objeddmissing = document.getElementById("eddmissing");
	if ((objT) && (objT.value != "")) {
		if (objD) {
			labelMandatory('PAADMEstimDischargeDate')
		}
		if (!(objD) && (objeddmissing)) {
			objeddmissing.value = 1;
		}
	}
	if ((objT) && (objT.value == "")) {
		if (objD) {
			labelNormal('PAADMEstimDischargeDate')
		}
	}

}

function PFSCodechangeHandler(e) {
	//dummy function
}
//md 03/09/003
function FUNDARCodechangeHandler(e) {
	//dummy function
}

function CheckMandatoryFields() {

	var msg = "";


	var objEd = document.getElementById('PAADMEstimDischargeDate')

	var objEt = document.getElementById('PAADMEstimDischargeTime')

	var objeddmissing = document.getElementById("eddmissing");
	var objdisdate = document.getElementById('PAADMDischgDate');

	if ((objdisdate) && (objdisdate.value == "")) {
		if ((objEd) && (objEd.value == "")) {
			var fld = 'PAADMEstimDischargeDate';
			var lbl = document.getElementById('c' + fld)
			if ((lbl) && (lbl.className == "clsRequired")) {
				msg += "\'" + t['PAADMEstimDischargeDate'] + "\' " + t['XMISSING'] + "\n";
			}
		}

		if ((objEt) && (objEt.value == "")) {
			var fld = 'PAADMEstimDischargeTime';
			var lbl = document.getElementById('c' + fld)
			if ((lbl) && (lbl.className == "clsRequired")) {
				msg += "\'" + t['PAADMEstimDischargeTime'] + "\' " + t['XMISSING'] + "\n";
			}
		}


		if ((objEt) && (objEt.value != "") && (objeddmissing) && (objeddmissing.value == 1)) {
			msg += "\'" + t['PAADMEstimDischargeDate'] + "\' " + t['FieldOnForm'] + "\n";
		}

		if ((objEd) && (objEd.value != "") && (objeddmissing) && (objeddmissing.value == 2)) {
			msg += "\'" + t['PAADMEstimDischargeTime'] + "\' " + t['FieldOnForm'] + "\n";
		}

	}
	if (msg != "") {
		alert(msg);
		return false;
	} else {
		return true;
	}
}

function StatisticalHandler() {
	//alert("standard");
	var objCreateStat = document.getElementById("CreateStat");
	if (objCreateStat) objCreateStat.value = 1;

}

function PAAdm_ReverseDischargeHandler(lnk, win) {
	var objGetFinalStat = document.getElementById('getFinalStat'); //cjb 20070528 add
	var EpisodeID = document.getElementById('EpisodeID').value;
	if (objGetFinalStat) {
		var retStr = cspRunServerMethod(objGetFinalStat.value, EpisodeID)
		if (retStr != "0") {
			alert(retStr)
			return;
		}
	}
	var PatientID = document.getElementById('PatientID').value;
	var mradm = document.getElementById('mradm').value;
	websys_createWindow("websys.default.csp?WEBSYS.TCOMPONENT=MRAdm.ReverseDischargeEdit&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + '&mradm=' + mradm + '&ID=' + mradm + "&PatientBanner=1", 'comp', 'top=20,left=20,width=300,height=100,scrollbars=yes,resizable=yes');
}

function PAAdm_ReverseEstimDischargeHandler() {
	var EpisodeID = document.getElementById('EpisodeID').value;
	var objReverseEstimDischarge = document.getElementById('ReverseEstimDischarge')
	if (objReverseEstimDischarge) {
		var retStr = cspRunServerMethod(objReverseEstimDischarge.value, EpisodeID);
		if (retStr != "0") {
			alert(retStr);
			return;
		}
		var lnk = "epr.default.csp";
		window.location = lnk;
	}
}

// cjb 09/02/2005 49232 - moved from QH custom script
function CheckForMentalHealth() {
	var EpisodeID = document.getElementById('EpisodeID');
	var MentalHealthLink = document.getElementById("PsychDetails");
	var MentalHealthFlag = document.getElementById('HiddenCodes').value.split("^")[14];
	if (MentalHealthLink) {
		//if ((EpisodeID)&&(EpisodeID.value!="")&&(MentalHealthFlag=="Y")) {
		if ((EpisodeID) && (EpisodeID.value != "") && (MentalHealthFlag == "Y") && (CheckMHAgainstBoarder())) {
			MentalHealthLink.disabled = false;
			MentalHealthLink.onclick = MentalHealthClickHandler;
		} else {
			MentalHealthLink.disabled = true;
			MentalHealthLink.onclick = LinkDisable;
		}
	}
}

function MentalHealthClickHandler() {
	var epi = document.getElementById('EpisodeID').value;
	var pat = document.getElementById('PatientID').value;
	var mradm = document.getElementById('mradm').value;
	var CONTEXT = session["CONTEXT"];
	websys_createWindow("psychdetails.frames.csp?PatientID=" + pat + "&EpisodeID=" + epi + '&mradm=' + mradm + '&CONTEXT=' + CONTEXT + '&PatientBanner=1', 'MentalHealth', "top=30,left=20,width=620,height=420,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
	return false;
}

function CheckMHAgainstBoarder() {
	return true;
}

function SetReaForRevFinDisch(str) {
	var tem = str.split("^");
	var obj = document.getElementById('RFDRowId');
	obj.value = tem[1];
	var obj = document.getElementById('RFDDesc');
	obj.value = tem[0];
	return;
}

function RevFinDischClick() {
	var EpisodeID = document.getElementById('EpisodeID').value;


	var retStr = tkMakeServerCall("web.DHCINSUPort", "GetInsuUpFlagByAdm", EpisodeID, "")
	if (retStr > 0) {
		alert("医保已经结算或上传,不能办理该操作");
		return;
	};
	var userId = session['LOGON.USERID'];
	var objRFDRowId = document.getElementById("RFDRowId");
	var objRevFinDisch = document.getElementById('RevFinDisch')

	if (objRevFinDisch) {
		var retStr = cspRunServerMethod(objRevFinDisch.value, EpisodeID, userId, objRFDRowId.value);
		if (retStr != "0") {
			alert(retStr);
			return;
		}
	}
	var lnk = "epr.default.csp";
	window.location = lnk;
}

function GetFilePath() //+wxl 090831
{
	var GetPath = document.getElementById("GetPath").value;
	var path = cspRunServerMethod(GetPath);
	return path
}

function PrintWardDischarge() //+wxl 090831
{
	var xlsExcel, xlsSheet, xlsBook;
	var titleRows, titleCols, LeftHeader, CenterHeader, RightHeader;
	var LeftFooter, CenterFooter, RightFooter;
	var path, fileName;

	path = GetFilePath();
	fileName = path + "warddischarge.xls";
	xlsExcel = new ActiveXObject("Excel.Application");
	xlsBook = xlsExcel.Workbooks.Add(fileName);
	xlsSheet = xlsBook.ActiveSheet;
	xlsTop = 1;
	xlsLeft = 1;
	var PatInfo = document.getElementById("GetPatInfo").value;
	var objEpisodeID = document.getElementById("EpisodeID");
	var str = cspRunServerMethod(PatInfo, "^" + objEpisodeID.value);
	var arr = str.split("^");
	var ctloc = arr[1];
	var wardDesc = arr[8];
	var bedCode = arr[6];
	var PatName = arr[4];
	var medCardNo = arr[12];
	var paadmReason = arr[21];
	var admDoc = arr[22];
	var admNurse = session['LOGON.USERNAME'];
	var regNo = arr[0];
	var DISCONDesc = document.getElementById("DISCONDesc").value;
	var PAADMDischgDate = document.getElementById("PAADMDischgDate").value;
	var row = 3;
	xlsSheet.cells(row, 2) = ctloc;
	xlsSheet.cells(row, 4) = wardDesc;
	xlsSheet.cells(row, 6) = bedCode;
	row = row + 1;
	xlsSheet.cells(row, 2) = PatName;
	xlsSheet.cells(row, 4) = paadmReason;
	xlsSheet.cells(row, 6) = medCardNo;
	row = row + 1;
	xlsSheet.cells(row, 2) = regNo;
	xlsSheet.cells(row, 4) = DISCONDesc;
	var tmpPAADMDischgDate = PAADMDischgDate.split("/");
	if (tmpPAADMDischgDate.length > 2) PAADMDischgDate = tmpPAADMDischgDate[2] + "-" + tmpPAADMDischgDate[1] + "-" + tmpPAADMDischgDate[0];
	xlsSheet.cells(row, 6) = PAADMDischgDate;
	row = row + 1;
	xlsSheet.cells(row, 2) = admDoc;
	xlsSheet.cells(row, 4) = admNurse;
	//090921 PJF  出院带药提示
	var OutDrugeMethod = document.getElementById("OutDruge");
	var EpisodeID = document.getElementById("EpisodeID").value;
	if (OutDrugeMethod) {
		row = row + 5;
		var OutDruge = cspRunServerMethod(OutDrugeMethod.value, EpisodeID);
		if (OutDruge != "") {
			xlsSheet.cells(row, 1) = "      您有(" + OutDruge + ")出院带药!请注意拿药"
			row = row + 1;
			xlsSheet.cells(row, 1) = "        西药请回护士站直接领取"
			row = row + 1;
			xlsSheet.cells(row, 1) = "        中成药请找主管医生索取处方后到门诊中药房自行领取"
		}
	}
	xlsSheet.PrintOut
	xlsSheet = null;
	xlsBook.Close(savechanges = false)
	xlsBook = null;
	xlsExcel.Quit();
	xlsExcel = null;
}
//add by zhaozh 2013.05.12
function ForobjDisConDesc() {
	var Desc = document.getElementById('DISCONDesc');
	if (Desc.value != "死亡") {
		document.getElementById("PAPERDeceasedDate").style.visibility = "hidden";
		document.getElementById("cPAPERDeceasedDate").style.visibility = "hidden";
		document.getElementById("ld1081iPAPERDeceasedDate").style.visibility = "hidden";
		document.getElementById("PAPERDeceasedTime").style.visibility = "hidden";
		document.getElementById("cPAPERDeceasedTime").style.visibility = "hidden";


	} else {
		document.getElementById("PAPERDeceasedDate").style.visibility = 'visible';
		document.getElementById("cPAPERDeceasedDate").style.visibility = 'visible';
		document.getElementById("ld1081iPAPERDeceasedDate").style.visibility = 'visible';
		document.getElementById("PAPERDeceasedTime").style.visibility = 'visible';
		document.getElementById("cPAPERDeceasedTime").style.visibility = 'visible';

	}
}

// ab 5.8.02 - following 2 functions here because need ones that arent overwritten by custom scripts
/* ab - no longer used?
function DisableFldObj(fld) {
	if (fld) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		var lbl = document.getElementById('c'+fld.id);
		if (lbl) lbl.className="";
	}
}

function EnableFldObj(fld) {
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		var lbl=document.getElementById('c'+fld.id);
		if (lbl) lbl.className="";
	}
}
*/

/*JW moved to websys.Edit.Tools.js - delete post 10/5/04
function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "clsRequired";
	}
}

function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "";
	}

}
function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		
	}
}
function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		
	}
} */
function AlertAbnormalOrder() {
	
	obj = document.getElementById("EpisodeID");
	var EpisodeID = obj ? obj.value : ""
	var retStr = tkMakeServerCall("web.DHCIPBillCheckAdmFee", "AdmOeOrdCheckNurse", EpisodeID, "New")
	if (retStr != 0) {
		alert("患者医嘱计费有误,您可在《患者住院费用核查》模块找到错误数据")
		document.getElementById("Update").style.visibility = "hidden";
		return;
	}
	var retStr = tkMakeServerCall("Nur.DHCADTDischarge", "getAbnormalOrder", EpisodeID, "Disch")
	if (retStr == "") return;
	var retStrArrat = retStr.split("^");
	var ifCanTrans = retStrArrat[0];
	if (ifCanTrans != "Y" && retStrArrat.length > 1) {
		document.getElementById("Update").style.visibility = "hidden";
	}
	for (var i = 1; i < retStrArrat.length; i++) {
		var alertStr = retStrArrat[i];
		alert(alertStr);
	}
}