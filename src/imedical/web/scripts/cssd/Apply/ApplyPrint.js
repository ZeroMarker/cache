function PrintPackageApply(ApplyStr) {
	if (PrintMethod == 0) {
		var ApplyArr = ApplyStr.split('^');
		var ApplyCount = ApplyArr.length;
		if (ApplyCount <= 0) {
			return;
		}
		for (var i = 0; i < ApplyCount; i++) {
			var ApplyRowId = ApplyArr[i];
			LodopPrint(ApplyRowId);
		}
	} else {
		PrintPackageApplyRQ(ApplyStr);
	}
}
function PrintPackageApplyRQ(ApplyStr) {
	var flag = ApplyParamObj['IndirPrint'];
	var ApplyArr = ApplyStr.split('^');
	var ArrCount = ApplyArr.length;
	if (ArrCount <= 0) {
		return;
	}
	var DictPrintStr = '';
	var DictPrintStrLen = '';
	for (var i = 0; i < ArrCount; i++) {
		var MainId = ApplyArr[i];
		var MainObj = GetMainData(MainId);
		var FromLocId = MainObj.ReqLocId;
		var PrintMode = GetPrintMode(FromLocId);
		var RaqName = 'CSSD_HUI_PackageApply' + RQSuffix;
		if (PrintMode !== '') {
			RaqName = 'CSSD_HUI_PackageApply' + PrintMode + RQSuffix;
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

// 汇总打印
function PrintApplySum(DetailIds) {
	if (isEmpty(DetailIds)) {
		return;
	}
	var RaqName = 'CSSD_HUI_ApplyPrintSum.raq';
	var DirectPrintStr = '{' + RaqName + '(MainIds=' + DetailIds + ')}';
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	CSSD_HUI_RQPrint(RQPrintStr);
}

// 回收申请确认-打印核对
function PrintApplyCheck(DetailIds) {
	if (isEmpty(DetailIds)) {
		return;
	}
	var RaqName = 'CSSD_HUI_ApplyCheck.raq';
	var DirectPrintStr = '{' + RaqName + '(MainIds=' + DetailIds + ')}';
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	CSSD_HUI_RQPrint(RQPrintStr);
}

function LodopPrint(INApplyReq) {
	// 请领单信息
	var PrintNum = 1;
	var MainObj = GetMainData(INApplyReq);
	var DetailData = GetDetailData(INApplyReq);
	var RowId = MainObj.RowId;
	var ReqLocName = MainObj.ReqLocName;
	var ReqDate = MainObj.ReqDateTime;
	var SerialNo = MainObj.SerialNo;
	var PrintDate = DateFormatter(new Date());
	var ReqUserName = MainObj.ReqUserName;
	var SupLocName = MainObj.SupLocName;
	var TaskName = '请领单打印';
	var Title = ReqLocName + '请领单';
	var Head = '单号:' + SerialNo + '  '
		+ '制单日期:' + ReqDate;
	var Foot = '打印日期:' + PrintDate + '  '
		+ '制单人:' + ReqUserName + '  '
		+ '主管:    '
		+ '核对:';
	var Cols = [
		{
			field: 'Num',
			title: '序号',
			width: '20%',
			align: 'center'
		}, {
			field: 'PackageName',
			title: '消毒包',
			width: '20%',
			align: 'left'
		}, {
			field: 'Qty',
			title: '数量',
			width: '20%',
			align: 'right',
			// format: "#,##0.00",
			sum: 'Y'
		}, {
			field: 'Remark',
			title: '备注',
			width: '30%',
			align: 'left'
		}
	];
	PrintDocument(PrintNum, 'N', TaskName, Title, Head, Foot, Cols, DetailData);
}
function GetMainData(RowId) {
	if (isEmpty(RowId)) {
		return;
	}
	var MainObj = $.cm({
		ClassName: 'web.CSSDHUI.Apply.PackageApply',
		MethodName: 'Select',
		RowId: RowId
	}, false);
	return MainObj;
}
function GetDetailData(RowId) {
	if (isEmpty(RowId)) {
		return;
	}
	var jsonData = $.cm({
		ClassName: 'web.CSSDHUI.Apply.PackageApplyItm',
		QueryName: 'SelectByF',
		ApplyId: RowId
	}, false);
	var DetailData = jsonData.rows;
	return DetailData;
}