// /科室库存管理
var init = function() {
	var HospId = '';
	function InitHosp() {
		var hospComp = InitHospCombo('CT_Loc', gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				$UI.clearBlock('#MainConditions');
				$HUI.combotree('#StkGrpId').load(HospId);
				Query();
			};
		} else {
			HospId = gHospId;
		}
	}
	var clear = function() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(ItmLocGrid);
		DefaultData();
		InitHosp();
	};

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			clear();
		}
	});
	$UI.linkbutton('#CreateLimits', {
		onClick: function() {
			CreateLimit(Query, $('#ItmLoc').combo('getValue'));
		}
	});
	var HandlerParams = function() {
		var ScgId = $('#StkGrpId').combotree('getValue');
		var FrLoc = $('#ItmLoc').combo('getValue');
		var Obj = { StkGrpRowId: ScgId, StkGrpType: 'M', Locdr: FrLoc, BDPHospital: HospId };
		return Obj;
	};
	$('#Incidesc').lookup(InciLookUpOp(HandlerParams, '#Incidesc', '#Inci'));
	
	// 科室
	var ItmLocBox = $HUI.combobox('#ItmLoc', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ItmLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#StkGrpId').setFilterByLoc(LocId);
		},
		onChange: function(newValue, oldValue) {
			StkBinReasonBox.clear();
			var StkBinReasonParams = JSON.stringify(addSessionParams({
				LocDr: newValue,
				BDPHospital: HospId
			}));
			var Params = JSON.stringify(addSessionParams({
				BDPHospital: HospId
			}));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocStkBin&ResultSetType=array&Params=' + StkBinReasonParams;
			StkBinReasonBox.reload(url);
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocManGrp&ResultSetType=array&LocId=' + newValue + '&Params=' + Params;
			LocMarReasonBox.reload(url);
		},
		onShowPanel: function() {
			ItmLocBox.clear();
			var ItmLocParams = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: HospId }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ItmLocParams;
			ItmLocBox.reload(url);
		}
	});
	// 货位
	var StkBinReasonBox = $HUI.combobox('#StkBinReasonId', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocStkBin&ResultSetType=array&Params=' + StkBinReasonParams,
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			StkBinReasonBox.clear();
			var locid = $HUI.combobox('#ItmLoc').getValue();
			var StkBinReasonParams = JSON.stringify(addSessionParams({ LocDr: locid, BDPHospital: HospId }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocStkBin&ResultSetType=array&Params=' + StkBinReasonParams;
			StkBinReasonBox.reload(url);
		}
	});
	// 管理组
	var LocMarReasonBox = $HUI.combobox('#LocMarReasonId', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocManGrp&ResultSetType=array&LocId=' + gLocId,
		valueField: 'RowId',
		textField: 'Description',
		multiple: true,
		selectOnNavigation: false,
		panelHeight: 'auto',
		editable: true,
		formatter: function(row) {
			var opts;
			if (row.selected == true) {
				opts = row.Description + "<span id='i" + row.RowId + "' class='icon icon-ok'></span>";
			} else {
				opts = row.Description + "<span id='i" + row.RowId + "' class='icon'></span>";
			}
			return opts;
		},
		onSelect: function(rec) {
			var obji = document.getElementById('i' + rec.RowId);
			$(obji).addClass('icon-ok');
		},
		onUnselect: function(rec) {
			var obji = document.getElementById('i' + rec.RowId);
			$(obji).removeClass('icon-ok');
		},
		onShowPanel: function() {
			LocMarReasonBox.clear();
			var locid = $HUI.combobox('#ItmLoc').getValue();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocManGrp&ResultSetType=array&LocId=' + locid + '&Params=' + Params;
			LocMarReasonBox.reload(url);
		}
	});
	// 供给仓库
	/* var FrLocParams = JSON.stringify(addSessionParams({ Type: "All" }));
	var FrLocCombox = {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			data : function(){
				var ComboData = $.cm({
					ClassName: 'web.DHCSTMHUI.Common.Dicts',
					QueryName: 'GetCTLoc',
					ResultSetType: 'array',
					Params: FrLocParams
				}, false);
				return ComboData;
			}()
		}
	};*/
	var FrLocCombox = {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = ItmLocGrid.getRows();
				var row = rows[ItmLocGrid.editIndex];
				row.wareHouseDesc = record.Description;
			},
			onShowPanel: function() {
				var Params = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: HospId }));
				$(this).combobox('clear');
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params=' + Params;
				$(this).combobox('reload', url);
			}
		}
	};

	// 货位码
	var stkbinReasonBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocStkBin&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			// required: true,
			mode: 'remote',
			onBeforeLoad: function(param) {
				var rows = ItmLocGrid.getRows();
				var row = rows[ItmLocGrid.editIndex];
				if (!isEmpty(row)) {
					param.Params = JSON.stringify(addSessionParams({ LocDr: $('#ItmLoc').combo('getValue'), BDPHospital: HospId }));
				}
			},
			onSelect: function(record) {
				var rows = ItmLocGrid.getRows();
				var row = rows[ItmLocGrid.editIndex];
				row.incsbDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('clear');
				$(this).combobox('reload');
			}
		}
	};
	// 管理组
	var locmarReasonBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocManGrp&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			mode: 'remote',
			onBeforeLoad: function(param) {
				var rows = ItmLocGrid.getRows();
				var row = rows[ItmLocGrid.editIndex];
				if (!isEmpty(row)) {
					param.LocId = $('#ItmLoc').combo('getValue');
				}
			},
			onSelect: function(record) {
				var rows = ItmLocGrid.getRows();
				var row = rows[ItmLocGrid.editIndex];
				row.inciLmgDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	$HUI.combobox('#TransType', {
		data: [
			{ 'RowId': 'MP', 'Description': '住院消耗' },
			{ 'RowId': 'MF', 'Description': '门诊消耗' },
			{ 'RowId': 'T', 'Description': '转出' },
			{ 'RowId': 'MY', 'Description': '住院退回' },
			{ 'RowId': 'MH', 'Description': '门诊退回' },
			{ 'RowId': 'K', 'Description': '转入' }
		],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ItmLocGridCm = [[
		{	title: '货位码打印',
			field: 'ck',
			width: 80,
			checkbox: true
		}, {
			title: 'incil',
			field: 'incil',
			saveCol: true,
			width: 80,
			hidden: true
		}, {
			title: 'inci',
			field: 'inci',
			width: 150,
			hidden: true
		}, {
			title: '代码',
			field: 'code',
			width: 100
		}, {
			title: '物资名称',
			field: 'desc',
			editor: {
				type: 'validatebox',
				options: {
					required: true,
					tipPosition: 'bottom'
				}
			},
			width: 180
		}, {
			title: '规格',
			field: 'spec',
			width: 100
		}, {
			title: '生产厂家',
			field: 'manf',
			width: 200
		}, {
			title: '基本单位',
			field: 'bUomDesc',
			width: 80
		}, {
			title: '包装单位',
			field: 'pUomDesc',
			width: 80
		}, {
			title: '库存上限',
			field: 'maxQty',
			width: 100,
			align: 'right',
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			},
			sorter: function(a, b) {
				var number1 = parseFloat(a);
				var number2 = parseFloat(b);
				return (number1 > number2 ? 1 : -1);
			}
		}, {
			title: '库存下限',
			field: 'minQty',
			width: 100,
			align: 'right',
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			},
			sorter: function(a, b) {
				var number1 = parseFloat(a);
				var number2 = parseFloat(b);
				return (number1 > number2 ? 1 : -1);
			}
		}, {
			title: '库存',
			field: 'stkQty',
			width: 80,
			align: 'right',
			saveCol: true,
			sorter: function(a, b) {
				var number1 = parseFloat(a);
				var number2 = parseFloat(b);
				return (number1 > number2 ? 1 : -1);
			}
		}, {
			title: '可用库存',
			field: 'avaQty',
			width: 80,
			align: 'right',
			corlor: 'bule',
			saveCol: true,
			sorter: function(a, b) {
				var number1 = parseFloat(a);
				var number2 = parseFloat(b);
				return (number1 > number2 ? 1 : -1);
			}
		}, {
			title: '标准库存',
			field: 'repQty',
			width: 100,
			align: 'right',
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			},
			sorter: function(a, b) {
				var number1 = parseFloat(a);
				var number2 = parseFloat(b);
				return (number1 > number2 ? 1 : -1);
			}
		}, {
			title: '请求基数',
			field: 'repLev',
			width: 100,
			align: 'right',
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			},
			sorter: function(a, b) {
				var number1 = parseFloat(a);
				var number2 = parseFloat(b);
				return (number1 > number2 ? 1 : -1);
			}
		}, {
			title: '采购基数',
			field: 'PurBasQty',
			width: 100,
			align: 'right',
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			}
		}, {
			title: '货位',
			field: 'incsb',
			width: 80,
			formatter: CommonFormatter(stkbinReasonBox, 'incsb', 'incsbDesc'),
			saveCol: true,
			editor: stkbinReasonBox
		}, {
			title: '备用货位',
			field: 'spStkBin',
			width: 100,
			saveCol: true,
			align: 'right',
			editor: {
				type: 'text'
			}
		}, {
			title: '加锁标志',
			field: 'ChkLockFlag',
			width: 100,
			saveCol: true,
			formatter: BoolFormatter,
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			align: 'center'
		}, {
			title: '管理组',
			field: 'inciLmg',
			width: 80,
			saveCol: true,
			formatter: CommonFormatter(locmarReasonBox, 'inciLmg', 'inciLmgDesc'),
			editor: locmarReasonBox
		}, {
			title: '供给仓库',
			field: 'wareHouse',
			width: 80,
			saveCol: true,
			formatter: CommonFormatter(FrLocCombox, 'wareHouse', 'wareHouseDesc'),
			editor: FrLocCombox
		}, {
			title: '零库存标志',
			field: 'ZeroStkFlag',
			width: 100,
			saveCol: true,
			formatter: BoolFormatter,
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			align: 'center'
		}
	]];
	function Query() {
		$UI.clear(ItmLocGrid);
		var ParamsObj = $UI.loopBlock('#MainConditions');
		if (isEmpty(ParamsObj.ItmLoc)) {
			$UI.msg('alert', '科室不能为空!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		ItmLocGrid.load({
			ClassName: 'web.DHCSTMHUI.INCItmLoc',
			QueryName: 'DHCSTLocItm',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	var ItmLocGrid = $UI.datagrid('#ItmLocGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INCItmLoc',
			QueryName: 'DHCSTLocItm',
			query2JsonStrict: 1
		},
		columns: ItmLocGridCm,
		remoteSort: false,
		showBar: true,
		singleSelect: false,
		onClickRow: function(index, row) {
			ItmLocGrid.commonClickRow(index, row);
		},
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var MainObj = $UI.loopBlock('#MainConditions');
			var MainInfo = JSON.stringify(MainObj);
			var SelectedRow = ItmLocGrid.getSelected();
			if (isEmpty(SelectedRow)) {
				$UI.msg('error', '没有需要保存的明细');
				return;
			}
			var ListData = ItmLocGrid.getChangesData('incil');
			if (ListData === false) {	// 未完成编辑或明细为空
				return;
			}
			if (isEmpty(ListData)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			var RowsData = ItmLocGrid.getRows();
			// 有效行数
			var count = 0;
			var CheckMsgArr = [];
			for (var i = 0; i < RowsData.length; i++) {
				var RowData = RowsData[i];
				var maxQty = RowData['maxQty'];
				var minQty = RowData['minQty'];
				if ((!isEmpty(maxQty)) && (Number(maxQty) <= 0)) {
					var CheckMsg = '第' + (i + 1) + '行库存上限不能小于等于零';
					CheckMsgArr.push(CheckMsg);
				}
				if ((!isEmpty(minQty)) && (Number(minQty) <= 0)) {
					var CheckMsg = '第' + (i + 1) + '行库存下限不能小于等于零';
					CheckMsgArr.push(CheckMsg);
				}
				if ((!isEmpty(maxQty)) && (!isEmpty(minQty)) && (Number(maxQty) <= Number(minQty))) {
					var CheckMsg = '第' + (i + 1) + '行库存上限不能小于等于库存下限';
					CheckMsgArr.push(CheckMsg);
				}
			}
			if (!isEmpty(CheckMsgArr)) {
				$UI.msg('alert', CheckMsgArr.join());
				return false;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.INCItmLoc',
				MethodName: 'Save',
				ListData: JSON.stringify(ListData)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					ItmLocGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	// 打印按钮对应方法
	function LodopPrintBarcode(incil, Times) {
		if (Times == undefined) {
			Times = 1;
		}
		DHCP_GetXMLConfig('InvPrintEncrypt', 'DHCSTMSTB');
		var inpara = '';
		inpara = $.cm({ ClassName: 'web.DHCSTMHUI.INCItmLoc', MethodName: 'Selectforprint', incil: incil, dataType: 'text' }, false);
		for (var i = 1; i <= Times; i++) {
			// 调用具体打印方法
			DHC_PrintByLodop(getLodop(), inpara, '', [], '货位码打印', { printListByText: true });
		}
	}
	var PrintBtn = $('#Print').menubutton({ menu: '#mm-Print' });
	$(PrintBtn.menubutton('options').menu).menu({
		onClick: function(item) {
			var BtnName = item.name;		// div定义了name属性
			if (BtnName == 'PrintHBarCode') {
				var rowsData = ItmLocGrid.getSelections();
				if (rowsData.length <= 0) {
					$UI.msg('alert', '没有要打印的货位码!');
					return;
				}
				var count = rowsData.length;
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var row = rowsData[rowIndex];
					var incil = row.incil;
					LodopPrintBarcode(incil, 1);
				}
			} else if (BtnName == 'PrintHPage') {
				var rowsData = ItmLocGrid.getRows();
				if (rowsData.length <= 0) {
					$UI.msg('alert', '没有要打印的货位码!');
					return;
				}
				var count = rowsData.length;
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var row = rowsData[rowIndex];
					var incil = row.incil;
					LodopPrintBarcode(incil, 1);
				}
			}
		}
	});
	/* --设置初始值--*/
	var ParamsObj = $UI.loopBlock('#MainConditions');
	var DefaultData = function() {
		var DefaultDataValue = {
			RowId: '',
			ItmLoc: gLocObj,
			StkGrpId: ParamsObj.StkGrpId
		};
		$UI.fillBlock('#MainConditions', DefaultDataValue);
	};

	clear();
};
$(init);