//库存转移单打印
var gHospId = session['LOGON.HOSPID'];
var gUserId = session['LOGON.USERID'];
function PrintInIsTrf(init, AutoFlag) {
	if (init == null || init == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	var mainData=GetInitMainData(init);
	if(mainData==""){
		return;
	}
	var mainArr=mainData.split("^");
	var InitFrLocId=mainArr[6];
	var ScgId=mainArr[24];
	var PrintCount=mainArr[41];
	var PrintModeData=GetPrintMode(InitFrLocId,ScgId);
	var PrintMode=PrintModeData.split("^")[0];
	var RaqName = "DHCSTM_InIsTrf_Common.raq";
	if(PrintMode == 'MO'){
		RaqName = 'DHCSTM_InIsTrf_MO_Common.raq';
	}
	var fileName = "{" + RaqName + "(init=" + init+ ";PrintCount="+PrintCount+ ")}";
	//获取打印次数的参数
	var PrintNum = parseInt(InitParamObj.PrintNum);
	if (!Ext.isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	for (var i = 1; i <= PrintNum; i++) {
		if (InitParamObj.IndirPrint != "N") {
			var transfileName = TranslateRQStr(fileName);
			DHCSTM_DHCCPM_RQPrint(transfileName);
		} else {
			DHCCPM_RQDirectPrint(fileName);
		}
		Common_PrintLog('T', init, AutoFlag);
	}
	PrintFlag(init);
	//打印试剂条码
	PrintItmLabel(init);
}

function PrintInIsTrfHVCol(init, AutoFlag) {
	if (init == null || init == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	var mainData=GetInitMainData(init);
	if(mainData==""){
		return;
	}
	var mainArr=mainData.split("^");
	var PrintCount=mainArr[41];
	var fileName = "{DHCSTM_InIsTrfHVCol_Common.raq(init=" + init + ";PrintCount="+PrintCount+  ")}";
	//获取打印次数的参数
	var PrintNum = parseInt(InitParamObj.PrintNum);
	if (!Ext.isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	for (var i = 1; i <= PrintNum; i++) {
		if (InitParamObj.IndirPrint != "N") {
			var transfileName = TranslateRQStr(fileName);
			DHCCPM_RQPrint(transfileName);
		} else {
			DHCCPM_RQDirectPrint(fileName);
		}
		Common_PrintLog('T', init, AutoFlag);
	}
	PrintFlag(init);
}

function PrintInIsTrfReturn(init, AutoFlag) {
	if (init == null || init == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	var mainData = GetInitMainData(init);
	if (mainData == "") {
		return;
	}
	var mainArr = mainData.split("^");
	var InitToLocId = mainArr[12];
	var InitScgId = mainArr[24];
	var PrintModeData = GetPrintMode(InitToLocId, InitScgId);
	var PrintMode = PrintModeData.split("^")[0];
	var RaqName = 'DHCSTM_InIsTrfRet_Common.raq';
	if (PrintMode == 'MO') {
		RaqName = 'DHCSTM_InIsTrfRet_MO_Common.raq';
	}
	var fileName = "{" + RaqName + "(init=" + init + ")}";
	//获取打印次数的参数
	var PrintNum = parseInt(InitParamObj.PrintNum);
	if (!Ext.isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	for (var i = 1; i <= PrintNum; i++) {
		if (InitParamObj.IndirPrint != "N") {
			var transfileName = TranslateRQStr(fileName);
			DHCCPM_RQPrint(transfileName);
		} else {
			DHCCPM_RQDirectPrint(fileName);
		}
		Common_PrintLog('T', init, AutoFlag);
	}
	PrintFlag(init);
}
function PrintInIsTrfReturnHVCol(init, AutoFlag) {
	if (init == null || init == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	var mainData = GetInitMainData(init);
	if (mainData == "") {
		return;
	}
	var mainArr = mainData.split("^");
	var InitToLocId = mainArr[12];
	var InitScgId = mainArr[24];
	var PrintModeData = GetPrintMode(InitToLocId, InitScgId);
	var PrintMode = PrintModeData.split("^")[0];
	var RaqName = 'DHCSTM_InIsTrfRetHVCol_Common.raq';
	if (PrintMode == 'MO') {
		RaqName = 'DHCSTM_InIsTrfRetHVCol_MO_Common.raq';
	}
	var fileName = "{" + RaqName + "(init=" + init + ")}";
	//获取打印次数的参数
	var PrintNum = parseInt(InitParamObj.PrintNum);
	if (!Ext.isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	for (var i = 1; i <= PrintNum; i++) {
		if (InitParamObj.IndirPrint != "N") {
			var transfileName = TranslateRQStr(fileName);
			DHCCPM_RQPrint(transfileName);
		} else {
			DHCCPM_RQDirectPrint(fileName);
		}
		Common_PrintLog('T', init, AutoFlag);
	}
	PrintFlag(init);
}
function GetInitMainData(init) {
	var mainData = "";
	if (init == null || init == '') {
		return;
	}
	var url = "dhcstm.dhcinistrfaction.csp?actiontype=Select&Rowid=" + init;
	var responseText = ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(responseText);
	if (jsonData.success == 'true') {
		mainData = jsonData.info;
	}
	return mainData;
}

function PrintFlag(init) {
	if (init == null || init == '') {
		return;
	}
	var url = "dhcstm.dhcinistrfaction.csp?actiontype=PrintFlag&Rowid=" + init;
	var responseText = ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(responseText);
	if (jsonData.success == 'true') {
		mainData = jsonData.info;
		if (mainData != 0) {
			Msg.info('error', '打印标志修改失败');
		}
	}

}

/**
 * 打印明细标签, 仅打印"试剂"部分
 * @param {} init
 */
function PrintItmLabel(init){
	if(init==null || init==''){
		return;
	}
	DHCP_GetXMLConfig('DHCSTM_LabelForLis');
	
	var mainData=GetInitMainData(init);
	if(mainData==""){
		return;
	}
	var mainArr=mainData.split("^");
	var InitFrLocId=mainArr[6];
	var InitNo=mainArr[8];
	var InitFrLocDesc=mainArr[26];
	var InitToLocDesc=mainArr[27];
	var InitDate=mainArr[29];
	
	var DetailUrl = 'dhcstm.serforlisaction.csp?actiontype=GetInitiBarCodeDetail&start=0&limit=999&Init=' + init;
	var InitItmInfo = ExecuteDBSynAccess(DetailUrl);
	InitItmInfo = Ext.decode(InitItmInfo);
	for(var i = 0, Len = InitItmInfo.rows.length; i < Len; i++){
		var ItmInfo = InitItmInfo.rows[i];
		var InciCode = ItmInfo['InciCode'], InciDesc = ItmInfo['InciDesc'], Spec = ItmInfo['Spec'], BUomDesc = ItmInfo['BUomDesc'];
		var BarCode = ItmInfo['BarCode'], BatchNo = ItmInfo['BatchNo'], ExpDate = ItmInfo['ExpDate'];
		
		var MyPara = 'FrLoc' + String.fromCharCode(2) + InitFrLocDesc
			+ '^ToLoc' + String.fromCharCode(2) + InitToLocDesc
			+ '^InitNo' + String.fromCharCode(2) + InitNo
			+ '^InitDate' + String.fromCharCode(2) + InitDate
			+ '^InciCode' + String.fromCharCode(2) + InciCode
			+ '^InciDesc' + String.fromCharCode(2) + InciDesc
			+ '^Spec' + String.fromCharCode(2) + Spec
			+ '^BUomDesc' + String.fromCharCode(2) + BUomDesc
			+ '^BarCode' + String.fromCharCode(2) + BarCode
			+ '^BatchNo' + String.fromCharCode(2) + BatchNo
			+ '^ExpDate' + String.fromCharCode(2) + ExpDate;
		DHCP_PrintFun(MyPara, "");
	}
}
