
var CodeMainParamObj = GetAppPropValue('DHCSTDRUGMAINTAINM');
var init = function() {
	var CURRENT_INGR = '', CURRENT_INIT = '';
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});

	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			Save();
		}
	});

	function Save() {
		var RowsData = MatOrdItmGrid.getSelectedData();
		if (RowsData.length <= 0) {
			$UI.msg('alert', '��ѡ�������ϸ!');
			return false;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.HVMatOrdItm',
			MethodName: 'SaveInvInfo',
			ListData: JSON.stringify(RowsData)
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			$UI.clear(MatOrdItmGrid);
			$UI.clear(IngrMainGrid);
			$UI.clear(IngrDetailGrid);
			$UI.clear(InitMainGrid);
			$UI.clear(InitDetailGrid);
			CURRENT_INGR = '';
			CURRENT_INIT = '';
			Query();
		}
	});
	function Query() {
		$('#MatAmt').text(0);
		var ParamsObj = $UI.loopBlock('#MainConditions');
		var StartDate = ParamsObj.FromDate;
		var EndDate = ParamsObj.ToDate;
		if (isEmpty(ParamsObj.Loc)) {
			$UI.msg('alert', '�ⷿ����Ϊ��!');
			return;
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
		ParamsObj.AuditFlag = 'Y';
		var Params = JSON.stringify(ParamsObj);
		var DTTabed = $('#tt2').tabs('getSelected');
		var DTTabed = $('#tt2').tabs('getTabIndex', DTTabed);
		if (DTTabed == 0) {
			MatOrdItmGrid.load({
				ClassName: 'web.DHCSTMHUI.HVMatOrdItm',
				QueryName: 'HVMatOrdItems',
				query2JsonStrict: 1,
				Params: Params,
				rows: 9999,
				totalFooter: '"�ϼ�":"InciCode"',
				totalFields: 'Rp,InvAmt,FeeAmt'
			});
		} else if (DTTabed == 3) {
			loadHvMatGridRQ('FlagUsedHvImp');
		} else if (DTTabed == 4) {
			loadHvMatGridRQ('FlagUsedHvImp1');
		} else if (DTTabed == 5) {
			loadHvMatGridRQ('FlagUsedHvPatent');
		} else if (DTTabed == 6) {
			loadHvMatGridRQ('FlagUsedMrNo');
		}
	}
	$UI.linkbutton('#CreateBT', {
		onClick: function() {
			Create();
		}
	});
	function Create() {
		var ParamsObj = $UI.loopBlock('#MainConditions');
		var Params = JSON.stringify(ParamsObj);
		var Detail = MatOrdItmGrid.getSelections();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '��ѡ����Ҫ�����ҽ����¼!');
			return;
		}
		for (var i = 0; i < Detail.length; i++) {
			var RowData = Detail[i];
			var BarCode = RowData['BarCode'];
			var IngriModify = RowData['IngriModify'];
			if (!isEmpty(IngriModify)) {
				$UI.msg('alert', BarCode + '��ϸ�Ѳ�¼!');
				return false;
			}
		}
		var RowsData = MatOrdItmGrid.getSelectedData();
		if (RowsData.length <= 0) {
			$UI.msg('alert', '��ѡ����Ҫ�����ҽ����¼!');
			return false;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.HVMatOrdItm',
			MethodName: 'Create',
			MainInfo: Params,
			ListDetail: JSON.stringify(RowsData)
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				var CurrentInfo = jsonData.rowid;
				var CurrentInfoArr = CurrentInfo.split('^');
				CURRENT_INGR = CurrentInfoArr[0];
				CURRENT_INIT = CurrentInfoArr[1];
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#CancelBT', {
		onClick: function() {
			var params = gGroupId + '^' + gLocId + '^' + gUserId + '^' + gHospId;
			var IfCanDoCancelOeRec = tkMakeServerCall('web.DHCSTMHUI.Common.AppCommon', 'GetAppPropValue', 'HVMatOrdItm', 'IfHavePermCancel', params);
			if (IfCanDoCancelOeRec != 'Y') {
				$UI.msg('alert', '��û��Ȩ�޳�����¼!');
				return false;
			}
			CancelMatOrd();
		}
	});
	function CancelMatOrd() {
		var rowsData = MatOrdItmGrid.getSelections();
		if (rowsData.length <= 0) {
			$UI.msg('alert', '��ѡ����Ҫ�����ҽ����¼!');
			return false;
		}
		var count = rowsData.length;
		var hvs = '';
		for (var rowIndex = 0; rowIndex < count; rowIndex++) {
			var row = rowsData[rowIndex];
			var RowId = row.RowId;
			var IngNo = row.IngNo;
			var BarCode = row.BarCode;
			var IngriModifyNo = row.IngriModifyNo;
			if (isEmpty(IngriModifyNo)) {
				$UI.msg('alert', BarCode + '��ϸδ��¼!');
				return false;
			}
			if (IngNo == '') { continue; }
			if (hvs == '') {
				hvs = RowId;
			} else {
				hvs = hvs + '^' + RowId;
			}
		}
		if (hvs == '') {
			$UI.msg('alert', 'û����Ҫ�����ҽ����¼!');
			return false;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.HVMatOrdItm',
			MethodName: 'jsCancelMatRecStr',
			hvmatids: hvs
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#Print1', {
		onClick: function() {
			var Row = IngrMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ����Ҫ��ӡ�ĵ���!');
				return;
			}
			PrintRec(Row.IngrId);
		}
	});
	$UI.linkbutton('#Print2', {
		onClick: function() {
			var Row = InitMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ����Ҫ��ӡ�ĵ���!');
				return;
			}
			PrintInIsTrf(Row.RowId);
		}
	});
	$UI.linkbutton('#CopyInvBT', {
		onClick: function() {
			var rows = MatOrdItmGrid.getRows();
			var len = rows.length;
			if (len == 0) {
				$UI.msg('alert', 'û��ҽ����Ϣ!');
				return false;
			}
			SaveInvWin(SaveInv);
		}
	});
	function SaveInv(Params) {
		if (!MatOrdItmGrid.endEditing()) {
			return false;
		}
		var ParamsObj = $UI.loopBlock('#MainConditions');
		var INGRFlag = ParamsObj.INGRFlag;
		if (INGRFlag == 1) {
			$UI.msg('alert', '����ⵥ�ݲ������޸ķ�Ʊ��Ϣ');
			return false;
		}
		var FillFlag = $("input[name='Fill']:checked").val();	// 1:������, 2:��������
		var InvCode = Params.InvCode;
		var InvNo = Params.InvNo;
		var InvDate = Params.InvDate;
		var Rows = MatOrdItmGrid.getRows();
		var len = Rows.length;
		var FillCount = 0;
		for (var index = 0; index < len; index++) {
			var RowData = Rows[index];
			if ((FillFlag == '1') && !(isEmpty(RowData.InvNo) && isEmpty(RowData.InvDate))) {
				continue;
			}
			$('#MatOrdItmGrid').datagrid('endEdit', index);
			$('#MatOrdItmGrid').datagrid('selectRow', index);
			$('#MatOrdItmGrid').datagrid('editCell', { index: index, field: 'InvCode' });
			var ed = $('#MatOrdItmGrid').datagrid('getEditor', { index: index, field: 'InvCode' });
			ed.target.val(InvCode);
			$('#MatOrdItmGrid').datagrid('editCell', { index: index, field: 'InvNo' });
			var ed = $('#MatOrdItmGrid').datagrid('getEditor', { index: index, field: 'InvNo' });
			ed.target.val(InvNo);
			$('#MatOrdItmGrid').datagrid('editCell', { index: index, field: 'InvDate' });
			var ed = $('#MatOrdItmGrid').datagrid('getEditor', { index: index, field: 'InvDate' });
			$(ed.target).datebox('setValue', InvDate);
			$('#MatOrdItmGrid').datagrid('endEdit', index);
			FillCount++;
		}
		if (FillCount > 0) {
			$UI.msg('alert', '�����' + FillCount + '��, ��ע�Ᵽ��!');
		} else {
			$UI.msg('error', 'δ������Ч���!');
		}
	}
	$UI.linkbutton('#ExportBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			if (isEmpty(ParamsObj.FromDate)) {
				$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
				return;
			}
			if (isEmpty(ParamsObj.ToDate)) {
				$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
				return;
			}
			ParamsObj.AuditFlag = 'Y';
			var Params = JSON.stringify(ParamsObj);
			// Params = encodeUrlStr(Params);
			var Conditions = '��ʼ����: ' + ParamsObj.FromDate + ', ��ֹ����: ' + ParamsObj.ToDate;
			// Conditions = encodeUrlStr(Conditions);
			var RaqName = 'DHCSTM_HUI_HVMatVendorItm.raq';
			var FileName = RaqName + '&Params=' + Params + '&Conditions=' + Conditions;
			DHCCPM_RQPrint(FileName);
		}
	});
	
	$HUI.tabs('#tt2', {
		onSelect: function(title) {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			ParamsObj.AuditFlag = 'Y';
			var Params = JSON.stringify(ParamsObj);
			if (title == 'ҽ����Ϣ') {
				MatOrdItmGrid.load({
					ClassName: 'web.DHCSTMHUI.HVMatOrdItm',
					QueryName: 'HVMatOrdItems',
					query2JsonStrict: 1,
					Params: Params,
					rows: 9999,
					totalFooter: '"�ϼ�":"InciCode"',
					totalFields: 'Rp,InvAmt,FeeAmt'
				});
			} else if (title == '�����Ϣ') {
				if (!isEmpty(CURRENT_INGR)) {
					IngrMainGrid.load({
						ClassName: 'web.DHCSTMHUI.DHCINGdRec',
						QueryName: 'QueryIngrStr',
						query2JsonStrict: 1,
						ingrStr: CURRENT_INGR
					});
				}
			} else if (title == '������Ϣ') {
				if (!isEmpty(CURRENT_INIT)) {
					InitMainGrid.load({
						ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
						QueryName: 'QueryTrans',
						query2JsonStrict: 1,
						InitStr: CURRENT_INIT
					});
				}
			} else if (title == '��Ӧ��ͳ��') {
				loadHvMatGridRQ('FlagUsedHvImp');
			} else if (title == '��Ӧ�̺Ĳ�����ͳ��') {
				loadHvMatGridRQ('FlagUsedHvImp1');
			} else if (title == '���ݲ���ͳ��') {
				loadHvMatGridRQ('FlagUsedHvPatent');
			} else if (title == '����סԺ��ͳ��') {
				loadHvMatGridRQ('FlagUsedMrNo');
			}
		}
	});
	function loadHvMatGridRQ(title) {
		var ParamsObj = $UI.loopBlock('#MainConditions');
		ParamsObj.AuditFlag = 'Y';
		var Params = JSON.stringify(ParamsObj);
		Params = encodeUrlStr(Params);
		if (title == 'FlagUsedHvImp') {
			var p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_HvMatOrdUnImp.raq' + '&Params=' + Params + '&StartDate=' + ParamsObj.FromDate + '&EndDate=' + ParamsObj.ToDate;
			$('#FlagUsedHvImp').attr('src', CommonFillUrl(p_URL));
		} else if (title == 'FlagUsedHvImp1') {
			var p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_HvMatOrdImp.raq' + '&Params=' + Params + '&StartDate=' + ParamsObj.FromDate + '&EndDate=' + ParamsObj.ToDate;
			$('#FlagUsedHvImp1').attr('src', CommonFillUrl(p_URL));
		} else if (title == 'FlagUsedHvPatent') {
			var p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_HvMatOrdImpDetail.raq' + '&Params=' + Params + '&StartDate=' + ParamsObj.FromDate + '&EndDate=' + ParamsObj.ToDate;
			$('#FlagUsedHvPatent').attr('src', CommonFillUrl(p_URL));
		} else {
			var p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_HvMatOrdTransOut.raq' + '&Params=' + Params + '&StartDate=' + ParamsObj.FromDate + '&EndDate=' + ParamsObj.ToDate;
			$('#FlagUsedMrNo').attr('src', CommonFillUrl(p_URL));
		}
	}
	var FVendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var FVendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	var SourceOfFundParams = JSON.stringify(addSessionParams());
	var SourceOfFundBox = $HUI.combobox('#Source', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSourceOfFund&ResultSetType=array&Params=' + SourceOfFundParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams = function() {
		var Scg = $('#ScgStk').combotree('getValue');
		var Obj = { StkGrpRowId: Scg, StkGrpType: 'M' };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	var Clear = function() {
		$UI.clearBlock('#MainConditions');
		var IngrParamObj = GetAppPropValue('DHCSTIMPORTM');
		function DefaultStDate() {
			var Today = new Date();
			var DefaStartDate = IngrParamObj.DefaStartDate;
			if (isEmpty(DefaStartDate)) {
				return DateFormatter(Today);
			}
			var EdDate = DateAdd(Today, 'd', parseInt(DefaStartDate));
			return DateFormatter(EdDate);
		}

		function DefaultEdDate() {
			var Today = new Date();
			var DefaEndDate = IngrParamObj.DefaEndDate;
			if (isEmpty(DefaEndDate)) {
				return DateFormatter(Today);
			}
			var EdDate = DateAdd(Today, 'd', parseInt(DefaEndDate));
			return DateFormatter(EdDate);
		}
		var DefaultData = {
			FromDate: DefaultStDate(),
			ToDate: DefaultEdDate(),
			Loc: gLocObj
		};
		$UI.fillBlock('#MainConditions', DefaultData);
		$UI.clear(MatOrdItmGrid);
		$UI.clear(IngrMainGrid);
		$UI.clear(IngrDetailGrid);
		$UI.clear(InitMainGrid);
		$UI.clear(InitDetailGrid);
		CURRENT_INGR = '';
		CURRENT_INIT = '';
	};
	var FLocParams = JSON.stringify(addSessionParams({ Type: 'Login', Element: 'Loc' }));
	var FLocBox = $HUI.combobox('#Loc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var Loc = record['RowId'];
			$HUI.combotree('#ScgStk').setFilterByLoc(Loc);
			if (CommParObj.ApcScg == 'L') {
				FVendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: Loc }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				FVendorBox.reload(url);
			}
		}
	});
	$('#ScgStk').combotree({
		onChange: function(newValue, oldValue) {
			if (CommParObj.ApcScg == 'S') {
				FVendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M' }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params + '&ScgId=' + newValue ;
				FVendorBox.reload(url);
			}
		}
	});
	var FOrdLocParams = JSON.stringify(addSessionParams({ Type: 'All', Element: 'OrdLoc' }));
	var FOrdLocBox = $HUI.combobox('#OrdLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FOrdLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
			valueField: 'RowId',
			textField: 'Description',
			// mode:'remote',
			onSelect: function(record) {
				var rows = MatOrdItmGrid.getRows();
				var row = rows[MatOrdItmGrid.editIndex];
				row.Vendor = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	$('#PaAdmNo').bind('keypress', function(event) {
		if (event.keyCode == '13') {
			var PaAdmNo = $(this).val();
			if (PaAdmNo == '') {
				$UI.msg('alert', '������ǼǺ�!');
				return;
			}
			var patinfostr = tkMakeServerCall('web.DHCSTMHUI.HVMatOrdItm', 'Pa', PaAdmNo);
			var patinfoarr = patinfostr.split('^');
			var newPaAdmNo = patinfoarr[0];
			var patinfo = patinfoarr[1];// +","+patinfoarr[2];
			$('#PaAdmNo').val(newPaAdmNo);
			$('#PatName').val(patinfo);
		}
	});
	function TotalAmt() {
		var Rows = MatOrdItmGrid.getChecked();
		var TotalAmt = 0;
		for (var i = 0; i < Rows.length; i++) {
			var Rp = Rows[i].Rp;
			TotalAmt = Number(TotalAmt) + Number(Rp);
		}
		$('#MatAmt').text(TotalAmt);
	}
	var MatOrdCm = [[
		{	field: 'ck',
			checkbox: true,
			width: 100
		}, {
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			hidden: true,
			width: 100
		}, {
			title: '����RowId',
			field: 'Inci',
			hidden: true,
			width: 100
		}, {
			title: '����',
			field: 'InciCode',
			width: 100
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 100
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '����',
			field: 'BarCode',
			width: 100
		}, {
			title: '��ⵥ',
			field: 'Ingri',
			hidden: true,
			width: 100
		}, {
			title: '��������',
			field: 'Date',
			width: 100
		}, {
			title: '����',
			field: 'Rp',
			width: 100,
			align: 'right'
		}, {
			title: '��Ʊ���',
			field: 'InvAmt',
			saveCol: true,
			width: 100,
			align: 'right'
		}, {
			title: '��Ʊ����',
			field: 'InvCode',
			saveCol: true,
			width: 100,
			editor: {
				type: 'text',
				options: {
				}
			}
		}, {
			title: '��Ʊ��',
			field: 'InvNo',
			saveCol: true,
			width: 100,
			editor: {
				type: 'text',
				options: {
				}
			}
		}, {
			title: '��Ʊ����',
			field: 'InvDate',
			saveCol: true,
			width: 100,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: '����',
			field: 'BatNo',
			width: 100
		}, {
			title: '��Ч��',
			field: 'ExpDate',
			width: 100
		}, {
			title: '��ⵥ��',
			field: 'IngNo',
			width: 100
		}, {
			title: '��¼��ⵥ��',
			field: 'IngriModifyNo',
			width: 100
		}, {
			title: '���ߵǼǺ�',
			field: 'PaNo',
			width: 100
		}, {
			title: 'ҽ��',
			field: 'Doctor',
			width: 100
		}, {
			title: 'ҽ������',
			field: 'OrdDate',
			width: 100
		}, {
			title: 'ҽ��ʱ��',
			field: 'OrdTime',
			width: 100
		}, {
			title: '����',
			field: 'Qty',
			width: 100,
			align: 'right'
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 100
		}, {
			title: '��¼���տ���',
			field: 'AdmLoc',
			width: 100
		}, {
			title: '���߲���',
			field: 'Ward',
			width: 100
		}, {
			title: '����',
			field: 'Bed',
			width: 100
		}, {
			title: '������',
			field: 'PrescNo',
			width: 100,
			hidden: true
		}, {
			title: '����״̬',
			field: 'FreeStatus',
			width: 100,
			hidden: true
		}, {
			title: '�����ܶ�',
			field: 'FeeAmt',
			width: 100,
			align: 'right'
		}, {
			title: '��Ӧ��',
			field: 'VendorDr',
			saveCol: true,
			width: 100,
			formatter: CommonFormatter(VendorBox, 'VendorDr', 'Vendor'),
			editor: VendorBox
		}, {
			title: '��������',
			field: 'Manf',
			width: 100
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 100,
			align: 'right'
		}, {
			title: '������',
			field: 'SpecDesc',
			width: 100,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: 'IngriModify',
			field: 'IngriModify',
			saveCol: true,
			hidden: true,
			width: 50
		}, {
			title: 'Initi',
			field: 'Initi',
			saveCol: true,
			hidden: true,
			width: 50
		}
	]];
	var MatOrdItmGrid = $UI.datagrid('#MatOrdItmGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.HVMatOrdItm',
			QueryName: 'HVMatOrdItems',
			query2JsonStrict: 1,
			rows: 9999,
			totalFooter: '"�ϼ�":"InciCode"',
			totalFields: 'Rp,InvAmt,FeeAmt'
		},
		columns: MatOrdCm,
		singleSelect: false,
		showBar: true,
		toolbar: '#MatTB',
		pagination: false,
		showFooter: true,
		onClickCell: function(index, filed, value) {
			var rows = MatOrdItmGrid.getRows();
			var row = rows[index];
			if (!isEmpty(row.Ingri) && (filed == 'VendorDr')) {
				return false;
			}
			MatOrdItmGrid.commonClickCell(index, filed, value);
		},
		onEndEdit: function(index, row, changes) {
			var Editors = $(this).datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
			}
		},
		onCheck: function(index, row) {
			var IngriModify = row.IngriModify;
			var MainIngr = IngriModify.split('||')[0];
			var Initi = row.Initi;
			var MainInit = Initi.split('||')[0];
			CURRENT_INGR = MainIngr;
			CURRENT_INIT = MainInit;
			TotalAmt();
		},
		onUncheck: function(Index, Row) {
			TotalAmt();
		},
		onCheckAll: function(rows) {
			TotalAmt();
		},
		onUncheckAll: function(rows) {
			$('#MatAmt').text(0);
		},
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if ((data.rows.length > 0) && (CommParObj.IfSelFirstRow == 'Y')) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	var InGrMainCm = [[
		{	field: 'ck',
			checkbox: true,
			width: 100
		}, {
			title: 'RowId',
			field: 'IngrId',
			hidden: true,
			width: 100
		}, {
			title: '��ⵥ��',
			field: 'IngrNo',
			width: 100
		}, {
			title: '��ⲿ��',
			field: 'RecLoc',
			width: 100
		}, {
			title: '��Ӧ��',
			field: 'Vendor',
			width: 100
		}, {
			title: 'StkGrp',
			field: 'StkGrp',
			hidden: true
		}, {
			title: '�ɹ�Ա',
			field: 'PurchUser',
			width: 100
		}, {
			title: '��ɱ�־',
			field: 'Complete',
			width: 100
		}, {
			title: '��Ʊ���',
			field: 'InvAmt',
			width: 100,
			align: 'right'
		}, {
			title: '���۽��',
			field: 'RpAmt',
			hidden: true,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '��ע',
			field: 'InGrRemarks',
			width: 100
		}
	]];

	var IngrMainGrid = $UI.datagrid('#IngrMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'QueryIngrStr',
			query2JsonStrict: 1
		},
		columns: InGrMainCm,
		singleSelect: false,
		showBar: true,
		onSelect: function(index, row) {
			IngrDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryDetail',
				query2JsonStrict: 1,
				Parref: row.IngrId
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	var IngrDetailCm = [[
		{	field: 'ck',
			checkbox: true,
			width: 100
		}, {
			title: 'Ingri',
			field: 'Ingri',
			hidden: true,
			width: 100
		}, {
			title: '���ʴ���',
			field: 'IncCode',
			width: 100
		}, {
			title: '��������',
			field: 'IncDesc',
			width: 100
		}, {
			title: '��������',
			field: 'Manf',
			width: 100
		}, {
			title: '����',
			field: 'BatchNo',
			width: 100
		}, {
			title: '��Ч��',
			field: 'ExpDate',
			width: 100
		}, {
			title: '��λ',
			field: 'IngrUom',
			width: 100
		}, {
			title: '����',
			field: 'RecQty',
			width: 100,
			align: 'right'
		}, {
			title: '����',
			field: 'Rp',
			width: 100,
			align: 'right'
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 100,
			align: 'right'
		}, {
			title: '��Ʊ��',
			field: 'InvNo',
			width: 100
		}, {
			title: '��Ʊ����',
			field: 'InvDate',
			width: 100
		}, {
			title: '��Ʊ���',
			field: 'InvMoney',
			width: 100,
			align: 'right'
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
		}
	]];

	var IngrDetailGrid = $UI.datagrid('#IngrDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1
		},
		columns: IngrDetailCm,
		singleSelect: false,
		showBar: true
	});
	var InitMainCm = [[
		{	field: 'ck',
			checkbox: true,
			width: 100
		}, {
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 100
		}, {
			title: 'ת�Ƶ���',
			field: 'InitNo',
			width: 100
		}, {
			title: '������',
			field: 'ToLocDesc',
			width: 100
		}, {
			title: '��������',
			field: 'FrLocDesc',
			width: 100
		}, {
			title: 'ת������',
			field: 'InitDate',
			width: 100
		}, {
			title: '�Ƶ���',
			field: 'UserName',
			width: 100
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100
		}
	]];

	var InitMainGrid = $UI.datagrid('#InitMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'QueryTrans',
			query2JsonStrict: 1
		},
		columns: InitMainCm,
		singleSelect: false,
		showBar: true,
		onSelect: function(index, row) {
			InitDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
				QueryName: 'DHCINIsTrfD',
				query2JsonStrict: 1,
				Params: JSON.stringify({ Init: row.RowId })
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	var InitDetailCm = [[
		{	field: 'ck',
			checkbox: true,
			width: 100
		}, {
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 100
		}, {
			title: '����RowId',
			field: 'InciId',
			hidden: true,
			width: 100
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 100
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 100
		}, {
			title: '����Id',
			field: 'Inclb',
			hidden: true,
			width: 100
		}, {
			title: '����/Ч��',
			field: 'BatExp',
			width: 100
		}, {
			title: '��������',
			field: 'ManfDesc',
			width: 100
		}, {
			title: '���ο��',
			field: 'InclbQty',
			width: 100
		}, {
			title: 'ת������',
			field: 'Qty',
			width: 100
		}, {
			title: 'ת�Ƶ�λ',
			field: 'UomDesc',
			width: 100
		}, {
			title: '����',
			field: 'Rp',
			width: 100
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 100
		}, {
			title: '��������',
			field: 'ReqQty',
			width: 100
		}, {
			title: '��λ��',
			field: 'StkBin',
			width: 100
		}, {
			title: '���󷽿��',
			field: 'ReqLocStkQty',
			width: 100
		}, {
			title: 'ռ������',
			field: 'InclbDirtyQty',
			width: 100
		}, {
			title: '��������',
			field: 'InclbAvaQty',
			width: 100
		}, {
			title: '�����ۼ�',
			field: 'NewSp',
			width: 100
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100
		}
	]];

	var InitDetailGrid = $UI.datagrid('#InitDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			query2JsonStrict: 1
		},
		columns: InitDetailCm,
		singleSelect: false,
		showBar: true
	});
	Clear();
	Query();
	GetReportStyle('#FlagUsedHvImp');
	GetReportStyle('#FlagUsedHvImp1');
	GetReportStyle('#FlagUsedHvPatent');
	GetReportStyle('#FlagUsedMrNo');
};
$(init);