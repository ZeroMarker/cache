var init = function() {
	if ('undefined' === typeof (sssAspType)) {
		sssAspType = '';
	}

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
				var Select = AdjPriceGrid.getSelected();
				if (!isEmpty(Select)) {
					param.Inci = Select.Inci;
				}
			},
			onSelect: function(record) {
				var rows = AdjPriceGrid.getRows();
				var row = rows[AdjPriceGrid.editIndex];
				row.AspUomDesc = record.Description;
				var NewUomid = record.RowId;
				var OldUomid = row.AspUomId;
				if (isEmpty(NewUomid) || (NewUomid == OldUomid)) {
					return false;
				}
				var BUomId = row.BUomId;
				var PriorRpUom = row.PriorRpUom;
				var PriorSpUom = row.PriorSpUom;
				var ResultRpUom = row.ResultRpUom;
				var ResultSpUom = row.ResultSpUom;
				var confac = row.ConFacPur;
				if (NewUomid == BUomId) { // 入库单位转换为基本单位
					row.PriorRpUom = Number(PriorRpUom).div(confac);
					row.PriorSpUom = Number(PriorSpUom).div(confac);
					row.ResultRpUom = Number(ResultRpUom).div(confac);
					row.ResultSpUom = Number(ResultSpUom).div(confac);
				} else { // 基本单位转换为入库单位
					row.PriorRpUom = Number(PriorRpUom).mul(confac);
					row.PriorSpUom = Number(PriorSpUom).mul(confac);
					row.ResultRpUom = Number(ResultRpUom).mul(confac);
					row.ResultSpUom = Number(ResultSpUom).mul(confac);
				}
				row.MarginNow = accDiv(row.ResultSpUom, row.ResultRpUom);
				row.DiffRpUom = accSub(row.ResultRpUom, row.PriorRpUom);
				row.DiffSpUom = accSub(row.ResultSpUom, row.PriorSpUom);
				row.AspUomId = NewUomid;
				AdjPriceGrid.EditorSetValue('ResultRpUom', row.ResultRpUom);
				AdjPriceGrid.EditorSetValue('ResultSpUom', row.ResultSpUom);
				setTimeout(function() {
					AdjPriceGrid.refreshRow();
				}, 0);
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	var AdjReasonComData = $.cm({
		ClassName: 'web.DHCSTMHUI.Common.Dicts',
		QueryName: 'GetAdjPriceReason',
		ResultSetType: 'array'
	}, false);
	var AdjReasonCombox = {
		type: 'combobox',
		options: {
			data: AdjReasonComData,
			valueField: 'RowId',
			textField: 'Description'
			// required: AdjSpParamObj.AllowSaveReasonEmpty != "Y"
		}
	};
	var InciHandlerParams = function() {
		var Scg = $('#ScgId').combotree('getValue');
		var Obj = {
			StkGrpRowId: Scg,
			StkGrpType: 'M',
			BDPHospital: gHospId
		};
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(InciHandlerParams, '#InciDesc', '#Inci'));
	var HandlerParams = function() {
		var Scg = $('#ScgId').combotree('getValue');
		var Obj = {
			StkGrpRowId: Scg,
			StkGrpType: 'M',
			Locdr: '',
			NotUseFlag: '',
			QtyFlag: 'Y',
			ToLoc: '',
			ReqModeLimited: '',
			NoLocReq: '',
			HV: '',
			BDPHospital: gHospId
		};
		return Obj;
	};
	var SelectRow = function(row) {
		var SelectRow = AdjPriceGrid.getSelected();
		SelectRow.Inci = row.InciDr;
		SelectRow.InciCode = row.InciCode;
		SelectRow.InciDesc = row.InciDesc;
		SelectRow.Spec = row.Spec;
		var ParamsObj = $UI.loopBlock('Conditions');
		var Params = JSON.stringify(ParamsObj);
		$.cm({
			ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
			MethodName: 'GetItmInfo',
			Inci: row.InciDr,
			Params: Params
		}, function(jsonData) {
			SelectRow.BUomId = jsonData.BUomId;
			SelectRow.ConFacPur = jsonData.ConFacPur;
			SelectRow.PriorSpUom = jsonData.PurSp;
			SelectRow.PriorRpUom = jsonData.PurRp;
			SelectRow.ResultSpUom = jsonData.PurSp;
			SelectRow.ResultRpUom = jsonData.PurRp;
			if ((jsonData.PurSp != 0) && (jsonData.PurRp != 0)) {
				var margin = accDiv(jsonData.PurSp, jsonData.PurRp);
				SelectRow.MarginNow = margin.toFixed(3);
			}
			SelectRow.MarkTypeDesc = jsonData.MarkTypeDesc;
			SelectRow.StkCatDesc = jsonData.StkCatDesc;
			SelectRow.WarrentNo = jsonData.WarrentNo;
			SelectRow.WnoDate = jsonData.WnoDate;
			SelectRow.AspUomId = jsonData.PUomId;
			SelectRow.AspUomDesc = jsonData.PUomDesc;
			// 20180912默认上一行调价原因
			if (AdjSpParamObj.DefaAspReason == 'Y') {
				var rowCount = AdjPriceGrid.getRows().length;
				if (rowCount > 1) {
					var rows = AdjPriceGrid.getRows();
					var tmpAdjReasonId = rows[rowCount - 2]['AdjReasonId'];
					var tmpAdjReason = rows[rowCount - 2]['AdjReason'];
					SelectRow.AdjReasonId = tmpAdjReasonId;
					SelectRow.AdjReason = tmpAdjReason;
				}
			}
			SelectRow.DiffSpUom = 0;
			SelectRow.DiffRpUom = 0;
			SelectRow.AdjSPCat = '手动调价';
			var Today = DateFormatter(new Date());
			var Tomorrow = DateFormatter(DateAdd(new Date(), 'd', 1));
			SelectRow.AdjDate = Today;
			SelectRow.PreExecuteDate = Tomorrow;
			setTimeout(function() {
				AdjPriceGrid.refreshRow();
				AdjPriceGrid.startEditingNext('InciDesc');
			}, 50);
		});
	};
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query(AspIdStr) {
		if (AspIdStr == undefined) {
			AspIdStr = '';
		}
		var ParamsObj = $UI.loopBlock('Conditions');
		ParamsObj = jQuery.extend(true, ParamsObj, {
			Status: 'No',
			AspIdStr: AspIdStr
		});
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
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
		AdjPriceGrid.load({
			ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
			QueryName: 'QueryAspInfo',
			query2JsonStrict: 1,
			Params: Params,
			rows: 99999
		});
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			ClearMain();
		}
	});
	var ClearMain = function() {
		$UI.clearBlock('#Conditions');
		$UI.clear(AdjPriceGrid);
		SetDefaValues();
	};
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			if (CheckBeforeSave()) {
				Save();
			}
		}
	});
	
	function CheckBeforeSave() {
		if (!AdjPriceGrid.endEditing()) {
			return false;
		}
		var RowsData = AdjPriceGrid.getRows();
		for (var i = 0; i < RowsData.length; i++) {
			var ResultSp = parseFloat(RowsData[i].ResultSpUom);
			var ResultRp = parseFloat(RowsData[i].ResultRpUom);
			var PreExecuteDate = RowsData[i].PreExecuteDate;
			var InciDesc = RowsData[i].InciDesc;
			var AdjReasonId = RowsData[i].AdjReasonId;
			var Inci = RowsData[i].Inci;
			var row = i + 1;
			if (ResultSp == null || ResultSp <= 0) {
				$UI.msg('alert', '第' + row + '行' + InciDesc + '调后售价不能小于或等于0!');
				return false;
			}
			if (PreExecuteDate == null) {
				$UI.msg('alert', '第' + row + '行' + InciDesc + '计划生效日期不能为空!');
				return false;
			}
			if (Number(ResultSp) < Number(ResultRp)) {
				$UI.msg('alert', '第' + row + '行' + InciDesc + '调后售价不能小于调后进价');
				return false;
			}
			var Today = DateFormatter(new Date());
			if (PreExecuteDate <= Today) {
				$UI.msg('alert', '第' + row + '行' + InciDesc + '计划生效日期不能小于或等于当前日期!');
				return false;
			}
			if ((AdjSpParamObj.AllowSaveReasonEmpty != 'Y') && (isEmpty(AdjReasonId))) {
				$UI.msg('alert', '第' + row + '行' + InciDesc + '调价原因不能为空!');
				return false;
			}
			var TodayAdjFlag = tkMakeServerCall('web.DHCSTMHUI.INAdjSalePrice', 'CheckItmAspToday', Inci, gHospId);
			if (TodayAdjFlag == 1) {
				if (!confirm('第' + row + '行' + InciDesc + '存在当天已生效调价单,是否继续?')) {
					return false;
				}
			}
		}
		return true;
	}
	var Save = function() {
		var MainObj = $UI.loopBlock('#Conditions');
		var Main = JSON.stringify(MainObj);
		var Detail = AdjPriceGrid.getChangesData('Inci');
		if (Detail === false) {
			return;
		} // 验证未通过  不能保存
		if (isEmpty(Detail)) {
			$UI.msg('alert', '没有需要保存的调价信息!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
			MethodName: 'Save',
			Main: Main,
			Detail: JSON.stringify(Detail)
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				var AspIdStr = jsonData.rowid;
				Query(AspIdStr);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	};
	var AdjPriceCm = [[
		{
			field: 'check',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '调价单号',
			field: 'AspNo',
			width: 150
		}, {
			title: '物资RowId',
			field: 'Inci',
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 150,
			editor: InciEditor(HandlerParams, SelectRow)
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '调价单位',
			field: 'AspUomId',
			width: 80,
			formatter: CommonFormatter(UomCombox, 'AspUomId', 'AspUomDesc'),
			editor: UomCombox
		}, {
			title: '调价原因',
			field: 'AdjReasonId',
			width: 120,
			align: 'left',
			formatter: CommonFormatter(AdjReasonCombox, 'AdjReasonId', 'AdjReason'),
			editor: AdjReasonCombox
		}, {
			title: 'BUomId',
			field: 'BUomId',
			width: 100,
			hidden: true
		}, {
			title: 'ConFacPur',
			field: 'ConFacPur',
			width: 100,
			hidden: true
		}, {
			title: '调前售价',
			field: 'PriorSpUom',
			width: 80,
			align: 'right'
		}, {
			title: '调前进价',
			field: 'PriorRpUom',
			width: 80,
			align: 'right'
		}, {
			title: '调后进价',
			field: 'ResultRpUom',
			width: 80,
			align: 'right',
			editor: ((AdjSpParamObj.AllowAdjRp == 'Y') && (sssAspType != 'SP')) ? {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					min: 0,
					precision: GetFmtNum('FmtRA'),
					onChange: function() {
						if ((AdjSpParamObj.CalSpByMarkType == 1) && (sssAspType != 'RP')) {
							ChangeSp(this);
						}
					}
				}
			}
				: {
					type: 'numberbox',
					options: {
						disabled: true,
						min: 0,
						precision: GetFmtNum('FmtRA')
					}
				}
		}, {
			title: '调后售价',
			field: 'ResultSpUom',
			width: 80,
			align: 'right',
			editor: ((AdjSpParamObj.AllowAdjSp == 'Y') && (sssAspType != 'RP')) ? {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					min: 0,
					precision: GetFmtNum('FmtSA')
				}
			}
				: {
					type: 'numberbox',
					options: {
						disabled: true,
						min: 0,
						precision: GetFmtNum('FmtSA')
					}
				}
		}, {
			title: '当前加成',
			field: 'MarginNow',
			width: 80,
			align: 'right'
		}, {
			title: '差价(售价)',
			field: 'DiffSpUom',
			width: 80,
			align: 'right'
		}, {
			title: '差价(进价)',
			field: 'DiffRpUom',
			width: 80,
			align: 'right'
		}, {
			title: '计划生效日期',
			field: 'PreExecuteDate',
			width: 120,
			align: 'left',
			editor: {
				type: 'datebox'
			}
		}, {
			title: '制单日期',
			field: 'AdjDate',
			width: 100,
			align: 'left'
		}, {
			title: '实际生效日期',
			field: 'ExecuteDate',
			width: 100,
			align: 'left'
		}, {
			title: '定价类型',
			field: 'MarkTypeDesc',
			width: 120,
			align: 'left'
		}, {
			title: '物价文件号',
			field: 'WarrentNo',
			width: 120,
			align: 'left',
			editor: {
				type: 'text'
			}
		}, {
			title: '物价文件日期',
			field: 'WnoDate',
			width: 120,
			align: 'left',
			editor: {
				type: 'datebox'
			}
		}, {
			title: '调价人',
			field: 'AdjUserName',
			width: 80,
			align: 'left'
		}, {
			title: '库存分类',
			field: 'StkCatDesc',
			width: 100,
			align: 'left'
		}, {
			title: '调价类型',
			field: 'AdjSPCat',
			width: 80,
			align: 'left' //, hidden: true
		}
	]];
	var AdjPriceGrid = $UI.datagrid('#AdjPriceGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
			QueryName: 'QueryAspInfo',
			query2JsonStrict: 1,
			rows: 99999
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
			MethodName: 'jsDelete'
		},
		columns: AdjPriceCm,
		singleSelect: false,
		checkField: 'Inci',
		sortName: 'RowId',
		sortOrder: 'Desc',
		showBar: true,
		remoteSort: false,
		pagination: false,
		showAddDelItems: true,
		onEndEdit: function(index, row, changes) {
			var Editors = $(this).datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
				if (Editor.field == 'ResultRpUom') {
					var ResultRpUom = row.ResultRpUom;
					if (isEmpty(ResultRpUom)) {
						$UI.msg('alert', '进价不能为空!');
						AdjPriceGrid.checked = false;
						return false;
					} else if (ResultRpUom < 0) {
						$UI.msg('alert', '进价不能小于0!');
						AdjPriceGrid.checked = false;
						return false;
					}
					if ((AdjSpParamObj.CalSpByMarkType == 1) && (sssAspType != 'RP')) {
						var Inci = row.Inci;
						var AspUomId = row.AspUomId;
						var Sp = tkMakeServerCall('web.DHCSTMHUI.Common.PriceCommon', 'GetMtSp', Inci, AspUomId, ResultRpUom);
						if (Sp == 0) {
							$UI.msg('alert', '调后售价为0，请检查该物资定价类型是否正确!');
							AdjPriceGrid.checked = false;
							return false;
						}
						row.ResultSpUom = Sp;
					}
					var ResultSpUom = row.ResultSpUom;
					var PriorRpUom = row.PriorRpUom;
					row.MarginNow = accDiv(ResultSpUom, ResultRpUom);
					row.DiffRpUom = accSub(ResultRpUom, PriorRpUom);
				} else if (Editor.field == 'ResultSpUom') {
					var ResultSpUom = row.ResultSpUom;
					var ResultRpUom = row.ResultRpUom;
					var PriorSpUom = row.PriorSpUom;
					if (ResultSpUom < 0) {
						$UI.msg('alert', '售价不能小于0!');
						AdjPriceGrid.checked = false;
						return false;
					}
					var PriorRpUom = row.PriorRpUom;
					row.MarginNow = accDiv(ResultSpUom, ResultRpUom);
					row.DiffSpUom = accSub(ResultSpUom, PriorSpUom);
				} else if (Editor.field == 'PreExecuteDate') {
					var PreDate = row.PreExecuteDate;
					var NowDate = DateFormatter(new Date());
					if ((!isEmpty(PreDate)) && (FormatDate(NowDate) >= FormatDate(PreDate))) {
						$UI.msg('alert', '计划生效日期不能小于或等于当前日期!');
						AdjPriceGrid.checked = false;
						return false;
					}
				} else if (Editor.field == 'InciDesc') {
					var Inci = row.Inci;
					var InpurRows = AdjPriceGrid.getRows();
					$.each(InpurRows, function(tindex, trow) {
						var tmpInci = trow['Inci'];
						var tmpInciDesc = trow['InciDesc'];
						if ((tmpInci == Inci) && (index != tindex)) {
							$UI.msg('alert', tmpInciDesc + '重复录入');
							AdjPriceGrid.checked = false;
							return false;
						}
					});
				}
			}
		},
		onClickRow: function(index, row) {
			AdjPriceGrid.commonClickRow(index, row);
		}
	});
	function ChangeSp(r) {
		var tr = $(r).closest('tr.datagrid-row');
		var rowindex = parseInt(tr.attr('datagrid-row-index'));
		var Rows = $('#AdjPriceGrid').datagrid('getRows')[rowindex];
		var Inci = Rows.Inci;
		var AspUomId = Rows.AspUomId;
		var Rp = Rows.ResultRpUom;
		var Sp = 0;
		var editors = $('#AdjPriceGrid').datagrid('getEditors', rowindex);
		for (var i = 0; i < editors.length; i++) {
			var editor = editors[i];
			if (editor.field == 'ResultRpUom') {
				Rp = $(editor.target).numberbox('getValue');
				Sp = tkMakeServerCall('web.DHCSTMHUI.Common.PriceCommon', 'GetMtSp', Inci, AspUomId, Rp);
			}
			if (editor.field == 'ResultSpUom') {
				$(editor.target).val(Sp);
			}
		}
	}
	// 设置缺省值
	function SetDefaValues() {
		var Today = DateFormatter(new Date());
		$('#StartDate').datebox('setValue', Today);
		$('#EndDate').datebox('setValue', Today);
		$('#ScgId').combotree('options')['setDefaultFun']();
	}
	ClearMain();
};
$(init);