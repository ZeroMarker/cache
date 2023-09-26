//库存调整单打印
var gHospId = session['LOGON.HOSPID'];
var gUserId = session['LOGON.USERID'];
var InAdjParamObj = GetAppPropValue('DHCSTSTOCKADJM');
function PrintInAdj(inadj, AutoFlag) {
	if (inadj == null || inadj == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	//判断是否预览打印
	fileName = "{DHCSTM_InAdj_Common.raq(adj=" + inadj + ")}";
	if (InAdjParamObj.IndirPrint != "N") {
		fileName = TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	} else {
		DHCCPM_RQDirectPrint(fileName);
	}
	Common_PrintLog('A', inadj, AutoFlag);
}

function GetMainData(inadj) {
	var mainData = "";
	if (inadj == null || inadj == '') {
		return;
	}
	var url = "dhcstm.inadjaction.csp?actiontype=select&adj=" + inadj;
	var responseText = ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(responseText);
	if (jsonData.results > 0) {
		data = jsonData.rows;
		if (!data) return;
		var InadjLoc = data[0]['locDesc'];
		var InadjNo = data[0]['INAD_No'];
		var InadjDate = data[0]['INAD_Date'];
		var InadjUser = data[0]['userName'];
		mainData = InadjLoc + "^" + InadjNo + "^" + InadjDate + "^" + InadjUser
	}
	return mainData;
}
function PrintMBPL(inadj, HospID, user) {
	if (inadj == null || inadj == '') {
		return;
	}
	var url = 'dhcstm.inadjaction.csp?actiontype=PrintMBPL&IndjRowid=' + inadj + '&HospId=' + gHospId + '&user=' + gUserId;
	var responseText = ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(responseText);
	if (jsonData.success == 'true') {
		mainData = jsonData.info;
		if (mainData != 0) {
			Msg.info('error', '插入数据失败');
		}
	}
}
