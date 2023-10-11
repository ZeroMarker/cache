// 名称:		实盘：录入方式四(高值扫码盘点)
var init = function() {
	// =======================条件初始化start==================
	// 库存分类
	var StkCatBox = $HUI.combobox('#StkCat', {
		valueField: 'RowId',
		textField: 'Description'
	});
	
	// 类组
	$('#StkScg').stkscgcombotree({
		onSelect: function(node) {
			StkCatBox.clear();
			$.cm({
				ClassName: 'web.DHCSTMHUI.Common.Dicts',
				QueryName: 'GetStkCat',
				ResultSetType: 'array',
				StkGrpId: node.id
			}, function(data) {
				StkCatBox.loadData(data);
			});
		}
	});
	
	$('#BarCode').bind('keypress', function(event) {
		if (event.keyCode == 13) {
			var BarCode = $('#BarCode').val();
			if (!isEmpty(BarCode)) {
				HVINStkTk(BarCode);
				$('#BarCode').val('');
			}
		}
	});
	// ===========================条件初始end===========================
	// ======================tbar操作事件start=========================
	// 清屏
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(DetailGrid);
		var DefaultData = {
			ScgStk: '',
			LocManaGrp: '',
			InstNo: '',
			StkCatBox: '',
			LocStkBin: '',
			InStkTkWin: ''
		};
		$UI.fillBlock('#Conditions', DefaultData);
		Select(gRowId);
	}
	// 查询
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			QueryDetail();
		}
	});
	
	var Select = function(Inst) {
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'jsSelect',
			Inst: Inst
		},
		function(jsonData) {
			var SupLocId = jsonData.SupLocId;
			LoadData(SupLocId);
			$UI.fillBlock('#Conditions', jsonData);
			QueryDetail();
		});
	};
	
	function LoadData(LocId) {
		$HUI.combobox('#LocManGrp', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocManGrp&ResultSetType=array&LocId=' + LocId,
			valueField: 'RowId',
			textField: 'Description'
		});
		// 货位
		var LocStkBinParams = JSON.stringify(addSessionParams({ LocDr: LocId }));
		$HUI.combobox('#LocStkBin', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocStkBin&ResultSetType=array&Params=' + LocStkBinParams,
			valueField: 'RowId',
			textField: 'Description'
		});
		// 实盘窗口
		$HUI.combobox('#InStkTkWin', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInStkTkWindow&ResultSetType=array&LocId=' + LocId,
			valueField: 'RowId',
			textField: 'Description',
			editable: false
		});
		$('#InStkTkWin').combobox('setValue', gInstwWin);
	}
	
	function QueryDetail() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var Params = JSON.stringify(ParamsObj);
		var Inst = ParamsObj.Inst;
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			QueryName: 'jsDHCSTInStkTkItm',
			query2JsonStrict: 1,
			Inst: Inst,
			Others: Params,
			rows: 99999
		});
	}
	
	function loadHVBarCodeInfoGrid() {
		var row = $('#DetailGrid').datagrid('getSelected');
		if ((isEmpty(row)) || (isEmpty(row.RowId))) {
			$UI.msg('alert', '请选择数据!');
			return;
		}
		HVBarCodeInfoGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTkItmTrack',
			QueryName: 'jsItmTrackDetail',
			query2JsonStrict: 1,
			Insti: row.RowId,
			Others: '',
			rows: 99999
		});
	}
	
	// 条码实盘
	function HVINStkTk(HVBarCode) {
		if (isEmpty(HVBarCode)) {
			return false;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTkItmTrack',
			MethodName: 'jsINStkTkItmTrack',
			HVBarCode: HVBarCode,
			Inst: gRowId,
			UserId: gUserId
		}, function(jsonData) {
			hideMask();
			if (jsonData.success >= 0) {
				var CountQty = jsonData.rowid;
				var RowIndex = DetailGrid.getRowIndex(DetailGrid.getSelected());
				if (RowIndex != -1) {
					DetailGrid.updateRow({
						index: RowIndex,
						row: {
							'CountQty': CountQty
						}
					});
				}
				loadHVBarCodeInfoGrid();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// ======================tbar操作事件end============================
	var DetailGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: 'Inclb',
			field: 'Inclb',
			width: 50,
			hidden: true
		}, {
			title: 'InciId',
			field: 'InciId',
			width: 50,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 120
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 150
		}, {
			title: '账盘数量',
			field: 'FreezeQty',
			width: 80,
			align: 'right'
		}, {
			title: '实盘数量',
			field: 'CountQty',
			width: 80,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					min: 0,
					precision: 0
				}
			}
		}, {
			title: 'UomId',
			field: 'uom',
			hidden: true,
			width: 60
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 60
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '批号',
			field: 'BatNo',
			width: 100
		}, {
			title: '有效期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 100
		}, {
			title: '进价',
			field: 'Rp',
			width: 100,
			align: 'right'
		}, {
			title: '售价',
			field: 'Sp',
			width: 100,
			align: 'right',
			hidden: true
		}, {
			title: '实盘日期',
			field: 'CountDate',
			width: 100
		}, {
			title: '实盘时间',
			field: 'CountTime',
			width: 80
		}, {
			title: '实盘人',
			field: 'CountUserName',
			width: 100
		}, {
			title: '货位',
			field: 'StkBinDesc',
			width: 60,
			hidden: true
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			QueryName: 'jsDHCSTInStkTkItm',
			query2JsonStrict: 1
		},
		columns: DetailGridCm,
		sortName: 'InciCode',
		sortOrder: 'asc',
		showBar: true,
		rows: 99999,
		pagination: false,
		onSelect: function(index, row) {
			loadHVBarCodeInfoGrid();
		}
	});
	var HVBarCodeInfoGridCm = [[
		{
			title: 'Instit',
			field: 'Instit',
			hidden: true,
			width: 50
		}, {
			title: '跟踪ID',
			field: 'Dhcit',
			hidden: true,
			width: 50
		}, {
			title: '高值条码',
			field: 'BarCode',
			width: 200
		}, {
			title: '盘点标志',
			field: 'CountFlag',
			width: 100
		}]];
		
	var HVBarCodeInfoGrid = $UI.datagrid('#HVBarCodeInfoGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTkItmTrack',
			MethodName: 'jsItmTrackDetail'
		},
		columns: HVBarCodeInfoGridCm,
		rows: 99999,
		pagination: false,
		onClickRow: function(index, row) {
			HVBarCodeInfoGrid.commonClickRow(index, row);
		}
	});
	Select(gRowId);
};
$(init);