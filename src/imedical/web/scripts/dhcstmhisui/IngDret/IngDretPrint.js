
function PrintIngDret(RetId, AutoFlag) {
	if(PrintMethod==0){
		LodopPrintIngDret(RetId, AutoFlag);
	}else{
		RQPrintIngDret(RetId, AutoFlag);
	}
}

function PrintIngDretHVCol(RetId, AutoFlag) {
	if(PrintMethod==0){
		LodopPrintIngDretHVCol(RetId, AutoFlag);
	}else{
		RQPrintIngDretHVCol(RetId, AutoFlag);
	}
}

//退货单Lodop打印
function LodopPrintIngDret(RetId, AutoFlag) {
	if (isEmpty(RetId)) {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	//获取打印次数，是否预览打印，处理打印标志和次数
	var PrintNum = parseInt(IngrtParamObj.PrintNum);
	var IndirPrint = IngrtParamObj.IndirPrint;
	//标志和次数处理
	if (isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	Common_PrintLog('R', RetId, AutoFlag, PrintNum);
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINGdRet',
		MethodName: 'Select',
		RetId: RetId
	},false);
	var DetailData=GetDetailDataIngRet(RetId); //明细信息
	var LocDesc=MainObj.LocDesc;
	var VendorDesc=MainObj.VendorDesc;
	var IngrtNo=MainObj.RetNo;
	var IngrtDate=MainObj.Date;
	var IngrtUser=MainObj.User;
	var PrintDate=DateFormatter(new Date());
	//主单信息展示
	var TaskName="退货单打印";  //打印任务名称
	//标题信息
	var Title=LocDesc+"退货单"; 
	//页眉信息
	var Head="供应商:"+VendorDesc+"      "
			+"退货单号:"+IngrtNo+"      "
			+"退货日期:"+IngrtDate
	//页尾信息
	var Foot="打印日期:"+PrintDate+"          "
			+"主管:"+""+"          "
			+"核对:"+""+"          "
			+"制单人:"+IngrtUser
	//明细信息展示
	var Cols=[
	{field:"Num",title:"序号",width:"25px",align:"center"},
	{field:"Code",title:"物资代码",width:"100px",align:"left"},
	{field:"Description",title:"物资名称",width:"100px",align:"left"},
	{field:"Spec",title:"规格",width:"100px",align:"left"},
	{field:"SpecDesc",title:"具体规格",width:"100px",align:"left"},
	{field:"UomDesc",title:"单位",width:"100px",align:"left"},
	{field:"Qty",title:"数量",width:"100px",align:"right",format:"#,##0.00"},
	{field:"BatNo",title:"批号",width:"100px",align:"left"},
	{field:"ExpDate",title:"有效期",width:"100px",align:"left"},
	{field:"Rp",title:"进价",width:"100px",align:"right",format:"#,##0.00"},
	{field:"Sp",title:"售价",width:"100px",align:"right",format:"#,##0.00"},
	{field:"RpAmt",title:"进价金额",width:"100px",align:"right",format:"#,##0.00",sum:"Y"},
	{field:"SpAmt",title:"售价金额",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
	];
	PrintDocument(PrintNum,IndirPrint,TaskName,Title,Head,Foot,Cols,DetailData)
}
//高值退货单Lodop打印
function LodopPrintIngDretHVCol(RetId, AutoFlag) {
	if (isEmpty(RetId)) {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	//获取打印次数，是否预览打印，处理打印标志和次数
	var PrintNum = parseInt(IngrtParamObj.PrintNum);
	var IndirPrint = IngrtParamObj.IndirPrint;
	//标志和次数处理
	if (isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	Common_PrintLog('R', RetId, AutoFlag, PrintNum);
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINGdRet',
		MethodName: 'Select',
		RetId: RetId
	},false);
	var DetailData=GetHVColDetailData(RetId); //明细信息
	var LocDesc=MainObj.LocDesc;
	var VendorDesc=MainObj.VendorDesc;
	var IngrtNo=MainObj.RetNo;
	var IngrtDate=MainObj.Date;
	var IngrtUser=MainObj.User;
	var PrintDate=DateFormatter(new Date());
	//主单信息展示
	var TaskName="高值退货单打印";  //打印任务名称
	//标题信息
	var Title=LocDesc+"高值退货单"; 
	//页眉信息
	var Head="供应商:"+VendorDesc+"      "
			+"退货单号:"+IngrtNo+"      "
			+"退货日期:"+IngrtDate
	//页尾信息
	var Foot="打印日期:"+PrintDate+"          "
			+"主管:"+""+"          "
			+"核对:"+""+"          "
			+"制单人:"+IngrtUser
	//明细信息展示
	var Cols=[
	{field:"Num",title:"序号",width:"25px",align:"center"},
	{field:"InciCode",title:"物资代码",width:"100px",align:"left"},
	{field:"InciDesc",title:"物资名称",width:"100px",align:"left"},
	{field:"Spec",title:"规格",width:"100px",align:"left"},
	{field:"SpecDesc",title:"具体规格",width:"100px",align:"left"},
	{field:"UomDesc",title:"单位",width:"100px",align:"left"},
	{field:"Qty",title:"数量",width:"100px",align:"right",format:"#,##0.00"},
	{field:"BatNo",title:"批号",width:"100px",align:"left"},
	{field:"ExpDate",title:"有效期",width:"100px",align:"left"},
	{field:"Rp",title:"进价",width:"100px",align:"right",format:"#,##0.00"},
	{field:"Sp",title:"售价",width:"100px",align:"right",format:"#,##0.00"},
	{field:"RpAmt",title:"进价金额",width:"100px",align:"right",format:"#,##0.00",sum:"Y"},
	{field:"SpAmt",title:"售价金额",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
	];
	PrintDocument(PrintNum,IndirPrint,TaskName,Title,Head,Foot,Cols,DetailData)
}

function GetDetailDataIngRet(RetId) {
	if (isEmpty(RetId)) {
		return;
	}
	var jsonData = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINGrtItm',
		QueryName: 'DHCINGdRetItm',
		RetId: RetId,
		rows:99999
	},false);
	var DetailData=jsonData.rows;
	return DetailData;
}

function GetHVColDetailData(RetId) {
	if (isEmpty(RetId)) {
		return;
	}
	var jsonData = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINGrtItm',
		QueryName: 'QueryHVColDetail',
		RetId: RetId,
		rows:99999
	},false);
	var DetailData=jsonData.rows;
	return DetailData;
}

function RQPrintIngDret(Ingrt, AutoFlag) {
	if (isEmpty(Ingrt)) {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINGdRet',
		MethodName: 'Select',
		RetId: Ingrt
	},false);
	var Ingrtloc=MainObj.INGRTCTLOCDR;
	var Ingrtscg=MainObj.INGRTCTLOCDR;
	var PrintModeData = GetPrintMode(Ingrtloc,Ingrtscg);
	var PrintMode = PrintModeData.split("^")[0];
	var RaqName = 'DHCSTM_HUI_IngDret_Common.raq';
	if (PrintMode == 'MO') {
		RaqName = 'DHCSTM_HUI_IngDret_MO_Common.raq';
	}
	fileName = "{" + RaqName + "(RetId=" + Ingrt + ")}";

	var PrintNum = parseInt(IngrtParamObj.PrintNum);
	if (PrintNum <= 0) {
		PrintNum = 1;
	}
	for (var i = 1; i <= PrintNum; i++) {
		if (IngrtParamObj.IndirPrint != "N") {
			var transfileName = TranslateRQStr(fileName);
			DHCSTM_DHCCPM_RQPrint(transfileName);
		} else {
			DHCCPM_RQDirectPrint(fileName);
		}
		Common_PrintLog('R', Ingrt, AutoFlag);
	}
}
function RQPrintIngDretHVCol(Ingrt, AutoFlag) {
	if (isEmpty(Ingrt)) {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINGdRet',
		MethodName: 'Select',
		RetId: Ingrt
	},false);
	var Ingrtloc=MainObj.INGRTCTLOCDR;
	var Ingrtscg=MainObj.INGRTCTLOCDR;
	var PrintModeData = GetPrintMode(Ingrtloc,Ingrtscg);
	var PrintMode = PrintModeData.split("^")[0];
	var RaqName = 'DHCSTM_HUI_IngDretHVCol_Common.raq';
	if (PrintMode == 'MO') {
		RaqName = 'DHCSTM_HUI_IngDretHVCol_MO_Common.raq';
	}
	fileName = "{" + RaqName + "(RetId=" + Ingrt + ")}";

	var PrintNum = parseInt(IngrtParamObj.PrintNum);
	if (PrintNum <= 0) {
		PrintNum = 1;
	}
	for (var i = 1; i <= PrintNum; i++) {
		if (IngrtParamObj.IndirPrint != "N") {
			var transfileName = TranslateRQStr(fileName);
			DHCCPM_RQPrint(transfileName);
		} else {
			DHCCPM_RQDirectPrint(fileName);
		}
		Common_PrintLog('R', Ingrt, AutoFlag);
	}
}