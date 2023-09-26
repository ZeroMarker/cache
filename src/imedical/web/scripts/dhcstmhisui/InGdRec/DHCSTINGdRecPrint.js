
function PrintRec(ingr, AutoFlag) {
	if(PrintMethod==0){
		LodopPrintRec(ingr,AutoFlag)
	}else{
		RQPrintRec(ingr,AutoFlag)
	}
}

function PrintRecHVCol(ingr, AutoFlag) {
	if(PrintMethod==0){
		LodopPrintRecHVCol(ingr,AutoFlag)
	}else{
		RQPrintRecHVCol(ingr,AutoFlag)
	}
}

//入库单Lodop打印
function LodopPrintRec(ingr,AutoFlag) {
	if (isEmpty(ingr)) {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	
	//获取打印次数，是否预览打印，处理打印标志和次数
	var PrintNum = parseInt(IngrParamObj.PrintNum);
	var IndirPrint = IngrParamObj.IndirPrint;
	//标志和次数处理
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	PrintFlag(ingr);
	Common_PrintLog('G', ingr, AutoFlag, PrintNum);
	
	//入库单信息
	var MainObj = GetIngrMainData(ingr); //主单信息
	var DetailData=GetDetailDataRec(ingr); //明细信息
	var LocDesc=MainObj.RecLoc.Description;
	var VendorDesc=MainObj.Vendor.Description;
	var IngrNo=MainObj.InGrNo;
	var CreateDate=MainObj.CreateDate;
	var PrintDate=DateFormatter(new Date());
	var AuditUser=MainObj.AuditUser.Description;
	var PurUser=MainObj.PurchaseUser.Description;
	var CreateUser=MainObj.CreateUser.Description;
	//主单信息展示
	var TaskName="入库单打印";  //打印任务名称
	//标题信息
	var Title=LocDesc+"入库单"; 
	//页眉信息
	var Head="供应商:"+VendorDesc+"          "
			+"入库单号:"+IngrNo+"          "
			+"制单日期:"+CreateDate;
	//页尾信息
	var Foot="打印日期:"+PrintDate+"          "
			+"制单:"+CreateUser+"          "
			+"审核:"+AuditUser+"          "
			+"采购:"+PurUser+"          "
			+"会计:";
	//明细信息展示
	var Cols=[
	{field:"Num",title:"序号",width:"25px",align:"center"},
	{field:"IncCode",title:"物资代码",width:"10%",align:"left"},
	{field:"IncDesc",title:"物资名称",width:"13%",align:"left"},
	{field:"Spec",title:"规格",width:"7%",align:"left"},
	{field:"Model",title:"型号",width:"7%",align:"left"},
	{field:"BatchNo",title:"批号",width:"7%",align:"left"},
	{field:"ExpDate",title:"有效期",width:"8%",align:"left"},
	{field:"IngrUom",title:"单位",width:"5%",align:"left"},
	{field:"RecQty",title:"数量",width:"5%",align:"right",format:"#,##0.00"},
	{field:"Rp",title:"进价",width:"6%",align:"right",format:"#,##0.00"},
	{field:"RpAmt",title:"进价金额",width:"8%",align:"right",format:"#,##0.00",sum:"Y"},
	{field:"InvNo",title:"发票号",width:"7%",align:"left"},
	{field:"SpecDesc",title:"具体规格",width:"7%",align:"left"},
	{field:"Manf",title:"厂商",width:"10%",align:"left"}
//	{field:"Sp",title:"售价",width:"100px",align:"right",format:"#,##0.00"},
//	{field:"SpAmt",title:"售价金额",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
	];
	
	PrintDocument(PrintNum,IndirPrint,TaskName,Title,Head,Foot,Cols,DetailData)
}
//高值入库单Lodop打印
function LodopPrintRecHVCol(ingr, AutoFlag) {
	if (isEmpty(ingr)) {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	
	//获取打印次数，是否预览打印，处理打印标志和次数
	var PrintNum = parseInt(IngrParamObj.PrintNum);
	var IndirPrint = IngrParamObj.IndirPrint;
	//标志和次数处理
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	PrintFlag(ingr);
	Common_PrintLog('G', ingr, AutoFlag, PrintNum);
	
	//入库单信息
	var MainObj = GetIngrMainData(ingr); //主单信息
	var DetailData=GetHVColDetailData(ingr); //明细信息
	var LocDesc=MainObj.RecLoc.Description;
	var VendorDesc=MainObj.Vendor.Description;
	var IngrNo=MainObj.InGrNo;
	var CreateDate=MainObj.CreateDate;
	var PrintDate=DateFormatter(new Date());
	var AuditUser=MainObj.AuditUser.Description;
	var PurUser=MainObj.PurchaseUser.Description;
	var CreateUser=MainObj.CreateUser.Description;
	//主单信息展示
	var TaskName="高值入库单打印";  //打印任务名称
	//标题信息
	var Title=LocDesc+"高值入库单"; 
	//页眉信息
	var Head="供应商:"+VendorDesc+"          "
			+"入库单号:"+IngrNo+"          "
			+"制单日期:"+CreateDate
	//页尾信息
	var Foot="打印日期:"+PrintDate+"          "
			+"审核人:"+AuditUser+"          "
			+"采购人:"+PurUser+"          "
			+"制单人:"+CreateUser
	//明细信息展示
	var Cols=[
	{field:"Num",title:"序号",width:"25px",align:"center"},
	{field:"InciCode",title:"物资代码",width:"100px",align:"left"},
	{field:"InciDesc",title:"物资名称",width:"100px",align:"left"},
	{field:"Spec",title:"规格",width:"100px",align:"left"},
	{field:"SpecDesc",title:"具体规格",width:"100px",align:"left"},
	{field:"BatNo",title:"批号",width:"100px",align:"left"},
	{field:"ExpDate",title:"有效期",width:"100px",align:"left"},
	{field:"InvNo",title:"发票号",width:"100px",align:"left"},
	{field:"ManfDesc",title:"厂商",width:"100px",align:"left"},
	{field:"IngrUomDesc",title:"单位",width:"100px",align:"left"},
	{field:"RecQty",title:"数量",width:"100px",align:"right",format:"#,##0.00"},
	{field:"Rp",title:"进价",width:"100px",align:"right",format:"#,##0.00"},
	{field:"Sp",title:"售价",width:"100px",align:"right",format:"#,##0.00"},
	{field:"RpAmt",title:"进价金额",width:"100px",align:"right",format:"#,##0.00",sum:"Y"},
	{field:"SpAmt",title:"售价金额",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
	];
	
	PrintDocument(PrintNum,IndirPrint,TaskName,Title,Head,Foot,Cols,DetailData)
}

//名称: 入库单打印
function RQPrintRec(ingr, AutoFlag) {
	if (isEmpty(ingr)) {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	var IngrObj = GetIngrMainData(ingr);
	var ScgId = IngrObj.StkGrpId;
	var RecLoc = IngrObj.RecLocId;
	if(isEmpty(RecLoc)){
		return;
	}
	var PrintModeData = GetPrintMode(RecLoc, ScgId);
	var RaqName = 'DHCSTM_HUI_StockRec_Common.raq';
	if (PrintModeData == 'MO') {
		RaqName = 'DHCSTM_HUI_StockRec_MO_Common.raq';
	}
	var fileName = "{" + RaqName + "(Parref=" + ingr + ")}";
	var PrintNum = parseInt(IngrParamObj.PrintNum);
	if (isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	for (var i = 1; i <= PrintNum; i++) {
		if (IngrParamObj.IndirPrint != "N") {
			var transfileName = TranslateRQStr(fileName);
			DHCSTM_DHCCPM_RQPrint(transfileName);
		} else {
			DHCCPM_RQDirectPrint(fileName);
		}
		Common_PrintLog('G', ingr, AutoFlag);
	}
	PrintFlag(ingr);
}

function RQPrintRecHVCol(ingr, AutoFlag) {
	if (isEmpty(ingr)) {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	var IngrObj = GetIngrMainData(ingr);
	var ScgId = IngrObj.StkGrpId;
	var RecLoc = IngrObj.ReqLocId;
	var PrintModeData = GetPrintMode(RecLoc, ScgId);
	var RaqName = 'DHCSTM_HUI_StockRecHVCol_Common.raq';
	if (PrintModeData == 'MO') {
		RaqName = 'DHCSTM_HUI_StockRecHVCol_MO_Common.raq';
	}
	var fileName = "{" + RaqName + "(Parref=" + ingr + ")}";
	var PrintNum = parseInt(IngrParamObj.PrintNum);
	if (isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	for (var i = 1; i <= PrintNum; i++) {
		if (IngrParamObj.IndirPrint != "N") {
			var transfileName = TranslateRQStr(fileName);
			DHCCPM_RQPrint(transfileName);
		} else {
			DHCCPM_RQDirectPrint(fileName);
		}
		Common_PrintLog('G', ingr, AutoFlag);
	}
	PrintFlag(ingr);
}

function PrintRecBill(ingr) {
	if (isEmpty(ingr)) {
		return;
	}
	var IngrObj = GetIngrMainData(ingr);
	var vendor = IngrObj.Vendor;
	var ingrNo = IngrObj.InGrNo;
	var ingrDate = IngrObj.CreateDate;
	var AuditDate = IngrObj.AuditDate; 
	var MyPara = 'Vendor' + String.fromCharCode(2) + vendor;
	MyPara = MyPara + '^IngrNo' + String.fromCharCode(2) + ingrNo;
	MyPara = MyPara + '^IngrDate' + String.fromCharCode(2) + ingrDate;

	var myList = "";
	var detailArr = GetDetailDataRec(ingr);
	for (i = 0; i < detailArr.length; i++) {
		var detailObj = detailArr[i];
		var inciCode = detailObj.IncCode;
		var inciDesc = detailObj.IncDesc;
		var spec = "";
		var ingrUom = detailObj.IngrUom;
		var batNo = detailObj.BatchNo;
		var manf = detailObj.Manf;
		var qty = detailObj.RecQty;
		var rp = detailObj.Rp;
		var rpAmt = detailObj.RpAmt;
		var sp = detailObj.Sp;
		var spAmt = detailObj.SpAmt;
		var marAmt = spAmt - rpAmt;
		var firstdesc = inciCode + " " + inciDesc + " " + spec + " " + ingrUom + " " + batNo + " " + manf + " " + qty + " " + rp + " " + rpAmt + " " + sp + " " + spAmt + " " + marAmt;
		if (myList == '') {
			myList = firstdesc;
		} else {
			myList = myList + String.fromCharCode(2) + firstdesc;
		}
	}
	DHCP_GetXMLConfig("DHCSTGdRecPrt");
	DHCP_PrintFun(MyPara, myList);
}

/*
 * creator:zhangdongmei,2012-11-13
 * description:取入库明细信息
 * params: ingr:入库主表id
 * return:
 * */
function GetDetailDataRec(ingr) {
	if (isEmpty(ingr)) {
		return;
	}
	var jsonData = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
		QueryName: 'QueryDetail',
		Parref: ingr,
		rows:99999
	},false);
	var DetailData=jsonData.rows;
	return DetailData;
}
/*
 * creator:zhangdongmei,2012-11-13
 * description:取入库明细信息
 * params: ingr:入库主表id
 * return:
 * */
function GetHVColDetailData(ingr) {
	if (isEmpty(ingr)) {
		return;
	}
	var jsonData = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
		QueryName: 'QueryHVColDetail',
		Parref: ingr,
		rows:99999
	},false);
	var DetailData=jsonData.rows;
	return DetailData;
}

/*
 * description:取入库主表信息
 * params: ingr:入库主表id
 * return:
*/
function GetIngrMainData(ingr) {
	if (isEmpty(ingr)) {
		return;
	}
	var IngrObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINGdRec',
		MethodName: 'Select',
		Ingr: ingr
	},false);
	return IngrObj;
}
function PrintFlag(ingr) {
	if (isEmpty(ingr)) {
		return;
	}
	$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'PrintFlag',
			IngrId: ingr
		},function(jsonData){
			if (jsonData.success!=0)
			{$UI.msg('alert',jsonData.msg);}
		});
}

