
function PrintINBackCount(DetailIds) {
	if (isEmpty(DetailIds)) {
		return;
	}
	var RaqName = 'CSSD_HUI_CallBackPrintCount.raq';
	var DirectPrintStr = '{' + RaqName + '(MainIds=' + DetailIds + ')}';
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	CSSD_HUI_RQPrint(RQPrintStr);
}
function PrintCallBack(CallBackStr) {
	if (PrintMethod == 0) {
		var CallBackArr = CallBackStr.split('^');
		var CallBackCount = CallBackArr.length;
		if (CallBackCount <= 0) {
			return;
		}
		for (var i = 0; i < CallBackCount; i++) {
			var CallBackRowId = CallBackArr[i];
			LodopPrint(CallBackRowId);
		}
	} else {
		PrintCallBackRQ(CallBackStr);
	}
}
function PrintCallBackRQ(CallBackStr) {
	var flag = CallBackParamObj['IndirPrint'];
	var CallBackArr = CallBackStr.split('^');
	var CallBackCount = CallBackArr.length;
	if (CallBackCount <= 0) {
		return;
	}
	var DictPrintStr = '';
	var DictPrintStrLen = '';
	for (var i = 0; i < CallBackCount; i++) {
		var MainId = CallBackArr[i];
		var MainObj = GetMainData(MainId);
		var ToLocId = MainObj.ToLocId;
		var PrintMode = GetPrintMode(ToLocId);
		var RaqName = 'CSSD_HUI_CallBack' + RQSuffix;
		if (PrintMode !== '') {
			RaqName = 'CSSD_HUI_CallBack' + PrintMode + RQSuffix;
		}
		var DirectPrintStr = '{' + RaqName + '(MainId=' + MainId + ')}';
		var RQPrintStr = TranslateRQStr(DirectPrintStr);
		if (flag != 'N') {
			CSSD_HUI_RQPrint(RQPrintStr);
		} else {
			if (HISVersion < 8.5) {
				DHCCPM_RQDirectPrint(DirectPrintStr);
			} else {
				if (DictPrintStr == '') {
					DictPrintStr = DirectPrintStr;
				} else {
					DictPrintStr = DictPrintStr + DirectPrintStr;
				}
				DictPrintStrLen = DictPrintStr.length;
				if (DictPrintStrLen > 512) {
					$UI.msg('alert', '打印参数超长,本次只能打印' + i + '份单据,请重新选择单据!');
					return;
				}
				DHCCPM_RQDirectPrint(DictPrintStr);
			}
		}
	}
}
function LodopPrint(INCallBackReq) {
	// 请领单信息
	var PrintNum = 1;
	var MainObj = GetMainData(INCallBackReq);
	var DetailData = GetDetailData(INCallBackReq);
	var RowId = MainObj.RowId;
	var ReqLocName = MainObj.ReqLocName;
	var PcDate = MainObj.PcDate;
	var SerialNo = MainObj.SerialNo;
	var PrintDate = MainObj.PrintDate;
	var ReqUserName = MainObj.ReqUserName;
	var SupLocName = MainObj.SupLocName;
	var AckDate = MainObj.AckDate;
	var ToUserName = MainObj.ToUserName;
	var Remark = MainObj.Remark;
	var TaskName = '回收单打印'; // 打印任务名称
	var Title = ReqLocName + '回收单';
	// 页眉信息
	var Head = '单号:' + SerialNo + '          '
		+ '回收日期:' + PcDate + '      ' + '提交日期:' + AckDate + '      ' + '回收人:' + ToUserName;
	// 页尾信息
	var Foot = '打印日期:' + PrintDate + '          '
		+ '制单人:' + ReqUserName + '          '
		+ '主管:          '
		+ '核对:'
		+ '备注:' + Remark;
	var Cols = [
		{
			field: 'Num',
			title: '序号',
			width: '15%',
			align: 'center'
		}, {
			field: 'PackageName',
			title: '消毒包',
			width: '45%',
			align: 'left'
		}, {
			field: 'ReqQty',
			title: '申请数量',
			width: '10%',
			align: 'right',
			// format: "#,##0.00",
			sum: 'Y'
		}, {
			field: 'Qty',
			title: '回收数量',
			width: '10%',
			align: 'right',
			// format: "#,##0.00",
			sum: 'Y'
		}, {
			field: 'DispQty',
			title: '发放数量',
			width: '10%',
			align: 'right',
			// format: "#,##0.00",
			sum: 'Y'
		}, {
			field: 'Price',
			title: '价格',
			width: '10%',
			align: 'right',
			sum: 'Y'
		}, {
			field: 'TotalPrice',
			title: '合计价格',
			width: '15%',
			align: 'right',
			sum: 'Y'
		}
	];
	PrintDocument(PrintNum, 'N', TaskName, Title, Head, Foot, Cols, DetailData);
}
function GetMainData(INCallBackReq) {
	if (isEmpty(INCallBackReq)) {
		return;
	}
	var CBObj = $.cm({
		ClassName: 'web.CSSDHUI.CallBack.CallBack',
		MethodName: 'Select',
		CallbackId: INCallBackReq
	}, false);
	return CBObj;
}
function GetDetailData(INCallBackReq) {
	if (isEmpty(INCallBackReq)) {
		return;
	}
	var jsonData = $.cm({
		ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
		QueryName: 'SelectByF',
		MainId: INCallBackReq,
		rows: 9999
	}, false);
	var DetailData = jsonData.rows;
	return DetailData;
}