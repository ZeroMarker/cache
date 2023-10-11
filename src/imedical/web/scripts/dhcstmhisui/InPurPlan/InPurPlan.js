var ReqTemplateFlag = false;
var init = function() {
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			FindWin(Select);
		}
	});
	var Select = function(PurId) {
		$UI.clearBlock('#MainConditions');
		$UI.clear(PurGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPurPlan',
			MethodName: 'Select',
			PurId: PurId
		},
		function(jsonData) {
			$UI.fillBlock('#MainConditions', jsonData);
			if ($HUI.checkbox('#CompFlag').getValue() == false) {
				setUnComp();
			} else {
				setComp();
			}
		});
		PurGrid.load({
			ClassName: 'web.DHCSTMHUI.INPurPlanItm',
			QueryName: 'Query',
			query2JsonStrict: 1,
			PurId: PurId,
			rows: 99999,
			totalFooter: '"InciDesc":"合计"',
			totalFields: 'RpAmt'
		});
	};
	// 设置可编辑组件的disabled属性
	function setUnComp() {
		$HUI.combobox('#PurLoc').disable();
		$HUI.combobox('#StkScg').disable();
		ChangeButtonEnable({ '#AddBT': true, '#DelBT': true, '#ComBT': true, '#CanComBT': false });
	}
	function setComp() {
		$HUI.combobox('#PurLoc').disable();
		$HUI.combobox('#StkScg').disable();
		ChangeButtonEnable({ '#AddBT': false, '#DelBT': false, '#ComBT': false, '#CanComBT': true });
	}
	function DefaultClear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(PurGrid);
		$('#File').filebox('clear');
		$HUI.combobox('#PurLoc').enable();
		$HUI.combobox('#StkScg').enable();
		ChangeButtonEnable({ '#AddBT': true, '#DelBT': true, '#ComBT': true, '#CanComBT': false });
		Default();
	}
	
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			Save();
		}
	});
	function Save() {
		if (savecheck() == true) {
			var MainObj = $UI.loopBlock('#MainConditions');
			var Main = JSON.stringify(MainObj);
			var IsChange = $UI.isChangeBlock('#MainConditions');
			
			var RowId = $('#RowId').val();
			if (ReqTemplateFlag && isEmpty(RowId)) {
				// 按模板制单
				var DetailObj = PurGrid.getRowsData();
			} else {
				var DetailObj = PurGrid.getChangesData('InciId');
			}
			if (DetailObj === false) {
				return;
			} else if (DetailObj.length == 0 && IsChange == false) {
				$UI.msg('alert', '没有需要保存的内容!');
				return;
			}
			var CheckMsgArr = [];
			var InpurRows = PurGrid.getRows();
			for (var i = 0; i < InpurRows.length; i++) {
				var InpurRow = InpurRows[i];
				var Inci = InpurRow.InciId;
				var InciDesc = InpurRow.InciDesc;
				var SpecDesc = InpurRow.SpecDesc;
				var RowIndex = $('#PurGrid').datagrid('getRowIndex', InpurRow);
				$.each(InpurRows, function(index, row) {
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
			var Detail = JSON.stringify(DetailObj);
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.INPurPlan',
				MethodName: 'Save',
				Main: Main,
				Detail: Detail
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Select(jsonData.rowid);
					ReqTemplateFlag = false;
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	}
	// 数据检查
	function savecheck() {
		if (!PurGrid.endEditing()) {
			return false;
		}
		if ($HUI.checkbox('#CompFlag').getValue() == true) {
			$UI.msg('alert', '已经完成，不能保存!');
			return false;
		}
		var rowsData = PurGrid.getRows();
		for (var i = 0; i < rowsData.length; i++) {
			var row = rowsData[i];
			var InciId = row.InciId;
			var UomId = row.UomId;
			var vendorId = row.VendorId;
			if ((UomId == '') && (InciId != '')) {
				$UI.msg('alert', '第' + (i + 1) + '行单位为空');
				return false;
			}
			if (InciId != '' && vendorId == '' && InPurPlanParamObj.VendorNeeded != 'N') {
				$UI.msg('alert', '第' + (i + 1) + '行供应商为空');
				return false;
			}
		}
		return true;
	}
	$UI.linkbutton('#DelBT', {
		onClick: function() {
			var PurId = $('#RowId').val();
			if (isEmpty(PurId)) {
				$UI.msg('alert', '请选择要删除的采购计划单');
				return;
			}
			$UI.confirm('确定要删除吗', 'warning', '', Delete, '', '', '警告', false);
		}
	});
	function Delete() {
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPurPlan',
			MethodName: 'jsDelete',
			PurId: $('#RowId').val()
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
	$UI.linkbutton('#ComBT', {
		onClick: function() {
			var PurId = $('#RowId').val();
			if (isEmpty(PurId)) {
				$UI.msg('alert', '请选择要完成的采购计划单');
				return;
			}
			var Detail = PurGrid.getChangesData();
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
			ClassName: 'web.DHCSTMHUI.INPurPlan',
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
			var PurId = $('#RowId').val();
			if (isEmpty(PurId)) {
				$UI.msg('alert', '请选择要取消完成的采购计划单');
				return;
			}
			var MainObj = $UI.loopBlock('#MainConditions');
			var Main = JSON.stringify(MainObj);
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.INPurPlan',
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
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			DefaultClear();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var PurId = $('#RowId').val();
			if (isEmpty(PurId)) {
				$UI.msg('alert', '请选择要打印的采购计划单');
				return;
			}
			PrintInPurPlan(PurId);
		}
	});
	
	$UI.linkbutton('#MouldBT', {
		onClick: function() {
			InPurPlanMouldWin(Select, MouldSelect);
		}
	});
	
	function MouldSelect(PurId, InppiIdStr) {
		DefaultClear();
		ReqTemplateFlag = true;
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPurPlan',
			MethodName: 'Select',
			PurId: PurId
		}, function(jsonData) {
			$('#PurLoc').combobox('setValue', jsonData['PurLoc']);
			$('#StkScg').combotree('setValue', jsonData['StkScg']);
		});
		var ParamsObj = { InppiIdStr: InppiIdStr };
		var Params = JSON.stringify(ParamsObj);
		PurGrid.load({
			ClassName: 'web.DHCSTMHUI.INPurPlanItm',
			QueryName: 'Query',
			query2JsonStrict: 1,
			PurId: PurId,
			Params: Params,
			rows: 99999,
			totalFooter: '"InciDesc":"合计"',
			totalFields: 'RpAmt'
		});
	}
	function ImportExcelFN() {
		var wb;
		var filelist = $('#File').filebox('files');
		if (filelist.length == 0) {
			$UI.msg('alert', '请选择要导入的Excel!');
			return;
		}
		showMask();
		var file = filelist[0];
		var reader = new FileReader();
		reader.onload = function(e) {
			if (reader.result) {
				reader.content = reader.result;
			}
			var data = e ? e.target.result : reader.content;
			wb = XLSX.read(data, {
				type: 'binary'
			});
			var json = to_json(wb);
			$('#PurGrid').datagrid('loadData', json);
			ReqTemplateFlag = true;
			hideMask();
		};
		reader.readAsBinaryString(file);
	}
	function to_json(workbook) {
		var jsonData = {};
		var sheet2JSONOpts = {
			defval: ''		// 格子为空时的默认值
		};
		var result = XLSX.utils.sheet_to_json(workbook.Sheets[workbook.SheetNames[0]], sheet2JSONOpts);
		result = result.slice(1);
		for (var i = 0; i < result.length; i++) {
			var InciCode = result[i].InciCode;
			var Manf = result[i].ManfDesc;
			var UomDesc = result[i].UomDesc;
			var Rp = result[i].Rp;
			var Hospital = result[i].Hospital;
			var Vendor = result[i].VendorDesc;
			if (InciCode != '') {
				var Str = tkMakeServerCall('web.DHCSTMHUI.INPurPlan', 'GetInciMsg', InciCode, Manf, Vendor, UomDesc, Hospital);
				result[i].InciId = Str.split('^')[0];
				result[i].ManfId = Str.split('^')[1];
				result[i].UomId = Str.split('^')[2];
				result[i].Spec = Str.split('^')[3];
				result[i].VendorId = Str.split('^')[4];
			}
			if (isEmpty(result[i].InciId)) {
				$UI.msg('alert', '第' + (i + 1) + '条记录物资代码相关信息不存在!');
				hideMask();
				return;
			}
		}
		jsonData.rows = result;
		jsonData.total = result.length;
		return jsonData;
	}
	
	function ExportExcel() {
		window.open('../scripts/dhcstmhisui/InPurPlan/采购单导入模板.xls', '_blank');
	}
	$('#File').filebox({
		prompt: '请选择要导入的Excel',
		accept: 'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
	});
	$UI.linkbutton('#ReadBT', {
		onClick: function() {
			$('#StkGrpId').combobox('clear');
			ImportExcelFN();
		}
	});
	$UI.linkbutton('#DownExcelTemplet', {
		onClick: function() {
			ExportExcel();
		}
	});
	/* --绑定控件--*/
	var PurLocBox = $HUI.combobox('#PurLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PurLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#StkScg').setFilterByLoc(LocId);
		}
	});
	
	/* --Grid列绑定--*/
	var HandlerParams = function() {
		var StkScg = $('#StkScg').combotree('getValue');
		var PurLoc = $('#PurLoc').combo('getValue');
		var Obj = { StkGrpRowId: StkScg, StkGrpType: 'M', Locdr: PurLoc, NotUseFlag: 'N', QtyFlag: '',
			ToLoc: '', ReqModeLimited: '', NoLocReq: '', HV: '', RequestNoStock: 'Y' };
		return Obj;
	};
	var SelectRow = function(row) {
		// 其他信息
		var purloc = $HUI.combobox('#PurLoc').getValue();
		var InciParams = JSON.stringify(addSessionParams({ PurLoc: purloc }));
		var Inci = row.InciDr;
		var InciDesc = row.InciDesc;
		var FindIndex = PurGrid.find('InciId', Inci);
		if (CodeMainParamObj.UseSpecList != 'Y' && FindIndex >= 0 && FindIndex != PurGrid.editIndex) {
			$UI.msg('alert', InciDesc + '已存在于第' + (FindIndex + 1) + '行!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPurPlan',
			MethodName: 'GetItmInfo',
			IncId: row.InciDr,
			Params: InciParams
		},
		function(jsonData) {
			/* PurGrid.updateRow({
				index:PurGrid.editIndex,
				row: {
					InciId:row.InciDr,
					InciCode:row.InciCode,
					InciDesc:row.InciDesc,
					Spec:jsonData.Spec,
					UomId:jsonData.PurUomId,
					UomDesc:jsonData.PurUomDesc,
					Rp:jsonData.Rp,
					Sp:jsonData.Sp,
					MinQty:jsonData.MinQty,
					MaxQty:jsonData.MaxQty,
					BUomId:jsonData.BUomId,
					ConFac:jsonData.Confac,
					VendorId:jsonData.VenId,
					VendorDesc:jsonData.VenDesc,
					ManfId:jsonData.ManfId,
					ManfDesc:jsonData.ManfDesc,
					CarrierId:jsonData.CarrierId,
					CarrierDesc:jsonData.CarrierDesc
				}
			});*/
			var Rows = PurGrid.getRows();
			var Row = Rows[PurGrid.editIndex];
			Row.InciId = row.InciDr;
			Row.InciCode = row.InciCode;
			Row.InciDesc = row.InciDesc;
			Row.Spec = jsonData.Spec;
			Row.UomId = jsonData.PurUomId;
			Row.UomDesc = jsonData.PurUomDesc;
			Row.Rp = jsonData.Rp;
			Row.Sp = jsonData.Sp;
			if (InPurPlanParamObj.DefaUom == 1) {
				Row.UomId = jsonData.BUomId;
				Row.UomDesc = jsonData.BUomDesc;
				Row.Rp = jsonData.BRp;
				Row.Sp = jsonData.BSp;
			}
			Row.MinQty = jsonData.MinQty;
			Row.MaxQty = jsonData.MaxQty;
			Row.BUomId = jsonData.BUomId;
			Row.ConFac = jsonData.Confac;
			Row.VendorId = jsonData.VenId;
			Row.VendorDesc = jsonData.VenDesc;
			Row.ManfId = jsonData.ManfId;
			Row.ManfDesc = jsonData.ManfDesc;
			Row.CarrierId = jsonData.CarrierId;
			Row.CarrierDesc = jsonData.CarrierDesc;
			setTimeout(function() {
				PurGrid.refreshRow();
				PurGrid.startEditingNext('InciDesc');
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
			mode: 'remote',
			editable: false,
			onBeforeLoad: function(param) {
				var rows = PurGrid.getRows();
				var row = rows[PurGrid.editIndex];
				if (!isEmpty(row)) {
					param.Inci = row.InciId;
				}
			},
			onSelect: function(record) {
				var rows = PurGrid.getRows();
				var row = rows[PurGrid.editIndex];
				var seluom = record.RowId;
				var rp = row.Rp;
				var sp = row.Sp;
				var buom = row.BUomId;
				var confac = row.ConFac;
				var uom = row.UomId; // 旧单位
				if (seluom != uom) {
					if (seluom != buom) {		// 原单位是基本单位，目前选择的是入库单位
						Rp = Number(rp).mul(confac);
						Sp = Number(sp).mul(confac);
					} else {					// 目前选择的是基本单位，原单位是入库单位
						Rp = Number(rp).div(confac);
						Sp = Number(sp).div(confac);
					}
				}
				row.UomDesc = record.Description;
				row.UomId = record.RowId;
				row.Rp = Rp;
				row.Sp = Sp;
				setTimeout(function() {
					PurGrid.refreshRow();
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
				var Select = PurGrid.getSelected();
				if (!isEmpty(Select)) {
					param.Inci = Select.InciId;
				}
			}
		}
	};
	var VendorCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = PurGrid.getRows();
				var row = rows[PurGrid.editIndex];
				row.VendorDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	var ManfCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = PurGrid.getRows();
				var row = rows[PurGrid.editIndex];
				row.ManfDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	var CarrierCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCarrier&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = PurGrid.getRows();
				var row = rows[PurGrid.editIndex];
				row.CarrierDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	var ReqLocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PurLocParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = PurGrid.getRows();
				var row = rows[PurGrid.editIndex];
				row.ReqLocDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	
	var PurCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 60,
			saveCol: true,
			hidden: true
		}, {
			title: '物资RowId',
			field: 'InciId',
			width: 60,
			saveCol: true,
			hidden: true
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
			title: '具体规格',
			field: 'SpecDesc',
			width: 100,
			saveCol: CodeMainParamObj.UseSpecList == 'Y' ? true : false,
			formatter: CommonFormatter(SpecDescbox, 'SpecDesc', 'SpecDesc'),
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true,
			editor: (CodeMainParamObj.UseSpecList == 'Y' ? false : true) ? null : SpecDescbox
		}, {
			title: '采购数量',
			field: 'Qty',
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
			title: '购入金额',
			field: 'RpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '供应商',
			field: 'VendorId',
			width: 100,
			saveCol: true,
			formatter: CommonFormatter(VendorCombox, 'VendorId', 'VendorDesc'),
			editor: VendorCombox
		}, {
			title: '配送商',
			field: 'CarrierId',
			width: 100,
			saveCol: true,
			formatter: CommonFormatter(CarrierCombox, 'CarrierId', 'CarrierDesc'),
			editor: CarrierCombox
		}, {
			title: '生产厂家',
			field: 'ManfId',
			width: 100,
			saveCol: true,
			formatter: CommonFormatter(ManfCombox, 'ManfId', 'ManfDesc'),
			editor: ManfCombox
		}, {
			title: '要求送货日期',
			field: 'DateNeeded',
			width: 120,
			saveCol: true,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '库存下限',
			field: 'MinQty',
			width: 80,
			align: 'right'
		}, {
			title: '库存上限',
			field: 'MaxQty',
			width: 80,
			align: 'right'
		}, {
			title: '本科室数量',
			field: 'LocQty',
			width: 80,
			align: 'right'
		}, {
			title: '本科室可用数量',
			field: 'LocAvaQty',
			width: 80,
			align: 'right'
		}, {
			title: '请求科室',
			field: 'ReqLocId',
			width: 100,
			saveCol: true,
			formatter: CommonFormatter(ReqLocCombox, 'ReqLocId', 'ReqLocDesc'),
			editor: ReqLocCombox
		}, {
			title: '请求数量',
			field: 'ReqQty',
			width: 80,
			align: 'right'
		}, {
			title: '已转移数量',
			field: 'TrfQty',
			width: 80,
			align: 'right'
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
	
	var PurGrid = $UI.datagrid('#PurGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPurPlanItm',
			QueryName: 'Query',
			query2JsonStrict: 1,
			rows: 99999,
			totalFooter: '"InciDesc":"合计"',
			totalFields: 'RpAmt'
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.INPurPlanItm',
			MethodName: 'jsDelete'
		},
		columns: PurCm,
		checkField: 'InciId',
		showAddDelItems: true,
		remoteSort: false,
		showBar: true,
		showFooter: true,
		pagination: false,
		singleSelect: false,
		onClickRow: function(index, row) {
			PurGrid.commonClickRow(index, row);
		},
		onBeforeEdit: function(index, row) {
			if ($HUI.checkbox('#CompFlag').getValue()) {
				return false;
			}
		},
		beforeAddFn: function() {
			if ($HUI.checkbox('#CompFlag').getValue() == true) {
				$UI.msg('alert', '已经完成，不能增加一行');
				return false;
			}
			if (isEmpty($HUI.combobox('#PurLoc').getValue())) {
				$UI.msg('alert', '采购科室不能为空');
				return false;
			}
			if (isEmpty($HUI.combobox('#StkScg').getValue())) {
				$UI.msg('alert', '类组不能为空');
				return false;
			}
			setUnComp();
		},
		onLoadSuccess: function(data) {
			var RowId = $('#RowId').val();
			if (isEmpty(RowId)) {
				for (var i = 0; i < data.rows.length; i++) {
					$(this).datagrid('updateRow', {
						index: i,
						row: { RowId: '' }
					});
				}
			}
		},
		onEndEdit: function(index, row, changes) {
			// 判断资质
			var CheckCertObj = addSessionParams({
				Manf: row.ManfId,
				Inci: row.IncId,
				Vendor: row.VendorId
			});
			var CheckCertRet = Common_CheckCert(CheckCertObj, 'Warn');
			if (!CheckCertRet) {
				PurGrid.checked = false;
				return false;
			}
			var Editors = $(this).datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
				if (Editor.field == 'SpecDesc') {
					var SpecDesc = row.SpecDesc;
					var InciDesc = row.InciDesc;
					var Inci = row.InciId;
					var InpurRows = PurGrid.getRows();
					$.each(InpurRows, function(tindex, trow) {
						var tmpInci = trow['InciId'];
						var tmpInciDesc = trow['InciDesc'];
						var tmpSpecDesc = trow['SpecDesc'];
						if ((tmpInci == Inci) && (tmpSpecDesc == SpecDesc) && index != tindex) {
							$UI.msg('alert', tmpInciDesc + '具体规格:[' + tmpSpecDesc + ']重复录入');
							PurGrid.checked = false;
							return false;
						}
					});
				}
			}
		}
	});
	
	var Default = function() {
		// /设置初始值 考虑使用配置
		var DefaultValue = {
			RowId: '',
			PurLoc: gLocObj
		};
		$UI.fillBlock('#MainConditions', DefaultValue);
		$('#StkScg').combotree('options')['setDefaultFun']();
	};
	Default();
	if (gPurId > 0) {
		Select(gPurId);
	}
};
$(init);
if (!FileReader.prototype.readAsBinaryString) {
	console.log('readAsBinaryString definition not found');
	FileReader.prototype.readAsBinaryString = function(fileData) {
		var binary = '';
		var pk = this;
		var reader = new FileReader();
		reader.onload = function(e) {
			var bytes = new Uint8Array(reader.result);
			var length = bytes.byteLength;
			for (var i = 0; i < length; i++) {
				var a = bytes[i];
				var b = String.fromCharCode(a);
				binary += b;
			}
			pk.content = binary;
			$(pk).trigger('onload');
		};
		reader.readAsArrayBuffer(fileData);
	};
}