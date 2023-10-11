
function PrintINScrap(Inscrap, AutoFlag) {
	if (isEmpty(Inscrap)) {
		return;
	}
	
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	var MainObj = GetMainData(Inscrap);
	var ScgId = MainObj.ScgStk;
	var RecLoc = MainObj.SupLoc;
	var PrintMode = GetPrintMode(RecLoc, ScgId);
	var RaqName = 'DHCSTM_HUI_INScrap_Common.raq';
	if (PrintMode != '') {
		RaqName = 'DHCSTM_HUI_INScrap_Common_' + PrintMode + '.raq';
	}
	fileName = '{' + RaqName + '(Parref=' + Inscrap + ')}';
	if (InScrapParamObj.IndirPrint != 'N') {
		fileName = TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	} else {
		DHCCPM_RQDirectPrint(fileName);
	}
	Common_PrintLog('D', Inscrap, AutoFlag);
}
/*
 * description:取报损主表信息
 * params: ingr:报损主表id
 * return:
*/
function GetMainData(Inscrap) {
	if (isEmpty(Inscrap)) {
		return;
	}
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINScrap',
		MethodName: 'Select',
		Inscrap: Inscrap
	}, false);
	return MainObj;
}