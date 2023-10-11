/// Creator:      pengjunfu
/// CreatDate:    2013.08.15
/// Description:  新打印js
var operationObject = {
	'oeordIdArray': [], //医嘱id
	'oeoreIdArray': [], //执行记录id
	'unFilterOeoreIdArray': [], //未过滤同一天后的医嘱执行ID
	'seqNoArray': [], //关联号
	'labNoArray': [], //标本号
	'findedFlag': [],
	"saveFlag": true, //是否置打印记录
	'queryTypeCode': "", //单据代码
	'printFlag': "", //打印标记
	"printType": "PAT", //打印类型 按病区打印:WARD  按病人:PAT  条码:P  贴瓶签:T
	"userId1": "",
	"userId2": "",
	"operationType": ""

}

function clearOperationObject() {
	operationObject.oeordIdArray = [];
	operationObject.oeoreIdArray = [];
	operationObject.unFilterOeoreIdArray = [];
	operationObject.seqNoArray = [];
	operationObject.labNoArray = [];
	operationObject.findedFlag = [];
	operationObject.queryTypeCode = "";
	operationObject.printFlag = "";
	operationObject.saveFlag = true;
	operationObject.printType = "PAT";
	operationObject.userId1 = "";
	operationObject.userId2 = "";
	operationObject.operationType = "";
}
//判断是否有选择
function getIfCheck() {

	var store = Ext.getCmp("orderGrid").getStore();
	var sm = Ext.getCmp("orderGrid").getSelectionModel();
	do {
		if (sm.getCount() > 0) {
			return true;
		}
		for (var i = 0; i < store.getCount(); i++) {
			var record = store.getAt(i);
			var exec = record.json["execs"];
			for (var j = 0; j < exec.length; j++) {
				if (exec[j]["check"] == 1) {
					return true;
				}
			}
		}

	} while (false)
	return false;
}

function QueryPrintData(printFlag, flag) {

	if (!printFlag) {
		printFlag = "Y"
	}
	var store = Ext.getCmp("orderGrid").getStore();
	var tmpList = new Array();
	var retStr = "没有打印数据";
	var tem = new Array();
	var temstr;
	
	var checked = getIfCheck();
	var oeordId = "";
	var rows = 0
	for (var i = 0; i < store.getCount(); i++) {
		var record = store.getAt(i);
		for (var j = 0; j < record.json["execs"].length; j++) {
			var mainExec = record.json["execs"][j];
			var disposeStatCode = mainExec["disposeStatCode"];
			//var printFlag = mainExec["prtFlag"];
			if ((((checked === false) && (mainExec["prtFlag"].indexOf(printFlag) < 0)) || ((checked === true) && (mainExec["check"] == "1"))) && (disposeStatCode != "ExecDiscon")) {
				var tempIdArray = mainExec["oeoreId"].split("||");

				//多条执行记录过滤同一天的
				if (operationObject.findedFlag[tempIdArray[0] + "||" + tempIdArray[1] + "||" + mainExec["sttDate"]] != undefined) {
					if (flag) {
						//循环取过滤同一天的成组医嘱ID
						for (var k = 0; k < record.json["orderNum"]; k++) {
							var printExec = store.getAt(i + k).json["execs"][j];
							operationObject.unFilterOeoreIdArray[operationObject.unFilterOeoreIdArray.length] = printExec["oeoreId"];
						}
						continue;
					}
				}
				//循环取成组医嘱ID
				for (var k = 0; k < record.json["orderNum"]; k++) {
					var printExec = store.getAt(i + k).json["execs"][j];
					operationObject.seqNoArray[operationObject.seqNoArray.length] = printExec["seqNo"]; //关联号
					operationObject.labNoArray[operationObject.labNoArray.length] = store.getAt(i + k).json["labNo"];
					operationObject.oeoreIdArray[operationObject.oeoreIdArray.length] = printExec["oeoreId"];
					operationObject.findedFlag[tempIdArray[0] + "||" + tempIdArray[1] + "||" + mainExec["sttDate"]] = 1

					//取未过滤同一天的成组医嘱ID
					operationObject.unFilterOeoreIdArray[operationObject.unFilterOeoreIdArray.length] = printExec["oeoreId"];

					rows = rows + 1
				}

			}
		}
	}
	if (rows != 0) {
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
	//seqNoStr 检验条码是printSetting.labNoArray.join("^")  其他都是printSetting.seqNoArray.join("^")
	if (operationObject.oeoreIdArray.length == 0) {
		var resStr = QueryPrintData(operationObject.printFlag);
			if (resStr != "0") {
				alert(resStr);
				return;
			}
		}
		
		var seqNoStr;
		if (operationObject.printType == "P") {
			var sortStr = sortByLabNo(operationObject.unFilterOeoreIdArray.join("^"), operationObject.labNoArray.join("^"))
			var sortStrArray = sortStr.split("@");
			seqNoStr = sortStrArray[1];
			DHCCNursePrintComm.showNurseExcuteSheetPreview(sortStrArray[0], seqNoStr, operationObject.printType, operationObject.queryTypeCode, session['webIp'], operationObject.saveFlag, 1, "NurseOrder.xml")
		} else {
			seqNoStr = operationObject.seqNoArray.join("^");
			DHCCNursePrintComm.showNurseExcuteSheetPreview(operationObject.oeoreIdArray.join("^"), seqNoStr, operationObject.printType, operationObject.queryTypeCode, session['webIp'], operationObject.saveFlag, 1, "NurseOrder.xml")
		}
        ///病人密级
        if (DHCCNursePrintComm.saveFlag == 1)
		{
		SavePrintRecord(operationObject.printType,operationObject.queryTypeCode,operationObject.oeoreIdArray.join("^"),session['LOGON.USERID'])
		}
		if ((DHCCNursePrintComm.saveFlag == 1)&&(operationObject.saveFlag==true)) {
			
			operationObject.unFilterOeoreIdArray = operationObject.unFilterOeoreIdArray.join("^")
			if (operationObject.unFilterOeoreIdArray.length > 0) {
				SetPrintFlag(operationObject.unFilterOeoreIdArray, operationObject.printFlag, operationObject.queryTypeCode);
				
				tkMakeServerCall("Nur.NurseOperationRecord", "save",
					operationObject.unFilterOeoreIdArray,
					operationObject.operationType,
					operationObject.queryTypeCode,
					operationObject.printType,
					operationObject.printFlag,
					session['LOGON.CTLOCID'],
					operationObject.userId1,
					operationObject.userId2,
					session['startDate'],
					session['startTime'],
					session['endDate'],
					session['endTime'])
			}
	  Ext.getCmp("orderGrid").getStore().reload();  //20141217
		}
      if (Ext.getCmp("signWindow")) Ext.getCmp("signWindow").close();  ///关闭弹出窗口
		return;
	}

if(Func==undefined){
	var Func=[];
}

	Func["PrintSJD"] = function PrintSJD(queryTypeCode, operationType, object) {
		operationObject.queryTypeCode = queryTypeCode
		operationObject.printFlag = "I";
		operationObject.printType = "I";
		operationObject.userId1 = object.userId1;
		operationObject.userId2 = object.userId2;
		operationObject.operationType = operationType;
		NurseExcuteSheetPrint()
		//DHCCNursePrintComm.showSJD(operationObject.unFilterOeoreIdArray.join("^"), "NurseSheetSJD", session['WebIP'], "NurseOrder.xml")
	}

	Func["PrintRp"] = function PrintRp(queryTypeCode, operationType, object) {
		operationObject.queryTypeCode = queryTypeCode
		operationObject.printFlag = "Y";
		operationObject.printType = "PAT";
		operationObject.userId1 = object.userId1;
		operationObject.userId2 = object.userId2;
		operationObject.operationType = operationType;
		NurseExcuteSheetPrint()
	}

	Func["PrintRpByWard"] = function PrintRpByWard(queryTypeCode, operationType, object) {
		operationObject.queryTypeCode = queryTypeCode
		operationObject.printFlag = "Y";
		operationObject.printType = "WARD";
		operationObject.userId1 = object.userId1;
		operationObject.userId2 = object.userId2;
		operationObject.operationType = operationType;
		NurseExcuteSheetPrint()
	}

	Func["PrintBar"] = function PrintBar(queryTypeCode, operationType, object) {
		operationObject.queryTypeCode = queryTypeCode
		operationObject.printFlag = "P";
		operationObject.printType = "P";
		operationObject.userId1 = object.userId1;
		operationObject.userId2 = object.userId2;
		operationObject.operationType = operationType;
		NurseExcuteSheetPrint()
	}

	Func["PrintSelSYCARD"] = function PrintSelSYCARD(queryTypeCode, operationType, object) {
		operationObject.queryTypeCode = queryTypeCode
		operationObject.printFlag = "T";
		operationObject.printType = "T";
		operationObject.userId1 = object.userId1;
		operationObject.userId2 = object.userId2;
		operationObject.operationType = operationType;

		NurseExcuteSheetPrint()
	}

	Func["PrintBedCard"] = function PrintBedCard(queryTypeCode, operationType, object) {
		operationObject.queryTypeCode = queryTypeCode
		operationObject.printFlag = "S";
		operationObject.printType = "S";
		operationObject.userId1 = object.userId1;
		operationObject.userId2 = object.userId2;
		operationObject.operationType = operationType;

		NurseExcuteSheetPrint()
	}

	function SetPrintFlag(oeoriIdStr, printFlag, queryTypeCode) {
		if (oeoriIdStr != "") {
			if (!printFlag) {
				printFlag = "Y"
			}
			resStr = tkMakeServerCall("web.DHCLCNUREXCUTE", "SetPrintFlag", session['LOGON.WARDID'], session['LOGON.USERID'], queryTypeCode, oeoriIdStr, printFlag);

		}
	}
	function SavePrintRecord(printType,queryTypeCode,OrderStr,UserId)
	{
	    var ModelName;
		if (printType == "P")
		{
		ModelName="DHCNurIPExecP";  ///模块代码，DHC_EventModel表中Code
		}
		else if(printType == "PAT")
		{
		ModelName="DHCNurIPExecPAT";
		}
		else if(printType == "S")
		{
		ModelName="DHCNurIPExecS"; 
		}
		else if(printType == "T")
		{
		ModelName="DHCNurIPExecT"; 
		}
		else if(printType == "WARD")
		{
		ModelName="DHCNurIPExecWARD"; 
		}
		//var Condition=operationObject.printType+"#"+operationObject.queryTypeCode+"#"+operationObject.unFilterOeoreIdArray.join("^");   ///操作条件?
		var SecretCode=""
		var ret=tkMakeServerCall("web.DHCCLCom","SaveRecord",ModelName,OrderStr,printType,queryTypeCode,SecretCode,UserId)
		
	}