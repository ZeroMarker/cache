// 消毒包库存盘点js
var StockGrid;
var init = function() {
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			query();
		}
	});
	
	var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TypeDetail: '1,2,7', CreateLocId: gLocId }));
	$HUI.combobox('#package', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$HUI.combobox('#StockFlag', {
		valueField: 'RowId',
		textField: 'Description',
		data: StockFlagData
	});
	
	function query() {
		var ParamsObj = $UI.loopBlock('StockTB');
		var Params = JSON.stringify(ParamsObj);
		StockGrid.load({
			ClassName: 'web.CSSDHUI.PackageDisp.PackageStock',
			QueryName: 'SelectAll',
			Params: Params
		});
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			DefaultData();
		}
	});

	// 确认
	function Check() {
		var Rows = StockGrid.getSelections();
		if (isEmpty(Rows)) {
			$UI.msg('alert', '请选择需要确认的标签！');
			return;
		}
		var Main = JSON.stringify(addSessionParams({}));
		var Detail = JSON.stringify(Rows);
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.PackageDisp.PackageStock',
			MethodName: 'jsCheck',
			Main: Main,
			Detail: Detail
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				StockGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	// 扫码领动作
	$('#Label').keypress(function(event) {
		if (event.which == 13) {
			var Params = JSON.stringify($UI.loopBlock('StockTB'));
			var label = $('#Label').val();
			if (isEmpty(label)) {
				$UI.msg('alert', '未获取到扫描的标签,请重新扫描！');
				return;
			}
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.PackageDisp.PackageStock',
				MethodName: 'jsSave',
				Params: Params
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					StockGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
				$('#Label').val('');
			});
		}
	});
	
	function flagColor(val, row, index) {
		if (val === 'Y') {
			return 'color:white;background:' + GetColorCode('green');
		} else {
			return 'color:white;background:' + GetColorCode('red');
		}
	}
	
	var StockCm = [[
		{
			title: '',
			field: 'ck',
			checkbox: true,
			width: 30
		}, {
			field: 'operate',
			title: '操作',
			align: 'center',
			width: 60,
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';
				if (row.ChkFlag !== 'Y') {
					str = str + '<div class="col-icon icon-cancel"  href="#"  title="删除" onclick="StockGrid.commonDeleteRow(false,' + index + ');"></div>';
				}
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			align: 'left',
			width: 100,
			hidden: true
		}, {
			title: '确认标志',
			field: 'ChkFlag',
			align: 'center',
			width: 80,
			styler: flagColor,
			formatter: function(value, row, index) {
				var desc = '';
				if (value == 'Y') {
					desc = '已确认';
				} else {
					desc = '未确认';
				}
				return desc;
			}
		}, {
			title: '第三方标签',
			field: 'ThirdFlag',
			align: 'center',
			width: 80,
			formatter: BoolFormatter
		}, {
			title: '标签',
			field: 'Label',
			align: 'left',
			width: 160,
			sortable: true,
			editor: { options: { required: true }}
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			align: 'left',
			width: 200,
			sortable: true
		}, {
			title: '失效日期',
			field: 'ExpDate',
			align: 'left',
			width: 100,
			sortable: true
		}, {
			title: '存放位置',
			field: 'Location',
			align: 'left',
			width: 100,
			sortable: true
		}, {
			title: '入库人员',
			field: 'InUserName',
			align: 'left',
			width: 100
		}, {
			title: '入库日期',
			field: 'InDate',
			align: 'left',
			width: 180
		}, {
			title: '灭菌批号',
			field: 'SterNo',
			align: 'left',
			width: 140,
			sortable: true
		}, {
			title: '灭菌日期',
			field: 'SterDate',
			align: 'left',
			width: 100,
			sortable: true
		}, {
			title: '发放人员',
			field: 'DispUserName',
			align: 'left',
			width: 100,
			sortable: true
		}, {
			title: '接收科室',
			field: 'ToLocDesc',
			align: 'left',
			width: 120
		}
	]];
	var Params = JSON.stringify($UI.loopBlock('StockTB'));
	StockGrid = $UI.datagrid('#StockGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.PackageStock',
			QueryName: 'SelectAll',
			Params: Params
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.PackageStock',
			MethodName: 'jsDelete'
		},
		columns: StockCm,
		showBar: true,
		sortOrder: 'desc',
		sortName: 'RowId',
		singleSelect: false,
		selectOnCheck: true,
		navigatingWithKey: true,
		toolbar: [{
			id: 'ChkBT',
			text: '确认',
			iconCls: 'icon-ok',
			handler: function() {
				Check();
			}
		}],
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#StockGrid').datagrid('selectRow', 0);
			}
		}
	});
	
	function DefaultData() {
		$UI.clearBlock('StockTB');
		$UI.clear(StockGrid);
		var Default = {
			FStartDate: DefaultEdDate(),
			FEndDate: DefaultEdDate(),
			StockFlag: 'I'
		};
		$('#Label').focus();
		$UI.fillBlock('#StockTB', Default);
	}
	
	DefaultData();
	query();
};
$(init);