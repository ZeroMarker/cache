var gHospId = session['LOGON.HOSPID'];
var gUserId = session['LOGON.USERID'];
function PrintIngDret(ingrt, AutoFlag) {
	if (ingrt == null || ingrt == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	var mainData = GetIngrtMainData(ingrt);
	if (mainData == null || mainData == "") {
		return;
	}
	var mainArr = mainData.split("^");
	var ingrtLocId = mainArr[7];
	var ingrtScgId = mainArr[14];
	var qPar = "^asc";

	var PrintModeData = GetPrintMode(ingrtLocId, ingrtScgId);
	var PrintMode = PrintModeData.split("^")[0];
	var RaqName = 'DHCSTM_IngDret_Common.raq';
	if (PrintMode == 'MO') {
		RaqName = 'DHCSTM_IngDret_MO_Common.raq';
	}
	fileName = "{" + RaqName + "(qPar=" + qPar + ";INGRT=" + ingrt + ")}";

	var PrintNum = parseInt(IngrtParamObj.PrintNum);
	if (!Ext.isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	for (var i = 1; i <= PrintNum; i++) {
		if (IngrtParamObj.IndirPrint != "N") {
			var transfileName = TranslateRQStr(fileName);
			DHCSTM_DHCCPM_RQPrint(transfileName);
		} else {
			DHCCPM_RQDirectPrint(fileName);
		}
		Common_PrintLog('R', ingrt, AutoFlag);
	}
}
function PrintIngDretHVCol(ingrt, AutoFlag) {
	if (ingrt == null || ingrt == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	var mainData = GetIngrtMainData(ingrt);
	if (mainData == null || mainData == "") {
		return;
	}
	var mainArr = mainData.split("^");
	var ingrtLocId = mainArr[7];
	var ingrtScgId = mainArr[14];
	var qPar = "^asc";

	var PrintModeData = GetPrintMode(ingrtLocId, ingrtScgId);
	var PrintMode = PrintModeData.split("^")[0];
	var RaqName = 'DHCSTM_IngDretHVCol_Common.raq';
	if (PrintMode == 'MO') {
		RaqName = 'DHCSTM_IngDretHVCol_MO_Common.raq';
	}
	fileName = "{" + RaqName + "(qPar=" + qPar + ";INGRT=" + ingrt + ")}";

	var PrintNum = parseInt(IngrtParamObj.PrintNum);
	if (!Ext.isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	for (var i = 1; i <= PrintNum; i++) {
		if (IngrtParamObj.IndirPrint != "N") {
			var transfileName = TranslateRQStr(fileName);
			DHCCPM_RQPrint(transfileName);
		} else {
			DHCCPM_RQDirectPrint(fileName);
		}
		Common_PrintLog('R', ingrt, AutoFlag);
	}
}

function GetIngrtMainData(ingrt) {
	var mainData = "";
	if (ingrt == null || ingrt == '') {
		return;
	}

	var url = 'dhcstm.ingdretaction.csp?actiontype=getOrder&rowid=' + ingrt;
	var responseText = ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(responseText);
	if (jsonData.success == 'true') {
		mainData = jsonData.info;
	}

	return mainData;
}
function PrintMBPL(ingrt, HospID, user) {
	if (ingrt == null || ingrt == '') {
		return;
	}
	var url = 'dhcstm.ingdretaction.csp?actiontype=PrintMBPL&IngrRowid=' + ingrt + '&HospId=' + gHospId + '&user=' + gUserId;
	var responseText = ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(responseText);
	if (jsonData.success == 'true') {
		mainData = jsonData.info;
		if (mainData != 0) {
			Msg.info('error', '²åÈëÊý¾ÝÊ§°Ü');
		}
	}
}
