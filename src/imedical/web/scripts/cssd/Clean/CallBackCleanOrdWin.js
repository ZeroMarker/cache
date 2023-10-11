// 待添加回收清洗弹框
var gFn;
function CallBackCleanOrdWin(Fn) {
	gFn = Fn;
	$HUI.dialog('#CallBackOrdWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
}

var initCallBackCleanOrdWin = function() {
	$UI.linkbutton('#QueryCallBackOrd', {
		onClick: function() {
			SelCallBackOrdQuery();
		}
	});
	
	// 灭菌方式
	$HUI.combobox('#SterTypeId', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterType&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TypeDetail: '1,2', ExtFlag: 'N', CreateLocId: gLocId }));
	$HUI.combobox('#PkgDesc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$UI.linkbutton('#AddCallBackUnCleanOrd', {
		onClick: function() {
			AddCallBackUnCleanOrd();
		}
	});
	
	function AddCallBackUnCleanOrd(Rows) {
		var Rows = CallBackUnCleanGrid.getSelectedData();
		if (isEmpty(Rows)) {
			$UI.msg('alert', '请选择要清洗的消毒包');
			return;
		}
		var flag = '';
		$.each(Rows, function(index, item) {
			if (parseInt(item.WillQty) <= 0) {
				$UI.msg('alert', '请输入合适的清洗数量');
				flag = 1;
			}
			if (parseInt(item.WillQty) > parseInt(item.UnCleanQty)) {
				$UI.msg('alert', '清洗数量不能多于未清洗数量');
				flag = 1;
			}
		});
		if (flag === 1) {
			return;
		}
		var row = $('#CleanList').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择需要添加的清洗单据!');
			return;
		}
		var DetailParams = JSON.stringify(Rows);
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			MethodName: 'jsSaveUnCleanOrd',
			Params: DetailParams,
			MainId: row.RowId
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$('#CallBackOrdWin').window('close');
				gFn(row.RowId);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	function SelCallBackOrdQuery() {
		$UI.clear(CallBackUnCleanGrid);
		var Params = JSON.stringify($UI.loopBlock('CallBackUnClean'));
		CallBackUnCleanGrid.load({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			QueryName: 'SelectUnCleanOrd',
			rows: 99999,
			Params: Params
		});
	}
	
	function SelCallBackOrdDefa() {
		$UI.clearBlock('#CallBackUnClean');
		var Default = {
			CBStartDate: DefaultStDate(),
			CBEndDate: DefaultEdDate()
		};
		$UI.fillBlock('#CallBackUnClean', Default);
	}

	var CallBackUnCleanOrdCm = [[
		{
			title: '',
			field: 'ck',
			checkbox: true,
			width: 50
		}, {
			title: '回收明细id',
			field: 'CallBackItmId',
			width: 100,
			hidden: true
		}, {
			title: 'MaterialId',
			field: 'MaterialId',
			width: 100,
			hidden: true
		}, {
			title: 'PkgId',
			field: 'PkgId',
			width: 100,
			hidden: true
		}, {
			field: 'ReqLevel',
			title: '标识',
			align: 'center',
			width: 60,
			formatter: function(value, row, index) {
				var str = '';
				if (value === '1') {
					str = str + '<div href="#" class="icon-emergency col-icon" title="紧急"></div>';
				}
				if (row.BeInfected === 'Y') {
					str = str + '<div href="#" class="icon-virus col-icon" title="感染"></div>';
				}
				return str;
			}
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 150,
			styler: function(value, row, index) {
				return 'background-color:' + row.SterTypeColor + ';' + 'color:' + GetFontColor(row.SterTypeColor);
			}
		}, {
			title: '标牌',
			field: 'CodeDict',
			width: 90
		}, {
			title: '回收数量',
			field: 'BackQty',
			align: 'right',
			width: 90
		}, {
			title: '已清洗数量',
			field: 'CleanQty',
			align: 'right',
			width: 90
		}, {
			title: '未清洗数量',
			field: 'UnCleanQty',
			align: 'right',
			width: 90
		}, {
			title: '数量',
			field: 'WillQty',
			width: 70,
			align: 'right',
			editor: { type: 'numberbox' }
		}, {
			title: '回收科室',
			field: 'ApplyLocDesc',
			align: 'left',
			width: 120
		}, {
			title: '回收单号',
			field: 'CallBackNo',
			align: 'left',
			width: 120
		}, {
			title: '感染标志',
			field: 'BeInfected',
			align: 'left',
			width: 120,
			hidden: true
		}, {
			title: '包装材料',
			field: 'MaterialDesc',
			width: 100
		}, {
			title: '灭菌方式',
			field: 'SterType',
			width: 100
		}, {
			title: '灭菌方式对应颜色',
			field: 'SterTypeColor',
			width: 100,
			hidden: true
		}
	]];
	var CallBackUnCleanGrid = $UI.datagrid('#CallBackUnCleanGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			QueryName: 'SelectUnCleanOrd',
			rows: 99999
		},
		columns: CallBackUnCleanOrdCm,
		pagination: false,
		singleSelect: false,
		sortName: 'CallBackItmId',
		sortOrder: 'asc',
		onClickRow: function(index, row) {
			CallBackUnCleanGrid.commonClickRow(index, row);
		},
		onDblClickRow: function(rowIndex) {
			$('#CallBackUnCleanGrid').datagrid('selectRow', rowIndex);
			AddCallBackUnCleanOrd();
		}
	});
	$HUI.dialog('#CallBackOrdWin', {
		onOpen: function() {
			SelCallBackOrdDefa();
			SelCallBackOrdQuery();
		}
	});
};
$(initCallBackCleanOrdWin);