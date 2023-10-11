// 待添加标牌追溯包弹框
var gFn;
function UnCleanOprWin(Fn) {
	gFn = Fn;
	$HUI.dialog('#UnOprWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
}

var initUnCleanOprWin = function() {
	$UI.linkbutton('#QueryUnOprWin', {
		onClick: function() {
			SelUnOprQuery();
		}
	});
	
	function SelUnOprQuery() {
		$UI.clear(UnOprListGrid);
		var Params = JSON.stringify($UI.loopBlock('UnOprConditions'));
		UnOprListGrid.load({
			ClassName: 'web.CSSDHUI.Clean.CleanUnPass',
			QueryName: 'SelectUnOpr',
			rows: 99999,
			Params: Params
		});
	}
	
	$UI.linkbutton('#AddUnOprBT', {
		onClick: function() {
			var Rows = UnOprListGrid.getSelectedData();
			var DetailParams = JSON.stringify(Rows);
			if (isEmpty(Rows)) {
				$UI.msg('alert', '请选择要清洗的消毒包');
				return;
			}
			var row = $('#CleanList').datagrid('getSelected');
			if (isEmpty(row)) {
				$UI.msg('alert', '请选择需要添加的清洗单据!');
				return;
			}
			var Main = JSON.stringify({ MainId: row.RowId });
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.Clean.CleanUnPass',
				MethodName: 'jsSaveUnOpr',
				Params: DetailParams,
				Main: Main
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$('#UnOprWin').window('close');
					gFn(row.RowId);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	function SelUnOprDefa() {
		$UI.clearBlock('#UnOprConditions');
		var Default = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate()
		};
		$UI.fillBlock('#UnOprConditions', Default);
	}

	var UnOprListCm = [
		[{
			title: '',
			field: 'ck',
			checkbox: true,
			width: 50
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			field: 'operate',
			title: '标识',
			align: 'center',
			width: 60,
			formatter: function(value, row, index) {
				var str = '';
				if (row.LevelFlag == '1') {
					str = '<div href="#" class="icon-emergency col-icon" title="紧急"></div>';
				}
				if (row.BeInfected == 'Y') {
					str = str + '<div href="#" class="icon-virus col-icon" title="感染"></div>';
				}
				return str;
			}
		}, {
			title: 'PkgId',
			field: 'PkgId',
			width: 100,
			hidden: true
		}, {
			title: '回收科室',
			field: 'BackLocDesc',
			width: 150
		}, {
			title: '回收单号',
			field: 'BackNo',
			width: 120
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 200,
			styler: function(value, row, index) {
				return 'background-color:' + row.SterTypeColor + ';' + 'color:' + GetFontColor(row.SterTypeColor);
			}
		}, {
			title: '包属性',
			field: 'AttributeDesc',
			width: 100,
			hidden: true
		}, {
			title: '标牌',
			field: 'CodeDict',
			width: 150
		}, {
			title: '数量',
			field: 'BackQty',
			width: 100,
			align: 'right'
		}, {
			title: '回收科室Dr',
			field: 'BackLocId',
			width: 100,
			align: 'right',
			hidden: true
		}, {
			title: '紧急状态',
			field: 'LevelFlag',
			width: 100,
			hidden: true
		}, {
			title: 'SterTypeColor',
			field: 'SterTypeColor',
			width: 100,
			hidden: true
		}, {
			title: '感染标志',
			field: 'BeInfected',
			width: 50,
			hidden: true
		}]
	];
	var UnOprListGrid = $UI.datagrid('#UnOprList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanUnPass',
			QueryName: 'SelectUnOpr',
			rows: 99999
		},
		columns: UnOprListCm,
		singleSelect: false,
		pagination: false,
		sortName: 'RowId',
		sortOrder: 'asc'
	});
	
	$HUI.dialog('#UnOprWin', {
		onOpen: function() {
			SelUnOprDefa();
			SelUnOprQuery();
		}
	});
};
$(initUnCleanOprWin);