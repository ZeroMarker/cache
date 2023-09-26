function PrintINDispReq(INDispReq) {
	if (INDispReq == null || INDispReq == '') {
		return;
	}
	LodopPrint(INDispReq);

}
function LodopPrint(INDispReq) {
	//获取打印次数，是否预览打印，处理打印标志和次数
	/* var PrintNum = parseInt(INDispReqParamObj.PrintNum);
	var IndirPrint = INDispReqParamObj.IndirPrint;
	//标志和次数处理
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	} */
	//请领单信息
	var PrintNum = 1;
	var MainObj = GetMainData(INDispReq); //主单信息
	var DetailData = ""
	var DetailData = GetDetailData(INDispReq); //明细信息
	var RowId = MainObj.RowId;
	var FromLocName = MainObj.FromLocName;
	var DispDate = MainObj.DispDate;
	var SerialNo = MainObj.SerialNo;
	var PrintDate = DateFormatter(new Date());
	var FromUserName = MainObj.FromUserName; //请领人
	var ToLocName = MainObj.ToLocName; //请领专业组

	//主单信息展示
	var TaskName = "请领单打印"; //打印任务名称
	//标题信息
	var Title = ToLocName + "发放单";
	//页眉信息
	var Head = "单号:" + SerialNo + "          "
		+ "制单日期:" + DispDate;
	//页尾信息
	var Foot = "打印日期:" + PrintDate + "          "
		+ "制单:" + FromUserName + "          "
		+ "主管:          "
		+ "核对:";
	//明细信息展示
	var Cols = [{
			field: "Num",
			title: "序号",
			width: "5px",
			align: "center"
		}, {
			field: "PackageName",
			title: "消毒包",
			width: "43%",
			align: "left"
		}, {
			field: "Qty",
			title: "数量",
			width: "50%",
			align: "right",
			format: "#,##0.00",
			sum: "Y"
		}
	];
	PrintDocument(PrintNum, "N", TaskName, Title, Head, Foot, Cols, DetailData);
}

function GetMainData(Dsrq) {
	if (isEmpty(Dsrq)) {
		return;
	}
	var DsrqObj = $.cm({
		ClassName: 'web.CSSDHUI.Disp.Disp',
		MethodName: 'Select',
		Dsrq: Dsrq
	}, false);
	return DsrqObj;
}
function GetDetailData(Dsrq) {
	if (isEmpty(Dsrq)) {
		return;
	}
	var jsonData = $.cm({
		ClassName: 'web.CSSDHUI.Disp.DispItem',
		QueryName: 'SelectByF',
		MainId: Dsrq,
		rows:9999999
	}, false);
	var DetailData = jsonData.rows;
	return DetailData;
}