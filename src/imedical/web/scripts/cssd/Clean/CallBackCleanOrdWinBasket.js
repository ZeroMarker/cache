// 待添加回收清洗弹框，装载页面使用
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
	
	$UI.linkbutton('#AddCallBackUnCleanOrd', {
		onClick: function() {
			var Rows = CallBackUnCleanGrid.getSelectedData();
			var DetailParams = JSON.stringify(Rows);
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
					$UI.msg('alert', '数量不能多于未装载数量');
					flag = 1;
				}
			});
			if (flag === 1) {
				return;
			}
			var MainParams = $UI.loopBlock('#Conditions');
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.Clean.CleanBasket',
				MethodName: 'jsSaveUnCleanOrd',
				Params: DetailParams,
				MainParams: JSON.stringify(MainParams)
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$('#CallBackOrdWin').window('close');
					gFn();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	function SelCallBackOrdQuery() {
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
			CBEndDate: DefaultEdDate(),
			ReqLevel: ''
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
			width: 150
		}, {
			title: '标牌编码',
			field: 'CodeDict',
			width: 120
		}, {
			title: '回收数量',
			field: 'BackQty',
			align: 'right',
			width: 100
		}, {
			title: '已装载数量',
			field: 'CleanQty',
			align: 'right',
			width: 100
		}, {
			title: '未装载数量',
			field: 'UnCleanQty',
			align: 'right',
			width: 100
		}, {
			title: '数量',
			field: 'WillQty',
			width: 100,
			align: 'right',
			editor: { type: 'numberbox' }
		}, {
			title: '科室',
			field: 'ApplyLocDesc',
			align: 'left',
			width: 120
		}, {
			title: '单号',
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
		}
	]];
	var CallBackUnCleanGrid = $UI.datagrid('#CallBackUnCleanGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			QueryName: 'SelectUnCleanOrd',
			rows: 99999999
		},
		columns: CallBackUnCleanOrdCm,
		pagination: false,
		singleSelect: false,
		sortName: 'CallBackItmId',
		sortOrder: 'asc',
		onClickRow: function(index, row) {
			CallBackUnCleanGrid.commonClickRow(index, row);
		}
	});
	
	$HUI.dialog('#CallBackOrdWin', {
		onOpen: function() {
			SelCallBackOrdDefa();
			SelCallBackOrdQuery();
		}
	});
	SelCallBackOrdDefa();
};
$(initCallBackCleanOrdWin);