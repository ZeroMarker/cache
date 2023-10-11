// 待清洗-过期处理包
var gFn;
function ExpireDealWin(Fn) {
	gFn = Fn;
	$HUI.dialog('#ExpireDealWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
}

var initExpireDealWin = function() {
	$UI.linkbutton('#QueryExpireDeal', {
		onClick: function() {
			ExpireDealQuery();
		}
	});

	$UI.linkbutton('#AddExpireDealBT', {
		onClick: function() {
			var Rows = ExpireDealListGrid.getSelectedData();
			if (isEmpty(Rows)) {
				$UI.msg('alert', '请选择要清洗的消毒包');
				return;
			}
			var params = JSON.stringify(Rows);
			var row = $('#CleanList').datagrid('getSelected');
			if (isEmpty(row)) {
				$UI.msg('alert', '请选择需要添加的清洗单据!');
				return;
			}
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.Clean.CleanExpireDeal',
				MethodName: 'SaveExpireDeal',
				Params: params,
				MainId: row.RowId
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$('#ExpireDealWin').window('close');
					gFn(row.RowId);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	function ExpireDealQuery() {
		$UI.clear(ExpireDealListGrid);
		var Params = JSON.stringify($UI.loopBlock('ExpireDealConditions'));
		ExpireDealListGrid.load({
			ClassName: 'web.CSSDHUI.Clean.CleanExpireDeal',
			QueryName: 'SelectExpireDeal',
			rows: 99999,
			Params: Params
		});
	}
	
	function ExpireDealDefa() {
		$UI.clearBlock('#ExpireDealConditions');
		var Default = {
			ExpStartDate: DefaultStDate(),
			ExpEndDate: DefaultEdDate()
		};
		$UI.fillBlock('#ExpireDealConditions', Default);
	}

	var ExpireDealListCm = [
		[{
			title: '',
			field: 'ck',
			checkbox: true,
			width: 50
		}, {
			title: 'TransRowId',
			field: 'TransRowId',
			width: 100,
			hidden: true
		}, {
			title: 'PkgId',
			field: 'PkgId',
			width: 100,
			hidden: true
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 200
		}, {
			title: '标签',
			field: 'Label',
			width: 160
		}, {
			title: '包属性',
			field: 'AttributeDesc',
			width: 150
		}, {
			title: '失效日期',
			field: 'ExpDate',
			width: 120
		}, {
			title: '过期处理日期',
			field: 'ExpDealDate',
			width: 120
		}, {
			title: '过期处理时间',
			field: 'ExpDealTime',
			width: 120
		}, {
			title: '过期处理人',
			field: 'ExpDealUserName',
			width: 100
		}, {
			title: '状态',
			field: 'StatusDesc',
			width: 150
		}, {
			title: '过期处理人Dr',
			field: 'ExpDealUserId',
			width: 100,
			hidden: true
		}, {
			title: '包属性Dr',
			field: 'AttributeId',
			width: 100,
			hidden: true
		}]
	];

	var ExpireDealListGrid = $UI.datagrid('#ExpireDealList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanExpireDeal',
			QueryName: 'SelectExpireDeal',
			rows: 99999
		},
		columns: ExpireDealListCm,
		singleSelect: false,
		pagination: false,
		sortName: 'TransRowId',
		sortOrder: 'asc'
	});
	
	$HUI.dialog('#ExpireDealWin', {
		onOpen: function() {
			ExpireDealDefa();
			ExpireDealQuery();
		}
	});
};
$(initExpireDealWin);