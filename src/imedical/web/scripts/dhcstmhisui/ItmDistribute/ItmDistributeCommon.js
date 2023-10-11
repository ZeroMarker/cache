
// 保存参数值的object
var DispParamObj = GetAppPropValue('DHCSTMATDISPM');
var RetParamObj = GetAppPropValue('DHCSTMATDISPRETM');
var CommonCardNoField = '';
var CommonPatNoField = '';

function DispFlagFormatter(value) {
	var DispFlag = value;
	if (value == '0') {
		DispFlag = '未发放';
	} else if (value == '1') {
		DispFlag = '已发放';
	} else if (value == '2') {
		DispFlag = '已退回';
	}
	return DispFlag;
}

// 读卡
function BtnReadCardHandler(CardType, CardNoField, PatNoField) {
	CommonCardNoField = CardNoField;
	CommonPatNoField = PatNoField;
	var CardNo = $('#' + CommonCardNoField).val();
	var PatNo = $('#' + CommonPatNoField).val();
	var readRet = '';
	try {
		if (CardNo != '') {
			readRet = DHCACC_GetAccInfo(CardType, CardNo, '', '', CardTypeCallBack);
		} else {
			readRet = DHCACC_GetAccInfo7('');
		}
	} catch (e) {}
}
function CardTypeCallBack(readRet) {
	if (readRet == false) {
		$UI.msg('alert', '卡无效!');
		return;
	}
	var readRetArr = readRet.split('^');
	var readRtn = readRetArr[0];
	switch (readRtn) {
		case '0':
			var tmpCardNo = readRetArr[1];
			var tmpPatNo = readRetArr[5];
			$('#' + CommonCardNoField).val(tmpCardNo);
			$('#' + CommonPatNoField).val(tmpPatNo);
			break;
		case '-1':
			$UI.msg('alert', '请检查读卡器，或者输入卡号后重试！');
			break;
		case '-200':
			$UI.msg('alert', '卡无效！');
			break;
		case '-201':// 现金
			var tmpCardNo = readRetArr[1];
			var tmpPatNo = readRetArr[5];
			$('#' + CommonCardNoField).val(tmpCardNo);
			$('#' + CommonPatNoField).val(tmpPatNo);
			break;
		default:
	}
}

function PrintDisp(LocId, UserId, DispId, AdmStr) {
	if (isEmpty(DispId) && isEmpty(AdmStr)) {
		return;
	}
	// RQPrintDisp(Adm,PrtId,LocId,DispFlag)
	LodopPrintDisp(LocId, UserId, DispId, AdmStr);
}
function RQPrintDisp(Adm, PrtId, LocId, DispFlag, UserId) {
	fileName = '{DHCSTM_HUI_ItmDistribute_Common.raq(Adm=' + Adm + '&PrtId=' + PrtId + '&LocId=' + LocId + '&DispFlag=' + DispFlag + ')}';
	DHCCPM_RQDirectPrint(fileName);
	Common_PrintLog('Disp', Adm, '');
}
function LodopPrintDisp(LocId, UserId, DispId, AdmStr) {
	var BaseNum = 10;
	var DispInfo = tkMakeServerCall('web.DHCSTMHUI.DHCMatDisp', 'GetPrintDispStr', LocId, UserId, DispId, AdmStr);
	var Pid = DispInfo.split('^')[0];
	var Num = Number(DispInfo.split('^')[1]);
	if ((Pid == '') || (Num == 0)) { return; }
	var yushu = Num % BaseNum;
	var Page = Math.floor(Num / BaseNum);
	if (yushu > 0) {
		Page = Page + 1;
	}
	for (var i = 1; i <= Page; i++) {
		DHCP_GetXMLConfig('InvPrintEncrypt', 'DHCSTM_Disp');
		var inpara = $.cm({ ClassName: 'web.DHCSTMHUI.DHCMatDisp', MethodName: 'GetPrintDispInfo', Pid: Pid, Page: Page, dataType: 'text' }, false);
		DHC_PrintByLodop(getLodop(), inpara, '', [], '物资门诊发放', { printListByText: true });
	}
	
	Common_PrintLog('Disp', DispId, '');
}