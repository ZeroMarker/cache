// /名称: 入库单打印
// /描述: 入库单打印
// /编写者：zhangdongmei
// /编写日期: 2012.11.13
var gHospId = session['LOGON.HOSPID'];
var gUserId = session['LOGON.USERID'];
function PrintRec(ingr, AutoFlag) {
	if (ingr == null || ingr == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	var mainData = GetIngrMainData(ingr);
	if (mainData == null || mainData == "") {
		return;
	}
	var mainArr = mainData.split("^");
	var ScgId = mainArr[27];
	var PtModLoc = mainArr[10];
	var PrintCount=mainArr[35];
	var PrintModeData = GetPrintMode(PtModLoc, ScgId);
	var PrintMode = PrintModeData.split("^")[0];
	var RaqName = 'DHCSTM_StockRec_Common.raq';
	if (PrintMode == 'MO') {
		RaqName = 'DHCSTM_StockRec_MO_Common.raq';
	}
	var fileName = "{" + RaqName + "(Parref=" + ingr + ";PrintCount="+PrintCount+ ")}";
	var PrintNum = parseInt(IngrParamObj.PrintNum);
	if (!Ext.isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	for (var i = 1; i <= PrintNum; i++) {
		if (IngrParamObj.IndirPrint != "N") {
			var transfileName = TranslateRQStr(fileName);
			DHCSTM_DHCCPM_RQPrint(transfileName);
		} else {
			DHCCPM_RQDirectPrint(fileName);
		}
		Common_PrintLog('G', ingr, AutoFlag);
	}
	PrintFlag(ingr);
}

function PrintRecHVCol(ingr, AutoFlag) {
	if (ingr == null || ingr == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	var mainData = GetIngrMainData(ingr);
	if (mainData == null || mainData == "") {
		return;
	}
	var mainArr = mainData.split("^");
	var ScgId = mainArr[27];
	var PtModLoc = mainArr[10];
	var PrintCount=mainArr[35];
	var PrintModeData = GetPrintMode(PtModLoc, ScgId);
	var PrintMode = PrintModeData.split("^")[0];
	var RaqName = 'DHCSTM_StockRecHVCol_Common.raq';
	if (PrintMode == 'MO') {
		RaqName = 'DHCSTM_StockRecHVCol_MO_Common.raq';
	}
	var fileName = "{" + RaqName + "(Parref=" + ingr +";PrintCount="+PrintCount+ ")}";
	var PrintNum = parseInt(IngrParamObj.PrintNum);
	if (!Ext.isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	for (var i = 1; i <= PrintNum; i++) {
		if (IngrParamObj.IndirPrint != "N") {
			var transfileName = TranslateRQStr(fileName);
			DHCCPM_RQPrint(transfileName);
		} else {
			DHCCPM_RQDirectPrint(fileName);
		}
		Common_PrintLog('G', ingr, AutoFlag);
	}
	PrintFlag(ingr);
}

function PrintRecBill(ingr) {
	if (ingr == null || ingr == '') {
		return;
	}
	var mainData = GetIngrMainData(ingr);
	if (mainData == null || mainData == "") {
		return;
	}
	var mainArr = mainData.split("^");
	var vendor = mainArr[2];
	var ingrNo = mainArr[0];
	var ingrDate = mainArr[12];
	var MyPara = 'Vendor' + String.fromCharCode(2) + vendor;
	MyPara = MyPara + '^IngrNo' + String.fromCharCode(2) + ingrNo;
	MyPara = MyPara + '^IngrDate' + String.fromCharCode(2) + ingrDate;

	var myList = "";
	var detailArr = GetDetailData(ingr);
	for (i = 0; i < detailArr.length; i++) {
		var detailObj = detailArr[i];
		var inciCode = detailObj.IncCode;
		var inciDesc = detailObj.IncDesc;
		var spec = "";
		var ingrUom = detailObj.IngrUom;
		var batNo = detailObj.BatchNo;
		var manf = detailObj.Manf;
		var qty = detailObj.RecQty;
		var rp = detailObj.Rp;
		var rpAmt = detailObj.RpAmt;
		var sp = detailObj.Sp;
		var spAmt = detailObj.SpAmt;
		var marAmt = spAmt - rpAmt;
		var firstdesc = inciCode + " " + inciDesc + " " + spec + " " + ingrUom + " " + batNo + " " + manf + " " + qty + " " + rp + " " + rpAmt + " " + sp + " " + spAmt + " " + marAmt;
		if (myList == '') {
			myList = firstdesc;
		} else {
			myList = myList + String.fromCharCode(2) + firstdesc;
		}
	}
	DHCP_GetXMLConfig("DHCSTGdRecPrt");
	DHCP_PrintFun(MyPara, myList);
}

/*
 * creator:zhangdongmei,2012-11-13
 * description:取入库明细信息
 * params: ingr:入库主表id
 * return:
 * */
function GetDetailData(ingr) {
	if (ingr == null || ingr == '') {
		return;
	}
	var url = 'dhcstm.ingdrecaction.csp?actiontype=QueryDetail&Parref=' + ingr + '&start=0&limit=999';
	var responseText = ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(responseText);
	var detailData = jsonData.rows;
	return detailData;
}

/*
 * creator:zhangdongmei,2012-11-13
 * description:取入库主表信息
 * params: ingr:入库主表id
 * return:
 * */
function GetIngrMainData(ingr) {
	var mainData = "";
	if (ingr == null || ingr == '') {
		return;
	}
	var url = 'dhcstm.ingdrecaction.csp?actiontype=Select&IngrRowid=' + ingr;
	var responseText = ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(responseText);
	if (jsonData.success == 'true') {
		mainData = jsonData.info;
	}
	return mainData;
}
function GetPrintMode(Loc, Scg) {
	var Mode = "";
	if (Loc == "") {
		return "";
	}
	var url = 'dhcstm.stklocgrpaction.csp?actiontype=GetMode&LocId=' + Loc + '&Scg=' + Scg;
	var responseText = ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(responseText);
	if (jsonData.success == 'true') {
		Mode = jsonData.info;
	}
	return Mode;
}
function PrintFlag(ingr) {
	if (ingr == null || ingr == '') {
		return;
	}
	var url = 'dhcstm.ingdrecaction.csp?actiontype=PrintFlag&IngrRowid=' + ingr;
	var responseText = ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(responseText);
	if (jsonData.success == 'true') {
		mainData = jsonData.info;
		if (mainData != 0) {
			Msg.info('error', '打印标志修改失败');
		}
	}
}
function PrintMBPL(ingr, HospID, user) {
	if (ingr == null || ingr == '') {
		return;
	}
	var url = 'dhcstm.ingdrecaction.csp?actiontype=PrintMBPL&IngrRowid=' + ingr + '&HospId=' + gHospId + '&user=' + gUserId;
	var responseText = ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(responseText);
	if (jsonData.success == 'true') {
		mainData = jsonData.info;
		if (mainData != 0) {
			Msg.info('error', '插入数据失败');
		}
	}
}
