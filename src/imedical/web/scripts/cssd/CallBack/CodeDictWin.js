// 待添加回收清洗弹框
var gFn;
function CodeDictWin(Fn) {
	gFn = Fn;
	var gWinWidth = $(window).width() * 0.7;
	var gWinHeight = $(window).height() * 0.7;
	$HUI.dialog('#CodeDictWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
}

var initCodeDictWin = function() {
	$UI.linkbutton('#Query', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		$UI.clear(CodeDictGrid);
		var ParamsObj = JSON.stringify($UI.loopBlock('UnCBCodeDict'));
		var Params = JSON.stringify(addSessionParams(ParamsObj));
		CodeDictGrid.load({
			ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
			QueryName: 'UnCallBackCodeDict',
			Params: Params,
			rows: 99999
		});
	}
	
	$UI.linkbutton('#AddCodeDict', {
		onClick: function() {
			var Rows = CodeDictGrid.getChecked();
			if (isEmpty(Rows)) {
				$UI.msg('alert', '未获取到标牌信息!');
				return;
			}
			for (var i = 0, Len = Rows.length; i < Len; i++) {
				var CodeDict = Rows[i]['CodeDict'];
				AddItem(CodeDict);
			}
		}
	});
	
	function AddItem(CodeDict) {
		var MainRow = $('#MainListGrid').datagrid('getSelected');
		if (isEmpty(MainRow)) {
			$UI.msg('alert', '请选择需要添加的回收单据!');
			return;
		}
		var Params = JSON.stringify($UI.loopBlock('#UnCBCodeDict'));
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.CallBack.CallBack',
			MethodName: 'jsCallBackLabel',
			MainId: MainRow.RowId,
			label: CodeDict,
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				CodeDictGrid.reload();
				$('#CodeDictWin').window('close');
				gFn(MainRow.RowId);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	function Default() {
		$UI.clearBlock('#UnCBCodeDict');
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate()
		};
		$UI.fillBlock('#UnCBCodeDict', DefaultData);
	}
	
	var Cm = [[
		{
			title: '',
			field: 'ck',
			checkbox: true,
			frozen: true,
			width: 50
		}, {
			title: '标牌',
			field: 'CodeDict',
			width: 150
		}, {
			title: '消毒包名称',
			field: 'CodeDictDesc',
			width: 200
		}, {
			title: '状态',
			field: 'StatusDesc',
			width: 150
		}, {
			field: '当前科室Id',
			title: 'CurrLocId',
			align: 'left',
			width: 100,
			hidden: true
		}, {
			field: 'CurLocDesc',
			title: '当前科室',
			align: 'left',
			width: 200
		}
	]];
	var CodeDictGrid = $UI.datagrid('#CodeDictGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
			QueryName: 'UnCallBackCodeDict',
			rows: 99999
		},
		columns: Cm,
		pagination: false,
		singleSelect: false,
		showBar: true,
		onDblClickRow: function(index, row) {
			var CodeDict = row['CodeDict'];
			if (isEmpty(CodeDict)) {
				$UI.msg('alert', '未获取到标牌信息!');
				return;
			}
			AddItem(CodeDict);
		}
	});
	
	$HUI.dialog('#CodeDictWin', {
		onOpen: function() {
			Default();
			Query();
		}
	});
};
$(initCodeDictWin);