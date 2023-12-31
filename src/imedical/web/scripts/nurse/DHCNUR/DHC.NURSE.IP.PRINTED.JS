document.write("<script language='javascript' src='../scripts/nurse/DHCNUR/DHCNurPrintClickOnce.js'></script>");

/// Creator:      pengjunfu
/// CreatDate:    2013.08.15
/// Description:  新打印js
var printSetting = {
	'printCollectData': [], //需置打印标记的医嘱
	'printSeqNoData': [], //关联号
	'printLabNoData': [], //标本号
	'printIdData': [], //医嘱id
	'labReceiveData': [], //标本接收医嘱  add by linyuxu
	'findedFlag': [],
	"save": true, //是否置打印标记
	'queryTypeCode': "", //单据代码
	'printFlag': "", //打印标记
	"printType": "PAT" //打印类型 按病区打印:WARD  按病人:PAT  条码:P  贴瓶签:T
}

function clearPrintSetting() {
	printSetting.printCollectData = [];
	printSetting.printSeqNoData = [];
	printSetting.printLabNoData = [];
	printSetting.printIdData = [];
	printSetting.labReceiveData = []; //add by linyuxu
	printSetting.findedFlag = [];
	printSetting.queryTypeCode = "";
	printSetting.printFlag = "";
	printSetting.save = true;
	printSetting.printType = "PAT";
}

function QueryPrintData(printFlag, flag) {
	//赋值查询时间范围
	if(parent&&parent.Ext){
		var Ext=parent.Ext;
		DHCCNursePrintComm.searchRange=Ext.getCmp("startDate").getRawValue()
		+"--"
		+Ext.getCmp("endDate").getRawValue();
	}
	DHCCNursePrintComm.userName=session['LOGON.USERNAME'];

	if (!printFlag) {
		printFlag = "Y"
	}
	var tmpList = new Array();
	var retStr = t['alert:noPrintData'];
	var TmpNum = serverOrderData.length - 1;
	var tem = new Array();
	var temstr;
	clearPrintSetting();
	var checked = getIfCheck();
	var oeordId = "";
	var rows = 0
	var recLabNo = ""; //add by linyuxu
	for (j = 1; j <= TmpNum; j++) {
		var itemData = serverOrderData[j];
		tmpList = (itemData).split("!");
		temstr = tmpList[tmpList.length - 6] + "!" + tmpList[tmpList.length - 3] + "!" + tmpList[tmpList.length - 1] + "!" + tmpList[arcimDescInd]
		tem = temstr.split("!");
		var disposeStatCode = tmpList[tmpList.length - 4]
		if ((((checked === false) && (tem[1].indexOf(printFlag) < 0)) || ((checked === true) && (checkData[j] === true))) && (disposeStatCode != "ExecDiscon")) {
			var tempIdArray = tmpList[tmpList.length - 6].split("||");

			//add by linyuxu
			if ((labNoInd != -1)&&(tmpList[labNoInd]!="")) {

				var ifLabRec = tkMakeServerCall("web.DHCLCNUREXCUTE", "ifLabReceive", tmpList[labNoInd]);
				if (ifLabRec == 1) {
					if (recLabNo.indexOf(tmpList[labNoInd]) == -1) {

						if (recLabNo == "") {
							recLabNo = tmpList[labNoInd];
						} else {
							recLabNo = recLabNo + "," + tmpList[labNoInd];
						}
						printSetting.labReceiveData[printSetting.labReceiveData.length] = tmpList[labNoInd];
					}

					continue;
				}

			}
			//end

			printSetting.printCollectData[printSetting.printCollectData.length] = tmpList[tmpList.length - 6]
				//多条执行记录过滤同一天的
			if (printSetting.findedFlag[tempIdArray[0] + "||" + tempIdArray[1] + "||" + tmpList[tmpList.length - 1]] != undefined) {
				if (flag) {
					continue;
				}
			}

			printSetting.printSeqNoData[printSetting.printSeqNoData.length] = tmpList[tmpList.length - 2]; //关联号
			printSetting.printLabNoData[printSetting.printLabNoData.length] = tmpList[labNoInd];
			printSetting.printIdData[printSetting.printIdData.length] = tmpList[tmpList.length - 6];
			printSetting.findedFlag[tempIdArray[0] + "||" + tempIdArray[1] + "||" + tmpList[tmpList.length - 1]] = 1
			rows = rows + 1
			myData[rows - 1] = tem
		}
	}
	if (myData.length != 0) {
		retStr = 0;
	}
	return retStr;
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

function NurseExcuteSheetPrint() {
	//seqNoStr 检验条码是printSetting.printLabNoData.join("^")  其他都是printSetting.printSeqNoData.join("^")
	var seqNoStr;
	if (printSetting.printType == "P") {
		var sortStr = sortByLabNo(printSetting.printIdData.join("^"), printSetting.printLabNoData.join("^"))
		var sortStrArray = sortStr.split("@");
		seqNoStr = sortStrArray[1];
		if((printSetting.queryTypeCode=="BLD")&&(seqNoStr=="")){
			alert("病理标本号为空!");
			return;
		}
		///clickOnce打印方式
		showNurseExcuteSheetPreview(sortStrArray[0], seqNoStr, printSetting.printType, printSetting.queryTypeCode, session['WebIP'], printSetting.save, 1, "NurseOrder.xml");
		///dll打印方式
		///DHCCNursePrintComm.showNurseExcuteSheetPreview(sortStrArray[0], seqNoStr, printSetting.printType, printSetting.queryTypeCode, session['WebIP'], printSetting.save, 1, "NurseOrder.xml")
		////调用病理接口
		if((printSetting.queryTypeCode=="BLD")&&(seqNoStr!="")){
			var rtn1 = tkMakeServerCall("web.DHCPisApplicationSheet", "UpdateTmOurINfo",session['LOGON.CTLOCID'],seqNoStr);
			var rtn2 = tkMakeServerCall("web.DHCPisApplicationSheet", "UpdateResult1",seqNoStr);
		}
	} else {
		seqNoStr = printSetting.printSeqNoData.join("^");
		//DHCCNursePrintComm.
		///ClickOnce打印方式(如需继续使用原来dll打印方式可直接在前面加DHCCNursePrintComm.)
		showNurseExcuteSheetPreview(printSetting.printIdData.join("^"), seqNoStr, printSetting.printType, printSetting.queryTypeCode, session['WebIP'], printSetting.save, 1, "NurseOrder.xml")
	}


	//if (DHCCNursePrintComm.saveFlag == 1) {
		printSetting.printCollectData = printSetting.printCollectData.join("^")
		if (printSetting.printCollectData.length > 0) {

			SavePrintRecord(printSetting.printType, printSetting.queryTypeCode, printSetting.printIdData.join("^"), session['LOGON.USERID'])

			SetPrintFlag(printSetting.printCollectData, printSetting.printFlag);
			tkMakeServerCall("Nur.NursePrintRecord", "save", printSetting.printCollectData, seqNoStr, printSetting.queryTypeCode, printSetting.printFlag, session['LOGON.CTLOCID'], session['LOGON.USERID'], session['StartDate'], session['startTime'], session['EndDate'], session['endTime'])
		}
	//}
	self.location.reload();
	//setTimeout('self.location.reload()',10000);
	return;
}

function PrintSJD(queryTypeCode, typ, RpDes) {
	var resStr = QueryPrintData("Y");
	if (resStr != "0") {
		alert(resStr);
		return;
	}
	////DHCCNursePrintComm.
	showSJD(printSetting.printIdData.join("^"), "NurseSheetSJD", session['WebIP'], "NurseOrder.xml")
}

function PrintRp(queryTypeCode, typ, RpDes) {
	var resStr = QueryPrintData("Y");
	if (resStr != "0") {
		alert(resStr);
		return;
	}
	if (queryTypeCode) {
		printSetting.queryTypeCode = queryTypeCode
	}
	if (printSetting.printFlag == "") {
		printSetting.printFlag = "Y";
	}
	printSetting.printType = "PAT";
	NurseExcuteSheetPrint()
}

function PrintRpByWard(queryTypeCode, typ, RpDes) {
	var resStr = QueryPrintData("Y");
	if (resStr != "0") {
		alert(resStr);
		return;
	}
	if (queryTypeCode) {
		printSetting.queryTypeCode = queryTypeCode
	}
	if (printSetting.printFlag == "") {
		printSetting.printFlag = "Y";
	}
	printSetting.printType = "WARD";
	NurseExcuteSheetPrint()
}

function PrintBar() {
	//alert("lvxin_printbar")
	var resStr = QueryPrintData("P");
	//change by linyuxu
	if (resStr != "0") {
		if (printSetting.labReceiveData.length != 0) {
			alert("检验号为" + printSetting.labReceiveData.join(",") + "的样本已被检验科接收,如需打印条码,请致电检验科接收室取消接收此项目");
		} else {
			alert(resStr);
		}
		return;
	}
	//end
	if (queryTypeCode) {
		printSetting.queryTypeCode = queryTypeCode;
	}
	if (printSetting.printFlag == "") {
		printSetting.printFlag = "P";
	}
	printSetting.printType = "P";
	NurseExcuteSheetPrint();
	//add by linyuxu
	if (printSetting.labReceiveData.length != 0) {
		alert("检验号为" + printSetting.labReceiveData.join(",") + "的样本已被检验科接收,如需打印条码,请致电检验科接收室取消接收此项目");
	}
}

function PrintSelSYCARD() {
	var resStr = QueryPrintData("T");
	if (resStr != "0") {
		alert(resStr);
		return;
	}
	if (queryTypeCode) {
		printSetting.queryTypeCode = queryTypeCode
	}
	if (printSetting.printFlag == "") {
		printSetting.printFlag = "T";
	}
	printSetting.printType = "T";
	NurseExcuteSheetPrint()
}

function PrintBedCard() {
	var resStr = QueryPrintData("S", true);
	if (resStr != "0") {
		alert(resStr);
		return;
	}
	if (queryTypeCode) {
		printSetting.queryTypeCode = queryTypeCode
	}
	if (printSetting.printFlag == "") {
		printSetting.printFlag = "S";
	}
	printSetting.printType = "S";
	NurseExcuteSheetPrint()
}

function SetPrintFlag(oeoriIdStr, printFlag) {


	if (oeoriIdStr != "") {
		if (!printFlag) {
			printFlag = "Y"
		}
		var Ward = tkMakeServerCall("web.PACWard", "GetWardFromLoc", session['LOGON.CTLOCID']) //g
		resStr = tkMakeServerCall("web.DHCLCNUREXCUTE", "SetPrintFlag", Ward, session['LOGON.USERID'], queryTypeCode, oeoriIdStr, printFlag);

	}
}

function SavePrintRecord(printType, queryTypeCode, OrderStr, UserId) {
	var ModelName;
	if (printType == "P") {
		ModelName = "DHCNurIPExecP"; ///模块代码，DHC_EventModel表中Code
	} else if (printType == "PAT") {
		ModelName = "DHCNurIPExecPAT";
	} else if (printType == "S") {
		ModelName = "DHCNurIPExecS";
	} else if (printType == "T") {
		ModelName = "DHCNurIPExecT";
	} else if (printType == "WARD") {
		ModelName = "DHCNurIPExecWARD";
	}
	var SecretCode = ""
	var ret = tkMakeServerCall("web.DHCCLCom", "SaveRecord", ModelName, OrderStr, printType, queryTypeCode, SecretCode, UserId)
		//alert(ret)
}