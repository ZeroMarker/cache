var gHospId = session['LOGON.HOSPID'];
var gUserId = session['LOGON.USERID'];
function PrintInPo(Parref, AutoFlag) {
	if (Parref == null || Parref == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	fileName = "{DHCSTM_INPO_Common.raq(Parref=" + Parref + ")}";
	if (InPoParamObj.IndirPrint != "N") {
		fileName = TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	} else {
		DHCCPM_RQDirectPrint(fileName);
	}
	Common_PrintLog('PO', Parref, AutoFlag);
}

function GetMainData(Parref) {
	var mainData = "";
	if (Parref == null || Parref == '') {
		return;
	}
	var url = 'dhcstm.inpoaction.csp?actiontype=SelectMain&Parref=' + Parref;
	var responseText = ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(responseText);
	if (jsonData.success == 'true') {
		mainData = jsonData.info;
	}
	return mainData;
}

function PrintMBPL(Parref, HospID, user) {
	if (Parref == null || Parref == '') {
		return;
	}
	var url = 'dhcstm.inpoaction.csp?actiontype=PrintMBPL&inpoRowid=' + Parref + '&HospId=' + gHospId + '&user=' + gUserId;
	var responseText = ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(responseText);
	if (jsonData.success == 'true') {
		mainData = jsonData.info;
		if (mainData != 0) {
			Msg.info('error', '≤Â»Î ˝æ› ß∞‹');
		}
	}
}
