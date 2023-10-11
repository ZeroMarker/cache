function PrintINDispReq(INDispReq) {
	if (INDispReq == null || INDispReq == '') {
		return;
	}
	if (PrintMethod == 0) {
		LodopPrintDispReq(INDispReq);
	} else {
		RQPrintDispReq(INDispReq);
	}
}
function LodopPrintDispReq(INDispReq) {
	// 获取打印次数，是否预览打印，处理打印标志和次数
	var PrintNum = parseInt(INDispReqParamObj.PrintNum);
	var IndirPrint = INDispReqParamObj.IndirPrint;
	// 标志和次数处理
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	// 请领单信息
	var MainObj = GetMainDataDispReq(INDispReq); // 主单信息
	var DetailData = GetDetailDataDispReq(INDispReq); // 明细信息
	var LocDesc = MainObj.LocId.Description;
	var DsrqNo = MainObj.DsrqNo;
	var CreateDate = MainObj.CreateDate;
	var PrintDate = DateFormatter(new Date());
	var ReqUser = MainObj.ReqUser; // 请领人
	var GrpDesc = MainObj.GrpDesc; // 请领专业组
	var CreateUser = MainObj.User;
	var ReqMode = '';
	if (ReqUser != '') {
		ReqMode = '个人请领:' + ReqUser;
	} else {
		ReqMode = '专业组请领:' + GrpDesc;
	}
	// 主单信息展示
	var TaskName = '请领单打印'; // 打印任务名称
	// 标题信息
	var Title = LocDesc + '物资请领单';
	// 页眉信息
	var Head = '单号:' + DsrqNo + '          '
		+ ReqMode + '          '
		+ '制单日期:' + CreateDate;
	// 页尾信息
	var Foot = '打印日期:' + PrintDate + '          '
		+ '制单:' + CreateUser + '          '
		+ '主管:          '
		+ '核对:';
	// 明细信息展示
	var Cols = [
		{ field: 'Num', title: '序号', width: '25px', align: 'center' },
		{ field: 'InciCode', title: '物资代码', width: '13%', align: 'left' },
		{ field: 'InciDesc', title: '物资名称', width: '15%', align: 'left' },
		{ field: 'Spec', title: '规格', width: '10%', align: 'left' },
		{ field: 'Qty', title: '数量', width: '10%', align: 'right', format: '#,##0.00' },
		{ field: 'UomDesc', title: '单位', width: '10%', align: 'left' },
		{ field: 'Manf', title: '生产厂家', width: '20%', align: 'left' },
		{ field: 'Remark', title: '备注', width: '20%', align: 'left' }
	];
	PrintDocument(PrintNum, IndirPrint, TaskName, Title, Head, Foot, Cols, DetailData);
}
function RQPrintDispReq(INDispReq) {
	var RaqName = 'DHCSTM_HUI_InDispReq_Common.raq';
	var DirectPrintStr = '{' + RaqName + '(INDispReq=' + INDispReq + ')}';
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	if (INDispReqParamObj.IndirPrint != 'N') {
		DHCSTM_DHCCPM_RQPrint(RQPrintStr);
	} else {
		DHCCPM_RQDirectPrint(DirectPrintStr);
	}
}
function GetMainDataDispReq(Dsrq) {
	if (isEmpty(Dsrq)) {
		return;
	}
	var DsrqObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINDispReq',
		MethodName: 'Select',
		Dsrq: Dsrq
	}, false);
	return DsrqObj;
}
function GetDetailDataDispReq(Dsrq) {
	if (isEmpty(Dsrq)) {
		return;
	}
	var jsonData = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
		QueryName: 'DHCINDispReqItm',
		Parref: Dsrq
	}, false);
	var DetailData = jsonData.rows;
	return DetailData;
}