function PrintINDispRet(INDispRet) {
	if (INDispRet == null || INDispRet == '') {
		return;
	}
	if (PrintMethod == 0) {
		LodopPrintDispRet(INDispRet);
	} else {
		RQPrintDispRet(INDispRet);
	}
}
function LodopPrintDispRet(INDispRet) {
	// 获取打印次数，是否预览打印，处理打印标志和次数
	var PrintNum = parseInt(INDispRetParamObj.PrintNum);
	var IndirPrint = INDispRetParamObj.IndirPrint;
	// 标志和次数处理
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	// 发放单信息
	var MainObj = GetMainDataDispRet(INDispRet); // 主单信息
	var DetailData = GetDetailDataDispRet(INDispRet); // 明细信息
	var LocDesc = MainObj.LocId.Description;
	var DsrNo = MainObj.DsrNo;
	var CreateDate = MainObj.CreateDate;
	var PrintDate = DateFormatter(new Date());
	var CreateUser = MainObj.User;
	// 主单信息展示
	var TaskName = '退回单打印'; // 打印任务名称
	// 标题信息
	var Title = LocDesc + '物资退回单';
	// 页眉信息
	var Head = '单号:' + DsrNo + '          '
		+ '制单日期:' + CreateDate;
	// 页尾信息
	var Foot = '打印日期:' + PrintDate + '          '
		+ '制单:' + CreateUser + '          '
		+ '主管:          '
		+ '核对:';
	// 明细信息展示
	var Cols = [
		{ field: 'Num', title: '序号', width: '25px', align: 'center' },
		{ field: 'InciCode', title: '物资代码', width: '10%', align: 'left' },
		{ field: 'InciDesc', title: '物资名称', width: '15%', align: 'left' },
		{ field: 'Spec', title: '规格', width: '7%', align: 'left' },
		{ field: 'BatchNo', title: '批号', width: '7%', align: 'left' },
		{ field: 'ExpDate', title: '效期', width: '7%', align: 'left' },
		{ field: 'Qty', title: '数量', width: '5%', align: 'right', format: '#,##0.00' },
		{ field: 'UomDesc', title: '单位', width: '5%', align: 'left' },
		{ field: 'Rp', title: '进价', width: '5%', align: 'right', format: '#,##0.00' },
		{ field: 'RpAmt', title: '进价总额', width: '8%', align: 'right', format: '#,##0.00' },
		{ field: 'Sp', title: '售价', width: '5%', align: 'right', format: '#,##0.00' },
		{ field: 'SpAmt', title: '售价总额', width: '8%', align: 'right', format: '#,##0.00' },
		{ field: 'Manf', title: '生产厂家', width: '10%', align: 'left' },
		{ field: 'Remark', title: '备注', width: '8%', align: 'left' }
	];
	PrintDocument(PrintNum, IndirPrint, TaskName, Title, Head, Foot, Cols, DetailData);
}
function RQPrintDispRet(INDispRet) {
	var RaqName = 'DHCSTM_HUI_InDispRet_Common.raq';
	var DirectPrintStr = '{' + RaqName + '(INDispRet=' + INDispRet + ')}';
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	if (INDispRetParamObj.IndirPrint != 'N') {
		DHCSTM_DHCCPM_RQPrint(RQPrintStr);
	} else {
		DHCCPM_RQDirectPrint(DirectPrintStr);
	}
}
function GetMainDataDispRet(Dsr) {
	if (isEmpty(Dsr)) {
		return;
	}
	var DsrObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINDispRet',
		MethodName: 'Select',
		Dsr: Dsr
	}, false);
	return DsrObj;
}
function GetDetailDataDispRet(Dsr) {
	if (isEmpty(Dsr)) {
		return;
	}
	var jsonData = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINDispRetItm',
		QueryName: 'DHCINDispRetItm',
		Parref: Dsr
	}, false);
	var DetailData = jsonData.rows;
	return DetailData;
}