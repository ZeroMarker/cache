//lvxin 2013-10-28
DHCCNursePrintComm = document.getElementById("DHCCNursePrintComm")
document.write("<script language='javascript' src='../scripts/nurse/DHCNUR/DHCNurPrintClickOnce.js'></script>");
function PrintTPQ() {
	var queryTypeCode = document.getElementById('queryTypeCode').value;
	var objSeatNo = parent.frames["NurseTop"].document.getElementById("SeatNo");
	if (objSeatNo) SeatNo = objSeatNo.value;
	var objtbl = document.getElementById('tDHCNurOPExec');
	var oeoriIdStr = "",
		seqNoStr = "",
		notFyStr = "",
		hasNotPrint = false;
	for (i = 1; i < objtbl.rows.length; i++) {
		var check = document.getElementById('seleitemz' + i);
		var oeoriId = document.getElementById('oeoriIdz' + i).innerText;
		var seqNo = document.getElementById('tmpSeqNoz' + i).innerText;
		var PrintFlag = document.getElementById('tmpPrtFlagz' + i).innerText;
		if (check.checked == true) {

			if ((PrintFlag.indexOf("T") == -1) && (hasNotPrint == false)) hasNotPrint = true;

			var fyFlag = tkMakeServerCall("web.DHCOutPhCommon", "GetfyflagforNurse", oeoriId);
			if (fyFlag == "0") {
				notFyStr = "患者有未发药的医嘱,请到药房取药！";
				continue;
			}


			if (oeoriIdStr.length == 0) {
				oeoriIdStr = oeoriId;
			} else {
				oeoriIdStr = oeoriIdStr + "^" + oeoriId
			}
			if (seqNoStr.length == 0) {
				seqNoStr = seqNo;
			} else {
				seqNoStr = seqNoStr + "^" + seqNo
			}
		}
	}

	if (notFyStr != "") {
		alert(notFyStr);
	}
	if (oeoriIdStr == "") {
		alert("请选择医嘱！");
		return;
	}

	//var ClientTyp = "";


	function TreatQueueFn(alertFlag) {
		var regNo = parent.frames["NurseTop"].document.getElementById("regNo").value;
		var TreatAdmDr = 0,
			insertTreatFlag = false;
		var objtbl = document.getElementById('tDHCNurOPExec');
		for (var i = 1; i < objtbl.rows.length; i++) {

			var check = document.getElementById('seleitemz' + i);
			var oeoriId = document.getElementById('oeoriIdz' + i).innerText;
			var comparId = oeoriId.split("||")[0];
			//var oeoriId = serverOrderID[i];
			//var tmpOrderDataList = serverOrderData[i].split("^");


			if (check.checked == true) {
				if (oeoriId != "") {
					var ExecStat = document.getElementById('disposeStatDescz' + i).innerText;
					if ((ExecStat == "已执行") || (ExecStat == "停止执行")) {
						//输液单没有未执行的不插入队列
					} else {
						if (TreatAdmDr < comparId) {
							TreatAdmDr = comparId; //取就诊最近的一次
						}
					}
				}
			}

		}
		TreatAdmDr = tkMakeServerCall("Nur.Infusion.DHCIFWorkLoad", "getAdmByOrdId", TreatAdmDr);
		if (TreatAdmDr == "") {
			if (alertFlag != false) {
				alert("请选择一条医嘱!");
			}
			return;
		}

		if (true) {
			var userId = session['LOGON.USERID'];
			var locId = session['LOGON.CTLOCID'];
			var seatFlag = parent.parent.frames["TreatLeft"].document.getElementById("seatFlag").value;
			var serverIP = parent.parent.frames["TreatLeft"].document.getElementById("serverIP").value;
			var ClientStr = tkMakeServerCall("web.DHCVISTreatQueue", "GetClientStr", serverIP);
			var start = new RegExp(/^\d+/);
			var ClientID = start.exec(ClientStr)
			var parr = "TreatLocDr|" + locId + "^TreatRecUser|" + userId + "^TreatQueState|Wait^TreatQuePrior|2^TreatQueDate|^TreatQueTime|" + "^TreatQueueCat|" + ClientID + "^TreatReportType|" + queryTypeCode + "^RegNo|" + regNo+"^SeatFlag|" + seatFlag + "^TreatServerIP|"+serverIP;;
			var resStr = tkMakeServerCall("User.DHCNurTreatQueue", "Save", "", parr);
			if (resStr != 0) {
				if (alertFlag != false) {
					alert(resStr);
				}
				return;
			} else {
				var regNo = parent.frames["NurseTop"].document.getElementById("regNo").value;

				///DHCCNursePrintComm.
				showOtherSingleSheet(regNo + "$" + TreatAdmDr + "$" + session['LOGON.CTLOCID'], "BedCard", session['WebIP'], "NurseOrderOP.xml");
				//PrintQueueNo(TreatAdmDr, locId, ClientId)
				if (parent.parent.frames["TreatLeft"]) {
					parent.parent.frames["TreatLeft"].RefreshFn();
				}
				var curAdm = tkMakeServerCall("Nur.Infusion.DHCIFWorkLoad", "getCurrAdm", regNo);
				if (queryTypeCode == "SYDO") {
					//插入工作量
					if (ClientTyp == "T1") {
						var ret = tkMakeServerCall("Nur.Infusion.DHCIFWorkLoad", "InsertWork", curAdm, 5, session['LOGON.USERID'], session['LOGON.CTLOCID'], 0, "O");
					} else {
						var ret = tkMakeServerCall("Nur.Infusion.DHCIFWorkLoad", "InsertWork", curAdm, 5, session['LOGON.USERID'], session['LOGON.CTLOCID'], 0, "E");
					}
				}
			}
		}
	}



	///DHCCNursePrintComm.
	showNurseExcuteSheetPreview(oeoriIdStr, seqNoStr, "T", queryTypeCode, session['WebIP'], "true", 1, "NurseOrderOP.xml")
	//if (DHCCNursePrintComm.saveFlag == 1) {
		SetPrintFlag(oeoriIdStr, "T");
		SavePrintRecord("T", queryTypeCode, oeoriIdStr, session['LOGON.USERID']);
		if (parent.parent.frames["TreatLeft"]) {
			var ifSYCall = parent.parent.frames["TreatLeft"].document.getElementById("ifSYCall");
			if (ifSYCall && (ifSYCall.value == 1) && hasNotPrint) {
				ClientTyp = (ClientTyp == "呼叫终端未授权!") ? "" : ClientTyp;
				TreatQueueFn(false);
			}
		}
	//}
	//DHCCNursePrintComm.showNurseExcuteSheetPreview(oeoriIdStr,seqNoStr,"T",queryTypeCode,session['WebIP'],"true",1,"NurseOrderOPInfusionLabel.xml") 	

}

function PrintTPQList() {
	//var queryTypeCode = document.getElementById('queryTypeCode').value;
	var objSeatNo = parent.frames["NurseTop"].document.getElementById("SeatNo");
	if (objSeatNo) SeatNo = objSeatNo.value;
	var objtbl = document.getElementById('tDHCNUROPEXEC');
	var oeoriIdStr = "",
		seqNoStr = "";
	var notFyStr = "",
		hasNotPrint = false;
	for (i = 0; i < serverOrderID.length; i++) {
		var oeoriId = serverOrderID[i];
		var tmpOrderDataList = serverOrderData[i].split("^");
		var printFlag = tmpOrderDataList[9];
		var seqNo = oeoriId;

		if (oeoriId != "") // 界面上勾选后 oeoriId 才不为空
		{

			if ((printFlag.indexOf("T") == -1) && (hasNotPrint == false)) hasNotPrint = true;

			var fyFlag = tkMakeServerCall("web.DHCOutPhCommon", "GetfyflagforNurse", oeoriId);
			if (fyFlag == "0") {
				notFyStr = "患者有未发药的医嘱,请到药房取药！";
				continue;
			}
		}
		var oeoriIdretstr = tkMakeServerCall("Nur.NurseExcuteSheet", "getOrderGroupIdStr", oeoriId);
		//alert(oeoriIdretstr)
		var oeoriIdretstrList = oeoriIdretstr.split("#");
		var oeoriId = oeoriIdretstrList[0];
		var seqNo = oeoriIdretstrList[1];
		if (oeoriId != "") {
			if (oeoriIdStr.length == 0) {
				oeoriIdStr = oeoriId;
			} else {
				oeoriIdStr = oeoriIdStr + "^" + oeoriId;
			}
			if (seqNoStr.length == 0) {
				seqNoStr = seqNo;
			} else {
				seqNoStr = seqNoStr + "^" + seqNo;
			}
		}
	}

	if (notFyStr != "") {
		alert(notFyStr);
	}

	if (oeoriIdStr == "") {
		alert("没有需要打印的医嘱,请选择医嘱！");
		return;
	}
	//TreatQueueFn(false);


	//var regNo = parent.frames["NurseTop"].document.getElementById("regNo").value;
	//DHCCNursePrintComm.showOtherSingleSheet(regNo + "$$" + session['LOGON.CTLOCID'], "BedCard", webIP, "NurseOrderOP.xml", "2");
	//DHCCNursePrintComm.showNurseExcuteSheetPreview(oeoriIdStr, seqNoStr, "T", queryTypeCode, session['WebIP'], "true", 1, "NurseOrderOP.xml");
	showNurseExcuteSheetPreview(oeoriIdStr, seqNoStr, "T", queryTypeCode, session['WebIP'], "true", 1, "NurseOrderOP.xml");
	//DHCCNursePrintComm.showNurseExcuteSheetPreview(oeoriIdStr, seqNoStr, "T", queryTypeCode, session['LOGON.HOSPID'], true, 1, webIP, "true", 1, "NurseOrderOP.xml");
//	if (DHCCNursePrintComm.saveFlag == 1) {
		SetPrintFlag(oeoriIdStr, "T");
		SavePrintRecord("T", queryTypeCode, oeoriIdStr, session['LOGON.USERID']);
		if (parent.parent.frames["TreatLeft"]) {
			var ifSYCall = parent.parent.frames["TreatLeft"].document.getElementById("ifSYCall");
			if (ifSYCall && (ifSYCall.value == 1) && hasNotPrint) {
				ClientTyp = (ClientTyp == "呼叫终端未授权!") ? "" : ClientTyp;
				TreatQueueFn(false);
			}
		}
	//}
	//var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurOPExec";
	parent.frames['OrdList'].location.href = parent.frames['OrdList'].location.href;
	//var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurOPExecTitle";
	//parent.frames['NurseTop'].location.href = lnk;
	//ClearScreen();
}



function ClearScreen() {
	parent.frames['NurseTop'].document.getElementById("regNo").value = "";
	parent.frames['NurseTop'].document.getElementById("CardNo").value = "";
	parent.frames['NurseTop'].document.getElementById("patMainInfo").value = "";
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurOPExecTitle";
	parent.frames['NurseTop'].location.href = lnk;
}

function PatInfoCardClick() {
	TreatQueueFn(false);
	var regNo = parent.frames["NurseTop"].document.getElementById("regNo").value;
	//DHCCNursePrintComm.
	showOtherSingleSheet(regNo + "$$" + session['LOGON.CTLOCID'], "BedCard", session['WebIP'], "NurseOrderOP.xml");
	//DHCCNursePrintComm.showOtherSingleSheet(regNo + "$$" + session['LOGON.CTLOCID'], "BedCard", webIP, "NurseOrderOP.xml", "2");
}



function printSYCard() {
	var queryTypeCode = document.getElementById('queryTypeCode').value;
	var objSeatNo = parent.frames["NurseTop"].document.getElementById("SeatNo");
	var objtbl = document.getElementById('tDHCNurOPExec');
	var oeoriIdStr = "",
		seqNoStr = "";
	var printedId = new Array();
	for (i = 1; i < objtbl.rows.length; i++) {
		var check = document.getElementById('seleitemz' + i);
		var oeoriId = document.getElementById('oeoriIdz' + i).innerText;
		var seqNo = document.getElementById('tmpSeqNoz' + i).innerText;
		var PrintFlag = document.getElementById('tmpPrtFlagz' + i).innerText;
		var orderStrList = oeoriId.split("||");
		if (check.checked == true) {

			if (printedId[orderStrList[0] + "||" + orderStrList[1]]) {
				continue;
			}
			if (oeoriIdStr.length == 0) {
				oeoriIdStr = oeoriId;
			} else {
				oeoriIdStr = oeoriIdStr + "^" + oeoriId
			}
			if (seqNoStr.length == 0) {
				seqNoStr = seqNo;
			} else {
				seqNoStr = seqNoStr + "^" + seqNo
			}
			printedId[orderStrList[0] + "||" + orderStrList[1]] = 1;

		}
	}
	if (oeoriIdStr == "") {
		alert("请选择医嘱！");
		return;
	}
	///DHCCNursePrintComm.showNurseExcuteSheetPreview(oeoriIdStr, seqNoStr, "S", queryTypeCode, session['WebIP'], "true", 1, "NurseOrderOP.xml")
	showNurseExcuteSheetPreview(oeoriIdStr, seqNoStr, "S", queryTypeCode, session['WebIP'], "true", 1, "NurseOrderOP.xml")
	if (DHCCNursePrintComm.saveFlag == 1) {
		SetPrintFlag(oeoriIdStr, "S");
		SavePrintRecord("S", queryTypeCode, oeoriIdStr, session['LOGON.USERID']);
	}

}

function printNurseSheet() {
	var queryTypeCode = document.getElementById('queryTypeCode').value;
	var objSeatNo = parent.frames["NurseTop"].document.getElementById("SeatNo");
	var objtbl = document.getElementById('tDHCNurOPExec');
	var oeoriIdStr = "",
		seqNoStr = "";
	var printedId = new Array();
	for (i = 1; i < objtbl.rows.length; i++) {
		var check = document.getElementById('seleitemz' + i);
		var oeoriId = document.getElementById('oeoriIdz' + i).innerText;
		var seqNo = document.getElementById('tmpSeqNoz' + i).innerText;
		var PrintFlag = document.getElementById('tmpPrtFlagz' + i).innerText;

		var orderStrList = oeoriId.split("||");
		if (check.checked == true) {
			if (printedId[orderStrList[0] + "||" + orderStrList[1]]) {
				continue;
			}
			if (oeoriIdStr.length == 0) {
				oeoriIdStr = oeoriId;
			} else {
				oeoriIdStr = oeoriIdStr + "^" + oeoriId
			}
			if (seqNoStr.length == 0) {
				seqNoStr = seqNo;
			} else {
				seqNoStr = seqNoStr + "^" + seqNo
			}
			printedId[orderStrList[0] + "||" + orderStrList[1]] = 1;
		}
	}
	if (oeoriIdStr == "") {
		alert("请选择医嘱！");
		return;
	}
	var type = "PAT"
	var ifPrintAllObj = document.getElementById("ifPrintAll");
	if (ifPrintAllObj && (ifPrintAllObj.value == "1")) {
		type = "PATALL"
	}
	///	DHCCNursePrintComm.showNurseExcuteSheetPreview(oeoriIdStr, seqNoStr, type, queryTypeCode, session['WebIP'], "true", 1, "NurseOrderOP.xml")
	showNurseExcuteSheetPreview(oeoriIdStr, seqNoStr, type, queryTypeCode, session['WebIP'], "true", 1, "NurseOrderOP.xml")
	//if (DHCCNursePrintComm.saveFlag == 1) {
		SetPrintFlag(oeoriIdStr, "Y");
		SavePrintRecord("PAT", queryTypeCode, oeoriIdStr, session['LOGON.USERID']);
	//}
	//DHCCNursePrintComm.showNurseExcuteSheetPreview(oeoriIdStr,seqNoStr,"T",queryTypeCode,session['WebIP'],"true",1,"NurseOrderOP.xml")	

}


function PrintBar() //lVXIN 2013-10-29
	{
		var queryTypeCode = document.getElementById('queryTypeCode').value;
		var objtbl = document.getElementById('tDHCNurOPExec');
		var labNoStr = "",
			oeorIdStr = "";
		var selectFlag = false;
		var recLab = ""; //接收标本存储 add by linyuxu
		for (i = 1; i < objtbl.rows.length; i++) {
			var check = document.getElementById('seleitemz' + i);
			if (check.checked == true) {
				var labNo = document.getElementById('labNoz' + i).innerText.replace(/\s+/g, "");
				if (labNo == "") {
					alert("标本号为空请联系网络中心")
					return;
				}
				var oeoriId = document.getElementById('oeoriIdz' + i).innerText;

				var disposeStatCode = document.getElementById('disposeStatCodez' + i).innerText;
				if (disposeStatCode == "UnPaid") {
					alert("有未交费医嘱!不能打印")
					return;
				}
				selectFlag = true;
				//判断检验科是否接受 add by linyuxu
				var ifRecLab = tkMakeServerCall("web.DHCLCNUREXCUTE", "ifLabReceive", labNo);
				if (ifRecLab == 1) {
					if (recLab.indexOf(labNo) == -1) {
						if (recLab == "") {
							recLab = labNo;
						} else {
							retLab = recLab + "," + labNo;
						}
					}

					continue;
				}
				//end
				if (labNoStr == "") {
					labNoStr = labNo;
				} else {
					labNoStr = labNoStr + "^" + labNo;
				}
				if (oeorIdStr == "") {
					oeorIdStr = oeoriId;
				} else {
					oeorIdStr = oeorIdStr + "^" + oeoriId;
				}
			}
		}
		//add by linyuxu
		if ((oeorIdStr == "") && (selectFlag)) {
			alert("检验号为" + recLab + "的样本已被检验科接收,如需打印条码,请致电检验科接收室取消接收此项目");
			return;
		}
		if (!selectFlag) {
			alert("请选择需要打印的医嘱");
			return;
		}
		//end
		var sortStr = sortByLabNo(oeorIdStr, labNoStr)
		var sortStrArray = sortStr.split("@");
		oeorIdStr = sortStrArray[0];
		labNoStr = sortStrArray[1];
		///DHCCNursePrintComm.
		showNurseExcuteSheetPreview(oeorIdStr, labNoStr, "P", queryTypeCode, session['WebIP'], "true", 1, "NurseOrderOP.xml")
		////调用病理接口
		/*if((queryTypeCode=="BLDO")&&(labNoStr!="")){
			var rtn1 = tkMakeServerCall("web.DHCPisApplicationSheet", "UpdateTmOurINfo",session['LOGON.CTLOCID'],labNoStr);
			var rtn2 = tkMakeServerCall("web.DHCPisApplicationSheet", "UpdateResult1",labNoStr);
		}*/
		//if (DHCCNursePrintComm.saveFlag == 1) {

			SetPrintFlag(oeorIdStr, "P");
			SavePrintRecord("P", queryTypeCode, oeorIdStr, session['LOGON.USERID']);
		//}
		var ifPrintJYHZD = tkMakeServerCall("web.DHCLCNURCOLUMNSETPRINT", "getIfPrintJYHZD");
		if ((ifPrintJYHZD == 1)&&(queryTypeCode=="JYDO")) {
			var printStr = tkMakeServerCall("Nur.NurseExcuteSheet", "DeleRepOrd", oeorIdStr);
			var printord = printStr.split("$");
			var PrintOeordStr = printord[0];
			var printLabStr = printord[1];


			//打印回执单 待加配置
			///DHCCNursePrintComm.
			showNurseExcuteSheetPreview(PrintOeordStr, printLabStr, "L", queryTypeCode, session['WebIP'], "true", 1, "LabOrderSheet.xml");

		}



		//add by linyuxu
		if (recLab != "") {
			alert("检验号为" + recLab + "的样本已被检验科接收,如需打印条码,请致电检验科接收室取消接收此项目");
		}
		//end
	}

function sortByLabNo(oeorIdStr, labNoStr) {
	var oeordIdArray = oeorIdStr.split("^")
	var labNoArray = labNoStr.split("^")
	var tmpLabNo = ""
	var tmpOeordId = "";
	var index = "";
	var tmpLabNoArray = [];
	var tmpOrderIdArray = [];
	var tmpCollectArray = [];
	for (var i = 0; i < oeordIdArray.length; i++) {
		if (!tmpCollectArray[i]) {
			tmpOrderIdArray[tmpOrderIdArray.length] = oeordIdArray[i]
			tmpLabNoArray[tmpLabNoArray.length] = labNoArray[i]
		} else {
			continue;
		}
		for (var j = i + 1; j < oeordIdArray.length; j++) {
			if ((labNoArray[i] == labNoArray[j]) && (!tmpCollectArray[j])) {
				tmpOrderIdArray[tmpOrderIdArray.length] = oeordIdArray[j]
				tmpLabNoArray[tmpLabNoArray.length] = labNoArray[j]
				tmpCollectArray[j] = 1
			}
		}
	}
	return tmpOrderIdArray.join("^") + "@" + tmpLabNoArray.join("^")
}

function DOCOnKeyDown() {
	if ((event.keyCode == 119)) {
		parent.window.frames["NurseTop"].ReadCard_Click();
	}
}

function SetPrintFlag(oeoriIdStr, printFlag) {


	if (oeoriIdStr != "") {
		if (!printFlag) {
			printFlag = "Y"
		}
		var Wardid = tkMakeServerCall("web.PACWard", "GetWardFromLoc", session['LOGON.CTLOCID']) //
		resStr = tkMakeServerCall("web.DHCNurCom", "SetPrintFlagNew", Wardid, session['LOGON.USERID'], queryTypeCode, oeoriIdStr, printFlag);

	}
}

function SavePrintRecord(printType, queryTypeCode, OrderStr, UserId) {
	var ModelName;
	if (printType == "P") {
		ModelName = "DHCNurOPExecP"; ///模块代码，DHC_EventModel表中Code
	} else if (printType == "PAT") {
		ModelName = "DHCNurOPExecPAT";
	} else if (printType == "S") {
		ModelName = "DHCNurOPExecS";
	} else if (printType == "T") {
		ModelName = "DHCNurOPExecT";
	}
	var SecretCode = ""
	var ret = tkMakeServerCall("web.DHCCLCom", "SaveRecord", ModelName, OrderStr, printType, queryTypeCode, SecretCode, UserId)
		//alert(ret)
}
document.onkeydown = DOCOnKeyDown;