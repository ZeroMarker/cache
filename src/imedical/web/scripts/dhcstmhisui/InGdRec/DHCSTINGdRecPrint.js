
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

// ��ⵥLodop��ӡ
function LodopPrintRec(ingr, AutoFlag) {
	if (isEmpty(ingr)) {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	
	// ��ȡ��ӡ�������Ƿ�Ԥ����ӡ�������ӡ��־�ʹ���
	var PrintNum = parseInt(IngrParamObj.PrintNum);
	var IndirPrint = IngrParamObj.IndirPrint;
	// ��־�ʹ�������
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	PrintFlag(ingr);
	Common_PrintLog('G', ingr, AutoFlag, PrintNum);
	
	// ��ⵥ��Ϣ
	var MainObj = GetIngrMainData(ingr); // ������Ϣ
	var DetailData = GetDetailDataRec(ingr); // ��ϸ��Ϣ
	var LocDesc = MainObj.RecLoc.Description;
	var VendorDesc = MainObj.Vendor.Description;
	var IngrNo = MainObj.InGrNo;
	var CreateDate = MainObj.CreateDate;
	var PrintDate = DateFormatter(new Date());
	var AuditUser = MainObj.AuditUser.Description;
	var PurUser = MainObj.PurchaseUser.Description;
	var CreateUser = MainObj.CreateUser.Description;
	// ������Ϣչʾ
	var TaskName = '��ⵥ��ӡ'; // ��ӡ��������
	// ������Ϣ
	var Title = LocDesc + '��ⵥ';
	// ҳü��Ϣ
	var Head = '��Ӧ��:' + VendorDesc + '          '
			+ '��ⵥ��:' + IngrNo + '          '
			+ '�Ƶ�����:' + CreateDate;
	// ҳβ��Ϣ
	var Foot = '��ӡ����:' + PrintDate + '          '
			+ '�Ƶ�:' + CreateUser + '          '
			+ '���:' + AuditUser + '          '
			+ '�ɹ�:' + PurUser + '          '
			+ '���:';
	// ��ϸ��Ϣչʾ
	var Cols = [
		{ field: 'Num', title: '���', width: '25px', align: 'center' },
		{ field: 'IncCode', title: '���ʴ���', width: '10%', align: 'left' },
		{ field: 'IncDesc', title: '��������', width: '13%', align: 'left' },
		{ field: 'Spec', title: '���', width: '7%', align: 'left' },
		{ field: 'Model', title: '�ͺ�', width: '7%', align: 'left' },
		{ field: 'BatchNo', title: '����', width: '7%', align: 'left' },
		{ field: 'ExpDate', title: '��Ч��', width: '8%', align: 'left' },
		{ field: 'IngrUom', title: '��λ', width: '5%', align: 'left' },
		{ field: 'RecQty', title: '����', width: '5%', align: 'right', format: '#,##0.00' },
		{ field: 'Rp', title: '����', width: '6%', align: 'right', format: '#,##0.00' },
		{ field: 'RpAmt', title: '���۽��', width: '8%', align: 'right', format: '#,##0.00', sum: 'Y' },
		{ field: 'InvNo', title: '��Ʊ��', width: '7%', align: 'left' },
		{ field: 'SpecDesc', title: '������', width: '7%', align: 'left' },
		{ field: 'Manf', title: '��������', width: '10%', align: 'left' }
		//	{field:"Sp",title:"�ۼ�",width:"100px",align:"right",format:"#,##0.00"},
		//	{field:"SpAmt",title:"�ۼ۽��",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
	];
	
	PrintDocument(PrintNum, IndirPrint, TaskName, Title, Head, Foot, Cols, DetailData);
}
// ��ֵ��ⵥLodop��ӡ
function LodopPrintRecHVCol(ingr, AutoFlag) {
	if (isEmpty(ingr)) {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	
	// ��ȡ��ӡ�������Ƿ�Ԥ����ӡ�������ӡ��־�ʹ���
	var PrintNum = parseInt(IngrParamObj.PrintNum);
	var IndirPrint = IngrParamObj.IndirPrint;
	// ��־�ʹ�������
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	PrintFlag(ingr);
	Common_PrintLog('G', ingr, AutoFlag, PrintNum);
	
	// ��ⵥ��Ϣ
	var MainObj = GetIngrMainData(ingr); // ������Ϣ
	var DetailData = GetHVColDetailData(ingr); // ��ϸ��Ϣ
	var LocDesc = MainObj.RecLoc.Description;
	var VendorDesc = MainObj.Vendor.Description;
	var IngrNo = MainObj.InGrNo;
	var CreateDate = MainObj.CreateDate;
	var PrintDate = DateFormatter(new Date());
	var AuditUser = MainObj.AuditUser.Description;
	var PurUser = MainObj.PurchaseUser.Description;
	var CreateUser = MainObj.CreateUser.Description;
	// ������Ϣչʾ
	var TaskName = '��ֵ��ⵥ��ӡ'; // ��ӡ��������
	// ������Ϣ
	var Title = LocDesc + '��ֵ��ⵥ';
	// ҳü��Ϣ
	var Head = '��Ӧ��:' + VendorDesc + '          '
			+ '��ⵥ��:' + IngrNo + '          '
			+ '�Ƶ�����:' + CreateDate;
	// ҳβ��Ϣ
	var Foot = '��ӡ����:' + PrintDate + '          '
			+ '�����:' + AuditUser + '          '
			+ '�ɹ���:' + PurUser + '          '
			+ '�Ƶ���:' + CreateUser;
	// ��ϸ��Ϣչʾ
	var Cols = [
		{ field: 'Num', title: '���', width: '25px', align: 'center' },
		{ field: 'InciCode', title: '���ʴ���', width: '100px', align: 'left' },
		{ field: 'InciDesc', title: '��������', width: '100px', align: 'left' },
		{ field: 'Spec', title: '���', width: '100px', align: 'left' },
		{ field: 'SpecDesc', title: '������', width: '100px', align: 'left' },
		{ field: 'BatNo', title: '����', width: '100px', align: 'left' },
		{ field: 'ExpDate', title: '��Ч��', width: '100px', align: 'left' },
		{ field: 'InvNo', title: '��Ʊ��', width: '100px', align: 'left' },
		{ field: 'ManfDesc', title: '��������', width: '100px', align: 'left' },
		{ field: 'IngrUomDesc', title: '��λ', width: '100px', align: 'left' },
		{ field: 'RecQty', title: '����', width: '100px', align: 'right', format: '#,##0.00' },
		{ field: 'Rp', title: '����', width: '100px', align: 'right', format: '#,##0.00' },
		{ field: 'Sp', title: '�ۼ�', width: '100px', align: 'right', format: '#,##0.00' },
		{ field: 'RpAmt', title: '���۽��', width: '100px', align: 'right', format: '#,##0.00', sum: 'Y' },
		{ field: 'SpAmt', title: '�ۼ۽��', width: '100px', align: 'right', format: '#,##0.00', sum: 'Y' }
	];
	
	PrintDocument(PrintNum, IndirPrint, TaskName, Title, Head, Foot, Cols, DetailData);
}

// ����: ��ⵥ��ӡ
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
						$UI.msg('alert', '��ӡ��������,����ֻ�ܴ�ӡ' + i + '�ݵ���,������ѡ�񵥾�!');
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
						$UI.msg('alert', '��ӡ��������,����ֻ�ܴ�ӡ' + i + '�ݵ���,������ѡ�񵥾�!');
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
// ����: ������յ���ӡ
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
					$UI.msg('alert', '��ӡ��������,����ֻ�ܴ�ӡ' + i + '�ݵ���,������ѡ�񵥾�!');
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
 * description:ȡ�����ϸ��Ϣ
 * params: ingr:�������id
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
 * description:ȡ�����ϸ��Ϣ
 * params: ingr:�������id
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
 * description:ȡ���������Ϣ
 * params: ingr:�������id
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