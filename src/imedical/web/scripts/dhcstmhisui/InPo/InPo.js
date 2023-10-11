var init = function() {
	/* --按钮事件--*/
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			FindWin(Select);
		}
	});
	var Select = function(PoId) {
		$UI.clearBlock('#MainConditions');
		$UI.clear(PoGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPO',
			MethodName: 'Select',
			PoId: PoId
		}, function(jsonData) {
			$UI.fillBlock('#MainConditions', jsonData);
			if ($HUI.checkbox('#CompFlag').getValue() == false) {
				setUnComp();
			} else {
				setComp();
			}
		});
		PoGrid.load({
			ClassName: 'web.DHCSTMHUI.INPOItm',
			QueryName: 'Query',
			query2JsonStrict: 1,
			PoId: PoId,
			totalFooter: '"InciDesc":"合计"',
			totalFields: 'RpAmt'
		});
	};
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			DefaultClear();
		}
	});
	function DefaultClear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(PoGrid);
		$HUI.combobox('#PoLoc').enable();
		$HUI.combobox('#StkScg').enable();
		$HUI.combobox('#Vendor').enable();
		ChangeButtonEnable({
			'#AddBT': true,
			'#DelBT': true,
			'#ComBT': true,
			'#CanComBT': false
		});
		Default();
	}
	$UI.linkbutton('#DelBT', {
		onClick: function() {
			if ($HUI.checkbox('#CompFlag').getValue() == true) {
				$UI.msg('alert', '已经完成，不能删除!');
				return false;
			}
			var PoId = $('#RowId').val();
			if (isEmpty(PoId)) {
				$UI.msg('alert', '请选择要删除的订单');
				return;
			}
			$UI.confirm('确定要删除吗', 'warning', '', Delete, '', '', '警告', false);
		}
	});
	function Delete() {
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPO',
			MethodName: 'jsDelete',
			PoId: $('#RowId').val()
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				DefaultClear();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			Save();
		}
	});
	var Save = function() {
		var MainObj = $UI.loopBlock('#MainConditions');
		var NeedDate = MainObj['NeedDate'];
		if (!isEmpty(NeedDate) && compareDate(NeedDate, DateFormatter(new Date())) < 0) {
			$UI.msg('alert', '到货日期不能小于当天!');
			return;
		}
		var Main = JSON.stringify(addSessionParams(MainObj));
		var DetailObj = PoGrid.getChangesData('InciId');
		// 判断
		var ifChangeMain = $UI.isChangeBlock('#MainConditions');
		if (DetailObj === false) {	// 未完成编辑或明细为空
			return;
		}
		if (!ifChangeMain && (isEmpty(DetailObj))) {	// 主单和明细不变
			$UI.msg('alert', '没有需要保存的信息!');
			return;
		}
		
		if ($HUI.checkbox('#CompFlag').getValue() == true) {
			$UI.msg('alert', '已经完成，不能保存!');
			return false;
		}
		var CheckMsgArr = [];
		var InpoRows = PoGrid.getRows();
		for (var i = 0; i < InpoRows.length; i++) {
			var InpoRow = InpoRows[i];
			var Inci = InpoRow.InciId;
			var InciDesc = InpoRow.InciDesc;
			var SpecDesc = InpoRow.SpecDesc;
			var RowIndex = $('#PoGrid').datagrid('getRowIndex', InpoRow);
			$.each(InpoRows, function(index, row) {
				var tmpInci = row['InciId'];
				var tmpInciDesc = row['InciDesc'];
				var tmpSpecDesc = row['SpecDesc'];
				if (tmpInci == Inci && index != RowIndex) {
					if ((CodeMainParamObj.UseSpecList != 'Y') || (isEmpty(tmpSpecDesc) && (isEmpty(SpecDesc)))) {
						var CheckMsg = InciDesc + '重复录入';
						CheckMsgArr.push(CheckMsg);
					} else {
						if (tmpSpecDesc == SpecDesc) {
							var CheckMsg = InciDesc + '具体规格:[' + SpecDesc + ']重复录入';
							CheckMsgArr.push(CheckMsg);
						}
					}
				}
			});
		}
		if (!isEmpty(CheckMsgArr)) {
			$UI.msg('alert', CheckMsgArr.join());
			return false;
		}
		showMask();
		var Detail = JSON.stringify(DetailObj);
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPO',
			MethodName: 'Save',
			Main: Main,
			Detail: Detail
		}, function(jsonData) {
			hideMask();
			$UI.msg('success', jsonData.msg);
			if (jsonData.success == 0) {
				Select(jsonData.rowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	};

	$UI.linkbutton('#ComBT', {
		onClick: function() {
			var PoId = $('#RowId').val();
			if (isEmpty(PoId)) {
				$UI.msg('alert', '请选择要完成的订单');
				return;
			}
			var Detail = PoGrid.getChangesData();
			if (Detail != '') {
				$UI.confirm('数据已修改是否放弃保存！', 'warning', '', SetComplete, '', '', '警告', false);
			} else {
				SetComplete();
			}
		}
	});
	
	function SetComplete() {
		var MainObj = $UI.loopBlock('#MainConditions');
		var Main = JSON.stringify(MainObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPO',
			MethodName: 'jsSetComplete',
			Params: Main
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Select(jsonData.rowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	$UI.linkbutton('#CanComBT', {
		onClick: function() {
			var PoId = $('#RowId').val();
			if (isEmpty(PoId)) {
				$UI.msg('alert', '请选择要取消完成的订单');
				return;
			}
			var MainObj = $UI.loopBlock('#MainConditions');
			var Main = JSON.stringify(MainObj);
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.INPO',
				MethodName: 'jsCancelComplete',
				Params: Main
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Select(jsonData.rowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var PoId = $('#RowId').val();
			if (isEmpty(PoId)) {
				$UI.msg('alert', '请选择要打印的订单');
				return;
			}
			PrintInPo(PoId);
		}
	});
	
	$UI.linkbutton('#SelInciBT', {
		onClick: function() {
			if ($HUI.checkbox('#CompFlag').getValue() == true) {
				$UI.msg('alert', '已经完成，不能增加');
				return false;
			}
			if (isEmpty($HUI.combobox('#PoLoc').getValue())) {
				$UI.msg('alert', '订单科室不能为空');
				return false;
			}
			if (isEmpty($HUI.combobox('#StkScg').getValue())) {
				$UI.msg('alert', '类组不能为空');
				return false;
			}
			if (isEmpty($HUI.combobox('#Vendor').getValue())) {
				$UI.msg('alert', '供应商不能为空');
				return false;
			}
			setUnComp();
			
			var Scg = $('#StkScg').combotree('getValue');
			var Vendor = $('#Vendor').combo('getValue');
			var PoLoc = $('#PoLoc').combo('getValue');
			var ParamsObj = {
				StkGrpRowId: Scg,
				StkGrpType: 'M',
				Locdr: PoLoc,
				NotUseFlag: 'N',
				QtyFlag: 0,	// 库存,
				Vendor: Vendor,
				SeachAllFlag: 'Y'
			};
			var OthersObj = {
				DefaUom: 0
			};
			IncItmWindow(ParamsObj, OthersObj, ReturnInfoFunc);
		}
	});
	var ReturnInfoFunc = function(RowsData) {
		var RowsLen = RowsData.length;
		for (var i = 0; i < RowsLen; i++) {
			var RowData = RowsData[i];
			var UomId = RowData.BUomDr;
			var UomDesc = RowData.BUomDesc;
			UomId = RowData.PUomDr;
			UomDesc = RowData.PUomDesc;
			
			var rowObj = {
				InciId: RowData.InciDr,
				InciCode: RowData.InciCode,
				InciDesc: RowData.InciDesc,
				Spec: RowData.Spec,
				UomId: RowData.PUomDr,
				UomDesc: RowData.PUomDesc,
				PurQty: RowData.Qty,
				ManfId: RowData.Manfdr,
				ManfDesc: RowData.ManfName,
				BUomId: RowData.BUomDr,
				ConFac: RowData.PFac,
				Rp: RowData.PRp,
				RpAmt: accMul(Number(RowData.Qty), Number(RowData.PRp))
			};
			
			var tmprow = $.extend({}, rowObj);
			var EditRowIndex = 0;
			var length = PoGrid.getRows().length;
			if (length > 0) {
				EditRowIndex = length;
			}
			PoGrid.insertRow({
				index: EditRowIndex,
				row: tmprow
			});
		}
	};

	/* --绑定控件--*/
	$HUI.combobox('#PoLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PoLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#StkScg').setFilterByLoc(LocId);
			if (CommParObj.ApcScg == 'L') {
				VendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				VendorBox.reload(url);
			}
		}
	});
	var ReqLocParams = JSON.stringify(addSessionParams({ Type: 'All', Element: 'ReqLoc' }));
	$HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description',
		onBeforeLoad: function(param) {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			var ScgId = ParamsObj.StkScg;
			param.ScgId = ScgId;
		}
	});

	/* --Grid列绑定--*/
	var HandlerParams = function() {
		var StkScg = $('#StkScg').combotree('getValue');
		var PoLoc = $('#PoLoc').combo('getValue');
		var Vendor = '';
		if (InPoParamObj.VendorFilter == 'Y') {
			Vendor = $('#Vendor').combo('getValue');
		}
		var Obj = {
			StkGrpRowId: StkScg,
			StkGrpType: 'M',
			Locdr: PoLoc,
			NotUseFlag: 'N',
			QtyFlag: 'Y',
			ToLoc: '',
			ReqModeLimited: '',
			NoLocReq: 'N',
			Vendor: Vendor,
			HV: '',
			RequestNoStock: 'Y'
		};
		return Obj;
	};
	var SelectRow = function(row) {
		var PoLoc = $HUI.combobox('#PoLoc').getValue();
		var InciParams = JSON.stringify(addSessionParams({
			LocId: PoLoc
		}));
		var Inci = row.InciDr;
		var InciDesc = row.InciDesc;
		var FindIndex = PoGrid.find('InciId', Inci);
		if (CodeMainParamObj.UseSpecList != 'Y' && FindIndex >= 0 && FindIndex != PoGrid.editIndex) {
			$UI.msg('alert', InciDesc + '已存在于第' + (FindIndex + 1) + '行!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPO',
			MethodName: 'GetItmInfo',
			IncId: row.InciDr,
			Params: InciParams
		}, function(jsonData) {
			var Rows = PoGrid.getRows();
			var Row = Rows[PoGrid.editIndex];
			Row.InciId = row.InciDr;
			Row.InciCode = row.InciCode;
			Row.InciDesc = row.InciDesc;
			Row.Spec = row.Spec;
			Row.UomId = row.PUomDr;
			Row.UomDesc = row.PUomDesc;
			Row.Rp = jsonData.Rp;
			Row.BUomId = row.BUomDr;
			Row.ConFac = jsonData.Confac;
			Row.ManfId = jsonData.ManfId;
			Row.ManfDesc = jsonData.ManfDesc;
			if (InPoParamObj.DefaUom == 1) {
				Row.UomId = jsonData.BUomId;
				Row.UomDesc = jsonData.BUomDesc;
				Row.Rp = jsonData.BRp;
				Row.Sp = jsonData.BSp;
			}
			setTimeout(function() {
				PoGrid.refreshRow();
				PoGrid.startEditingNext('InciDesc');
			}, 50);
		});
	};

	var UomCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			tipPosition: 'bottom',
			mode: 'remote',
			editable: false,
			onBeforeLoad: function(param) {
				var rows = PoGrid.getRows();
				var row = rows[PoGrid.editIndex];
				if (!isEmpty(row)) {
					param.Inci = row.InciId;
				}
			},
			onSelect: function(record) {
				var rows = PoGrid.getRows();
				var row = rows[PoGrid.editIndex];
				var seluom = record.RowId;
				var rp = row.Rp;
				var buom = row.BUomId;
				var confac = row.ConFac;
				var uom = row.UomId; // 旧单位
				if (seluom != uom) {
					if (seluom != buom) { // 原单位是基本单位，目前选择的是入库单位
						row.Rp = Number(rp).mul(Number(confac));
					} else { // 目前选择的是基本单位，原单位是入库单位
						row.Rp = Number(rp).div(Number(confac));
					}
				}
				row.UomDesc = record.Description;
				row.UomId = record.RowId;
				setTimeout(function() {
					PoGrid.refreshRow();
				}, 0);
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	var SpecDescParams = JSON.stringify(sessionObj);
	var SpecDescbox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSpecDesc&ResultSetType=array&Params=' + SpecDescParams,
			valueField: 'Description',
			textField: 'Description',
			required: false,
			mode: 'remote',
			onBeforeLoad: function(param) {
				var rows = PoGrid.getRows();
				var row = rows[PoGrid.editIndex];
				if (!isEmpty(row)) {
					param.Inci = row.InciId;
				}
			}
		}
	};

	var PoCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			hidden: true,
			width: 60
		}, {
			title: '物资RowId',
			field: 'InciId',
			saveCol: true,
			hidden: true,
			width: 60
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 200,
			editor: InciEditor(HandlerParams, SelectRow)
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '生产厂家',
			field: 'ManfId',
			width: 100,
			saveCol: true,
			hidden: true
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 100
		}, {
			title: '数量',
			field: 'PurQty',
			width: 100,
			align: 'right',
			saveCol: true,
			necessary: true,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			}
		}, {
			title: '单位',
			field: 'UomId',
			width: 80,
			saveCol: true,
			necessary: true,
			formatter: CommonFormatter(UomCombox, 'UomId', 'UomDesc'),
			editor: UomCombox
		}, {
			title: '进价',
			field: 'Rp',
			width: 80,
			align: 'right',
			saveCol: true,
			necessary: true,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 100,
			saveCol: CodeMainParamObj.UseSpecList == 'Y' ? true : false,
			formatter: CommonFormatter(SpecDescbox, 'SpecDesc', 'SpecDesc'),
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true,
			editor: (CodeMainParamObj.UseSpecList == 'Y' ? false : true) ? null : SpecDescbox
		}, {
			title: '基本单位Id',
			field: 'BUomId',
			width: 80,
			hidden: true
		}, {
			title: '单位转换系数',
			field: 'ConFac',
			width: 80,
			hidden: true
		}, {
			title: '备注',
			field: 'Remark',
			width: 100,
			saveCol: true,
			editor: {
				type: 'text'
			}
		}
	]];

	var PoGrid = $UI.datagrid('#PoGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPOItm',
			QueryName: 'Query',
			query2JsonStrict: 1,
			totalFooter: '"InciDesc":"合计"',
			totalFields: 'RpAmt'
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.INPOItm',
			MethodName: 'jsDelete'
		},
		columns: PoCm,
		checkField: 'InciId',
		singleSelect: false,
		showAddDelItems: true,
		remoteSort: false,
		showBar: true,
		showFooter: true,
		onClickRow: function(index, row) {
			PoGrid.commonClickRow(index, row);
		},
		beforeAddFn: function() {
			if ($HUI.checkbox('#CompFlag').getValue() == true) {
				$UI.msg('alert', '已经完成，不能增加一行');
				return false;
			}
			if (isEmpty($HUI.combobox('#PoLoc').getValue())) {
				$UI.msg('alert', '订单科室不能为空');
				return false;
			}
			if (isEmpty($HUI.combobox('#StkScg').getValue())) {
				$UI.msg('alert', '类组不能为空');
				return false;
			}
			if (isEmpty($HUI.combobox('#Vendor').getValue())) {
				$UI.msg('alert', '供应商不能为空');
				return false;
			}
			setUnComp();
		},
		onBeforeEdit: function(index, row) {
			if ($HUI.checkbox('#CompFlag').getValue()) {
				return false;
			}
		},
		onEndEdit: function(index, row, changes) {
			// 判断资质
			var VendorId = $('#Vendor').combo('getValue');
			var CheckCertObj = addSessionParams({
				Manf: row.ManfId,
				Inci: row.IncId,
				Vendor: VendorId
			});
			var CheckCertRet = Common_CheckCert(CheckCertObj, 'Warn');
			if (!CheckCertRet) {
				PoGrid.checked = false;
				return false;
			}
			var Editors = $(this).datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
				if (Editor.field == 'SpecDesc') {
					var SpecDesc = row.SpecDesc;
					var InciDesc = row.InciDesc;
					var Inci = row.InciId;
					var InpoRows = PoGrid.getRows();
					$.each(InpoRows, function(tindex, trow) {
						var tmpInci = trow['InciId'];
						var tmpInciDesc = trow['InciDesc'];
						var tmpSpecDesc = trow['SpecDesc'];
						if ((tmpInci == Inci) && (tmpSpecDesc == SpecDesc) && index != tindex) {
							$UI.msg('alert', tmpInciDesc + '具体规格:[' + tmpSpecDesc + ']重复录入');
							PoGrid.checked = false;
							return false;
						}
					});
				}
			}
		}
	});

	// 设置可编辑组件的disabled属性
	function setUnComp() {
		$HUI.combobox('#PoLoc').disable();
		$HUI.combobox('#StkScg').disable();
		$HUI.combobox('#Vendor').disable();
		ChangeButtonEnable({
			'#ClearBT': true,
			'#SaveBT': true,
			'#DelBT': true,
			'#ComBT': true,
			'#CanComBT': false
		});
	}
	function setComp() {
		$HUI.combobox('#PoLoc').disable();
		$HUI.combobox('#StkScg').disable();
		$HUI.combobox('#Vendor').disable();
		ChangeButtonEnable({
			'#ClearBT': true,
			'#SaveBT': false,
			'#DelBT': false,
			'#ComBT': false,
			'#CanComBT': true
		});
	}

	/* --设置初始值--*/
	var Default = function() {
		// /设置初始值 考虑使用配置
		var DefaultValue = {
			RowId: '',
			PoLoc: gLocObj,
			NeedDate: NeedDate()
		};
		$UI.fillBlock('#MainConditions', DefaultValue);
	};
	Default();
};
$(init);