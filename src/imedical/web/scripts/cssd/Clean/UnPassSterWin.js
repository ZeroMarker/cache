// 待添加灭菌不合格弹框
var gFn;
function UnPassSterWin(Fn) {
	gFn = Fn;
	$HUI.dialog('#UnPassSterWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
}

// 查询-灭菌不合格包
var initUnPassSterWin = function() {
	$UI.linkbutton('#QueryUnPassSterWin', {
		onClick: function() {
			SelUnPassSterQuery();
		}
	});

	$UI.linkbutton('#AddUnPassSterBT', {
		onClick: function() {
			var Rows = UnPassSterListGrid.getSelectedData();
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
				ClassName: 'web.CSSDHUI.Clean.CleanUnPass',
				MethodName: 'SaveUnPassSter',
				Params: params,
				MainId: row.RowId
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$('#UnPassSterWin').window('close');
					gFn(row.RowId);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	function SelUnPassSterQuery() {
		$UI.clear(UnPassSterListGrid);
		var Params = JSON.stringify($UI.loopBlock('UnPassSterConditions'));
		UnPassSterListGrid.load({
			ClassName: 'web.CSSDHUI.Clean.CleanUnPass',
			QueryName: 'SelectUnPassSter',
			rows: 99999,
			Params: Params
		});
	}
	
	function SelUnPassSterDefa() {
		$UI.clearBlock('#UnPassSterConditions');
		var Default = {
			UnPassSStartDate: DefaultStDate(),
			UnPassSEndDate: DefaultEdDate()
		};
		$UI.fillBlock('#UnPassSterConditions', Default);
	}

	var UnPassSterListCm = [
		[{
			title: '',
			field: 'ck',
			checkbox: true,
			width: 50
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
			width: 150
		}, {
			title: '包分类',
			field: 'PkgClassDesc',
			width: 100
		}, {
			title: '灭菌批号',
			field: 'SterNum',
			width: 150
		}, {
			title: '不合格批号',
			field: 'UnPassNum',
			width: 150
		}, {
			title: '不合格原因',
			field: 'ReasonDesc',
			width: 150
		}, {
			title: '包属性',
			field: 'AttributeId',
			width: 100,
			hidden: true
		}, {
			title: '不合格明细ID',
			field: 'UnPassSterDetailID',
			width: 100,
			hidden: true
		}]
	];
	var UnPassSterListGrid = $UI.datagrid('#UnPassSterList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanUnPass',
			QueryName: 'SelectUnPassSter',
			rows: 99999
		},
		columns: UnPassSterListCm,
		singleSelect: false,
		pagination: false,
		sortName: 'unPassSterDetailID',
		sortOrder: 'asc'
	});
	
	$HUI.dialog('#UnPassSterWin', {
		onOpen: function() {
			SelUnPassSterDefa();
			SelUnPassSterQuery();
		}
	});
};
$(initUnPassSterWin);