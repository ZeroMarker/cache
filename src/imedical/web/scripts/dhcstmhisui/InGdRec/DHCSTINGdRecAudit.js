/* ��ⵥ���*/
var init = function() {
	var Clear = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(InGdRecMainGrid);
		$UI.clear(InGdRecDetailGrid);
		// ���ó�ʼֵ ����ʹ������
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			FRecLoc: gLocObj,
			AuditFlag: 'N',
			FStatusBox: 'Y'
		};
		$UI.fillBlock('#FindConditions', DefaultData);
		if (ItmTrackParamObj.AutoVirFlag == 'Y') {
			$('#VirtualFlag').checkbox('setValue', true);
		} else {
			$('#VirtualFlag').checkbox('setValue', false);
		}
		// $('#ScgId').combotree('options')['setDefaultFun']();
	};
	var FRecLocParams = JSON.stringify(addSessionParams({
		Type: 'Login',
		Element: 'FRecLoc'
	}));
	var FRecLocBox = $HUI.combobox('#FRecLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRecLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#ScgId').setFilterByLoc(LocId);
			if (CommParObj.ApcScg == 'L') {
				FVendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				FVendorBox.reload(url);
			}
			$('#CreateUserId').combobox('clear');
			$('#CreateUserId').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=Array&Params='
				+ JSON.stringify({LocDr:LocId})
			);
		}
	});
	var VirtualFlag = $HUI.checkbox('#VirtualFlag', {
		onCheckChange: function(e, value) {
			if (value) {
				var LocId = $('#FRecLoc').combobox('getValue');
				var Info = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon', 'GetMainLoc', LocId);
				var InfoArr = Info.split('^');
				var VituralLoc = InfoArr[0], VituralLocDesc = InfoArr[1];
				AddComboData($('#FRecLoc'), VituralLoc, VituralLocDesc);
				$('#FRecLoc').combobox('setValue', VituralLoc);
			} else {
				$('#FRecLoc').combobox('setValue', gLocId);
			}
		}
	});
	
	var RequestLocParams = JSON.stringify(addSessionParams({
		Type: 'All',
		Element: 'RequestLoc'
	}));
	var RequestLocBox = $HUI.combobox('#RequestLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + RequestLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var CreateUserIdParams = JSON.stringify(addSessionParams({
		LocDr: ''
	}));
	var CreateUserIdBox = $HUI.combobox('#CreateUserId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=array&Params=' + CreateUserIdParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var FVendorBoxParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var FVendorBox = $HUI.combobox('#FVendorBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVendorBoxParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams = function() {
		var ScgId = $('#ScgId').combotree('getValue');
		var Locdr = $('#FRecLoc').combobox('getValue');
		var Obj = { StkGrpRowId: ScgId, StkGrpType: 'M', Locdr: Locdr, BDPHospital: gHospId };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	$('#FInGrNo').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			QueryIngrInfo();
		}
	});
	$('#HVFlag').simplecombobox({
		data: [
			{ 'RowId': '', 'Description': 'ȫ��' },
			{ 'RowId': 'Y', 'Description': '��ֵ' },
			{ 'RowId': 'N', 'Description': '�Ǹ�ֵ' }
		]
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			QueryIngrInfo();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#SaveInvBT', {
		onClick: function() {
			SaveInvInfo();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var RowsData = InGdRecMainGrid.getSelections();
			if (isEmpty(RowsData)) {
				$UI.msg('alert', '��ѡ����Ҫ��ӡ�ĵ���!');
				return;
			}
			var IngrStr = '';
			for (var i = 0; i < RowsData.length; i++) {
				var IngrId = RowsData[i].IngrId;
				if (IngrStr == '') {
					IngrStr = IngrId;
				} else {
					IngrStr = IngrStr + '^' + IngrId;
				}
			}
			if (IngrStr == '') {
				$UI.msg('alert', '��ѡ����Ҫ��ӡ����Ϣ!');
				return false;
			}
			PrintRec(IngrStr);
		}
	});

	$UI.linkbutton('#PrintHVColBT', {
		onClick: function() {
			var RowsData = InGdRecMainGrid.getSelections();
			if (isEmpty(RowsData)) {
				$UI.msg('alert', '��ѡ����Ҫ��ӡ�ĵ���!');
				return;
			}
			var IngrStr = '';
			for (var i = 0; i < RowsData.length; i++) {
				var IngrId = RowsData[i].IngrId;
				if (IngrStr == '') {
					IngrStr = IngrId;
				} else {
					IngrStr = IngrStr + '^' + IngrId;
				}
			}
			if (IngrStr == '') {
				$UI.msg('alert', '��ѡ����Ҫ��ӡ����Ϣ!');
				return false;
			}
			PrintRecHVCol(IngrStr);
		}
	});
	
	var SunPurPlan = CommParObj.SunPurPlan; // �������� ����
	// /20221112 ����ɹ�
	$UI.linkbutton('#SendIngdrecBT', {
		onClick: function() {
			if (isEmpty(SunPurPlan)) {
				$UI.msg('alert', '�����òɹ�ƽ̨��Ϣ!');
				return;
			}
			if (SunPurPlan == '�Ĵ�ʡ') {
				SCSendIngdrec();
			}
		}
	});
	function SCSendIngdrec() {
		var RowData = InGdRecMainGrid.getSelections();
		var IngrIdStr = '';
		for (var i = 0; i < RowData.length; i++) {
			var RowIndex = InGdRecMainGrid.getRowIndex(RowData[i]);
			var AuditFlag = RowData[i].AuditFlag;
			var IngrNo = RowData[i].IngrNo;
			if (AuditFlag != 'Y') {
				$UI.msg('alert', '��ⵥ:' + IngrNo + 'δ���!');
				InGdRecMainGrid.unselectRow(RowIndex);
			}
			var IngrId = RowData[i].IngrId;
			if (IngrIdStr == '') {
				IngrIdStr = IngrId;
			} else {
				IngrIdStr = IngrIdStr + '^' + IngrId;
			}
		}
		if (isEmpty(IngrIdStr)) {
			$UI.msg('alert', '��ѡ��Ҫͬ������ⵥ!');
			return false;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'JsSendIngrStr',
			IngrStr: IngrIdStr
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				var retinfo = jsonData.msg;
				var retarr = retinfo.split('@');
				var all = Number(retarr[0]) + Number(retarr[1]);
				var sucret = retarr[2];
				var failret = retarr[3];
				$UI.msg('alert', '��' + all + '����ⵥ���ɹ���' + retarr[0] + '����ʧ�ܣ�' + retarr[1] + '��' + failret);
			}
		});
	}
	// / 20221112 ����ɹ� ������ⵥ���ɶ���
	$UI.linkbutton('#CreatePoByRecBT', {
		onClick: function() {
			 	if (isEmpty(SunPurPlan)) {
				$UI.msg('alert', '�����òɹ�ƽ̨��Ϣ!');
				return;
			}
			if (SunPurPlan == '�Ĵ�ʡ') {
				SCjsCreatePoByRec();
			}
		}
	});
	function SCjsCreatePoByRec() {
		var RowData = InGdRecMainGrid.getSelections();
		var IngrIdStr = '';
		for (var i = 0; i < RowData.length; i++) {
			var AuditFlag = RowData[i].AuditFlag;
			if (AuditFlag != 'Y') {
				continue;
			}
			var IngrId = RowData[i].IngrId;
			if (IngrIdStr == '') {
				IngrIdStr = IngrId;
			} else {
				IngrIdStr = IngrIdStr + '^' + IngrId;
			}
		}
		if (IngrIdStr == '') {
			$UI.msg('alert', 'û����Ҫ����ĵ���!');
			return false;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPurPlan',
			MethodName: 'jsCreatePoByRec',
			UserId: gUserId,
			IngrIdStr: IngrIdStr
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				QueryIngrInfo();
				var info = jsonData.msg;
				var infoArr = info.split('@');
				var Allcnt = infoArr[0];
				var Succnt = infoArr[1];
				var failcnt = Number(Allcnt) - Number(Succnt);
				var ErrInfo = infoArr[2];
				$UI.msg('success', '��:' + Allcnt + '��¼,�ɹ�:' + Succnt + '��');
				if (failcnt > 0) {
					$UI.msg('error', 'ʧ��:' + failcnt + '��;' + ErrInfo);
				}
			}
		});
	}
		
	// ���� end
	var InGdRecMainCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'IngrId',
			width: 100,
			hidden: true
		}, {
			title: '��ⵥ��',
			field: 'IngrNo',
			width: 120
		}, {
			title: '������',
			field: 'RecLoc',
			width: 150
		}, {
			title: '���տ���',
			field: 'ReqLocDesc',
			width: 150
		}, {
			title: '��Ӧ��',
			field: 'Vendor',
			width: 200
		}, {
			title: '�ʽ���Դ',
			field: 'SourceOfFund',
			width: 80
		}, {
			title: '������',
			field: 'CreateUser',
			width: 70
		}, {
			title: '��������',
			field: 'CreateDate',
			width: 90
		}, {
			title: '����ʱ��',
			field: 'CreateTime',
			width: 90
		}, {
			title: '�����',
			field: 'AuditUser',
			width: 70
		}, {
			title: '�������',
			field: 'AuditDate',
			width: 90
		}, {
			title: '������',
			field: 'PoNo',
			width: 120
		}, {
			title: '�������',
			field: 'IngrType',
			width: 80
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�������',
			field: 'Margin',
			width: 100,
			align: 'right'
		}, {
			title: '��ע',
			field: 'InGrRemarks',
			width: 100
		}, {
			title: '���ͱ�־',
			field: 'GiftFlag',
			width: 80,
			formatter: BoolFormatter,
			align: 'center'
		}, {
			title: '���ۻ�Ʊ��־',
			field: 'AdjCheque',
			width: 100,
			formatter: BoolFormatter,
			align: 'center'
		}, {
			title: 'ReqLoc',
			field: 'ReqLoc',
			width: 10,
			hidden: true
		}, {
			title: 'Complete',
			field: 'Complete',
			width: 10,
			hidden: true
		}, {
			title: 'StkGrp',
			field: 'StkGrp',
			width: 10,
			hidden: true
		}, {
			title: 'AuditFlag',
			field: 'AuditFlag',
			width: 10,
			hidden: true
		}, {
			title: '���״̬',
			field: 'Audit',
			width: 80
		}, {
			title: '��ӡ����',
			field: 'PrintCount',
			width: 80,
			align: 'right'
		}, {
			title: 'RecLocId',
			field: 'RecLocId',
			width: 10,
			hidden: true
		}
	]];
	var InGdRecMainGrid = $UI.datagrid('#InGdRecMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query',
			query2JsonStrict: 1,
			totalFooter: '"IngrNo":"�ϼ�"',
			totalFields: 'RpAmt,SpAmt'
		},
		columns: InGdRecMainCm,
		showBar: true,
		showFooter: true,
		singleSelect: false,
		onSelect: function(index, row) {
			InGdRecDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryDetail',
				query2JsonStrict: 1,
				Parref: row.IngrId,
				rows: 99999,
				totalFooter: '"IncCode":"�ϼ�"',
				totalFields: 'RpAmt,SpAmt'
			});
		},
		onLoadSuccess: function(data) {
			if ((data.rows.length > 0) && (CommParObj.IfSelFirstRow == 'Y')) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});

	var InGdRecDetailCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'IncCode',
			width: 80
		}, {
			title: '��������',
			field: 'IncDesc',
			width: 160
		}, {
			title: '���',
			field: 'Spec',
			width: 80
		}, {
			title: '��ֵ����',
			field: 'HVBarCode',
			width: 140
		}, {
			title: '�Դ�����',
			field: 'OrigiBarCode',
			width: 80
		}, {
			title: '��������',
			field: 'Manf',
			width: 180
		}, {
			title: '����id',
			field: 'Inclb',
			width: 70,
			hidden: true
		}, {
			title: '����',
			field: 'BatchNo',
			width: 90
		}, {
			title: '��Ч��',
			field: 'ExpDate',
			width: 100
		}, {
			title: '��λ',
			field: 'IngrUom',
			width: 80
		}, {
			title: '����',
			field: 'RecQty',
			width: 80,
			align: 'right'
		}, {
			title: '����',
			field: 'Rp',
			width: 60,
			align: 'right'
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 60,
			align: 'right'
		}, {
			title: '��Ʊ����',
			field: 'InvCode',
			width: 80,
			editor: {
				type: 'text'
			}
		}, {
			title: '��Ʊ��',
			field: 'InvNo',
			width: 80,
			editor: {
				type: 'text'
			}
		}, {
			title: '��Ʊ����',
			field: 'InvDate',
			width: 100,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '��Ʊ���',
			field: 'InvMoney',
			width: 100,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtRA')
				}
			}
		}, {
			title: '����ҽ������',
			field: 'MatInsuCode',
			width: 160
		}, {
			title: '����ҽ������',
			field: 'MatInsuDesc',
			width: 160
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�������',
			field: 'Margin',
			width: 100,
			align: 'right'
		}, {
			title: '���е���',
			field: 'SxNo',
			width: 140
		}, {
			title: '���۵�״̬',
			field: 'AdjSpStatus',
			width: 80
		}, {
			title: '������Ϣ',
			field: 'PatInfo',
			width: 160
		}
	]];

	var InGdRecDetailGrid = $UI.datagrid('#InGdRecDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1,
			rows: 99999,
			totalFooter: '"IncCode":"�ϼ�"',
			totalFields: 'RpAmt,SpAmt'
		},
		pagination: false,
		columns: InGdRecDetailCm,
		showBar: true,
		showFooter: true,
		toolbar: [
			{
				text: '��ӡ����',
				iconCls: 'icon-print',
				handler: function() {
					IngrPrintBarcode();
				}
			}
		],
		onClickRow: function(index, row) {
			InGdRecDetailGrid.commonClickRow(index, row);
		}
	});

	function IngrPrintBarcode() {
		var Rows = InGdRecDetailGrid.getSelections();
		$.each(Rows, function(index, item) {
			var BarCode = item.HVBarCode;
			if (isEmpty(BarCode)) {
				return;
			}
			PrintBarcode(BarCode);
		});
	}

	function QueryIngrInfo() {
		$UI.clear(InGdRecMainGrid);
		$UI.clear(InGdRecDetailGrid);
		var ParamsObj = $UI.loopBlock('#FindConditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(ParamsObj.FRecLoc)) {
			$UI.msg('alert', '�����Ҳ���Ϊ��!');
			return false;
		}
		if (isEmpty(StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		if (compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���С�ڿ�ʼ����!');
			return;
		}
		ParamsObj.QueryType = 'audit';
		var Params = JSON.stringify(ParamsObj);
		InGdRecMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query',
			query2JsonStrict: 1,
			Params: Params,
			totalFooter: '"IngrNo":"�ϼ�"',
			totalFields: 'RpAmt,SpAmt'
		});
	}
	function CheckDataBeforeAudit() {
		var RowsData = InGdRecMainGrid.getSelections();
		for (var i = 0; i < RowsData.length; i++) {
			var AuditFlag = RowsData[i].AuditFlag;
			var IngrNo = RowsData[i].IngrNo;
			if (AuditFlag == 'Y') {
				$UI.msg('alert', IngrNo + '��ⵥ�����!');
				return false;
			}
			var IngrId = RowsData[i].IngrId;
			var Oerecflag = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetOeriRecFlag', IngrId);
			if ((Oerecflag != 'Y') && (UseItmTrack) && (CheckHighValueLabels('G', IngrId) == false)) {
				$UI.msg('alert', IngrNo + '��ֵ�������쳣!');
				return false;
			}
			var InStkTkParamObj = GetAppPropValue('DHCSTINSTKTKM');
			if (InStkTkParamObj.AllowBusiness != 'Y') {
				var phaLoc = RowsData[i].RecLocId;
				var IfExistInStkTk = tkMakeServerCall('web.DHCSTMHUI.INStkTk', 'CheckInStkTkByLoc', phaLoc);
				if (IfExistInStkTk == 'Y') {
					$UI.msg('alert', '����δ��ɵ��̵㵥���������!');
					return false;
				}
			}
		}
		return true;
	}
	$UI.linkbutton('#AuditBT', {
		onClick: function() {
			if (CheckDataBeforeAudit()) {
				var RowData = InGdRecMainGrid.getSelections();
				if ((isEmpty(RowData)) || (RowData.length == 0)) {
					$UI.msg('alert', '��ѡ����Ҫ��˵ĵ���!');
					return false;
				}
				if (IngrParamObj.ConfirmBeforeAudit == 'Y') {
					$UI.confirm('����Ҫ�����ѡ����,�Ƿ����?', '', '', IngrAudit);
				} else {
					IngrAudit();
				}
			}
		}
	});
	function IngrAudit() {
		var RowData = InGdRecMainGrid.getSelections();
		var IngrIdStr = '';
		for (var i = 0; i < RowData.length; i++) {
			var IngrId = RowData[i].IngrId;
			if (IngrIdStr == '') {
				IngrIdStr = IngrId;
			} else {
				IngrIdStr = IngrIdStr + '^' + IngrId;
			}
		}
		if (IngrIdStr == '') {
			$UI.msg('alert', 'û����Ҫ��˵ĵ���!');
			return false;
		}
		var Params = JSON.stringify(sessionObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'jsAudit',
			Params: Params,
			IngrIdStr: IngrIdStr
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				QueryIngrInfo();
				var info = jsonData.msg;
				var infoArr = info.split('@');
				var Allcnt = infoArr[0];
				var Succnt = infoArr[1];
				var failcnt = Allcnt - Succnt;
				var ErrInfo = infoArr[2];
				$UI.msg('success', '��:' + Allcnt + '��¼,�ɹ�:' + Succnt + '��');
				if (failcnt > 0) {
					$UI.msg('error', 'ʧ��:' + failcnt + '��;' + ErrInfo);
				}
				var IngrIdStr = jsonData.rowid;
				if ((Succnt > 0) && (IngrParamObj.AutoPrintAfterAudit == 'Y')) {
					PrintRec(IngrIdStr);
				}
			}
		});
	}
	function SaveInvInfo() {
		var rowsData = InGdRecDetailGrid.getRowsData();
		if (rowsData.length <= 0) {
			$UI.msg('alert', '����Ҫ�������ϸ��Ϣ!');
			return false;
		}
		for (var i = 0; i < rowsData.length; i++) {
			var row = rowsData[i];
			var RowId = row.RowId;
			var InvCode = row.InvCode;
			var InvNo = row.InvNo;
			var InvDate = row.InvDate;
			var InvMoney = row.InvMoney;
			var SxNo = row.SxNo;
			var Params = JSON.stringify(addSessionParams({
				TrType: 'G',
				RowId: RowId,
				InvCode: InvCode,
				InvNo: InvNo,
				InvDate: InvDate,
				InvMoney: InvMoney,
				SxNo: SxNo
			}));
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINGdRec',
				MethodName: 'jsUpdateINV',
				Params: Params
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					QueryIngrInfo();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	}
	Clear();
	QueryIngrInfo();
};
$(init);