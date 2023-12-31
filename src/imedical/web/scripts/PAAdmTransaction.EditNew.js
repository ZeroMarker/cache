// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//W650

var curCPType, ordStrsInd, transDiscon = "N"; //ypz
function CareProvChangeHandler(str) {
	var lu = str.split("^");
	//KM: because the lookup and broker to a contains on location then so does below.
	//if (obj) {if (lu[2].indexOf(obj.value)==-1) obj.value = "";}
	//var obj=document.getElementById('CareProvLocDesc');
	//if (obj) obj.value = lu[2];

	var obj = document.getElementById("CTPCPCode");
	if (obj) obj.value = lu[1];
	var obj = document.getElementById('TRANSCTLOCDR')
	if ((obj) && (lu[2] != "")) obj.value = lu[2];
	var obj = document.getElementById('HOSPDesc')
	if (obj) obj.value = lu[5];
	var obj = document.getElementById("LocationID");
	if ((obj) && (lu[4] != "")) obj.value = lu[4];

	endLookups();
}

// ab 20.01.04 41905
function HospChangeHandler(str) {
	var lu = str.split("^");

	var obj = document.getElementById("Hospitals");
	if (obj) obj.value = lu[1];
}

function HospBlurHandler() {
	var obj = document.getElementById("HOSPDesc");
	var objHosps = document.getElementById("Hospitals");
	if ((objHosps) && (obj) && (obj.value == "")) objHosps.value = "";
}

function LocBlurHandler() {
	var obj = document.getElementById("TRANSCTLOCDR");
	var obj2 = document.getElementById("HOSPDesc");
	var objHosps = document.getElementById("Hospitals");
	if ((objHosps) && (obj) && (obj.value == "") && (!obj2)) objHosps.value = "";
	if ((objHosps) && (obj) && (obj.value == "") && (obj2) && (obj2.value == "")) objHosps.value = "";
	var objLocID = document.getElementById("LocationID");
	if ((objLocID) && (obj) && (obj.value == "")) objLocID.value = "";
}

//checks to see if the Ward field is on the screen,
//if it isn't, bed lookup will restrict to ward associated with logged on location
function DefaultCurrentWard() {
	var obj = document.getElementById('TRANSWardDR');
	if (obj) {
		var obj = document.getElementById('CurrentWardID');
		if (obj) obj.value = "";
	}
}

function UpdateHandler() {

	//var objAge=document.getElementById("PATAge");
	//var objMaxAge=document.getElementById('CTLOCAgeTo');
	//var objMinAge=document.getElementById('CTLOCAgeFrom');

	//KM 4-Apr-2002: re-enable fields for update
	//var obj=document.getElementById('TRANSCTLOCDR'); //for default loc ypz rem
	//if (obj) obj.disabled=false;                     //for default loc 
	//var obj=document.getElementById('TRANSCTCPDR');
	//if (obj) obj.disabled=false;
	var obj = document.getElementById('TRANSMain');
	if (obj) obj.disabled = false;
	var obj = document.getElementById('TRANSEndDate');
	if (obj) obj.disabled = false;
	var obj = document.getElementById('TRANSEndTime');
	if (obj) obj.disabled = false;
	var obj = document.getElementById("TRANSBedDR");
	var objBedID = document.getElementById("BedID");
	if ((obj) && (objBedID) && (obj.value == "")) objBedID.value = "";

	// ab 10.02.04 - show mental health warning message
	var obj = document.getElementById("MentalHealth");
	if ((obj) && (obj.value == 1)) {
		if (!confirm(t["MentalHealthMsg"])) obj.value = 0;
	}

	//ab 9.05.03 - modified age restrict code and moved to websysSaveValidate of PAAdmTransaction as cache error message
	// ab 18.03.02 - log 23587 - prompt to update if age is out of room range
	//ab 9.05.03 - modified sex restrict code and moved to websysSaveValidate of PAAdmTransaction as cache error message

	//var fields=new Array("TRANSCTCPDR","TRANSCTLOCDR","TRANSBedDR","TRANSWardDR");
	//if (!checkCodeTableValid(fields)) return false;
	///ypz begin
	//wxl 081128 Start	
	var EpisodeID = document.getElementById('EpisodeID').value;

	if (objBedID.value != "") {
		var Hosid = session['LOGON.HOSPID'];
		var Ctloc = session['LOGON.CTLOCID'];
		var TransWardDesc = "";
		var obj = document.getElementById('TRANSWardDR');
		if (obj) TransWardDesc = obj.value;
		var locId = tkMakeServerCall("Nur.DHCBedManager", "GetLocIdByWardDesc", TransWardDesc);
		if (locId == Ctloc) {
			var ret = tkMakeServerCall("Nur.DHCBedManager", "IfCanTransBed", Hosid, locId, objBedID.value, EpisodeID);
			if (ret == "1") {
				alert("床位被预约,不能分配")
				return;
			}
			if (ret != "0") {
				//先屏蔽
				var lnk = "DHCNurBedApply.csp?&EpisodeID=" + EpisodeID + "&ApplyBedId=" + objBedID.value;
				window.open(lnk, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=378,height=389,left=120,top=0')
				return;
			}
		}

	}

	var objLocationID = document.getElementById('LocationID');
	var TransWardDesc = "";
	var obj = document.getElementById('TRANSWardDR');
	if (obj) TransWardDesc = obj.value;
	var objGetLocWard = document.getElementById('GetLocWard');
	if (objGetLocWard) {
		encmeth = objGetLocWard.value;
		var ret = cspRunServerMethod(encmeth, EpisodeID, objLocationID.value, TransWardDesc);
		if (ret != 0) {
			alert(ret);
			return;
		}
	}
	var GetUserTypeCWT = tkMakeServerCall("web.DHCNurseRecordComm", "GetUserTypeTran", session['LOGON.USERID'])
	if (GetUserTypeCWT !== "0") {
		alert(GetUserTypeCWT);
		return;
	}

	//wxl 081128 End
	var obj = document.getElementById('TransType');


	if (obj.value == "T") {
		var doctor = document.getElementById("TRANSCTCPDR").value;
		if (doctor == "") {
			alert("医生不能为空!")
			return;
		}
	}

	if ((obj) && (transDiscon == "Y")) {
		if ((obj.value == "T") || (obj.value == "MT")) {
			var objLocationID = document.getElementById('LocationID')
			if (objLocationID) {
				var disconStandOrd = true;
				var objDisconStandOrd = document.getElementById('DisconStandOrd');
				if (objDisconStandOrd) disconStandOrd = objDisconStandOrd.checked;
				//alert(disconStandOrd)
				if ((ordStrsInd > 0) && (disconStandOrd)) {
					var userId = session['LOGON.USERID'];
					var EpisodeID = document.getElementById('EpisodeID').value;
					var objc, encmeth, retStr;
					objc = document.getElementById("DisconLongOrder");
					if (objc) {
						encmeth = objc.value
					} else {
						encmeth = ''
					};
					//alert(ordStrsInd+"/"+EpisodeID+"//"+userId+"/"+objLocationID.value+"/");return;
					retStr = cspRunServerMethod(encmeth, ordStrsInd, EpisodeID, "", userId, objLocationID.value, "");
					if (retStr != 0) alert(t['alert:DischOrdFail']);
				}
			}
		}
	}
	if (obj.value == "M") {
		var doctor = document.getElementById("TRANSCTCPDR").value;
		if (doctor == "") {
			alert("医生不能为空!")
			return;
		}
		var MainNurseID = document.getElementById("MainNurseID")
		if (MainNurseID) {
			MainNurseID = MainNurseID.value
			var MainNurseID2 = document.getElementById("MainNurseID2").value
			var LocationID = document.getElementById("LocationID").value
			var ret = tkMakeServerCall("web.DHCMainNurse", "UpdateMainNurse", EpisodeID, MainNurseID, MainNurseID2)
		}
	}
	/*	var EpisodeID = document.getElementById('EpisodeID').value;
		var CTPCPCode = document.getElementById("CTPCPCode").value
		var MainNurseID = document.getElementById("MainNurseID")
		if (MainNurseID) {
			MainNurseID = MainNurseID.value
			var MainNurseID2 = document.getElementById("MainNurseID2").value
			var LocationID = document.getElementById("LocationID").value
			var ret = tkMakeServerCall("web.DHCMainNurse", "UpdateMainDocAndNurse", EpisodeID, CTPCPCode, MainNurseID, MainNurseID2, LocationID, session['LOGON.USERID'])
		}



	}*/
	var objIfInsertBedOrd = document.getElementById('ifInsertBedOrd')
	if ((obj) && (objIfInsertBedOrd)) {
		if (objIfInsertBedOrd.value == "Y") {
			if ((obj.value == "M") || (obj.value == "MT")) {
				var objWardId = document.getElementById('TRANSWardDR')
				if (objWardId) {
					var userId = session['LOGON.USERID'];
					var EpisodeID = document.getElementById('EpisodeID').value;
					var objInsertBedOrd, encmethBed, retStrBed;
					objInsertBedOrd = document.getElementById("InsertBedOrd");
					if (objInsertBedOrd) {
						encmethBed = objInsertBedOrd.value
					} else {
						encmethBed = ''
					};
					//alert(EpisodeID+"/"+encmethBed+"/"+objWardId.value+"/");//return;
					retStrBed = cspRunServerMethod(encmethBed, EpisodeID, objWardId.value);
					//alert(retStrBed);
				}
			}
		}
	}

	var objTransType = document.getElementById('TransType');
	var objMoveAttachBaby = document.getElementById("MoveAttachBaby");
	if ((objTransType) && ((objMoveAttachBaby))) {
		if ((objTransType.value == "M") || (objTransType.value == "MT")) {
			var objTRANSWardDR = document.getElementById('TRANSWardDR')
			if (objTRANSWardDR) {
				var userId = session['LOGON.USERID'];
				var EpisodeID = document.getElementById('EpisodeID').value;
				var bedId = document.getElementById('BedID').value;
				//alert(EpisodeID+"/"+objTRANSWardDR.value+"/"+bedId);return;
				var retStr = cspRunServerMethod(objMoveAttachBaby.value, EpisodeID, userId, objTRANSWardDR.value, bedId);
				if (retStr != 0) {
					alert(retStr);
					window.close();
					return;
				}
			}
		}
	}

	var objLocationID = document.getElementById('LocationID');
	var objTRANSWardDR = document.getElementById('TRANSWardDR');

	if ((objTransType.value == "MT") && (objLocationID) && (objTRANSWardDR)) {
		//alert(objTransType.value+"@"+EpisodeID+"@"+objLocationID.value+"@"+objTRANSWardDR.value)


		var ret = tkMakeServerCall("web.DrugAuditNew", "TranDispAdmLocAndDept", EpisodeID, objLocationID.value, objTRANSWardDR.value)

		if (ret != "") {
			alert(ret)
			return;
		}
	}
	
	update1_click();
	if (window.opener) {
		//window.opener.location.reload();
		if (window.opener.opener) {
			if (window.opener.opener.parent.window.frames['TRAK_main']) {
				window.opener.opener.parent.window.frames['TRAK_main'].location.reload();
			}
		}

	}
}

function BodyLoadHandler() {
	DefaultCurrentWard();

	try {
		setEvents();
	} catch (err) {}

	var obj = document.getElementById('update1')
	if (obj) obj.onclick = UpdateHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']] = UpdateHandler;
	var episodeid = document.getElementById("EpisodeID");
	var wardid = session['LOGON.WARDID'];
	var transout = tkMakeServerCall("web.DHCSETIMAGE", "IsTransOutPat", episodeid.value,wardid)
	if(transout=='1'){
		obj.style.display = "none";
	}
		
	
	var objWL = document.getElementById("PAADMWaitListDR");
	var objFirstMove = document.getElementById("FirstTransM");
	var objFirstTrans = document.getElementById("FirstTransT");
	var objID = document.getElementById("ID");
	var objStartDate = document.getElementById("TRANSStartDate");
	var objCP = document.getElementById('TRANSCTCPDR');
	var objCPlu = document.getElementById('ld1069iTRANSCTCPDR');
	var objLoc = document.getElementById('TRANSCTLOCDR');
	var objLoclu = document.getElementById('ld1069iTRANSCTLOCDR');
	var objMainCare = document.getElementById("TRANSMain");
	var objEndDate = document.getElementById("TRANSEndDate");
	var objEndTime = document.getElementById("TRANSEndTime");
	//Log 32516 md 07.02.2003
	var objEndDateH = document.getElementById("TRANSEndDatehidden");
	var objEndTimeH = document.getElementById("TRANSEndTimehidden");
	if ((objEndDate) && (objEndDate.value == "") && (objEndDateH)) {
		objEndDate.value = objEndDateH.value
	}
	if ((objEndTime) && (objEndTime.value == "") && (objEndTimeH)) {
		objEndTime.value = objEndTimeH.value
	}

	var obj = document.getElementById("HOSPDesc");
	if (obj) obj.onblur = HospBlurHandler;

	var obj = document.getElementById("TRANSCTLOCDR");
	if (obj) obj.onblur = LocBlurHandler;

	var obj = document.getElementById("TemporaryLoc");
	if (obj) obj.onblur = TempLocBlurHandler;

	//Log 32516 md 07.02.2003
	//Log 27043: Disable irrelevant fields depending on transaction type being edited or created.
	var obj = document.getElementById('TransType');
	if (obj) {

		if (obj.value == "M") {
			var obj2 = document.getElementById('TRANSCTLOCDR');
			if (obj2) setDisabled(obj2)
			var obj2 = document.getElementById('ld1069iTRANSCTLOCDR');
			if (obj2) obj2.style.display = "none";
			var obj2 = document.getElementById('TRANSCTCPDR');
			//if (obj2) setDisabled(obj2)
			var obj2 = document.getElementById('ld1069iTRANSCTCPDR');
			//if (obj2) obj2.style.display = "none";
			var obj2 = document.getElementById('TRANSMain');
			if (obj2) setDisabled(obj2)

			// 30200 ab 17.12.02 - disable start date for first move transaction of waiting list TCI
			if ((objWL) && (objFirstMove) && (objWL.value != "") && (objID) && (objFirstMove.value == objID.value)) {
				if (objStartDate) {
					setDisabled(objStartDate);
					var objStartDateL = document.getElementById("ld1069iTRANSStartDate");
					if (objStartDateL) objStartDateL.disabled = true;
				}
			}

			// md 31152 18.12.2002 disable end date/time
			if ((objID) && (objID.value != "")) {
				if ((objEndDate) && (objEndDate.value == "")) {
					setDisabled(objEndDate);
					var objEndDateL = document.getElementById("ld1069iTRANSEndDate");
					if (objEndDateL) objEndDateL.disabled = true;
				}
				if ((objEndTime) && (objEndTime.value == "")) setDisabled(objEndTime);
			}
			//add by linyuxu
			var objTRANSCTLOCDR = document.getElementById("TRANSCTLOCDR");
			var episodeid = document.getElementById("EpisodeID");
			var hidecodeInfo = document.getElementById("HiddenCodes");
			var objlocdesc = document.getElementById('getLocDesc');
			//alert(hidecodeInfo.value)

			//var locId = cspRunServerMethod(hidecodeInfo.value, episodeid.value);
			var locId = tkMakeServerCall("web.DHCCLCom", "getLocIdByAdm", episodeid.value)

			var retStr = cspRunServerMethod(objlocdesc.value, locId);

			objTRANSCTLOCDR.value = retStr;

			var objBedID = document.getElementById("BedID");
			if (objBedID) {

				var RetWardNurse = tkMakeServerCall("web.DHCMainNurse", "GetWardNurse", episodeid.value);

				if (RetWardNurse != "") {
					var WardNurse = RetWardNurse.split("^");
					var mainNurse1 = document.getElementById("MainNurse");
					if (mainNurse1) {
						mainNurse1.value = WardNurse[2];

						document.getElementById("MainNurseID").value = WardNurse[3];
						var mainNurse2 = document.getElementById("MainNurse2");
						if (mainNurse2) {
							mainNurse2.value = WardNurse[4];
						}
						document.getElementById("MainNurseID2").value = WardNurse[5];
						var ctcpOfBedInfo = tkMakeServerCall("web.DHCArrbeddoc", "getCTCPOfBed", objBedID.value);
						if (ctcpOfBedInfo != "") {
							var ctcpOfBedInfoArray = ctcpOfBedInfo.split("^");
							var doctorCode = ctcpOfBedInfoArray[4];
							var doctorName = ctcpOfBedInfoArray[1];
							var nurseCtcpId = ctcpOfBedInfoArray[2];
							var nurseName = ctcpOfBedInfoArray[3];
							if (doctorCode != "") {
								document.getElementById("CTPCPCode").value = doctorCode;
								document.getElementById("TRANSCTCPDR").value = doctorName;

							}
							if (nurseCtcpId != "") {
								document.getElementById("MainNurseID").value = nurseCtcpId;
								document.getElementById("MainNurse").value = nurseName;


							}
						}
					}


				}


			}


		}
		if (obj.value == "B") {
			var obj2 = document.getElementById('TRANSCTLOCDR');
			if (obj2) obj2.style.display = "none";
			var obj2 = document.getElementById('ld1069iTRANSCTLOCDR');
			if (obj2) obj2.disabled = true;
			var obj2 = document.getElementById('TRANSCTCPDR');
			if (obj2) setDisabled(obj2)
			var obj2 = document.getElementById('ld1069iTRANSCTCPDR');
			if (obj2) obj2.style.display = "none";
			var obj2 = document.getElementById('TRANSMain');
			if (obj2) setDisabled(obj2)
				// 30200 ab 17.12.02 - disable start date for first move transaction of waiting list TCI
			if ((objWL) && (objFirstMove) && (objWL.value != "") && (objID) && (objFirstMove.value == objID.value)) {
				if (objStartDate) {
					setDisabled(objStartDate);
					var objStartDateL = document.getElementById("ld1069iTRANSStartDate");
					if (objStartDateL) objStartDateL.disabled = true;
				}
			}
			// md 31152 18.12.2002 disable end date/time 
			if ((objID) && (objID.value != "")) {
				if (objEndTime) setDisabled(objEndTime);
				if (objEndDate) {
					setDisabled(objEndDate);
					var objEndDateL = document.getElementById("ld1069iTRANSEndDate");
					if (objEndDateL) objEndDateL.disabled = true;
				}
			}
		}
		if (obj.value == "T") {
			// ab 1.03.04 - hospital can be used to restrict location/care provider
			//var obj2=document.getElementById('HOSPDesc');
			//if (obj2) setDisabled(obj2)
			//var obj2=document.getElementById('ld1069iHOSPDesc');
			//if (obj2) obj2.disabled=true;

			var objImgTransCtlocId = document.getElementById("ld1069iTRANSCTLOCDR");
			if (objImgTransCtlocId) {
				setDisabled(objImgTransCtlocId)
			}
			var obj2 = document.getElementById('TRANSWardDR');
			if (obj2) setDisabled(obj2)
			var obj2 = document.getElementById('ld1069iTRANSWardDR');
			if (obj2) obj2.style.display = "none";
			var obj2 = document.getElementById('TRANSCTLOCDR');
			if (obj2) setDisabled(obj2)
			var obj2 = document.getElementById('ld1069iTRANSCTLOCDR');
			if (obj2) obj2.style.display = "none";
			var obj2 = document.getElementById('TRANSWardRoomDR');
			if (obj2) setDisabled(obj2)
			var obj2 = document.getElementById('ld1069iTRANSWardRoomDR');
			if (obj2) obj2.style.display = "none";
			var obj2 = document.getElementById('TRANSOverrideRoomTypeDR');
			if (obj2) setDisabled(obj2)
			var obj2 = document.getElementById('ld1069iTRANSOverrideRoomTypeDR');
			if (obj2) obj2.style.display = "none";
			var obj2 = document.getElementById('TRANSBedDR');
			if (obj2) setDisabled(obj2)
			var obj2 = document.getElementById('ld1069iTRANSBedDR');
			if (obj2) obj2.style.display = "none";
			var obj2 = document.getElementById('TRANSBedTypeDR');
			if (obj2) setDisabled(obj2)
			var obj2 = document.getElementById('ld1069iTRANSBedTypeDR');
			if (obj2) obj2.style.display = "none";

			// 30200 ab 17.12.02 - disable start date/loc/doc for first transfer transaction of waiting list TCI
			if ((objWL) && (objFirstTrans) && (objWL.value != "") && (objID) && (objFirstTrans.value == objID.value)) {
				if (objStartDate) objStartDate.disabled = true;
				if (objCP) objCP.disabled = true;
				if (objCPlu) objCPlu.disabled = true;
				if (objLoc) objLoc.disabled = true;
				if (objLoclu) objLoclu.disabled = true;
			}
			// md 31152 18.12.2002 disable end date/time
			if ((objID) && (objID.value != "") && (objMainCare) && (objMainCare.checked == true)) {
				if ((objEndTime) && (objEndTime.value == "")) setDisabled(objEndTime);
				if ((objEndDate) && (objEndDate.value == "")) {
					setDisabled(objEndDate);
					var objEndDateL = document.getElementById("ld1069iTRANSEndDate");
					if (objEndDateL) objEndDateL.disabled = true;
				}
			}
			//MD 32467 05.02.2003 disable Parent Ward,Temporary Location,Move All Records with Patient 
			var obj2 = document.getElementById('PAADMParentWardDR');
			if (obj2) setDisabled(obj2);
			var obj2 = document.getElementById('ld1069iPAADMParentWardDR');
			if (obj2) obj2.disabled = true;
			var obj2 = document.getElementById('TemporaryLoc');
			if (obj2) setDisabled(obj2);
			var obj2 = document.getElementById('ld1069iTemporaryLoc');
			if (obj2) setDisabled(obj2);
			var obj2 = document.getElementById('MoveAllMR');
			if (obj2) setDisabled(obj2);
			//xuqy add begin
			var objTRANSCTLOCDR = document.getElementById("TRANSCTLOCDR");
			var objLocID = document.getElementById("LocationID");
			if ((objLocID) && (objTRANSCTLOCDR) && (objTRANSCTLOCDR.value == "")) objLocID.value = "";
			if ((objLocID.value == "") && (objTRANSCTLOCDR.value == "")) {
				var hidecodeInfo = document.getElementById("HiddenCodes");
				var hidecodeDr = hidecodeInfo.value.split("^");
				objLocID.value = hidecodeDr[0];
				var objlocdesc = document.getElementById('getLocDesc');
				var retStr
				if (objlocdesc) {
					retStr = cspRunServerMethod(objlocdesc.value, hidecodeDr[0]);
					objTRANSCTLOCDR.value = retStr;
					//if (retStr=="")
				}
			}

			// xuqy add end

		}
		if ((obj.value == "T") || (obj.value == "M") || (obj.value == "MT")) AlertAbnormalOrder() //ypz
	}
	if (objMainCare) objMainCare.onclick = checkforEndDate;
	var objLOCDR = document.getElementById('TRANSCTLOCDR');
	if(objLOCDR&&objLOCDR.value!=""){
		document.getElementById('ld1084iTRANSCTLOCDR').style.display='none';		
	}
}

function AlertAbnormalOrder() {
	var objc, encmeth;
	objc = document.getElementById("UserID");
	if (objc) {
		var userId = objc.value
	} else {
		return 0
	};
	var objTransCtlocId = document.getElementById("TRANSCTLOCDR");
	var objTransCtcpId = document.getElementById("TRANSCTCPDR");
	var objImgTransCtlocId = document.getElementById("ld1069iTRANSCTLOCDR");
	var objImgTransCtcpId = document.getElementById("ld1069iTRANSCTCPDR");
	var ifAlertCanTrans = document.getElementById("ifAlertCanTrans");
	var objTransType = document.getElementById('TransType'); ////xuqy 080430
	objc = document.getElementById("GetAbnormalOrder");
	if (objc) {
		encmeth = objc.value
	} else {
		return;
		encmeth = '';
	};
	objc = document.getElementById("EpisodeID");
	if (objc) {
		var EpisodeID = objc.value
	} else {
		return 0
	};
	var abnormalOrder = cspRunServerMethod(encmeth, EpisodeID, userId);
	var tmpList = abnormalOrder.split("^");
	//alert(tmpList)
	if (tmpList.length < 34) {
		if (objTransCtlocId) {
			objTransCtlocId.disabled = true;
		}
		if (objTransCtcpId) {
			objTransCtcpId.disabled = true;
		}
		if (objImgTransCtlocId) {
			objImgTransCtlocId.disabled = true;
		}
		if (objImgTransCtcpId) {
			objImgTransCtcpId.disabled = true;
		}
		ordStrsInd = 0; //not discontinue today long order
	} else {
		ordStrsInd = tmpList[30];
		if (tmpList[0] == "0") ordStrsInd = 0;

		for (var i = 0; i < 30; i++) {
			if ((i > 14) && (i < 25)) continue;
			if (tmpList[i] != "0") {
				//alert(ifAlertCanTrans+"/"+tmpList[i]);
				if (objTransType.value != "T") {
					alert(tmpList[i]);
				}
				if (ifAlertCanTrans) {
					if (ifAlertCanTrans.value != "Y") {

						var obj = document.getElementById('update1');
						if (obj) {
							obj.disabled = true;
						}
						if (objTransCtlocId) {
							objTransCtlocId.disabled = true;
						}
						//if (objTransCtcpId) {objTransCtcpId.disabled=true;}
						if ((objTransCtcpId) && (objTransType.value != "T")) {
							objTransCtcpId.disabled = true;
						}
						if (objImgTransCtlocId) {
							objImgTransCtlocId.disabled = true;
						}
						//if (objImgTransCtcpId) {objImgTransCtcpId.disabled=true;}  //xuqy 080430
						if ((objImgTransCtcpId) && (objTransType.value != "T")) {
							objImgTransCtcpId.disabled = true;
						}
					}
				}
			}
		}
		if (tmpList[32]) transDiscon = tmpList[32];
	}
	//ypz end


	/*var objc,encmeth
	objc=document.getElementById("GetAbnormalOrder");
	if (objc) {	encmeth=objc.value;
		objc=document.getElementById("EpisodeID");
		if (objc)
		{	var episodeId=objc.value
			var resStr=cspRunServerMethod(encmeth,episodeId);
			var tmpList=resStr.split("^");
			if (tmpList.length>2)
			{	ordStrsInd=tmpList[1];
				if (tmpList[0]!="0" ) alert(tmpList[0]);
				if (tmpList[2]!="0" ) alert(tmpList[2]);
			}
		}
	}*/
}



function setDisabled(obj) {
	obj.disabled = true;
	if (obj.value == "") obj.className = "disabledField";
}

function setEnabled(obj) {
	obj.disabled = false;
	obj.className = "";
}

function checkforEndDate(e) {

	var obj = document.getElementById('TransType');
	var objID = document.getElementById("ID");
	var objEndDate = document.getElementById("TRANSEndDate");
	var objEndTime = document.getElementById("TRANSEndTime");
	var objMainCare = document.getElementById("TRANSMain");

	if ((obj) && (obj.value == "T") && (objID) && (objID.value != "")) {
		if ((objMainCare) && (objMainCare.checked == true)) {
			if ((objEndDate) && (objEndDate.value == "")) {
				setDisabled(objEndDate);
				var objEndDateL = document.getElementById("ld1069iTRANSEndDate");
				if (objEndDateL) objEndDateL.disabled = true;
			}
			if ((objEndTime) && (objEndTime.value == "")) setDisabled(objEndTime);
		}
		if ((objMainCare) && (objMainCare.checked == false)) {
			if ((objEndDate) && (objEndDate.value == "")) {
				setEnabled(objEndDate);
				var objEndDateL = document.getElementById("ld1069iTRANSEndDate");
				if (objEndDateL) objEndDateL.disabled = false;
			}
			if ((objEndTime) && (objEndTime.value == "")) setEnabled(objEndTime);
		}
	}
}

function TempLocselector(str) {
	//LocDesc,RowID,Code,Type,VisitFr,VisitTo,RestFr,RestTo,VisitRange,SNAPFlag
	//0	 ,1	,2   ,3  ,4 	 ,5      ,6     ,7     ,8         ,9 
	var lu = str.split("^");
	var obj = document.getElementById("TemporaryLoc");
	if (obj) obj.value = lu[0];
	//will need to define 2 new fields
	var obj = document.getElementById("TempLocType")
	if (obj) obj.value = lu[3];
	var obj = document.getElementById("TempLocSNAP")
	if ((obj) && (lu[9])) obj.value = lu[9];

}

function TempLocBlurHandler() {
	var obj = document.getElementById("TemporaryLoc");
	var objType = document.getElementById("TempLocType");
	var objFlag = document.getElementById("TempLocSNAP")
	if ((obj) && (obj.value == "")) {
		if (objType) {
			objType.value = "";
		}
		if (objFlag) {
			objFlag.value = "";
		}
	}
}

document.body.onload = BodyLoadHandler;



function AlertAbnormalOrder() {
	var objTransType = document.getElementById('TransType');
	if (objTransType.value != "MT") return;
	obj = document.getElementById("EpisodeID");
	var EpisodeID = obj ? obj.value : ""
	var retStr = tkMakeServerCall("Nur.DHCADTDischarge", "getAbnormalOrder", EpisodeID, "Trans")
	if (retStr == "") return;
	var retStrArrat = retStr.split("^");
	var ifCanTrans = retStrArrat[0];
	if (ifCanTrans != "Y" && retStrArrat.length > 1) {
		document.getElementById("update1").style.display = "none"
	}
	for (var i = 1; i < retStrArrat.length; i++) {
		var alertStr = retStrArrat[i];
		alert(alertStr);
	}
}

function mainNurseLookUp(info) {
	var info = info.split("^")
	var mainNurse = document.getElementById("MainNurse")
	mainNurse.value = info[1];
	var mainNurseId = document.getElementById("MainNurseID");
	mainNurseId.value = info[0];

}

function mainNurseLookUp2(info) {
	var info = info.split("^")
	var mainNurse = document.getElementById("MainNurse2")
	mainNurse.value = info[1];
	var mainNurseId = document.getElementById("MainNurseID2");
	mainNurseId.value = info[0];

}