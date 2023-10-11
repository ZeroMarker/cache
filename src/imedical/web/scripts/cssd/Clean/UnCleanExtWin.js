// 待添加外来器械包弹框
var gFn;
function UnCleanExtWin(Fn) {
	gFn = Fn;
	$HUI.dialog('#UnExtWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
}

var initUnCleanExtWin = function() {
	$UI.linkbutton('#QueryUnExtWin', {
		onClick: function() {
			SelUnExtQuery();
		}
	});
	
	$UI.linkbutton('#AddUnExtBT', {
		onClick: function() {
			var Rows = UnExtListGrid.getSelectedData();
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
				MethodName: 'SaveUnExt',
				Params: DetailParams,
				MainId: row.RowId
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$('#UnExtWin').window('close');
					gFn(row.RowId);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	function SelUnExtQuery() {
		$UI.clear(UnExtListGrid);
		var Params = JSON.stringify($UI.loopBlock('UnExtConditions'));
		UnExtListGrid.load({
			ClassName: 'web.CSSDHUI.Clean.CleanUnPass',
			QueryName: 'SelectUnExt',
			rows: 99999,
			Params: Params
		});
	}
	
	function SelUnExtDefa() {
		$UI.clearBlock('#UnExtConditions');
		var Default = {
			EStartDate: DefaultStDate(),
			EEndDate: DefaultEdDate()
		};
		$UI.fillBlock('#UnExtConditions', Default);
	}

	var OperatorTypeData = [{
		'RowId': '1',
		'Description': '急诊手术'
	}, {
		'RowId': '0',
		'Description': '择期手术'
	}];
	var OperatorTypeCombox = {
		type: 'combobox',
		options: {
			data: OperatorTypeData,
			valueField: 'RowId',
			textField: 'Description',
			editable: true
		}
	};

	function OperatorTypeColor(val, row, index) {
		if (val === '0') {
			return 'color:white;background:' + GetColorCode('green');
		} else {
			return 'color:white;background:' + GetColorCode('red');
		}
	}
	
	var UnExtListCm = [
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
			title: 'PkgId',
			field: 'PkgId',
			width: 100,
			hidden: true
		}, {
			title: '状态',
			field: 'Status',
			width: 60,
			hidden: true
		}, {
			title: '状态',
			field: 'StatusDesc',
			width: 80,
			formatter: function(value, row, index) {
				var str = row.StatusDesc;
				if (row.LevelFlag === '1') {
					str = str + '<div href="#" class="icon-emergency col-icon" title="紧急"></div>';
				}
				return str;
			}
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 200
		}, {
			title: '手术类型',
			field: 'OperatorType',
			width: 80,
			formatter: CommonFormatter(OperatorTypeCombox, 'OperatorType', 'OperatorTypeDesc'),
			styler: OperatorTypeColor
		}, {
			title: '包属性',
			field: 'AttributeDesc',
			width: 100,
			hidden: true
		}, {
			title: '标牌',
			field: 'CodeDictId',
			width: 100
		}, {
			title: '患者姓名',
			field: 'SickerName',
			width: 80
		}, {
			title: '登记号',
			field: 'RegistNo',
			width: 150
		}, {
			title: '接收包数',
			field: 'RecNum',
			width: 100
		}, {
			title: '厂商',
			field: 'VenDesc',
			width: 200
		}, {
			title: '回收明细Dr',
			field: 'CallBackDetailId',
			width: 100,
			hidden: true
		}, {
			title: '紧急状态',
			field: 'LevelFlag',
			width: 100,
			hidden: true
		}]
	];
	var UnExtListGrid = $UI.datagrid('#UnExtList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanUnPass',
			QueryName: 'SelectUnExt',
			rows: 99999
		},
		columns: UnExtListCm,
		singleSelect: false,
		pagination: false,
		sortName: 'RowId',
		sortOrder: 'asc'
	});
	
	$HUI.dialog('#UnExtWin', {
		onOpen: function() {
			SelUnExtDefa();
			SelUnExtQuery();
		}
	});
};
$(initUnCleanExtWin);