
function PrintRec(IngrStr, AutoFlag) {
	IngrStr = IngrStr.toString();
	if (PrintMethod == 0) {
		var IngrArr = IngrStr.split('^');
		var IngrCount = IngrArr.length;
		if (IngrCount <= 0) {
			return;
		}
		for (var i = 0; i < IngrCount; i++) {
			var ingr = IngrStr[i];
			var HVFlag = GetCertDocHVFlag(ingr, 'G');
			if (HVFlag == 'Y') {
				LodopPrintRec(ingr, AutoFlag);
			} else {
				LodopPrintRecHVCol(ingr, AutoFlag);
			}
		}
	} else {
		RQPrintRec(IngrStr, AutoFlag);
	}
}

function PrintRecHVCol(IngrStr, AutoFlag) {
	IngrStr = IngrStr.toString();
	if (PrintMethod == 0) {
		var IngrArr = IngrStr.split('^');
		var IngrCount = IngrArr.length;
		if (IngrCount <= 0) {
			return;
		}
		for (var i = 0; i < IngrCount; i++) {
			var ingr = IngrStr[i];
			LodopPrintRecHVCol(ingr, AutoFlag);
		}
	} else {
		RQPrintRecHVCol(IngrStr, AutoFlag);
	}
}

// 入库单Lodop打印
function LodopPrintRec(ingr, AutoFlag) {
	if (isEmpty(ingr)) {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	
	// 获取打印次数，是否预览打印，处理打印标志和次数
	var PrintNum = parseInt(IngrParamObj.PrintNum);
	var IndirPrint = IngrParamObj.IndirPrint;
	// 标志和次数处理
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	PrintFlag(ingr);
	Common_PrintLog('G', ingr, AutoFlag, PrintNum);
	
	// 入库单信息
	var MainObj = GetIngrMainData(ingr); // 主单信息
	var DetailData = GetDetailDataRec(ingr); // 明细信息
	var LocDesc = MainObj.RecLoc.Description;
	var VendorDesc = MainObj.Vendor.Description;
	var IngrNo = MainObj.InGrNo;
	var CreateDate = MainObj.CreateDate;
	var PrintDate = DateFormatter(new Date());
	var AuditUser = MainObj.AuditUser.Description;
	var PurUser = MainObj.PurchaseUser.Description;
	var CreateUser = MainObj.CreateUser.Description;
	// 主单信息展示
	var TaskName = '入库单打印'; // 打印任务名称
	// 标题信息
	var Title = LocDesc + '入库单';
	// 页眉信息
	var Head = '供应商:' + VendorDesc + '          '
			+ '入库单号:' + IngrNo + '          '
			+ '制单日期:' + CreateDate;
	// 页尾信息
	var Foot = '打印日期:' + PrintDate + '          '
			+ '制单:' + CreateUser + '          '
			+ '审核:' + AuditUser + '          '
			+ '采购:' + PurUser + '          '
			+ '会计:';
	// 明细信息展示
	var Cols = [
		{ field: 'Num', title: '序号', width: '25px', align: 'center' },
		{ field: 'IncCode', title: '物资代码', width: '10%', align: 'left' },
		{ field: 'IncDesc', title: '物资名称', width: '13%', align: 'left' },
		{ field: 'Spec', title: '规格', width: '7%', align: 'left' },
		{ field: 'Model', title: '型号', width: '7%', align: 'left' },
		{ field: 'BatchNo', title: '批号', width: '7%', align: 'left' },
		{ field: 'ExpDate', title: '有效期', width: '8%', align: 'left' },
		{ field: 'IngrUom', title: '单位', width: '5%', align: 'left' },
		{ field: 'RecQty', title: '数量', width: '5%', align: 'right', format: '#,##0.00' },
		{ field: 'Rp', title: '进价', width: '6%', align: 'right', format: '#,##0.00' },
		{ field: 'RpAmt', title: '进价金额', width: '8%', align: 'right', format: '#,##0.00', sum: 'Y' },
		{ field: 'InvNo', title: '发票号', width: '7%', align: 'left' },
		{ field: 'SpecDesc', title: '具体规格', width: '7%', align: 'left' },
		{ field: 'Manf', title: '生产厂家', width: '10%', align: 'left' }
		//	{field:"Sp",title:"售价",width:"100px",align:"right",format:"#,##0.00"},
		//	{field:"SpAmt",title:"售价金额",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
	];
	
	PrintDocument(PrintNum, IndirPrint, TaskName, Title, Head, Foot, Cols, DetailData);
}
// 高值入库单Lodop打印
function LodopPrintRecHVCol(ingr, AutoFlag) {
	if (isEmpty(ingr)) {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	
	// 获取打印次数，是否预览打印，处理打印标志和次数
	var PrintNum = parseInt(IngrParamObj.PrintNum);
	var IndirPrint = IngrParamObj.IndirPrint;
	// 标志和次数处理
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	PrintFlag(ingr);
	Common_PrintLog('G', ingr, AutoFlag, PrintNum);
	
	// 入库单信息
	var MainObj = GetIngrMainData(ingr); // 主单信息
	var DetailData = GetHVColDetailData(ingr); // 明细信息
	var LocDesc = MainObj.RecLoc.Description;
	var VendorDesc = MainObj.Vendor.Description;
	var IngrNo = MainObj.InGrNo;
	var CreateDate = MainObj.CreateDate;
	var PrintDate = DateFormatter(new Date());
	var AuditUser = MainObj.AuditUser.Description;
	var PurUser = MainObj.PurchaseUser.Description;
	var CreateUser = MainObj.CreateUser.Description;
	// 主单信息展示
	var TaskName = '高值入库单打印'; // 打印任务名称
	// 标题信息
	var Title = LocDesc + '高值入库单';
	// 页眉信息
	var Head = '供应商:' + VendorDesc + '          '
			+ '入库单号:' + IngrNo + '          '
			+ '制单日期:' + CreateDate;
	// 页尾信息
	var Foot = '打印日期:' + PrintDate + '          '
			+ '审核人:' + AuditUser + '          '
			+ '采购人:' + PurUser + '          '
			+ '制单人:' + CreateUser;
	// 明细信息展示
	var Cols = [
		{ field: 'Num', title: '序号', width: '25px', align: 'center' },
		{ field: 'InciCode', title: '物资代码', width: '100px', align: 'left' },
		{ field: 'InciDesc', title: '物资名称', width: '100px', align: 'left' },
		{ field: 'Spec', title: '规格', width: '100px', align: 'left' },
		{ field: 'SpecDesc', title: '具体规格', width: '100px', align: 'left' },
		{ field: 'BatNo', title: '批号', width: '100px', align: 'left' },
		{ field: 'ExpDate', title: '有效期', width: '100px', align: 'left' },
		{ field: 'InvNo', title: '发票号', width: '100px', align: 'left' },
		{ field: 'ManfDesc', title: '生产厂家', width: '100px', align: 'left' },
		{ field: 'IngrUomDesc', title: '单位', width: '100px', align: 'left' },
		{ field: 'RecQty', title: '数量', width: '100px', align: 'right', format: '#,##0.00' },
		{ field: 'Rp', title: '进价', width: '100px', align: 'right', format: '#,##0.00' },
		{ field: 'Sp', title: '售价', width: '100px', align: 'right', format: '#,##0.00' },
		{ field: 'RpAmt', title: '进价金额', width: '100px', align: 'right', format: '#,##0.00', sum: 'Y' },
		{ field: 'SpAmt', title: '售价金额', width: '100px', align: 'right', format: '#,##0.00', sum: 'Y' }
	];
	
	PrintDocument(PrintNum, IndirPrint, TaskName, Title, Head, Foot, Cols, DetailData);
}

// 名称: 入库单打印
function RQPrintRec(IngrStr, AutoFlag) {
	IngrStr = IngrStr.toString();
	var IngrArr = IngrStr.split('^');
	var ArrCount = IngrArr.length;
	if (ArrCount <= 0) {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	var PrintNum = parseInt(IngrParamObj.PrintNum);
	if (isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	var DictPrintStr = '';
	var DictPrintStrLen = '';
	for (var i = 0; i < ArrCount; i++) {
		var ingr = IngrArr[i];
		var IngrObj = GetIngrMainData(ingr);
		var ScgId = IngrObj.StkGrpId;
		var RecLoc = IngrObj.RecLocId.RowId;
		if (isEmpty(RecLoc)) {
			return;
		}
		var PrintMode = GetPrintMode(RecLoc, ScgId);
		var HVFlag = GetCertDocHVFlag(ingr, 'G');
		var RaqName = 'DHCSTM_HUI_StockRec_Common' + RQSuffix;
		if (HVFlag == 'Y') {
			if (PrintMode != '') {
				RaqName = 'DHCSTM_HUI_StockRecHVCol_Common_' + PrintMode + RQSuffix;
			} else {
				RaqName = 'DHCSTM_HUI_StockRecHVCol_Common' + RQSuffix;
			}
		} else {
			if (PrintMode != '') {
				RaqName = 'DHCSTM_HUI_StockRec_Common_' + PrintMode + RQSuffix;
			} else {
				RaqName = 'DHCSTM_HUI_StockRec_Common' + RQSuffix;
			}
		}
		var PrintStr = '{' + RaqName + '(Parref=' + ingr + ')}';
		var RQPrintStr = TranslateRQStr(PrintStr);
		for (var j = 1; j <= PrintNum; j++) {
			if (IngrParamObj.IndirPrint != 'N') {
				DHCSTM_DHCCPM_RQPrint(RQPrintStr);
				Common_PrintLog('G', ingr, AutoFlag);
				PrintFlag(ingr);
			} else {
				if (HISVersion < 8.5) {
					DHCCPM_RQDirectPrint(PrintStr);
					Common_PrintLog('G', ingr, AutoFlag);
					PrintFlag(ingr);
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
	if ((HISVersion >= 8.5) && (IngrParamObj.IndirPrint == 'N')) {
		DHCCPM_RQDirectPrint(DictPrintStr);
		Common_PrintLog('G', IngrStr, AutoFlag, '', PrintNum);
		PrintFlag(IngrStr);
	}
}
function RQPrintRecHVCol(IngrStr, AutoFlag) {
	IngrStr = IngrStr.toString();
	var IngrArr = IngrStr.split('^');
	var ArrCount = IngrArr.length;
	if (ArrCount <= 0) {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	var PrintNum = parseInt(IngrParamObj.PrintNum);
	if (isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	var DictPrintStr = '';
	var DictPrintStrLen = '';
	for (var i = 0; i < ArrCount; i++) {
		var ingr = IngrArr[i];
		var IngrObj = GetIngrMainData(ingr);
		var ScgId = IngrObj.StkGrpId;
		var RecLoc = IngrObj.RecLocId.RowId;
		var PrintModeData = GetPrintMode(RecLoc, ScgId);
		var RaqName = 'DHCSTM_HUI_StockRecHVCol_Common' + RQSuffix;
		if (PrintModeData != '') {
			RaqName = 'DHCSTM_HUI_StockRecHVCol_Common_' + PrintModeData + RQSuffix;
		}
		var PrintStr = '{' + RaqName + '(Parref=' + ingr + ')}';
		var RQPrintStr = TranslateRQStr(PrintStr);
		for (var j = 1; j <= PrintNum; j++) {
			if (IngrParamObj.IndirPrint != 'N') {
				DHCSTM_DHCCPM_RQPrint(RQPrintStr);
				Common_PrintLog('G', ingr, AutoFlag);
				PrintFlag(ingr);
			} else {
				if (HISVersion < 8.5) {
					DHCCPM_RQDirectPrint(PrintStr);
					CCommon_PrintLog('G', ingr, AutoFlag);
					PrintFlag(ingr);
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
	if ((HISVersion >= 8.5) && (IngrParamObj.IndirPrint == 'N')) {
		DHCCPM_RQDirectPrint(DictPrintStr);
		Common_PrintLog('G', IngrStr, AutoFlag, '', PrintNum);
		PrintFlag(IngrStr);
	}
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

	var myList = '';
	var detailArr = GetDetailDataRec(ingr);
	for (i = 0; i < detailArr.length; i++) {
		var detailObj = detailArr[i];
		var inciCode = detailObj.IncCode;
		var inciDesc = detailObj.IncDesc;
		var spec = '';
		var ingrUom = detailObj.IngrUom;
		var batNo = detailObj.BatchNo;
		var manf = detailObj.Manf;
		var qty = detailObj.RecQty;
		var rp = detailObj.Rp;
		var rpAmt = detailObj.RpAmt;
		var sp = detailObj.Sp;
		var spAmt = detailObj.SpAmt;
		var marAmt = spAmt - rpAmt;
		var firstdesc = inciCode + ' ' + inciDesc + ' ' + spec + ' ' + ingrUom + ' ' + batNo + ' ' + manf + ' ' + qty + ' ' + rp + ' ' + rpAmt + ' ' + sp + ' ' + spAmt + ' ' + marAmt;
		if (myList == '') {
			myList = firstdesc;
		} else {
			myList = myList + String.fromCharCode(2) + firstdesc;
		}
	}
	DHCP_GetXMLConfig('DHCSTGdRecPrt');
	DHCP_PrintFun(MyPara, myList);
}
// 名称: 入库验收单打印
function PrintRecCheck(IngrStr, Others) {
	IngrStr = IngrStr.toString();
	var IngrArr = IngrStr.split(',');
	var IngrCount = IngrArr.length;
	if (IngrCount <= 0) {
		return;
	}
	var DictPrintStr = '';
	var DictPrintStrLen = '';
	for (var i = 0; i < IngrCount; i++) {
		var ingr = IngrArr[i];
		var RaqName = 'DHCSTM_HUI_StockRecCheck_Common' + RQSuffix;
		var fileName = '{' + RaqName + '(Parref=' + ingr + ';Others=' + Others + ')}';
		var transfileName = TranslateRQStr(fileName);
		if (IngrParamObj.IndirPrint != 'N') {
			DHCCPM_RQPrint(transfileName);
		} else {
			if (HISVersion < 8.5) {
				DHCCPM_RQDirectPrint(fileName);
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
	if ((HISVersion >= 8.5) && (IngrParamObj.IndirPrint == 'N')) {
		DHCCPM_RQDirectPrint(DictPrintStr);
	}
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
		query2JsonStrict: 1,
		Parref: ingr,
		rows: 99999
	}, false);
	var DetailData = jsonData.rows;
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
		query2JsonStrict: 1,
		Parref: ingr,
		rows: 99999
	}, false);
	var DetailData = jsonData.rows;
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
	}, false);
	return IngrObj;
}
function PrintFlag(IngrStr) {
	if (isEmpty(IngrStr)) {
		return;
	}
	$.cm({
		ClassName: 'web.DHCSTMHUI.DHCINGdRec',
		MethodName: 'PrintFlag',
		IngrIdStr: IngrStr
	}, function(jsonData) {
		if (jsonData.success != 0) { $UI.msg('alert', jsonData.msg); }
	});
}