// 待添加清洗不合格包弹框
var gFn;
function UnPassCleanWin(Fn) {
	gFn = Fn;
	$HUI.dialog('#UnPassCleanWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
}

var initUnPassCleanWin = function() {
	$UI.linkbutton('#QueryUnPassCleanWin', {
		onClick: function() {
			SelUnPassCleanQuery();
		}
	});

	$UI.linkbutton('#AddUnPassCleanBT', {
		onClick: function() {
			var Rows = UnPassCleanListGrid.getSelectedData();
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
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.Clean.CleanUnPass',
				MethodName: 'SaveUnPassClean',
				Params: DetailParams,
				MainId: row.RowId
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$('#UnPassCleanWin').window('close');
					gFn(row.RowId);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	function SelUnPassCleanQuery() {
		$UI.clear(UnPassCleanListGrid);
		var Params = JSON.stringify($UI.loopBlock('UnPassCleanConditions'));
		UnPassCleanListGrid.load({
			ClassName: 'web.CSSDHUI.Clean.CleanUnPass',
			QueryName: 'SelectUnPassClean',
			rows: 99999,
			Params: Params
		});
	}
	
	function SelUnPassCleanDefa() {
		$UI.clearBlock('#UnPassCleanConditions');
		var Default = {
			UnPassCStartDate: DefaultStDate(),
			UnPassCEndDate: DefaultEdDate()
		};
		$UI.fillBlock('#UnPassCleanConditions', Default);
	}

	var UnPassCleanListCm = [
		[{
			title: '',
			field: 'ck',
			checkbox: true,
			width: 50
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
				if (row.BeInfected === 'Y') {
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
			title: '申请单',
			field: 'ApplyNo',
			width: 120
		}, {
			title: '科室',
			field: 'BackLocDesc',
			width: 120
		}, {
			title: '清洗不合格批次',
			field: 'CleanNum',
			width: 140
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 200
		}, {
			title: '标牌',
			field: 'CodeDictId',
			width: 100
		}, {
			title: '数量',
			field: 'PkgNum',
			align: 'right',
			width: 100
		}, {
			title: '包属性',
			field: 'AttributeId',
			width: 100,
			hidden: true
		}, {
			title: '不合格明细ID',
			field: 'UnPassDetailId',
			width: 100,
			hidden: true
		}, {
			title: '不合格单据ID',
			field: 'UsedPrdoRowId',
			width: 100,
			hidden: true
		}, {
			title: '清洗明细ID',
			field: 'CleanDetailId',
			width: 100,
			hidden: true
		}, {
			title: '回收明细ID(专科）',
			field: 'CallBackDetailId',
			width: 100,
			hidden: true
		}, {
			title: '紧急状态',
			field: 'LevelFlag',
			width: 100,
			hidden: true
		}, {
			title: 'ExtId',
			field: 'ExtId',
			width: 100,
			hidden: true
		}, {
			title: '感染标志',
			field: 'BeInfected',
			align: 'left',
			width: 120,
			hidden: true
		}]
	];
	var UnPassCleanListGrid = $UI.datagrid('#UnPassCleanList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanUnPass',
			QueryName: 'SelectUnPassClean',
			rows: 99999
		},
		columns: UnPassCleanListCm,
		singleSelect: false,
		pagination: false,
		sortName: 'UnPassDetailId',
		sortOrder: 'asc'
	});
	
	$HUI.dialog('#UnPassCleanWin', {
		onOpen: function() {
			SelUnPassCleanDefa();
			SelUnPassCleanQuery();
		}
	});
};
$(initUnPassCleanWin);