// 待清洗紧急包弹框
var gFn;
function SelCallBackItm(Fn) {
	gFn = Fn;
	$HUI.dialog('#SelReqWinForCallBack', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
}

var initSelReqWin = function() {
	$UI.clearBlock('#SelReqConditionsForCallBack');
	var BackLocParams = JSON.stringify(addSessionParams({ Type: 'RecLoc', BDPHospital: gHospId }));
	$HUI.combobox('#BackLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params=' + BackLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	$UI.linkbutton('#SelReqQueryBT', {
		onClick: function() {
			SelReqQuery();
		}
	});
	function SelReqQuery() {
		$UI.clear(SelReqMasterGrid);
		$UI.clear(SelReqDetailGrid);
		var ParamsObj = $UI.loopBlock('#SelReqWinForCallBack');
		var Params = JSON.stringify(ParamsObj);
		SelReqMasterGrid.load({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			QueryName: 'SelectForGreenFlag',
			Params: Params
		});
	}
	
	$UI.linkbutton('#SelReqCreateBT', {
		onClick: function() {
			SelReqCreate();
		}
	});
	
	var ReqLevelData = [{
		'RowId': '0',
		'Description': '一般'
	}, {
		'RowId': '1',
		'Description': '紧急'
	}];
	var ReqLevelCombox = {
		type: 'combobox',
		options: {
			data: ReqLevelData,
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	
	function SelReqDefa() {
		$UI.clearBlock('#SelReqConditionsForCallBack');
		var Default = {
			CBStartDate: DefaultStDate(),
			CBEndDate: DefaultEdDate()
		};
		$UI.fillBlock('#SelReqConditionsForCallBack', Default);
	}
	
	function flagColor(val, row, index) {
		if (val === '1') {
			return 'color:white;background:' + GetColorCode('green');
		} else {
			return 'color:white;background:' + GetColorCode('red');
		}
	}

	var SelReqMasterCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			align: 'center',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			field: 'operate',
			title: '标识',
			align: 'center',
			width: 60,
			formatter: function(value, row, index) {
				var str = '';
				if (row.ReqLevel === '1') {
					str = str + '<div href="#" class="icon-emergency col-icon" title="紧急"></div>';
				}
				if (row.InfectFlag === 'Y') {
					str = str + '<div href="#" class="icon-virus col-icon" title="感染"></div>';
				}
				return str;
			}
		}, {
			title: '单号',
			align: 'left',
			field: 'No',
			width: 110
		}, {
			title: '紧急程度',
			field: 'ReqLevel',
			width: 80,
			styler: flagColor,
			formatter: CommonFormatter(ReqLevelCombox, 'ReqLevel', 'ReqLevelDesc'),
			hidden: true
		}, {
			title: '回收科室',
			align: 'left',
			field: 'BackLocDesc',
			width: 100
		}, {
			title: '回收日期',
			align: 'left',
			field: 'BackDate',
			width: 100
		}, {
			title: '回收时间',
			align: 'left',
			field: 'BackTime',
			width: 100
		}, {
			title: '回收人',
			align: 'left',
			field: 'BackUserName',
			width: 100
		}, {
			title: '回收标志',
			align: 'left',
			field: 'ReqFlag',
			width: 100
		}, {
			title: '感染标志',
			field: 'InfectFlag',
			align: 'left',
			width: 120,
			hidden: true
		}
	]];

	var SelReqMasterGrid = $UI.datagrid('#SelReqMasterGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			QueryName: 'SelectForGreenFlag',
			Params: JSON.stringify($UI.loopBlock('#SelReqWinForCallBack'))
		},
		columns: SelReqMasterCm,
		singleSelect: false,
		pagination: false,
		sortName: 'RowId',
		sortOrder: 'desc',
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#SelReqMasterGrid').datagrid('selectRow', 0);
			}
		},
		onClickRow: function(index, row) {
			SelReqMasterGrid.commonClickRow(index, row);
		},
		onSelect: function(index, row) {
			FindItemByF();
		},
		onUnselect: function(index, row) {
			FindItemByF();
		},
		onSelectAll: function(rows) {
			FindItemByF();
		},
		onUnselectAll: function(rows) {
			$UI.clear(SelReqDetailGrid);
		},
		onDblClickRow: function(rowIndex) { // 鼠标双击事件
			$('#SelReqMasterGrid').datagrid('selectRow', rowIndex);
			SelReqCreate();
		}
	});
	
	function SelReqCreate() {
		var CBMainRow = $('#SelReqMasterGrid').datagrid('getSelected');
		if (isEmpty(CBMainRow)) {
			$UI.msg('alert', '请选择对应的回收制单');
			return;
		}
		var row = $('#CleanList').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择需要添加的清洗单据!');
			return;
		}
		var ItemRowObj = SelReqDetailGrid.getSelectedData();
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			MethodName: 'jsCreateCleanByCallback',
			CleanId: row.RowId,
			Details: JSON.stringify(ItemRowObj)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				$('#SelReqWinForCallBack').window('close');
				gFn(row.RowId);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	var SelReqDetailCm = [[
		{
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
				if (row.BeInfected === 'Y') {
					str = str + '<div href="#" class="icon-virus col-icon" title="感染"></div>';
				}
				return str;
			}
		}, {
			title: '消毒包',
			align: 'left',
			field: 'PkgDesc',
			width: 150
		}, {
			title: '标牌',
			field: 'CodeDict',
			width: 90
		}, {
			title: '已回收数量',
			align: 'right',
			field: 'BackQty',
			width: 100
		}, {
			title: '感染标志',
			field: 'BeInfected',
			align: 'left',
			width: 120,
			hidden: true
		}
	]];

	var SelReqDetailGrid = $UI.datagrid('#SelReqDetailGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			QueryName: 'SelectUnCleanOrd'
		},
		columns: SelReqDetailCm,
		pagination: false,
		singleSelect: false,
		sortName: 'RowId',
		sortOrder: 'asc',
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#SelReqDetailGrid').datagrid('selectAll');
			}
		}
	});
	
	function FindItemByF() {
		$UI.clear(SelReqDetailGrid);
		var ReqIdStr = '';
		var Sels = SelReqMasterGrid.getSelections();
		for (var i = 0, Len = Sels.length; i < Len; i++) {
			var ReqId = Sels[i]['RowId'];
			if (ReqIdStr === '') {
				ReqIdStr = ReqId;
			} else {
				ReqIdStr = ReqIdStr + ',' + ReqId;
			}
		}
		if (ReqIdStr === '') {
			return;
		}
		var Params = $UI.loopBlock('#SelReqWinForCallBack');
		Params.ApplyId = ReqIdStr;
		SelReqDetailGrid.load({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			QueryName: 'SelectUnCleanOrd',
			Params: JSON.stringify(Params),
			rows: 9999
		});
	}
	$HUI.dialog('#SelReqWinForCallBack', {
		onOpen: function() {
			SelReqDefa();
			SelReqQuery();
		}
	});
};
$(initSelReqWin);