/* 跟台高值清点*/
var init = function() {
	var InciHandlerParams = function() {
		var Obj = {
			StkGrpType: 'M'
		};
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(InciHandlerParams, '#InciDesc', '#Inci'));
	var Clear = function() {
		$UI.clearBlock('#MainConditions');
		$UI.clearBlock('#BatExpCondition');
		$UI.clear(TableHVRecordGrid);
		// /设置初始值 考虑使用配置
		var DefaultData = {
			FromDate: TrackDefaultStDate(),
			ToDate: TrackDefaultEdDate(),
			OrdLoc: gLocObj,
			TableFlag: 'Y'
		};
		$UI.fillBlock('#MainConditions', DefaultData);
		$('#SInci').val('');
		if ((SerUseObj.ECS == 'Y') || (SerUseObj.SCI == 'Y')) {
			$('.SCIShow').show();
		} else {
			$('.SCIShow').hide();
		}
	};
	var OrdLocParams = JSON.stringify(addSessionParams({ Type: 'Login', Element: 'OrdLoc' }));
	$HUI.combobox('#OrdLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + OrdLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var VendorBoxParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	$HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorBoxParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var SpecDescParams = JSON.stringify(sessionObj);
	var SpecDescbox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSpecDesc&ResultSetType=array&Params=' + SpecDescParams,
			valueField: 'Description',
			textField: 'Description',
			onBeforeLoad: function(param) {
				var Select = TableHVRecordGrid.getSelected();
				if (!isEmpty(Select)) {
					param.Inci = Select['Inci'];
				}
			}
		}
	};
	var VendorCombo = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorBoxParams,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			tipPosition: 'bottom',
			onSelect: function(record) {
				var rows = TableHVRecordGrid.getRows();
				var row = rows[TableHVRecordGrid.editIndex];
				row['Vendor'] = record['Description'];
			}
		}
	};
	
	var MainLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	var MainLocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + MainLocParams,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = TableHVRecordGrid.getRows();
				var row = rows[TableHVRecordGrid.editIndex];
				row.MainLocDesc = record.Description;
			}
		}
	};
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
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
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			Print();
		}
	});
	$UI.linkbutton('#PrintDocBT', {
		onClick: function() {
			PrintDoc();
		}
	});
	$('#MainLabel').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			$('#SecLabel').focus();
		}
	});
	$('#SecLabel').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			var Code = $('#MainLabel').val();
			if (isEmpty(Code)) {
				$UI.msg('alert', '请输入主条码!');
				return;
			}
			var BatCode = $(this).val();
			if (isEmpty(BatCode)) {
				return;
			}
			
			var CodeObj = $.cm({
				ClassName: 'web.DHCSTMHUI.DHCUDI',
				MethodName: 'UDIInfo',
				Code: Code,
				SCode: BatCode
			}, false);
			var IncId = CodeObj['Inci'], InciCode = CodeObj['InciCode'], InciDesc = CodeObj['InciDesc'],
				batno = CodeObj['BatchNo'], expdate = CodeObj['ExpDate'];
			$('#SInci').val(IncId);
			if (IncId == '') {
				$UI.msg('alert', '主条码解析失败！');
				return;
			}
			$('#SInciCode').val(InciCode);
			$('#SInciDesc').val(InciDesc);
			$('#CodeBatNo').val(batno);
			$('#CodeExpDate').datebox('setValue', expdate);
			$('#BatNo').val(batno);
			$('#ExpDate').datebox('setValue', expdate);
			if (batno == '') {
				$UI.msg('alert', '批号为空!');
				// return;
			}
			if (expdate == '') {
				$UI.msg('alert', '效期为空!');
				// return;
			}
			
			var RowsData = TableHVRecordGrid.getRows();
			// 有效行数
			var suc = 0;
			for (var index = 0; index < RowsData.length; index++) {
				var RowData = RowsData[index];
				var inci = RowData['Inci'];
				if (suc == 1) {
					break;
				}
				if (inci != IncId) {
					continue;
				}
				
				var ExpDate = RowData['ExpDate'];
				if (isEmpty(ExpDate)) {
					$('#TableHVRecordGrid').datagrid('endEdit', index);
					$('#TableHVRecordGrid').datagrid('selectRow', index);
					$('#TableHVRecordGrid').datagrid('editCell', { index: index, field: 'BatNo' });
					var ed = $('#TableHVRecordGrid').datagrid('getEditor', { index: index, field: 'BatNo' });
					ed.target.val(batno);
					$('#TableHVRecordGrid').datagrid('editCell', { index: index, field: 'ExpDate' });
					var ed = $('#TableHVRecordGrid').datagrid('getEditor', { index: index, field: 'ExpDate' });
					$(ed.target).datebox('setValue', expdate);
					$('#TableHVRecordGrid').datagrid('endEdit', index);
					suc = 1;
				}
			}
			if (suc == 0) {
				$UI.msg('alert', '未找到匹配信息');
				return;
			} else {
				$('#MainLabel').val('');
				$('#SecLabel').val('');
				$('#MainLabel').focus();
			}
		}
	});
	$UI.linkbutton('#AssBT', {
		onClick: function() {
			var incicode = $('#SInciCode').val();
			var batno = $('#BatNo').val();
			var IncId = $('#SInci').val();
			var expdate = $('#ExpDate').datebox('getValue');
			var RowsData = TableHVRecordGrid.getRows();
			// 有效行数
			if (incicode == '') {
				$UI.msg('alert', '请先扫描主条码!');
				return;
			}
			var suc = 0;
			for (var index = 0; index < RowsData.length; index++) {
				var RowData = RowsData[index];
				var inci = RowData['Inci'];
				if (suc == 1) {
					break;
				}
				if (inci != IncId) {
					continue;
				}
				var ExpDate = RowData['ExpDate'];
				if (isEmpty(ExpDate)) {
					$('#TableHVRecordGrid').datagrid('endEdit', index);
					$('#TableHVRecordGrid').datagrid('selectRow', index);
					$('#TableHVRecordGrid').datagrid('editCell', { index: index, field: 'BatNo' });
					var ed = $('#TableHVRecordGrid').datagrid('getEditor', { index: index, field: 'BatNo' });
					ed.target.val(batno);
					$('#TableHVRecordGrid').datagrid('editCell', { index: index, field: 'ExpDate' });
					var ed = $('#TableHVRecordGrid').datagrid('getEditor', { index: index, field: 'ExpDate' });
					$(ed.target).datebox('setValue', expdate);
					$('#TableHVRecordGrid').datagrid('endEdit', index);
					suc = 1;
				}
			}
			if (suc == 0) {
				$UI.msg('alert', '未找到匹配信息');
				return;
			} else {
				$('#MainLabel').val('');
				$('#SecLabel').val('');
				$('#MainLabel').focus();
			}
		}
	});
	
	$('#PaAdmNo').bind('keypress', function(event) {
		if (event.keyCode == '13') {
			var PaAdmNo = $(this).val();
			if (PaAdmNo == '') {
				$UI.msg('alert', '请输入登记号!');
				return;
			}
			var patinfostr = tkMakeServerCall('web.DHCSTMHUI.HVMatOrdItm', 'Pa', PaAdmNo);
			if (patinfostr != '') {
				var patinfoarr = patinfostr.split('^');
				var newPaAdmNo = patinfoarr[0];
				var patinfo = patinfoarr[1] + ',' + patinfoarr[2];
				// var PatNoLen = tkMakeServerCall("web.DHCSTMHUI.DHCMatDisp", "GetPatNoLen");
				// var newPaAdmNo = NumZeroPadding(PaAdmNo, PatNoLen);
				$('#PaAdmNo').val(newPaAdmNo);
				$('#RegInfo').val(patinfo);
				Query();
			} else {
				$UI.msg('alert', '登记号不正确!');
				return;
			}
		}
	});
	$UI.linkbutton('#CopyBatNoBT', {
		onClick: function() {
			if (!TableHVRecordGrid.endEditing()) {
				$UI.msg('alert', '明细未完成编辑,请检查必填项!');
				return;
			}
			var Rows = TableHVRecordGrid.getSelections();
			var len = Rows.length;
			if (len == 0) {
				$UI.msg('alert', '请选择需要批量填充的明细!');
				return false;
			}
			SaveBatExpWin(SaveBatExp);
		}
	});
	function SaveBatExp(Params) {
		if (!TableHVRecordGrid.endEditing()) {
			$UI.msg('alert', '明细未完成编辑,请检查必填项!');
			return;
		}
		var FillFlag = $("input[name='Fill']:checked").val();	// 1:不覆盖, 2:覆盖已填
		var BatNo = Params['BatNo'];
		var ExpDate = Params['ExpDate'];
		var IngrLoc = Params['IngrLoc'];
		var IngrLocDesc = Params['IngrLocDesc'];
		var Rows = TableHVRecordGrid.getSelections();
		var len = Rows.length;
		if (len == 0) {
			$UI.msg('alert', '请勾选需要批量填充的明细!');
			return false;
		}
		var FillCount = 0;
		for (var index = 0; index < len; index++) {
			var RowData = Rows[index];
			if ((FillFlag == '1') && !(isEmpty(RowData.BatNo) && isEmpty(RowData.ExpDate))) {
				continue;
			}
			RowData.BatNo = BatNo;
			RowData.ExpDate = ExpDate;
			RowData.MainLoc = IngrLoc;
			RowData.MainLocDesc = IngrLocDesc;
			var RowIndex = $('#TableHVRecordGrid').datagrid('getRowIndex', Rows[index]);
			$('#TableHVRecordGrid').datagrid('refreshRow', RowIndex);
			/* $('#TableHVRecordGrid').datagrid('endEdit', index);
			$('#TableHVRecordGrid').datagrid('selectRow', index);
			$('#TableHVRecordGrid').datagrid('editCell', { index: index, field: 'BatNo' });
			var ed = $('#TableHVRecordGrid').datagrid('getEditor', { index: index, field: 'BatNo' });
			$(ed.target).val(BatNo);
			$('#TableHVRecordGrid').datagrid('editCell', { index: index, field: 'ExpDate' });
			var ed = $('#TableHVRecordGrid').datagrid('getEditor', { index: index, field: 'ExpDate' });
			$(ed.target).datebox('setValue', ExpDate);
			$('#TableHVRecordGrid').datagrid('editCell', { index: index, field: 'MainLoc' });
			var ed = $('#TableHVRecordGrid').datagrid('getEditor', { index: index, field: 'MainLoc' });
			//var IngrLocObj={RowId: IngrLoc, Description:IngrLocDesc};
			//$(ed.target).combobox('loadData', IngrLocObj);
			$('#TableHVRecordGrid').datagrid('endEdit', index);
			*/
			FillCount++;
		}
		if (FillCount > 0) {
			$UI.msg('alert', '已填充' + FillCount + '行, 请注意保存!');
		} else {
			$UI.msg('error', '未进行有效填充!');
		}
	}
	var TableHVRecordCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			width: 60,
			hidden: true
		}, {
			title: 'Oeori',
			field: 'Oeori',
			width: 60,
			hidden: true
		}, {
			title: '物资RowId',
			field: 'Inci',
			width: 60,
			hidden: true
		}, {
			title: '代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 100
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 100
		}, {
			title: '数量',
			field: 'Qty',
			width: 100
		}, {
			title: '批号',
			field: 'BatNo',
			saveCol: true,
			width: 100,
			editor: {
				type: 'text',
				options: {
				}
			}
		}, {
			title: '有效期',
			field: 'ExpDate',
			saveCol: true,
			width: 100,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			saveCol: true,
			width: 100,
			editable: false,
			formatter: CommonFormatter(SpecDescbox, 'SpecDesc', 'SpecDesc'),
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true,
			editor: (CodeMainParamObj.UseSpecList == 'Y' ? false : true) ? null : SpecDescbox
		}, {
			title: 'dhcit',
			field: 'dhcit',
			saveCol: true,
			width: 100,
			hidden: true
		}, {
			title: '自带条码',
			field: 'OriginalCode',
			saveCol: true,
			width: 150,
			editor: {
				type: 'text',
				options: {
				}
			}
		}, {
			title: '条码',
			field: 'BarCode',
			width: 150
		}, {
			title: '补录标记',
			field: 'IngrFlag',
			formatter: BoolFormatter,
			align: 'center',
			width: 100
		}, {
			title: '进价',
			field: 'Rp',
			saveCol: true,
			width: 100,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '售价',
			field: 'Sp',
			width: 100
		}, {
			title: '供应商',
			field: 'VendorDr',
			formatter: CommonFormatter(VendorCombo, 'VendorDr', 'Vendor'),
			editor: VendorCombo,
			saveCol: true,
			width: 200
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 100
		}, {
			title: '患者登记号',
			field: 'PaNo',
			width: 100
		}, {
			title: '患者姓名',
			field: 'PaName',
			width: 100
		}, {
			title: '患者科室',
			field: 'AdmLoc',
			width: 150
		}, {
			title: '医生',
			field: 'Doctor',
			width: 100
		}, {
			title: '医嘱日期',
			field: 'OrdDate',
			width: 100
		}, {
			title: '医嘱时间',
			field: 'OrdTime',
			width: 100
		}, {
			title: '补录入库科室',
			field: 'MainLoc',
			width: 150,
			saveCol: true,
			formatter: CommonFormatter(MainLocCombox, 'MainLoc', 'MainLocDesc'),
			editor: MainLocCombox
		}, {
			title: 'Adm',
			field: 'Adm',
			width: 100,
			hidden: true
		}
	]];
	var TableHVRecordGrid = $UI.datagrid('#TableHVRecordGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.HVMatOrdItm',
			QueryName: 'HVMatOrdItems',
			query2JsonStrict: 1
		},
		columns: TableHVRecordCm,
		showBar: true,
		singleSelect: false,
		onClickRow: function(index, row) {
			TableHVRecordGrid.commonClickRow(index, row);
		}
	});
	
	function Query() {
		var ParamsObj = $UI.loopBlock('#MainConditions');
		var StartDate = ParamsObj.FromDate;
		var EndDate = ParamsObj.ToDate;
		if (isEmpty(ParamsObj.OrdLoc)) {
			$UI.msg('alert', '医嘱接受科室不能为空!');
			return;
		}
		if (isEmpty(StartDate)) {
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if (isEmpty(EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '截止日期不能小于开始日期!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		TableHVRecordGrid.load({
			ClassName: 'web.DHCSTMHUI.HVMatOrdItm',
			QueryName: 'HVMatOrdItems',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	function Save() {
		if (!TableHVRecordGrid.endEditing()) {
			$UI.msg('alert', '明细未完成编辑,请检查必填项!');
			return;
		}
		var RowsData = TableHVRecordGrid.getRows();
		if (RowsData.length <= 0) {
			$UI.msg('alert', '没有需要保存的记录!');
			return;
		}
		/* if (RowsData === false){	//未完成编辑或明细为空
			return;
		}
		if (isEmpty(RowsData)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
			return;
		}*/
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.HVMatOrdItm',
			MethodName: 'SaveHvmInfo',
			ListData: JSON.stringify(RowsData)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				// Query();
				$('#TableHVRecordGrid').datagrid('reload');
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	function Print() {
		var rowsData = TableHVRecordGrid.getSelections();
		if (rowsData.length <= 0) {
			$UI.msg('alert', '没有要打印的高值条码!');
			return;
		}
		var count = rowsData.length;
		for (var rowIndex = 0; rowIndex < count; rowIndex++) {
			var row = rowsData[rowIndex];
			var BarCode = row.BarCode;
			PrintBarcode(BarCode, 1);
		}
	}
	function PrintDoc() {
		var rowsData = TableHVRecordGrid.getSelections();
		if (rowsData.length <= 0) {
			$UI.msg('alert', '请勾选需要打印的记录!');
			return;
		}
		var PaAdmNo = $('#PaAdmNo').val();
		if (isEmpty(PaAdmNo)) {
			$UI.msg('alert', '请输入登记号!');
			return;
		}
		var OriIdStr = '';
		var count = rowsData.length;
		var allowcount = 0;
		var Adm = '';
		for (var rowIndex = 0; rowIndex < count; rowIndex++) {
			var row = rowsData[rowIndex];
			var PaNo = row.PaNo;
			var RowId = row.RowId;
			var PaAdmId = row.Adm;
			if (PaNo == PaAdmNo) {
				if (OriIdStr == '') { OriIdStr = RowId; } else { OriIdStr = OriIdStr + ',' + RowId; }
				allowcount = allowcount + 1;
				Adm = PaAdmId;
			}
		}
		if (allowcount == 0) {
			$UI.msg('alert', '请勾选与当前登记号相符合的信息!');
			return;
		}
		if (allowcount < count) {
			$UI.msg('alert', '勾选记录中存在与当前登记号不符合的信息!');
		}
		var RaqName = 'DHCSTM_HUI_TableHVRecord.raq';
		var fileName = '{' + RaqName + '(OriIdStr=' + OriIdStr + ';Adm=' + Adm + ')}';
		var transfileName = TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(transfileName);
	}
	Clear();
	Query();
};
$(init);