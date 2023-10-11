function PrintDispMain(DispStr) {
	if (PrintMethod == 0) {
		var DispArr = DispStr.split('^');
		var DispCount = DispArr.length;
		if (DispCount <= 0) {
			return;
		}
		for (var i = 0; i < DispCount; i++) {
			var DispRowId = DispArr[i];
			LodopPrint(DispRowId);
			}
		} else {
		PrintOrpDispRQ(DispStr);
	}
}

// 标牌追溯包打印-润乾
function PrintOrpDisp(RowId) {
	if (isEmpty(RowId)) {
		return;
	}
	var MainObj = GetMainData(RowId);
	var FromLocId = MainObj.FromLocId;
	var PrintMode = GetPrintMode(FromLocId);
	var RaqName = 'CSSD_HUI_OprDispBill.raq';
	if (PrintMode !== '') {
		RaqName = 'CSSD_HUI_OprDispBill_' + PrintMode + '.raq';
	}
	var DirectPrintStr = '{' + RaqName + '(MainIds=' + RowId + ')}';
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	CSSD_HUI_RQPrint(RQPrintStr);
}
// 标牌追溯包批量打印-润乾
function PrintOrpDispRQ(DispStr) {
	var flag=DispParamObj['IndirPrint'];
	var IngrArr = DispStr.split('^');
	var ArrCount = IngrArr.length;
	if (ArrCount <= 0) {
		return;
	}
	var DictPrintStr = '';
	var DictPrintStrLen = '';
	for (var i = 0; i < ArrCount; i++) {
		var ingr = IngrArr[i];
		var MainObj = GetMainData(ingr);
		var FromLocId = MainObj.FromLocId;
		var PrintMode = GetPrintMode(FromLocId);
		var RaqName = 'CSSD_HUI_OprDispBill'+RQSuffix;
		if (PrintMode !== '') {
			RaqName = 'CSSD_HUI_OprDispBill_' + PrintMode + RQSuffix;
		}
		var DirectPrintStr = '{' + RaqName + '(MainIds=' + ingr + ')}';
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
				}
			}
	}
	if ((HISVersion >= 8.5)&&(flag!="N" )) {
		DHCCPM_RQDirectPrint(DictPrintStr);
	}
	
}
function PrintINDispSum(RaqName, DetailIds) {
	if (isEmpty(DetailIds)) {
		return;
	}
	var DirectPrintStr = '{' + RaqName + '(MainIds=' + DetailIds + ')}';
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	CSSD_HUI_RQPrint(RQPrintStr);
}
function LodopPrint(DispMainId) {
	// 请领单信息
	var PrintNum = 1;
	var MainObj = GetMainData(DispMainId);
	var DetailData = GetDetailData(DispMainId);
	var DispDate = MainObj.DispDate;
	var SerialNo = MainObj.SerialNo;
	var PrintDate = DateFormatter(new Date());
	var FromUserName = MainObj.FromUserName;
	var ToLocName = MainObj.ToLocName; // 请领专业组
	var TaskName = '请领单打印';
	var Title = ToLocName + '发放单';
	var Head = '单号:' + SerialNo + '          '
		+ '制单日期:' + DispDate;
	// 页尾信息
	var Foot = '打印日期:' + PrintDate + '          '
		+ '制单:' + FromUserName + '          '
		+ '主管:          '
		+ '核对:';
	// 明细信息展示
	var Cols = [{
		field: 'Num',
		title: '序号',
		width: '5px',
		align: 'center'
	}, {
		field: 'PackageName',
		title: '消毒包',
		width: '43%',
		align: 'left'
	}, {
		field: 'Qty',
		title: '数量',
		width: '10%',
		align: 'right',
		sum: 'Y'
	}, {
		field: 'Price',
		title: '价格',
		width: '10%',
		align: 'right'
	}, {
		field: 'TotalPrice',
		title: '合计价格',
		width: '20%',
		align: 'right',
		sum: 'Y'
	}
	];
	PrintDocument(PrintNum, 'N', TaskName, Title, Head, Foot, Cols, DetailData);
}
function GetMainData(DispMainId) {
	if (isEmpty(DispMainId)) {
		return;
	}
	var DispMainObj = $.cm({
		ClassName: 'web.CSSDHUI.PackageDisp.DispScan',
		MethodName: 'Select',
		DispMainId: DispMainId
	}, false);
	return DispMainObj;
}
function GetDetailData(DispMainId) {
	if (isEmpty(DispMainId)) {
		return;
	}
	var jsonData = $.cm({
		ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
		QueryName: 'SelectByF',
		MainId: DispMainId,
		rows: 9999999
	}, false);
	var DetailData = jsonData.rows;
	return DetailData;
}