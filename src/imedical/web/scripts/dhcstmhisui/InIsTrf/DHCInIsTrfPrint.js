function PrintInIsTrf(InitStr, AutoFlag) {
	InitStr = InitStr.toString();
	if (PrintMethod == 0) {
		var InitArr = InitStr.split('^');
		var InitCount = InitArr.length;
		if (InitCount <= 0) {
			return;
		}
		for (var i = 0; i < InitCount; i++) {
			var Init = InitArr[i];
			var HVFlag = GetCertDocHVFlag(Init, 'T');
			if (HVFlag == 'Y') {
				LodopPrintInIsTrf(Init, AutoFlag);
			} else {
				LodopPrintInIsTrfHVCol(Init, AutoFlag);
			}
		}
	} else {
		RQPrintInIsTrf(InitStr, AutoFlag);
	}
}

function PrintInIsTrfHVCol(InitStr, AutoFlag) {
	InitStr = InitStr.toString();
	if (PrintMethod == 0) {
		var InitArr = InitStr.split('^');
		var InitCount = InitArr.length;
		if (InitCount <= 0) {
			return;
		}
		for (var i = 0; i < InitCount; i++) {
			var Init = InitArr[i];
			LodopPrintInIsTrfHVCol(Init, AutoFlag);
		}
	} else {
		RQPrintInIsTrfHVCol(InitStr, AutoFlag);
	}
}

function PrintInIsTrfReturn(InitStr, AutoFlag) {
	InitStr = InitStr.toString();
	if (PrintMethod == 0) {
		var InitArr = InitStr.split('^');
		var InitCount = InitArr.length;
		if (InitCount <= 0) {
			return;
		}
		for (var i = 0; i < InitCount; i++) {
			var Init = InitArr[i];
			var HVFlag = GetCertDocHVFlag(Init, 'T');
			if (HVFlag == 'Y') {
				LodopPrintInIsTrfReturn(Init, AutoFlag);
			} else {
				LodopPrintInIsTrfReturnHVCol(Init, AutoFlag);
			}
		}
	} else {
		RQPrintInIsTrfReturn(InitStr, AutoFlag);
	}
}

function PrintInIsTrfReturnHVCol(InitStr, AutoFlag) {
	InitStr = InitStr.toString();
	if (PrintMethod == 0) {
		var InitArr = InitStr.split('^');
		var InitCount = InitArr.length;
		if (InitCount <= 0) {
			return;
		}
		for (var i = 0; i < InitCount; i++) {
			var Init = InitArr[i];
			LodopPrintInIsTrfReturnHVCol(Init, AutoFlag);
		}
	} else {
		RQPrintInIsTrfReturnHVCol(InitStr, AutoFlag);
	}
}

// 出库单Lodop打印
function LodopPrintInIsTrf(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	// 获取打印次数，是否预览打印，处理打印标志和次数
	var PrintNum = parseInt(InitParamObj.PrintNum);
	var IndirPrint = InitParamObj.IndirPrint;
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
	var DetailData = GetDetailDataInIs(Init, 'T'); // 明细信息
	var FrLocDesc = MainObj.InitFrLoc.Description;
	var ToLocDesc = MainObj.InitToLoc.Description;
	var InitNo = MainObj.InitNo;
	var InitReqUser = MainObj.InitReqUser.Description;
	var InitDate = MainObj.InitDate;
	var InitUser = MainObj.InitUser.Description;
	var InitAckUser = MainObj.InitAckUserName;
	var PrintDate = DateFormatter(new Date());
	// 主单信息展示
	var TaskName = '出库单打印'; // 打印任务名称
	// 标题信息
	var Title = FrLocDesc + '出库单';
	// 页眉信息
	var Head = '接收科室:' + ToLocDesc + '      '
			+ '出库单号:' + InitNo + '      '
			+ '制单日期:' + InitDate;
	// 页尾信息
	var Foot = '打印日期:' + PrintDate + '          '
			+ '制单:' + InitUser + '          '
			+ '审核:' + InitAckUser + '          '
			+ '接收:' + InitReqUser;
	// 明细信息展示
	var Cols = [
		{ field: 'Num', title: '序号', width: '25px', align: 'center' },
		{ field: 'InciCode', title: '物资代码', width: '10%', align: 'left' },
		{ field: 'InciDesc', title: '物资名称', width: '13%', align: 'left' },
		{ field: 'Spec', title: '规格', width: '7%', align: 'left' },
		{ field: 'SterilizedBat', title: '灭菌批号', width: '10%', align: 'left' },
		{ field: 'UomDesc', title: '单位', width: '5%', align: 'left' },
		{ field: 'Qty', title: '数量', width: '5%', align: 'right', format: '#,##0.00' },
		{ field: 'BatExp', title: '批号~效期', width: '15%', align: 'left' },
		{ field: 'Rp', title: '进价', width: '7%', align: 'right', format: '#,##0.00' },
		{ field: 'RpAmt', title: '进价金额', width: '10%', align: 'right', format: '#,##0.00', sum: 'Y' },
		{ field: 'SpecDesc', title: '具体规格', width: '10%', align: 'left' },
		{ field: 'ManfDesc', title: '生产厂家', width: '10%', align: 'left' }
		//	{field:"Sp",title:"售价",width:"100px",align:"right",format:"#,##0.00"},
		//	{field:"SpAmt",title:"售价金额",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
	];
	PrintDocument(PrintNum, IndirPrint, TaskName, Title, Head, Foot, Cols, DetailData);
}
// 高值出库单Lodop打印
function LodopPrintInIsTrfHVCol(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	// 获取打印次数，是否预览打印，处理打印标志和次数
	var PrintNum = parseInt(InitParamObj.PrintNum);
	var IndirPrint = InitParamObj.IndirPrint;
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
	var DetailData = GetHVColDetailData(Init, 'T'); // 明细信息
	var FrLocDesc = MainObj.InitFrLoc.Description;
	var ToLocDesc = MainObj.InitToLoc.Description;
	var InitNo = MainObj.InitNo;
	var InitReqUser = MainObj.InitReqUser.Description;
	var InitDate = MainObj.InitDate;
	var InitUser = MainObj.InitUser.Description;
	var InitAckUser = MainObj.InitAckUserName;
	var PrintDate = DateFormatter(new Date());
	// 主单信息展示
	var TaskName = '高值出库单打印'; // 打印任务名称
	// 标题信息
	var Title = FrLocDesc + '出库单';
	// 页眉信息
	var Head = '接收科室:' + ToLocDesc + '      '
			+ '出库单号:' + InitNo + '      '
			+ '制单日期:' + InitDate;
	// 页尾信息
	var Foot = '打印日期:' + PrintDate + '          '
			+ '制单:' + InitUser + '          '
			+ '审核:' + InitAckUser + '          '
			+ '接收:' + InitReqUser;
	// 明细信息展示
	var Cols = [
		{ field: 'Num', title: '序号', width: '25px', align: 'center' },
		{ field: 'InciCode', title: '物资代码', width: '10%', align: 'left' },
		{ field: 'InciDesc', title: '物资名称', width: '13%', align: 'left' },
		{ field: 'Spec', title: '规格', width: '7%', align: 'left' },
		{ field: 'SterilizedBat', title: '灭菌批号', width: '10%', align: 'left' },
		{ field: 'UomDesc', title: '单位', width: '5%', align: 'left' },
		{ field: 'Qty', title: '数量', width: '5%', align: 'right', format: '#,##0.00' },
		{ field: 'BatExp', title: '批号~效期', width: '15%', align: 'left' },
		{ field: 'Rp', title: '进价', width: '7%', align: 'right', format: '#,##0.00' },
		{ field: 'RpAmt', title: '进价金额', width: '10%', align: 'right', format: '#,##0.00', sum: 'Y' },
		{ field: 'SpecDesc', title: '具体规格', width: '10%', align: 'left' },
		{ field: 'ManfDesc', title: '生产厂家', width: '10%', align: 'left' }
	//	{field:"Sp",title:"售价",width:"100px",align:"right",format:"#,##0.00"},
	//	{field:"SpAmt",title:"售价金额",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
	];
	PrintDocument(PrintNum, IndirPrint, TaskName, Title, Head, Foot, Cols, DetailData);
}
// 退库单Lodop打印
function LodopPrintInIsTrfReturn(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	// 获取打印次数，是否预览打印，处理打印标志和次数
	var PrintNum = parseInt(InitParamObj.PrintNum);
	var IndirPrint = InitParamObj.IndirPrint;
	// 标志和次数处理
	if (isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	Common_PrintLog('T', Init, AutoFlag, PrintNum);
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
		MethodName: 'Select',
		Init: Init
	}, false);
	var DetailData = GetDetailDataInIs(Init, 'K'); // 明细信息
	var FrLocDesc = MainObj.InitFrLoc.Description;
	var ToLocDesc = MainObj.InitToLoc.Description;
	var InitNo = MainObj.InitNo;
	var InitReqUser = MainObj.InitReqUser.Description;
	var InitDate = MainObj.InitDate;
	var InitUser = MainObj.InitUser.Description;
	var PrintDate = DateFormatter(new Date());
	// 主单信息展示
	var TaskName = '退库单打印'; // 打印任务名称
	// 标题信息
	var Title = ToLocDesc + '退库单';
	// 页眉信息
	var Head = '退库科室:' + FrLocDesc + '      '
			+ '退库单号:' + InitNo + '      '
			+ '制单日期:' + InitDate;
	// 页尾信息
	var Foot = '打印日期:' + PrintDate + '          '
			+ '库管:' + '          '
			+ '退库人:' + '          '
			+ '制单人:' + InitUser;
	// 明细信息展示
	var Cols = [
		{ field: 'Num', title: '序号', width: '25px', align: 'center' },
		{ field: 'InciCode', title: '物资代码', width: '10%', align: 'left' },
		{ field: 'InciDesc', title: '物资名称', width: '13%', align: 'left' },
		{ field: 'Spec', title: '规格', width: '7%', align: 'left' },
		{ field: 'SterilizedBat', title: '灭菌批号', width: '10%', align: 'left' },
		{ field: 'UomDesc', title: '单位', width: '5%', align: 'left' },
		{ field: 'Qty', title: '数量', width: '5%', align: 'right', format: '#,##0.00' },
		{ field: 'BatExp', title: '批号~效期', width: '15%', align: 'left' },
		{ field: 'Rp', title: '进价', width: '7%', align: 'right', format: '#,##0.00' },
		{ field: 'RpAmt', title: '进价金额', width: '10%', align: 'right', format: '#,##0.00', sum: 'Y' },
		{ field: 'SpecDesc', title: '具体规格', width: '10%', align: 'left' },
		{ field: 'ManfDesc', title: '生产厂家', width: '10%', align: 'left' }
	//	{field:"Sp",title:"售价",width:"100px",align:"right",format:"#,##0.00"},
	//	{field:"SpAmt",title:"售价金额",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
	];
	PrintDocument(PrintNum, IndirPrint, TaskName, Title, Head, Foot, Cols, DetailData);
}
// 高值退库单Lodop打印
function LodopPrintInIsTrfReturnHVCol(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	// 获取打印次数，是否预览打印，处理打印标志和次数
	var PrintNum = parseInt(InitParamObj.PrintNum);
	var IndirPrint = InitParamObj.IndirPrint;
	// 标志和次数处理
	if (isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	Common_PrintLog('T', Init, AutoFlag, PrintNum);
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
		MethodName: 'Select',
		Init: Init
	}, false);
	var DetailData = GetHVColDetailData(Init, 'K'); // 明细信息
	var FrLocDesc = MainObj.InitFrLoc.Description;
	var ToLocDesc = MainObj.InitToLoc.Description;
	var InitNo = MainObj.InitNo;
	var InitReqUser = MainObj.InitReqUser.Description;
	var InitDate = MainObj.InitDate;
	var InitUser = MainObj.InitUser.Description;
	var PrintDate = DateFormatter(new Date());
	// 主单信息展示
	var TaskName = '高值退库单打印'; // 打印任务名称
	// 标题信息
	var Title = ToLocDesc + '退库单';
	// 页眉信息
	var Head = '退库科室:' + FrLocDesc + '      '
			+ '退库单号:' + InitNo + '      '
			+ '制单日期:' + InitDate;
	// 页尾信息
	var Foot = '打印日期:' + PrintDate + '          '
			+ '库管:' + '          '
			+ '退库人:' + '          '
			+ '制单人:' + InitUser;
	// 明细信息展示
	var Cols = [
		{ field: 'Num', title: '序号', width: '25px', align: 'center' },
		{ field: 'InciCode', title: '物资代码', width: '10%', align: 'left' },
		{ field: 'InciDesc', title: '物资名称', width: '13%', align: 'left' },
		{ field: 'Spec', title: '规格', width: '7%', align: 'left' },
		{ field: 'SterilizedBat', title: '灭菌批号', width: '10%', align: 'left' },
		{ field: 'UomDesc', title: '单位', width: '5%', align: 'left' },
		{ field: 'Qty', title: '数量', width: '5%', align: 'right', format: '#,##0.00' },
		{ field: 'BatExp', title: '批号~效期', width: '15%', align: 'left' },
		{ field: 'Rp', title: '进价', width: '7%', align: 'right', format: '#,##0.00' },
		{ field: 'RpAmt', title: '进价金额', width: '10%', align: 'right', format: '#,##0.00', sum: 'Y' },
		{ field: 'SpecDesc', title: '具体规格', width: '10%', align: 'left' },
		{ field: 'ManfDesc', title: '生产厂家', width: '10%', align: 'left' }
	//	{field:"Sp",title:"售价",width:"100px",align:"right",format:"#,##0.00"},
	//	{field:"SpAmt",title:"售价金额",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
	];
	PrintDocument(PrintNum, IndirPrint, TaskName, Title, Head, Foot, Cols, DetailData);
}

function GetDetailDataInIs(Init, InitType) {
	if (isEmpty(Init)) {
		return;
	}
	var Params = JSON.stringify({ Init: Init, InitType: InitType });
	var jsonData = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
		QueryName: 'DHCINIsTrfD',
		query2JsonStrict: 1,
		Params: Params,
		rows: 99999
	}, false);
	var DetailData = jsonData.rows;
	return DetailData;
}

function GetHVColDetailData(Init, InitType) {
	if (isEmpty(Init)) {
		return;
	}
	var Params = JSON.stringify({ Init: Init, InitType: InitType });
	var jsonData = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
		QueryName: 'QueryHVColDetail',
		query2JsonStrict: 1,
		Params: Params,
		rows: 99999
	}, false);
	var DetailData = jsonData.rows;
	return DetailData;
}
function RQPrintInIsTrf(InitStr, AutoFlag) {
	InitStr = InitStr.toString();
	var InitArr = InitStr.split('^');
	var ArrCount = InitArr.length;
	if (ArrCount <= 0) {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	var PrintNum = parseInt(InitParamObj.PrintNum);
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	var DictPrintStr = '';
	var DictPrintStrLen = '';
	for (var i = 0; i < ArrCount; i++) {
		var Init = InitArr[i];
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
		var HVFlag = GetCertDocHVFlag(Init, 'T');	// 出库单查询多选打印区分高低值单据
		var RaqName = 'DHCSTM_HUI_InIsTrf_Common' + RQSuffix;
		if (HVFlag == 'Y') {
			if (PrintMode != '') {
				RaqName = 'DHCSTM_HUI_InIsTrfHVCol_Common_' + PrintMode + RQSuffix;
			} else {
				RaqName = 'DHCSTM_HUI_InIsTrfHVCol_Common' + RQSuffix;
			}
		} else {
			if (PrintMode != '') {
				RaqName = 'DHCSTM_HUI_InIsTrf_Common_' + PrintMode + RQSuffix;
			} else {
				RaqName = 'DHCSTM_HUI_InIsTrf_Common' + RQSuffix;
			}
		}
		var Params = '';
		var RQInitStr = Init;
		var PrintStr = '{' + RaqName + '(Params=' + Params + ';Init=' + Init + ';RQInitStr=' + RQInitStr + ')}';
		var RQPrintStr = TranslateRQStr(PrintStr);
		for (var j = 1; j <= PrintNum; j++) {
			if (InitParamObj.IndirPrint != 'N') {
				DHCSTM_DHCCPM_RQPrint(RQPrintStr);
				Common_PrintLog('T', Init, AutoFlag);
			} else {
				if (HISVersion < 8.5) {
					DHCCPM_RQDirectPrint(PrintStr);
					Common_PrintLog('T', Init, AutoFlag);
				} else {
					if (DictPrintStr == '') {
						DictPrintStr = PrintStr;
					} else {
						DictPrintStr = DictPrintStr + PrintStr;
					}
					DictPrintStrLen = DictPrintStr.length;
					if (DictPrintStrLen > 512) {
						$UI.msg('alert', '打印参数超长,本次只能打印' + i + '份单据,请重新选择单据!');
						return;
					}
				}
			}
		}
	}
	if ((HISVersion >= 8.5) && (InitParamObj.IndirPrint == 'N')) {
		DHCCPM_RQDirectPrint(DictPrintStr);
		Common_PrintLog('T', InitStr, AutoFlag, '', PrintNum);
	}
}
/*
 * 打印高值汇总
 */
function RQPrintInIsTrfHVCol(InitStr, AutoFlag) {
	InitStr = InitStr.toString();
	var InitArr = InitStr.split('^');
	var ArrCount = InitArr.length;
	if (ArrCount <= 0) {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	var PrintNum = parseInt(InitParamObj.PrintNum);
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	var DictPrintStr = '';
	var DictPrintStrLen = '';
	for (var i = 0; i < ArrCount; i++) {
		var Init = InitArr[i];
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
		var RaqName = 'DHCSTM_HUI_InIsTrfHVCol_Common' + RQSuffix;
		if (PrintMode != '') {
			RaqName = 'DHCSTM_HUI_InIsTrfHVCol_Common_' + PrintMode + RQSuffix;
		}
		var Params = '';
		var RQInitStr = Init;
		var PrintStr = '{' + RaqName + '(Params=' + Params + ';Init=' + Init + ';RQInitStr=' + RQInitStr + ')}';
		var RQPrintStr = TranslateRQStr(PrintStr);
		for (var j = 1; j <= PrintNum; j++) {
			if (InitParamObj.IndirPrint != 'N') {
				DHCSTM_DHCCPM_RQPrint(RQPrintStr);
				Common_PrintLog('T', Init, AutoFlag);
			} else {
				if (HISVersion < 8.5) {
					DHCCPM_RQDirectPrint(PrintStr);
					Common_PrintLog('T', Init, AutoFlag);
				} else {
					if (DictPrintStr == '') {
						DictPrintStr = PrintStr;
					} else {
						DictPrintStr = DictPrintStr + PrintStr;
					}
					DictPrintStrLen = DictPrintStr.length;
					if (DictPrintStrLen > 512) {
						$UI.msg('alert', '打印参数超长,本次只能打印' + i + '份单据,请重新选择单据!');
						return;
					}
				}
			}
		}
	}
	if ((HISVersion >= 8.5) && (InitParamObj.IndirPrint == 'N')) {
		DHCCPM_RQDirectPrint(DictPrintStr);
		Common_PrintLog('T', InitStr, AutoFlag, '', PrintNum);
	}
}

/*
 * 打印退库单
 */
function RQPrintInIsTrfReturn(InitStr, AutoFlag) {
	InitStr = InitStr.toString();
	var InitArr = InitStr.split('^');
	var ArrCount = InitArr.length;
	if (ArrCount <= 0) {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	var PrintNum = parseInt(InitParamObj.PrintNum);
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	var DictPrintStr = '';
	var DictPrintStrLen = '';
	for (var i = 0; i < ArrCount; i++) {
		var Init = InitArr[i];
		var InitObj = $.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'Select',
			Init: Init
		}, false);
		var ToLocId = InitObj['InitToLoc']['RowId'];
		var ScgId = InitObj['ScgId'];
		if (isEmpty(ToLocId)) {
			return;
		}
		var PrintMode = GetPrintMode(ToLocId, ScgId);
		var HVFlag = GetCertDocHVFlag(Init, 'T');
		var RaqName = 'DHCSTM_HUI_InIsTrfRet_Common.raq';
		if (HVFlag == 'Y') {
			if (PrintMode != '') {
				RaqName = 'DHCSTM_HUI_InIsTrfRetHVCol_Common_' + PrintMode + RQSuffix;
			} else {
				RaqName = 'DHCSTM_HUI_InIsTrfRetHVCol_Common' + RQSuffix;
			}
		} else {
			if (PrintMode != '') {
				RaqName = 'DHCSTM_HUI_InIsTrfRet_Common_' + PrintMode + RQSuffix;
			} else {
				RaqName = 'DHCSTM_HUI_InIsTrfRet_Common' + RQSuffix;
			}
		}
		var Params = '';
		var RQInitStr = Init + ',K';
		var PrintStr = '{' + RaqName + '(Params=' + Params + ';Init=' + Init + ';RQInitStr=' + RQInitStr + ')}';
		var RQPrintStr = TranslateRQStr(PrintStr);
		for (var j = 1; j <= PrintNum; j++) {
			if (InitParamObj.IndirPrint != 'N') {
				DHCSTM_DHCCPM_RQPrint(RQPrintStr);
				Common_PrintLog('T', Init, AutoFlag);
			} else {
				if (HISVersion < 8.5) {
					DHCCPM_RQDirectPrint(PrintStr);
					Common_PrintLog('T', Init, AutoFlag);
				} else {
					if (DictPrintStr == '') {
						DictPrintStr = PrintStr;
					} else {
						DictPrintStr = DictPrintStr + PrintStr;
					}
					DictPrintStrLen = DictPrintStr.length;
					if (DictPrintStrLen > 512) {
						$UI.msg('alert', '打印参数超长,本次只能打印' + i + '份单据,请重新选择单据!');
						return;
					}
				}
			}
		}
	}
	if ((HISVersion >= 8.5) && (InitParamObj.IndirPrint == 'N')) {
		DHCCPM_RQDirectPrint(DictPrintStr);
		Common_PrintLog('T', InitStr, AutoFlag, '', PrintNum);
	}
}

/*
 * 打印退库单(高值汇总)
 */
function RQPrintInIsTrfReturnHVCol(InitStr, AutoFlag) {
	InitStr = InitStr.toString();
	var InitArr = InitStr.split('^');
	var ArrCount = InitArr.length;
	if (ArrCount <= 0) {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	var PrintNum = parseInt(InitParamObj.PrintNum);
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	var DictPrintStr = '';
	var DictPrintStrLen = '';
	for (var i = 0; i < ArrCount; i++) {
		var Init = InitArr[i];
		var InitObj = $.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'Select',
			Init: Init
		}, false);
		var ToLocId = InitObj['InitToLoc']['RowId'];
		var ScgId = InitObj['ScgId'];
		if (isEmpty(ToLocId)) {
			return;
		}
		var PrintMode = GetPrintMode(ToLocId, ScgId);
		var RaqName = 'DHCSTM_HUI_InIsTrfRetHVCol_Common' + RQSuffix;
		if (PrintMode != '') {
			RaqName = 'DHCSTM_HUI_InIsTrfRetHVCol_Common_' + PrintMode + RQSuffix;
		}
		var Params = '';
		var RQInitStr = Init + ',K';
		var PrintStr = '{' + RaqName + '(Params=' + Params + ';Init=' + Init + ';RQInitStr=' + RQInitStr + ')}';
		var RQPrintStr = TranslateRQStr(PrintStr);
		for (var j = 1; j <= PrintNum; j++) {
			if (InitParamObj.IndirPrint != 'N') {
				DHCSTM_DHCCPM_RQPrint(RQPrintStr);
				Common_PrintLog('T', Init, AutoFlag);
			} else {
				if (HISVersion < 8.5) {
					DHCCPM_RQDirectPrint(PrintStr);
					Common_PrintLog('T', Init, AutoFlag);
				} else {
					if (DictPrintStr == '') {
						DictPrintStr = PrintStr;
					} else {
						DictPrintStr = DictPrintStr + PrintStr;
					}
					DictPrintStrLen = DictPrintStr.length;
					if (DictPrintStrLen > 512) {
						$UI.msg('alert', '打印参数超长,本次只能打印' + i + '份单据,请重新选择单据!');
						return;
					}
				}
			}
		}
	}
	if ((HISVersion >= 8.5) && (InitParamObj.IndirPrint == 'N')) {
		DHCCPM_RQDirectPrint(DictPrintStr);
		Common_PrintLog('T', InitStr, AutoFlag, '', PrintNum);
	}
}