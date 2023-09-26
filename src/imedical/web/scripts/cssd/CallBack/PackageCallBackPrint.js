function PrintINCallBackReq(INCallBackReq) {
	if (INCallBackReq == null || INCallBackReq == '') {
		return;
	}
	LodopPrint(INCallBackReq);

}
function LodopPrint(INCallBackReq) {
	//获取打印次数，是否预览打印，处理打印标志和次数
	/* var PrintNum = parseInt(INApplyReqParamObj.PrintNum);
	var IndirPrint = INApplyReqParamObj.IndirPrint;
	//标志和次数处理
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	} */
	//请领单信息
	var PrintNum = 1;
	var MainObj = GetMainData(INCallBackReq); //主单信息
	var DetailData = ""
	var DetailData = GetDetailData(INCallBackReq); //明细信息
	var RowId = MainObj.RowId;
	var ReqLocName = MainObj.ReqLocName;
	var PcDate = MainObj.PcDate;
	var SerialNo = MainObj.SerialNo;
	var PrintDate = DateFormatter(new Date());
	var ReqUserName = MainObj.ReqUserName; //提交人
	var SupLocName = MainObj.SupLocName; //请领专业组
	var AckDate = MainObj.AckDate;
	var ToUserName = MainObj.ToUserName;
	var Remark= MainObj.Remark;
	//主单信息展示
	var TaskName = "回收单打印"; //打印任务名称
	//标题信息
	var Title = ReqLocName + "回收单";
	//页眉信息
	var Head = "单号:" + SerialNo + "          "
		+ "回收日期:" + PcDate + "      " +"提交日期:" + AckDate+ "      " +"回收人:" + ToUserName;
	//页尾信息
	var Foot = "打印日期:" + PrintDate + "          "
		+ "制单人:" + ReqUserName + "          "
		+ "主管:          "
		+ "核对:"
		+ "备注:" + Remark;
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

function GetMainData(INCallBackReq) {
	if (isEmpty(INCallBackReq)) {
		return;
	}
	var DsrqObj = $.cm({
		ClassName: 'web.CSSDHUI.CallBack.CallBack',
		MethodName: 'Select',
		INCallBackReq: INCallBackReq
	}, false);
	return DsrqObj;
}
function GetDetailData(INCallBackReq) {
	if (isEmpty(INCallBackReq)) {
		return;
	}
	var jsonData = $.cm({
		ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
		QueryName: 'SelectByF',
		MainId: INCallBackReq
	}, false);
	var DetailData = jsonData.rows;
	return DetailData;
}