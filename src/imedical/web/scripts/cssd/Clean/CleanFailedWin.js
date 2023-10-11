// 清洗不合格登记-不合格包弹框
var gFn;
function SelCleanFailPackage(Fn) {
	gFn = Fn;
	$HUI.dialog('#CleanFailedItmWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
}
var initCleanFailedItm = function() {
	$UI.linkbutton('#SelAddQuery', {
		onClick: function() {
			SelReqQuery();
		}
	});
	function SelReqQuery() {
		$UI.clear(SelCleanFailGrid);
		var row = $('#MainList').datagrid('getSelected');
		var Params = JSON.stringify(addSessionParams({ CleanMainId: row.CleanMainId, PrdoId: row.RowId, RegisterFlag: '' }));
		SelCleanFailGrid.load({
			ClassName: 'web.CSSDHUI.Clean.CleanFailItem',
			QueryName: 'GetCleanFailPackage',
			Params: Params,
			rows: 99999
		});
	}
	
	$UI.linkbutton('#AddBT', {
		onClick: function() {
			var Detail = SelCleanFailGrid.getSelectedData();
			if (isEmpty(Detail)) {
				$UI.msg('alert', '请选择要添加的数据!');
				return;
			}
			var row = $('#MainList').datagrid('getSelected');
			if (isEmpty(row)) {
				$UI.msg('alert', '请选择需要添加的清洗单据!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.Clean.CleanFailItem',
				MethodName: 'jsSaveSter',
				MainId: row.RowId,
				Params: JSON.stringify(Detail)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					$('#CleanFailedItmWin').window('close');
					gFn(row.RowId);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	var SelCleanFailCm = [[
		{
			title: '',
			field: 'ck',
			checkbox: true,
			width: 50
		}, {
			title: '消毒包DR',
			field: 'PkgId',
			width: 50,
			hidden: true
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 150
		}, {
			title: '标牌',
			field: 'CodeDictId',
			width: 150
		}, {
			title: '器械Id',
			field: 'ItmId',
			width: 50,
			hidden: true
		}, {
			title: '器械',
			field: 'ItmDesc',
			width: 150
		}, {
			title: '数量',
			field: 'PkgNum',
			width: 50
		}, {
			title: '器械规格',
			field: 'ItmSpec',
			width: 120
		}, {
			title: '清洗不合格批次',
			field: 'CleanNum',
			width: 140
		}, {
			title: '不合格原因Dr',
			field: 'ReasonId',
			width: 50,
			hidden: true
		}, {
			title: '不合格原因',
			field: 'UnPassReasonDesc',
			width: 100
		}, {
			title: '包属性',
			field: 'AttributeIdDesc',
			width: 100
		}, {
			title: '清洗明细ID',
			field: 'CleanDetailId',
			width: 100,
			hidden: true
		}, {
			title: '消毒包数量',
			field: 'PkgMainQty',
			width: 100,
			hidden: true
		}
	]];
	
	var SelCleanFailGrid = $UI.datagrid('#SelCleanFailGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanFailItem',
			QueryName: 'GetCleanFailPackage'
		},
		columns: SelCleanFailCm,
		singleSelect: false,
		pagination: false
	});
	$HUI.dialog('#CleanFailedItmWin', {
		onOpen: function() {
			SelReqQuery();
		}
	});
};
$(initCleanFailedItm);