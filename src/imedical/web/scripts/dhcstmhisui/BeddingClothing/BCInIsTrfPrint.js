
// 保存参数值的object
var BCInitParamObj = GetAppPropValue('DHCSTBCM');

function PrintInIsTrfBC(Init, AutoFlag) {
	if (PrintMethod == 0) {
		LodopPrintInIsTrfBC(Init, AutoFlag); // Lodop打印
	} else {
		RQPrintInIsTrfBC(Init, AutoFlag); // 润乾打印
	}
}
function LodopPrintInIsTrfBC(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	// 获取打印次数，是否预览打印，处理打印标志和次数
	var PrintNum = parseInt(BCInitParamObj.PrintNum);
	var IndirPrint = BCInitParamObj.IndirPrint;
	// 标志和次数处理
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	Common_PrintLog('T', Init, AutoFlag, PrintNum);
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
		MethodName: 'Select',
		Init: Init
	}, false);
	var DetailData = GetDetailDataBCInIs(Init, 'T'); // 明细信息
	var FrLocDesc = MainObj.InitFrLoc.Description;
	var ToLocDesc = MainObj.InitToLoc.Description;
	var InitNo = MainObj.InitNo;
	var InitReqUser = MainObj.InitReqUser.Description;
	var InitDate = MainObj.InitDate;
	var InitUser = MainObj.InitUser.Description;
	var PrintDate = DateFormatter(new Date());
	// 主单信息展示
	var TaskName = '被服转移单打印'; // 打印任务名称
	// 标题信息
	var Title = FrLocDesc + '转移单';
	// 页眉信息
	var Head = '接收科室:' + ToLocDesc + '      '
			+ '转移单号:' + InitNo + '      '
			+ '请领人:' + InitReqUser + '      '
			+ '制单日期:' + PrintDate;
	// 页尾信息
	var Foot = '打印日期:' + PrintDate + '          '
			+ '主管:' + '' + '          '
			+ '核对:' + '' + '          '
			+ '制单人:' + InitUser;
	// 明细信息展示
	var Cols = [
		{ field: 'Num', title: '序号', width: '25px', align: 'center' },
		{ field: 'InciCode', title: '物资代码', width: '100px', align: 'left' },
		{ field: 'InciDesc', title: '物资名称', width: '100px', align: 'left' },
		{ field: 'Spec', title: '规格', width: '100px', align: 'left' },
		{ field: 'SpecDesc', title: '具体规格', width: '100px', align: 'left' },
		{ field: 'UomDesc', title: '单位', width: '100px', align: 'left' },
		{ field: 'Qty', title: '数量', width: '100px', align: 'right', format: '#,##0.00' },
		{ field: 'BatExp', title: '批号~效期', width: '100px', align: 'left' },
		{ field: 'Rp', title: '进价', width: '100px', align: 'right', format: '#,##0.00' },
		{ field: 'Sp', title: '售价', width: '100px', align: 'right', format: '#,##0.00' },
		{ field: 'RpAmt', title: '进价金额', width: '100px', align: 'right', format: '#,##0.00', sum: 'Y' },
		{ field: 'SpAmt', title: '售价金额', width: '100px', align: 'right', format: '#,##0.00', sum: 'Y' }
	];
	PrintDocument(PrintNum, IndirPrint, TaskName, Title, Head, Foot, Cols, DetailData);
}

function RQPrintInIsTrfBC(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	var InitObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
		MethodName: 'Select',
		Init: Init
	}, false);
	var FrLocId = InitObj['InitFrLoc']['RowId'];
	var ScgId = InitObj['ScgId'];
	if (isEmpty(FrLocId)) {
		return;
	}
	var PrintMode = GetPrintMode(FrLocId, ScgId);
	var RaqName = 'DHCSTM_HUI_InIsTrf_Common.raq';
	if (PrintMode == 'MO') {
		RaqName = 'DHCSTM_HUI_InIsTrf_MO_Common.raq';
	}
	var Params = JSON.stringify({ Init: Init });
	var DirectPrintStr = '{' + RaqName + '(Params=' + Params + ';Init=' + Init + ')}';
	var PrintNum = parseInt(BCInitParamObj.PrintNum);
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	for (var i = 1; i <= PrintNum; i++) {
		if (BCInitParamObj.IndirPrint != 'N') {
			DHCSTM_DHCCPM_RQPrint(RQPrintStr);
		} else {
			DHCCPM_RQDirectPrint(DirectPrintStr);
		}
		Common_PrintLog('T', Init, AutoFlag);
	}
}

function GetDetailDataBCInIs(Init, InitType) {
	if (isEmpty(Init)) {
		return;
	}
	var Params = JSON.stringify({ Init: Init, InitType: InitType });
	var jsonData = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
		QueryName: 'DHCINIsTrfD',
		query2JsonStrict: 1,
		Params: Params
	}, false);
	var DetailData = jsonData.rows;
	return DetailData;
}